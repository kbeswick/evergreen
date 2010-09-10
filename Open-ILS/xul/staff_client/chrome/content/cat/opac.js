var docid; var marc_html; var top_pane; var bottom_pane; var opac_frame; var opac_url;

var marc_view_reset = true;
var marc_edit_reset = true;
var copy_browser_reset = true;
var hold_browser_reset = true;
var serctrl_view_reset = true;

function $(id) { return document.getElementById(id); }

function my_init() {
    try {
        netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
        if (typeof JSAN == 'undefined') { throw(document.getElementById('offlineStrings').getString('common.jsan.missing')); }
        JSAN.errorLevel = "die"; // none, warn, or die
        JSAN.addRepository('..');
        JSAN.use('util.error'); g.error = new util.error();
        g.error.sdump('D_TRACE','my_init() for cat/opac.xul');

        JSAN.use('OpenILS.data'); g.data = new OpenILS.data(); g.data.init({'via':'stash'});
        XML_HTTP_SERVER = g.data.server_unadorned;

        // Pull in local customizations
        var r = new XMLHttpRequest();
        r.open("GET", xulG.url_prefix('/xul/server/skin/custom.js'), false);
        r.send(null);
        if (r.status == 200) {
            dump('Evaluating /xul/server/skin/custom.js\n');
            eval( r.responseText );
        }

        window.help_context_set_locally = true;

        JSAN.use('util.network'); g.network = new util.network();

        g.cgi = new CGI();
        try { authtime = g.cgi.param('authtime') || xulG.authtime; } catch(E) { g.error.sdump('D_ERROR',E); }
        try { docid = g.cgi.param('docid') || xulG.docid; } catch(E) { g.error.sdump('D_ERROR',E); }
        try { opac_url = g.cgi.param('opac_url') || xulG.opac_url; } catch(E) { g.error.sdump('D_ERROR',E); }
        try { g.view_override = g.cgi.param('default_view') || xulG.default_view; } catch(E) { g.error.sdump('D_ERROR',E); }

        JSAN.use('util.deck');
        top_pane = new util.deck('top_pane');
        bottom_pane = new util.deck('bottom_pane');

        set_opac();

    } catch(E) {
        var err_msg = document.getElementById("offlineStrings").getFormattedString("common.exception", ["cat/opac.xul", E]);
        try { g.error.sdump('D_ERROR',err_msg); } catch(E) { dump(err_msg); }
        alert(err_msg);
    }
}

function default_focus() {
    opac_wrapper_set_help_context(); 
}

function opac_wrapper_set_help_context() {
    try {
        dump('Entering opac.js, opac_wrapper_set_help_context\n');
        var cw = bottom_pane.get_contentWindow(); 
        if (cw && typeof cw['location'] != 'undefined') {
            if (typeof cw.help_context_set_locally == 'undefined') {
                var help_params = {
                    'protocol' : cw.location.protocol,
                    'hostname' : cw.location.hostname,
                    'port' : cw.location.port,
                    'pathname' : cw.location.pathname,
                    'src' : ''
                };
                xulG.set_help_context(help_params);
            } else {
                dump('\tcw.help_context_set_locally = ' + cw.help_context_set_locally + '\n');
                if (typeof cw.default_focus == 'function') {
                    cw.default_focus();
                }
            }
        } else {
            dump('opac.js: problem in opac_wrapper_set_help_context(): bottom_pane = ' + bottom_pane + ' cw = ' + cw + '\n');
            dump('\tcw.location = ' + cw.location + '\n');
        }
    } catch(E) {
        // We can expect some errors here if this called before the DOM is ready.  Easiest to just trap and ignore
        dump('Error in opac.js, opac_wrapper_set_help_context(): ' + E + '\n');
    }
}

function set_brief_view() {
    var url = xulG.url_prefix( urls.XUL_BIB_BRIEF ) + '?docid=' + window.escape(docid); 
    dump('spawning ' + url + '\n');
    top_pane.set_iframe( 
        url,
        {}, 
        { 
            'set_tab_name' : function(n) { 
                if (typeof window.xulG == 'object' && typeof window.xulG.set_tab_name == 'function') {
                    try { window.xulG.set_tab_name(document.getElementById('offlineStrings').getFormattedString("cat.bib_record", [n])); } catch(E) { alert(E); }
                } else {
                    dump('no set_tab_name\n');
                }
            }
        }  
    );
}

