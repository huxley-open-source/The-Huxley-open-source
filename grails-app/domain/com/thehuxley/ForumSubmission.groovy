package com.thehuxley

import java.io.Serializable;

class ForumSubmission implements Serializable{
	public static final STATUS_OPEN= "OPEN"
	public static final STATUS_CLOSED= "CLOSED"
	public static final STATUS_ANSWERED= "ANSWERED"
	
	Submission submission
	String status
	ShiroUser user
	String message
	String title
	Date date
    Date changed
	
	static hasMany = [comment: SubmissionComment]
	
	static constraints = {
        submission(nullable: false)
		status(inList: ['OPEN', 'CLOSED', 'ANSWERED'])
        user(nullable: false)
        message(blank: false)
        title(nullable: true, maxSize: 255)
        date(nullable: false)
        changed(nullable: true)
	}

    static mapping = {
        message type: 'text'
    }
	
	
	
	
	public static ArrayList<ForumSubmission> mountByCommentDate(){
		
		return ForumSubmission.executeQuery("select f from ForumSubmission f inner join f.comment c  group by f.id order by c.date desc")
	}
	
	public static ArrayList<ForumSubmission> mountByCommentDateAndStatus(String statusToFind){
		
		return ForumSubmission.executeQuery("select f from ForumSubmission f inner join f.comment c where f.status = '"+statusToFind+"'  group by f.id order by c.date desc")
	}
	
	public static ArrayList<ForumSubmission> mountByCommentDateAndStatusAndUser(String statusToFind,long userId){
		
		return ForumSubmission.executeQuery("select f from ForumSubmission f inner join f.comment c where f.status = '"+statusToFind+"' and f.user.id = "+userId+"  group by f.id order by c.date desc")
	}
	
	public static ArrayList<ForumSubmission> mountByCommentDateAndUser(long userId){
		
		return ForumSubmission.executeQuery("select f from ForumSubmission f inner join f.comment c where f.user.id = "+userId+"  group by f.id order by c.date desc")
	}
	
	
}
