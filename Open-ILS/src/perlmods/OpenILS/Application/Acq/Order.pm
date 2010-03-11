package OpenILS::Application::Acq::BatchManager;
use OpenILS::Application::Acq::Financials;
use OpenSRF::AppSession;
use OpenSRF::EX qw/:try/;
use strict; use warnings;

sub new {
    my($class, %args) = @_;
    my $self = bless(\%args, $class);
    $self->{args} = {
        lid => 0,
        li => 0,
        copies => 0,
        bibs => 0,
        progress => 0,
        debits_accrued => 0,
        purchase_order => undef,
        picklist => undef,
        complete => 0,
        indexed => 0,
        total => 0
    };
    $self->{ingest_queue} = [];
    $self->{cache} = {};
    $self->throttle(5) unless $self->throttle;
    $self->{post_proc_queue} = [];
    $self->{last_respond_progress} = 0;
    return $self;
}

sub conn {
    my($self, $val) = @_;
    $self->{conn} = $val if $val;
    return $self->{conn};
}
sub throttle {
    my($self, $val) = @_;
    $self->{throttle} = $val if $val;
    return $self->{throttle};
}
sub respond {
    my($self, %other_args) = @_;
    if($self->throttle and not %other_args) {
        return unless (
            ($self->{args}->{progress} - $self->{last_respond_progress}) >= $self->throttle
        );
    }
    $self->conn->respond({ %{$self->{args}}, %other_args });
    $self->{last_respond_progress} = $self->{args}->{progress};
}
sub respond_complete {
    my($self, %other_args) = @_;
    $self->complete;
    $self->conn->respond_complete({ %{$self->{args}}, %other_args });
    $self->run_post_response_hooks;
    return undef;
}

# run the post response hook subs, shifting them off as we go
sub run_post_response_hooks {
    my($self) = @_;
    (shift @{$self->{post_proc_queue}})->() while @{$self->{post_proc_queue}};
}

# any subs passed to this method will be run after the call to respond_complete
sub post_process {
    my($self, $sub) = @_;
    push(@{$self->{post_proc_queue}}, $sub);
}

sub total {
    my($self, $val) = @_;
    $self->{args}->{total} = $val if defined $val;
    $self->{args}->{maximum} = $self->{args}->{total};
    return $self->{args}->{total};
}
sub purchase_order {
    my($self, $val) = @_;
    $self->{args}->{purchase_order} = $val if $val;
    return $self;
}
sub picklist {
    my($self, $val) = @_;
    $self->{args}->{picklist} = $val if $val;
    return $self;
}
sub add_lid {
    my $self = shift;
    $self->{args}->{lid} += 1;
    $self->{args}->{progress} += 1;
    return $self;
}
sub add_li {
    my $self = shift;
    $self->{args}->{li} += 1;
    $self->{args}->{progress} += 1;
    return $self;
}
sub add_copy {
    my $self = shift;
    $self->{args}->{copies} += 1;
    $self->{args}->{progress} += 1;
    return $self;
}
sub add_bib {
    my $self = shift;
    $self->{args}->{bibs} += 1;
    $self->{args}->{progress} += 1;
    return $self;
}
sub add_debit {
    my($self, $amount) = @_;
    $self->{args}->{debits_accrued} += $amount;
    $self->{args}->{progress} += 1;
    return $self;
}
sub editor {
    my($self, $editor) = @_;
    $self->{editor} = $editor if defined $editor;
    return $self->{editor};
}
sub complete {
    my $self = shift;
    $self->{args}->{complete} = 1;
    return $self;
}

sub ingest_ses {
    my($self, $val) = @_;
    $self->{ingest_ses} = $val if $val;
    return $self->{ingest_ses};
}

sub push_ingest_queue {
    my($self, $rec_id) = @_;

    $self->ingest_ses(OpenSRF::AppSession->connect('open-ils.ingest'))
        unless $self->ingest_ses;

    my $req = $self->ingest_ses->request('open-ils.ingest.full.biblio.record', $rec_id);

    push(@{$self->{ingest_queue}}, $req);
}

sub process_ingest_records {
    my $self = shift;
    return unless @{$self->{ingest_queue}};

    for my $req (@{$self->{ingest_queue}}) {

        try { 
            $req->gather(1); 
            $self->{args}->{indexed} += 1;
            $self->{args}->{progress} += 1;
        } otherwise {};

        $self->respond;
    }
    $self->ingest_ses->disconnect;
}


sub cache {
    my($self, $org, $key, $val) = @_;
    $self->{cache}->{$org} = {} unless $self->{cache}->{org};
    $self->{cache}->{$org}->{$key} = $val if defined $val;
    return $self->{cache}->{$org}->{$key};
}


package OpenILS::Application::Acq::Order;
use base qw/OpenILS::Application/;
use strict; use warnings;
# ----------------------------------------------------------------------------
# Break up each component of the order process and pieces into managable
# actions that can be shared across different workflows
# ----------------------------------------------------------------------------
use OpenILS::Event;
use OpenSRF::Utils::Logger qw(:logger);
use OpenSRF::Utils::JSON;
use OpenSRF::AppSession;
use OpenILS::Utils::Fieldmapper;
use OpenILS::Utils::CStoreEditor q/:funcs/;
use OpenILS::Const qw/:const/;
use OpenSRF::EX q/:try/;
use OpenILS::Application::AppUtils;
use OpenILS::Application::Cat::BibCommon;
use OpenILS::Application::Cat::AssetCommon;
use MARC::Record;
use MARC::Batch;
use MARC::File::XML;
my $U = 'OpenILS::Application::AppUtils';


# ----------------------------------------------------------------------------
# Lineitem
# ----------------------------------------------------------------------------
sub create_lineitem {
    my($mgr, %args) = @_;
    my $li = Fieldmapper::acq::lineitem->new;
    $li->creator($mgr->editor->requestor->id);
    $li->selector($li->creator);
    $li->editor($li->creator);
    $li->create_time('now');
    $li->edit_time('now');
    $li->state('new');
    $li->$_($args{$_}) for keys %args;
    $li->clear_id;
    $mgr->add_li;
    $mgr->editor->create_acq_lineitem($li) or return 0;
    
    unless($li->estimated_unit_price) {
        # extract the price from the MARC data
        my $price = get_li_price_from_attrs($li) or return $li;
        $li->estimated_unit_price($price);
        return update_lineitem($mgr, $li);
    }

    return $li;
}

sub get_li_price_from_attr {
    my($e, $li) = @_;
    my $attrs = $li->attributes || $e->search_acq_lineitem_attr({lineitem => $li->id});

    for my $attr_type (qw/    
            lineitem_local_attr_definition 
            lineitem_prov_attr_definition 
            lineitem_marc_attr_definition/) {

        my ($attr) = grep {
            $_->attr_name eq 'estimated_price' and 
            $_->attr_type eq $attr_type } @$attrs;

        return $attr->attr_value if $attr;
    }

    return undef;
}


sub update_lineitem {
    my($mgr, $li) = @_;
    $li->edit_time('now');
    $li->editor($mgr->editor->requestor->id);
    $mgr->add_li;
    return $mgr->editor->retrieve_acq_lineitem($mgr->editor->data) if
        $mgr->editor->update_acq_lineitem($li);
    return undef;
}


# ----------------------------------------------------------------------------
# Create real holds from patron requests for a given lineitem
# ----------------------------------------------------------------------------
sub promote_lineitem_holds {
    my($mgr, $li) = @_;

    my $requests = $mgr->editor->search_acq_user_request(
        { lineitem => $li->id,
          '-or' =>
            [ { need_before => {'>' => 'now'} },
              { need_before => undef }
            ]
        }
    );

    for my $request ( @$requests ) {

        $request->eg_bib( $li->eg_bib_id );
        $mgr->editor->update_acq_user_request( $request ) or return 0;

        next unless ($U->is_true( $request->hold ));

        my $hold = Fieldmapper::action::hold_request->new;
        $hold->usr( $request->usr );
        $hold->requestor( $request->usr );
        $hold->request_time( $request->request_date );
        $hold->pickup_lib( $request->pickup_lib );
        $hold->request_lib( $request->pickup_lib );
        $hold->selection_ou( $request->pickup_lib );
        $hold->phone_notify( $request->phone_notify );
        $hold->email_notify( $request->email_notify );
        $hold->expire_time( $request->need_before );

        if ($request->holdable_formats) {
            my $mrm = $mgr->editor->search_metabib_metarecord_source_map( { source => $li->eg_bib_id } )->[0];
            if ($mrm) {
                $hold->hold_type( 'M' );
                $hold->holdable_formats( $request->holdable_formats );
                $hold->target( $mrm->metarecord );
            }
        }

        if (!$hold->target) {
            $hold->hold_type( 'T' );
            $hold->target( $li->eg_bib_id );
        }

        $mgr->editor->create_actor_hold_request( $hold ) or return 0;
    }

    return $li;
}

