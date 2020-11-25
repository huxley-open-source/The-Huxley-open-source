package com.thehuxley.container.forum

import com.thehuxley.ShiroUser

/**
 * Created with IntelliJ IDEA.
 * User: romero
 * Date: 4/29/13
 * Time: 3:07 PM
 * To change this template use File | Settings | File Templates.
 */
class ForumMessage {
    private ShiroUser user;
    private String message;
    private Date date;

    public ForumMessage(user,message,date){
        this.user = user
        this.message = message
        this.date = date
    }

    public ShiroUser getUser(){
        return user
    }

    public Date getDate(){
        return date
    }

    public String getMessage(){
        return message
    }
}
