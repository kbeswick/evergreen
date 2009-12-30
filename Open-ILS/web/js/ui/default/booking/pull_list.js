dojo.require("openils.User");
dojo.require("openils.PermaCrud");
dojo.require("fieldmapper.OrgUtils");
dojo.require("openils.widget.OrgUnitFilteringSelect");
dojo.requireLocalization("openils.booking", "pull_list");

var localeStrings = dojo.i18n.getLocalization("openils.booking", "pull_list");
var pcrud = new openils.PermaCrud();

var pickup_lib_selected;
var acp_cache = {};

function init_pickup_lib_selector() {
    var User = new openils.User();
    User.buildPermOrgSelector(
        "RETRIEVE_RESERVATION_PULL_LIST", pickup_lib_selector, null,
        function() {
            pickup_lib_selected = pickup_lib_selector.getValue();
            dojo.connect(pickup_lib_selector, "onChange",
                function() { pickup_lib_selected = this.getValue(); }
            )
        }
    );
}

function retrieve_pull_list(ivl_in_days) {
    var secs = Number(ivl_in_days) * 86400;

    if (isNaN(secs) || secs < 1)
        throw new Error("Invalid interval");

    return fieldmapper.standardRequest(
        ["open-ils.booking", "open-ils.booking.reservations.get_pull_list"],
        [xulG.auth.session.key, null, secs, pickup_lib_selected]
    );
}

function dom_table_rowid(resource_id) {
    return "pull_list_resource_" + resource_id;
}

function generate_result_row(one) {
    function cell(id, content) {
        var td = document.createElement("td");
        if (id != undefined) td.setAttribute("id", id);
        td.appendChild(document.createTextNode(content));
        return td;
    }

    function reservation_info_cell(one) {
        var td = document.createElement("td");
        for (var i in one.reservations) {
            var one_resv = one.reservations[i];
            var div = document.createElement("div");
            var s = humanize_timestamp_string(one_resv.start_time()) + " - " +
                humanize_timestamp_string(one_resv.end_time()) + " " +
                formal_name(one_resv.usr());
            /* FIXME: The above need patron barcode instead of name, but
             * that requires a fix in the middle layer to flesh on the
             * right stuff. */
            div.appendChild(document.createTextNode(s));
            td.appendChild(div);
        }
        return td;
    }

    var baseid = dom_table_rowid(one.current_resource.id());

    var cells = [];
    cells.push(cell(undefined, one.target_resource_type.name()));
    cells.push(cell(undefined, one.current_resource.barcode()));
    cells.push(cell(baseid + "_call_number", "-"));
    cells.push(cell(baseid + "_copy_location", "-"));
    cells.push(cell(baseid + "_copy_number", "-"));
    cells.push(reservation_info_cell(one));

    var row = document.createElement("tr");
    row.setAttribute("id", baseid);

    for (var i in cells) row.appendChild(cells[i]);
    return row;
}

function render_pull_list_fundamentals(list) {
    var rows = [];

    for (var i in list)
        rows.push(generate_result_row(list[i]));

    document.getElementById("the_table_body").innerHTML = "";

    for (var i in rows)
        document.getElementById("the_table_body").appendChild(rows[i]);
}

function get_all_relevant_acp(list) {
    var barcodes = [];
    for (var i in list) {
        if (list[i].target_resource_type.catalog_item()) {
            /* There shouldn't be any duplicates. No need to worry bout that */
            barcodes.push(list[i].current_resource.barcode());
        }
    }
    var results = fieldmapper.standardRequest(
        [
            "open-ils.booking",
            "open-ils.booking.asset.get_copy_fleshed_just_right"
        ],
        [xulG.auth.session.key, barcodes]
    );

    if (!results) {
        alert(localeStrings.COPY_LOOKUP_NO_RESPONSE);
        return null;
    } else if (is_ils_error(results)) {
        alert(my_ils_error(localeStrings.COPY_LOOKUP_ERROR, results));
        return null;
    } else {
        return results;
    }
}

function fill_in_pull_list_details(list, acp_cache) {
    for (var i in list) {
        var one = list[i];
        if (one.target_resource_type.catalog_item() == "t") {
            /* FIXME: This block could stand to be a lot more elegant. */
            var call_number_el = document.getElementById(
                dom_table_rowid(one.current_resource.id()) + "_call_number"
            );
            var copy_location_el = document.getElementById(
                dom_table_rowid(one.current_resource.id()) + "_copy_location"
            );
            var copy_number_el = document.getElementById(
                dom_table_rowid(one.current_resource.id()) + "_copy_number"
            );

            var bc = one.current_resource.barcode();

            if (acp_cache[bc]) {
                if (call_number_el && acp_cache[bc].call_number()) {
                    var value = acp_cache[bc].call_number().label();
                    if (value) call_number_el.innerHTML = value;
                }
                if (copy_location_el && acp_cache[bc].location()) {
                    var value = acp_cache[bc].location().name();
                    if (value) copy_location_el.innerHTML = value;
                }
                if (copy_number_el) {
                    var value = acp_cache[bc].copy_number();
                    if (value) copy_number_el.innerHTML = value;
                }
            } else {
                alert(localeStrings.COPY_MISSING + bc);
            }
        }
    }
}

function populate_pull_list(form) {
    /* Step 1: get the pull list from the server. */
    try {
        var results = retrieve_pull_list(form.interval_in_days.value);
    } catch (E) {
        alert(localeStrings.PULL_LIST_ERROR + E);
        return;
    }
    if (results == null) {
        alert(localeStrings.PULL_LIST_NO_RESPONSE);
        return;
    } else if (is_ils_error(results)) {
        alert(my_ils_error(localeStrings.PULL_LIST_ERROR, results));
        return;
    }

    /* Step 2: render the table with the pull list */
    render_pull_list_fundamentals(results);

    /* Step 3: asynchronously fill in the copy details we're missing */
    setTimeout(function() {
        var acp_cache = {};
        if ((acp_cache = get_all_relevant_acp(results)))
            fill_in_pull_list_details(results, acp_cache);
    }, 0);
}

function my_init() {
    init_pickup_lib_selector();
    init_auto_l10n(document.getElementById("auto_l10n_start_here"));
}