sub delete_lineitem {
    my($mgr, $li) = @_;
    $li = $mgr->editor->retrieve_acq_lineitem($li) unless ref $li;

    # delete the attached lineitem_details
    my $lid_ids = $mgr->editor->search_acq_lineitem_detail({lineitem => $li->id}, {idlist=>1});
    for my $lid_id (@$lid_ids) {
        return 0 unless delete_lineitem_detail($mgr, $lid_id);
    }

    $mgr->add_li;
    return $mgr->editor->delete_acq_lineitem($li);
}

# begins and commit transactions as it goes
sub create_lineitem_list_assets {
    my($mgr, $li_ids) = @_;
    return undef if check_import_li_marc_perms($mgr, $li_ids);

    # create the bibs/volumes/copies and ingest the records
    for my $li_id (@$li_ids) {
        $mgr->editor->xact_begin;
        my $data = create_lineitem_assets($mgr, $li_id) or return undef;
        $mgr->editor->xact_commit;
        # XXX ingest is in-db now
        #$mgr->push_ingest_queue($data->{li}->eg_bib_id) if $data->{new_bib};
        $mgr->respond;
    }
    $mgr->process_ingest_records;
    return 1;
}

# returns event on error, undef on success
sub check_import_li_marc_perms {
    my($mgr, $li_ids) = @_;

    # if there are any order records that are not linked to 
    # in-db bib records, verify staff has perms to import order records
    my $order_li = $mgr->editor->search_acq_lineitem(
        [{id => $li_ids, eg_bib_id => undef}, {limit => 1}], {idlist => 1})->[0];

    if($order_li) {
        return $mgr->editor->die_event unless 
            $mgr->editor->allowed('IMPORT_ACQ_LINEITEM_BIB_RECORD');
    }

    return undef;
}


# ----------------------------------------------------------------------------
# if all of the lineitem details for this lineitem have 
# been received, mark the lineitem as received
# returns 1 on non-received, li on received, 0 on error
# ----------------------------------------------------------------------------

sub describe_affected_po {
    my ($e, $po) = @_;

    my ($enc, $spent) =
        OpenILS::Application::Acq::Financials::build_price_summary(
            $e, $po->id
        );

    +{$po->id => {
            "state" => $po->state,
            "amount_encumbered" => $enc,
            "amount_spent" => $spent
        }
    };
}

sub check_lineitem_received {
    my($mgr, $li_id) = @_;

    my $non_recv = $mgr->editor->search_acq_lineitem_detail(
        {recv_time => undef, lineitem => $li_id}, {idlist=>1});

    return 1 if @$non_recv;

    my $li = $mgr->editor->retrieve_acq_lineitem($li_id);
    $li->state('received');
    return update_lineitem($mgr, $li);
}

sub receive_lineitem {
    my($mgr, $li_id, $skip_complete_check) = @_;
    my $li = $mgr->editor->retrieve_acq_lineitem($li_id) or return 0;

    my $lid_ids = $mgr->editor->search_acq_lineitem_detail(
        {lineitem => $li_id, recv_time => undef}, {idlist => 1});

    for my $lid_id (@$lid_ids) {
       receive_lineitem_detail($mgr, $lid_id, 1) or return 0; 
    }

    $mgr->add_li;
    $li->state('received');

    $li = update_lineitem($mgr, $li) or return 0;
    $mgr->post_process( sub { create_lineitem_status_events($mgr, $li_id, 'aur.received'); });

    my $po;
    return 0 unless
        $skip_complete_check or (
            $po = check_purchase_order_received($mgr, $li->purchase_order)
        );

    my $result = {"li" => {$li->id => {"state" => $li->state}}};
    $result->{"po"} = describe_affected_po($mgr->editor, $po) if ref $po;
    return $result;
}

sub rollback_receive_lineitem {
    my($mgr, $li_id) = @_;
    my $li = $mgr->editor->retrieve_acq_lineitem($li_id) or return 0;

    my $lid_ids = $mgr->editor->search_acq_lineitem_detail(
        {lineitem => $li_id, recv_time => {'!=' => undef}}, {idlist => 1});

    for my $lid_id (@$lid_ids) {
       rollback_receive_lineitem_detail($mgr, $lid_id, 1) or return 0; 
    }

    $mgr->add_li;
    $li->state('on-order');
    return update_lineitem($mgr, $li);
}


sub create_lineitem_status_events {
    my($mgr, $li_id, $hook) = @_;

    my $ses = OpenSRF::AppSession->create('open-ils.trigger');
    $ses->connect;
    my $user_reqs = $mgr->editor->search_acq_user_request([
        {lineitem => $li_id}, 
        {flesh => 1, flesh_fields => {aur => ['usr']}}
    ]);

    for my $user_req (@$user_reqs) {
        my $req = $ses->request('open-ils.trigger.event.autocreate', $hook, $user_req, $user_req->usr->home_ou);
        $req->recv; 
    }

    $ses->disconnect;
    return undef;
}

# ----------------------------------------------------------------------------
# Lineitem Detail
# ----------------------------------------------------------------------------
sub create_lineitem_detail {
    my($mgr, %args) = @_;
    my $lid = Fieldmapper::acq::lineitem_detail->new;
    $lid->$_($args{$_}) for keys %args;
    $lid->clear_id;
    $mgr->add_lid;
    return $mgr->editor->create_acq_lineitem_detail($lid);
}


# flesh out any required data with default values where appropriate
sub complete_lineitem_detail {
    my($mgr, $lid) = @_;
    unless($lid->barcode) {
        my $pfx = $U->ou_ancestor_setting_value($lid->owning_lib, 'acq.tmp_barcode_prefix') || 'ACQ';
        $lid->barcode($pfx.$lid->id);
    }

    unless($lid->cn_label) {
        my $pfx = $U->ou_ancestor_setting_value($lid->owning_lib, 'acq.tmp_callnumber_prefix') || 'ACQ';
        $lid->cn_label($pfx.$lid->id);
    }

    if(!$lid->location and my $loc = $U->ou_ancestor_setting_value($lid->owning_lib, 'acq.default_copy_location')) {
        $lid->location($loc);
    }

    if(!$lid->circ_modifier and my $mod = get_default_circ_modifier($mgr, $lid->owning_lib)) {
        $lid->circ_modifier($mod);
    }

    $mgr->editor->update_acq_lineitem_detail($lid) or return 0;
    return $lid;
}

sub get_default_circ_modifier {
    my($mgr, $org) = @_;
    my $mod = $mgr->cache($org, 'def_circ_mod');
    return $mod if $mod;
    $mod = $U->ou_ancestor_setting_value($org, 'acq.default_circ_modifier');
    return $mgr->cache($org, 'def_circ_mod', $mod) if $mod;
    return undef;
}

sub delete_lineitem_detail {
    my($mgr, $lid) = @_;
    $lid = $mgr->editor->retrieve_acq_lineitem_detail($lid) unless ref $lid;
    return $mgr->editor->delete_acq_lineitem_detail($lid);
}


sub receive_lineitem_detail {
    my($mgr, $lid_id, $skip_complete_check) = @_;
    my $e = $mgr->editor;

    my $lid = $e->retrieve_acq_lineitem_detail([
        $lid_id,
        {   flesh => 1,
            flesh_fields => {
                acqlid => ['fund_debit']
            }
        }
    ]) or return 0;

    return 1 if $lid->recv_time;

    $lid->recv_time('now');
    $e->update_acq_lineitem_detail($lid) or return 0;

    my $copy = $e->retrieve_asset_copy($lid->eg_copy_id) or return 0;
    $copy->status(OILS_COPY_STATUS_IN_PROCESS);
    $copy->edit_date('now');
    $copy->editor($e->requestor->id);
    $e->update_asset_copy($copy) or return 0;

    $mgr->add_lid;

    return 1 if $skip_complete_check;

    my $li = check_lineitem_received($mgr, $lid->lineitem) or return 0;
    return 1 if $li == 1; # li not received

    return check_purchase_order_received($mgr, $li->purchase_order) or return 0;
}


sub rollback_receive_lineitem_detail {
    my($mgr, $lid_id) = @_;
    my $e = $mgr->editor;

    my $lid = $e->retrieve_acq_lineitem_detail([
        $lid_id,
        {   flesh => 1,
            flesh_fields => {
                acqlid => ['fund_debit']
            }
        }
    ]) or return 0;

    return 1 unless $lid->recv_time;

    $lid->clear_recv_time;
    $e->update_acq_lineitem_detail($lid) or return 0;

    my $copy = $e->retrieve_asset_copy($lid->eg_copy_id) or return 0;
    $copy->status(OILS_COPY_STATUS_ON_ORDER);
    $copy->edit_date('now');
    $copy->editor($e->requestor->id);
    $e->update_asset_copy($copy) or return 0;

    $mgr->add_lid;
    return $lid;
}

