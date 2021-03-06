dump('entering main/menu.js\n');
// vim:noet:sw=4:ts=4:

var offlineStrings;

if (typeof main == 'undefined') main = {};
main.menu = function () {

    netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
    offlineStrings = document.getElementById('offlineStrings');
    JSAN.use('util.error'); this.error = new util.error();
    JSAN.use('util.window'); this.window = new util.window();
    JSAN.use('OpenILS.data'); this.data = new OpenILS.data(); this.data.init({'via':'stash'});

    this.w = window;
    var x = document.getElementById('network_progress');
    x.setAttribute('count','0');
    x.addEventListener(
        'click',
        function() {
            if ( window.confirm(offlineStrings.getString('menu.reset_network_stats')) ) {
                var y = document.getElementById('network_progress_rows');
                while(y.firstChild) { y.removeChild( y.lastChild ); }
                x.setAttribute('mode','determined');
                x.setAttribute('count','0');
            }
        },
        false
    );

    if (xulG.pref.getBoolPref('open-ils.disable_accesskeys_on_tabs')) {
        var tabs = document.getElementById('main_tabs');
        for (var i = 0; i < tabs.childNodes.length; i++) {
            tabs.childNodes[i].setAttribute('accesskey','');
        }
    }

    if (xulG.pref.getBoolPref('open-ils.enable_join_tabs')) {
        document.getElementById('join_tabs_menuitem_vertical').hidden = false;
        document.getElementById('join_tabs_menuitem_horizontal').hidden = false;
    }
}