function set_marc_view() {
    g.view = 'marc_view';
    if (marc_view_reset) {
        bottom_pane.reset_iframe( xulG.url_prefix( urls.XUL_MARC_VIEW ) + '?docid=' + window.escape(docid),{},xulG);
        marc_view_reset = false;
    } else {
        bottom_pane.set_iframe( xulG.url_prefix( urls.XUL_MARC_VIEW ) + '?docid=' + window.escape(docid),{},xulG);
    }
    opac_wrapper_set_help_context(); 
    bottom_pane.get_contentWindow().addEventListener('load',opac_wrapper_set_help_context,false);
}

function set_marc_edit() {
    g.view = 'marc_edit';
    var a =    xulG.url_prefix( urls.XUL_MARC_EDIT );
    var b =    {};
    var c =    {
            'record' : { 'url' : '/opac/extras/supercat/retrieve/marcxml/record/' + docid, "id": docid, "rtype": "bre" },
            'fast_add_item' : function(doc_id,cn_label,cp_barcode) {
                try {
                    var cat = { util: {} }; /* FIXME: kludge since we can't load remote JSAN libraries into chrome */
                    cat.util.spawn_copy_editor = function(params) {
                        try {
                            if (!params.copy_ids && !params.copies) return;
                            if (params.copy_ids && params.copy_ids.length == 0) return;
                            if (params.copies && params.copies.length == 0) return;
                            if (params.copy_ids) params.copy_ids = js2JSON(params.copy_ids); // legacy
                            if (!params.caller_handles_update) params.handle_update = 1; // legacy

                            var obj = {};
                            JSAN.use('util.network'); obj.network = new util.network();
                            JSAN.use('util.error'); obj.error = new util.error();
                        
                            var title = '';
                            if (params.copy_ids && params.copy_ids.length > 1 && params.edit == 1)
                                title = $("offlineStrings").getString('staff.cat.util.copy_editor.batch_edit');
                            else if(params.copies && params.copies.length > 1 && params.edit == 1)
                                title = $("offlineStrings").getString('staff.cat.util.copy_editor.batch_view');
                            else if(params.copy_ids && params.copy_ids.length == 1)
                                title = $("offlineStrings").getString('staff.cat.util.copy_editor.edit');
                            else
                                title = $("offlineStrings").getString('staff.cat.util.copy_editor.view');

                            JSAN.use('util.window'); var win = new util.window();
                            var my_xulG = win.open(
                                (urls.XUL_COPY_EDITOR),
                                title,
                                'chrome,modal,resizable',
                                params
                            );
                            if (!my_xulG.copies && params.edit) {
                            } else {
                                return my_xulG.copies;
                            }
                            return [];
                        } catch(E) {
                            JSAN.use('util.error'); var error = new util.error();
                            error.standard_unexpected_error_alert('Error in chrome/content/cat/opac.js, cat.util.spawn_copy_editor',E);
                        }
                    }
                    cat.util.fast_item_add = function(doc_id,cn_label,cp_barcode) {
                        var error;
                        try {

                            JSAN.use('util.error'); error = new util.error();
                            JSAN.use('util.network'); var network = new util.network();

                            var acn_id = network.simple_request(
                                'FM_ACN_FIND_OR_CREATE',
                                [ ses(), cn_label, doc_id, ses('ws_ou') ]
                            );

                            if (typeof acn_id.ilsevent != 'undefined') {
                                error.standard_unexpected_error_alert('Error in chrome/content/cat/opac.js, cat.util.fast_item_add', acn_id);
                                return;
                            }

                            var copy_obj = new acp();
                            copy_obj.id( -1 );
                            copy_obj.isnew('1');
                            copy_obj.barcode( cp_barcode );
                            copy_obj.call_number( acn_id );
                            copy_obj.circ_lib( ses('ws_ou') );
                            /* FIXME -- use constants */
                            copy_obj.deposit(0);
                            copy_obj.price(0);
                            copy_obj.deposit_amount(0);
                            copy_obj.fine_level(2);
                            copy_obj.loan_duration(2);
                            copy_obj.location(1);
                            copy_obj.status(0);
                            copy_obj.circulate(get_db_true());
                            copy_obj.holdable(get_db_true());
                            copy_obj.opac_visible(get_db_true());
                            copy_obj.ref(get_db_false());

                            JSAN.use('util.window'); var win = new util.window();
                            return cat.util.spawn_copy_editor( { 'handle_update' : 1, 'edit' : 1, 'docid' : doc_id, 'copies' : [ copy_obj ] });

                        } catch(E) {
                            if (error) error.standard_unexpected_error_alert('Error in chrome/content/cat/opac.js, cat.util.fast_item_add #2',E); else alert('FIXME: ' + E);
                        }
                    }
                    return cat.util.fast_item_add(doc_id,cn_label,cp_barcode);
                } catch(E) {
                    alert('Error in chrome/content/cat/opac.js, set_marc_edit, fast_item_add: ' + E);
                }
            },
            'save' : {
                'label' : document.getElementById('offlineStrings').getString('cat.save_record'),
                'func' : function (new_marcxml) {
                    try {
                        var r = g.network.simple_request('MARC_XML_RECORD_UPDATE', [ ses(), docid, new_marcxml ]);
                        marc_view_reset = true;
                        copy_browser_reset = true;
                        hold_browser_reset = true;
                        if (typeof r.ilsevent != 'undefined') {
                            throw(r);
                        } else {
                            return {
                                'id' : r.id(),
                                'oncomplete' : function() {}
                            };
                        }
                    } catch(E) {
                            g.error.standard_unexpected_error_alert(document.getElementById('offlineStrings').getString("cat.save.failure"), E);
                    }
                }
            }
        };
    if (marc_edit_reset) {
        bottom_pane.reset_iframe( a,b,c );
        marc_edit_reset = false;
    } else {
        bottom_pane.set_iframe( a,b,c );
    }
    opac_wrapper_set_help_context(); 
    bottom_pane.get_contentWindow().addEventListener('load',opac_wrapper_set_help_context,false);
}

