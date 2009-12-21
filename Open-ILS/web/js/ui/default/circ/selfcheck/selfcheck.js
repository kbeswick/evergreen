dojo.require('dojo.date.locale');
dojo.require('dojo.date.stamp');
dojo.require('dijit.form.CheckBox');
dojo.require('dijit.form.NumberSpinner');
dojo.require('openils.CGI');
dojo.require('openils.Util');
dojo.require('openils.User');
dojo.require('openils.Event');
dojo.require('openils.widget.ProgressDialog');
dojo.require('openils.widget.OrgUnitFilteringSelect');

dojo.requireLocalization('openils.circ', 'selfcheck');
var localeStrings = dojo.i18n.getLocalization('openils.circ', 'selfcheck');


const SET_BARCODE_REGEX = 'opac.barcode_regex';
const SET_PATRON_TIMEOUT = 'circ.selfcheck.patron_login_timeout';
const SET_AUTO_OVERRIDE_EVENTS = 'circ.selfcheck.auto_override_checkout_events';
const SET_PATRON_PASSWORD_REQUIRED = 'circ.selfcheck.patron_password_required';
const SET_AUTO_RENEW_INTERVAL = 'circ.checkout_auto_renew_age';
const SET_WORKSTATION_REQUIRED = 'circ.selfcheck.workstation_required';
const SET_ALERT_POPUP = 'circ.selfcheck.alert.popup';
const SET_ALERT_SOUND = 'circ.selfcheck.alert.sound';
const SET_CC_PAYMENT_ALLOWED = 'credit.payments.allow';

function SelfCheckManager() {

    this.cgi = new openils.CGI();
    this.staff = null; 
    this.workstation = null;
    this.authtoken = null;

    this.patron = null; 
    this.patronBarcodeRegex = null;

    this.checkouts = [];
    this.itemsOut = [];

    // During renewals, keep track of the ID of the previous circulation. 
    // Previous circ is used for tracking failed renewals (for receipts).
    this.prevCirc = null;

    // current item barcode
    this.itemBarcode = null; 

    // are we currently performing a renewal?
    this.isRenewal = false; 

    // dict of org unit settings for "here"
    this.orgSettings = {};

    // Construct a mock checkout for debugging purposes
    if(this.mockCheckouts = this.cgi.param('mock-circ')) {

        this.mockCheckout = {
            payload : {
                record : new fieldmapper.mvr(),
                copy : new fieldmapper.acp(),
                circ : new fieldmapper.circ()
            }
        };

        this.mockCheckout.payload.record.title('Jazz improvisation for guitar');
        this.mockCheckout.payload.record.author('Wise, Les');
        this.mockCheckout.payload.record.isbn('0634033565');
        this.mockCheckout.payload.copy.barcode('123456789');
        this.mockCheckout.payload.circ.renewal_remaining(1);
        this.mockCheckout.payload.circ.parent_circ(1);
        this.mockCheckout.payload.circ.due_date('2012-12-21');
    }
}



/**
 * Fetch the org-unit settings, initialize the display, etc.
 */
SelfCheckManager.prototype.init = function() {

    this.staff = openils.User.user;
    this.workstation = openils.User.workstation;
    this.authtoken = openils.User.authtoken;
    this.loadOrgSettings();

    this.circTbody = dojo.byId('oils-selfck-circ-tbody');
    this.itemsOutTbody = dojo.byId('oils-selfck-circ-out-tbody');

    // workstation is required but none provided
    if(this.orgSettings[SET_WORKSTATION_REQUIRED] && !this.workstation) {
        if(confirm(dojo.string.substitute(localeStrings.WORKSTATION_REQUIRED))) {
            this.registerWorkstation();
        }
        return;
    }
    
    var self = this;
    // connect onclick handlers to the various navigation links
    var linkHandlers = {
        'oils-selfck-hold-details-link' : function() { self.drawHoldsPage(); },
        'oils-selfck-view-fines-link' : function() { self.drawFinesPage(); },
        'oils-selfck-pay-fines-link' : function() { self.drawPayFinesPage(); },
        'oils-selfck-nav-home' : function() { self.drawCircPage(); },
        'oils-selfck-nav-logout' : function() { self.logoutPatron(); },
        'oils-selfck-nav-logout-print' : function() { self.logoutPatron(true); },
        'oils-selfck-items-out-details-link' : function() { self.drawItemsOutPage(); },
        'oils-selfck-print-list-link' : function() { self.printList(); }
    }

    for(var id in linkHandlers) 
        dojo.connect(dojo.byId(id), 'onclick', linkHandlers[id]);


    if(this.cgi.param('patron')) {
        
        // Patron barcode via cgi param.  Mainly used for debugging and
        // only works if password is not required by policy
        this.loginPatron(this.cgi.param('patron'));

    } else {
        this.drawLoginPage();
    }

    /**
     * To test printing, pass a URL param of 'testprint'.  The value for the param
     * should be a JSON string like so:  [{circ:<circ_id>}, ...]
     */
    var testPrint = this.cgi.param('testprint');
    if(testPrint) {
        this.checkouts = JSON2js(testPrint);
        this.printSessionReceipt();
        this.checkouts = [];
    }
}


