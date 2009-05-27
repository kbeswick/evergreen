// vim: noet:sw=4:ts=4:
var xmlDeclaration = /^<\?xml version[^>]+?>/;

var serializer = new XMLSerializer();
var marcns = new Namespace("http://www.loc.gov/MARC21/slim");
var gw = new Namespace("http://opensrf.org/-/namespaces/gateway/v1");
var xulns = new Namespace("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");
default xml namespace = marcns;

var tooltip_hash = {};
var current_focus;
var _record;
var _record_type;
var bib_data;

var xml_record;

var context_menus;
var tag_menu;
var p;

function $(id) { return document.getElementById(id); }

function mangle_005() {
	var now = new Date();
	var y = now.getUTCFullYear();

	var m = now.getUTCMonth() + 1;
	if (m < 10) m = '0' + m;
	
	var d = now.getUTCDate();
	if (d < 10) d = '0' + d;
	
	var H = now.getUTCHours();
	if (H < 10) H = '0' + H;
	
	var M = now.getUTCMinutes();
	if (M < 10) M = '0' + M;
	
	var S = now.getUTCSeconds();
	if (S < 10) S = '0' + S;
	

	var stamp = '' + y + m + d + H + M + S + '.0';
	createControlField('005',stamp);

}

function createControlField (tag,data) {
	// first, remove the old field, if any;
	for (var i in xml_record.controlfield.(@tag == tag)) delete xml_record.controlfield.(@tag == tag)[i];

	var cf = <controlfield tag="" xmlns="http://www.loc.gov/MARC21/slim">{ data }</controlfield>;
	cf.@tag = tag;

	// then, find the right position and insert it
	var done = 0;
	var cfields = xml_record.controlfield;
	var base = Number(tag.substring(2));
	for (var i in cfields) {
		var t = Number(cfields[i].@tag.toString().substring(2));
		if (t > base) {
			xml_record.insertChildBefore( cfields[i], cf );
			done = 1
			break;
		}
	}

	if (!done) xml_record.insertChildBefore( xml_record.datafield[0], cf );

	return cf;
}

function xml_escape_unicode ( str ) {
	return str.replace(
		/([\u0080-\ufffe])/g,
		function (r,s) { return "&#x" + s.charCodeAt(0).toString(16) + ";"; }
	);
}

function my_init() {
	try {

		netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
		if (typeof JSAN == 'undefined') { throw( $("commonStrings").getString('common.jsan.missing') ); }
		JSAN.errorLevel = "die"; // none, warn, or die
		JSAN.addRepository('/xul/server/');

		// Fake xulG for standalone...
		try {
			window.xulG.record;
		} catch (e) {
			window.xulG = {};
			window.xulG.record = {};
			window.xulG.save = {};

			window.xulG.save.label = $('catStrings').getString('staff.cat.marcedit.save.label');
			window.xulG.save.func = function (r) { alert(r); }

			var cgi = new CGI();
			var _rid = cgi.param('record');
			if (_rid) {
				window.xulG.record.url = '/opac/extras/supercat/retrieve/marcxml/record/' + _rid;
			}
		}
		// End faking part...

		document.getElementById('save-button').setAttribute('label', window.xulG.save.label);
		document.getElementById('save-button').setAttribute('oncommand',
			'mangle_005(); ' + 
			'var xml_string = xml_escape_unicode( xml_record.toXMLString() ); ' + 
			'save_attempt( xml_string ); ' +
			'loadRecord(xml_record);'
		);

		if (window.xulG.record.url) {
			var req =  new XMLHttpRequest();
			req.open('POST',window.xulG.record.url,false);
			req.send(null);
			window.xulG.record.marc = req.responseText.replace(xmlDeclaration, '');
		}

		xml_record = new XML( window.xulG.record.marc );
		if (xml_record..record[0]) xml_record = xml_record..record[0];

		// Get the tooltip xml all async like
		req =  new XMLHttpRequest();

		// Set a default locale in case preferences fail us
		var locale = "en-US";

		// Try to get the locale from our preferences
		netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
		try {
			const Cc = Components.classes;
			const Ci = Components.interfaces;
			locale = Cc["@mozilla.org/preferences-service;1"].
				getService(Ci.nsIPrefBranch).
				getCharPref("general.useragent.locale");
		}
		catch (e) { }

		// TODO: We should send a HEAD request to check for the existence of the desired file
		// then fall back to the default locale if preferred locale is not necessary;
		// however, for now we have a simplistic check:
		//
		// we currently have translations for only two locales; in the absence of a
		// valid locale, default to the almighty en-US
		if (locale != 'en-US' && locale != 'fr-CA') {
			locale = 'en-US';
		}

		// Get the locale-specific tooltips
		req.open('GET','/xul/server/locale/' + locale + '/marcedit-tooltips.xml',true);

		context_menus = createComplexXULElement('popupset');
		document.documentElement.appendChild( context_menus );

		tag_menu = createPopup({position : 'after_start', id : 'tags_popup'});
		context_menus.appendChild( tag_menu );

		tag_menu.appendChild(
			createMenuitem(
				{ label : $('catStrings').getString('staff.cat.marcedit.add_row.label'),
				  oncommand : 
					'var e = document.createEvent("KeyEvents");' +
					'e.initKeyEvent("keypress",1,1,null,1,0,0,0,13,0);' +
					'current_focus.inputField.dispatchEvent(e);'
				 }
			)
		);

		tag_menu.appendChild(
			createMenuitem(
				{ label : $('catStrings').getString('staff.cat.marcedit.insert_row.label'),
				  oncommand : 
					'var e = document.createEvent("KeyEvents");' +
					'e.initKeyEvent("keypress",1,1,null,1,0,1,0,13,0);' +
					'current_focus.inputField.dispatchEvent(e);'
				 }
			)
		);

		tag_menu.appendChild(
			createMenuitem(
				{ label : $('catStrings').getString('staff.cat.marcedit.remove_row.label'),
				  oncommand : 
					'var e = document.createEvent("KeyEvents");' +
					'e.initKeyEvent("keypress",1,1,null,1,0,0,0,46,0);' +
					'current_focus.inputField.dispatchEvent(e);'
				}
			)
		);

		tag_menu.appendChild( createComplexXULElement( 'separator' ) );

		tag_menu.appendChild(
			createMenuitem(
				{ label : $('catStrings').getString('staff.cat.marcedit.replace_006.label'),
				  oncommand : 
					'var e = document.createEvent("KeyEvents");' +
					'e.initKeyEvent("keypress",1,1,null,1,0,0,0,64,0);' +
					'current_focus.inputField.dispatchEvent(e);'
				 }
			)
		);

		tag_menu.appendChild(
			createMenuitem(
				{ label : $('catStrings').getString('staff.cat.marcedit.replace_007.label'),
				  oncommand : 
					'var e = document.createEvent("KeyEvents");' +
					'e.initKeyEvent("keypress",1,1,null,1,0,0,0,65,0);' +
					'current_focus.inputField.dispatchEvent(e);'
				}
			)
		);

		tag_menu.appendChild(
			createMenuitem(
				{ label : $('catStrings').getString('staff.cat.marcedit.replace_008.label'),
				  oncommand : 
					'var e = document.createEvent("KeyEvents");' +
					'e.initKeyEvent("keypress",1,1,null,1,0,0,0,66,0);' +
					'current_focus.inputField.dispatchEvent(e);'
				}
			)
		);

		tag_menu.appendChild( createComplexXULElement( 'separator' ) );

		p = createComplexXULElement('popupset');
		document.documentElement.appendChild( p );

		req.onreadystatechange = function () {
			if (req.readyState == 4) {
				bib_data = new XML( req.responseText.replace(xmlDeclaration, '') );
				genToolTips();
			}
		}
		req.send(null);

		loadRecord(xml_record);

        if (! xulG.fast_add_item) {
            document.getElementById('fastItemAdd_checkbox').hidden = true;
        }
        document.getElementById('fastItemAdd_textboxes').hidden = document.getElementById('fastItemAdd_checkbox').hidden || !document.getElementById('fastItemAdd_checkbox').checked;

	} catch(E) {
		alert('FIXME, MARC Editor, my_init: ' + E);
	}
}


