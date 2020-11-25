package com.thehuxley

import java.io.Serializable;

import org.apache.commons.lang.StringEscapeUtils;

//import com.thehuxley.util.Constants;

class HuxleySystemFail implements Serializable{
	String message
	String stackTrace
	ShiroUser loggedUser
	Date timeOfError

	static mapping = {
		message type:"text"
		stackTrace type:"text"
	}

	static constraints = {
		message (nullable:true)
		loggedUser(nullable:true)
	}

	public HuxleySystemFail(){

	}

	public HuxleySystemFail(Throwable t, ShiroUser u) {
		if (t!=null){
			StringWriter sw = new StringWriter()
			PrintWriter pw = new PrintWriter(sw)
			t.printStackTrace(pw)

			stackTrace = sw.toString()
			message = t.getMessage()
		}else{
			stackTrace = "Vazio"
			message = "Vazio"
		}

		loggedUser = u
		timeOfError = new Date()
	}

	public String formatAsHTML(){
		String user = "Usuário não autenticado";
		if (loggedUser!=null){
			user = "[id:"+loggedUser.id+"] "+loggedUser.name;
		}
		String content = "<p><b>User:</b></br>"+StringEscapeUtils.escapeHtml(user)+"</p>";
		content+= "<p><b>Time:</b></br>"+StringEscapeUtils.escapeHtml(Constants.DATE_FORMAT.format(timeOfError))+"</p>";
		content+= "<p><b>Message:</b></br>"+StringEscapeUtils.escapeHtml(message)+"</p>";
		content+= "<p><b>Stacktrace:</b></br>"+StringEscapeUtils.escapeHtml(stackTrace)+"</p>";

		return content;
	}
}
