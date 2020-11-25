package com.thehuxley.container.forum

import com.thehuxley.ShiroUser

/**
 * Created with IntelliJ IDEA.
 * User: romero
 * Date: 4/29/13
 * Time: 3:13 PM
 * To change this template use File | Settings | File Templates.
 */
class UserStatus {
    public static final int STATUS_UNREAD = 0;
    public static final int STATUS_READ = 1;

    private ShiroUser user;
    private int status;

    public UserStatus(ShiroUser user, int status){
        this.user = user
        this.status = status
    }

    public ShiroUser getUser() {
        return user
    }

    public int getStatus() {
        return status
    }


}
