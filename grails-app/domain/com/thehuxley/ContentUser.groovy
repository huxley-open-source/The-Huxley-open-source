package com.thehuxley

class ContentUser {

    public static final String COMPLETED = "COMPLETED"
    public static final String NOT_COMPLETED = "NOT_COMPLETED"

    ShiroUser user;
    Content content;
    String status;
    Date dateCreated
    Date lastUpdated

    static constraints = {
    }
}
