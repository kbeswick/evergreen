dump('Loading constants.js\n');
var api = {
	'AUTH_INIT' : { 'app' : 'open-ils.auth', 'method' : 'open-ils.auth.authenticate.init' },
	'AUTH_COMPLETE' : { 'app' : 'open-ils.auth', 'method' : 'open-ils.auth.authenticate.complete' },
	'AUTH_DELETE' : { 'app' : 'open-ils.auth', 'method' : 'open-ils.auth.session.delete' },
	'AUTH_WORKSTATION' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.workstation.register' },
	'BILL_PAY' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.money.payment' },
	'BLOB_CHECKOUTS_RETRIEVE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.actor.user.checked_out' },
	'BLOB_MARC_CALLNUMBERS_RETRIEVE' : { 'app' : 'open-ils.cat', 'method' : 'open-ils.cat.biblio.record.marc_cn.retrieve' },
	'BLOB_MOBTS_CIRC_MVR_HAVING_BALANCE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.transactions.have_balance.fleshed' },
	'BUCKET_CREATE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.container.create' },
	'BUCKET_DELETE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.container.delete' },
	'BUCKET_FLESH' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.container.flesh' },
	'BUCKET_FULL_DELETE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.container.full_delete' },
	'BUCKET_RETRIEVE_VIA_USER' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.container.all.retrieve_by_user' },
	'BUCKET_ITEM_CREATE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.container.item.create' },
	'BUCKET_ITEM_DELETE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.container.item.delete' },
	'CAPTURE_COPY_FOR_HOLD_VIA_BARCODE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.hold.capture_copy.barcode' },
	'CHECKIN_VIA_BARCODE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.checkin' },
	'CHECKOUT' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.checkout' },
	'CHECKOUT_PERMIT' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.checkout.permit' },
	'CHECKOUT_RENEW' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.renew' },
	'FM_ACN_RETRIEVE' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.callnumber.retrieve' },
	'FM_ACN_TREE_UPDATE' : { 'app' : 'open-ils.cat', 'method' : 'open-ils.cat.asset.volume_tree.fleshed.batch.update' },
	'FM_ACN_TREE_LIST_RETRIEVE_VIA_RECORD_ID_AND_ORG_IDS' : { 'app' : 'open-ils.cat', 'method' : 'open-ils.cat.asset.copy_tree.retrieve' },
	'FM_ACP_RETRIEVE' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.asset.copy.fleshed.retrieve' },
	'FM_ACP_RETRIEVE_VIA_BARCODE' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.asset.copy.find_by_barcode' },
	'FM_ACP_FLESHED_BATCH_RETRIEVE' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.asset.copy.fleshed.batch.retrieve' },
	'FM_ACP_FLESHED_BATCH_UPDATE' : { 'app' : 'open-ils.cat', 'method' : 'open-ils.cat.asset.copy.fleshed.batch.update' },
	'FM_ACPL_RETRIEVE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.copy_location.retrieve.all' },
	'FM_ACTSC_RETRIEVE_VIA_AOU' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.stat_cat.actor.retrieve.all' },
	'FM_AHR_RETRIEVE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.holds.retrieve' },
	'FM_AHR_RETRIEVE_VIA_PICKUP_AOU' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.holds.retrieve_by_pickup_lib' },
	'FM_AHR_COUNT_RETRIEVE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.hold_requests.count' },
	'FM_AIHU_CREATE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.in_house_use.create' },
	'FM_AOU_RETRIEVE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.org_tree.retrieve' },
	'FM_AOU_RETRIEVE_RELATED_VIA_SESSION' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.org_unit.full_path.retrieve' },
	'FM_AOU_IDS_RETRIEVE_VIA_RECORD_ID' : { 'app' : 'open-ils.cat', 'method' : 'open-ils.cat.actor.org_unit.retrieve_by_title' },
	'FM_AOUT_RETRIEVE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.org_types.retrieve' },
	'FM_ASC_BATCH_RETRIEVE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.stat_cat.asset.retrieve.batch' },
	'FM_ASC_RETRIEVE_VIA_AOU' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.stat_cat.asset.retrieve.all' },
	'FM_ASV_CREATE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.survey.create' },
	'FM_ASV_RETRIEVE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.survey.retrieve.all' },
	'FM_ASV_RETRIEVE_REQUIRED' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.survey.retrieve.required' },
	'FM_ASVR_RETRIEVE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.survey.response.retrieve' },
	'FM_AU_IDS_RETRIEVE_VIA_HASH' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.patron.search.advanced' },
	'FM_AU_RETRIEVE_VIA_SESSION' : { 'app' : 'open-ils.auth', 'method' : 'open-ils.auth.session.retrieve' },
	'FM_AU_RETRIEVE_VIA_BARCODE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.fleshed.retrieve_by_barcode' },
	'FM_AU_RETRIEVE_VIA_ID' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.retrieve' },
	'FM_AU_FLESHED_RETRIEVE_VIA_ID' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.fleshed.retrieve' },
	'FM_BRE_RETRIEVE_VIA_ID' : { 'app' : 'open-ils.cat', 'method' : 'open-ils.cat.biblio.record.metadata.retrieve' },
	'FM_BRE_ID_SEARCH_VIA_TCN' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.biblio.tcn' },
	'FM_BRN_FROM_MARCXML' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.z3950.marcxml_to_brn' },
	'FM_CCS_RETRIEVE' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.config.copy_status.retrieve.all' },
	'FM_CIRC_RETRIEVE_VIA_ID' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.retrieve' },
	'FM_CIRC_RETRIEVE_VIA_USER' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.actor.user.checked_out.slim' },
	'FM_CIRC_COUNT_RETRIEVE_VIA_USER' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.checked_out.count' },
	'FM_CIT_RETRIEVE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.ident_types.retrieve' },
	'FM_CNCT_RETRIEVE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.non_cat_types.retrieve.all' },
	'FM_CST_RETRIEVE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.standings.retrieve' },
	'FM_MB_CREATE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.money.billing.create' },
	'FM_MB_RETRIEVE_VIA_MBTS_ID' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.money.billing.retrieve.all' },
	'FM_MBTS_RETRIEVE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.money.billable_xact_summary.retrieve' },
	'FM_MP_RETRIEVE_VIA_MBTS_ID' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.money.payment.retrieve.all' },
	'FM_MG_CREATE' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.money.grocery.create' },
	'FM_MOBTS_HAVING_BALANCE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.transactions.have_balance' },
	'FM_MOBTS_TOTAL_HAVING_BALANCE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.transactions.have_balance.total' },
	'FM_MOBTS_COUNT_HAVING_BALANCE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.transactions.have_balance.count' },
	'FM_PGT_RETRIEVE' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.groups.retrieve' },
	'MARC_HTML_RETRIEVE' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.biblio.record.html' },
	'FM_BLOB_RETRIEVE_VIA_Z3950_RAW' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.z3950.raw_string' },
	'FM_BLOB_RETRIEVE_VIA_Z3950_TCN' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.z3950.tcn' },
	'MARK_ITEM_LOST' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.circulation.set_lost' },
	'MARK_ITEM_CLAIM_RETURNED' : { 'app' : 'open-ils.circ', 'method' : 'open-ils.circ.circulation.set_claims_returned' },
	'MODS_SLIM_METARECORD_RETRIEVE' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.biblio.metarecord.mods_slim.retrieve' },
	'MODS_SLIM_RECORD_RETRIEVE' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.biblio.record.mods_slim.retrieve' },
	'MODS_SLIM_RECORD_RETRIEVE_VIA_COPY' : { 'app' : 'open-ils.search', 'method' : 'open-ils.search.biblio.mods_from_copy' },
	'PERM_CHECK' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.perm.check' },
	'PERM_MULTI_ORG_CHECK' : { 'app' : 'open-ils.actor', 'method' : 'open-ils.actor.user.perm.check.multi_org' },
}

