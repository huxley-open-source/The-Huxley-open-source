package com.thehuxley

import grails.converters.JSON

class CourseController {

    def teachingResourceService
    def courseService

    def index() {

        def lessons = []
        def lessonList = []

        if (params.k) {
            lessonList = Lesson.findAllByTitleLike("%${params.k}%")
        } else {
            lessonList = Lesson.list()
        }

        lessonList.each {

            def teachingResources = it.teachingResources
            def completedCount = 0

            teachingResources.each {
                if (it.problem) {
                    def userProblemInstance = UserProblem.findByUserAndProblem(session.profile.user, it.problem)
                    if (userProblemInstance && userProblemInstance.status == UserProblem.CORRECT) {
                        completedCount++
                    }
                } else if (it.content) {
                    def contentUserInstance = ContentUser.findByUserAndContent(session.profile.user, it.content)
                    if (contentUserInstance && contentUserInstance.status == ContentUser.COMPLETED) {
                        completedCount++
                    }
                }
            }

            lessons.add([lesson: it, percent: g.formatNumber(number: (100 * completedCount) / teachingResources.size(), format: '0')])

        }

        [lessons: lessons, total: Lesson.count(), k: params.k]
    }

    def getCourseList = {
        redirect(action: 'index', params: [k: params.title])
    }

    def ajxGetCourseList = {
        def lessons = []
        def lessonList = []

        if (params.k) {
            lessonList = Lesson.findAllByTitleLike("%${params.k}%")
        } else {
            lessonList = Lesson.list()
        }

        lessonList.each {

            def teachingResources = it.teachingResources
            def completedCount = 0

            teachingResources.each {
                if (it.problem) {
                    def userProblemInstance = UserProblem.findByUserAndProblem(session.profile.user, it.problem)
                    if (userProblemInstance && userProblemInstance.status == UserProblem.CORRECT) {
                        completedCount++
                    }
                } else if (it.content) {
                    def contentUserInstance = ContentUser.findByUserAndContent(session.profile.user, it.content)
                    if (contentUserInstance && contentUserInstance.status == ContentUser.COMPLETED) {
                        completedCount++
                    }
                }
            }

            def profile = Profile.findByUser(it.owner)

            lessons.add([id: it.id, title: it.title, description: it.description, lastUpdatedDate: g.formatDate(date: it.lastUpdated, format: ('dd/MM/yyyy')), lastUpdatedHour: g.formatDate(date: it.lastUpdated, format: ('hh:mm')), ownerHash: profile.hash, ownerName: profile.name, progress: g.formatNumber(number: (100 * completedCount) / teachingResources.size(), format: '0')])

        }

        render(contentType:"text/json") {
            lessons
        }
    }

    def show = {
        def courseInstance = Lesson.get(params.id)

        [courseInstance: courseInstance]
    }

    def changeStatus = {
        teachingResourceService.changeStatusToComplete(params.c, session.profile.user)
        render(contentType:"text/json") {
            [progress: g.formatNumber(number: courseService.getProgress(Lesson.get(params.k), session.profile.user), format: '0')]
        }
    }

}