/**
 * Registers a new workstion
 */
SelfCheckManager.prototype.registerWorkstation = function() {
    
    oilsSelfckWsDialog.show();

    new openils.User().buildPermOrgSelector(
        'REGISTER_WORKSTATION', 
        oilsSelfckWsLocSelector, 
        this.staff.home_ou()
    );


    var self = this;
    dojo.connect(oilsSelfckWsSubmit, 'onClick', 

        function() {
            oilsSelfckWsDialog.hide();
            var name = oilsSelfckWsLocSelector.attr('displayedValue') + '-' + oilsSelfckWsName.attr('value');

            var res = fieldmapper.standardRequest(
                ['open-ils.actor', 'open-ils.actor.workstation.register'],
                { params : [
                        self.authtoken, name, oilsSelfckWsLocSelector.attr('value')
                    ]
                }
            );

            if(evt = openils.Event.parse(res)) {
                if(evt.textcode == 'WORKSTATION_NAME_EXISTS') {
                    if(confirm(localeStrings.WORKSTATION_EXISTS)) {
                        location.href = location.href.replace(/\?.*/, '') + '?ws=' + name;
                    } else {
                        self.registerWorkstation();
                    }
                    return;
                } else {
                    alert(evt);
                }
            } else {
                location.href = location.href.replace(/\?.*/, '') + '?ws=' + name;
            }
        }
    );
}

/**
 * Loads the org unit settings
 */
SelfCheckManager.prototype.loadOrgSettings = function() {

    var settings = fieldmapper.aou.fetchOrgSettingBatch(
        this.staff.ws_ou(), [
            SET_BARCODE_REGEX,
            SET_PATRON_TIMEOUT,
            SET_ALERT_POPUP,
            SET_ALERT_SOUND,
            SET_AUTO_OVERRIDE_EVENTS,
            SET_PATRON_PASSWORD_REQUIRED,
            SET_AUTO_RENEW_INTERVAL,
            SET_WORKSTATION_REQUIRED,
            SET_CC_PAYMENT_ALLOWED
        ]
    );

    for(k in settings) {
        if(settings[k])
            this.orgSettings[k] = settings[k].value;
    }

    if(settings[SET_BARCODE_REGEX]) 
        this.patronBarcodeRegex = new RegExp(settings[SET_BARCODE_REGEX].value);
}

SelfCheckManager.prototype.drawLoginPage = function() {
    var self = this;

    var bcHandler = function(barcode) {
        // handle patron barcode entry

        if(self.orgSettings[SET_PATRON_PASSWORD_REQUIRED]) {
            
            // password is required.  wire up the scan box to read it
            self.updateScanBox({
                msg : 'Please enter your password', // TODO i18n 
                handler : function(pw) { self.loginPatron(barcode, pw); },
                password : true
            });

        } else {
            // password is not required, go ahead and login
            self.loginPatron(barcode);
        }
    };

    this.updateScanBox({
        msg : 'Please log in with your library barcode.', // TODO
        handler : bcHandler
    });
}

/**
 * Login the patron.  
 */
SelfCheckManager.prototype.loginPatron = function(barcode, passwd) {

    if(this.orgSettings[SET_PATRON_PASSWORD_REQUIRED]) {
        
        if(!passwd) {
            // would only happen in dev/debug mode when using the patron= param
            alert('password required by org setting.  remove patron= from URL'); 
            return;
        }

        // patron password is required.  Verify it.

        var res = fieldmapper.standardRequest(
            ['open-ils.actor', 'open-ils.actor.verify_user_password'],
            {params : [this.authtoken, barcode, null, hex_md5(passwd)]}
        );

        if(res == 0) {
            // user-not-found results in login failure
            this.handleAlert(
                dojo.string.substitute(localeStrings.LOGIN_FAILED, [barcode]),
                false, 'login-failure'
            );
            this.drawLoginPage();
            return;
        }
    } 

    // retrieve the fleshed user by barcode
    this.patron = fieldmapper.standardRequest(
        ['open-ils.actor', 'open-ils.actor.user.fleshed.retrieve_by_barcode'],
        {params : [this.authtoken, barcode]}
    );

    var evt = openils.Event.parse(this.patron);
    if(evt) {
        this.handleAlert(
            dojo.string.substitute(localeStrings.LOGIN_FAILED, [barcode]),
            false, 'login-failure'
        );
        this.drawLoginPage();

    } else {

        this.handleAlert('', false, 'login-success');
        dojo.byId('oils-selfck-user-banner').innerHTML = 'Welcome, ' + this.patron.first_given_name(); // TODO i18n
        this.drawCircPage();
    }
}


SelfCheckManager.prototype.handleAlert = function(message, shouldPopup, sound) {

    console.log("Handling alert " + message);

    dojo.byId('oils-selfck-status-div').innerHTML = message;

    if(shouldPopup && this.orgSettings[SET_ALERT_POPUP]) 
        alert(message);

    if(sound && this.orgSettings[SET_ALERT_SOUND])
        openils.Util.playAudioUrl(SelfCheckManager.audioConfig[sound]);
}


