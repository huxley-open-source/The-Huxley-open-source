package com.thehuxley

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Map;
import java.util.Date;

class QuestionnaireShiroUser implements Serializable{
    public static final int SYSTEM_CORRECTED = 1;
    public static final int MASTER_CORRECTED = 2;
    public static final int PLAGIUM_STATUS_TEACHER_PLAGIUM = 1;


	ShiroUser user
	Questionnaire questionnaire
	double score
    int status = SYSTEM_CORRECTED
    String comment
    int plagiumStatus = 0;



    static constraints = {
		status(nullable:true,blank:true)
        comment(nullable:true,blank:true)
    }
    static mapping = {
		comment type:"text"
	}

	def calculateScore() {		
		score = 0
        String query = "Select sum(qp2.score) from QuestionnaireProblem qp2 where qp2.id in (SELECT qp.id FROM Submission s, Questionnaire q left join q.questionnaireProblem qp "+
                                            "where s.user.id = '${this.user.id}' "+
                                            "and s.problem.id = qp.problem.id "+
                                            "and q.id ='${this.questionnaire.id}' " +
                                            "and s.submissionDate <=q.endDate " +
                                            "and s.evaluation=? group by qp.problem)"


        def scoreResult = QuestionnaireShiroUser.executeQuery(query,[EvaluationStatus.CORRECT])
        if(scoreResult[0]){
            score += scoreResult
        }

	}
	
	static QuestionnaireShiroUser link(user, questionnaire) {
		def qu = QuestionnaireShiroUser.findByQuestionnaireAndUser(questionnaire, user)
		if (!qu) {
			
			qu = new QuestionnaireShiroUser()
			user?.addToQuestionnaireShiroUser(qu)
			questionnaire?.addToQuestionnaireShiroUser(qu)
			qu.score = 0
			qu.save()
		}
		return qu
	}
	
	static void unlink(user, questionnaire) {
		def qu = QuestionnaireShiroUser.findByQuestionnaireAndUser(questionnaire, user)
		
		if (qu) {
			user?.removeFromQuestionnaireShiroUser(qu)
			questionnaire?.removeFromQuestionnaireShiroUser(qu)
			qu.delete()
		}
	}
	def double calculateScoreByProblem(long problemId){
		
		
		
		String query = "SELECT s.evaluation FROM Submission s, Questionnaire q "+
				"where s.user.id ='${this.user.id}' "+
				"and s.problem.id = '${problemId}' "+
				"and q.id ='${this.questionnaire.id}' " +
				"and s.submissionDate <=q.endDate " +
				"and s.evaluation=? " +
				"order by s.submissionDate "+
				"DESC LIMIT 1"
		
		List list = QuestionnaireShiroUser.executeQuery(query,[EvaluationStatus.CORRECT])
		
		if(list.size()>0){			
			
			return QuestionnaireProblem.findByQuestionnaireAndProblem(this.questionnaire,Problem.get(problemId)).score
		}
		return 0
	}
	/**
	 * Essa função recebe um usuário como entrada e retorna todas os questionários referentes a ele até a data atual
	 * @param params [user.id = id do usuario, max: número maximo de retorno da query, offset: offset da query]
	 * @return Lista de questionários para usuário
	 */
	static List<QuestionnaireShiroUser> mountQuestionnaireByUser(Map params){
		if(params.get("max")==null){
			params.put("max","10")
		}
		if(params.get("offset")==null){
			params.put("offset","0")
		}
		List questionnaireList = new ArrayList<QuestionnaireShiroUser>()
		Date actualDate = new GregorianCalendar(TimeZone.getDefault()).getTime()
		String query = "SELECT qu FROM QuestionnaireShiroUser qu, Questionnaire q WHERE qu.id = q.id and q.startDate <  :date and qu.user.id = " + params.get("user.id")
		questionnaireList = QuestionnaireShiroUser.executeQuery(query,[date:actualDate,max:params.get("max"),offset:params.get("offset")])
		return questionnaireList
	}
}