function set_copy_browser() {
    g.view = 'copy_browser';
    if (copy_browser_reset) {
        bottom_pane.reset_iframe( xulG.url_prefix( urls.XUL_COPY_VOLUME_BROWSE ) + '?docid=' + window.escape(docid),{},xulG);
        copy_browser_reset =false;
    } else {
        bottom_pane.set_iframe( xulG.url_prefix( urls.XUL_COPY_VOLUME_BROWSE ) + '?docid=' + window.escape(docid),{},xulG);
    }
    opac_wrapper_set_help_context(); 
    bottom_pane.get_contentWindow().addEventListener('load',opac_wrapper_set_help_context,false);
}

function set_hold_browser() {
    g.view = 'hold_browser';
    if (hold_browser_reset) {
        bottom_pane.reset_iframe( xulG.url_prefix( urls.XUL_HOLDS_BROWSER ) + '?docid=' + window.escape(docid),{},xulG);
        hold_browser_reset = false;
    } else {
        bottom_pane.set_iframe( xulG.url_prefix( urls.XUL_HOLDS_BROWSER ) + '?docid=' + window.escape(docid),{},xulG);
    }
    opac_wrapper_set_help_context(); 
    bottom_pane.get_contentWindow().addEventListener('load',opac_wrapper_set_help_context,false);
}


function open_acq_orders() {
    try {
        var content_params = {
            "session": ses(),
            "authtime": ses("authtime"),
            "no_xulG": false,
            "show_nav_buttons": true,
            "show_print_button": false
        };

        ["url_prefix", "new_tab", "set_tab", "close_tab", "new_patron_tab",
            "set_patron_tab", "volume_item_creator", "get_new_session",
            "holdings_maintenance_tab", "set_tab_name", "open_chrome_window",
            "url_prefix", "network_meter", "page_meter", "set_statusbar",
            "set_help_context"
        ].forEach(function(k) { content_params[k] = xulG[k]; });

        var loc = urls.XUL_BROWSER + "?url=" + window.escape(
            xulG.url_prefix("/eg/acq/lineitem/related/") +
            docid + "?target=bib"
        );
        xulG.new_tab(
            loc, {
                "tab_name": $("offlineStrings").getString(
                    "staff.cat.opac.related_items"
                ),
                "browser": false
            }, content_params
        );
    } catch (E) {
        g.error.sdump("D_ERROR", E);
    }
}