# ----------------------------------------------------------------------------
# Lineitem Attr
# ----------------------------------------------------------------------------
sub set_lineitem_attr {
    my($mgr, %args) = @_;
    my $attr_type = $args{attr_type};

    # first, see if it's already set.  May just need to overwrite it
    my $attr = $mgr->editor->search_acq_lineitem_attr({
        lineitem => $args{lineitem},
        attr_type => $args{attr_type},
        attr_name => $args{attr_name}
    })->[0];

    if($attr) {
        $attr->attr_value($args{attr_value});
        return $attr if $mgr->editor->update_acq_lineitem_attr($attr);
        return undef;

    } else {

        $attr = Fieldmapper::acq::lineitem_attr->new;
        $attr->$_($args{$_}) for keys %args;
        
        unless($attr->definition) {
            my $find = "search_acq_$attr_type";
            my $attr_def_id = $mgr->editor->$find({code => $attr->attr_name}, {idlist=>1})->[0] or return 0;
            $attr->definition($attr_def_id);
        }
        return $mgr->editor->create_acq_lineitem_attr($attr);
    }
}

# ----------------------------------------------------------------------------
# Lineitem Debits
# ----------------------------------------------------------------------------
sub create_lineitem_debits {
    my($mgr, $li) = @_; 

    unless($li->estimated_unit_price) {
        $mgr->editor->event(OpenILS::Event->new('ACQ_LINEITEM_NO_PRICE', payload => $li->id));
        $mgr->editor->rollback;
        return 0;
    }

    unless($li->provider) {
        $mgr->editor->event(OpenILS::Event->new('ACQ_LINEITEM_NO_PROVIDER', payload => $li->id));
        $mgr->editor->rollback;
        return 0;
    }

    my $lid_ids = $mgr->editor->search_acq_lineitem_detail(
        {lineitem => $li->id}, 
        {idlist=>1}
    );

    for my $lid_id (@$lid_ids) {

        my $lid = $mgr->editor->retrieve_acq_lineitem_detail([
            $lid_id,
            {   flesh => 1, 
                flesh_fields => {acqlid => ['fund']}
            }
        ]);

        create_lineitem_detail_debit($mgr, $li, $lid) or return 0;
    }

    return 1;
}


# flesh li->provider
# flesh lid->fund
sub create_lineitem_detail_debit {
    my($mgr, $li, $lid) = @_;

    my $li_id = ref($li) ? $li->id : $li;

    unless(ref $li and ref $li->provider) {
       $li = $mgr->editor->retrieve_acq_lineitem([
            $li_id,
            {   flesh => 1,
                flesh_fields => {jub => ['provider']},
            }
        ]);
    }

    unless(ref $lid and ref $lid->fund) {
        $lid = $mgr->editor->retrieve_acq_lineitem_detail([
            $lid,
            {   flesh => 1, 
                flesh_fields => {acqlid => ['fund']}
            }
        ]);
    }

    my $amount = $li->estimated_unit_price;
    if($li->provider->currency_type ne $lid->fund->currency_type) {

        # At Fund debit creation time, translate into the currency of the fund
        # TODO: org setting to disable automatic currency conversion at debit create time?

        $amount = $mgr->editor->json_query({
            from => [
                'acq.exchange_ratio', 
                $li->provider->currency_type, # source currency
                $lid->fund->currency_type, # destination currency
                $li->estimated_unit_price # source amount
            ]
        })->[0]->{value};
    }

    my $debit = create_fund_debit(
        $mgr, 
        fund => $lid->fund->id,
        origin_amount => $li->estimated_unit_price,
        origin_currency_type => $li->provider->currency_type,
        amount => $amount
    ) or return 0;

    $lid->fund_debit($debit->id);
    $lid->fund($lid->fund->id);
    $mgr->editor->update_acq_lineitem_detail($lid) or return 0;
    return $debit;
}


# ----------------------------------------------------------------------------
# Fund Debit
# ----------------------------------------------------------------------------
sub create_fund_debit {
    my($mgr, %args) = @_;

    # Verify the fund is not being spent beyond the hard stop amount
    my $fund = $mgr->editor->retrieve_acq_fund($args{fund}) or return 0;

    if($fund->balance_stop_percent) {

        my $balance = $mgr->editor->search_acq_fund_combined_balance({fund => $fund->id})->[0];
        my $allocations = $mgr->editor->search_acq_fund_allocation_total({fund => $fund->id})->[0];
        $balance = ($balance) ? $balance->amount : 0;
        $allocations = ($allocations) ? $allocations->amount : 0;

        if( 
            $allocations == 0 || # if no allocations were ever made, assume we have hit the stop percent
            ( ( ( ($balance - $args{amount}) / $allocations ) * 100 ) < $fund->balance_stop_percent)) 
        {
                $mgr->editor->event(OpenILS::Event->new(
                    'FUND_EXCEEDS_STOP_PERCENT', 
                    payload => {fund => $fund->id, debit_amount => $args{amount}}
                ));
                return 0;
        }
    }

    my $debit = Fieldmapper::acq::fund_debit->new;
    $debit->debit_type('purchase');
    $debit->encumbrance('t');
    $debit->$_($args{$_}) for keys %args;
    $debit->clear_id;
    $mgr->add_debit($debit->amount);
    return $mgr->editor->create_acq_fund_debit($debit);
}


# ----------------------------------------------------------------------------
# Picklist
# ----------------------------------------------------------------------------
sub create_picklist {
    my($mgr, %args) = @_;
    my $picklist = Fieldmapper::acq::picklist->new;
    $picklist->creator($mgr->editor->requestor->id);
    $picklist->owner($picklist->creator);
    $picklist->editor($picklist->creator);
    $picklist->create_time('now');
    $picklist->edit_time('now');
    $picklist->org_unit($mgr->editor->requestor->ws_ou);
    $picklist->owner($mgr->editor->requestor->id);
    $picklist->$_($args{$_}) for keys %args;
    $picklist->clear_id;
    $mgr->picklist($picklist);
    return $mgr->editor->create_acq_picklist($picklist);
}

sub update_picklist {
    my($mgr, $picklist) = @_;
    $picklist = $mgr->editor->retrieve_acq_picklist($picklist) unless ref $picklist;
    $picklist->edit_time('now');
    $picklist->editor($mgr->editor->requestor->id);
    $mgr->picklist($picklist);
    return $picklist if $mgr->editor->update_acq_picklist($picklist);
    return undef;
}

sub delete_picklist {
    my($mgr, $picklist) = @_;
    $picklist = $mgr->editor->retrieve_acq_picklist($picklist) unless ref $picklist;

    # delete all 'new' lineitems
    my $li_ids = $mgr->editor->search_acq_lineitem({picklist => $picklist->id, state => 'new'}, {idlist => 1});
    for my $li_id (@$li_ids) {
        my $li = $mgr->editor->retrieve_acq_lineitem($li_id);
        return 0 unless delete_lineitem($mgr, $li);
        $mgr->respond;
    }

    # detach all non-'new' lineitems
    $li_ids = $mgr->editor->search_acq_lineitem({picklist => $picklist->id, state => {'!=' => 'new'}}, {idlist => 1});
    for my $li_id (@$li_ids) {
        my $li = $mgr->editor->retrieve_acq_lineitem($li_id);
        $li->clear_picklist;
        return 0 unless update_lineitem($mgr, $li);
        $mgr->respond;
    }

    # remove any picklist-specific object perms
    my $ops = $mgr->editor->search_permission_usr_object_perm_map({object_type => 'acqpl', object_id => ''.$picklist->id});
    for my $op (@$ops) {
        return 0 unless $mgr->editor->delete_usr_object_perm_map($op);
    }

    return $mgr->editor->delete_acq_picklist($picklist);
}

# ----------------------------------------------------------------------------
# Purchase Order
# ----------------------------------------------------------------------------
sub update_purchase_order {
    my($mgr, $po) = @_;
    $po = $mgr->editor->retrieve_acq_purchase_order($po) unless ref $po;
    $po->editor($mgr->editor->requestor->id);
    $po->edit_time('now');
    $mgr->purchase_order($po);
    return $mgr->editor->retrieve_acq_purchase_order($mgr->editor->data)
        if $mgr->editor->update_acq_purchase_order($po);
    return undef;
}

sub create_purchase_order {
    my($mgr, %args) = @_;

    # verify the chosen provider is still active
    my $provider = $mgr->editor->retrieve_acq_provider($args{provider}) or return 0;
    unless($U->is_true($provider->active)) {
        $logger->error("provider is not active.  cannot create PO");
        $mgr->editor->event(OpenILS::Event->new('ACQ_PROVIDER_INACTIVE'));
        return 0;
    }

    my $po = Fieldmapper::acq::purchase_order->new;
    $po->creator($mgr->editor->requestor->id);
    $po->editor($mgr->editor->requestor->id);
    $po->owner($mgr->editor->requestor->id);
    $po->edit_time('now');
    $po->create_time('now');
    $po->state('pending');
    $po->ordering_agency($mgr->editor->requestor->ws_ou);
    $po->$_($args{$_}) for keys %args;
    $po->clear_id;
    $mgr->purchase_order($po);
    return $mgr->editor->create_acq_purchase_order($po);
}

