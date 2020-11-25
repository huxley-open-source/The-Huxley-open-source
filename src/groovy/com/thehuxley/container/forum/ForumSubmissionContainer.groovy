package com.thehuxley.container.forum

import com.thehuxley.Submission

/**
 * Created with IntelliJ IDEA.
 * User: romero
 * Date: 4/29/13
 * Time: 3:39 PM
 * To change this template use File | Settings | File Templates.
 */
class ForumSubmissionContainer extends ForumContainer {
    private Submission submission

    public ForumSubmissionContainer(String id, Date lastUpdated, ArrayList<UserStatus> userList, ArrayList<ForumMessage> messageList){
        super(id,lastUpdated,userList,messageList)
    }

    public ForumSubmissionContainer(String id, Date lastUpdated, ArrayList<UserStatus> userList, ArrayList<ForumMessage> messageList,Submission submission){
        super(id,lastUpdated,userList,messageList)
        this.submission = submission
    }

    public Submission getSubmission(){
        return submission
    }

    public boolean hasSubmission(){
        return true;
    }
}
