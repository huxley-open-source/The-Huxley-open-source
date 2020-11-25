package com.thehuxley

class Content {

    String title
    String description
    Date dateCreated
    Date lastUpdated
    ShiroUser owner
    String embedded

    public static final String GOOGLE_CONTENT = "CONTENT"
    public static final String GOOGLE_TOTAL = "TOTAL"

    static hasMany = [topics: Topic]

    static mapping = {
        description type: 'text'
    }

    static constraints = {
        title nullable: false
    }

    public static Map<String, Object> google(Map params){
        Hashtable<String, Object> values = new Hashtable<String, Object>()
        String query = " from Content c left join c.topics t left join c.owner o where c.title like '%"+params.get("ss")+"%' or t.name like '%"+params.get("ss")+"%' or c.description like '%"+params.get("ss")+"%' or o.name like '%"+params.get("ss")+"%'"
        ArrayList<Content> contentList = Content.executeQuery("Select distinct c" + query,[max:20,offset:params.get("offset")])
        int totalContent =Content.executeQuery("Select count(distinct c.id)" + query)[0]
        values.put(GOOGLE_CONTENT,contentList)
        values.put(GOOGLE_TOTAL,totalContent)
        return values

    }
}