/**
 * Manages the main input box
 * @param msg The context message to display with the box
 * @param clearOnly Don't update the context message, just clear the value and re-focus
 * @param handler Optional "on-enter" handler.  
 */
SelfCheckManager.prototype.updateScanBox = function(args) {
    args = args || {};

    if(args.select) {
        selfckScanBox.domNode.select();
    } else {
        selfckScanBox.attr('value', '');
    }

    if(args.password) {
        selfckScanBox.domNode.setAttribute('type', 'password');
    } else {
        selfckScanBox.domNode.setAttribute('type', '');
    }

    if(args.value)
        selfckScanBox.attr('value', args.value);

    if(args.msg) 
        dojo.byId('oils-selfck-scan-text').innerHTML = args.msg;

    if(selfckScanBox._lastHandler && (args.handler || args.clearHandler)) {
        dojo.disconnect(selfckScanBox._lastHandler);
    }

    if(args.handler) {
        selfckScanBox._lastHandler = dojo.connect(
            selfckScanBox, 
            'onKeyDown', 
            function(e) {
                if(e.keyCode != dojo.keys.ENTER) 
                    return;
                args.handler(selfckScanBox.attr('value'));
            }
        );
    }

    selfckScanBox.focus();
}

/**
 *  Sets up the checkout/renewal interface
 */
SelfCheckManager.prototype.drawCircPage = function() {

    openils.Util.show('oils-selfck-circ-tbody', 'table-row-group');
    this.goToTab('checkout');

    while(this.itemsOutTbody.childNodes[0])
        this.itemsOutTbody.removeChild(this.itemsOutTbody.childNodes[0]);

    var self = this;
    this.updateScanBox({
        msg : 'Please enter an item barcode', // TODO i18n
        handler : function(barcode) { self.checkout(barcode); }
    });

    if(!this.circTemplate)
        this.circTemplate = this.circTbody.removeChild(dojo.byId('oils-selfck-circ-row'));

    // fines summary
    this.updateFinesSummary();

    // holds summary
    this.updateHoldsSummary();

    // items out summary
    this.updateCircSummary();

    // render mock checkouts for debugging?
    if(this.mockCheckouts) {
        for(var i in [1,2,3]) 
            this.displayCheckout(this.mockCheckout, 'checkout');
    }
}


SelfCheckManager.prototype.updateFinesSummary = function() {
    var self = this; 

    // fines summary
    fieldmapper.standardRequest(
        ['open-ils.actor', 'open-ils.actor.user.fines.summary'],
        {   async : true,
            params : [this.authtoken, this.patron.id()],
            oncomplete : function(r) {

                var summary = openils.Util.readResponse(r);

                dojo.byId('oils-selfck-fines-total').innerHTML = 
                    dojo.string.substitute(
                        localeStrings.TOTAL_FINES_ACCOUNT, 
                        [summary.balance_owed()]
                    );

                self.creditPayableBalance = summary.balance_owed();
            }
        }
    );
}


SelfCheckManager.prototype.drawItemsOutPage = function() {
    openils.Util.hide('oils-selfck-circ-tbody');

    this.goToTab('items_out');

    while(this.itemsOutTbody.childNodes[0])
        this.itemsOutTbody.removeChild(this.itemsOutTbody.childNodes[0]);

    progressDialog.show(true);
    
    var self = this;
    fieldmapper.standardRequest(
        ['open-ils.circ', 'open-ils.circ.actor.user.checked_out.atomic'],
        {
            async : true,
            params : [this.authtoken, this.patron.id()],
            oncomplete : function(r) {

                var resp = openils.Util.readResponse(r);

                var circs = resp.sort(
                    function(a, b) {
                        if(a.circ.due_date() > b.circ.due_date())
                            return -1;
                        return 1;
                    }
                );

                progressDialog.hide();

                self.itemsOut = [];
                dojo.forEach(circs,
                    function(circ) {
                        self.itemsOut.push(circ.circ.id());
                        self.displayCheckout(
                            {payload : circ}, 
                            (circ.circ.parent_circ()) ? 'renew' : 'checkout',
                            true
                        );
                    }
                );
            }
        }
    );
}


SelfCheckManager.prototype.goToTab = function(name) {
    this.tabName = name;

    openils.Util.hide('oils-selfck-fines-page');
    openils.Util.hide('oils-selfck-payment-page');
    openils.Util.hide('oils-selfck-holds-page');
    openils.Util.hide('oils-selfck-circ-page');
    openils.Util.hide('oils-selfck-pay-fines-link');
    
    switch(name) {
        case 'checkout':
            openils.Util.show('oils-selfck-circ-page');
            break;
        case 'items_out':
            openils.Util.show('oils-selfck-circ-page');
            break;
        case 'holds':
            openils.Util.show('oils-selfck-holds-page');
            break;
        case 'fines':
            openils.Util.show('oils-selfck-fines-page');
            break;
        case 'payment':
            openils.Util.show('oils-selfck-payment-page');
            break;
    }
}


SelfCheckManager.prototype.printList = function() {
    switch(this.tabName) {
        case 'checkout':
            this.printSessionReceipt();
            break;
        case 'items_out':
            this.printItemsOutReceipt();
            break;
        case 'holds':
            this.printHoldsReceipt();
            break;
        case 'fines':
            this.printFinesReceipt();
            break;
    }
}

