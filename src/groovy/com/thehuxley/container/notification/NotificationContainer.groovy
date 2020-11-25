package com.thehuxley.container.notification

import com.thehuxley.container.forum.UserStatus

/**
 * Created with IntelliJ IDEA.
 * User: jose aureliano
 * Date: 9/6/13
 * Time: 9:45 AM
 * To change this template use File | Settings | File Templates.
 */
class NotificationContainer {
    private long notificationId
    private ArrayList<UserStatus> userList
    private Date createdAt
    private Date updateAt
    private String notificationTitle
    private String notificationResume

    NotificationContainer(long notificationId, ArrayList<UserStatus> userList, Date createdAt, Date updateAt, String notificationTitle, String notificationResume) {
        this.notificationId = notificationId
        this.userList = userList
        this.createdAt = createdAt
        this.updateAt = updateAt
        this.notificationTitle = notificationTitle
        this.notificationResume = notificationResume
    }

    public long getNotificationId() {
        return notificationId
    }

    public void setNotificationId(long notificationId) {
        this.notificationId = notificationId
    }

    public ArrayList<UserStatus> getUserList() {
        return userList
    }

    public void setUserList(ArrayList<UserStatus> userList) {
        this.userList = userList
    }

    public Date getCreatedAt() {
        return createdAt
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt
    }

    public String getNotificationTitle() {
        return notificationTitle
    }

    public void setNotificationTitle(String notificationTitle) {
        this.notificationTitle = notificationTitle
    }

    public String getNotificationResume() {
        return notificationResume
    }

    public void setNotificationResume(String notificationResume) {
        this.notificationResume = notificationResume
    }

    public Date getUpdateAt() {
        return updateAt
    }

    public void setUpdateAt(Date updateAt) {
        this.updateAt = updateAt
    }
}