main.menu.prototype = {

    'id_incr' : 0,

    'url_prefix' : function(url) {
        if (url.match(/^\//)) url = urls.remote + url;
        if (! url.match(/^(http|chrome):\/\//) && ! url.match(/^data:/) ) url = 'http://' + url;
        dump('url_prefix = ' + url + '\n');
        return url;
    },

    'init' : function( params ) {

        urls.remote = params['server'];

        // Pull in local customizations
        var r = new XMLHttpRequest();
        r.open("GET", url_prefix('/xul/server/skin/custom.js'), false);
        r.send(null);
        if (r.status == 200) {
            dump('Evaluating /xul/server/skin/custom.js\n');
            eval( r.responseText );
        }

        var obj = this;

        var button_bar = String( obj.data.hash.aous['ui.general.button_bar'] ) == 'true';
        if (button_bar) {
            var x = document.getElementById('main_toolbar');
            if (x) x.setAttribute('hidden','false');
        }

        var network_meter = String( obj.data.hash.aous['ui.network.progress_meter'] ) == 'true';
        if (! network_meter) {
            var x = document.getElementById('network_progress');
            if (x) x.setAttribute('hidden','true');
            var y = document.getElementById('page_progress');
            if (y) y.setAttribute('hidden','true');
        }

        function open_conify_page(path, labelKey) {

            // tab label
            labelKey = labelKey || 'menu.cmd_open_conify.tab';
            label = offlineStrings.getString(labelKey);

            // URL
            var loc = urls.XUL_BROWSER + '?url=' + window.escape( obj.url_prefix(urls.CONIFY) + '/' + path + '.html');

            obj.set_tab( 
                loc, 
                {'tab_name' : label, 'browser' : false }, 
                {'no_xulG' : false, 'show_print_button' : false, show_nav_buttons:true} 
            );
        }

        function open_admin_page(path, labelKey, addSes) {

            // tab label
            labelKey = labelKey || 'menu.cmd_open_conify.tab';
            label = offlineStrings.getString(labelKey);

            // URL
            var loc = urls.XUL_BROWSER + '?url=' + window.escape( obj.url_prefix(urls.XUL_LOCAL_ADMIN_BASE) + '/' + path);
            if(addSes) loc += window.escape('?ses=' + ses());

            obj.set_tab( 
                loc, 
                {'tab_name' : label, 'browser' : false }, 
                {'no_xulG' : false, 'show_print_button' : true, 'show_nav_buttons' : true } 
            );
        }


        function open_eg_web_page(path, labelKey) {
            
            // tab label
            labelKey = labelKey || 'menu.cmd_open_conify.tab';
            var label = offlineStrings.getString(labelKey);

            // URL
            var loc = urls.XUL_BROWSER + '?url=' + window.escape(obj.url_prefix(urls.EG_WEB_BASE) + '/' + path);

            obj.set_tab( 
                loc, 
                {tab_name : label, browser : false }, 
                {no_xulG : false, show_print_button : true, show_nav_buttons : true }
            );
        }

        var cmd_map = {
            'cmd_broken' : [
                ['oncommand'],
                function() { alert(offlineStrings.getString('common.unimplemented')); }
            ],

            /* File Menu */
            'cmd_close_window' : [ 
                ['oncommand'], 
                function() { window.close(); } 
            ],
            'cmd_new_window' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    var mframe = obj.window.open(
                        obj.url_prefix(urls.XUL_MENU_FRAME)
                        + '?server='+window.escape(urls.remote),
                        'main' + obj.window.window_name_increment(),
                        'chrome,resizable'); 
                    netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
                    mframe.xulG = xulG;
                    /* This window should get its own objects for these */
                    delete mframe.xulG['_data'];
                }
            ],
            'cmd_new_tab' : [
                ['oncommand'],
                function() { obj.new_tab(null,{'focus':true},null); }
            ],
            'cmd_join_tabs_vertical' : [
                ['oncommand'],
                function() { obj.join_tabs({'orient':'vertical'}); }
            ],
            'cmd_join_tabs_horizontal' : [
                ['oncommand'],
                function() { obj.join_tabs({'orient':'horizontal'}); }
            ],
            'cmd_close_tab' : [
                ['oncommand'],
                function() { obj.close_tab(); }
            ],
            'cmd_close_all_tabs' : [
                ['oncommand'],
                function() { obj.close_all_tabs(); }
            ],

            /* Edit Menu */
            'cmd_edit_copy_buckets' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_COPY_BUCKETS),{'tab_name':offlineStrings.getString('menu.cmd_edit_copy_buckets.tab')},{});
                }
            ],
            'cmd_edit_volume_buckets' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_VOLUME_BUCKETS),{'tab_name':offlineStrings.getString('menu.cmd_edit_volume_buckets.tab')},{});
                }
            ],
            'cmd_edit_record_buckets' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_RECORD_BUCKETS),{'tab_name':offlineStrings.getString('menu.cmd_edit_record_buckets.tab')},{});
                }
            ],
            'cmd_edit_user_buckets' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_USER_BUCKETS),{'tab_name':offlineStrings.getString('menu.cmd_edit_user_buckets.tab')},{});
                }
            ],


            'cmd_replace_barcode' : [
                ['oncommand'],
                function() {
                    try {
                        JSAN.use('util.network');
                        var network = new util.network();

                        var old_bc = window.prompt(offlineStrings.getString('menu.cmd_replace_barcode.prompt'),'',offlineStrings.getString('menu.cmd_replace_barcode.label'));
                        if (!old_bc) return;
    
                        var copy;
                        try {
                            copy = network.simple_request('FM_ACP_RETRIEVE_VIA_BARCODE',[ old_bc ]);
                            if (typeof copy.ilsevent != 'undefined') throw(copy); 
                            if (!copy) throw(copy);
                        } catch(E) {
                            alert(offlineStrings.getFormattedString('menu.cmd_replace_barcode.retrieval.error', [old_bc]) + '\n');
                            return;
                        }
    
                        // Why did I want to do this twice?  Because this copy is more fleshed?
                        try {
                            copy = network.simple_request('FM_ACP_RETRIEVE',[ copy.id() ]);
                            if (typeof copy.ilsevent != 'undefined') throw(copy);
                            if (!copy) throw(copy);
                        } catch(E) {
                            try { alert(offlineStrings.getFormattedString('menu.cmd_replace_barcode.retrieval.error', [old_bc]) + '\n' + (typeof E.ilsevent == 'undefined' ? '' : E.textcode + ' : ' + E.desc)); } catch(F) { alert(E + '\n' + F); }
                            return;
                        }
    
                        var new_bc = window.prompt(offlineStrings.getString('menu.cmd_replace_barcode.replacement.prompt'),'',offlineStrings.getString('menu.cmd_replace_barcode.replacement.label'));
                        new_bc = String( new_bc ).replace(/\s/g,'');
                        /* Casting a possibly null input value to a String turns it into "null" */
                        if (!new_bc || new_bc == 'null') {
                            alert(offlineStrings.getString('menu.cmd_replace_barcode.blank.error'));
                            return;
                        }
    
                        var test = network.simple_request('FM_ACP_RETRIEVE_VIA_BARCODE',[ new_bc ]);
                        if (typeof test.ilsevent == 'undefined') {
                            alert(offlineStrings.getFormattedString('menu.cmd_replace_barcode.duplicate.error', [new_bc]));
                            return;
                        } else {
                            if (test.ilsevent != 1502 /* ASSET_COPY_NOT_FOUND */) {
                                obj.error.standard_unexpected_error_alert(offlineStrings.getFormattedString('menu.cmd_replace_barcode.testing.error', [new_bc]),test);
                                return;
                            }    
                        }

                        copy.barcode(new_bc); copy.ischanged('1');
                        var r = network.simple_request('FM_ACP_FLESHED_BATCH_UPDATE', [ ses(), [ copy ] ]);
                        if (typeof r.ilsevent != 'undefined') { 
                            if (r.ilsevent != 0) {
                                if (r.ilsevent == 5000 /* PERM_FAILURE */) {
                                    alert(offlineStrings.getString('menu.cmd_replace_barcode.permission.error'));
                                } else {
                                    obj.error.standard_unexpected_error_alert(offlineStrings.getString('menu.cmd_replace_barcode.renaming.error'),r);
                                }
                            }
                        }
                    } catch(E) {
                        obj.error.standard_unexpected_error_alert(offlineStrings.getString('menu.cmd_replace_barcode.renaming.failure'),copy);
                    }
                }
            ],

            /* Search Menu */
            'cmd_patron_search' : [
                ['oncommand'],
                function() {
                    obj.set_patron_tab();
                }
            ],
            'cmd_search_opac' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    var content_params = { 'session' : ses(), 'authtime' : ses('authtime') };
                    obj.set_tab(obj.url_prefix(urls.XUL_OPAC_WRAPPER), {'tab_name':offlineStrings.getString('menu.cmd_search_opac.tab')}, content_params);
                }
            ],
            'cmd_search_tcn' : [
                ['oncommand'],
                function() {
                    var tcn = prompt(offlineStrings.getString('menu.cmd_search_tcn.tab'),'',offlineStrings.getString('menu.cmd_search_tcn.prompt'));

                    function spawn_tcn(r) {
                        for (var i = 0; i < r.count; i++) {
                            var id = r.ids[i];
                            var opac_url = obj.url_prefix( urls.opac_rdetail ) + '?r=' + id;
                            obj.data.stash_retrieve();
                            var content_params = { 
                                'session' : ses(), 
                                'authtime' : ses('authtime'),
                                'opac_url' : opac_url,
                            };
                            if (i == 0) {
                                obj.set_tab(
                                    obj.url_prefix(urls.XUL_OPAC_WRAPPER), 
                                    {'tab_name':tcn}, 
                                    content_params
                                );
                            } else {
                                obj.new_tab(
                                    obj.url_prefix(urls.XUL_OPAC_WRAPPER), 
                                    {'tab_name':tcn}, 
                                    content_params
                                );
                            }
                        }
                    }

                    if (tcn) {
                        JSAN.use('util.network');
                        var network = new util.network();
                        var robj = network.simple_request('FM_BRE_ID_SEARCH_VIA_TCN',[tcn]);
                        if (robj.count != robj.ids.length) throw('FIXME -- FM_BRE_ID_SEARCH_VIA_TCN = ' + js2JSON(robj));
                        if (robj.count == 0) {
                            var robj2 = network.simple_request('FM_BRE_ID_SEARCH_VIA_TCN',[tcn,1]);
                            if (robj2.count == 0) {
                                alert(offlineStrings.getFormattedString('menu.cmd_search_tcn.not_found.error', [tcn]));
                            } else {
                                if ( window.confirm(offlineStrings.getFormattedString('menu.cmd_search_tcn.deleted.error', [tcn])) ) {
                                    spawn_tcn(robj2);
                                }
                            }
                        } else {
                            spawn_tcn(robj);
                        }
                    }
                }
            ],
            'cmd_search_bib_id' : [
                ['oncommand'],
                function() {
                    var bib_id = prompt(offlineStrings.getString('menu.cmd_search_bib_id.tab'),'',offlineStrings.getString('menu.cmd_search_bib_id.prompt'));
                    if (!bib_id) return;

                    var opac_url = obj.url_prefix( urls.opac_rdetail ) + '?r=' + bib_id;
                    var content_params = { 
                        'session' : ses(), 
                        'authtime' : ses('authtime'),
                        'opac_url' : opac_url,
                    };
                    obj.set_tab(
                        obj.url_prefix(urls.XUL_OPAC_WRAPPER), 
                        {'tab_name':'#' + bib_id}, 
                        content_params
                    );
                }
            ],
            'cmd_copy_status' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_COPY_STATUS),{},{});
                }
            ],

            /* Circulation Menu */
            'cmd_patron_register' : [
                ['oncommand'],
                function() {

                    function log_registration(p) {
                        try {
                            obj.error.work_log(
                                document.getElementById('offlineStrings').getFormattedString(
                                    'staff.circ.work_log_patron_registration.message',
                                    [
                                        ses('staff_usrname'),
                                        p.family_name(),
                                        p.card().barcode()
                                    ]
                                ), {
                                    'au_id' : p.id(),
                                    'au_family_name' : p.family_name(),
                                    'au_barcode' : p.card().barcode()
                                }
                            );
                        } catch(E) {
                            obj.error.sdump('D_ERROR','Error with work_logging in menu.js, cmd_patron_register:' + E);
                        }
                    }

                    function spawn_editor(p) {
                        var url = urls.XUL_PATRON_EDIT;
                        var param_count = 0;
                        for (var i in p) {
                            if (param_count++ == 0) url += '?'; else url += '&';
                            url += i + '=' + window.escape(p[i]);
                        }
                        var loc = obj.url_prefix( urls.XUL_BROWSER ) + '?url=' + window.escape( obj.url_prefix(url) );
                        obj.new_tab(
                            loc, 
                            {}, 
                            { 
                                'show_print_button' : true , 
                                'tab_name' : offline.getString('menu.cmd_patron_register.related.tab'),
                                'passthru_content_params' : {
                                    'spawn_search' : function(s) { obj.spawn_search(s); },
                                    'spawn_editor' : spawn_editor,
                                    'on_save' : function(p) { log_registration(p); }
                                }
                            }
                        );
                    }

                    obj.data.stash_retrieve();
                    var loc = obj.url_prefix( urls.XUL_BROWSER ) 
                        + '?url=' + window.escape( obj.url_prefix(urls.XUL_PATRON_EDIT) );
                    obj.set_tab(
                        loc, 
                        {}, 
                        { 
                            'show_print_button' : true , 
                            'tab_name' : offlineStrings.getString('menu.cmd_patron_register.tab'),
                            'passthru_content_params' : {
                                'ses' : ses(),
                                'spawn_search' : function(s) { obj.spawn_search(s); },
                                'spawn_editor' : spawn_editor,
                                'on_save' : function(p) { log_registration(p); }
                            }
                        }
                    );
                }
            ],
            'cmd_staged_patrons' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_STAGED_PATRONS),{'tab_name':offlineStrings.getString('menu.circulation.staged_patrons.tab')},{});
                }
            ],
            'cmd_circ_checkin' : [
                ['oncommand'],
                function() { 
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_CHECKIN),{},{});
                }
            ],
            'cmd_circ_renew' : [
                ['oncommand'],
                function() { 
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_RENEW),{},{});
                }
            ],
            'cmd_circ_checkout' : [
                ['oncommand'],
                function() { 
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_PATRON_BARCODE_ENTRY),{},{});
                }
            ],
            'cmd_circ_hold_capture' : [
                ['oncommand'],
                function() { 
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_CHECKIN)+'?hold_capture=1',{},{});
                }
            ],
            'cmd_browse_holds' : [
                ['oncommand'],
                function() { 
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_HOLDS_BROWSER),{ 'tab_name' : offlineStrings.getString('menu.cmd_browse_holds.tab') },{});
                }
            ],
            'cmd_browse_holds_shelf' : [
                ['oncommand'],
                function() { 
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_HOLDS_BROWSER)+'?shelf=1',{ 'tab_name' : offlineStrings.getString('menu.cmd_browse_holds_shelf.tab') },{});
                }
            ],
            'cmd_circ_hold_pull_list' : [
                ['oncommand'],
                function() { 
                    obj.data.stash_retrieve();
                    var loc = urls.XUL_BROWSER + '?url=' + window.escape(
                        obj.url_prefix(urls.XUL_HOLD_PULL_LIST)
                    );
                    obj.set_tab( loc, {'tab_name' : offlineStrings.getString('menu.cmd_browse_hold_pull_list.tab')}, { 'show_print_button' : true } );
                }
            ],

            'cmd_in_house_use' : [
                ['oncommand'],
                function() { 
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_IN_HOUSE_USE),{},{});
                }
            ],

            'cmd_scan_item_as_missing_pieces' : [
                ['oncommand'],
                function() { 
                    xulG.window.open(obj.url_prefix(urls.XUL_SCAN_ITEM_AS_MISSING_PIECES),'scan_missing_pieces','chrome'); 
                }
            ],

            'cmd_standalone' : [
                ['oncommand'],
                function() { 
                    obj.set_tab(obj.url_prefix(urls.XUL_STANDALONE),{},{});
                }
            ],

            'cmd_local_admin' : [
                ['oncommand'],
                function() { 
                    //obj.set_tab(obj.url_prefix(urls.XUL_LOCAL_ADMIN)+'?ses='+window.escape(ses())+'&session='+window.escape(ses()),{},{});
                    var loc = urls.XUL_BROWSER + '?url=' + window.escape(
                        obj.url_prefix( urls.XUL_LOCAL_ADMIN+'?ses='+window.escape(ses())+'&session='+window.escape(ses()) )
                    );
                    obj.set_tab( 
                        loc, 
                        {'tab_name' : offlineStrings.getString('menu.cmd_local_admin.tab'), 'browser' : false }, 
                        { 'no_xulG' : false, 'show_nav_buttons' : true, 'show_print_button' : true } 
                    );

                }
            ],

            'cmd_toggle_buttonbar' : [
                ['oncommand'],
                function() {
                    var x = document.getElementById('main_toolbar');
                    if (x) x.hidden = ! x.hidden;
                }
            ],

            'cmd_toggle_meters' : [
                ['oncommand'],
                function() {
                    var x = document.getElementById('network_progress');
                    if (x) x.hidden = ! x.hidden;
                    var y = document.getElementById('page_progress');
                    if (y) y.hidden = ! y.hidden;
                }
            ],

            'cmd_local_admin_reports' : [
                ['oncommand'],
                function() { 
                    var loc = urls.XUL_BROWSER + '?url=' + window.escape( obj.url_prefix(urls.XUL_REPORTS) + '?ses=' + ses());
                    obj.set_tab( 
                        loc, 
                        {'tab_name' : offlineStrings.getString('menu.cmd_local_admin_reports.tab'), 'browser' : false }, 
                        {'no_xulG' : false, 'show_print_button' : false, show_nav_buttons : true } 
                    );
                }
            ],
            'cmd_open_vandelay' : [
                ['oncommand'],
                function() { open_eg_web_page('vandelay/vandelay'); }
            ],
            'cmd_local_admin_transit_list' : [
                ['oncommand'],
                function() { open_admin_page('transit_list.xul', 'menu.cmd_local_admin_transit_list.tab'); }
            ],
            'cmd_local_admin_cash_reports' : [
                ['oncommand'],
                function() { open_admin_page('cash_reports.xhtml', 'menu.cmd_local_admin_cash_reports.tab', true); }
            ],
            'cmd_local_admin_fonts_and_sounds' : [
                ['oncommand'],
                function() { open_admin_page('font_settings.xul', 'menu.cmd_local_admin_fonts_and_sounds.tab'); }
            ],
            'cmd_local_admin_printer' : [
                ['oncommand'],
                function() { open_admin_page('printer_settings.html', 'menu.cmd_local_admin_printer.tab', true); }
            ],
            'cmd_local_admin_do_not_auto_attempt_print_setting' : [
                ['oncommand'],
                function() { 
                    obj.set_tab(obj.url_prefix(urls.XUL_DO_NOT_AUTO_ATTEMPT_PRINT_SETTING),{'tab_name':offlineStrings.getString('menu.cmd_local_admin_do_not_auto_attempt_print_setting.tab')},{});
                }
            ],
            'cmd_local_admin_closed_dates' : [
                ['oncommand'],
                function() { open_admin_page('closed_dates.xhtml', 'menu.cmd_local_admin_closed_dates.tab', true); }
            ],
            'cmd_local_admin_copy_locations' : [
                ['oncommand'],
                function() { open_admin_page('copy_locations.xhtml', 'menu.cmd_local_admin_copy_locations.tab', true); }
            ],
            'cmd_local_admin_lib_settings' : [
                ['oncommand'],
                function() { open_admin_page('org_unit_settings.xhtml', 'menu.cmd_local_admin_lib_settings.tab', true); }
            ],
            'cmd_local_admin_non_cat_types' : [
                ['oncommand'],
                function() { open_admin_page('non_cat_types.xhtml', 'menu.cmd_local_admin_non_cat_types.tab', true); }
            ],
            'cmd_local_admin_stat_cats' : [
                ['oncommand'],
                function() { open_admin_page('stat_cat_editor.xhtml', 'menu.cmd_local_admin_stat_cats.tab', true); }
            ],
            'cmd_local_admin_standing_penalty' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/standing_penalty'); }
            ],
            'cmd_local_admin_grp_penalty_threshold' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/permission/grp_penalty_threshold'); }
            ],
            'cmd_server_admin_config_rule_circ_duration' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/rule_circ_duration'); }
            ],
            'cmd_server_admin_config_rule_recurring_fine' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/rule_recurring_fine'); }
            ],
            'cmd_server_admin_config_rule_max_fine' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/rule_max_fine'); }
            ],
            'cmd_server_admin_config_rule_age_hold_protect' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/rule_age_hold_protect'); }
            ],
            'cmd_local_admin_external_text_editor' : [
                ['oncommand'],
                function() {
                    var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components.interfaces['nsIPrefBranch']);
                    var key = 'oils.text_editor.external.cmd';
                    var has_key = prefs.prefHasUserValue(key);
                    var value = has_key ? prefs.getCharPref(key) : 'C:\\Windows\\notepad.exe %letter.txt%';
                    var cmd = window.prompt(
                        document.getElementById('offlineStrings').getString('text_editor.prompt_for_external_cmd'),
                        value
                    );
                    if (!cmd) { return; }
                    prefs.setCharPref(key,cmd);
                }
            ],
            'cmd_local_admin_idl_field_doc' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/idl_field_doc'); }
            ],
            'cmd_local_admin_action_trigger' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/action_trigger/event_definition'); }
            ],
            'cmd_local_admin_survey' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/action/survey'); }
            ],
            'cmd_local_admin_circ_matrix_matchpoint' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/circ_matrix_matchpoint', 
                    'menu.local_admin.circ_matrix_matchpoint.tab'); }
            ],
            'cmd_local_admin_hold_matrix_matchpoint' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/hold_matrix_matchpoint', 
                    'menu.local_admin.hold_matrix_matchpoint.tab'); }
            ],
            'cmd_local_admin_copy_location_order' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/asset/copy_location_order'); }
            ],
            'cmd_local_admin_work_log' : [
                ['oncommand'],
                function() { 
                    obj.set_tab(
                        urls.XUL_WORK_LOG,
                        { 'tab_name' : offlineStrings.getString('menu.local_admin.work_log.tab') },
                        {}
                    );
                }
            ],
            "cmd_local_admin_copy_template": [
                ["oncommand"],
                function() {
                    open_eg_web_page("conify/global/asset/copy_template");
                }
            ],
            'cmd_local_admin_patrons_due_refunds' : [
                ['oncommand'],
                function() {
                    obj.set_tab(
                        obj.url_prefix(urls.XUL_PATRONS_DUE_REFUNDS),
                        { 'tab_name' : offlineStrings.getString('menu.local_admin.patrons_due_refunds.tab') },
                        {}
                    );
                }
            ],
            'cmd_server_admin_org_type' : [
                ['oncommand'],
                function() { open_conify_page('actor/org_unit_type', null); }
            ],
            'cmd_server_admin_org_unit' : [
                ['oncommand'],
                function() { open_conify_page('actor/org_unit', null); }
            ],
            'cmd_server_admin_grp_tree' : [
                ['oncommand'],
                function() { open_conify_page('permission/grp_tree', null); }
            ],
            'cmd_server_admin_perm_list' : [
                ['oncommand'],
                function() { open_conify_page('permission/perm_list', null); }
            ],
            'cmd_server_admin_copy_status' : [
                ['oncommand'],
                function() { open_conify_page('config/copy_status', null); }
            ],
            'cmd_server_admin_marc_code' : [
                ['oncommand'],
                function() { open_conify_page('config/marc_code_maps', null); }
            ],
            'cmd_server_admin_billing_type' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/billing_type'); }
            ],
            'cmd_server_admin_acq_invoice_item_type' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/invoice_item_type'); }
            ],
            'cmd_server_admin_acq_invoice_payment_method' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/invoice_payment_method'); }
            ],
            'cmd_server_admin_acq_lineitem_alert' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/lineitem_alert'); }
            ],
            'cmd_server_admin_acq_fund_tag' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/fund_tag'); }
            ],
            'cmd_server_admin_acq_cancel_reason' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/cancel_reason'); }
            ],
            'cmd_server_admin_acq_claim_type' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/claim_type'); }
            ],
            'cmd_server_admin_acq_claim_event_type' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/claim_event_type'); }
            ],
            'cmd_server_admin_acq_claim_policy' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/claim_policy'); }
            ],
            'cmd_server_admin_acq_claim_policy_action' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/claim_policy_action'); }
            ],
            'cmd_server_admin_acq_fund' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/fund/list'); }
            ],
            'cmd_server_admin_acq_funding_source' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/funding_source/list'); }
            ],
            'cmd_server_admin_acq_provider' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/provider'); }
            ],
            'cmd_server_admin_acq_edi_account' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/edi_account'); }
            ],
            'cmd_server_admin_acq_edi_message' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/po/edi_messages'); }
            ],
            'cmd_server_admin_acq_currency_type' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/currency_type/list'); }
            ],
            'cmd_server_admin_acq_exchange_rate' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/exchange_rate'); }
            ],
            'cmd_server_admin_acq_distrib_formula' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/acq/distribution_formula'); }
            ],
            'cmd_server_admin_z39_source' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/z3950_source'); }
            ],
            'cmd_server_admin_circ_mod' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/circ_modifier'); }
            ],
            'cmd_server_admin_global_flag' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/global_flag'); }
            ],
            'cmd_server_admin_org_unit_setting_type' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/org_unit_setting_type'); }
            ],
            'cmd_server_admin_usr_setting_type' : [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/config/usr_setting_type'); }
            ],
            'cmd_server_admin_booking_resource': [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/booking/resource'); }
            ],
            'cmd_server_admin_booking_resource_type': [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/booking/resource_type'); }
            ],
            'cmd_server_admin_booking_resource_attr': [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/booking/resource_attr'); }
            ],
            'cmd_server_admin_booking_resource_attr_value': [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/booking/resource_attr_value'); }
            ],
            'cmd_server_admin_booking_resource_attr_map': [
                ['oncommand'],
                function() { open_eg_web_page('conify/global/booking/resource_attr_map'); }
            ],
            'cmd_acq_create_invoice' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/invoice/view?create=1', 'menu.cmd_acq_create_invoice.tab'); }
            ],
            'cmd_acq_view_my_pl' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/search/unified?ca=pl', 'menu.cmd_acq_unified_search.tab'); }
            ],
            'cmd_acq_view_local_po' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/search/unified?ca=po', 'menu.cmd_acq_unified_search.tab'); }
            ],
            'cmd_acq_create_po' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/po/create', 'menu.cmd_acq_po.tab'); }
            ],
            'cmd_acq_view_local_inv' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/search/unified?ca=inv', 'menu.cmd_acq_unified_search.tab'); }
            ],
            'cmd_acq_user_requests' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/picklist/user_request', 'menu.cmd_acq_user_requests.tab'); }
            ],
            'cmd_acq_upload' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/picklist/upload', 'menu.cmd_acq_upload.tab'); }
            ],
            'cmd_acq_bib_search' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/picklist/bib_search', 'menu.cmd_acq_bib_search.tab'); }
            ],
            'cmd_acq_unified_search' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/search/unified', 'menu.cmd_acq_unified_search.tab'); }
            ],
            'cmd_acq_from_bib' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/picklist/from_bib', 'menu.cmd_acq_from_bib.tab'); }
            ],
            'cmd_acq_new_brief_record' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/picklist/brief_record', 'menu.cmd_acq_new_brief_record.tab'); }
            ],
            'cmd_acq_claim_eligible' : [
                ['oncommand'],
                function() { open_eg_web_page('acq/financial/claim_eligible', 'menu.cmd_acq_claim_eligible.tab'); }
            ],
            'cmd_booking_reservation' : [
                ['oncommand'],
                function() {
                    obj.set_tab(
                        "/eg/booking/reservation",
                        {
                            "tab_name": offlineStrings.getString(
                                "menu.cmd_booking_reservation.tab"
                            ),
                            "browser": false
                        },
                        xulG
                    );
                }
            ],
            'cmd_booking_pull_list' : [
                ['oncommand'],
                function() {
                    obj.set_tab(
                        "/eg/booking/pull_list",
                        {
                            "tab_name": offlineStrings.getString(
                                "menu.cmd_booking_pull_list.tab"
                            ),
                            "browser": false
                        },
                        xulG
                    );
                }
            ],
            'cmd_booking_capture' : [
                ['oncommand'],
                function() {
                    obj.set_tab(
                        "/eg/booking/capture",
                        {
                            "tab_name": offlineStrings.getString(
                                "menu.cmd_booking_capture.tab"
                            ),
                            "browser": false
                        },
                        xulG
                    );
                }
            ],
            'cmd_booking_reservation_pickup' : [
                ['oncommand'],
                function() {
                    obj.set_tab(
                        "/eg/booking/pickup",
                        {
                            "tab_name": offlineStrings.getString(
                                "menu.cmd_booking_reservation_pickup.tab"
                            ),
                            "browser": false
                        },
                        xulG
                    );
                }
            ],
            'cmd_booking_reservation_return' : [
                ['oncommand'],
                function() {
                    obj.set_tab(
                        "/eg/booking/return",
                        {
                            "tab_name": offlineStrings.getString(
                                "menu.cmd_booking_reservation_return.tab"
                            ),
                            "browser": false
                        },
                        xulG
                    );
                }
            ],
            'cmd_reprint' : [
                ['oncommand'],
                function() {
                    try {
                        JSAN.use('util.print'); var print = new util.print();
                        print.reprint_last();
                    } catch(E) {
                        alert(E);
                    }
                }
            ],

            'cmd_retrieve_last_patron' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    if (!obj.data.last_patron) {
                        alert(offlineStrings.getString('menu.cmd_retrieve_last_patron.session.error'));
                        return;
                    }
                    var horizontal_interface = String( obj.data.hash.aous['ui.circ.patron_summary.horizontal'] ) == 'true';
                    var url = obj.url_prefix( horizontal_interface ? urls.XUL_PATRON_HORIZ_DISPLAY : urls.XUL_PATRON_DISPLAY );
                    obj.set_tab( url, {}, { 'id' : obj.data.last_patron } );
                }
            ],
            
            'cmd_retrieve_last_record' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    if (!obj.data.last_record) {
                        alert(offlineStrings.getString('menu.cmd_retrieve_last_record.session.error'));
                        return;
                    }
                    var opac_url = obj.url_prefix( urls.opac_rdetail ) + '?r=' + obj.data.last_record;
                    var content_params = {
                        'session' : ses(),
                        'authtime' : ses('authtime'),
                        'opac_url' : opac_url,
                    };
                    obj.set_tab(
                        obj.url_prefix(urls.XUL_OPAC_WRAPPER),
                        {'tab_name' : offlineStrings.getString('menu.cmd_retrieve_last_record.status')},
                        content_params
                    );
                }
            ],

            'cmd_verify_credentials' : [
                ['oncommand'],
                function() {
                    obj.set_tab(
                        obj.url_prefix(urls.XUL_VERIFY_CREDENTIALS),
                        { 'tab_name' : offlineStrings.getString('menu.cmd_verify_credentials.tabname') },
                        {}
                    );
                }
            ],

            /* Cataloging Menu */
            'cmd_z39_50_import' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_Z3950_IMPORT),{},{});
                }
            ],
            'cmd_create_marc' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_MARC_NEW),{},{});
                }
            ],

            'cmd_authority_manage' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.AUTHORITY_MANAGE),{},{});
                }
            ],

            /* Admin menu */
            'cmd_change_session' : [
                ['oncommand'],
                function() {
                    try {
                        obj.data.stash_retrieve();
                        JSAN.use('util.network'); var network = new util.network();
                        var x = document.getElementById('oc_menuitem');
                        var x_label = x.getAttribute('label_orig');
                        var temp_au = js2JSON( obj.data.list.au[0] );
                        var temp_ses = js2JSON( obj.data.session );
                        if (obj.data.list.au.length > 1) {
                            obj.data.list.au = [ obj.data.list.au[1] ];
                            obj.data.stash('list');
                            network.reset_titlebars( obj.data );
                            x.setAttribute('label', x_label );
                            network.simple_request('AUTH_DELETE', [ obj.data.session.key ] );
                            obj.data.session = obj.data.previous_session;
                            obj.data.stash('session');
                            try {
                                netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
                                var ios = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService);
                                var cookieUri = ios.newURI("http://" + obj.data.server_unadorned, null, null);
                                var cookieUriSSL = ios.newURI("https://" + obj.data.server_unadorned, null, null);
                                var cookieSvc = Components.classes["@mozilla.org/cookieService;1"].getService(Components.interfaces.nsICookieService);

                                cookieSvc.setCookieString(cookieUri, null, "ses="+obj.data.session.key, null);
                                cookieSvc.setCookieString(cookieUriSSL, null, "ses="+obj.data.session.key, null);

                        } catch(E) {
                            alert(offlineStrings.getFormattedString(main.session_cookie.error, [E]));
                        }

                            removeCSSClass(document.getElementById('main_tabbox'),'operator_change');
                        } else {
                            if (network.get_new_session(offlineStrings.getString('menu.cmd_chg_session.label'),{'url_prefix':obj.url_prefix})) {
                                obj.data.stash_retrieve();
                                obj.data.list.au[1] = JSON2js( temp_au );
                                obj.data.stash('list');
                                obj.data.previous_session = JSON2js( temp_ses );
                                obj.data.stash('previous_session');
                                x.setAttribute('label', offlineStrings.getFormattedString('menu.cmd_chg_session.operator.label', [obj.data.list.au[1].usrname()]) );
                                addCSSClass(document.getElementById('main_tabbox'),'operator_change');
                            }
                        }
                    } catch(E) {
                        obj.error.standard_unexpected_error_alert('cmd_change_session',E);
                    }
                }
            ],
            'cmd_manage_offline_xacts' : [
                ['oncommand'],
                function() {
                    obj.set_tab(obj.url_prefix(urls.XUL_OFFLINE_MANAGE_XACTS), {'tab_name' : offlineStrings.getString('menu.cmd_manage_offline_xacts.tab')}, {});
                }
            ],
            'cmd_download_patrons' : [
                ['oncommand'],
                function() {
                    try {
                        netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
                        var x = new XMLHttpRequest();
                        var url = 'http://' + XML_HTTP_SERVER + '/standalone/list.txt';
                        x.open("GET",url,false);
                        x.send(null);
                        if (x.status == 200) {
                            JSAN.use('util.file'); var file = new util.file('offline_patron_list');
                            file.write_content('truncate',x.responseText);
                            file.close();
                            file = new util.file('offline_patron_list.date');
                            file.write_content('truncate',new Date());
                            file.close();
                            alert(offlineStrings.getString('menu.cmd_download_patrons.complete.status'));
                        } else {
                            alert(offlineStrings.getFormattedString('menu.cmd_download_patrons.error', [x.status, x.statusText]));
                        }
                    } catch(E) {
                        obj.error.standard_unexpected_error_alert('cmd_download_patrons',E);
                    }
                }
            ],
            'cmd_adv_user_edit' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_PATRON_BARCODE_ENTRY), {}, { 'perm_editor' : true });
                }
            ],
            'cmd_print_list_template_edit' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_PRINT_LIST_TEMPLATE_EDITOR), {}, {});
                }
            ],
            'cmd_stat_cat_edit' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_STAT_CAT_EDIT) + '?ses='+window.escape(ses()), {'tab_name' : offlineStrings.getString('menu.cmd_stat_cat_edit.tab')},{});
                }
            ],
            'cmd_non_cat_type_edit' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_NON_CAT_LABEL_EDIT) + '?ses='+window.escape(ses()), {'tab_name' : offlineStrings.getString('menu.cmd_non_cat_type_edit.tab')},{});
                }
            ],
            'cmd_copy_location_edit' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.XUL_COPY_LOCATION_EDIT) + '?ses='+window.escape(ses()),{'tab_name' : offlineStrings.getString('menu.cmd_copy_location_edit.tab')},{});
                }
            ],
            'cmd_test' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    var content_params = { 'session' : ses(), 'authtime' : ses('authtime') };
                    obj.set_tab(obj.url_prefix(urls.XUL_OPAC_WRAPPER), {}, content_params);
                }
            ],
            'cmd_test_html' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.TEST_HTML) + '?ses='+window.escape(ses()),{ 'browser' : true },{});
                }
            ],
            'cmd_test_xul' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    obj.set_tab(obj.url_prefix(urls.TEST_XUL) + '?ses='+window.escape(ses()),{ 'browser' : false },{});
                }
            ],
            'cmd_console' : [
                ['oncommand'],
                function() {
                    obj.set_tab(obj.url_prefix(urls.XUL_DEBUG_CONSOLE),{'tab_name' : offlineStrings.getString('menu.cmd_console.tab')},{});
                }
            ],
            'cmd_shell' : [
                ['oncommand'],
                function() {
                    obj.set_tab(obj.url_prefix(urls.XUL_DEBUG_SHELL),{'tab_name' : offlineStrings.getString('menu.cmd_shell.tab')},{});
                }
            ],
            'cmd_xuleditor' : [
                ['oncommand'],
                function() {
                    obj.set_tab(obj.url_prefix(urls.XUL_DEBUG_XULEDITOR),{'tab_name' : offlineStrings.getString('menu.cmd_xuleditor.tab')},{});
                }
            ],
            'cmd_fieldmapper' : [
                ['oncommand'],
                function() {
                    obj.set_tab(obj.url_prefix(urls.XUL_DEBUG_FIELDMAPPER),{'tab_name' : offlineStrings.getString('menu.cmd_fieldmapper.tab')},{});
                }
            ],
            'cmd_survey_wizard' : [
                ['oncommand'],
                function() {
                    obj.data.stash_retrieve();
                    xulG.window.open(obj.url_prefix(urls.XUL_SURVEY_WIZARD),'survey_wizard','chrome'); 
                }
            ],
            'cmd_public_opac' : [
                ['oncommand'],
                function() {
                    var loc = urls.XUL_BROWSER + '?url=' + window.escape(
                        obj.url_prefix(urls.remote)
                    );
                    obj.set_tab( 
                        loc, 
                        {'tab_name' : offlineStrings.getString('menu.cmd_public_opac.tab'), 'browser' : false}, 
                        { 'no_xulG' : true, 'show_nav_buttons' : true, 'show_print_button' : true } 
                    );
                }
            ],
            'cmd_clear_cache' : [
                ['oncommand'],
                function clear_the_cache() {
                    try {
                        netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
                        var cacheClass         = Components.classes["@mozilla.org/network/cache-service;1"];
                        var cacheService    = cacheClass.getService(Components.interfaces.nsICacheService);
                        cacheService.evictEntries(Components.interfaces.nsICache.STORE_ON_DISK);
                        cacheService.evictEntries(Components.interfaces.nsICache.STORE_IN_MEMORY);
                    } catch(E) {
                        dump(E+'\n');alert(E);
                    }
                }
            ],
            'cmd_restore_all_tabs' : [
                ['oncommand'],
                function() {
                    var tabs = obj.controller.view.tabs;
                    for (var i = 0; i < tabs.childNodes.length; i++) {
                        tabs.childNodes[i].hidden = false;
                    }
                }
            ],
            'cmd_extension_manager' : [
                ['oncommand'],
                function() {
                    obj.set_tab('chrome://mozapps/content/extensions/extensions.xul?type=extensions',{'tab_name' : offlineStrings.getString('menu.cmd_extension_manager.tab')},{});
                }
            ],
            'cmd_theme_manager' : [
                ['oncommand'],
                function() {
                    obj.set_tab('chrome://mozapps/content/extensions/extensions.xul?type=themes',{'tab_name' : offlineStrings.getString('menu.cmd_theme_manager.tab')},{});
                }
            ],
            'cmd_about_config' : [
                ['oncommand'],
                function() {
                    obj.set_tab('chrome://global/content/config.xul',{'tab_name' : 'about:config'},{});
                }
            ],
            'cmd_shutdown' : [
                ['oncommand'],
                function() {
                    if (window.confirm(offlineStrings.getString('menu.cmd_shutdown.prompt'))) {
                        netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
                        var windowManager = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService();
                        var windowManagerInterface = windowManager.QueryInterface(Components.interfaces.nsIWindowMediator);
                        var enumerator = windowManagerInterface.getEnumerator(null);
                        var w; // close all other windows
                        while ( w = enumerator.getNext() ) {
                            if (w != window) {
                                if (w.xulG) { w.close(); } // FIXME: kludge so we don't close Firefox windows as an extension.  We should define a @windowtype for all the staff client windows and have the enumerator just pull those
                            }
                        }
                        window.close();
                    }
                }
            ],

        };

        JSAN.use('util.controller');
        var cmd;
        obj.controller = new util.controller();
        obj.controller.init( { 'window_knows_me_by' : 'g.menu.controller', 'control_map' : cmd_map } );

        obj.controller.view.tabbox = window.document.getElementById('main_tabbox');
        obj.controller.view.tabs = obj.controller.view.tabbox.firstChild;
        obj.controller.view.panels = obj.controller.view.tabbox.lastChild;

        obj.new_tab(null,{'focus':true},null);

        obj.init_tab_focus_handlers();
    },

    'spawn_search' : function(s) {
        var obj = this;
        obj.error.sdump('D_TRACE', offlineStrings.getFormattedString('menu.spawn_search.msg', [js2JSON(s)]) ); 
        obj.new_patron_tab( {}, { 'doit' : 1, 'query' : js2JSON(s) } );
    },

    'init_tab_focus_handlers' : function() {
        var obj = this;
        for (var i = 0; i < obj.controller.view.tabs.childNodes.length; i++) {
            var tab = obj.controller.view.tabs.childNodes[i];
            var panel = obj.controller.view.panels.childNodes[i];
            tab.addEventListener(
                'command',
                function(p) {
                    return function() {
                        try {
                            netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
                            if (p
                                && p.firstChild 
                                && ( p.firstChild.nodeName == 'iframe' || p.firstChild.nodeName == 'browser' )
                                && p.firstChild.contentWindow 
                            ) {
                                var cw = p.firstChild.contentWindow;
                                var help_params = {
                                    'protocol' : cw.location.protocol,
                                    'hostname' : cw.location.hostname,
                                    'port' : cw.location.port,
                                    'pathname' : cw.location.pathname,
                                    'src' : ''
                                };
                                obj.set_help_context(help_params);
                                if (typeof cw.default_focus == 'function') {
                                    cw.default_focus();
                                }
                            }
                        } catch(E) {
                            obj.error.sdump('D_ERROR','init_tab_focus_handler: ' + js2JSON(E));
                        }
                    }
                }(panel),
                false
            );
        }
    },

    // We keep a reference to content_params fed to tabs, so if we manipulate the DOM (say, via join_tabs),
    // we can re-inject the content_params into the content if needed.  We have to watch out for memory leaks
    // doing this.
    'preserved_content_params' : {},

    'close_all_tabs' : function() {
        var obj = this;
        try {
            var count = obj.controller.view.tabs.childNodes.length;
            for (var i = 0; i < count; i++) obj.close_tab();
            setTimeout( function(){ obj.controller.view.tabs.firstChild.focus(); }, 0);
        } catch(E) {
            obj.error.standard_unexpected_error_alert(offlineStrings.getString('menu.close_all_tabs.error'),E);
        }
    },

    'close_tab' : function (specific_idx) {
        var idx = specific_idx || this.controller.view.tabs.selectedIndex;
        var tab = this.controller.view.tabs.childNodes[idx];
        var panel = this.controller.view.panels.childNodes[ idx ];
        while ( panel.lastChild ) panel.removeChild( panel.lastChild );
        if (idx == 0) {
            try {
                this.controller.view.tabs.advanceSelectedTab(+1);
            } catch(E) {
                this.error.sdump('D_TAB','failed tabs.advanceSelectedTab(+1):'+js2JSON(E) + '\n');
                try {
                    this.controller.view.tabs.advanceSelectedTab(-1);
                } catch(E) {
                    this.error.sdump('D_TAB','failed again tabs.advanceSelectedTab(-1):'+
                        js2JSON(E) + '\n');
                }
            }
        } else {
            try {
                this.controller.view.tabs.advanceSelectedTab(-1);
            } catch(E) {
                this.error.sdump('D_TAB','failed tabs.advanceSelectedTab(-1):'+js2JSON(E) + '\n');
                try {
                    this.controller.view.tabs.advanceSelectedTab(+1);
                } catch(E) {
                    this.error.sdump('D_TAB','failed again tabs.advanceSelectedTab(+1):'+
                        js2JSON(E) + '\n');
                }
            }

        }
        
        this.error.sdump('D_TAB','\tnew tabbox.selectedIndex = ' + this.controller.view.tabbox.selectedIndex + '\n');

        this.controller.view.tabs.childNodes[ idx ].hidden = true;
        this.error.sdump('D_TAB','tabs.childNodes[ ' + idx + ' ].hidden = true;\n');

        // Make sure we keep at least one tab open.
        var tab_flag = true;
        for (var i = 0; i < this.controller.view.tabs.childNodes.length; i++) {
            var tab = this.controller.view.tabs.childNodes[i];
            if (!tab.hidden)
                tab_flag = false;
        }
        if (tab_flag) {
            this.controller.view.tabs.selectedIndex = 0;
            this.new_tab(); 
        }
    },

    'join_tabs' : function(params) {
        try {
            if (!params) { params = {}; }
            if (!params.orient) { params.orient = 'horizontal'; }

            var left_idx = params.specific_idx || this.controller.view.tabs.selectedIndex;
            var left_tab = this.controller.view.tabs.childNodes[left_idx];
            var left_panel = this.controller.view.panels.childNodes[ left_idx ];

            // Find next not-hidden tab
            var right_idx;
            for (var i = left_idx + 1; i<this.controller.view.tabs.childNodes.length; i++) {
                var tab = this.controller.view.tabs.childNodes[i];
                if (!tab.hidden && !right_idx) {
                    right_idx = i;
                }
            }
            if (!right_idx) { return; }

            // Grab the content
            var right_tab = this.controller.view.tabs.childNodes[right_idx];
            var right_panel = this.controller.view.panels.childNodes[ right_idx ];

            var left_content = left_panel.removeChild( left_panel.firstChild );
            var right_content = right_panel.removeChild( right_panel.firstChild );

            // Create a wrapper and shuffle the content
            var box = params.orient == 'vertical' ? document.createElement('vbox') : document.createElement('hbox');
            box.setAttribute('flex',1);
            left_panel.appendChild(box);
            box.appendChild(left_content);
            var splitter = document.createElement('splitter');
            splitter.appendChild( document.createElement('grippy') );
            box.appendChild(splitter);
            box.appendChild(right_content);

            right_tab.hidden = true;
            // FIXME: if we really want to combine labels for joined tabs, need to handle the cases where the content dynamically set their tab 
            // labels with xulG.set_tab_name
            left_tab.setAttribute('unadornedlabel', left_tab.getAttribute('unadornedlabel') + ' / ' + right_tab.getAttribute('unadornedlabel'));
            left_tab.setAttribute('label', left_tab.getAttribute('label') + ' / ' + right_tab.getAttribute('unadornedlabel'));

            // Re-apply content params, etc.
            var left_params = this.preserved_content_params[ left_idx ];
            var right_params = this.preserved_content_params[ right_idx ];
            this.preserved_content_params[ left_idx ] = function() {
                try {
                    left_params();
                    right_params();
                } catch(E) {
                    alert('Error re-applying content params after join_tabs');
                }
            };
            this.preserved_content_params[ left_idx ]();

        } catch(E) {
            alert('Error in menu.js with join_tabs(): ' + E);
        }
    },

    'find_free_tab' : function() {
        var last_not_hidden = -1;
        for (var i = 0; i<this.controller.view.tabs.childNodes.length; i++) {
            var tab = this.controller.view.tabs.childNodes[i];
            if (!tab.hidden)
                last_not_hidden = i;
        }
        if (last_not_hidden == this.controller.view.tabs.childNodes.length - 1)
            last_not_hidden = -1;
        // If the one next to last_not_hidden is hidden, we want it.
        // Basically, we fill in tabs after existing tabs for as 
        // long as possible.
        var idx = last_not_hidden + 1;
        var candidate = this.controller.view.tabs.childNodes[ idx ];
        if (candidate.hidden)
            return idx;
        // Alright, find the first hidden then
        for (var i = 0; i<this.controller.view.tabs.childNodes.length; i++) {
            var tab = this.controller.view.tabs.childNodes[i];
            if (tab.hidden)
                return i;
        }
        return -1;
    },

    'new_tab' : function(url,params,content_params) {
        var tc = this.find_free_tab();
        if (tc == -1) { return null; } // 9 tabs max
        var tab = this.controller.view.tabs.childNodes[ tc ];
        tab.hidden = false;
        if (!content_params) content_params = {};
        if (!params) params = {};
        if (!params.tab_name) params.tab_name = offlineStrings.getString('menu.new_tab.tab');
        if (!params.nofocus) params.focus = true; /* make focus the default */
        try {
            if (params.focus) this.controller.view.tabs.selectedIndex = tc;
            params.index = tc;
            this.set_tab(url,params,content_params);
        } catch(E) {
            this.error.sdump('D_ERROR',E);
        }
    },

    'page_meter' : {
        'node' : document.getElementById('page_progress'),
        'on' : function() {
            document.getElementById('page_progress').setAttribute('mode','undetermined');
        },
        'off' : function() {
            document.getElementById('page_progress').setAttribute('mode','determined');
        },
        'tooltip' : function(text) {
            if (text || text == '') {
                document.getElementById('page_progress').setAttribute('tooltiptext',text);
            }
            return document.getElementById('page_progress').getAttribute('tooltiptext');
        }
    },

    'network_meter' : {
        'inc' : function(app,method) {
            try {
                var m = document.getElementById('network_progress');
                var count = 1 + Number( m.getAttribute('count') );
                m.setAttribute('mode','undetermined');
                m.setAttribute('count', count);
                var rows = document.getElementById('network_progress_rows');
                var row = document.getElementById('network_progress_tip_'+app+'_'+method);
                if (!row) {
                    row = document.createElement('row'); row.setAttribute('id','network_progress_tip_'+app+'_'+method);
                    var a = document.createElement('label'); a.setAttribute('value','App:');
                    var b = document.createElement('label'); b.setAttribute('value',app);
                    var c = document.createElement('label'); c.setAttribute('value','Method:');
                    var d = document.createElement('label'); d.setAttribute('value',method);
                    var e = document.createElement('label'); e.setAttribute('value','Total:');
                    var f = document.createElement('label'); f.setAttribute('value','0'); 
                    f.setAttribute('id','network_progress_tip_total_'+app+'_'+method);
                    var g = document.createElement('label'); g.setAttribute('value','Outstanding:');
                    var h = document.createElement('label'); h.setAttribute('value','0');
                    h.setAttribute('id','network_progress_tip_out_'+app+'_'+method);
                    row.appendChild(a); row.appendChild(b); row.appendChild(c);
                    row.appendChild(d); row.appendChild(e); row.appendChild(f);
                    row.appendChild(g); row.appendChild(h); rows.appendChild(row);
                }
                var total = document.getElementById('network_progress_tip_total_'+app+'_'+method);
                if (total) {
                    total.setAttribute('value', 1 + Number( total.getAttribute('value') ));
                }
                var out = document.getElementById('network_progress_tip_out_'+app+'_'+method);
                if (out) {
                    out.setAttribute('value', 1 + Number( out.getAttribute('value') ));
                }
            } catch(E) {
                dump('network_meter.inc(): ' + E + '\n');
            }
        },
        'dec' : function(app,method) {
            try {
                var m = document.getElementById('network_progress');
                var count = -1 + Number( m.getAttribute('count') );
                if (count < 0) count = 0;
                if (count == 0) m.setAttribute('mode','determined');
                m.setAttribute('count', count);
                var out = document.getElementById('network_progress_tip_out_'+app+'_'+method);
                if (out) {
                    out.setAttribute('value', -1 + Number( out.getAttribute('value') ));
                }
            } catch(E) {
                dump('network_meter.dec(): ' + E + '\n');
            }
        }
    },
    'set_patron_tab' : function(params,content_params) {
        var obj = this;
        var horizontal_interface = String( obj.data.hash.aous['ui.circ.patron_summary.horizontal'] ) == 'true';
        var url = obj.url_prefix( horizontal_interface ? urls.XUL_PATRON_HORIZ_DISPLAY : urls.XUL_PATRON_DISPLAY );
        obj.set_tab(url,params ? params : {},content_params ? content_params : {});
    },
    'new_patron_tab' : function(params,content_params) {
        var obj = this;
        var horizontal_interface = String( obj.data.hash.aous['ui.circ.patron_summary.horizontal'] ) == 'true';
        var url = obj.url_prefix( horizontal_interface ? urls.XUL_PATRON_HORIZ_DISPLAY : urls.XUL_PATRON_DISPLAY );
        obj.new_tab(url,params ? params : {},content_params ? content_params : {});
    },
    'volume_item_creator' : function(params) {
        var obj = this;
        JSAN.use('util.window'); var win = new util.window();
        var w = win.open(
            obj.url_prefix(urls.XUL_VOLUME_COPY_CREATOR),
            document.getElementById('offlineStrings').getString('staff.cat.create_or_rebarcode_items'),
            'chrome,resizable',
            params
        );
    },
    'holdings_maintenance_tab' : function(docid,params,content_params) {
        var obj = this;
        if (!content_params) {
            content_params = {};
        }
        if (docid) {
            content_params['docid'] = docid;
        }
        var url = obj.url_prefix( urls.XUL_COPY_VOLUME_BROWSE );
        obj.new_tab(url,params || {}, content_params);
    },
    'get_new_session' : function(params) {
        var obj = this;
        if (!params) { params = {}; }
        JSAN.use('util.network'); var net = new util.network();
        var result = net.get_new_session(null,{'url_prefix':obj.url_prefix},!params.operator_change);
        if (typeof params.callback == 'function') {
            return params.callback( result, ses(), ses('authtime') );
        }
        return result;
    },
    'set_help_context' : function(params) {
        var obj = this;
        if (!params) { params = {}; }
        if (params.protocol == 'chrome:') { return; } /* not supported */
        var help_btn = document.getElementById('help_btn');
        if (help_btn) {
            dump('set_help_context: ' + js2JSON(params) + '\n');
            if (params.protocol) { help_btn.setAttribute('protocol', params.protocol); }
            if (params.hostname) { help_btn.setAttribute('hostname', params.hostname);  }
            if (params.port) { help_btn.setAttribute('port', params.port);  }
            if (params.pathname) { help_btn.setAttribute('pathname', params.pathname); }
            if (params.src) { help_btn.setAttribute('src', params.src); }
        }
    },
    'augment_content_params' : function(idx,tab,params,content_params) {
        var obj = this;
        content_params.new_tab = function(a,b,c) { return obj.new_tab(a,b,c); };
        content_params.set_tab = function(a,b,c) { return obj.set_tab(a,b,c); };
        content_params.close_tab = function() { return obj.close_tab(); };
        content_params.new_patron_tab = function(a,b) { return obj.new_patron_tab(a,b); };
        content_params.set_patron_tab = function(a,b) { return obj.set_patron_tab(a,b); };
        content_params.volume_item_creator = function(a) { return obj.volume_item_creator(a); };
        content_params.get_new_session = function(a) { return obj.get_new_session(a); };
        content_params.holdings_maintenance_tab = function(a,b,c) { return obj.holdings_maintenance_tab(a,b,c); };
        content_params.set_tab_name = function(name) { tab.setAttribute('unadornedlabel',name); tab.setAttribute('label',(idx + 1) + ' ' + name); };
        content_params.set_help_context = function(params) { return obj.set_help_context(params); };
        content_params.open_chrome_window = function(a,b,c) { return xulG.window.open(a,b,c); };
        content_params.url_prefix = function(url) { return obj.url_prefix(url); };
        content_params.network_meter = obj.network_meter;
        content_params.page_meter = obj.page_meter;
        content_params.set_statusbar = function(slot,text) {
            var e = document.getElementById('statusbarpanel'+slot);
            if (e) { e.setAttribute('label',text); }
        };
        content_params.chrome_xulG = xulG;
        content_params._data = xulG._data;

        return content_params;
    },
    'set_tab' : function(url,params,content_params) {
        var obj = this;
        if (!url) url = '/xul/server/';
        if (!url.match(/:\/\//) && !url.match(/^data:/)) url = urls.remote + url;
        if (!params) params = {};
        if (!content_params) content_params = {};
        var idx = this.controller.view.tabs.selectedIndex;
        if (obj.preserved_content_params[idx]) { delete obj.preserved_content_params[ idx ]; }
        if (params && typeof params.index != 'undefined') idx = params.index;
        var tab = this.controller.view.tabs.childNodes[ idx ];
        if (params.focus) tab.focus();
        var panel = this.controller.view.panels.childNodes[ idx ];
        while ( panel.lastChild ) panel.removeChild( panel.lastChild );

        content_params = obj.augment_content_params(idx,tab,params,content_params);
        if (params && params.tab_name) content_params.set_tab_name( params.tab_name );
        
        var frame;
        try {
            if (typeof params.browser == 'undefined') params.browser = false;
            if (params.browser) {
                obj.id_incr++;
                frame = this.w.document.createElement('browser');
                frame.setAttribute('flex','1');
                frame.setAttribute('type','content');
                frame.setAttribute('autoscroll','false');
                frame.setAttribute('id','frame_'+obj.id_incr);
                panel.appendChild(frame);
                try {
                    dump('creating browser with src = ' + url + '\n');
                    JSAN.use('util.browser');
                    var b = new util.browser();
                    b.init(
                        {
                            'url' : url,
                            'push_xulG' : true,
                            'alt_print' : false,
                            'browser_id' : 'frame_'+obj.id_incr,
                            'passthru_content_params' : content_params,
                        }
                    );
                    obj.preserved_content_params[ idx ] = function() {
                        b.passthru_content_params = content_params;
                    }
                } catch(E) {
                    alert(E);
                }
            } else {
                frame = this.w.document.createElement('iframe');
                frame.setAttribute('flex','1');
                panel.appendChild(frame);
                dump('creating iframe with src = ' + url + '\n');
                frame.setAttribute('src',url);
                obj.preserved_content_params[ idx ] = function() {
                    try {
                        netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
                        var cw = frame.contentWindow;
                        if (typeof cw.wrappedJSObject != 'undefined') cw = cw.wrappedJSObject;
                        cw.IAMXUL = true;
                        cw.xulG = content_params;
                        cw.addEventListener(
                            'load',
                            function() {
                                try {
                                    if (typeof cw.help_context_set_locally == 'undefined') {
                                        var help_params = {
                                            'protocol' : cw.location.protocol,
                                            'hostname' : cw.location.hostname,
                                            'port' : cw.location.port,
                                            'pathname' : cw.location.pathname,
                                            'src' : ''
                                        };
                                        obj.set_help_context(help_params);
                                    } else if (typeof cw.default_focus == 'function') {
                                        cw.default_focus();
                                    }
                                } catch(E) {
                                    obj.error.sdump('D_ERROR', 'main.menu, set_tab, onload: ' + E);
                                }
                            },
                            false
                        );
                    } catch(E) {
                        this.error.sdump('D_ERROR', 'main.menu: ' + E);
                    }
                };
                obj.preserved_content_params[ idx ]();
            }
        } catch(E) {
            this.error.sdump('D_ERROR', 'main.menu:2: ' + E);
            alert(offlineStrings.getString('menu.set_tab.error'));
        }

        return frame;
    }

}

dump('exiting main/menu.js\n');