SelfCheckManager.prototype.updateHoldsSummary = function() {

    if(!this.holdsSummary) {
        var summary = fieldmapper.standardRequest(
            ['open-ils.circ', 'open-ils.circ.holds.user_summary'],
            {params : [this.authtoken, this.patron.id()]}
        );

        this.holdsSummary = {};
        this.holdsSummary.ready = Number(summary['4']);
        this.holdsSummary.total = 0;

        for(var i in summary) 
            this.holdsSummary.total += Number(summary[i]);
    }

    dojo.byId('oils-selfck-holds-total').innerHTML = 
        dojo.string.substitute(
            localeStrings.TOTAL_HOLDS, 
            [this.holdsSummary.total]
        );

    dojo.byId('oils-selfck-holds-ready').innerHTML = 
        dojo.string.substitute(
            localeStrings.HOLDS_READY_FOR_PICKUP, 
            [this.holdsSummary.ready]
        );
}


SelfCheckManager.prototype.updateCircSummary = function(increment) {

    if(!this.circSummary) {

        var summary = fieldmapper.standardRequest(
            ['open-ils.actor', 'open-ils.actor.user.checked_out.count'],
            {params : [this.authtoken, this.patron.id()]}
        );

        this.circSummary = {
            total : Number(summary.out) + Number(summary.overdue),
            overdue : Number(summary.overdue),
            session : 0
        };
    }

    if(increment) {
        // local checkout occurred.  Add to the total and the session.
        this.circSummary.total += 1;
        this.circSummary.session += 1;
    }

    dojo.byId('oils-selfck-circ-account-total').innerHTML = 
        dojo.string.substitute(
            localeStrings.TOTAL_ITEMS_ACCOUNT, 
            [this.circSummary.total]
        );

    dojo.byId('oils-selfck-circ-session-total').innerHTML = 
        dojo.string.substitute(
            localeStrings.TOTAL_ITEMS_SESSION, 
            [this.circSummary.session]
        );
}


SelfCheckManager.prototype.drawHoldsPage = function() {

    // TODO add option to hid scanBox
    // this.updateScanBox(...)

    this.goToTab('holds');

    this.holdTbody = dojo.byId('oils-selfck-hold-tbody');
    if(!this.holdTemplate)
        this.holdTemplate = this.holdTbody.removeChild(dojo.byId('oils-selfck-hold-row'));
    while(this.holdTbody.childNodes[0])
        this.holdTbody.removeChild(this.holdTbody.childNodes[0]);

    progressDialog.show(true);

    var self = this;
    fieldmapper.standardRequest( // fetch the hold IDs

        ['open-ils.circ', 'open-ils.circ.holds.id_list.retrieve'],
        {   async : true,
            params : [this.authtoken, this.patron.id()],

            oncomplete : function(r) { 
                var ids = openils.Util.readResponse(r);
                if(!ids || ids.length == 0) {
                    progressDialog.hide();
                    return;
                }

                fieldmapper.standardRequest( // fetch the hold objects with fleshed details
                    ['open-ils.circ', 'open-ils.circ.hold.details.batch.retrieve.atomic'],
                    {   async : true,
                        params : [self.authtoken, ids],

                        oncomplete : function(rr) {
                            self.drawHolds(openils.Util.readResponse(rr));
                        }
                    }
                );
            }
        }
    );
}

/**
 * Fetch and add a single hold to the list of holds
 */
SelfCheckManager.prototype.drawHolds = function(holds) {

    holds = holds.sort(
        // sort available holds to the top of the list
        // followed by queue position order
        function(a, b) {
            if(a.status == 4) return -1;
            if(a.queue_position < b.queue_position) return -1;
            return 1;
        }
    );

    this.holds = holds;

    progressDialog.hide();

    for(var i in holds) {

        var data = holds[i];
        var row = this.holdTemplate.cloneNode(true);

        if(data.mvr.isbn()) {
            this.byName(row, 'jacket').setAttribute('src', '/opac/extras/ac/jacket/small/' + data.mvr.isbn());
        }

        this.byName(row, 'title').innerHTML = data.mvr.title();
        this.byName(row, 'author').innerHTML = data.mvr.author();

        if(data.status == 4) {

            // hold is ready for pickup
            this.byName(row, 'status').innerHTML = localeStrings.HOLD_STATUS_READY;

        } else {

            // hold is still pending
            this.byName(row, 'status').innerHTML = 
                dojo.string.substitute(
                    localeStrings.HOLD_STATUS_WAITING,
                    [data.queue_position, data.potential_copies]
                );
        }

        this.holdTbody.appendChild(row);
    }
}


