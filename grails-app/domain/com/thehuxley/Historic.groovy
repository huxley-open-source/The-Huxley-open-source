package com.thehuxley

import java.io.Serializable;
import java.util.Date;

class Historic implements Serializable{

	ShiroUser user
	Date date
	String action
	String controller
	

	
	public void initialize(ShiroUser user, String action, String controller){
		this.user = user
		date = new GregorianCalendar().getTime()
		this.action = action
		this.controller = controller
		this.save()
	}	
}
