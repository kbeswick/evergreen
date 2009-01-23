if(!dojo._hasResource['openils.widget.EditPane']) {
    dojo.provide('openils.widget.EditPane');
    dojo.require('openils.widget.AutoWidget');
    dojo.require('openils.widget.AutoFieldWidget');
    dojo.require('fieldmapper.Fieldmapper');
    dojo.require('dijit.layout.ContentPane');
    dojo.require('openils.Util');
    dojo.require('openils.PermaCrud');

    dojo.declare(
        'openils.widget.EditPane',
        [dijit.layout.ContentPane, openils.widget.AutoWidget],
        {
            mode : 'update',
            fieldList : [], // holds the field name + associated widget
            onPostApply : null, // apply callback
            onCancel : null, // cancel callback
            hideActionButtons : false,

            constructor : function(args) {
                for(var k in args)
                    this[k] = args[k];
            },

            /**
             * Builds a basic table of key / value pairs.  Keys are IDL display labels.
             * Values are dijit's, when values set
             */
            startup : function() {
                this.inherited(arguments);
                this.initAutoEnv();

                var table = document.createElement('table');
                var tbody = document.createElement('tbody');
                this.domNode.appendChild(table);
                table.appendChild(tbody);

                this.limitPerms = [];
                if(this.fmIDL.permacrud && this.fmIDL.permacrud[this.mode])
                    this.limitPerms = this.fmIDL.permacrud[this.mode].perms;

                for(var f in this.sortedFieldList) {
                    var field = this.sortedFieldList[f];
                    if(!field || field.virtual) continue;

                    var row = document.createElement('tr');
                    var nameTd = document.createElement('td');
                    var valTd = document.createElement('td');

                    nameTd.appendChild(document.createTextNode(field.label));
                    row.appendChild(nameTd);
                    row.appendChild(valTd);
                    tbody.appendChild(row);

                    var widget = new openils.widget.AutoFieldWidget({
                        idlField : field, 
                        fmObject : this.fmObject,
                        parentNode : valTd,
                        orgLimitPerms : this.limitPerms
                    });
                    widget.build();
                    this.fieldList.push({name:field.name, widget:widget});
                }
                if(!this.hideActionButtons)
                    this.buildActionButtons(tbody);
    
                openils.Util.addCSSClass(table, 'oils-fm-edit-dialog');
            },

            buildActionButtons : function(tbody) {
                var row = document.createElement('tr');
                var cancelTd = document.createElement('td');
                var applyTd = document.createElement('td');
                row.appendChild(cancelTd);
                row.appendChild(applyTd);
                tbody.appendChild(row);

                var self = this;
                new dijit.form.Button({
                    label:'Cancel', // XXX
                    onClick : this.onCancel
                }, cancelTd);

                new dijit.form.Button({
                    label:'Save',  // XXX
                    onClick: function() {
                        self.performEditAction({
                            oncomplete:function() {
                                if(self.onPostApply)
                                    self.onPostApply();
                            }
                        });
                    }
                }, applyTd);
            },

            getFields : function() {
                return this.fieldList.map(function(a) { return a.name });
            },

            getFieldValue : function(field) {
                for(var i in this.fieldList) {
                    if(field == this.fieldList[i].name)
                        return this.fieldList[i].widget.getFormattedValue();
                }
            },

            performEditAction : function(opts) {
                var pcrud = new openils.PermaCrud();
                var fields = this.getFields();
                if(this.mode == 'create')
                    this.fmObject = new fieldmapper[this.fmClass]();
                for(var idx in fields) 
                    this.fmObject[fields[idx]](this.getFieldValue(fields[idx]));
                pcrud[this.mode](this.fmObject, opts);
            }
        }
    );
}