SelfCheckManager.prototype.drawPayFinesPage = function() {
    this.goToTab('payment');

    dojo.byId('oils-selfck-cc-payment-summary').innerHTML = 
        dojo.string.substitute(
            localeStrings.CC_PAYABLE_BALANCE,
            [this.creditPayableBalance]
        );

    oilsSelfckCCNumber.attr('value', '');
    oilsSelfckCCMonth.attr('value', '01');
    oilsSelfckCCAmount.attr('value', this.creditPayableBalance);
    oilsSelfckCCYear.attr('value', new Date().getFullYear());
    oilsSelfckCCFName.attr('value', this.patron.first_given_name());
    oilsSelfckCCLName.attr('value', this.patron.family_name());
    var addr = this.patron.billing_address() || this.patron.mailing_address();

    if(addr) {
        oilsSelfckCCStreet.attr('value', addr.street1()+' '+addr.street2());
        oilsSelfckCCCity.attr('value', addr.city());
        oilsSelfckCCState.attr('value', addr.state());
        oilsSelfckCCZip.attr('value', addr.post_code());
    }

    dojo.connect(oilsSelfckEditDetails, 'onChange', 
        function(newVal) {
            dojo.forEach(
                [   oilsSelfckCCFName, 
                    oilsSelfckCCLName, 
                    oilsSelfckCCStreet, 
                    oilsSelfckCCCity, 
                    oilsSelfckCCState, 
                    oilsSelfckCCZip
                ],
                function(dij) { dij.attr('disabled', !newVal); }
            );
        }
    );


    var self = this;
    dojo.connect(oilsSelfckCCSubmit, 'onClick',
        function() {
            progressDialog.show(true);
            self.sendCCPayment();
        }
    );
}


// In this form, this code only supports global on/off credit card 
// payments and does not dissallow payments to transactions that started
// at remote locations or transactions that have accumulated billings at 
// remote locations that dissalow credit card payments.
// TODO add per-transaction blocks for orgs that do not support CC payments

SelfCheckManager.prototype.sendCCPayment = function() {

    var args = {
        userid : this.patron.id(),
        payment_type : 'credit_card_payment',
        payments : [],
        cc_args : {
            where_process : 1,
            number : oilsSelfckCCNumber.attr('value'),
            expire_year : oilsSelfckCCYear.attr('value'),
            expire_month : oilsSelfckCCMonth.attr('value'),
            billing_first : oilsSelfckCCFName.attr('value'),
            billing_last : oilsSelfckCCLName.attr('value'),
            billing_address : oilsSelfckCCStreet.attr('value'),
            billing_city : oilsSelfckCCCity.attr('value'),
            billing_state : oilsSelfckCCState.attr('value'),
            billing_zip : oilsSelfckCCZip.attr('value')
        }
    }

    var funds = oilsSelfckCCAmount.attr('value');

    xacts = this.finesData.sort(
        function(a, b) {
            if(a.transaction.xact_start() < b.transaction.xact_start()) 
                return -1;
            return 1;
        }
    );

    for(var i in xacts) {
        var xact = xacts[i].transaction;
        var paying = Math.min(funds, xact.balance_owed());
        args.payments.push([xact.id(), paying]);
        funds -= paying;
        if(funds <= 0) break;
    }

    var resp = fieldmapper.standardRequest(
        ['open-ils.circ', 'open-ils.circ.money.payment'],
        {params : [this.authtoken, args]}
    );

    progressDialog.hide();

    var evt = openils.Event.parse(resp);
    if(evt) {
        alert(evt);
    } else {
        this.updateFinesSummary();
        this.drawFinesPage();
    }
}


SelfCheckManager.prototype.drawFinesPage = function() {

    // TODO add option to hid scanBox
    // this.updateScanBox(...)

    this.goToTab('fines');
    progressDialog.show(true);

    if(this.creditPayableBalance > 0 && this.orgSettings[SET_CC_PAYMENT_ALLOWED]) {
        openils.Util.show('oils-selfck-pay-fines-link', 'inline');
    }

    this.finesTbody = dojo.byId('oils-selfck-fines-tbody');
    if(!this.finesTemplate)
        this.finesTemplate = this.finesTbody.removeChild(dojo.byId('oils-selfck-fines-row'));
    while(this.finesTbody.childNodes[0])
        this.finesTbody.removeChild(this.finesTbody.childNodes[0]);

    var self = this;
    var handler = function(dataList) {
        self.finesCount = dataList.length;
        self.finesData = dataList;
        for(var i in dataList) {
            var data = dataList[i];
            var row = self.finesTemplate.cloneNode(true);
            var type = data.transaction.xact_type();
            if(type == 'circulation') {
                self.byName(row, 'type').innerHTML = type;
                self.byName(row, 'details').innerHTML = data.record.title();
            } else if(type == 'grocery') {
                self.byName(row, 'type').innerHTML = 'Miscellaneous'; // Go ahead and head off any confusion around "grocery".  TODO i18n
                self.byName(row, 'details').innerHTML = data.transaction.last_billing_type();
            }
            self.byName(row, 'total_owed').innerHTML = data.transaction.total_owed();
            self.byName(row, 'total_paid').innerHTML = data.transaction.total_paid();
            self.byName(row, 'balance').innerHTML = data.transaction.balance_owed();
            self.finesTbody.appendChild(row);
        }
    }

    fieldmapper.standardRequest( 
        ['open-ils.actor', 'open-ils.actor.user.transactions.have_balance.fleshed'],
        {   async : true,
            params : [this.authtoken, this.patron.id()],
            oncomplete : function(r) { 
                progressDialog.hide();
                handler(openils.Util.readResponse(r));
            }
        }
    );
}

