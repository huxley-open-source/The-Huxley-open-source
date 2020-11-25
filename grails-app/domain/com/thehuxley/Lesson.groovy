package com.thehuxley

class Lesson {

    String title
    String description
    Date dateCreated
    Date lastUpdated
    ShiroUser  owner

    public static final String GOOGLE_LESSON = "LESSON"
    public static final String GOOGLE_TOTAL = "TOTAL"

    static hasMany = [teachingResources:TeachingResources, lessonPlans: LessonPlanLessons, topics: Topic]
    SortedSet teachingResources

    static mappedBy = [teachingResources: "lesson"]

    static belongsTo = [LessonPlan]

    static mapping = {
        description type: 'text'

    }


    static constraints = {
        title nullable: false
    }

    public static Map<String, Object> google(Map params){
        Hashtable<String, Object> values = new Hashtable<String, Object>()
        String query = " from Lesson l left join l.topics t left join l.owner o where l.title like '%"+params.get("ss")+"%' or t.name like '%"+params.get("ss")+"%' or l.description like '%"+params.get("ss")+"%' or o.name like '%"+params.get("ss")+"%'"
        ArrayList<Lesson> lessonList = Lesson.executeQuery("Select distinct l" + query,[max:20,offset:params.get("offset")])
        int totalLesson =Lesson.executeQuery("Select count(distinct l.id)" + query)[0]
        values.put(GOOGLE_LESSON,lessonList)
        values.put(GOOGLE_TOTAL,totalLesson)
        return values

    }
}
