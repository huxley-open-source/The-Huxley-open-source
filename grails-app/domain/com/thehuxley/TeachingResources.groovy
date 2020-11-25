package com.thehuxley

class TeachingResources implements Comparable {

    Content content
    Problem problem
    int orderInList
    Lesson lesson

    static constraints = {
        content nullable:true
        problem nullable: true
    }

    static mapping = {
        sort orderInList : 'desc'
    }

    public int compareTo(def other) {
        return orderInList <=> other?.orderInList
    }
}
