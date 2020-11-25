package com.thehuxley

class ContentService {

    def isComplete = {content, user ->

        def contentUserInstance = ContentUser.findByUserAndContent(user, content)

        if (contentUserInstance && contentUserInstance.status == ContentUser.COMPLETED) {
            return true
        }

        return false;
    }

    def changeStatus = {content, user, status ->
        def contentUserInstance = ContentUser.findByUserAndContent(user, content)

        if (!contentUserInstance) {
            contentUserInstance = new ContentUser()
            contentUserInstance.content = content
            contentUserInstance.user = user
        }

        contentUserInstance.status = status

        contentUserInstance.save();
    }

}
