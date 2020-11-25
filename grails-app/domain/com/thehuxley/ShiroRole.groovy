package com.thehuxley

import java.io.Serializable;

class ShiroRole implements Serializable{
    String name

    static hasMany = [ users: ShiroUser, permissions : String ]
    static belongsTo = ShiroUser

    static constraints = {
        name(nullable: false, blank: false, unique: true)
    }
    String toString(){
		return name
	}
}
