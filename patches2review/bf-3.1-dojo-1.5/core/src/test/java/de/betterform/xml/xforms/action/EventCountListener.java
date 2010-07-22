/*
 * Copyright (c) 2010. betterForm Project - http://www.betterform.de
 */

package de.betterform.xml.xforms.action;

import org.w3c.dom.events.EventListener;
import org.w3c.dom.events.Event;

public class EventCountListener implements EventListener {
    private int count;
    private String type;

    public EventCountListener(String type) {
        this.type = type;
        this.count = 0;
    }

    public void handleEvent(Event event) {
        if (event.getType().equals(this.type)) {
            this.count++;
        }
    }

    public int getCount() {
        return this.count;
    }
}