# ----------------------------------------------------------------------------
# if all of the lineitems for this PO are received,
# mark the PO as received
# ----------------------------------------------------------------------------
sub check_purchase_order_received {
    my($mgr, $po_id) = @_;

    my $non_recv_li = $mgr->editor->search_acq_lineitem(
        {   purchase_order => $po_id,
            state => {'!=' => 'received'}
        }, {idlist=>1});

    my $po = $mgr->editor->retrieve_acq_purchase_order($po_id);
    return $po if @$non_recv_li;

    $po->state('received');
    return update_purchase_order($mgr, $po);
}


# ----------------------------------------------------------------------------
# Bib, Callnumber, and Copy data
# ----------------------------------------------------------------------------

sub create_lineitem_assets {
    my($mgr, $li_id) = @_;
    my $evt;

    my $li = $mgr->editor->retrieve_acq_lineitem([
        $li_id,
        {   flesh => 1,
            flesh_fields => {jub => ['purchase_order', 'attributes']}
        }
    ]) or return 0;

    # -----------------------------------------------------------------
    # first, create the bib record if necessary
    # -----------------------------------------------------------------
    my $new_bib = 0;
    unless($li->eg_bib_id) {
        create_bib($mgr, $li) or return 0;
        $new_bib = 1;
    }


    # -----------------------------------------------------------------
    # The lineitem is going live, promote user request holds to real holds
    # -----------------------------------------------------------------
    promote_lineitem_holds($mgr, $li) or return 0;

    my $li_details = $mgr->editor->search_acq_lineitem_detail({lineitem => $li_id}, {idlist=>1});

    # -----------------------------------------------------------------
    # for each lineitem_detail, create the volume if necessary, create 
    # a copy, and link them all together.
    # -----------------------------------------------------------------
    my $first_cn;
    for my $lid_id (@{$li_details}) {

        my $lid = $mgr->editor->retrieve_acq_lineitem_detail($lid_id) or return 0;
        next if $lid->eg_copy_id;

        # use the same callnumber label for all items within this lineitem
        $lid->cn_label($first_cn) if $first_cn and not $lid->cn_label;

        # apply defaults if necessary
        return 0 unless complete_lineitem_detail($mgr, $lid);

        $first_cn = $lid->cn_label unless $first_cn;

        my $org = $lid->owning_lib;
        my $label = $lid->cn_label;
        my $bibid = $li->eg_bib_id;

        my $volume = $mgr->cache($org, "cn.$bibid.$label");
        unless($volume) {
            $volume = create_volume($mgr, $li, $lid) or return 0;
            $mgr->cache($org, "cn.$bibid.$label", $volume);
        }
        create_copy($mgr, $volume, $lid) or return 0;
    }

    return { li => $li, new_bib => $new_bib };
}

sub create_bib {
    my($mgr, $li) = @_;

    my $record = OpenILS::Application::Cat::BibCommon->biblio_record_xml_import(
        $mgr->editor, 
        $li->marc, 
        undef, # bib source
        undef, 
        1, # override tcn collisions
    ); 

    if($U->event_code($record)) {
        $mgr->editor->event($record);
        $mgr->editor->rollback;
        return 0;
    }

    $li->eg_bib_id($record->id);
    $mgr->add_bib;
    return update_lineitem($mgr, $li);
}

sub create_volume {
    my($mgr, $li, $lid) = @_;

    my ($volume, $evt) = 
        OpenILS::Application::Cat::AssetCommon->find_or_create_volume(
            $mgr->editor, 
            $lid->cn_label, 
            $li->eg_bib_id, 
            $lid->owning_lib
        );

    if($evt) {
        $mgr->editor->event($evt);
        return 0;
    }

    return $volume;
}

sub create_copy {
    my($mgr, $volume, $lid) = @_;
    my $copy = Fieldmapper::asset::copy->new;
    $copy->isnew(1);
    $copy->loan_duration(2);
    $copy->fine_level(2);
    $copy->status(OILS_COPY_STATUS_ON_ORDER);
    $copy->barcode($lid->barcode);
    $copy->location($lid->location);
    $copy->call_number($volume->id);
    $copy->circ_lib($volume->owning_lib);
    $copy->circ_modifier($lid->circ_modifier);

    my $evt = OpenILS::Application::Cat::AssetCommon->create_copy($mgr->editor, $volume, $copy);
    if($evt) {
        $mgr->editor->event($evt);
        return 0;
    }

    $mgr->add_copy;
    $lid->eg_copy_id($copy->id);
    $mgr->editor->update_acq_lineitem_detail($lid) or return 0;
}






# ----------------------------------------------------------------------------
# Workflow: Build a selection list from a Z39.50 search
# ----------------------------------------------------------------------------

__PACKAGE__->register_method(
	method => 'zsearch',
	api_name => 'open-ils.acq.picklist.search.z3950',
    stream => 1,
	signature => {
        desc => 'Performs a z3950 federated search and creates a picklist and associated lineitems',
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'Search definition', type => 'object'},
            {desc => 'Picklist name, optional', type => 'string'},
        ]
    }
);

sub zsearch {
    my($self, $conn, $auth, $search, $name, $options) = @_;
    my $e = new_editor(authtoken=>$auth);
    return $e->event unless $e->checkauth;
    return $e->event unless $e->allowed('CREATE_PICKLIST');

    $search->{limit} ||= 10;
    $options ||= {};

    my $ses = OpenSRF::AppSession->create('open-ils.search');
    my $req = $ses->request('open-ils.search.z3950.search_class', $auth, $search);

    my $first = 1;
    my $picklist;
    my $mgr;
    while(my $resp = $req->recv(timeout=>60)) {

        if($first) {
            my $e = new_editor(requestor=>$e->requestor, xact=>1);
            $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);
            $picklist = zsearch_build_pl($mgr, $name);
            $first = 0;
        }

        my $result = $resp->content;
        my $count = $result->{count} || 0;
        $mgr->total( (($count < $search->{limit}) ? $count : $search->{limit})+1 );

        for my $rec (@{$result->{records}}) {

            my $li = create_lineitem($mgr, 
                picklist => $picklist->id,
                source_label => $result->{service},
                marc => $rec->{marcxml},
                eg_bib_id => $rec->{bibid}
            );

            if($$options{respond_li}) {
                $li->attributes($mgr->editor->search_acq_lineitem_attr({lineitem => $li->id}))
                    if $$options{flesh_attrs};
                $li->clear_marc if $$options{clear_marc};
                $mgr->respond(lineitem => $li);
            } else {
                $mgr->respond;
            }
        }
    }

    $mgr->editor->commit;
    return $mgr->respond_complete;
}

sub zsearch_build_pl {
    my($mgr, $name) = @_;
    $name ||= '';

    my $picklist = $mgr->editor->search_acq_picklist({
        owner => $mgr->editor->requestor->id, 
        name => $name
    })->[0];

    if($name eq '' and $picklist) {
        return 0 unless delete_picklist($mgr, $picklist);
        $picklist = undef;
    }

    return update_picklist($mgr, $picklist) if $picklist;
    return create_picklist($mgr, name => $name);
}


# ----------------------------------------------------------------------------
# Workflow: Build a selection list / PO by importing a batch of MARC records
# ----------------------------------------------------------------------------

__PACKAGE__->register_method(
    method => 'upload_records',
    api_name => 'open-ils.acq.process_upload_records',
    stream => 1,
);