SelfCheckManager.prototype.checkin = function(barcode, abortTransit) {

    var resp = fieldmapper.standardRequest(
        ['open-ils.circ', 'open-ils.circ.transit.abort'],
        {params : [this.authtoken, {barcode : barcode}]}
    );

    // resp == 1 on success
    if(openils.Event.parse(resp))
        return false;

    var resp = fieldmapper.standardRequest(
        ['open-ils.circ', 'open-ils.circ.checkin.override'],
        {params : [
            this.authtoken, {
                patron_id : this.patron.id(),
                copy_barcode : barcode,
                noop : true
            }
        ]}
    );

    if(!resp.length) resp = [resp];
    for(var i = 0; i < resp.length; i++) {
        var tc = openils.Event.parse(resp[i]).textcode;
        if(tc == 'SUCCESS' || tc == 'NO_CHANGE') {
            continue;
        } else {
            return false;
        }
    }

    return true;
}

/**
 * Check out a single item.  If the item is already checked 
 * out to the patron, redirect to renew()
 */
SelfCheckManager.prototype.checkout = function(barcode, override) {

    this.prevCirc = null;

    if(!barcode) {
        this.updateScanbox(null, true);
        return;
    }

    if(this.mockCheckouts) {
        // if we're in mock-checkout mode, just insert another
        // fake circ into the table and get out of here.
        this.displayCheckout(this.mockCheckout, 'checkout');
        return;
    }

    // TODO see if it's a patron barcode
    // TODO see if this item has already been checked out in this session

    var method = 'open-ils.circ.checkout.full';
    if(override) method += '.override';

    console.log("Checkout out item " + barcode + " with method " + method);

    var result = fieldmapper.standardRequest(
        ['open-ils.circ', 'open-ils.circ.checkout.full'],
        {params: [
            this.authtoken, {
                patron_id : this.patron.id(),
                copy_barcode : barcode
            }
        ]}
    );

    var stat = this.handleXactResult('checkout', barcode, result);

    if(stat.override) {
        this.checkout(barcode, true);
    } else if(stat.doOver) {
        this.checkout(barcode);
    } else if(stat.renew) {
        this.renew(barcode);
    }
}


SelfCheckManager.prototype.handleXactResult = function(action, item, result) {

    var displayText = '';

    // If true, the display message is important enough to pop up.  Whether or not
    // an alert() actually occurs, depends on org unit settings
    var popup = false;  
    var sound = ''; // sound file reference
    var payload = result.payload || {};
    var overrideEvents = this.orgSettings[SET_AUTO_OVERRIDE_EVENTS];
        
    if(result.textcode == 'NO_SESSION') {

        return this.logoutStaff();

    } else if(result.textcode == 'SUCCESS') {

        if(action == 'checkout') {

            displayText = dojo.string.substitute(localeStrings.CHECKOUT_SUCCESS, [item]);
            this.displayCheckout(result, 'checkout');

            if(payload.holds_fulfilled && payload.holds_fulfilled.length) {
                // A hold was fulfilled, update the hold numbers in the circ summary
                console.log("fulfilled hold " + payload.holds_fulfilled + " during checkout");
                this.holdsSummary = null;
                this.updateHoldsSummary();
            }

            this.updateCircSummary(true);

        } else if(action == 'renew') {

            displayText = dojo.string.substitute(localeStrings.RENEW_SUCCESS, [item]);
            this.displayCheckout(result, 'renew');
        }

        this.checkouts.push({circ : result.payload.circ.id()});
        sound = 'checkout-success';
        this.updateScanBox();

    } else if(result.textcode == 'OPEN_CIRCULATION_EXISTS' && action == 'checkout') {

        // Server says the item is already checked out.  If it's checked out to the
        // current user, we may need to renew it.  

        if(payload.old_circ) { 

            /*
            old_circ refers to the previous checkout IFF it's for the same user. 
            If no auto-renew interval is not defined, assume we should renew it
            If an auto-renew interval is defined and the payload comes back with
            auto_renew set to true, do the renewal.  Otherwise, let the patron know
            the item is already checked out to them.  */

            if( !this.orgSettings[SET_AUTO_RENEW_INTERVAL] ||
                (this.orgSettings[SET_AUTO_RENEW_INTERVAL] && payload.auto_renew) ) {
                this.prevCirc = payload.old_circ.id();
                return { renew : true };
            }

            popup = true;
            sound = 'checkout-failure';
            displayText = dojo.string.substitute(localeStrings.ALREADY_OUT, [item]);

        } else {

            if( // copy is marked lost.  if configured to do so, check it in and try again.
                result.payload.copy && 
                result.payload.copy.status() == /* LOST */ 3 &&
                overrideEvents && overrideEvents.length &&
                overrideEvents.indexOf('COPY_STATUS_LOST') != -1) {

                    if(this.checkin(item)) {
                        return { doOver : true };
                    }
            }

            
            // item is checked out to some other user
            popup = true;
            sound = 'checkout-failure';
            displayText = dojo.string.substitute(localeStrings.OPEN_CIRCULATION_EXISTS, [item]);
        }

        this.updateScanBox({select:true});

    } else {

    
        if(overrideEvents && overrideEvents.length) {
            
            // see if the events we received are all in the list of
            // events to override
    
            if(!result.length) result = [result];
    
            var override = true;
            for(var i = 0; i < result.length; i++) {
                var match = overrideEvents.filter(
                    function(e) { return (e == result[i].textcode); })[0];
                if(!match) {
                    override = false;
                    break;
                }

                if(result[i].textcode == 'COPY_IN_TRANSIT') {
                    // to override a transit, we have to abort the transit and check it in first
                    if(this.checkin(item, true)) {
                        return { doOver : true };
                    } else {
                        override = false;
                    }

                }
            }

            if(override) 
                return { override : true };
        }
    
        this.updateScanBox({select : true});
        popup = true;
        sound = 'checkout-failure';

        if(action == 'renew')
            this.checkouts.push({circ : this.prevCirc, renewal_failure : true});

        if(result.length) 
            result = result[0];

        switch(result.textcode) {

            // TODO custom handler for blocking penalties

            case 'MAX_RENEWALS_REACHED' :
                displayText = dojo.string.substitute(
                    localeStrings.MAX_RENEWALS, [item]);
                break;

            case 'ITEM_NOT_CATALOGED' :
                displayText = dojo.string.substitute(
                    localeStrings.ITEM_NOT_CATALOGED, [item]);
                break;

            case 'OPEN_CIRCULATION_EXISTS' :
                displayText = dojo.string.substitute(
                    localeStrings.OPEN_CIRCULATION_EXISTS, [item]);

                break;

            default:
                console.error('Unhandled event ' + result.textcode);

                if(action == 'checkout' || action == 'renew') {
                    displayText = dojo.string.substitute(
                        localeStrings.GENERIC_CIRC_FAILURE, [item]);
                } else {
                    displayText = dojo.string.substitute(
                        localeStrings.UNKNOWN_ERROR, [result.textcode]);
                }
        }
    }

    this.handleAlert(displayText, popup, sound);
    return {};
}


