package OpenILS::Application::Circ::CopyLocations;
use base 'OpenILS::Application';
use strict; use warnings;
use Data::Dumper;
$Data::Dumper::Indent = 0;
use OpenSRF::EX qw(:try);
use OpenSRF::Utils::Logger qw(:logger);
use OpenILS::Application::AppUtils;
use OpenILS::Utils::Fieldmapper;
use OpenILS::Utils::CStoreEditor qw/:funcs/;
my $U = "OpenILS::Application::AppUtils";


__PACKAGE__->register_method(
	api_name		=> "open-ils.circ.copy_location.retrieve.all",
	method		=> 'cl_retrieve_all',
	argc			=>	2,
	signature	=> q/
		Retrieves the ranged set of copy locations for the requested org.
		If no org is provided, all copy locations are returned
		@param orgId The org location id
		@param noi18n No i18n in result
        @param flesh_owning_lib Flesh owning lib in results
		@return An array of copy location objects
		/);

sub cl_retrieve_all {
	my ($self, $client, $org_id, $no_i18n, $flesh_owning_lib) = @_;

	if(!$org_id) {
		my $otree = $U->get_org_tree();
		$org_id = $otree->id;
	}

    my $second_cstore_arg = {"no_i18n" => scalar($no_i18n)};
    if ($flesh_owning_lib) {
        $second_cstore_arg->{"flesh"} = 1;
        $second_cstore_arg->{"flesh_fields"} = {"acpl" => ["owning_lib"]};
    }

    return new_editor()->search_asset_copy_location([{
        owning_lib => $U->get_org_full_path($org_id)
    }, $second_cstore_arg]);
}

__PACKAGE__->register_method(
	api_name		=> 'open-ils.circ.copy_location.create',
	method		=> 'cl_create',
	argc			=> 2,
	signature	=> q/
		Creates a new copy location.  Requestor must have the CREATE_COPY_LOCATION
		permission at the location specified on the new location object
		@param authtoken The login session key
		@param copyLoc The new copy location object
		@return The if of the new location object on success, event on error
	/);


sub cl_create {
    my( $self, $conn, $auth, $location ) = @_;

    my $e = new_editor(authtoken=>$auth, xact=>1);
    return $e->die_event unless $e->checkauth;
    return $e->die_event unless 
        $e->allowed('CREATE_COPY_LOCATION', $location->owning_lib);

    # make sure there is no copy_location with the same name in the same place
    my $existing = $e->search_asset_copy_location(
        {owning_lib => $location->owning_lib, name => $location->name}, {idlist=>1});
    return OpenILS::Event->new('COPY_LOCATION_EXISTS') if @$existing;

    $e->create_asset_copy_location($location) or return $e->die_event;
    $e->commit;
    return $location->id;
}



__PACKAGE__->register_method (
	api_name		=> 'open-ils.circ.copy_location.delete',
	method		=> 'cl_delete',
	argc			=> 2,
	signature	=> q/
		Deletes a copy location. Requestor must have the 
		DELETE_COPY_LOCATION permission.
		@param authtoken The login session key
		@param id The copy location object id
		@return 1 on success, event on error
	/);


sub cl_delete {
    my( $self, $conn, $auth, $id ) = @_;

    my $e = new_editor(authtoken=>$auth, xact=>1);
    return $e->die_event unless $e->checkauth;

    my $cloc = $e->retrieve_asset_copy_location($id) 
        or return $e->die_event;
    return $e->die_event unless 
        $e->allowed('DELETE_COPY_LOCATION', $cloc->owning_lib);

    $e->delete_asset_copy_location($cloc) or return $e->die_event;
    $e->commit;
    return 1;
}


__PACKAGE__->register_method (
	api_name		=> 'open-ils.circ.copy_location.update',
	method		=> 'cl_update',
	argc			=> 2,
	signature	=> q/
		Updates a copy location object.  Requestor must have 
		the UPDATE_COPY_LOCATION permission
		@param authtoken The login session key
		@param copyLoc	The copy location object
		@return 1 on success, event on error
	/);


sub cl_update {
    my( $self, $conn, $auth, $location ) = @_;

    my $e = new_editor(authtoken=>$auth, xact=>1);
    return $e->die_event unless $e->checkauth;

    # check permissions against the original copy location
    my $orig_loc = $e->retrieve_asset_copy_location($location->id)
        or return $e->die_event;

    return $e->die_event unless 
        $e->allowed('UPDATE_COPY_LOCATION', $orig_loc->owning_lib);

    # disallow hijacking of the location
    $location->owning_lib($orig_loc->owning_lib);  

    $e->update_asset_copy_location($location)
        or return $e->die_event;

    $e->commit;
    return 1;
}



__PACKAGE__->register_method(
	method => 'fetch_loc',
    authoritative => 1,
	api_name => 'open-ils.circ.copy_location.retrieve',
);

sub fetch_loc {
	my( $self, $con, $id ) = @_;
	my $e = new_editor();
	my $cl = $e->retrieve_asset_copy_location($id)
		or return $e->event;
	return $cl;
}




23;