function createComplexHTMLElement (e, attrs, objects, text) {
	var l = document.createElementNS('http://www.w3.org/1999/xhtml',e);

	if (attrs) {
		for (var i in attrs) l.setAttribute(i,attrs[i]);
	}

	if (objects) {
		for ( var i in objects ) l.appendChild( objects[i] );
	}

	if (text) {
		l.appendChild( document.createTextNode(text) )
	}

	return l;
}

function createComplexXULElement (e, attrs, objects) {
	var l = document.createElementNS('http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul',e);

	if (attrs) {
		for (var i in attrs) {
			if (typeof attrs[i] == 'function') {
				l.addEventListener( i, attrs[i], true );
			} else {
				l.setAttribute(i,attrs[i]);
			}
		}
	} 

	if (objects) {
		for ( var i in objects ) l.appendChild( objects[i] );
	}

	return l;
}

function createDescription (attrs) {
	return createComplexXULElement('description', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createTooltip (attrs) {
	return createComplexXULElement('tooltip', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createLabel (attrs) {
	return createComplexXULElement('label', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createVbox (attrs) {
	return createComplexXULElement('vbox', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createHbox (attrs) {
	return createComplexXULElement('hbox', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createRow (attrs) {
	return createComplexXULElement('row', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createTextbox (attrs) {
	return createComplexXULElement('textbox', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createMenu (attrs) {
	return createComplexXULElement('menu', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createMenuPopup (attrs) {
	return createComplexXULElement('menupopup', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createPopup (attrs) {
	return createComplexXULElement('popup', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createMenuitem (attrs) {
	return createComplexXULElement('menuitem', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createCheckbox (attrs) {
	return createComplexXULElement('checkbox', attrs, Array.prototype.slice.apply(arguments, [1]) );
}

function createMARCTextbox (element,attrs) {

	var box = createComplexXULElement('textbox', attrs, Array.prototype.slice.apply(arguments, [2]) );
	box.onkeypress = function (event) {
		var root_node;
		var node = element;
		while(node = node.parent()) {
			root_node = node;
		}

		var row = event.target;
		while (row.tagName != 'row') row = row.parentNode;

		if (element.nodeKind() == 'attribute') element[0]=box.value;
		else element.setChildren( box.value );

		if (element.localName() != 'controlfield') {
			if ((event.charCode == 100 || event.charCode == 105) && event.ctrlKey) { // ctrl+d or ctrl+i

				var index_sf, target, move_data;
				if (element.localName() == 'subfield') {
					index_sf = element;
					target = event.target.parentNode;

					var start = event.target.selectionStart;
					var end = event.target.selectionEnd - event.target.selectionStart ?
							event.target.selectionEnd :
							event.target.value.length;

					move_data = event.target.value.substring(start,end);
					event.target.value = event.target.value.substring(0,start) + event.target.value.substring(end);
					event.target.setAttribute('size', event.target.value.length + 2);
	
					element.setChildren( event.target.value );

				} else if (element.localName() == 'code') {
					index_sf = element.parent();
					target = event.target.parentNode;
				} else if (element.localName() == 'tag' || element.localName() == 'ind1' || element.localName() == 'ind2') {
					index_sf = element.parent().children()[element.parent().children().length() - 1];
					target = event.target.parentNode.lastChild.lastChild;
				}

				var sf = <subfield code="" xmlns="http://www.loc.gov/MARC21/slim">{ move_data }</subfield>;

				index_sf.parent().insertChildAfter( index_sf, sf );

				var new_sf = marcSubfield(sf);

				if (target === target.parentNode.lastChild) {
					target.parentNode.appendChild( new_sf );
				} else {
					target.parentNode.insertBefore( new_sf, target.nextSibling );
				}

				new_sf.firstChild.nextSibling.focus();

				event.preventDefault();
				return false;

			} else if (event.keyCode == 13 || event.keyCode == 77) {
				if (event.ctrlKey) { // ctrl+enter

					var index;
					if (element.localName() == 'subfield') index = element.parent();
					if (element.localName() == 'code') index = element.parent().parent();
					if (element.localName() == 'tag') index = element.parent();
					if (element.localName() == 'ind1') index = element.parent();
					if (element.localName() == 'ind2') index = element.parent();

					var df = <datafield tag="" ind1="" ind2="" xmlns="http://www.loc.gov/MARC21/slim"><subfield code="" /></datafield>;

					if (event.shiftKey) { // ctrl+shift+enter
						index.parent().insertChildBefore( index, df );
					} else {
						index.parent().insertChildAfter( index, df );
					}

					var new_df = marcDatafield(df);

					if (row.parentNode.lastChild === row) {
						row.parentNode.appendChild( new_df );
					} else {
						if (event.shiftKey) { // ctrl+shift+enter
							row.parentNode.insertBefore( new_df, row );
						} else {
							row.parentNode.insertBefore( new_df, row.nextSibling );
						}
					}

					new_df.firstChild.focus();

					event.preventDefault();
					return false;

				} else if (event.shiftKey) {
					if (row.previousSibling.className.match('marcDatafieldRow'))
						row.previousSibling.firstChild.focus();
				} else {
					row.nextSibling.firstChild.focus();
				}

			} else if (event.keyCode == 38 || event.keyCode == 40) { // up-arrow or down-arrow
				if (event.ctrlKey) { // CTRL key: copy the field
					var index;
					if (element.localName() == 'subfield') index = element.parent();
					if (element.localName() == 'code') index = element.parent().parent();
					if (element.localName() == 'tag') index = element.parent();
					if (element.localName() == 'ind1') index = element.parent();
					if (element.localName() == 'ind2') index = element.parent();

					var copyField = index.copy();

					if (event.keyCode == 38) { // ctrl+up-arrow
						index.parent().insertChildBefore( index, copyField );
					} else {
						index.parent().insertChildAfter( index, copyField );
					}

					var new_df = marcDatafield(copyField);

					if (row.parentNode.lastChild === row) {
						row.parentNode.appendChild( new_df );
					} else {
						if (event.keyCode == 38) { // ctrl+up-arrow
							row.parentNode.insertBefore( new_df, row );
						} else { // ctrl+down-arrow
							row.parentNode.insertBefore( new_df, row.nextSibling );
						}
					}

					new_df.firstChild.focus();

					event.preventDefault();

					return false;
				}

			} else if (event.keyCode == 46 && event.ctrlKey) { // ctrl+del

				var index;
				if (element.localName() == 'subfield') index = element.parent();
				if (element.localName() == 'code') index = element.parent().parent();
				if (element.localName() == 'tag') index = element.parent();
				if (element.localName() == 'ind1') index = element.parent();
				if (element.localName() == 'ind2') index = element.parent();

				for (var i in index.parent().children()) {
					if (index === index.parent().children()[i]) {
						delete index.parent().children()[i];
						break;
					}
				}

				row.previousSibling.firstChild.focus();
				row.parentNode.removeChild(row);

				event.preventDefault();
				return false;

			} else if (event.keyCode == 46 && event.shiftKey) { // shift+del

				var index;
				if (element.localName() == 'subfield') index = element;
				if (element.localName() == 'code') index = element.parent();

				if (index) {
					for (var i in index.parent().children()) {
						if (index === index.parent().children()[i]) {
							delete index.parent().children()[i];
							break;
						}
					}

					if (event.target.parentNode === event.target.parentNode.parentNode.lastChild) {
						event.target.parentNode.previousSibling.lastChild.focus();
					} else {
						event.target.parentNode.nextSibling.firstChild.nextSibling.focus();
					}

					event.target.parentNode.parentNode.removeChild(event.target.parentNode);

					event.preventDefault();
					return false;
				}
			} else if (event.keyCode == 64 && event.ctrlKey) { // ctrl + F6
				createControlField('006','');
				loadRecord(xml_record);
			} else if (event.keyCode == 65 && event.ctrlKey) { // ctrl + F7
				createControlField('007','');
				loadRecord(xml_record);
			} else if (event.keyCode == 66 && event.ctrlKey) { // ctrl + F8
				createControlField('008','');
				loadRecord(xml_record);
			}
			return true;
		}
	};

	box.addEventListener(
		'keypress', 
		function () {
			if (element.nodeKind() == 'attribute') element[0]=box.value;
			else element.setChildren( box.value );
			return true;
		},
		false
	);

	box.addEventListener(
		'change', 
		function () {
			if (element.nodeKind() == 'attribute') element[0]=box.value;
			else element.setChildren( box.value );
			return true;
		},
		false
	);

	box.addEventListener(
		'keypress', 
		function () {
			if (element.nodeKind() == 'attribute') element[0]=box.value;
			else element.setChildren( box.value );
			return true;
		},
		true
	);

	box.addEventListener(
		'keyup', 
		function () {
			if (element.localName() == 'controlfield')
				eval('fillFixedFields(xml_record);');
		},
		true
	);

	return box;
}

var rec_type = {
	BKS : { Type : /[at]{1}/,	BLvl : /[acdm]{1}/ },
	SER : { Type : /[a]{1}/,	BLvl : /[bs]{1}/ },
	VIS : { Type : /[gkro]{1}/,	BLvl : /[abcdms]{1}/ },
	MIX : { Type : /[p]{1}/,	BLvl : /[cd]{1}/ },
	MAP : { Type : /[ef]{1}/,	BLvl : /[abcdms]{1}/ },
	SCO : { Type : /[cd]{1}/,	BLvl : /[abcdms]{1}/ },
	REC : { Type : /[ij]{1}/,	BLvl : /[abcdms]{1}/ },
	COM : { Type : /[m]{1}/,	BLvl : /[abcdms]{1}/ }
};

var ff_pos = {
	TrAr : {
		_8 : {
			SCO : {start : 33, len : 1, def : ' ' },
			REC : {start : 33, len : 1, def : 'n' }
		},
		_6 : {
			SCO : {start : 16, len : 1, def : ' ' },
			REC : {start : 16, len : 1, def : 'n' }
		}
	},
	TMat : {
		_8 : {
			VIS : {start : 33, len : 1, def : ' ' }
		},
		_6 : {
			VIS : {start : 16, len : 1, def : ' ' }
		}
	},
	Time : {
		_8 : {
			VIS : {start : 18, len : 3, def : ' ' }
		},
		_6 : {
			VIS : {start : 1, len : 3, def : ' ' }
		}
	},
	Tech : {
		_8 : {
			VIS : {start : 34, len : 1, def : 'n' }
		},
		_6 : {
			VIS : {start : 17, len : 1, def : 'n' }
		}
	},
	SrTp : {
		_8 : {
			SER : {start : 21, len : 1, def : ' ' }
		},
		_6 : {
			SER : {start : 4, len : 1, def : ' ' }
		}
	},
	Srce : {
		_8 : {
			BKS : {start : 39, len : 1, def : 'd' },
			SER : {start : 39, len : 1, def : 'd' },
			VIS : {start : 39, len : 1, def : 'd' },
			MIX : {start : 39, len : 1, def : 'd' },
			MAP : {start : 39, len : 1, def : 'd' },
			SCO : {start : 39, len : 1, def : 'd' },
			REC : {start : 39, len : 1, def : 'd' },
			COM : {start : 39, len : 1, def : 'd' }
		}
	},
	SpFm : {
		_8 : {
			MAP : {start : 33, len : 2, def : ' ' }
		},
		_6 : {
			MAP : {start : 16, len : 2, def : ' ' }
		}
	},
	Relf : {
		_8 : {
			MAP : {start : 18, len : 4, def : ' ' }
		},
		_6 : {
			MAP : {start : 1, len : 4, def : ' ' }
		}
	},
	Regl : {
		_8 : {
			SER : {start : 19, len : 1, def : ' ' }
		},
		_6 : {
			SER : {start : 2, len : 1, def : ' ' }
		}
	},
	Proj : {
		_8 : {
			MAP : {start : 22, len : 2, def : ' ' }
		},
		_6 : {
			MAP : {start : 5, len : 2, def : ' ' }
		}
	},
	Part : {
		_8 : {
			SCO : {start : 21, len : 1, def : ' ' },
			REC : {start : 21, len : 1, def : 'n' }
		},
		_6 : {
			SCO : {start : 4, len : 1, def : ' ' },
			REC : {start : 4, len : 1, def : 'n' }
		}
	},
	Orig : {
		_8 : {
			SER : {start : 22, len : 1, def : ' ' }
		},
		_6 : {
			SER : {start : 5, len : 1, def : ' ' }
		}
	},
	LTxt : {
		_8 : {
			SCO : {start : 30, len : 2, def : ' ' },
			REC : {start : 30, len : 2, def : ' ' }
		},
		_6 : {
			SCO : {start : 13, len : 2, def : ' ' },
			REC : {start : 13, len : 2, def : ' ' }
		}
	},
	Freq : {
		_8 : {
			SER : {start : 18, len : 1, def : ' ' }
		},
		_6 : {
			SER : {start : 1, len : 1, def : ' ' }
		}
	},
	FMus : {
		_8 : {
			SCO : {start : 20, len : 1, def : ' ' },
			REC : {start : 20, len : 1, def : 'n' }
		},
		_6 : {
			SCO : {start : 3, len : 1, def : ' ' },
			REC : {start : 3, len : 1, def : 'n' }
		}
	},
	File : {
		_8 : {
			COM : {start : 26, len : 1, def : 'u' }
		},
		_6 : {
			COM : {start : 9, len : 1, def : 'u' }
		}
	},
	EntW : {
		_8 : {
			SER : {start : 24, len : 1, def : ' ' }
		},
		_6 : {
			SER : {start : 7, len : 1, def : ' ' }
		}
	},
	AccM : {
		_8 : {
			SCO : {start : 24, len : 6, def : ' ' },
			REC : {start : 24, len : 6, def : ' ' }
		},
		_6 : {
			SCO : {start : 7, len : 6, def : ' ' },
			REC : {start : 7, len : 6, def : ' ' }
		}
	},
	Comp : {
		_8 : {
			SCO : {start : 18, len : 2, def : ' ' },
			REC : {start : 18, len : 2, def : ' ' }
		},
		_6 : {
			SCO : {start : 1, len : 2, def : ' ' },
			REC : {start : 1, len : 2, def : ' ' }
		}
	},
	CrTp : {
		_8 : {
			MAP : {start : 25, len : 1, def : ' ' }
		},
		_6 : {
			MAP : {start : 8, len : 1, def : ' ' }
		}
	},
	Ctry : {
		_8 : {
			BKS : {start : 15, len : 3, def : ' ' },
			SER : {start : 15, len : 3, def : ' ' },
			VIS : {start : 15, len : 3, def : ' ' },
			MIX : {start : 15, len : 3, def : ' ' },
			MAP : {start : 15, len : 3, def : ' ' },
			SCO : {start : 15, len : 3, def : ' ' },
			REC : {start : 15, len : 3, def : ' ' },
			COM : {start : 15, len : 3, def : ' ' }
		}
	},
	Lang : {
		_8 : {
			BKS : {start : 35, len : 3, def : ' ' },
			SER : {start : 35, len : 3, def : ' ' },
			VIS : {start : 35, len : 3, def : ' ' },
			MIX : {start : 35, len : 3, def : ' ' },
			MAP : {start : 35, len : 3, def : ' ' },
			SCO : {start : 35, len : 3, def : ' ' },
			REC : {start : 35, len : 3, def : ' ' },
			COM : {start : 35, len : 3, def : ' ' }
		}
	},
	MRec : {
		_8 : {
			BKS : {start : 38, len : 1, def : ' ' },
			SER : {start : 38, len : 1, def : ' ' },
			VIS : {start : 38, len : 1, def : ' ' },
			MIX : {start : 38, len : 1, def : ' ' },
			MAP : {start : 38, len : 1, def : ' ' },
			SCO : {start : 38, len : 1, def : ' ' },
			REC : {start : 38, len : 1, def : ' ' },
			COM : {start : 38, len : 1, def : ' ' }
		}
	},
	DtSt : {
		_8 : {
			BKS : {start : 6, len : 1, def : ' ' },
			SER : {start : 6, len : 1, def : 'c' },
			VIS : {start : 6, len : 1, def : ' ' },
			MIX : {start : 6, len : 1, def : ' ' },
			MAP : {start : 6, len : 1, def : ' ' },
			SCO : {start : 6, len : 1, def : ' ' },
			REC : {start : 6, len : 1, def : ' ' },
			COM : {start : 6, len : 1, def : ' ' }
		}
	},
	Type : {
		ldr : {
			BKS : {start : 6, len : 1, def : 'a' },
			SER : {start : 6, len : 1, def : 'a' },
			VIS : {start : 6, len : 1, def : 'g' },
			MIX : {start : 6, len : 1, def : 'p' },
			MAP : {start : 6, len : 1, def : 'e' },
			SCO : {start : 6, len : 1, def : 'c' },
			REC : {start : 6, len : 1, def : 'i' },
			COM : {start : 6, len : 1, def : 'm' }
		}
	},
	Ctrl : {
		ldr : {
			BKS : {start : 8, len : 1, def : ' ' },
			SER : {start : 8, len : 1, def : ' ' },
			VIS : {start : 8, len : 1, def : ' ' },
			MIX : {start : 8, len : 1, def : ' ' },
			MAP : {start : 8, len : 1, def : ' ' },
			SCO : {start : 8, len : 1, def : ' ' },
			REC : {start : 8, len : 1, def : ' ' },
			COM : {start : 8, len : 1, def : ' ' }
		}
	},
	BLvl : {
		ldr : {
			BKS : {start : 7, len : 1, def : 'm' },
			SER : {start : 7, len : 1, def : 's' },
			VIS : {start : 7, len : 1, def : 'm' },
			MIX : {start : 7, len : 1, def : 'c' },
			MAP : {start : 7, len : 1, def : 'm' },
			SCO : {start : 7, len : 1, def : 'm' },
			REC : {start : 7, len : 1, def : 'm' },
			COM : {start : 7, len : 1, def : 'm' }
		}
	},
	Desc : {
		ldr : {
			BKS : {start : 18, len : 1, def : ' ' },
			SER : {start : 18, len : 1, def : ' ' },
			VIS : {start : 18, len : 1, def : ' ' },
			MIX : {start : 18, len : 1, def : ' ' },
			MAP : {start : 18, len : 1, def : ' ' },
			SCO : {start : 18, len : 1, def : ' ' },
			REC : {start : 18, len : 1, def : ' ' },
			COM : {start : 18, len : 1, def : ' ' }
		}
	},
	ELvl : {
		ldr : {
			BKS : {start : 17, len : 1, def : ' ' },
			SER : {start : 17, len : 1, def : ' ' },
			VIS : {start : 17, len : 1, def : ' ' },
			MIX : {start : 17, len : 1, def : ' ' },
			MAP : {start : 17, len : 1, def : ' ' },
			SCO : {start : 17, len : 1, def : ' ' },
			REC : {start : 17, len : 1, def : ' ' },
			COM : {start : 17, len : 1, def : ' ' }
		}
	},
	Indx : {
		_8 : {
			BKS : {start : 31, len : 1, def : '0' },
			MAP : {start : 31, len : 1, def : '0' }
		},
		_6 : {
			BKS : {start : 14, len : 1, def : '0' },
			MAP : {start : 14, len : 1, def : '0' }
		}
	},
	Date1 : {
		_8 : {
			BKS : {start : 7, len : 4, def : ' ' },
			SER : {start : 7, len : 4, def : ' ' },
			VIS : {start : 7, len : 4, def : ' ' },
			MIX : {start : 7, len : 4, def : ' ' },
			MAP : {start : 7, len : 4, def : ' ' },
			SCO : {start : 7, len : 4, def : ' ' },
			REC : {start : 7, len : 4, def : ' ' },
			COM : {start : 7, len : 4, def : ' ' }
		}
	},
	Date2 : {
		_8 : {
			BKS : {start : 11, len : 4, def : ' ' },
			SER : {start : 11, len : 4, def : '9' },
			VIS : {start : 11, len : 4, def : ' ' },
			MIX : {start : 11, len : 4, def : ' ' },
			MAP : {start : 11, len : 4, def : ' ' },
			SCO : {start : 11, len : 4, def : ' ' },
			REC : {start : 11, len : 4, def : ' ' },
			COM : {start : 11, len : 4, def : ' ' }
		}
	},
	LitF : {
		_8 : {
			BKS : {start : 33, len : 1, def : '0' }
		},
		_6 : {
			BKS : {start : 16, len : 1, def : '0' }
		}
	},
	Biog : {
		_8 : {
			BKS : {start : 34, len : 1, def : ' ' }
		},
		_6 : {
			BKS : {start : 17, len : 1, def : ' ' }
		}
	},
	Ills : {
		_8 : {
			BKS : {start : 18, len : 4, def : ' ' }
		},
		_6 : {
			BKS : {start : 1, len : 4, def : ' ' }
		}
	},
	Fest : {
		_8 : {
			BKS : {start : 30, len : 1, def : '0' }
		},
		_6 : {
			BKS : {start : 13, len : 1, def : '0' }
		}
	},
	Conf : {
		_8 : {
			BKS : {start : 29, len : 1, def : '0' },
			SER : {start : 29, len : 1, def : '0' }
		},
		_6 : {
			BKS : {start : 12, len : 1, def : '0' },
			SER : {start : 12, len : 1, def : '0' }
		}
	},
	Cont : {
		_8 : {
			BKS : {start : 24, len : 4, def : ' ' },
			SER : {start : 25, len : 3, def : ' ' }
		},
		_6 : {
			BKS : {start : 7, len : 4, def : ' ' },
			SER : {start : 8, len : 3, def : ' ' }
		}
	},
	GPub : {
		_8 : {
			BKS : {start : 28, len : 1, def : ' ' },
			SER : {start : 28, len : 1, def : ' ' },
			VIS : {start : 28, len : 1, def : ' ' },
			MAP : {start : 28, len : 1, def : ' ' },
			COM : {start : 28, len : 1, def : ' ' }
		},
		_6 : {
			BKS : {start : 11, len : 1, def : ' ' },
			SER : {start : 11, len : 1, def : ' ' },
			VIS : {start : 11, len : 1, def : ' ' },
			MAP : {start : 11, len : 1, def : ' ' },
			COM : {start : 11, len : 1, def : ' ' }
		}
	},
	Audn : {
		_8 : {
			BKS : {start : 22, len : 1, def : ' ' },
			SER : {start : 22, len : 1, def : ' ' },
			VIS : {start : 22, len : 1, def : ' ' },
			SCO : {start : 22, len : 1, def : ' ' },
			REC : {start : 22, len : 1, def : ' ' },
			COM : {start : 22, len : 1, def : ' ' }
		},
		_6 : {
			BKS : {start : 5, len : 1, def : ' ' },
			SER : {start : 5, len : 1, def : ' ' },
			VIS : {start : 5, len : 1, def : ' ' },
			SCO : {start : 5, len : 1, def : ' ' },
			REC : {start : 5, len : 1, def : ' ' },
			COM : {start : 5, len : 1, def : ' ' }
		}
	},
	Form : {
		_8 : {
			BKS : {start : 23, len : 1, def : ' ' },
			SER : {start : 23, len : 1, def : ' ' },
			VIS : {start : 29, len : 1, def : ' ' },
			MIX : {start : 23, len : 1, def : ' ' },
			MAP : {start : 29, len : 1, def : ' ' },
			SCO : {start : 23, len : 1, def : ' ' },
			REC : {start : 23, len : 1, def : ' ' }
		},
		_6 : {
			BKS : {start : 6, len : 1, def : ' ' },
			SER : {start : 6, len : 1, def : ' ' },
			VIS : {start : 12, len : 1, def : ' ' },
			MIX : {start : 6, len : 1, def : ' ' },
			MAP : {start : 12, len : 1, def : ' ' },
			SCO : {start : 6, len : 1, def : ' ' },
			REC : {start : 6, len : 1, def : ' ' }
		}
	},
	'S/L' : {
		_8 : {
			SER : {start : 34, len : 1, def : '0' }
		},
		_6 : {
			SER : {start : 17, len : 1, def : '0' }
		}
	},
	'Alph' : {
		_8 : {
			SER : {start : 33, len : 1, def : ' ' }
		},
		_6 : {
			SER : {start : 16, len : 1, def : ' ' }
		}
	}
};

function recordType (rec) {
	try {
		var _l = rec.leader.toString();

		var _t = _l.substr(ff_pos.Type.ldr.BKS.start, ff_pos.Type.ldr.BKS.len);
		var _b = _l.substr(ff_pos.BLvl.ldr.BKS.start, ff_pos.BLvl.ldr.BKS.len);

		for (var t in rec_type) {
			if (_t.match(rec_type[t].Type) && _b.match(rec_type[t].BLvl)) {
				document.getElementById('recordTypeLabel').value = t;
				_record_type = t;
				return t;
			}
		}

		// in case we don't have a valid record type ...
		_record_type = 'BKS';
		return _record_type;

	} catch(E) {
		alert('FIXME, MARC Editor, recordType: ' + E);
	}
}

function toggleFFE () {
	var grid = document.getElementById('leaderGrid');
	if (grid.hidden) {
		grid.hidden = false;
	} else {
		grid.hidden = true;
	}
	return true;
}

function changeFFEditor (type) {
	var grid = document.getElementById('leaderGrid');
	grid.setAttribute('type',type);
}

function fillFixedFields (rec) {
	try {
			var grid = document.getElementById('leaderGrid');

			var rtype = _record_type;

			var _l = rec.leader.toString();
			var _6 = rec.controlfield.(@tag=='006').toString();
			var _7 = rec.controlfield.(@tag=='007').toString();
			var _8 = rec.controlfield.(@tag=='008').toString();

			var list = [];
			var pre_list = grid.getElementsByTagName('label');
			for (var i in pre_list) {
				if ( pre_list[i].getAttribute && pre_list[i].getAttribute('set').indexOf(grid.getAttribute('type')) > -1 ) {
					list.push( pre_list[i] );
				}
			}

			for (var i in list) {
				var name = list[i].getAttribute('name');

				if (!ff_pos[name])
					continue;

				var value = '';
				if ( ff_pos[name].ldr && ff_pos[name].ldr[rtype] )
					value = _l.substr(ff_pos[name].ldr[rtype].start, ff_pos[name].ldr[rtype].len);

				if ( ff_pos[name]._8 && ff_pos[name]._8[rtype] )
					value = _8.substr(ff_pos[name]._8[rtype].start, ff_pos[name]._8[rtype].len);

				if ( !value && ff_pos[name]._6 && ff_pos[name]._6[rtype] )
					value = _6.substr(ff_pos[name]._6[rtype].start, ff_pos[name]._6[rtype].len);

				if ( ff_pos[name]._7 && ff_pos[name]._7[rtype] )
					value = _7.substr(ff_pos[name]._7[rtype].start, ff_pos[name]._7[rtype].len);
				
				if (!value) {
					var d;
					var p;
					if (ff_pos[name].ldr && ff_pos[name].ldr[rtype]) {
						d = ff_pos[name].ldr[rtype].def;
						p = 'ldr';
					}

					if (ff_pos[name]._8 && ff_pos[name]._8[rtype]) {
						d = ff_pos[name]._8[rtype].def;
						p = '_8';
					}

					if (!value && ff_pos[name]._6 && ff_pos[name]._6[rtype]) {
						d = ff_pos[name]._6[rtype].def;
						p = '_6';
					}

					if (ff_pos[name]._7 && ff_pos[name]._7[rtype]) {
						d = ff_pos[name]._7[rtype].def;
						p = '_7';
					}

					if (!value) {
						for (var j = 0; j < ff_pos[name][p][rtype].len; j++) {
							value += d;
						}
					}
				}

				list[i].nextSibling.value = value;
			}

			return true;
	} catch(E) {
		alert('FIXME, MARC Editor, fillFixedFields: ' + E);
	}
}

function updateFixedFields (element) {
	var grid = document.getElementById('leaderGrid');
	var recGrid = document.getElementById('recGrid');

	var rtype = _record_type;
	var new_value = element.value;

	var parts = {
		ldr : _record.leader,
		_6 : _record.controlfield.(@tag=='006'),
		_7 : _record.controlfield.(@tag=='007'),
		_8 : _record.controlfield.(@tag=='008')
	};

	var name = element.getAttribute('name');
	for (var i in ff_pos[name]) {

		if (!ff_pos[name][i][rtype]) continue;
		if (!parts[i]) continue;

		var before = parts[i].substr(0, ff_pos[name][i][rtype].start);
		var after = parts[i].substr(ff_pos[name][i][rtype].start + ff_pos[name][i][rtype].len);

		for (var j = 0; new_value.length < ff_pos[name][i][rtype].len; j++) {
			new_value += ff_pos[name][i][rtype].def;
		}

		parts[i].setChildren( before + new_value + after );
		recGrid.getElementsByAttribute('tag',i)[0].lastChild.value = parts[i].toString();
	}

	return true;
}

function marcLeader (leader) {
	var row = createRow(
		{ class : 'marcLeaderRow',
		  tag : 'ldr' },
		createLabel(
			{ value : 'LDR',
			  class : 'marcTag',
			  tooltiptext : $('catStrings').getString('staff.cat.marcedit.marcTag.LDR.label') } ),
		createLabel(
			{ value : '',
			  class : 'marcInd1' } ),
		createLabel(
			{ value : '',
			  class : 'marcInd2' } ),
		createLabel(
			{ value : leader.text(),
			  class : 'marcLeader' } )
	);

	return row;
}

function marcControlfield (field) {
	tagname = field.@tag.toString().substr(2);
	var row;
	if (tagname == '1' || tagname == '3' || tagname == '6' || tagname == '7' || tagname == '8') {
		row = createRow(
			{ class : 'marcControlfieldRow',
			  tag : '_' + tagname },
			createLabel(
				{ value : field.@tag,
				  class : 'marcTag',
				  context : 'tags_popup',
				  onmouseover : 'getTooltip(this, "tag");',
				  tooltipid : 'tag' + field.@tag } ),
			createLabel(
				{ value : field.@ind1,
				  class : 'marcInd1',
				  onmouseover : 'getTooltip(this, "ind1");',
				  tooltipid : 'tag' + field.@tag + 'ind1val' + field.@ind1 } ),
			createLabel(
				{ value : field.@ind2,
				  class : 'marcInd2',
				  onmouseover : 'getTooltip(this, "ind2");',
				  tooltipid : 'tag' + field.@tag + 'ind2val' + field.@ind2 } ),
			createMARCTextbox(
				field,
				{ value : field.text(),
				  class : 'plain marcEditableControlfield',
				  name : 'CONTROL' + tagname,
				  oncontext : 'return false();',
				  size : 50,
				  maxlength : 50 } )
			);
	} else {
		row = createRow(
			{ class : 'marcControlfieldRow',
			  tag : '_' + tagname },
			createLabel(
				{ value : field.@tag,
				  class : 'marcTag',
				  onmouseover : 'getTooltip(this, "tag");',
				  tooltipid : 'tag' + field.@tag } ),
			createLabel(
				{ value : field.@ind1,
				  class : 'marcInd1',
				  onmouseover : 'getTooltip(this, "ind1");',
				  tooltipid : 'tag' + field.@tag + 'ind1val' + field.@ind1 } ),
			createLabel(
				{ value : field.@ind2,
				  class : 'marcInd2',
				  onmouseover : 'getTooltip(this, "ind2");',
				  tooltipid : 'tag' + field.@tag + 'ind2val' + field.@ind2 } ),
			createLabel(
				{ value : field.text(),
				  class : 'marcControlfield' } )
		);
	}

	return row;
}

function stackSubfields(checkbox) {
	var list = document.getElementsByAttribute('name','sf_box');

	var o = 'vertical';
	if (!checkbox.checked) o = 'horizontal';
	
	for (var i = 0; i < list.length; i++) {
		if (list[i]) list[i].setAttribute('orient',o);
	}
}

function fastItemAdd_toggle(checkbox) {
    var x = document.getElementById('fastItemAdd_textboxes');
    if (checkbox.checked) {
        x.hidden = false;
        document.getElementById('fastItemAdd_callnumber').focus();
        document.getElementById('fastItemAdd_callnumber').select();
    } else {
        x.hidden = true;
    }
}

function fastItemAdd_attempt(doc_id) {
    try {
        if (typeof window.xulG.fast_add_item != 'function') { return; }
        if (!document.getElementById('fastItemAdd_checkbox').checked) { return; }
        if (!document.getElementById('fastItemAdd_callnumber').value) { return; }
        if (!document.getElementById('fastItemAdd_barcode').value) { return; }
        window.xulG.fast_add_item( doc_id, document.getElementById('fastItemAdd_callnumber').value, document.getElementById('fastItemAdd_barcode').value );
    } catch(E) {
        alert('fastItemAdd_attempt: ' + E);
    }
}

function save_attempt(xml_string) {
    try {
        var result = window.xulG.save.func( xml_string );   
        if (result) {
            if (result.id) fastItemAdd_attempt(result.id);
            if (typeof result.on_complete == 'function') result.on_complete();
        }
    } catch(E) {
        alert('save_attempt: ' + E);
    }
}

function marcDatafield (field) {
	var row = createRow(
		{ class : 'marcDatafieldRow' },
		createMARCTextbox(
			field.@tag,
			{ value : field.@tag,
			  class : 'plain marcTag',
			  name : 'marcTag',
			  context : 'tags_popup',
			  oninput : 'if (this.value.length == 3) { this.nextSibling.focus(); }',
			  size : 3,
			  maxlength : 3,
			  onmouseover : 'current_focus = this; getTooltip(this, "tag");' } ),
		createMARCTextbox(
			field.@ind1,
			{ value : field.@ind1,
			  class : 'plain marcInd1',
			  name : 'marcInd1',
			  oninput : 'if (this.value.length == 1) { this.nextSibling.focus(); }',
			  size : 1,
			  maxlength : 1,
			  onmouseover : 'current_focus = this; getContextMenu(this, "ind1"); getTooltip(this, "ind1");',
			  oncontextmenu : 'getContextMenu(this, "ind1");' } ),
		createMARCTextbox(
			field.@ind2,
			{ value : field.@ind2,
			  class : 'plain marcInd2',
			  name : 'marcInd2',
			  oninput : 'if (this.value.length == 1) { this.nextSibling.firstChild.firstChild.focus(); }',
			  size : 1,
			  maxlength : 1,
			  onmouseover : 'current_focus = this; getContextMenu(this, "ind2"); getTooltip(this, "ind2");',
			  oncontextmenu : 'getContextMenu(this, "ind2");' } ),
		createHbox({ name : 'sf_box' })
	);

	if (!current_focus && field.@tag == '') current_focus = row.childNodes[0];
	if (!current_focus && field.@ind1 == '') current_focus = row.childNodes[1];
	if (!current_focus && field.@ind2 == '') current_focus = row.childNodes[2];

	var sf_box = row.lastChild;
	if (document.getElementById('stackSubfields').checked)
		sf_box.setAttribute('orient','vertical');

	sf_box.addEventListener(
		'click',
		function (e) {
			if (sf_box === e.target) {
				sf_box.lastChild.lastChild.focus();
			} else if (e.target.parentNode === sf_box) {
				e.target.lastChild.focus();
			}
		},
		false
	);


	for (var i in field.subfield) {
		var sf = field.subfield[i];
		sf_box.appendChild(
			marcSubfield(sf)
		);

		if (sf.@code == '' && (!current_focus || current_focus.className.match(/Ind/)))
			current_focus = sf_box.lastChild.childNodes[1];
	}

	return row;
}

function marcSubfield (sf) {			
	return createHbox(
		{ class : 'marcSubfieldBox' },
		createLabel(
			{ value : "\u2021",
			  class : 'plain marcSubfieldDelimiter',
			  onmouseover : 'getTooltip(this.nextSibling, "subfield");',
			  oncontextmenu : 'getContextMenu(this.nextSibling, "subfield");',
	  		  //onclick : 'this.nextSibling.focus();',
	  		  onfocus : 'this.nextSibling.focus();',
			  size : 2 } ),
		createMARCTextbox(
			sf.@code,
			{ value : sf.@code,
			  class : 'plain marcSubfieldCode',
			  name : 'marcSubfieldCode',
			  onmouseover : 'current_focus = this; getContextMenu(this, "subfield"); getTooltip(this, "subfield");',
			  oncontextmenu : 'getContextMenu(this, "subfield");',
			  oninput : 'if (this.value.length == 1) { this.nextSibling.focus(); }',
			  size : 2,
			  maxlength : 1 } ),
		createMARCTextbox(
			sf,
			{ value : sf.text(),
			  name : sf.parent().@tag + ':' + sf.@code,
			  class : 'plain marcSubfield', 
			  onmouseover : 'getTooltip(this, "subfield");',
			  contextmenu : function (event) { getAuthorityContextMenu(event.target, sf) },
			  size : new String(sf.text()).length + 2,
			  oninput : "this.setAttribute('size', this.value.length + 2);"
			} )
	);
}

function loadRecord(rec) {
	try {
			_record = rec;
			var grid_rows = document.getElementById('recGrid').lastChild;

			while (grid_rows.firstChild) grid_rows.removeChild(grid_rows.firstChild);

			grid_rows.appendChild( marcLeader( rec.leader ) );

			for (var i in rec.controlfield) {
				grid_rows.appendChild( marcControlfield( rec.controlfield[i] ) );
			}

			for (var i in rec.datafield) {
				grid_rows.appendChild( marcDatafield( rec.datafield[i] ) );
			}

			grid_rows.getElementsByAttribute('class','marcDatafieldRow')[0].firstChild.focus();
			changeFFEditor(recordType(rec));
			fillFixedFields(rec);
	} catch(E) {
		alert('FIXME, MARC Editor, loadRecord: ' + E);
	}
}


function genToolTips () {
	for (var i in bib_data.field) {
		var f = bib_data.field[i];
	
		tag_menu.appendChild(
			createMenuitem(
				{ label : f.@tag,
				  oncommand : 
				  	'current_focus.value = "' + f.@tag + '";' +
					'var e = document.createEvent("MutationEvents");' +
					'e.initMutationEvent("change",1,1,null,0,0,0,0);' +
					'current_focus.inputField.dispatchEvent(e);',
				  disabled : f.@tag < '010' ? "true" : "false",
				  tooltiptext : f.description }
			)
		);
	
		var i1_popup = createPopup({position : 'after_start', id : 't' + f.@tag + 'i1' });
		context_menus.appendChild( i1_popup );
	
		var i2_popup = createPopup({position : 'after_start', id : 't' + f.@tag + 'i2' });
		context_menus.appendChild( i2_popup );
	
		var sf_popup = createPopup({position : 'after_start', id : 't' + f.@tag + 'sf' });
		context_menus.appendChild( sf_popup );
	
		tooltip_hash['tag' + f.@tag] = f.description;
		for (var j in f.indicator) {
			var ind = f.indicator[j];
			tooltip_hash['tag' + f.@tag + 'ind' + ind.@position + 'val' + ind.@value] = ind.description;
	
			if (ind.@position == 1) {
				i1_popup.appendChild(
					createMenuitem(
						{ label : ind.@value,
						  oncommand : 
				  			'current_focus.value = "' + ind.@value + '";' +
							'var e = document.createEvent("MutationEvents");' +
							'e.initMutationEvent("change",1,1,null,0,0,0,0);' +
							'current_focus.inputField.dispatchEvent(e);',
						  tooltiptext : ind.description }
					)
				);
			}
	
			if (ind.@position == 2) {
				i2_popup.appendChild(
					createMenuitem(
						{ label : ind.@value,
						  oncommand : 
				  			'current_focus.value = "' + ind.@value + '";' +
							'var e = document.createEvent("MutationEvents");' +
							'e.initMutationEvent("change",1,1,null,0,0,0,0);' +
							'current_focus.inputField.dispatchEvent(e);',
						  tooltiptext : ind.description }
					)
				);
			}
		}
	
		for (var j in f.subfield) {
			var sf = f.subfield[j];
			tooltip_hash['tag' + f.@tag + 'sf' + sf.@code] = sf.description;
	
			sf_popup.appendChild(
				createMenuitem(
					{ label : sf.@code,
					  oncommand : 
			  			'current_focus.value = "' + sf.@code + '";' +
						'var e = document.createEvent("MutationEvents");' +
						'e.initMutationEvent("change",1,1,null,0,0,0,0);' +
						'current_focus.inputField.dispatchEvent(e);',
					  tooltiptext : sf.description
					}
				)
			);
		}
	}
}

function getTooltip (target, type) {

	var tt = '';
	if (type == 'subfield')
		tt = 'tag' + target.parentNode.parentNode.parentNode.firstChild.value + 'sf' + target.parentNode.childNodes[1].value;

	if (type == 'ind1')
		tt = 'tag' + target.parentNode.firstChild.value + 'ind1val' + target.value;

	if (type == 'ind2')
		tt = 'tag' + target.parentNode.firstChild.value + 'ind2val' + target.value;

	if (type == 'tag')
		tt = 'tag' + target.parentNode.firstChild.value;

	if (!document.getElementById( tt )) {
		p.appendChild(
			createTooltip(
				{ id : tt,
				  flex : "1",
				  orient : 'vertical',
				  onpopupshown : 'this.width = this.firstChild.boxObject.width + 10; this.height = this.firstChild.boxObject.height + 10;',
				  class : 'tooltip' },
				createDescription({}, document.createTextNode( tooltip_hash[tt] ) )
			)
		);
	}

	target.tooltip = tt;
	return true;
}

function getContextMenu (target, type) {

	var tt = '';
	if (type == 'subfield')
		tt = 't' + target.parentNode.parentNode.parentNode.firstChild.value + 'sf';

	if (type == 'ind1')
		tt = 't' + target.parentNode.firstChild.value + 'i1';

	if (type == 'ind2')
		tt = 't' + target.parentNode.firstChild.value + 'i2';

	target.setAttribute('context', tt);
	return true;
}

var authority_tag_map = {
	100 : ['[100,400,500,700]',100],
	400 : ['[100,400,500,700]',100],
	700 : ['[100,400,500,700]',100],
	800 : ['[100,400,500,700]',100],
	110 : ['[110,410,510,710]',110],
	410 : ['[110,410,510,710]',110],
	710 : ['[110,410,510,710]',110],
	810 : ['[110,410,510,710]',110],
	111 : ['[111,411,511,711]',111],
	411 : ['[111,411,511,711]',111],
	711 : ['[111,411,511,711]',111],
	811 : ['[111,411,511,711]',111],
	240 : ['[130,430,530,730]',130],
	440 : ['[130,430,530,730]',130],
	130 : ['[130,430,530,730]',130],
	730 : ['[130,430,530,730]',130],
	830 : ['[130,430,530,730]',130],
	600 : ['[100,400,480,481,482,485,500,580,581,582,585,700,780,781,782,785]',100],
	650 : ['[150,450,480,481,482,485,550,580,581,582,585,750,780,781,782,785]',150],
	651 : ['[151,451,480,481,482,485,551,580,581,582,585,751,780,781,782,785]',151],
	655 : ['[155,455,480,481,482,485,555,580,581,582,585,755,780,781,782,785]',155]
};

function getAuthorityContextMenu (target, sf) {
	var menu_id = sf.parent().@tag + ':' + sf.@code + '-authority-context-' + sf;

	var old = document.getElementById( menu_id );
	if (old) old.parentNode.removeChild(old);

	var sf_popup = createPopup({ id : menu_id, flex : 1 });
	context_menus.appendChild( sf_popup );

	if (!authority_tag_map[sf.parent().@tag]) {
		sf_popup.appendChild(createLabel( { value : $('catStrings').getString('staff.cat.marcedit.not_authority_field.label') } ) );
		target.setAttribute('context', menu_id);
		return false;
	}

	var auth_data = searchAuthority( sf, authority_tag_map[sf.parent().@tag][0], sf.@code, 50);

	var res = new XML( auth_data.responseText );

	var rec_list = [];

	var recs = res.gw::payload.gw::array.gw::string;
	for (var i in recs) {
		var x = recs[i];
		var xml = new XML(x.toString());
		var main = xml.datafield.(@tag.toString().match(/^1/)).subfield;

		if (! (main[0].parent().@tag == authority_tag_map[sf.parent().@tag][1]) ) continue;

		var main_text = '';
		for (var i in main) {
			if (main_text) main_text += ' / ';
			main_text += main[i];
		}

		rec_list.push( [ main_text, xml ] );
	}
	
	for (var i in rec_list.sort( function (a, b) { if(a[0] > b[0]) return 1; return -1; } )) {

		var main_text = rec_list[i][0];
		var xml = rec_list[i][1];
		var main = xml.datafield.(@tag.toString().match(/^1/)).subfield;

		if (! (main[0].parent().@tag == authority_tag_map[sf.parent().@tag][1]) ) continue;

		var grid = document.getElementsByAttribute('name','authority-marc-template')[0].cloneNode(true);
		grid.setAttribute('name','-none-');
		grid.setAttribute('style','overflow:scroll');


		var submenu = createMenu( { label : main_text } );

		var popup = createMenuPopup({ flex : "1" });
		submenu.appendChild(popup);

		var fields = xml.datafield;
		for (var j in fields) {

			var row = createRow(
				{},
				createLabel( { value : fields[j].@tag } ),
				createLabel( { value : fields[j].@ind1 } ),
				createLabel( { value : fields[j].@ind2 } )
			);

			var sf_box = createHbox();

			var subfields = fields[j].subfield;
			for (var k in subfields) {
				sf_box.appendChild(
					createCheckbox(
						{ label    : '\u2021' + subfields[k].@code + ' ' + subfields[k],
						  subfield : subfields[k].@code,
						  tag      : subfields[k].parent().@tag,
						  value    : subfields[k]
						}
					)
				);
				row.appendChild(sf_box);
			}

			grid.lastChild.appendChild(row);
		}

		grid.hidden = false;
		popup.appendChild( grid );

		popup.appendChild(
			createMenuitem(
				{ label : $('catStrings').getString('staff.cat.marcedit.apply_selected.label'),
				  command : function (event) {
						applyAuthority(event.target.previousSibling, target, sf);
						return true;
				  }
				}
			)
		);

		sf_popup.appendChild( submenu );
	}

	if (sf_popup.childNodes.length == 0)
		sf_popup.appendChild(createLabel( { value : $('catStrings').getString('staff.cat.marcedit.no_authority_match.label') } ) );

	target.setAttribute('context', menu_id);
	return true;
}

function applyAuthority ( target, ui_sf, e4x_sf ) {

	var new_vals = target.getElementsByAttribute('checked','true');
	var field = e4x_sf.parent();

	for (var i = 0; i < new_vals.length; i++) {

		var sf_list = field.subfield;
		for (var j in sf_list) {

			if (sf_list[j].@code == new_vals[i].getAttribute('subfield')) {
				sf_list[j] = new_vals[i].getAttribute('value');
				new_vals[i].setAttribute('subfield','');
				break;
			}
		}
	}

	for (var i = 0; i < new_vals.length; i++) {
		if (!new_vals[i].getAttribute('subfield')) continue;

		var val = new_vals[i].getAttribute('value');

		var sf = <subfield code="" xmlns="http://www.loc.gov/MARC21/slim">{val}</subfield>;
		sf.@code = new_vals[i].getAttribute('subfield');

		field.insertChildAfter(field.subfield[field.subfield.length() - 1], sf);
	}

	var row = marcDatafield( field );

	var node = ui_sf;
	while (node.nodeName != 'row') {
		node = node.parentNode;
	}

	node.parentNode.replaceChild( row, node );
	return true;
}

var control_map = {
	100 : {
		'a' : { 100 : 'a' },
		'd' : { 100 : 'd' },
		'q' : { 100 : 'q' }
	},
	110 : {
		'a' : { 110 : 'a' },
		'd' : { 110 : 'd' }
	},
	111 : {
		'a' : { 111 : 'a' },
		'd' : { 111 : 'd' }
	},
	130 : {
		'a' : { 130 : 'a' },
		'd' : { 130 : 'd' }
	},
	240 : {
		'a' : { 130 : 'a' },
		'd' : { 130 : 'd' }
	},
	400 : {
		'a' : { 100 : 'a' },
		'd' : { 100 : 'd' }
	},
	410 : {
		'a' : { 110 : 'a' },
		'd' : { 110 : 'd' }
	},
	411 : {
		'a' : { 111 : 'a' },
		'd' : { 111 : 'd' }
	},
	440 : {
		'a' : { 130 : 'a' },
		'n' : { 130 : 'n' },
		'p' : { 130 : 'p' }
	},
	700 : {
		'a' : { 100 : 'a' },
		'd' : { 100 : 'd' },
		'q' : { 100 : 'q' },
		't' : { 100 : 't' }
	},
	710 : {
		'a' : { 110 : 'a' },
		'd' : { 110 : 'd' }
	},
	711 : {
		'a' : { 111 : 'a' },
		'd' : { 111 : 'd' }
	},
	730 : {
		'a' : { 130 : 'a' },
		'd' : { 130 : 'd' }
	},
	800 : {
		'a' : { 100 : 'a' },
		'd' : { 100 : 'd' }
	},
	810 : {
		'a' : { 110 : 'a' },
		'd' : { 110 : 'd' }
	},
	811 : {
		'a' : { 111 : 'a' },
		'd' : { 111 : 'd' }
	},
	830 : {
		'a' : { 130 : 'a' },
		'd' : { 130 : 'd' }
	},
	600 : {
		'a' : { 100 : 'a' },
		'd' : { 100 : 'd' },
		'q' : { 100 : 'q' },
		't' : { 100 : 't' },
		'v' : { 180 : 'v',
			100 : 'v',
			181 : 'v',
			182 : 'v',
			185 : 'v'
		},
		'x' : { 180 : 'x',
			100 : 'x',
			181 : 'x',
			182 : 'x',
			185 : 'x'
		},
		'y' : { 180 : 'y',
			100 : 'y',
			181 : 'y',
			182 : 'y',
			185 : 'y'
		},
		'z' : { 180 : 'z',
			100 : 'z',
			181 : 'z',
			182 : 'z',
			185 : 'z'
		}
	},
	610 : {
		'a' : { 110 : 'a' },
		'd' : { 110 : 'd' },
		't' : { 110 : 't' },
		'v' : { 180 : 'v',
			110 : 'v',
			181 : 'v',
			182 : 'v',
			185 : 'v'
		},
		'x' : { 180 : 'x',
			110 : 'x',
			181 : 'x',
			182 : 'x',
			185 : 'x'
		},
		'y' : { 180 : 'y',
			110 : 'y',
			181 : 'y',
			182 : 'y',
			185 : 'y'
		},
		'z' : { 180 : 'z',
			110 : 'z',
			181 : 'z',
			182 : 'z',
			185 : 'z'
		}
	},
	611 : {
		'a' : { 111 : 'a' },
		'd' : { 111 : 'd' },
		't' : { 111 : 't' },
		'v' : { 180 : 'v',
			111 : 'v',
			181 : 'v',
			182 : 'v',
			185 : 'v'
		},
		'x' : { 180 : 'x',
			111 : 'x',
			181 : 'x',
			182 : 'x',
			185 : 'x'
		},
		'y' : { 180 : 'y',
			111 : 'y',
			181 : 'y',
			182 : 'y',
			185 : 'y'
		},
		'z' : { 180 : 'z',
			111 : 'z',
			181 : 'z',
			182 : 'z',
			185 : 'z'
		}
	},
	630 : {
		'a' : { 130 : 'a' },
		'd' : { 130 : 'd' }
	},
	650 : {
		'a' : { 150 : 'a' },
		'b' : { 150 : 'b' },
		'v' : { 180 : 'v',
			150 : 'v',
			181 : 'v',
			182 : 'v',
			185 : 'v'
		},
		'x' : { 180 : 'x',
			150 : 'x',
			181 : 'x',
			182 : 'x',
			185 : 'x'
		},
		'y' : { 180 : 'y',
			150 : 'y',
			181 : 'y',
			182 : 'y',
			185 : 'y'
		},
		'z' : { 180 : 'z',
			150 : 'z',
			181 : 'z',
			182 : 'z',
			185 : 'z'
		}
	},
	651 : {
		'a' : { 151 : 'a' },
		'v' : { 180 : 'v',
			151 : 'v',
			181 : 'v',
			182 : 'v',
			185 : 'v'
		},
		'x' : { 180 : 'x',
			151 : 'x',
			181 : 'x',
			182 : 'x',
			185 : 'x'
		},
		'y' : { 180 : 'y',
			151 : 'y',
			181 : 'y',
			182 : 'y',
			185 : 'y'
		},
		'z' : { 180 : 'z',
			151 : 'z',
			181 : 'z',
			182 : 'z',
			185 : 'z'
		}
	},
	655 : {
		'a' : { 155 : 'a' },
		'v' : { 180 : 'v',
			155 : 'v',
			181 : 'v',
			182 : 'v',
			185 : 'v'
		},
		'x' : { 180 : 'x',
			155 : 'x',
			181 : 'x',
			182 : 'x',
			185 : 'x'
		},
		'y' : { 180 : 'y',
			155 : 'y',
			181 : 'y',
			182 : 'y',
			185 : 'y'
		},
		'z' : { 180 : 'z',
			155 : 'z',
			181 : 'z',
			182 : 'z',
			185 : 'z'
		}
	}
};

function validateAuthority (button) {
	var grid = document.getElementById('recGrid');
	var label = button.getAttribute('label');

	//loop over rows
	var rows = grid.lastChild.childNodes;
	for (var i = 0; i < rows.length; i++) {
		var row = rows[i];
		var tag = row.firstChild;

		if (!control_map[tag.value]) continue
		button.setAttribute('label', label + ' - ' + tag.value);

		var ind1 = tag.nextSibling;
		var ind2 = ind1.nextSibling;
		var subfields = ind2.nextSibling.childNodes;

        var tags = {};

		for (var j = 0; j < subfields.length; j++) {
			var sf = subfields[j];
            var sf_code = sf.childNodes[1].value;
            var sf_value = sf.childNodes[2].value;

			if (!control_map[tag.value][sf_code]) continue;

			var found = 0;
			for (var a_tag in control_map[tag.value][sf_code]) {
                if (!tags[a_tag]) tags[a_tag] = [];
                tags[a_tag].push({ term : sf_value, subfield : sf_code });
			}

		}

        for (var val_tag in tags) {
        	var auth_data = validateBibField( [val_tag], tags[val_tag]);
	        var res = new XML( auth_data.responseText );
	        found = parseInt(res.gw::payload.gw::string.toString());
            if (found) break;
        }

		// XXX If adt, etc should be validated separately from vxz, etc then move this up into the above for loop
		for (var j = 0; j < subfields.length; j++) {
			var sf = subfields[j];
   			if (!found) {
				sf.childNodes[2].inputField.style.color = 'red';
			} else {
				sf.childNodes[2].inputField.style.color = 'black';
			}
        }
	}

	button.setAttribute('label', label);

	return true;
}


function validateBibField (tags, searches) {
	var url = "/gateway?input_format=json&format=xml&service=open-ils.search&method=open-ils.search.authority.validate.tag";
	url += '&param="tags"&param=' + js2JSON(tags);
	url += '&param="searches"&param=' + js2JSON(searches);


	var req = new XMLHttpRequest();
	req.open('GET',url,false);
	req.send(null);

	return req;

}
function searchAuthority (term, tag, sf, limit) {
	var url = "/gateway?input_format=json&format=xml&service=open-ils.search&method=open-ils.search.authority.fts";
	url += '&param="term"&param="' + term + '"';
	url += '&param="limit"&param=' + limit;
	url += '&param="tag"&param=' + tag;
	url += '&param="subfield"&param="' + sf + '"';


	var req = new XMLHttpRequest();
	req.open('GET',url,false);
	req.send(null);

	return req;

}

