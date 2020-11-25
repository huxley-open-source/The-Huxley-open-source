package com.thehuxley

import java.io.Serializable;

class QuestionnaireProblem implements Serializable{
	double score
	Questionnaire questionnaire 
	Problem problem
	
	static QuestionnaireProblem link(problem, questionnaire) {
		def qp = QuestionnaireProblem.findByProblemAndQuestionnaire(problem, questionnaire)
		if (!qp) {
			qp = new QuestionnaireProblem()
			problem?.addToQuestionnaireProblem(qp)
			questionnaire?.addToQuestionnaireProblem(qp)

		}
		
		return qp
	}
	
	static void unlink(problem, questionnaire) {
		def qp = QuestionnaireProblem.findByProblemAndQuestionnaire(problem, questionnaire)
		
		if (qp) {
			problem?.removeFromQuestionnaireProblem(qp)
			questionnaire?.removeFromQuestionnaireProblem(qp)
			qp.delete()
		}
	}
	String toString(){
		return problem.name
	}
}
