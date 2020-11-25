package com.thehuxley

import java.io.Serializable;

class Institution implements Serializable{
	
    String name	
    String phone
    String photo
    int status

    static hasMany = [users : ShiroUser, licenses: License]
    static mappedBy = [licenses: "institution"]

    public static final int STATUS_WAITING = 0
    public static final int STATUS_ACCEPTED = 1
    public static final int STATUS_REJECTED = 2

    static mapping = {
        users lazy: false
    }
    
        
    static def userList(long user){
		ShiroUser userInstance = ShiroUser.get(user)
		ArrayList<Institution> institutionList = new ArrayList<Institution>()
		Institution.list().each{
			if(it.users.contains(userInstance)){
				institutionList.add(it)
			}
		}
		return institutionList
	}
	
    String toString(){
		return name
	}


}