function set_opac() {
    g.view = 'opac';
    try {
        var content_params = { 
            'show_nav_buttons' : true,
            'show_print_button' : true,
            'passthru_content_params' : { 
                'authtoken' : ses(), 
                'authtime' : ses('authtime'),
                'window_open' : function(a,b,c) {
                    try {
                        netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect UniversalBrowserWrite');
                        return window.open(a,b,c);
                    } catch(E) {
                        g.error.standard_unexpected_error_alert('window_open',E);
                    }
                }
            },
            'on_url_load' : function(f) {
                netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
                var win;
                try {
                    if (typeof f.contentWindow.wrappedJSObject.attachEvt != 'undefined') {
                        win = f.contentWindow.wrappedJSObject;
                    } else {
                        win = f.contentWindow;
                    }
                } catch(E) {
                    win = f.contentWindow;
                }
                win.attachEvt("rdetail", "recordRetrieved",
                    function(id){
                        try {
                            if (docid == id) return;
                            docid = id;
                            refresh_display(id);
                        } catch(E) {
                            g.error.standard_unexpected_error_alert('rdetail -> recordRetrieved',E);
                        }
                    }
                );
                
                g.f_record_start = null; g.f_record_prev = null; g.f_record_next = null; g.f_record_end = null;
                $('record_start').disabled = true; $('record_next').disabled = true;
                $('record_prev').disabled = true; $('record_end').disabled = true;
                $('record_pos').setAttribute('value','');

                win.attachEvt("rdetail", "nextPrevDrawn",
                    function(rIndex,rCount){
                        $('record_pos').setAttribute('value', document.getElementById('offlineStrings').getFormattedString('cat.record.counter', [(1+rIndex), rCount ? rCount : 1]));
                        if (win.rdetailNext) {
                            g.f_record_next = function() { 
                                g.view_override = g.view; 
                                win.rdetailNext(); 
                            }
                            $('record_next').disabled = false;
                        }
                        if (win.rdetailPrev) {
                            g.f_record_prev = function() { 
                                g.view_override = g.view; 
                                win.rdetailPrev(); 
                            }
                            $('record_prev').disabled = false;
                        }
                        if (win.rdetailStart) {
                            g.f_record_start = function() { 
                                g.view_override = g.view; 
                                win.rdetailStart(); 
                            }
                            $('record_start').disabled = false;
                        }
                        if (win.rdetailEnd) {
                            g.f_record_end = function() { 
                                g.view_override = g.view; 
                                win.rdetailEnd(); 
                            }
                            $('record_end').disabled = false;
                        }
                    }
                );

                $('mfhd_add').setAttribute('oncommand','create_mfhd()');
                var mfhd_edit_menu = $('mfhd_edit');
                var mfhd_delete_menu = $('mfhd_delete');

                // clear menus on subsequent loads
                if (mfhd_edit_menu.firstChild) {
                    mfhd_edit_menu.removeChild(mfhd_edit_menu.firstChild);
                    mfhd_delete_menu.removeChild(mfhd_delete_menu.firstChild);
                }

                mfhd_edit_menu.disabled = true;
                mfhd_delete_menu.disabled = true;

                win.attachEvt("rdetail", "MFHDDrawn",
                    function() {
                        if (win.mfhdDetails && win.mfhdDetails.length > 0) {
                            g.mfhd = {};
                            g.mfhd.details = win.mfhdDetails;
                            mfhd_edit_menu.disabled = false;
                            mfhd_delete_menu.disabled = false;
                            for (var i = 0; i < win.mfhdDetails.length; i++) {
                                var mfhd_details = win.mfhdDetails[i];
                                var num = mfhd_details.entryNum;
                                num++;
                                var label = mfhd_details.label + ' (' + num + ')';
                                var item = mfhd_edit_menu.appendItem(label);
                                item.setAttribute('oncommand','open_mfhd_editor('+mfhd_details.id+')');
                                item = mfhd_delete_menu.appendItem(label);
                                item.setAttribute('oncommand','delete_mfhd('+mfhd_details.id+')');
                            }
                        }
                    }
                );
            },
            'url_prefix' : xulG.url_prefix,
        };
        content_params.new_tab = xulG.new_tab;
        content_params.set_tab = xulG.set_tab;
        content_params.close_tab = xulG.close_tab;
        content_params.new_patron_tab = xulG.new_patron_tab;
        content_params.set_patron_tab = xulG.set_patron_tab;
        content_params.volume_item_creator = xulG.volume_item_creator;
        content_params.get_new_session = xulG.get_new_session;
        content_params.holdings_maintenance_tab = xulG.holdings_maintenance_tab;
        content_params.set_tab_name = xulG.set_tab_name;
        content_params.open_chrome_window = xulG.open_chrome_window;
        content_params.url_prefix = xulG.url_prefix;
        content_params.network_meter = xulG.network_meter;
        content_params.page_meter = xulG.page_meter;
        content_params.set_statusbar = xulG.set_statusbar;
        content_params.set_help_context = xulG.set_help_context;

        if (opac_url) { content_params.url = opac_url; } else { content_params.url = xulG.url_prefix( urls.browser ); }
        browser_frame = bottom_pane.set_iframe( xulG.url_prefix(urls.XUL_BROWSER) + '?name=Catalog', {}, content_params);
        /* // Remember to use the REMOTE_BROWSER if we ever try to move this to remote xul again
        browser_frame = bottom_pane.set_iframe( xulG.url_prefix(urls.XUL_REMOTE_BROWSER) + '?name=Catalog', {}, content_params);
        */
    } catch(E) {
        g.error.sdump('D_ERROR','set_opac: ' + E);
    }
    opac_wrapper_set_help_context(); 
    bottom_pane.get_contentWindow().addEventListener('load',opac_wrapper_set_help_context,false);
}

