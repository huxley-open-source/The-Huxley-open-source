package com.thehuxley

class Topic implements Serializable{
	//um tema tem muitos problemas
	static hasMany = [problems : Problem, contents: Content]
    static belongsTo = [Content]
	//cada tema tem um nome unico
	String name

    static constraints = {
		name(blank : false, unique : true)
	}
	
	public int countSubmission(){
		String query = "Select count(*) from Submission s, Topic t, Topic.Problems tp "+
		"where s.problem.id = tp.problem.id " +
		"and t.id= tp.topic.id " +
		"and t.name = '${this.name}'"
		List list = ShiroUser.executeQuery(query)
		int count = list.get(0)
		return count
	}
}

