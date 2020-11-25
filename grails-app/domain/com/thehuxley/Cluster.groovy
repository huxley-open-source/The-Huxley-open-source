package com.thehuxley

import java.io.Serializable;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;

class Cluster implements Serializable{
	String name
	Institution institution
	String hash
    String description
    Date dateCreated
    Date lastUpdated
    Date startDate
    Date endDate
    String url
    String accessKey

	static final String BLACK_LIST = "BlackList"

	static hasMany = [users : ShiroUser, groups:Cluster]
	static mapping = {
        institution lazy: false
    }
    static constraints = {
		name nullable: false, blank: false
        description nullable: true, blank: true
		hash nullable: true, unique: true
        url nullable:true, unique: true
        accessKey nullable:true
        startDate nullable:true
        endDate nullable:true
	}



	int countSubmissions(){
		int submissions = 0

		this.users.each {

			submissions += it.countSubmissions()
		}
		return  submissions
	}
	
	int countCorrectSubmissions(){
		int correctSubmissions = 0

		this.users.each {
			correctSubmissions += it.countCorrectSubmissions()
		}
		return  correctSubmissions
	}
	
	String toString(){
		return name
	}

	public static def listByInstitution(long institutionId){
		Institution anInstitution = Institution.get(institutionId)
		return Cluster.findAllByInstitution(anInstitution)
	}
	
	public boolean containsUser(long id){
		boolean contains = false
		this.users.each{
			if(it.id == id){
				contains = true
			}
		}
		return contains
	}
	public ArrayList<Integer> topCoderList(){
		if(ClusterPermissions.findAllByGroupAndPermission(this,0).size>0){
			def blackList = Cluster.findByName(BLACK_LIST).users.id
			def idList = ClusterPermissions.findAllByGroupAndPermission(this,0).user.id
			ArrayList<ShiroUser> topCoderList = ShiroUser.findAllByIdInList(idList,[sort:"topCoderPosition",order:"asc"])
			ArrayList<Integer> users = new ArrayList<Integer>()
			def studentUsers = topCoderList
			ArrayList<Integer> usersTemp = new ArrayList<Integer>()
			studentUsers.each{
				if(it.topCoderPosition ==0){
					usersTemp.add(it.id)
				}else{
					if(!blackList.contains(it.id)){

						users.add(it.id)
					}
				}
			}
			usersTemp.each{ users.add(it) }
			usersTemp = null


			return users
		}else{


			return new ArrayList<ShiroUser>()
		}
	}
	public long getUserPosition(long userId){
		if(ShiroUser.get(userId).topCoderPosition==0){
			return 0
		}else{
			return topCoderList().indexOf(userId) + 1
		}
	}
//	public byte[] mountTopicRadarChart(int width, int height){
//		Map<String, Double> result = mountDataForChart();
//
//		// Pronto, monta o gráfico com cada tópico e o respectivo percentual de acerto.
//		SpiderWebChart chart = new SpiderWebChart("Desempenho por tópico");
//
//		chart.createDataset(result,name);
//		chart.generateChart();
//
//		KeypointPNGEncoderAdapter encoder = new KeypointPNGEncoderAdapter();
//		encoder.setEncodingAlpha(true);
//
//		return encoder.encode(chart.getImage(width,height));
//	}
	public Map<String, Double> mountDataForChart(){
		// Quantidade total de cada tópico associado aos questionários ao grupo de usuários

		String allTopicsQuery = "SELECT t.name, count(t.id) from Topic t " +
				"join t.problems tp "+
				"where tp.id in " +
				"(SELECT qp.problem.id from Questionnaire q left join q.groups g, QuestionnaireProblem qp " +
				"where g.id = ? and q.id = qp.questionnaire.id) "+
				"group by t.id"

		// Quantidade de tópicos respondidos corretamente associado aos questionários ao grupo de usuários
		String correctTopicQuery = "SELECT t.name, count(t.id) from Topic t " +
				"join t.problems tp "+
				"where tp.id in " +
				"(SELECT qp.problem.id from Questionnaire q left join q.groups g, QuestionnaireProblem qp " +
				"where g.id = ? and q.id = qp.questionnaire.id and qp.problem.id in " +
				" (SELECT s.problem.id from Submission s where s.user.id in (SELECT g.user.id from ClusterPermissions g where g.group.id = ? and g.permission = 0) " +
                "and s.evaluation = ?)) "+
				"group by t.id"


		List totalOfTopics = ShiroUser.executeQuery(allTopicsQuery,[this.id]);
		List correctTopics = ShiroUser.executeQuery(correctTopicQuery, [this.id,id, EvaluationStatus.CORRECT]);

		HashMap<String, Double> result = new HashMap<String, Double>();

		/* Monta um map com os tópicos corretos. O valor da hash será,
		 * temporariamente, a quantidade de tópicos corretos encontrada.
		 */

		for (List element : correctTopics) {
			String topicName = element[0];
			Long topicCount = element[1];

			result.put(topicName,topicCount);
		}

		/*
		 * Agora, percorre a lista de todos os tópicos para fazer o percentual
		 * de acerto.
		 */
		for (List element : totalOfTopics) {
			String topicName = element[0];
			Long topicCount = element[1];

			Double value = result.get (topicName);
			if (value==null){
				result.put (topicName, 0);
			}else{
				result.put (topicName, (value/topicCount.toDouble())*100 );
			}
		}
		return result;
	}
}