sub upload_records {
    my($self, $conn, $auth, $key) = @_;

	my $e = new_editor(authtoken => $auth, xact => 1);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    my $cache = OpenSRF::Utils::Cache->new;

    my $data = $cache->get_cache("vandelay_import_spool_$key");
	my $purpose = $data->{purpose};
    my $filename = $data->{path};
    my $provider = $data->{provider};
    my $picklist = $data->{picklist};
    my $create_po = $data->{create_po};
    my $activate_po = $data->{activate_po};
    my $ordering_agency = $data->{ordering_agency};
    my $create_assets = $data->{create_assets};
    my $po;
    my $evt;

    unless(-r $filename) {
        $logger->error("unable to read MARC file $filename");
        $e->rollback;
        return OpenILS::Event->new('FILE_UPLOAD_ERROR', payload => {filename => $filename});
    }

    $provider = $e->retrieve_acq_provider($provider) or return $e->die_event;

    if($picklist) {
        $picklist = $e->retrieve_acq_picklist($picklist) or return $e->die_event;
        if($picklist->owner != $e->requestor->id) {
            return $e->die_event unless 
                $e->allowed('CREATE_PICKLIST', $picklist->org_unit, $picklist);
        }
        $mgr->picklist($picklist);
    }

    if($create_po) {

        $po = create_purchase_order($mgr, 
            ordering_agency => $ordering_agency,
            provider => $provider->id,
            state => 'on-order'
        ) or return $mgr->editor->die_event;
    }

    $logger->info("acq processing MARC file=$filename");

    my $marctype = 'USMARC'; # ?
	my $batch = new MARC::Batch ($marctype, $filename);
	$batch->strict_off;

	my $count = 0;
    my @li_list;

	while(1) {

	    my $err;
        my $xml;
		$count++;
        my $r;

		try {
            $r = $batch->next;
        } catch Error with {
            $err = shift;
			$logger->warn("Proccessing of record $count in set $key failed with error $err.  Skipping this record");
        };

        next if $err;
        last unless $r;

		try {
            ($xml = $r->as_xml_record()) =~ s/\n//sog;
            $xml =~ s/^<\?xml.+\?\s*>//go;
            $xml =~ s/>\s+</></go;
            $xml =~ s/\p{Cc}//go;
            $xml = $U->entityize($xml);
            $xml =~ s/[\x00-\x1f]//go;

		} catch Error with {
			$err = shift;
			$logger->warn("Proccessing XML of record $count in set $key failed with error $err.  Skipping this record");
		};

        next if $err or not $xml;

        my %args = (
            source_label => $provider->code,
            provider => $provider->id,
            marc => $xml,
        );

        $args{picklist} = $picklist->id if $picklist;
        if($po) {
            $args{purchase_order} = $po->id;
            $args{state} = 'order-pending';
        }

        my $li = create_lineitem($mgr, %args) or return $mgr->editor->die_event;
        $mgr->respond;
        $li->provider($provider); # flesh it, we'll need it later

        import_lineitem_details($mgr, $ordering_agency, $li) or return $mgr->editor->die_event;
        $mgr->respond;

        push(@li_list, $li->id);
        $mgr->respond;
	}

    my $die_event = activate_purchase_order_impl($mgr, $po->id) if $po;;
    return $die_event if $die_event;

	$e->commit;
    unlink($filename);
    $cache->delete_cache('vandelay_import_spool_' . $key);

    if($create_assets) {
        create_lineitem_list_assets($mgr, \@li_list) or return $e->die_event;
    }

    return $mgr->respond_complete;
}

sub import_lineitem_details {
    my($mgr, $ordering_agency, $li) = @_;

    my $holdings = $mgr->editor->json_query({from => ['acq.extract_provider_holding_data', $li->id]});
    return 1 unless @$holdings;
    my $org_path = $U->get_org_ancestors($ordering_agency);
    $org_path = [ reverse (@$org_path) ];
    my $price;

    my $idx = 1;
    while(1) {
        # create a lineitem detail for each copy in the data

        my $compiled = extract_lineitem_detail_data($mgr, $org_path, $holdings, $idx);
        last unless defined $compiled;
        return 0 unless $compiled;

        # this takes the price of the last copy and uses it as the lineitem price
        # need to determine if a given record would include different prices for the same item
        $price = $$compiled{price};

        for(1..$$compiled{quantity}) {
            my $lid = create_lineitem_detail($mgr, 
                lineitem => $li->id,
                owning_lib => $$compiled{owning_lib},
                cn_label => $$compiled{call_number},
                fund => $$compiled{fund},
                circ_modifier => $$compiled{circ_modifier},
                note => $$compiled{note},
                location => $$compiled{copy_location},
                collection_code => $$compiled{collection_code}
            ) or return 0;
        }

        $mgr->respond;
        $idx++;
    }

    $li->estimated_unit_price($price);
    update_lineitem($mgr, $li) or return 0;
    return 1;
}

# return hash on success, 0 on error, undef on no more holdings
sub extract_lineitem_detail_data {
    my($mgr, $org_path, $holdings, $index) = @_;

    my @data_list = grep { $_->{holding} eq $index } @$holdings;
    return undef unless @data_list;

    my %compiled = map { $_->{attr} => $_->{data} } @data_list;
    my $base_org = $$org_path[0];

    my $killme = sub {
        my $msg = shift;
        $logger->error("Item import extraction error: $msg");
        $logger->error('Holdings Data: ' . OpenSRF::Utils::JSON->perl2JSON(\%compiled));
        $mgr->editor->rollback;
        $mgr->editor->event(OpenILS::Event->new('ACQ_IMPORT_ERROR', payload => $msg));
        return 0;
    };

    $compiled{quantity} ||= 1;

    # ---------------------------------------------------------------------
    # Fund
    my $code = $compiled{fund_code};
    return $killme->('no fund code provided') unless $code;

    my $fund = $mgr->cache($base_org, "fund.$code");
    unless($fund) {
        # search up the org tree for the most appropriate fund
        for my $org (@$org_path) {
            $fund = $mgr->editor->search_acq_fund(
                {org => $org, code => $code, year => DateTime->now->year}, {idlist => 1})->[0];
            last if $fund;
        }
    }
    return $killme->("no fund with code $code at orgs [@$org_path]") unless $fund;
    $compiled{fund} = $fund;
    $mgr->cache($base_org, "fund.$code", $fund);


    # ---------------------------------------------------------------------
    # Owning lib
    my $sn = $compiled{owning_lib};
    return $killme->('no owning_lib defined') unless $sn;
    my $org_id = 
        $mgr->cache($base_org, "orgsn.$sn") ||
            $mgr->editor->search_actor_org_unit({shortname => $sn}, {idlist => 1})->[0];
    return $killme->("invalid owning_lib defined: $sn") unless $org_id;
    $compiled{owning_lib} = $org_id;
    $mgr->cache($$org_path[0], "orgsn.$sn", $org_id);


    # ---------------------------------------------------------------------
    # Circ Modifier
    my $mod;
    $code = $compiled{circ_modifier};

    if($code) {

        $mod = $mgr->cache($base_org, "mod.$code") ||
            $mgr->editor->retrieve_config_circ_modifier($code);
        return $killme->("invlalid circ_modifier $code") unless $mod;
        $mgr->cache($base_org, "mod.$code", $mod);

    } else {
        # try the default
        $mod = get_default_circ_modifier($mgr, $base_org)
            or return $killme->('no circ_modifier defined');
    }

    $compiled{circ_modifier} = $mod;


    # ---------------------------------------------------------------------
    # Shelving Location
    my $name = $compiled{copy_location};
    if($name) {
        my $loc = $mgr->cache($base_org, "copy_loc.$name");
        unless($loc) {
            for my $org (@$org_path) {
                $loc = $mgr->editor->search_asset_copy_location(
                    {owning_lib => $org, name => $name}, {idlist => 1})->[0];
                last if $loc;
            }
        }
        return $killme->("Invalid copy location $name") unless $loc;
        $compiled{copy_location} = $loc;
        $mgr->cache($base_org, "copy_loc.$name", $loc);
    }

    return \%compiled;
}



# ----------------------------------------------------------------------------
# Workflow: Given an existing purchase order, import/create the bibs, 
# callnumber and copy objects
# ----------------------------------------------------------------------------

__PACKAGE__->register_method(
	method => 'create_po_assets',
	api_name	=> 'open-ils.acq.purchase_order.assets.create',
	signature => {
        desc => q/Creates assets for each lineitem in the purchase order/,
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'The purchase order id', type => 'number'},
        ],
        return => {desc => 'Streams a total versus completed counts object, event on error'}
    }
);

sub create_po_assets {
    my($self, $conn, $auth, $po_id) = @_;

    my $e = new_editor(authtoken=>$auth, xact=>1);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    my $po = $e->retrieve_acq_purchase_order($po_id) or return $e->die_event;

    my $li_ids = $e->search_acq_lineitem({purchase_order => $po_id}, {idlist => 1});

    # it's ugly, but it's fast.  Get the total count of lineitem detail objects to process
    my $lid_total = $e->json_query({
        select => { acqlid => [{aggregate => 1, transform => 'count', column => 'id'}] }, 
        from => {
            acqlid => {
                jub => {
                    fkey => 'lineitem', 
                    field => 'id', 
                    join => {acqpo => {fkey => 'purchase_order', field => 'id'}}
                }
            }
        }, 
        where => {'+acqpo' => {id => $po_id}}
    })->[0]->{id};

    $mgr->total(scalar(@$li_ids) + $lid_total);

    create_lineitem_list_assets($mgr, $li_ids) or return $e->die_event;

    $e->xact_begin;
    update_purchase_order($mgr, $po) or return $e->die_event;
    $e->commit;

    return $mgr->respond_complete;
}



__PACKAGE__->register_method(
	method => 'create_purchase_order_api',
	api_name	=> 'open-ils.acq.purchase_order.create',
	signature => {
        desc => 'Creates a new purchase order',
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'purchase_order to create', type => 'object'}
        ],
        return => {desc => 'The purchase order id, Event on failure'}
    }
);

