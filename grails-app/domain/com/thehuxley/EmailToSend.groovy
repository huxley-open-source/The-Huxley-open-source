package com.thehuxley

import java.io.Serializable;

class EmailToSend implements Serializable{
	
	public static final String TO_SEND = "TOSEND" 
	
	String email
	String message
	String status
    String subject
    Date dateCreated
    Date lastUpdated


    static constraints = {
        subject nullable: true
    }
	
	static mapping = {
		message type:"text"
	}
}