function set_serctrl_view() {
    g.view = 'serctrl_view';
    if (serctrl_view_reset) {
        bottom_pane.reset_iframe( xulG.url_prefix( urls.XUL_SERIAL_SERCTRL_MAIN ) + '?docid=' + window.escape(docid), {}, xulG);
        serctrl_view_reset =false;
    } else {
        bottom_pane.set_iframe( xulG.url_prefix( urls.XUL_SERIAL_SERCTRL_MAIN ) + '?docid=' + window.escape(docid), {}, xulG);
    }
}

function create_mfhd() {
    try {
        g.data.create_mfhd_aou = '';
        JSAN.use('util.window'); var win = new util.window();
        win.open(
            xulG.url_prefix(urls.XUL_SERIAL_SELECT_AOU),
            'sel_bucket_win' + win.window_name_increment(),
            'chrome,resizable,modal,centerscreen'
        );
        if (!g.data.create_mfhd_aou) {
            return;
        }
        var r = g.network.simple_request(
                'MFHD_XML_RECORD_CREATE',
                [ ses(), 1, g.data.create_mfhd_aou, docid ]
            );
        if (typeof r.ilsevent != 'undefined') {
            throw(r);
        }
        alert("MFHD record created."); //TODO: better success message
        //TODO: refresh opac display
    } catch(E) {
        g.error.standard_unexpected_error_alert("Create MFHD failed", E); //TODO: better error handling
    }
}

function delete_mfhd(sre_id) {
    if (g.error.yns_alert(
        document.getElementById('offlineStrings').getFormattedString('serial.delete_record.confirm', [sre_id]),
        document.getElementById('offlineStrings').getString('cat.opac.delete_record'),
        document.getElementById('offlineStrings').getString('cat.opac.delete'),
        document.getElementById('offlineStrings').getString('cat.opac.cancel'),
        null,
        document.getElementById('offlineStrings').getString('cat.opac.record_deleted.confirm')) == 0) {
        var robj = g.network.request(
                'open-ils.permacrud',
                'open-ils.permacrud.delete.sre',
                [ses(),sre_id]);
        if (typeof robj.ilsevent != 'undefined') {
            alert(document.getElementById('offlineStrings').getFormattedString('cat.opac.record_deleted.error',  [docid, robj.textcode, robj.desc]) + '\n');
        } else {
            alert(document.getElementById('offlineStrings').getString('cat.opac.record_deleted'));
            //TODO: refresh opac display
        }
    }
}

function open_mfhd_editor(sre_id) {
    try {
        var r = g.network.simple_request(
                'FM_SRE_RETRIEVE',
                [ ses(), sre_id ]
              );
        if (typeof r.ilsevent != 'undefined') {
            throw(r);
        }
        open_marc_editor(r, 'MFHD');
    } catch(E) {
        g.error.standard_unexpected_error_alert("Create MFHD failed", E); //TODO: better error handling
    }
}

