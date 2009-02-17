dojo.require('dojo.data.ItemFileReadStore');
dojo.require('dijit.form.Textarea');
dojo.require('dijit.form.FilteringSelect');
dojo.require('dijit.form.ComboBox');
dojo.require('fieldmapper.IDL');
dojo.require('openils.PermaCrud');
dojo.require('openils.widget.AutoGrid');
dojo.require('openils.widget.AutoFieldWidget');
dojo.require('dijit.form.CheckBox');
dojo.require('dijit.form.Button');

var pcrud;
var fmClasses = ['au', 'ac', 'aua', 'actsc', 'asv', 'asvq', 'asva'];
var fieldDoc = {};
var statCats;
var statCatTempate;
var surveys;
var staff;
var patron;
var uEditUsePhonePw = false;
var widgetPile = [];
var uEditCardVirtId = -1;
var uEditAddrVirtId = -1;


function load() {
    staff = new openils.User().user;
    pcrud = new openils.PermaCrud();
    
    var list = pcrud.search('fdoc', {fm_class:fmClasses});
    for(var i in list) {
        var doc = list[i];
        if(!fieldDoc[doc.fm_class()])
            fieldDoc[doc.fm_class()] = {};
        fieldDoc[doc.fm_class()][doc.field()] = doc;
    }

    var tbody = dojo.byId('uedit-tbody');
    statCatTemplate = tbody.removeChild(dojo.byId('stat-cat-row-template'));
    surveyTemplate = tbody.removeChild(dojo.byId('survey-row-template'));
    surveyQuestionTemplate = tbody.removeChild(dojo.byId('survey-question-row-template'));

    loadStaticFields(tbody);
    loadStatCats(tbody);
    loadSurveys(tbody);
}

function loadStaticFields(tbody) {
    // draw static user/addr fields
    for(var idx = 0; tbody.childNodes[idx]; idx++) {
        var row = tbody.childNodes[idx];
        if(row.nodeType != row.ELEMENT_NODE) continue;
        var fmcls = row.getAttribute('fmclass');
        if(!fmcls) continue;
        fleshFMRow(row, fmcls);
    }
}

function loadStatCats(tbody) {
    statCats = fieldmapper.standardRequest(
        ['open-ils.circ', 'open-ils.circ.stat_cat.actor.retrieve.all'],
        {params : [openils.User.authtoken, staff.ws_ou()]}
    );

    // draw stat cats
    for(var idx in statCats) {
        var stat = statCats[idx];
        var row = statCatTemplate.cloneNode(true);
        row.id = 'stat-cat-row-' + idx;
        tbody.appendChild(row);
        getByName(row, 'name').innerHTML = stat.name();
        var valtd = getByName(row, 'widget');
        var span = valtd.appendChild(document.createElement('span'));
        var store = new dojo.data.ItemFileReadStore(
                {data:fieldmapper.actsc.toStoreData(stat.entries())});
        var comboBox = new dijit.form.ComboBox({store:store}, span);
        comboBox.labelAttr = 'value';
        comboBox.searchAttr = 'value';

        comboBox._wtype = 'statcat';
        comboBox._statcat = stat.id();
        widgetPile.push(comboBox); 

    }
}

function loadSurveys(tbody) {

    surveys = fieldmapper.standardRequest(
        ['open-ils.circ', 'open-ils.circ.survey.retrieve.all'],
        {params : [openils.User.authtoken]}
    );

    // draw surveys
    for(var idx in surveys) {
        var survey = surveys[idx];
        var srow = surveyTemplate.cloneNode(true);
        tbody.appendChild(srow);
        getByName(srow, 'name').innerHTML = survey.name();

        for(var q in survey.questions()) {
            var quest = survey.questions()[q];
            var qrow = surveyQuestionTemplate.cloneNode(true);
            tbody.appendChild(qrow);
            getByName(qrow, 'question').innerHTML = quest.question();

            var span = getByName(qrow, 'answers').appendChild(document.createElement('span'));
            var store = new dojo.data.ItemFileReadStore(
                {data:fieldmapper.asva.toStoreData(quest.answers())});
            var select = new dijit.form.FilteringSelect({store:store}, span);
            select.labelAttr = 'answer';
            select.searchAttr = 'answer';

            select._wtype = 'survey';
            select._survey = survey.id();
            select._question = quest.id();
            widgetPile.push(select); 
        }
    }
}


