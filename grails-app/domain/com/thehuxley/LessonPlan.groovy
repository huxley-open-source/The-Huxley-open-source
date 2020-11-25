package com.thehuxley

class LessonPlan {

    String title
    String description
    Date dateCreated
    Date lastUpdated
    ShiroUser owner

    static hasMany = [lesson: LessonPlanLessons]

    SortedSet lesson


    static mapping = {
        description type: 'text'
    }

    static constraints = {

    }

}