sub create_purchase_order_api {
    my($self, $conn, $auth, $po, $args) = @_;
    $args ||= {};

    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    return $e->die_event unless $e->allowed('CREATE_PURCHASE_ORDER', $po->ordering_agency);
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    # create the PO
    my %pargs = (ordering_agency => $e->requestor->ws_ou); # default
    $pargs{provider} = $po->provider if $po->provider;
    $pargs{ordering_agency} = $po->ordering_agency if $po->ordering_agency;
    $po = create_purchase_order($mgr, %pargs) or return $e->die_event;

    my $li_ids = $$args{lineitems};

    if($li_ids) {

        for my $li_id (@$li_ids) { 

            my $li = $e->retrieve_acq_lineitem([
                $li_id,
                {flesh => 1, flesh_fields => {jub => ['attributes']}}
            ]) or return $e->die_event;

            $li->provider($po->provider);
            $li->purchase_order($po->id);
            $li->state('pending-order');
            update_lineitem($mgr, $li) or return $e->die_event;
            $mgr->respond;
        }
    }

    # commit before starting the asset creation
    $e->xact_commit;

    if($li_ids and $$args{create_assets}) {
        create_lineitem_list_assets($mgr, $li_ids) or return $e->die_event;
    }

    return $mgr->respond_complete;
}


__PACKAGE__->register_method(
	method => 'lineitem_detail_CUD_batch',
	api_name => 'open-ils.acq.lineitem_detail.cud.batch',
    stream => 1,
	signature => {
        desc => q/Creates a new purchase order line item detail.  
            Additionally creates the associated fund_debit/,
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'List of lineitem_details to create', type => 'array'},
        ],
        return => {desc => 'Streaming response of current position in the array'}
    }
);

sub lineitem_detail_CUD_batch {
    my($self, $conn, $auth, $li_details) = @_;

    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    # XXX perms

    $mgr->total(scalar(@$li_details));
    
    my %li_cache;

    for my $lid (@$li_details) {

        my $li = $li_cache{$lid->lineitem} || $e->retrieve_acq_lineitem($lid->lineitem);

        if($lid->isnew) {
            create_lineitem_detail($mgr, %{$lid->to_bare_hash}) or return $e->die_event;

        } elsif($lid->ischanged) {
            $e->update_acq_lineitem_detail($lid) or return $e->die_event;

        } elsif($lid->isdeleted) {
            delete_lineitem_detail($mgr, $lid) or return $e->die_event;
        }

        $mgr->respond(li => $li);
        $li_cache{$lid->lineitem} = $li;
    }

    $e->commit;
    return $mgr->respond_complete;
}


__PACKAGE__->register_method(
	method => 'receive_po_api',
	api_name	=> 'open-ils.acq.purchase_order.receive'
);

sub receive_po_api {
    my($self, $conn, $auth, $po_id) = @_;
    my $e = new_editor(xact => 1, authtoken => $auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    my $po = $e->retrieve_acq_purchase_order($po_id) or return $e->die_event;
    return $e->die_event unless $e->allowed('RECEIVE_PURCHASE_ORDER', $po->ordering_agency);

    my $li_ids = $e->search_acq_lineitem({purchase_order => $po_id}, {idlist => 1});

    for my $li_id (@$li_ids) {
        receive_lineitem($mgr, $li_id) or return $e->die_event;
        $mgr->respond;
    }

    $po->state('received');
    update_purchase_order($mgr, $po) or return $e->die_event;

    $e->commit;
    return $mgr->respond_complete;
}


# At the moment there's a lack of parallelism between the receive and unreceive
# API methods for POs and the API methods for LIs and LIDs.  The methods for
# POs stream back objects as they act, whereas the methods for LIs and LIDs
# atomically return an object that describes only what changed (in LIs and LIDs
# themselves or in the objects to which to LIs and LIDs belong).
#
# The methods for LIs and LIDs work the way they do to faciliate the UI's
# maintaining correct information about the state of these things when a user
# wants to receive or unreceive these objects without refreshing their whole
# display.  The UI feature for receiving and un-receiving a whole PO just
# refreshes the whole display, so this absence of parallelism in the UI is also
# relected in this module.
#
# This could be neatened in the future by making POs receive and unreceive in
# the same way the LIs and LIDs do.

__PACKAGE__->register_method(
	method => 'receive_lineitem_detail_api',
	api_name	=> 'open-ils.acq.lineitem_detail.receive',
	signature => {
        desc => 'Mark a lineitem_detail as received',
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'lineitem detail ID', type => 'number'}
        ],
        return => {desc =>
            "on success, object describing changes to LID and possibly " .
            "to LI and PO; on error, Event"
        }
    }
);

sub receive_lineitem_detail_api {
    my($self, $conn, $auth, $lid_id) = @_;

    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    my $fleshing = {
        "flesh" => 2, "flesh_fields" => {
            "acqlid" => ["lineitem"], "jub" => ["purchase_order"]
        }
    };

    my $lid = $e->retrieve_acq_lineitem_detail([$lid_id, $fleshing]);

    return $e->die_event unless $e->allowed(
        'RECEIVE_PURCHASE_ORDER', $lid->lineitem->purchase_order->ordering_agency);

    # update ...
    my $recvd = receive_lineitem_detail($mgr, $lid_id) or return $e->die_event;

    # .. and re-retrieve
    $lid = $e->retrieve_acq_lineitem_detail([$lid_id, $fleshing]);

    # Now build result data structure.
    my $result = {"lid" => {$lid->id => {"recv_time" => $lid->recv_time}}};

    if (ref $recvd) {
        if ($recvd->class_name =~ /::purchase_order/) {
            $result->{"po"} = describe_affected_po($e, $recvd);
            $result->{"li"} = {
                $lid->lineitem->id => {"state" => $lid->lineitem->state}
            };
        } elsif ($recvd->class_name =~ /::lineitem/) {
            $result->{"li"} = {$recvd->id => {"state" => $recvd->state}};
        }
    }
    $result->{"po"} ||=
        describe_affected_po($e, $lid->lineitem->purchase_order);

    $e->commit;
    return $result;
}

__PACKAGE__->register_method(
	method => 'receive_lineitem_api',
	api_name	=> 'open-ils.acq.lineitem.receive',
	signature => {
        desc => 'Mark a lineitem as received',
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'lineitem ID', type => 'number'}
        ],
        return => {desc =>
            "on success, object describing changes to LI and possibly PO; " .
            "on error, Event"
        }
    }
);

sub receive_lineitem_api {
    my($self, $conn, $auth, $li_id) = @_;

    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    my $li = $e->retrieve_acq_lineitem([
        $li_id, {
            flesh => 1,
            flesh_fields => {
                jub => ['purchase_order']
            }
        }
    ]) or return $e->die_event;

    return $e->die_event unless $e->allowed(
        'RECEIVE_PURCHASE_ORDER', $li->purchase_order->ordering_agency);

    my $res = receive_lineitem($mgr, $li_id) or return $e->die_event;
    $e->commit;
    $conn->respond_complete($res);
    $mgr->run_post_response_hooks;
}


__PACKAGE__->register_method(
	method => 'rollback_receive_po_api',
	api_name	=> 'open-ils.acq.purchase_order.receive.rollback'
);

sub rollback_receive_po_api {
    my($self, $conn, $auth, $po_id) = @_;
    my $e = new_editor(xact => 1, authtoken => $auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    my $po = $e->retrieve_acq_purchase_order($po_id) or return $e->die_event;
    return $e->die_event unless $e->allowed('RECEIVE_PURCHASE_ORDER', $po->ordering_agency);

    my $li_ids = $e->search_acq_lineitem({purchase_order => $po_id}, {idlist => 1});

    for my $li_id (@$li_ids) {
        rollback_receive_lineitem($mgr, $li_id) or return $e->die_event;
        $mgr->respond;
    }

    $po->state('on-order');
    update_purchase_order($mgr, $po) or return $e->die_event;

    $e->commit;
    return $mgr->respond_complete;
}


__PACKAGE__->register_method(
	method => 'rollback_receive_lineitem_detail_api',
	api_name	=> 'open-ils.acq.lineitem_detail.receive.rollback',
	signature => {
        desc => 'Mark a lineitem_detail as Un-received',
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'lineitem detail ID', type => 'number'}
        ],
        return => {desc =>
            "on success, object describing changes to LID and possibly " .
            "to LI and PO; on error, Event"
        }
    }
);

sub rollback_receive_lineitem_detail_api {
    my($self, $conn, $auth, $lid_id) = @_;

    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    my $lid = $e->retrieve_acq_lineitem_detail([
        $lid_id, {
            flesh => 2,
            flesh_fields => {
                acqlid => ['lineitem'],
                jub => ['purchase_order']
            }
        }
    ]);
    my $li = $lid->lineitem;
    my $po = $li->purchase_order;

    return $e->die_event unless $e->allowed('RECEIVE_PURCHASE_ORDER', $po->ordering_agency);

    my $result = {};

    my $recvd = rollback_receive_lineitem_detail($mgr, $lid_id)
        or return $e->die_event;

    if (ref $recvd) {
        $result->{"lid"} = {$recvd->id => {"recv_time" => $recvd->recv_time}};
    } else {
        $result->{"lid"} = {$lid->id => {"recv_time" => $lid->recv_time}};
    }

    if ($li->state eq "received") {
        $li->state("on-order");
        $li = update_lineitem($mgr, $li) or return $e->die_event;
        $result->{"li"} = {$li->id => {"state" => $li->state}};
    }

    if ($po->state eq "received") {
        $po->state("on-order");
        $po = update_purchase_order($mgr, $po) or return $e->die_event;
    }
    $result->{"po"} = describe_affected_po($e, $po);

    $e->commit and return $result or return $e->die_event;
}

