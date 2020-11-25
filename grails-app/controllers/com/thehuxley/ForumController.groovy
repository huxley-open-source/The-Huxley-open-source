package com.thehuxley

import com.thehuxley.container.forum.UserStatus
import com.thehuxley.container.forum.ForumContainer

class ForumController {
    def mongoService

    def index = {


    }

    def show = {
        [id:params.id]
    }

    def getForum = {
        render(contentType:"text/json") {
            content = huxley.forum(forumList:mongoService.getForumList(session.license.user.id,Integer.parseInt(params.offset),20))

        }

    }
    def getForumById = {
        render(contentType:"text/json") {
            content = huxley.forum(forumList:mongoService.getForum(params.id))

        }

    }



    def sendComment = {
        try {
            if(mongoService.insertForumMessage(session.license.user.id,params.c,new Date(System.currentTimeMillis()),params.fid)){
                render(contentType:"text/json") {
                    content = huxley.forumComment(comment:mongoService.getForum(params.fid).getLastMessage())
                }
            }
            return
        } catch (Exception e) {
            println e
            e.printStackTrace()
        }

        render 'error'
    }

    def getLastCommentList = {
        ArrayList<ForumContainer> forumList = mongoService.getForumList(session.license.user.id,0,20)
        String comments = ""
        forumList.each {
            comments += huxley.forumComment(comment:it.getLastMessage(),forumId:it.getId()) + "<hr></br>"
        }
        render(contentType:"text/json") {
            comment = comments
        }

    }

    def getNewMessageCount = {
        int totalCount = 0
        totalCount = mongoService.getForumUnreadCount(session.license.user.id)
        render(contentType:"text/json") {
            total = totalCount
        }

    }

    def updateForumStatus = {
        String answer = 'error'
        if (mongoService.updateForumStatus(session.license.user.id,params.id,UserStatus.STATUS_READ)){
            answer = 'ok'
        }
        render(contentType:"text/json") {
            status = answer
        }
    }

    def sendMessage = {
        def forumSubmission = new ForumSubmission()
        forumSubmission.message = params.m
        forumSubmission.user = session.license.user
        forumSubmission.status = ForumSubmission.STATUS_OPEN
        forumSubmission.date = new Date(System.currentTimeMillis())
        forumSubmission.changed = new Date(System.currentTimeMillis())
        forumSubmission.submission = Submission.get(params.sid);
        try {
            if((!session.license.isStudent())||(session.license.isStudent() && Submission.get(params.sid).user.id == session.license.user.id)){
                mongoService.insertForumSubmissionMessage(session.license.user.id,params.m,new Date(System.currentTimeMillis()),Long.parseLong(params.sid))
            }
            render "ok"
            return
        } catch (Exception e) {
            e.printStackTrace()
        }
        render "error"
    }

    def sendProblemReport = {
        println params

        try {
            mongoService.insertForumProblemReport(session.license.user.id,params.m,new Date(System.currentTimeMillis()),Long.parseLong(params.pid))
            render "ok"
            return
        } catch (Exception e) {
            e.printStackTrace()
        }
        render "error"
    }

    def updateForumToMongo = {
        ForumSubmission.list().each{ forum ->
            try {
                forum.comment.each{ comment ->
                    println "criado?" + mongoService.insertForumSubmissionMessage(comment.user.id,comment.comment,comment.date,forum.submission.id)
                }
            }catch(e){
                println "exceçao em:" + forum.id
            }
        }
    }


}