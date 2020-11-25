package com.thehuxley.util

import org.apache.log4j.Logger;

import com.thehuxley.EmailToSend;
import com.thehuxley.HuxleySystemFail
import com.thehuxley.ShiroUser

class HuxleyExceptionHandler {
	

	public static void handle(Throwable t, ShiroUser u){
		HuxleySystemFail fail = new HuxleySystemFail(t,u)
		// Salva no banco de dados a exceção
		try{
			fail.save()
		}catch(Exception e){
			e.printStackTrace();
		}
		if (!fail.hasErrors()){
			// Tenta enviar email
			EmailToSend email = new EmailToSend()
			email.email = HuxleyProperties.getInstance().get("email.support")
			email.message = fail.formatAsHTML()
			email.status = EmailToSend.TO_SEND
			try{
				email.save()
				if (email.hasErrors()){
					email.errors.each {
						println it
					}
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}else{
			fail.errors.each {
				println it
			}
		}
	}

}