function fleshFMRow(row, fmcls) {
    var fmfield = row.getAttribute('fmfield');
    var wclass = row.getAttribute('wclass');
    var wstyle = row.getAttribute('wstyle');
    var fieldIdl = fieldmapper.IDL.fmclasses[fmcls].field_map[fmfield];

    var existing = dojo.query('td', row);
    var htd = existing[0] || row.appendChild(document.createElement('td'));
    var ltd = existing[1] || row.appendChild(document.createElement('td'));
    var wtd = existing[2] || row.appendChild(document.createElement('td'));

    openils.Util.addCSSClass(htd, 'uedit-help');
    if(fieldDoc[fmcls] && fieldDoc[fmcls][fmfield]) {
        var link = dojo.byId('uedit-help-template').cloneNode(true);
        link.id = '';
        link.setAttribute('href', 'javascript:ueLoadContextHelp("'+fmcls+'","'+fmfield+'")');
        openils.Util.removeCSSClass(link, 'hidden');
        htd.appendChild(link);
    }

    if(!ltd.textContent) {
        var span = document.createElement('span');
        ltd.appendChild(document.createTextNode(fieldIdl.label));
    }

    span = document.createElement('span');
    wtd.appendChild(span);

    var widget = new openils.widget.AutoFieldWidget({
        idlField : fieldIdl,
        fmObject : null, // XXX
        fmClass : fmcls,
        parentNode : span,
        widgetClass : wclass,
        dijitArgs : {style: wstyle},
        orgLimitPerms : ['UPDATE_USER'],
    });
    widget.build();

    widget._wtype = fmcls;
    widget._fmfield = fmfield;
    widget._addr = uEditAddrVirtId;
    widgetPile.push(widget);
}

function getByName(node, name) {
    return dojo.query('[name='+name+']', node)[0];
}


function ueLoadContextHelp(fmcls, fmfield) {
    openils.Util.removeCSSClass(dojo.byId('uedit-help-div'), 'hidden');
    dojo.byId('uedit-help-field').innerHTML = fieldmapper.IDL.fmclasses[fmcls].field_map[fmfield].label;
    dojo.byId('uedit-help-text').innerHTML = fieldDoc[fmcls][fmfield].string();
}


/* creates a new patron object with card attached */
function uEditNewPatron() {
    patron = new au();
    patron.isnew(1);
    patron.id(-1);
    card = new ac();
    card.id(uEditCardVirtId--);
    card.isnew(1);
    patron.card(card);
    patron.cards([card]);
    //patron.net_access_level(defaultNetLevel);
    patron.stat_cat_entries([]);
    patron.survey_responses([]);
    patron.addresses([]);
    //patron.home_ou(USER.ws_ou());
    uEditMakeRandomPw(patron);
}

function uEditMakeRandomPw(patron) {
    if(uEditUsePhonePw) return;
    var rand  = Math.random();
    rand = parseInt(rand * 10000) + '';
    while(rand.length < 4) rand += '0';
/*
    appendClear($('ue_password_plain'),text(rand));
    unHideMe($('ue_password_gen'));
*/
    patron.passwd(rand);
    return rand;
}

function uEditWidgetVal(w) {
    var val = (w.getFormattedValue) ? w.getFormattedValue() : w.attr('value');
    if(val == '') val = null;
    return val;
}

function uEditSave() {
    if(!patron) uEditNewPatron();

    for(var idx in widgetPile) {
        var w = widgetPile[idx];
        console.log(w._wtype + ' : ' + w._fmfield + ' : ' + uEditWidgetVal(w));

        switch(w._wtype) {
            case 'au':
                patron[w._fmfield](uEditWidgetVal(w));
                break;

            case 'ac':
                patron.card()[w._fmfield](uEditWidgetVal(w));
                break;

            case 'aua':
                var addr = patron.addresses().filter(function(i){return (i.id() == w._addr)})[0];
                if(!addr) {
                    addr = new fieldmapper.aua();
                    addr.id(w._addr);
                    addr.isnew(1);
                    patron.addresses().push(addr);
                    console.log("pushing address " + addr.id());
                }
                addr[w._fmfield](uEditWidgetVal(w));
                break;

            case 'survey':
                var val = uEditWidgetVal(w);
                if(val == null) break;
                var resp = new fieldmapper.asvr();
                resp.isnew(1);
                resp.survey(w._survey)
                resp.usr(patron.id());
                resp.question(w._question)
                resp.answer(val);
                patron.survey_responses().push(resp);
                break;

            case 'statcat':
                var val = uEditWidgetVal(w);
                if(val == null) break;
                var map = new fieldmapper.actscecm();
                map.isnew(1);
                map.stat_cat(w._statcat);
                map.stat_cat_entry(val);
                map.target_usr(patron.id());
                patron.stat_cat_entries().push(map);
                break;
        }
    }

    console.log(js2JSON(patron.addresses()));
    alert(js2JSON(patron));

    fieldmapper.standardRequest(
        ['open-ils.actor', 'open-ils.actor.patron.update'],
        {   async: true,
            params: [openils.User.authtoken, patron],
            oncomplete: function(r) {
                patron = openils.Util.readResponse(r);
                if(patron) {
                    alert('success');
                    //uEditRefresh();
                } else {
                    alert('no success?');
                }
            }
        }
    );
}

function uEditRefresh() {
    var href = location.href;
    href = href.replace(/\&?clone=\d+/, '');
    location.href = href;
}







openils.Util.addOnLoad(load);

