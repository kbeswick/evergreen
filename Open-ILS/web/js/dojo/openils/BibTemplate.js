/* ---------------------------------------------------------------------------
 * Copyright (C) 2009  Equinox Software, Inc.
 * Mike Rylander <miker@esilibrary.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * ---------------------------------------------------------------------------
 */

if(!dojo._hasResource["openils.BibTemplate"]) {

    dojo.require('DojoSRF');
    dojo.require('dojox.data.dom');
    dojo.require('dojo.string');
    dojo._hasResource["openils.BibTemplate"] = true;
    dojo.provide("openils.BibTemplate");
    dojo.declare('openils.BibTemplate', null, {

        constructor : function(kwargs) {
            this.root = kwargs.root;
            this.subObjectLimit = kwargs.subObjectLimit;
            this.subObjectOffset = kwargs.subObjectOffset;
            this.tagURI = kwargs.tagURI;
            this.record = kwargs.record;
            this.org_unit = kwargs.org_unit || '-';
            this.depth = kwargs.depth;
            this.locale = kwargs.locale || OpenSRF.locale || 'en-US';

            this.mode = 'biblio-record_entry';
            this.default_datatype = 'marcxml-uris';
            if (kwargs.metarecord) {
                this.record = kwargs.metarecord;
                this.mode = 'metabib-metarecord';
                this.default_datatype = 'mods';
            }
        },

        render : function() {
            var all_slots = dojo.query('*[type^=opac/slot-data]', this.root);
            var default_datatype = this.default_datatype;
        
            var slots = {};
            dojo.forEach(all_slots, function(s){
                // marcxml-uris does not include copies, which avoids timeouts
                // with bib records that have hundreds or thousands of copies
                var current_datatype = default_datatype;
        
                if (s.getAttribute('datatype')) {
                    current_datatype = s.getAttribute('datatype');
                } else if (s.getAttribute('type').indexOf('+') > -1)  {
                    current_datatype = s.getAttribute('type').split('+').reverse()[0];
                }
        
                if (!slots[current_datatype]) slots[current_datatype] = [];
                slots[current_datatype].push(s);

            });
        
            for (var datatype in slots) {

                //(function (slot_list,dtype,mode,rec,org) {
                (function (args) {
                    var BT = args.renderer;

                    var uri = '';
                    if (BT.tagURI) {
                        uri = BT.tagURI;
                    } else {
                        uri = 'tag:evergreen-opac:' + BT.mode + '/' + BT.record;
                        if (BT.subObjectLimit) {
                            uri += '[' + BT.subObjectLimit;
                            if (BT.subObjectOffset)
                                uri += ',' + BT.subObjectOffset;
                            uri += ']';
                        }
                        uri += '/' + BT.org_unit;
                        if (BT.depth || BT.depth == '0') uri += '/' + BT.depth;
                    }

                    dojo.xhrGet({
                        url: '/opac/extras/unapi?id=' + uri + '&format=' + args.dtype + '&locale=' + BT.locale,
                        handleAs: 'xml',
                        load: function (bib) {

                            dojo.forEach(args.slot_list, function (slot) {
                                var joiner = slot.getAttribute('join') || ' ';
                                var item_limit = slot.getAttribute('limit');
                                var item_offset = slot.getAttribute('offset') || 0;

                                var item_list = dojo.query(
                                    slot.getAttribute('query'),
                                    bib
                                );

                                if (item_limit) item_list = item_list.splice(parseInt(item_offset),parseInt(item_limit));
                                if (!item_list.length) return;

                                var templated = slot.getAttribute('templated') == 'true';
                                if (templated) {
                                    var template_values = {};

                                    dojo.query(
                                        '*[type=opac/template-value]',
                                        slot
                                    ).orphan().forEach(function(x) {
                                        dojo.setObject(
                                            x.getAttribute('name'),
                                            (new Function( 'item_list', 'BT', 'slotXML', unescape(x.innerHTML) ))(item_list,BT,bib),
                                            template_values
                                        );
                                    });

                                    slot.innerHTML = dojo.string.substitute( unescape(slot.innerHTML), template_values );
                                }

                                var handler_node = dojo.query( '*[type=opac/slot-format]', slot )[0];
                                if (handler_node) slot_handler = new Function('item_list', 'BT', 'slotXML', 'item', dojox.data.dom.textContent(handler_node) || handler_node.innerHTML);
                                else slot_handler = new Function('item_list', 'BT', 'slotXML', 'item','return dojox.data.dom.textContent(item) || item.innerHTML;');
            
                                if (item_list.length) {
                                    var content = dojo.map(item_list, dojo.partial(slot_handler,item_list,BT,bib)).join(joiner);
                                    if (templated) handler_node.parentNode.replaceChild( dojo.doc.createTextNode( content ), handler_node );
                                    else slot.innerHTML = content;
                                }

                                delete(slot_handler);

                            });
                       }
                    });

                })({ slot_list : slots[datatype].reverse(), dtype : datatype, renderer : this });
            
            }

            return true;
        }
    });

}
