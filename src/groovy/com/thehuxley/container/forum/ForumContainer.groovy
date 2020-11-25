package com.thehuxley.container.forum

import com.thehuxley.ShiroUser

/**
 * Created with IntelliJ IDEA.
 * User: romero
 * Date: 4/29/13
 * Time: 3:16 PM
 * To change this template use File | Settings | File Templates.
 */
class ForumContainer {
    private Date lastUpdated
    private ArrayList<UserStatus> userList
    private ArrayList<ForumMessage> messageList
    private String id;

    public ForumContainer(String id,Date lastUpdated, ArrayList<UserStatus> userList, ArrayList<ForumMessage> messageList){
        this.lastUpdated = lastUpdated
        this.userList = userList
        this.messageList = messageList
        this.id = id
    }

    public Date getLastUpdated() {
        return lastUpdated
    }

    public ArrayList<UserStatus> getUserList() {
        return userList
    }

    public ArrayList<ForumMessage> getMessageList() {
        return messageList
    }

    public String getId(){
        return id
    }

    //Retorna o Status de um dado usuário, se o usuário não existe retorna -1
    public int getUserStatus(ShiroUser user){
        int findResult = -1
        userList.each{
              if(it.getUser().id == user.id){
                  findResult = it.status
              }
        }
        return findResult
    }

    public ForumMessage getFirstMessage(){
        return messageList.get(0)
    }

    public ForumMessage getLastMessage(){
        return messageList.get(messageList.size() - 1)
    }

    public boolean hasSubmission(){
        return false;
    }

    public boolean hasProblem(){
        return false;
    }
}
