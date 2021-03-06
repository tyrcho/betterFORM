/*
 * Copyright (c) 2011. betterForm Project - http://www.betterform.de
 * Licensed under the terms of BSD License
 */

dojo.provide("betterform.ClientServerEvent");

/*
 This class represents the interface to the XForms processor (aka 'betterForm Web'). It is the only class
 actually having dependency on DWR to handle the AJAX part of things and calling remote Java methods on
 de.betterform.web.flux.FluxFacade.
 */
dojo.declare("betterform.ClientServerEvent",
        null,
{
    targetId:null,
    eventType:null,
    contextInfo:null,
    value:null,
    repeatItem:null,
    callerFunction:"",

    constructor: function() {
    },

    createClientServerEvent: function(targetId, eventType, contextInfo) {
        var newInstance = new betterform.ClientServerEvent();
        newInstance.targetId = targetId;
        newInstance.eventType = eventType;
        newInstance.contextInfo = contextInfo;
        return newInstance;
    },

    setTargetId: function(targetId) {
        this.targetId = targetId;
    },

    setEventType: function(eventType) {
        this.eventType = eventType;
    },

    setContextInfo: function(contextInfo) {
        this.contextInfo = contextInfo;
    },

    setValue: function(value) {
        this.value = value;
    },

    setRepeatItem: function(repeatItem) {
        this.repeatItem = repeatItem;
    },

    setCallerFunction: function(callerFunction) {
        this.callerFunction = callerFunction;
    },

    getTargetId: function() {
        return this.targetId;
    },

    getEventType: function() {
        return this.eventType;
    },

    getContextInfo: function() {
        return this.contextInfo;
    },

    getValue: function() {
        return this.value;
    },

    getRepeatItem: function() {
        return this.repeatItem;
    },

    getCallerFunction: function() {
        return this.callerFunction;
    }
}
        );