function open_marc_editor(rec, label) {
    win = window.open( xulG.url_prefix('/xul/server/cat/marcedit.xul') );

    win.xulG = {
        record : {marc : rec.marc()},
        save : {
            label: 'Save ' + label,
            func: function(xmlString) {  // TODO: switch to pcrud, or define an sre update method in Serial.pm?
                var method = 'open-ils.permacrud.update.' + rec.classname;
                rec.marc(xmlString);
                g.network.request(
                    'open-ils.permacrud', method,
                    [ses(), rec]
                );
            }
        }
    };
}

function serials_mgmt_new_tab() {
    try {
        /* XXX should the following be put into a function somewhere? the gist
         * of this setting up of content_params seems to be duplicated all
         * over the place.
         */
        var content_params = {"session": ses(), "authtime": ses("authtime")};
        ["url_prefix", "new_tab", "set_tab", "close_tab", "new_patron_tab",
            "set_patron_tab", "volume_item_creator", "get_new_session",
            "holdings_maintenance_tab", "set_tab_name", "open_chrome_window",
            "url_prefix", "network_meter", "page_meter", "set_statusbar",
            "set_help_context"
        ].forEach(function(k) { content_params[k] = xulG[k]; });

        xulG.new_tab(
            xulG.url_prefix(urls.XUL_SERIAL_RECORD_ENTRY), {}, content_params
        );
    } catch (E) {
        g.error.sdump('D_ERROR', E);
    }
}

function bib_in_new_tab() {
    try {
        var url = browser_frame.contentWindow.g.browser.controller.view.browser_browser.contentWindow.wrappedJSObject.location.href;
        var content_params = { 'session' : ses(), 'authtime' : ses('authtime'), 'opac_url' : url };
        content_params.url_prefix = xulG.url_prefix;
        content_params.new_tab = xulG.new_tab;
        content_params.set_tab = xulG.set_tab;
        content_params.close_tab = xulG.close_tab;
        content_params.new_patron_tab = xulG.new_patron_tab;
        content_params.set_patron_tab = xulG.set_patron_tab;
        content_params.volume_item_creator = xulG.volume_item_creator;
        content_params.get_new_session = xulG.get_new_session;
        content_params.holdings_maintenance_tab = xulG.holdings_maintenance_tab;
        content_params.set_tab_name = xulG.set_tab_name;
        content_params.open_chrome_window = xulG.open_chrome_window;
        content_params.url_prefix = xulG.url_prefix;
        content_params.network_meter = xulG.network_meter;
        content_params.page_meter = xulG.page_meter;
        content_params.set_statusbar = xulG.set_statusbar;
        content_params.set_help_context = xulG.set_help_context;

        xulG.new_tab(xulG.url_prefix(urls.XUL_OPAC_WRAPPER), {}, content_params);
    } catch(E) {
        g.error.sdump('D_ERROR',E);
    }
}

function batch_receive_in_new_tab() {
    try {
        var content_params = {"session": ses(), "authtime": ses("authtime")};

        ["url_prefix", "new_tab", "set_tab", "close_tab", "new_patron_tab",
            "set_patron_tab", "volume_item_creator", "get_new_session",
            "holdings_maintenance_tab", "set_tab_name", "open_chrome_window",
            "url_prefix", "network_meter", "page_meter", "set_statusbar",
            "set_help_context"
        ].forEach(function(k) { content_params[k] = xulG[k]; });

        xulG.new_tab(
            xulG.url_prefix(urls.XUL_SERIAL_BATCH_RECEIVE) +
                "?docid=" + window.escape(docid), {
                "tab_name": $("offlineStrings").getString(
                    "menu.cmd_serial_batch_receive.tab"
                )
            }, content_params
        );
    } catch (E) {
        g.error.sdump("D_ERROR", E);
    }
}

function remove_me() {
    var url = xulG.url_prefix( urls.XUL_BIB_BRIEF ) + '?docid=' + window.escape(docid);
    dump('removing ' + url + '\n');
    try { top_pane.remove_iframe( url ); } catch(E) { dump(E + '\n'); }
    $('nav').setAttribute('hidden','true');
}