var urls = {

	'opac' : '/opac/en-US/skin/default/xml/advanced.xml',
	'opac_rdetail' : '/opac/en-US/skin/default/xml/rdetail.xml',
	'browser' : '/opac/en-US/skin/default/xml/advanced.xml',
	'fieldmapper' : '/opac/common/js/fmall.js',

	'AUDIO_GOOD_SOUND' : '/xul/server/skin/media/audio/bonus.wav',
	'AUDIO_BAD_SOUND' : '/xul/server/skin/media/audio/question.wav',
	'AUDIO_HORRIBLE_SOUND' : '/xul/server/skin/media/audio/redalert.wav',
	'AUDIO_CIRC_GOOD_SOUND' : '/xul/server/skin/media/audio/toggled.wav',
	'AUDIO_CIRC_BAD_SOUND' : '/xul/server/skin/media/audio/question.wav',

	'XUL_ADV_USER_BARCODE_ENTRY' : '/xul/server/patron/adv_barcode_entry.xul',
	'XUL_AUTH_SIMPLE' : '/xul/server/main/simple_auth.xul',
	'XUL_BIB_BRIEF' : '/xul/server/cat/bib_brief.xul',
	'XUL_BROWSER' : 'chrome://open_ils_staff_client/content/util/browser.xul',
	'XUL_CHECKIN' : '/xul/server/circ/checkin.xul',
	'XUL_CHECKOUT' : '/xul/server/circ/checkout.xul',
	'XUL_COPY_BUCKETS' : '/xul/server/cat/copy_buckets.xul',
	'XUL_COPY_EDITOR' : '/xul/server/cat/copy_editor.xul',
	'XUL_COPY_LOCATION_EDIT' : '/xul/server/admin/copy_locations.xhtml',
	'XUL_COPY_STATUS' : '/xul/server/circ/copy_status.xul',
	'XUL_COPY_VOLUME_BROWSE' : 'chrome://open_ils_staff_client/content/legacy/_browse.xul',
	'XUL_DEBUG_CONSOLE' : 'chrome://global/content/console.xul',
	'XUL_DEBUG_FIELDMAPPER' : '/xul/server/util/fm_view.xul',
	'XUL_DEBUG_FILTER_CONSOLE' : '/xul/server/util/filter_console.xul',
	'XUL_DEBUG_SHELL' : '/xul/server/util/shell.html',
	'XUL_DEBUG_XULEDITOR' : '/xul/server/util/xuledit.xul',
	'XUL_HOLD_CAPTURE' : '/xul/server/circ/hold_capture.xul',
	'XUL_HOLD_PULL_LIST' : '/xul/server/admin/hold_pull_list.xhtml',
	'XUL_HOLDS_BROWSER' : '/xul/server/patron/holds.xul',
	'XUL_IN_HOUSE_USE' : '/xul/server/circ/in_house_use.xul',
	'XUL_MARC_EDIT' : 'chrome://open_ils_staff_client/content/legacy/_marc.xul',
	'XUL_MARC_VIEW' : '/xul/server/cat/marc_view.xul',
	'XUL_MENU_FRAME' : 'chrome://open_ils_staff_client/content/main/menu_frame.xul',
	'XUL_NON_CAT_LABEL_EDIT' : '/xul/server/admin/non_cat_types.xhtml',
	'XUL_OFFLINE_UPLOAD_XACTS' : '/xul/server/admin/upload_xacts.xhtml',
	'XUL_OFFLINE_MANAGE_XACTS' : '/xul/server/admin/offline_manage_xacts.xul',
	'XUL_OFFLINE_MANAGE_XACTS_CGI' : '/cgi-bin/offline/offline.pl',
	'XUL_OFFLINE_GENERATE_WIDGETS' : '/xul/server/main/gen_offline_widgets.xul',
	'XUL_OPAC_WRAPPER' : 'chrome://open_ils_staff_client/content/cat/opac.xul',
	'XUL_PATRON_BARCODE_ENTRY' : '/xul/server/patron/barcode_entry.xul',
	'XUL_PATRON_BILLS' : '/xul/server/patron/bills.xul',
	'XUL_PATRON_BILL_CC_INFO' : '/xul/server/patron/bill_cc_info.xul',
	'XUL_PATRON_BILL_CHECK_INFO' : '/xul/server/patron/bill_check_info.xul',
	'XUL_PATRON_BILL_DETAILS' : '/xul/server/patron/bill_details.xul',
	'XUL_PATRON_BILL_WIZARD' : '/xul/server/patron/bill_wizard.xul',
	'XUL_PATRON_DISPLAY' : '/xul/server/patron/display.xul',
	'XUL_PATRON_EDIT' : '/xul/server/patron/ue.xhtml',
	'XUL_PATRON_HOLDS' : '/xul/server/patron/holds.xul',
	'XUL_PATRON_INFO' : 'data:text/html,<h1>Info Here</h1>',
	'XUL_PATRON_ITEMS' : '/xul/server/patron/items.xul',
	'XUL_PATRON_SEARCH_FORM' : '/xul/server/patron/search_form.xul',
	'XUL_PATRON_SEARCH_RESULT' : '/xul/server/patron/search_result.xul',
	'XUL_PATRON_SUMMARY' : '/xul/server/patron/summary.xul',
	'XUL_PRE_CAT' : '/xul/server/circ/pre_cat_fields.xul',
	'XUL_PRINT_LIST_TEMPLATE_EDITOR' : '/xul/server/circ/print_list_template_editor.xul',
	'XUL_REMOTE_BROWSER' : '/xul/server/util/rbrowser.xul',
	'XUL_STANDALONE' : 'chrome://open_ils_staff_client/content/circ/offline.xul',
	'XUL_STAT_CAT_EDIT' : '/xul/server/admin/stat_cat_editor.xhtml',
	'XUL_SURVEY_WIZARD' : 'chrome://open_ils_staff_client/content/admin/survey_wizard.xul',
	'XUL_VOLUME_COPY_CREATOR' : '/xul/server/cat/volume_copy_creator.xul',
	'XUL_VOLUME_EDITOR' : '/xul/server/cat/volume_editor.xul',
	'XUL_Z3950_IMPORT' : '/xul/server/cat/z3950.xul',
	'TEST_HTML' : '/xul/server/main/test.html',
	'TEST_XUL' : '/xul/server/cat/copy_browser.xul',
}
