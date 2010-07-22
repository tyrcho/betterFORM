/*
 * Copyright (c) 2010. betterForm Project - http://www.betterform.de
 * Licensed under the terms of BSD License
 */

dojo.provide("betterform.ui.upload.UploadPlain");

dojo.require("betterform.ui.ControlValue");
dojo.require("betterform.FluxProcessor");


dojo.declare(
        "betterform.ui.upload.UploadPlain",
        betterform.ui.ControlValue,
{

    templatePath: dojo.moduleUrl("betterform", "ui/templates/HtmlUpload.html"),
    
    // parameters
    value:"",
    disabledNodes: new Array(),
    progress: null,
    progressBackground: null,
    fileId:"",
    fileValue:"",
    xfControlId:"",
    progressUpdate:null,

    postMixInProperties:function() {
        // console.debug("Upload.postMixInProperties: this",this);
        this.inherited(arguments);
        this.applyProperties(dijit.byId(this.xfControlId), this.srcNodeRef);
    },

    postCreate:function() {
      // console.debug("Upload.postMixInProperties: START this",this);
      this.inherited(arguments);
      dojo.attr(this.inputNode,"name", dojo.attr(this.srcNodeRef,"name"));
      dojo.attr(this.fileName,"id", dojo.attr(this.srcNodeRef,"fileId"));
      dojo.attr(this.fileName,"value", dojo.attr(this.srcNodeRef,"fileValue"));
      dojo.removeClass(this.domNode, "xfValue");

    },

    _onFocus:function() {
        this.inherited(arguments);
        this.handleOnFocus();
    },

    _onBlur:function() {
        this.inherited(arguments);
        //this.handleOnBlur();
    },

    getControlValue:function() {
        console.warn("betterform.ui.upload.Upload.getControlValue");
    },

    _handleSetControlValue:function(value) {
        console.warn("betterform.ui.upload.Upload._handleSetControlValue");
    },


    onChange: function() {
        // console.debug("UploadPlain.onChange");
        var action = confirm("Really upload ?");
        if (action) {
            this._submitFile(this.inputNode);
        }
        else {
            this.inputNode.value = "";
        }
    },
    updateProgress: function (value) {
        // console.debug("UploadPlain.updateProgress: value",value);
        if (value != 0) {
            this.progressBackground.style.width = value + "%";
        }
        if (value < 0) {
            alert("Upload failed");
        }
        if (value == 100) {
            // stop polling
            // console.debug("UploadPlain.updateProgress before Clear Interval");
            clearInterval(this.progressUpdate);
            // console.debug("stopped polling");
            this.progressBackground.style.width = "100%";
            dojo.fadeOut({
                node: this.progress,
                duration:2000,
                onEnd: dojo.hitch(this,function() {
                    this.progress.style.display="none";
                })
            }).play();

            // reset disabled controls
            dojo.query(".xfUpload.xfReadWrite .xfValue:disabled").forEach(function(item) {
                  item.removeAttribute("disabled");
            });
        }
    },
    _submitFile: function() {
        // console.debug("UploadPlain._submitFile");

        // disable all controls contained in repeat prototypes to avoid
        // inconsistent updates.
        var me = this.inputNode;
        dojo.query(".xfUpload.xfReadWrite .xfValue").forEach(function(item) {
            if(item != me){
                //console.debug("Disable Upload Item: ", item);
                dojo.attr(item, "disabled", "disabled");
            }
        });

        /* Effect.BlindDown(this.xformsId + "-progress"); */
        this.progress.style.display="block";
        this.progress.style.opacity="1";
        var path = this.inputNode.value;
        var filename = path.substring(path.lastIndexOf("/") + 1);
        //polling betterForm for update information and submit the form
        this.progressUpdate = setInterval("fluxProcessor.fetchProgress('" + this.xfControlId + "','" + filename + "')", 500);

        document.forms["betterform"].target = "UploadTarget";
        document.forms["betterform"].submit();
        return true;
    },

    applyState:function(){
        // console.debug("UploadPlain.applyState");
        if(this.xfControl.isReadonly()){
            dojo.attr(this.inputNode,"disabled", "disabled");
        }else{
            this.inputNode.removeAttribute("disabled");
        }
    }
}
);


