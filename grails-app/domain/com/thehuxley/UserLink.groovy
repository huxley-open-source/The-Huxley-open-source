package com.thehuxley

import java.io.Serializable;
import java.security.MessageDigest;

class UserLink implements Serializable{
	public static final int OPEN = 1
	public static final int CLOSED = 2
	ShiroUser user
	String link
	int status

	
	public static UserLink generate(long userId){
		UserLink userLinkInstance = new UserLink()
		Long time = System.currentTimeMillis()
		String link
		MessageDigest md
		
		md = MessageDigest.getInstance("MD5")
		
		BigInteger hash = new BigInteger(1, md.digest(time.toString().getBytes()))
		link = hash.toString(16)
		userLinkInstance.user = ShiroUser.get(userId)
		userLinkInstance.link = link
		userLinkInstance.status = OPEN
		userLinkInstance.save()
		return userLinkInstance
	}
	
	public static UserLink generate(ShiroUser user){
		UserLink userLinkInstance = new UserLink()
		Long time = System.currentTimeMillis()
		String link
		MessageDigest md
		
		md = MessageDigest.getInstance("MD5")
		
		BigInteger hash = new BigInteger(1, md.digest(time.toString().getBytes()))
		link = hash.toString(16)
		userLinkInstance.user = user
		userLinkInstance.link = link
		userLinkInstance.status = OPEN
		userLinkInstance.save()
		return userLinkInstance
	}
}
