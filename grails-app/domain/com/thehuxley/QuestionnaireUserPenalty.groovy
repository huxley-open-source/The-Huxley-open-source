package com.thehuxley

class QuestionnaireUserPenalty {

    QuestionnaireShiroUser questionnaireUser
    QuestionnaireProblem questionnaireProblem
    double penalty
    Date dateCreated
    Date lastUpdated

    static constraints = {
        questionnaireProblem(nullabe:false, blank:false)
        questionnaireUser(nullabe:false, blank:false)
        penalty(nullabe:false, blank:false)
    }
}