/**
 * Renew an item
 */
SelfCheckManager.prototype.renew = function(barcode, override) {

    var method = 'open-ils.circ.renew';
    if(override) method += '.override';

    console.log("Renewing item " + barcode + " with method " + method);

    var result = fieldmapper.standardRequest(
        ['open-ils.circ', method],
        {params: [
            this.authtoken, {
                patron_id : this.patron.id(),
                copy_barcode : barcode
            }
        ]}
    );

    console.log(js2JSON(result));

    var stat = this.handleXactResult('renew', barcode, result);

    if(stat.override)
        this.renew(barcode, true);
}

/**
 * Display the result of a checkout or renewal in the items out table
 */
SelfCheckManager.prototype.displayCheckout = function(evt, type, itemsOut) {

    var copy = evt.payload.copy;
    var record = evt.payload.record;
    var circ = evt.payload.circ;
    var row = this.circTemplate.cloneNode(true);

    if(record.isbn()) {
        this.byName(row, 'jacket').setAttribute('src', '/opac/extras/ac/jacket/small/' + record.isbn());
    }

    this.byName(row, 'barcode').innerHTML = copy.barcode();
    this.byName(row, 'title').innerHTML = record.title();
    this.byName(row, 'author').innerHTML = record.author();
    this.byName(row, 'remaining').innerHTML = circ.renewal_remaining();
    openils.Util.show(this.byName(row, type));

    var date = dojo.date.stamp.fromISOString(circ.due_date());
    this.byName(row, 'due_date').innerHTML = 
        dojo.date.locale.format(date, {selector : 'date'});

    // put new circs at the top of the list
    var tbody = this.circTbody;
    if(itemsOut) tbody = this.itemsOutTbody;
    tbody.insertBefore(row, tbody.getElementsByTagName('tr')[0]);
}


SelfCheckManager.prototype.byName = function(node, name) {
    return dojo.query('[name=' + name+']', node)[0];
}


SelfCheckManager.prototype.initPrinter = function() {
    try { // Mozilla only
		netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
        netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
        netscape.security.PrivilegeManager.enablePrivilege('UniversalPreferencesRead');
        netscape.security.PrivilegeManager.enablePrivilege('UniversalPreferencesWrite');
        var pref = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefBranch);
        if (pref)
            pref.setBoolPref('print.always_print_silent', true);
    } catch(E) {
        console.log("Unable to initialize auto-printing"); 
    }
}

/**
 * Print a receipt for this session's checkouts
 */