function add_to_bucket() {
    JSAN.use('util.window'); var win = new util.window();
    win.open(
        xulG.url_prefix(urls.XUL_RECORD_BUCKETS_QUICK),
        'sel_bucket_win' + win.window_name_increment(),
        'chrome,resizable,modal,centerscreen',
        {
            record_ids: [ docid ]
        }
    );
}

function mark_for_overlay() {
    g.data.marked_record = docid;
    g.data.stash('marked_record');
    var robj = g.network.simple_request('MODS_SLIM_RECORD_RETRIEVE.authoritative',[docid]);
    if (typeof robj.ilsevent == 'undefined') {
        g.data.marked_record_mvr = robj;
    } else {
        g.data.marked_record_mvr = null;
        g.error.standard_unexpected_error_alert('in mark_for_overlay',robj);
    }
    g.data.stash('marked_record_mvr');
    if (g.data.marked_record_mvr) {
        alert(document.getElementById('offlineStrings').getFormattedString('cat.opac.record_marked_for_overlay.tcn.alert',[ g.data.marked_record_mvr.tcn() ]));
        xulG.set_statusbar(1, $("offlineStrings").getFormattedString('staff.cat.z3950.marked_record_for_overlay_indicator.tcn.label',[g.data.marked_record_mvr.tcn()]) );
    } else {
        alert(document.getElementById('offlineStrings').getFormattedString('cat.opac.record_marked_for_overlay.record_id.alert',[ g.data.marked_record  ]));
        xulG.set_statusbar(1, $("offlineStrings").getFormattedString('staff.cat.z3950.marked_record_for_overlay_indicator.record_id.label',[g.data.marked_record]) );
    }
}

function mark_for_hold_transfer() {
    g.data.marked_record_for_hold_transfer = docid;
    g.data.stash('marked_record_for_hold_transfer');
    var robj = g.network.simple_request('MODS_SLIM_RECORD_RETRIEVE.authoritative',[docid]);
    if (typeof robj.ilsevent == 'undefined') {
        g.data.marked_record_for_hold_transfer_mvr = robj;
    } else {
        g.data.marked_record_for_hold_transfer_mvr = null;
        g.error.standard_unexpected_error_alert('in mark_for_hold_transfer',robj);
    }
    g.data.stash('marked_record_for_hold_transfer_mvr');
    if (g.data.marked_record_mvr) {
        var m = $("offlineStrings").getFormattedString('staff.cat.opac.marked_record_for_hold_transfer_indicator.tcn.label',[g.data.marked_record_for_hold_transfer_mvr.tcn()]);
        alert(m); xulG.set_statusbar(1, m );
    } else {
        var m = $("offlineStrings").getFormattedString('staff.cat.opac.marked_record_for_hold_transfer_indicator.record_id.label',[g.data.marked_record_for_hold_transfer]);
        alert(m); xulG.set_statusbar(1, m );
    }
}

function transfer_title_holds() {
    g.data.stash_retrieve();
    var target = g.data.marked_record_for_hold_transfer;
    if (!target) {
        var m = $("offlineStrings").getString('staff.cat.opac.title_for_hold_transfer.destination_needed.label');
        alert(m);
        return;
    }
    var robj = g.network.simple_request('TRANSFER_TITLE_HOLDS',[ ses(), target, [ docid ] ]);
    if (robj == 1) {
        var m = $("offlineStrings").getString('staff.cat.opac.title_for_hold_transfer.success.label');
        alert(m);
    } else {
        var m = $("offlineStrings").getString('staff.cat.opac.title_for_hold_transfer.failure.label');
        alert(m);
    }
    hold_browser_reset = true;
    if (g.view == 'hold_browser') { set_hold_browser(); };
}

function delete_record() {
    if (g.error.yns_alert(
        document.getElementById('offlineStrings').getFormattedString('cat.opac.delete_record.confirm', [docid]),
        document.getElementById('offlineStrings').getString('cat.opac.delete_record'),
        document.getElementById('offlineStrings').getString('cat.opac.delete'),
        document.getElementById('offlineStrings').getString('cat.opac.cancel'),
        null,
        document.getElementById('offlineStrings').getString('cat.opac.record_deleted.confirm')) == 0) {
        var robj = g.network.simple_request('FM_BRE_DELETE',[ses(),docid]);
        if (typeof robj.ilsevent != 'undefined') {
            alert(document.getElementById('offlineStrings').getFormattedString('cat.opac.record_deleted.error',  [docid, robj.textcode, robj.desc]) + '\n');
        } else {
            alert(document.getElementById('offlineStrings').getString('cat.opac.record_deleted'));
            refresh_display(docid);
        }
    }
}

