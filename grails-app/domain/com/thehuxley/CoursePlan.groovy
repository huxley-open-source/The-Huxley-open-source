package com.thehuxley

class CoursePlan {

    Date dateCreated
    Date lastUpdated
    String title
    String description
    Profile owner
    static hasMany = [questionnaire: Questionnaire]

    SortedSet questionnaire

    static mapping = {
        description (type:"text")
    }
}