SelfCheckManager.prototype.printSessionReceipt = function(callback) {

    var circIds = [];
    var circCtx = []; // circ context data.  in this case, renewal_failure info

    // collect the circs and failure info
    dojo.forEach(
        this.checkouts, 
        function(blob) {
            circIds.push(blob.circ);
            circCtx.push({renewal_failure:blob.renewal_failure});
        }
    );

    var params = [
        this.authtoken, 
        this.staff.ws_ou(),
        null,
        'format.selfcheck.checkout',
        'print-on-demand',
        circIds,
        circCtx
    ];

    var self = this;
    fieldmapper.standardRequest(
        ['open-ils.circ', 'open-ils.circ.fire_circ_trigger_events'],
        {   
            async : true,
            params : params,
            oncomplete : function(r) {
                var resp = openils.Util.readResponse(r);
                var output = resp.template_output();
                if(output) {
                    self.printData(output.data(), self.checkouts.length, callback); 
                } else {
                    var error = resp.error_output();
                    if(error) {
                        throw new Error("Error creating receipt: " + error.data());
                    } else {
                        throw new Error("No receipt data returned from server");
                    }
                }
            }
        }
    );
}

SelfCheckManager.prototype.printData = function(data, numItems, callback) {

    var win = window.open('', '', 'resizable,width=700,height=500,scrollbars=1'); 
    win.document.body.innerHTML = data;
    win.print();

    /*
     * There is no way to know when the browser is done printing.
     * Make a best guess at when to close the print window by basing
     * the setTimeout wait on the number of items to be printed plus
     * a small buffer
     */
    var sleepTime = 1000;
    if(numItems > 0) 
        sleepTime += (numItems / 2) * 1000;

    setTimeout(
        function() { 
            win.close(); // close the print window
            if(callback)
                callback(); // fire optional post-print callback
        },
        sleepTime 
    );
}


/**
 * Print a receipt for this user's items out
 */
SelfCheckManager.prototype.printItemsOutReceipt = function(callback) {

    if(!this.itemsOut.length) return;

    progressDialog.show(true);

    var params = [
        this.authtoken, 
        this.staff.ws_ou(),
        null,
        'format.selfcheck.items_out',
        'print-on-demand',
        this.itemsOut
    ];

    var self = this;
    fieldmapper.standardRequest(
        ['open-ils.circ', 'open-ils.circ.fire_circ_trigger_events'],
        {   
            async : true,
            params : params,
            oncomplete : function(r) {
                progressDialog.hide();
                var resp = openils.Util.readResponse(r);
                var output = resp.template_output();
                if(output) {
                    self.printData(output.data(), self.itemsOut.length, callback); 
                } else {
                    var error = resp.error_output();
                    if(error) {
                        throw new Error("Error creating receipt: " + error.data());
                    } else {
                        throw new Error("No receipt data returned from server");
                    }
                }
            }
        }
    );
}

/**
 * Print a receipt for this user's items out
 */
SelfCheckManager.prototype.printHoldsReceipt = function(callback) {

    if(!this.holds.length) return;

    progressDialog.show(true);

    var holdIds = [];
    var holdData = [];

    dojo.forEach(this.holds,
        function(data) {
            holdIds.push(data.hold.id());
            if(data.status == 4) {
                holdData.push({ready : true});
            } else {
                holdData.push({
                    queue_position : data.queue_position, 
                    potential_copies : data.potential_copies
                });
            }
        }
    );

    var params = [
        this.authtoken, 
        this.staff.ws_ou(),
        null,
        'format.selfcheck.holds',
        'print-on-demand',
        holdIds,
        holdData
    ];

    var self = this;
    fieldmapper.standardRequest(
        ['open-ils.circ', 'open-ils.circ.fire_hold_trigger_events'],
        {   
            async : true,
            params : params,
            oncomplete : function(r) {
                progressDialog.hide();
                var resp = openils.Util.readResponse(r);
                var output = resp.template_output();
                if(output) {
                    self.printData(output.data(), self.holds.length, callback); 
                } else {
                    var error = resp.error_output();
                    if(error) {
                        throw new Error("Error creating receipt: " + error.data());
                    } else {
                        throw new Error("No receipt data returned from server");
                    }
                }
            }
        }
    );
}


/**
 * Print a receipt for this user's items out
 */
SelfCheckManager.prototype.printFinesReceipt = function(callback) {

    progressDialog.show(true);

    var params = [
        this.authtoken, 
        this.staff.ws_ou(),
        null,
        'format.selfcheck.fines',
        'print-on-demand',
        [this.patron.id()]
    ];

    var self = this;
    fieldmapper.standardRequest(
        ['open-ils.circ', 'open-ils.circ.fire_user_trigger_events'],
        {   
            async : true,
            params : params,
            oncomplete : function(r) {
                progressDialog.hide();
                var resp = openils.Util.readResponse(r);
                var output = resp.template_output();
                if(output) {
                    self.printData(output.data(), self.finesCount, callback); 
                } else {
                    var error = resp.error_output();
                    if(error) {
                        throw new Error("Error creating receipt: " + error.data());
                    } else {
                        throw new Error("No receipt data returned from server");
                    }
                }
            }
        }
    );
}




/**
 * Logout the patron and return to the login page
 */
SelfCheckManager.prototype.logoutPatron = function(print) {
    if(print && this.checkouts.length) {
        this.printSessionReceipt(
            function() {
                location.href = location.href;
            }
        );
    } else {
        location.href = location.href;
    }
}


/**
 * Fire up the manager on page load
 */
openils.Util.addOnLoad(
    function() {
        new SelfCheckManager().init();
    }
);