__PACKAGE__->register_method(
	method => 'rollback_receive_lineitem_api',
	api_name	=> 'open-ils.acq.lineitem.receive.rollback',
	signature => {
        desc => 'Mark a lineitem as Un-received',
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'lineitem ID', type => 'number'}
        ],
        return => {desc =>
            "on success, object describing changes to LI and possibly PO; " .
            "on error, Event"
        }
    }
);

sub rollback_receive_lineitem_api {
    my($self, $conn, $auth, $li_id) = @_;

    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    my $li = $e->retrieve_acq_lineitem([
        $li_id, {
            "flesh" => 1, "flesh_fields" => {"jub" => ["purchase_order"]}
        }
    ]);
    my $po = $li->purchase_order;

    return $e->die_event unless $e->allowed('RECEIVE_PURCHASE_ORDER', $po->ordering_agency);

    $li = rollback_receive_lineitem($mgr, $li_id) or return $e->die_event;

    my $result = {"li" => {$li->id => {"state" => $li->state}}};
    if ($po->state eq "received") {
        $po->state("on-order");
        $po = update_purchase_order($mgr, $po) or return $e->die_event;
    }
    $result->{"po"} = describe_affected_po($e, $po);

    $e->commit and return $result or return $e->die_event;
}


__PACKAGE__->register_method(
	method => 'set_lineitem_price_api',
	api_name	=> 'open-ils.acq.lineitem.price.set',
	signature => {
        desc => 'Set lineitem price.  If debits already exist, update them as well',
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'lineitem ID', type => 'number'}
        ],
        return => {desc => 'status blob, Event on error'}
    }
);

sub set_lineitem_price_api {
    my($self, $conn, $auth, $li_id, $price) = @_;

    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    my $li = $e->retrieve_acq_lineitem([
        $li_id,
        {   flesh => 1,
            flesh_fields => {jub => ['purchase_order', 'picklist']}
        }
    ]) or return $e->die_event;

    if($li->purchase_order) {
        return $e->die_event unless 
            $e->allowed('CREATE_PURCHASE_ORDER', $li->purchase_order->ordering_agency);
    } else {
        return $e->die_event unless 
            $e->allowed('CREATE_PICKLIST', $li->picklist->org_unit);
    }

    $li->estimated_unit_price($price);
    update_lineitem($mgr, $li) or return $e->die_event;

    my $lid_ids = $e->search_acq_lineitem_detail(
        {lineitem => $li_id, fund_debit => {'!=' => undef}}, 
        {idlist => 1}
    );

    for my $lid_id (@$lid_ids) {

        my $lid = $e->retrieve_acq_lineitem_detail([
            $lid_id, {
            flesh => 1, flesh_fields => {acqlid => ['fund', 'fund_debit']}}
        ]);

        $lid->fund_debit->amount($price);
        $e->update_acq_fund_debit($lid->fund_debit) or return $e->die_event;
        $mgr->add_lid;
        $mgr->respond;
    }

    $e->commit;
    return $mgr->respond_complete;
}


__PACKAGE__->register_method(
	method => 'clone_picklist_api',
	api_name	=> 'open-ils.acq.picklist.clone',
	signature => {
        desc => 'Clones a picklist, including lineitem and lineitem details',
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'Picklist ID', type => 'number'},
            {desc => 'New Picklist Name', type => 'string'}
        ],
        return => {desc => 'status blob, Event on error'}
    }
);

sub clone_picklist_api {
    my($self, $conn, $auth, $pl_id, $name) = @_;

    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    my $old_pl = $e->retrieve_acq_picklist($pl_id);
    my $new_pl = create_picklist($mgr, %{$old_pl->to_bare_hash}, name => $name) or return $e->die_event;

    my $li_ids = $e->search_acq_lineitem({picklist => $pl_id}, {idlist => 1});

    for my $li_id (@$li_ids) {

        # copy the lineitems
        my $li = $e->retrieve_acq_lineitem($li_id);
        my $new_li = create_lineitem($mgr, %{$li->to_bare_hash}, picklist => $new_pl->id) or return $e->die_event;

        my $lid_ids = $e->search_acq_lineitem_detail({lineitem => $li_id}, {idlist => 1});
        for my $lid_id (@$lid_ids) {

            # copy the lineitem details
            my $lid = $e->retrieve_acq_lineitem_detail($lid_id);
            create_lineitem_detail($mgr, %{$lid->to_bare_hash}, lineitem => $new_li->id) or return $e->die_event;
        }

        $mgr->respond;
    }

    $e->commit;
    return $mgr->respond_complete;
}


__PACKAGE__->register_method(
	method => 'merge_picklist_api',
	api_name	=> 'open-ils.acq.picklist.merge',
	signature => {
        desc => 'Merges 2 or more picklists into a single list',
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'Lead Picklist ID', type => 'number'},
            {desc => 'List of subordinate picklist IDs', type => 'array'}
        ],
        return => {desc => 'status blob, Event on error'}
    }
);

sub merge_picklist_api {
    my($self, $conn, $auth, $lead_pl, $pl_list) = @_;

    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    # XXX perms on each picklist modified

    # point all of the lineitems at the lead picklist
    my $li_ids = $e->search_acq_lineitem({picklist => $pl_list}, {idlist => 1});

    for my $li_id (@$li_ids) {
        my $li = $e->retrieve_acq_lineitem($li_id);
        $li->picklist($lead_pl);
        update_lineitem($mgr, $li) or return $e->die_event;
        $mgr->respond;
    }

    # now delete the subordinate lists
    for my $pl_id (@$pl_list) {
        my $pl = $e->retrieve_acq_picklist($pl_id);
        $e->delete_acq_picklist($pl) or return $e->die_event;
    }

    $e->commit;
    return $mgr->respond_complete;
}


__PACKAGE__->register_method(
	method => 'delete_picklist_api',
	api_name	=> 'open-ils.acq.picklist.delete',
	signature => {
        desc => q/Deletes a picklist.  It also deletes any lineitems in the "new" state.  
            Other attached lineitems are detached'/,
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'Picklist ID to delete', type => 'number'}
        ],
        return => {desc => '1 on success, Event on error'}
    }
);

sub delete_picklist_api {
    my($self, $conn, $auth, $picklist_id) = @_;
    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);
    my $pl = $e->retrieve_acq_picklist($picklist_id) or return $e->die_event;
    delete_picklist($mgr, $pl) or return $e->die_event;
    $e->commit;
    return $mgr->respond_complete;
}



__PACKAGE__->register_method(
	method => 'activate_purchase_order',
	api_name	=> 'open-ils.acq.purchase_order.activate',
	signature => {
        desc => q/Activates a purchase order.  This updates the status of the PO
            and Lineitems to 'on-order'.  Activated PO's are ready for EDI delivery
            if appropriate./,
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'Purchase ID', type => 'number'}
        ],
        return => {desc => '1 on success, Event on error'}
    }
);

sub activate_purchase_order {
    my($self, $conn, $auth, $po_id) = @_;
    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);
    my $die_event = activate_purchase_order_impl($mgr, $po_id);
    return $die_event if $die_event;
    $e->commit;
    $conn->respond_complete(1);
    $mgr->run_post_response_hooks;
    return undef;
}

sub activate_purchase_order_impl {
    my($mgr, $po_id) = @_;
    my $e = $mgr->editor;

    my $po = $e->retrieve_acq_purchase_order($po_id) or return $e->die_event;
    return $e->die_event unless $e->allowed('CREATE_PURCHASE_ORDER', $po->ordering_agency);

    $po->state('on-order');
    update_purchase_order($mgr, $po) or return $e->die_event;

    my $query = [
        {purchase_order => $po_id, state => 'pending-order'},
        {limit => 1}
    ];

    while( my $li = $e->search_acq_lineitem($query)->[0] ) {
        $li->state('on-order');
        create_lineitem_debits($mgr, $li) or return $e->die_event;
        update_lineitem($mgr, $li) or return $e->die_event;
        $mgr->post_process( sub { create_lineitem_status_events($mgr, $li->id, 'aur.ordered'); });
        $mgr->respond;
    }

    return undef;
}


__PACKAGE__->register_method(
	method => 'split_purchase_order_by_lineitems',
	api_name	=> 'open-ils.acq.purchase_order.split_by_lineitems',
	signature => {
        desc => q/Splits a PO into many POs, 1 per lineitem.  Only works for
        POs a) with more than one lineitems, and b) in the "pending" state./,
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'Purchase order ID', type => 'number'}
        ],
        return => {desc => 'list of new PO IDs on success, Event on error'}
    }
);

