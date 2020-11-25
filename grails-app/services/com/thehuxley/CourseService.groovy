package com.thehuxley

class CourseService {

    def getProgress = {course, user ->

        def teachingResources = course.teachingResources
        def completedCount = 0
        def formatNumber =

        teachingResources.each {
            if (it.problem) {
                def userProblemInstance = UserProblem.findByUserAndProblem(user, it.problem)
                if (userProblemInstance && userProblemInstance.status == UserProblem.CORRECT) {
                    completedCount++
                }
            } else if (it.content) {
                def contentUserInstance = ContentUser.findByUserAndContent(user, it.content)
                if (contentUserInstance && contentUserInstance.status == ContentUser.COMPLETED) {
                    completedCount++
                }
            }
        }

        return (100 * completedCount) / teachingResources.size()

    }

}
