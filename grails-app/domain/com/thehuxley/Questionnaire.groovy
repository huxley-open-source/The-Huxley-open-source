package com.thehuxley

import java.io.Serializable;
import java.util.List;

class Questionnaire implements Serializable, Comparable {
	public static final String QUESTIONNAIRE_INSTANCE = "QUESTIONNAIREINSTANCE"
	public static final String AVERAGE_NOTE = "AVERAGENOTE"
	public static final String STANDART_DEVIATION = "STANDARTDEVIATION"
	public static final String GREATER_THEN_EQUALS_SEVEN = "GREATERTHENEQUALSSEVEN"
	public static final String LESS_SEVEN = "LESSSEVER"
	public static final String AVERAGE_DIFFICULTY = "AVERAGEDIFFICULT"
	public static final String WEIGHTED_AVERAGE_DIFFICULTY = "WHEIGHTEDAVERAGEDIFFICULTY"
	public static final String TRY_PERCENTAGE = "TRYPERCENTAGE"
	public static final String USERS_IN_GROUP = "USERSINGROUP"

	String title
	String description
	int evaluationDetail
	Date startDate
	Date endDate
	double score

	static hasMany = [ questionnaireProblem : QuestionnaireProblem, questionnaireShiroUser : QuestionnaireShiroUser, groups : Cluster, user : ShiroUser ]
	static belongsTo = ShiroUser
	static mapping = {
        questionnaireProblem cascade: "all,delete-orphan"
        description type: "text"
    }

	static constraints = {
		title               (blank : false)
		evaluationDetail (range : 1..2, blank : false, nullable : false)
		startDate (blank : true)
		endDate(blank : true)
	}

	List user() {
		return questionnaireShiroUser.collect {it.user}
	}

	List problem() {
		return questionnaireProblem.collect {it.problem}
	}

	def addToQuestionnaireProblem(Problem problem) {
		QuestionnaireProblem.link(problem,this)
	}

	def addToQuestionnaireShiroUser(ShiroUser user) {
		QuestionnaireShiroUser.link(user,this)
	}

	def removeFromProblem(Problem problem) {
		QuestionnaireProblem.unlink(problem,this)
	}

	def beforeDelete() {
		user().each { QuestionnaireShiroUser.unlink it, this }

		problem().each {  QuestionnaireProblem.unlink it, this }
	}

