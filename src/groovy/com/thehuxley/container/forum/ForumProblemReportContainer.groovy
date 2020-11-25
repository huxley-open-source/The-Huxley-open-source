package com.thehuxley.container.forum

import com.thehuxley.Problem

/**
 * Created with IntelliJ IDEA.
 * User: romero
 * Date: 4/29/13
 * Time: 3:39 PM
 * To change this template use File | Settings | File Templates.
 */
class ForumProblemReportContainer extends ForumContainer {
    private Problem problem

    public ForumProblemReportContainer(String id, Date lastUpdated, ArrayList<UserStatus> userList, ArrayList<ForumMessage> messageList){
        super(id,lastUpdated,userList,messageList)
    }

    public ForumProblemReportContainer(String id, Date lastUpdated, ArrayList<UserStatus> userList, ArrayList<ForumMessage> messageList,Problem problem){
        super(id,lastUpdated,userList,messageList)
        this.problem = problem
    }

    public boolean hasProblem(){
        return true;
    }

    public Problem getProblem(){
        return problem
    }
}