function undelete_record() {
    if (g.error.yns_alert(
        document.getElementById('offlineStrings').getFormattedString('cat.opac.undelete_record.confirm', [docid]),
        document.getElementById('offlineStrings').getString('cat.opac.undelete_record'),
        document.getElementById('offlineStrings').getString('cat.opac.undelete'),
        document.getElementById('offlineStrings').getString('cat.opac.cancel'),
        null,
        document.getElementById('offlineStrings').getString('cat.opac.record_undeleted.confirm')) == 0) {

        var robj = g.network.simple_request('FM_BRE_UNDELETE',[ses(),docid]);
        if (typeof robj.ilsevent != 'undefined') {
            alert(document.getElementById('offlineStrings').getFormattedString('cat.opac.record_undeleted.error',  [docid, robj.textcode, robj.desc]) + '\n');
        } else {
            alert(document.getElementById('offlineStrings').getString('cat.opac.record_undeleted'));
            refresh_display(docid);
        }
    }
}

function refresh_display(id) {
    try { 
        marc_view_reset = true;
        marc_edit_reset = true;
        copy_browser_reset = true;
        hold_browser_reset = true;
        while(top_pane.node.lastChild) top_pane.node.removeChild( top_pane.node.lastChild );
        var children = bottom_pane.node.childNodes;
        for (var i = 0; i < children.length; i++) {
            if (children[i] != browser_frame) bottom_pane.node.removeChild(children[i]);
        }

        set_brief_view();
        $('nav').setAttribute('hidden','false');
        var settings = g.network.simple_request(
            'FM_AUS_RETRIEVE',
            [ ses(), g.data.list.au[0].id() ]
        );
        var view = settings['staff_client.catalog.record_view.default'];
        if (g.view_override) {
            view = g.view_override;
            g.view_override = null;
        }
        switch(view) {
            case 'marc_view' : set_marc_view(); break;
            case 'marc_edit' : set_marc_edit(); break;
            case 'copy_browser' : set_copy_browser(); break;
            case 'hold_browser' : set_hold_browser(); break;
            case 'serctrl_view' : set_serctrl_view(); break;
            case 'opac' :
            default: set_opac(); break;
        }
        opac_wrapper_set_help_context(); 
    } catch(E) {
        g.error.standard_unexpected_error_alert('in refresh_display',E);
    }
}

function set_default() {
    var robj = g.network.simple_request(
        'FM_AUS_UPDATE',
        [ ses(), g.data.list.au[0].id(), { 'staff_client.catalog.record_view.default' : g.view } ]
    )
    if (typeof robj.ilsevent != 'undefined') {
        if (robj.ilsevent != 0) g.error.standard_unexpected_error_alert(document.getElementById('offlineStrings').getString('cat.preference.error'), robj);
    }
}

function add_volumes() {
    try {
        var edit = 0;
        try {
            edit = g.network.request(
                api.PERM_MULTI_ORG_CHECK.app,
                api.PERM_MULTI_ORG_CHECK.method,
                [ 
                    ses(), 
                    ses('staff_id'), 
                    [ ses('ws_ou') ],
                    [ 'CREATE_VOLUME', 'CREATE_COPY' ]
                ]
            ).length == 0 ? 1 : 0;
        } catch(E) {
            g.error.sdump('D_ERROR','batch permission check: ' + E);
        }

        if (edit==0) {
            alert(document.getElementById('offlineStrings').getString('staff.circ.copy_status.add_volumes.perm_failure'));
            return; // no read-only view for this interface
        }

        var title = document.getElementById('offlineStrings').getFormattedString('staff.circ.copy_status.add_volumes.title', [docid]);

        JSAN.use('util.window'); var win = new util.window();
        var w = win.open(
            window.xulG.url_prefix(urls.XUL_VOLUME_COPY_CREATOR),
            title,
            'chrome,resizable',
            { 'doc_id' : docid, 'ou_ids' : [ ses('ws_ou') ] }
        );
    } catch(E) {
        alert('Error in chrome/content/cat/opac.js, add_volumes(): ' + E);
    }
}
