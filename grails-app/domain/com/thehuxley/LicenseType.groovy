package com.thehuxley

class LicenseType {

    public static final String ADMIN = "ADMIN"
    public static final String SYSTEM = "SYSTEM"
    public static final String ADMIN_INST = "ADMIN_INST"
    public static final String TEACHER = "TEACHER"
    public static final String TEACHER_ASSISTANT = "TEACHER_ASSISTANT"
    public static final String STUDENT = "STUDENT"

    String name
    String description
    String descriptor
    String kind
    Date dateCreated
    Date lastUpdated

    static hasMany = [licenses: License]
    static mappedBy = [licenses: 'type']

    static constraints = {
        kind inList:  [ADMIN, SYSTEM, ADMIN_INST, TEACHER, TEACHER_ASSISTANT, STUDENT]
    }
}
