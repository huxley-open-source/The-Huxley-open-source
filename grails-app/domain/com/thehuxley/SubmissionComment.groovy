package com.thehuxley

import java.io.Serializable;

class SubmissionComment implements Serializable, Comparable{

    static belongsTo = [forum:ForumSubmission]

    String comment
	Date date
	ShiroUser user

    static constraints = {
        comment(blank: false, maxSize: 2000)
        date(nullable: false)
        user(nullable: false)
    }

    static mapping = {
		comment type:"text"
	}

    public int compareTo(def other) {
        return date <=> other?.date
    }
}
