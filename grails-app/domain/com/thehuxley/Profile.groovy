package com.thehuxley

import java.io.Serializable;

class Profile implements Serializable{

	String name
	String photo
	String smallPhoto
	ShiroUser user
	int problemsTryed
	int problemsCorrect
	String hash
    Institution institution
    Date dateCreated
    Date lastUpdated
    int submissionCount
    int submissionCorrectCount
    	
	static constraints = {
		user(nullable: false, blank: false, unique: true)
		hash(nullable: true, unique: true)
        institution (nullable: true)
	}

    static mapping = {
        user lazy: false
    }
}