sub split_purchase_order_by_lineitems {
    my ($self, $conn, $auth, $po_id) = @_;

    my $e = new_editor("xact" => 1, "authtoken" => $auth);
    return $e->die_event unless $e->checkauth;

    my $po = $e->retrieve_acq_purchase_order([
        $po_id, {
            "flesh" => 1,
            "flesh_fields" => {"acqpo" => [qw/lineitems notes/]}
        }
    ]) or return $e->die_event;

    return $e->die_event
        unless $e->allowed("CREATE_PURCHASE_ORDER", $po->ordering_agency);

    unless ($po->state eq "pending") {
        $e->rollback;
        return new OpenILS::Event("ACQ_PURCHASE_ORDER_TOO_LATE");
    }

    unless (@{$po->lineitems} > 1) {
        $e->rollback;
        return new OpenILS::Event("ACQ_PURCHASE_ORDER_TOO_SHORT");
    }

    # To split an existing PO into many, it seems unwise to just delete the
    # original PO, so we'll instead detach all of the original POs' lineitems
    # but the first, then create new POs for each of the remaining LIs, and
    # then attach the LIs to their new POs.

    my @po_ids = ($po->id);
    my @moving_li = @{$po->lineitems};
    shift @moving_li;    # discard first LI

    foreach my $li (@moving_li) {
        my $new_po = $po->clone;
        $new_po->clear_id;
        $new_po->clear_name;
        $new_po->creator($e->requestor->id);
        $new_po->editor($e->requestor->id);
        $new_po->owner($e->requestor->id);
        $new_po->edit_time("now");
        $new_po->create_time("now");

        $new_po = $e->create_acq_purchase_order($new_po);

        # Clone any notes attached to the old PO and attach to the new one.
        foreach my $note (@{$po->notes}) {
            my $new_note = $note->clone;
            $new_note->clear_id;
            $new_note->edit_time("now");
            $new_note->purchase_order($new_po->id);
            $e->create_acq_po_note($new_note);
        }

        $li->edit_time("now");
        $li->purchase_order($new_po->id);
        $e->update_acq_lineitem($li);

        push @po_ids, $new_po->id;
    }

    $po->edit_time("now");
    $e->update_acq_purchase_order($po);

    return \@po_ids if $e->commit;
    return $e->die_event;
}


__PACKAGE__->register_method(
	method => 'cancel_lineitem_api',
	api_name	=> 'open-ils.acq.lineitem.cancel',
	signature => {
        desc => q/Cancels an on-order lineitem/,
        params => [
            {desc => 'Authentication token', type => 'string'},
            {desc => 'Lineitem ID to cancel', type => 'number'},
            {desc => 'Cancel Cause ID', type => 'number'}
        ],
        return => {desc => '1 on success, Event on error'}
    }
);

sub cancel_lineitem_api {
    my($self, $conn, $auth, $li_id, $cancel_cause) = @_;

    my $e = new_editor(xact=>1, authtoken=>$auth);
    return $e->die_event unless $e->checkauth;
    my $mgr = OpenILS::Application::Acq::BatchManager->new(editor => $e, conn => $conn);

    my $li = $e->retrieve_acq_lineitem([$li_id, 
        {flesh => 1, flesh_fields => {jub => [q/purchase_order/]}}]);

    unless( $li->purchase_order and ($li->state eq 'on-order' or $li->state eq 'pending-order') ) {
        $e->rollback;
        return OpenILS::Event->new('BAD_PARAMS') 
    }

    return $e->die_event unless 
        $e->allowed('CREATE_PURCHASE_ORDER', $li->purchase_order->ordering_agency);

    $li->state('cancelled');

    # TODO delete the associated fund debits?
    # TODO add support for cancel reasons
    # TODO who/what/where/how do we indicate this change for electronic orders?

    update_lineitem($mgr, $li) or return $e->die_event;
    $e->commit;

    $conn->respond_complete($li);
    create_lineitem_status_events($mgr, $li_id, 'aur.cancelled');
    return undef;
}

__PACKAGE__->register_method (
    method        => 'user_requests',
    api_name    => 'open-ils.acq.user_request.retrieve.by_user_id',
    stream      => 1,
    signature => q/
        Retrieve fleshed user requests and related data for a given user or users.
        @param authtoken Login session key
        @param owner Id or array of id's for the pertinent users.
        @param options Allows one to override the query's 'order_by', 'limit', and 'offset'.  And the 'state' of the lineitem in the search.
    /
);

__PACKAGE__->register_method (
    method        => 'user_requests',
    api_name    => 'open-ils.acq.user_request.retrieve.by_home_ou',
    stream      => 1,
    signature => q/
        Retrieve fleshed user requests and related data for a given org unit or units.
        @param authtoken Login session key
        @param owner Id or array of id's for the pertinent org units.
        @param options Allows one to override the query's 'order_by', 'limit', and 'offset'.  And the 'state' of the lineitem in the search.
    /
);

sub user_requests {
    my($self, $conn, $auth, $search_value, $options) = @_;
    my $e = new_editor(authtoken => $auth);
    return $e->event unless $e->checkauth;
    my $rid = $e->requestor->id;

    my $query = {
        "select"=>{"aur"=>["id"],"au"=>["home_ou", {column => 'id', alias => 'usr_id'} ]},
        "from"=>{ "aur" => { "au" => {}, "jub" => { "type" => "left" } } },
        "where"=>{
            "+jub"=> {
                "-or" => [
                    {"id"=>undef}, # this with the left-join pulls in requests without lineitems
                    {"state"=>["new","on-order","pending-order"]} # FIXME - probably needs softcoding
                ]
            }
        },
        "order_by"=>[{"class"=>"aur", "field"=>"request_date", "direction"=>"desc"}]
    };

    if ($options && defined $options->{'order_by'}) {
        $query->{'order_by'} = $options->{'order_by'};        
    }
    if ($options && defined $options->{'limit'}) {
        $query->{'limit'} = $options->{'limit'};        
    }
    if ($options && defined $options->{'offset'}) {
        $query->{'offset'} = $options->{'offset'};        
    }
    if ($options && defined $options->{'state'}) {
        $query->{'where'}->{'+jub'}->{'-or'}->[1]->{'state'} = $options->{'state'};        
    }

    if ($self->api_name =~ /by_user_id/) {
        $query->{'where'}->{'usr'} = $search_value;
    } else {
        $query->{'where'}->{'+au'} = { 'home_ou' => $search_value };
    }

    my $pertinent_ids = $e->json_query($query);

    my %perm_test = ();
    for my $id_blob (@$pertinent_ids) {
        if ($rid != $id_blob->{usr_id}) {
            if (!defined $perm_test{ $id_blob->{home_ou} }) {
                $perm_test{ $id_blob->{home_ou} } = $e->allowed( ['user_request.view'], $id_blob->{home_ou} );
            }
            if (!$perm_test{ $id_blob->{home_ou} }) {
                next; # failed test
            }
        }
        my $aur_obj = $e->retrieve_acq_user_request([
            $id_blob->{id},
            {flesh => 1, flesh_fields => { "aur" => [ 'lineitem' ] } }
        ]);
        if (! $aur_obj) { next; }

        if ($aur_obj->lineitem()) {
            $aur_obj->lineitem()->clear_marc();
        }
        $conn->respond($aur_obj);
    }

    return undef;
}

__PACKAGE__->register_method (
    method      => 'update_user_request',
    api_name    => 'open-ils.acq.user_request.cancel.batch',
    stream      => 1,
);
__PACKAGE__->register_method (
    method      => 'update_user_request',
    api_name    => 'open-ils.acq.user_request.set_no_hold.batch',
    stream      => 1,
);

sub update_user_request {
    my($self, $conn, $auth, $aur_ids) = @_;
    my $e = new_editor(xact => 1, authtoken => $auth);
    return $e->die_event unless $e->checkauth;
    my $rid = $e->requestor->id;

    my $x = 1;
    my %perm_test = ();
    for my $id (@$aur_ids) {

        my $aur_obj = $e->retrieve_acq_user_request([
            $id,
            {   flesh => 1,
                flesh_fields => { "aur" => ['lineitem', 'usr'] }
            }
        ]) or return $e->die_event;

        my $context_org = $aur_obj->usr()->home_ou();
        $aur_obj->usr( $aur_obj->usr()->id() );

        if ($rid != $aur_obj->usr) {
            if (!defined $perm_test{ $context_org }) {
                $perm_test{ $context_org } = $e->allowed( ['user_request.update'], $context_org );
            }
            if (!$perm_test{ $context_org }) {
                next; # failed test
            }
        }

        if($self->api_name =~ /set_no_hold/) {
            if ($U->is_true($aur_obj->hold)) { 
                $aur_obj->hold(0); 
                $e->update_acq_user_request($aur_obj) or return $e->die_event;
            }
        }

        if($self->api_name =~ /cancel/) {
            $e->delete_acq_user_request($aur_obj);
        }

        $conn->respond({maximum => scalar(@$aur_ids), progress => $x++});
    }

    $e->commit;
    return {complete => 1};
}

1;