	public List getQuestionnairePlagium(){
		String query =
				"SELECT u.name, p.source.id, s.id, p2.name, q.title, p.id FROM Plagium p , Submission s, Problem p2, ShiroUser u, Questionnaire q, QuestionnaireProblem qp "+
				"where p.submission.id = s.id " +
				"and s.problem.id = p2.id "+
				"and p2.id = qp.problem.id "+
				"and qp.questionnaire.id = q.id " +
				"and u.id = s.user.id "+
				"and p.percentage >= 90 "+
				"and s.submissionDate < q.endDate " +
				"and q.id = '${this.id}'"


		List list = Plagium.executeQuery(query)
		return list
	}
	public static void updateUserQuestionnaireList(ClusterPermissions clusterPermissionsInstance){
		if(clusterPermissionsInstance.permission ==0){
			String query = "Select q from Questionnaire q left join q.groups g where g.id = "+clusterPermissionsInstance.group.id+" and q.id not in (Select q2.id from Questionnaire q2 left join q2.questionnaireShiroUser qu where qu.user.id = "+clusterPermissionsInstance.user.id+")"
			ArrayList<Questionnaire> questionnaireList = Questionnaire.executeQuery(query)
			questionnaireList.each{
					QuestionnaireShiroUser questionnaireShiroUser = new QuestionnaireShiroUser(user:clusterPermissionsInstance.user ,questionnaire:it ,score:0).save()
					questionnaireShiroUser.calculateScore()
			}
		}
	}
	/**
	 * Essa função gera as estatisticas de um dado questionário
	 * @param questionnaireId
	 * @return Hashtable<String,Object>
	 */
	public Hashtable<String,Object> generateStatistics(long questionnaireId){
		Questionnaire questionnaireInstance = Questionnaire.get(questionnaireId)
		ArrayList<Double> averageNote = new ArrayList<Double>()
		ArrayList<Double> standartDeviaton = new ArrayList<Double>()
		ArrayList<Integer> lessSeven = new ArrayList<Integer>()
		ArrayList<Integer> greaterThenEqualsSeven = new ArrayList<Integer>()
		ArrayList<Integer> tryPercentage = new ArrayList<Integer>()
		ArrayList<Integer> usersInGroup = new ArrayList<Integer>()
		ArrayList<QuestionnaireShiroUser> questionnairesTryed = new ArrayList<QuestionnaireShiroUser>()
		def userList
		def questionnaireProblemList =questionnaireInstance.questionnaireProblem
		ArrayList<Problem> problemList = new ArrayList<Problem>()
		double averageDifficulty = 0
		double weightedAverageDifficulty = 0
		double weight = 0
		double totalWeight = questionnaireInstance.score
		double difficulty =0
		questionnaireProblemList.each{
			Problem problem = Problem.get(it.problem.id)
			problemList.add(problem)
			difficulty = problem.nd
			averageDifficulty += difficulty
			weight = it.score
			weightedAverageDifficulty += difficulty * (weight/totalWeight)
		}

		averageDifficulty = averageDifficulty/ problemList.size()
		questionnaireInstance.groups.each{
			int userTryed = 0

			userList = it.users
			userList = QuestionnaireShiroUser.findAllByUserInListAndQuestionnaire(userList,questionnaireInstance)
			double scoreTotal = 0
			double variance = 0
			int localLessSeven=0
			int localGreaterThenEqualsSeven=0
			double note = 0

			userList.each{ user->
				boolean tryed = false
				note = user.score
				scoreTotal += note
				problemList.each{

					if(Submission.findAll("from Submission as s where s.user = '${user.user.id}' and s.problem = '${it.id}' and s.submissionDate <= '${questionnaireInstance.endDate}'").size()>0){
						tryed = true
					}
				}

				if(tryed){
					userTryed ++
					tryed = false
					questionnairesTryed.add(user)

					if(note<7){

						localLessSeven ++
					}else{
						localGreaterThenEqualsSeven ++
					}
				}
			}


			double localAverageNote	= scoreTotal/userTryed

			questionnairesTryed.each{

				variance += Math.pow(localAverageNote - it.score,2)
			}
			variance = variance/userTryed
			int users = userList.size()


			if(users!=0){
				usersInGroup.add(users)
				averageNote.add(localAverageNote)
				greaterThenEqualsSeven.add(localGreaterThenEqualsSeven)
				lessSeven.add(localLessSeven)
				tryPercentage.add(userTryed/users)

				standartDeviaton.add(Math.sqrt(variance))
			}else{
				usersInGroup.add(0)
				averageNote.add(0)
				standartDeviaton.add(0)
			}
		}

		Hashtable<String,Object> returnParams = new Hashtable<String,Object>()
		returnParams.put(QUESTIONNAIRE_INSTANCE,questionnaireInstance)
		returnParams.put(AVERAGE_NOTE,averageNote)
		returnParams.put(STANDART_DEVIATION,standartDeviaton)
		returnParams.put(GREATER_THEN_EQUALS_SEVEN,greaterThenEqualsSeven)
		returnParams.put(LESS_SEVEN,lessSeven)
		returnParams.put(AVERAGE_DIFFICULTY,averageDifficulty)
		returnParams.put(WEIGHTED_AVERAGE_DIFFICULTY,weightedAverageDifficulty)
		returnParams.put(TRY_PERCENTAGE,tryPercentage)
		returnParams.put(USERS_IN_GROUP,usersInGroup)
		return returnParams
	}

	/**
	 * Retorna todos os questionários com prazo ainda a vencer de um determinado usuário.
	 * Ordenar a lista da maior (recente) data de término para a menor (antiga)
	 * @param user
	 * @return
	 */
	public static List<Questionnaire> findOpenQuestionnaires(ShiroUser user){
		//TODO: Romero, implementar esse método
	}
	public static List<Questionnaire> findQuestionnairesByMaster(long userId){
		String query = "Select q from Questionnaire q inner join q.groups qp where qp.id in (Select group.id from ClusterPermissions where user.id = "+userId+" and permission > 0 ) order by q.endDate desc"
		return Questionnaire.executeQuery(query)
	}

    @Override
    int compareTo(Object o) {
        return startDate.compareTo(o.startDate)
    }
}
