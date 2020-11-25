package com.thehuxley

class LessonPlanLessons implements Comparable {

    int position
    Date dateCreated
    Date lastUpdated

    static belongsTo = [lesson: Lesson, lessonPlan: LessonPlan]

    static mapping = {
        version false
    }

    static constraints = {
    }

    public int compareTo(def other) {
        return position <=> other?.position
    }
}
