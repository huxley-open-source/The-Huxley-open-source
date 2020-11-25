package com.thehuxley

import grails.converters.JSON

import java.text.SimpleDateFormat

class QuestService {

    def memcachedService

    def CACHE_TIME = 60; //60 segundos
    SimpleDateFormat formater = new SimpleDateFormat("HH:mm dd/MM/yyyy")

    public Map getUserQuest(userId){
        String query = ""
        String select = "Select Distinct qu"
        String count = "Select count(Distinct qu)"
        query = " from Questionnaire q left join q.questionnaireShiroUser qu left join q.questionnaireProblem qp  where qu.user.id = "+userId+" group by q having count(qp) > 0 order by q.endDate desc"
        ArrayList<QuestionnaireShiroUser> list = QuestionnaireShiroUser.executeQuery(select + query)
        def total = Questionnaire.executeQuery(count + query)[0]
        Map<String, Object> results = new HashMap<String, Object>()
        if (!total){
            total = 0
        }
        results.put("TOTAL",total)
        results.put("LIST",list)
        return  results
    }
    public Map getUserOpenedQuest(userId,limit, offset){
        String query = ""
        String select = "Select Distinct qu"
        String count = "Select count(Distinct qu)"
        String queryTotal = ""
        java.sql.Date actualDate =  new  java.sql.Date(System.currentTimeMillis())
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        String formatedDate = dateFormat.format(actualDate)
        query = " from Questionnaire q left join q.questionnaireShiroUser qu left join q.questionnaireProblem qp  where qu.user.id = "+userId+" and q.endDate > '" + formatedDate + "' group by q having count(qp) > 0 order by q.endDate desc"
        queryTotal = " from Questionnaire q left join q.questionnaireShiroUser qu left join q.questionnaireProblem qp  where qu.user.id = "+userId+" and q.endDate > '" + formatedDate + "' group by qu.user.id having count(qp) > 0 order by q.endDate desc"
        ArrayList<QuestionnaireShiroUser> list = QuestionnaireShiroUser.executeQuery(select + query,[max:limit,offset:offset])
        def total = Questionnaire.executeQuery(count + queryTotal)[0]
        Map<String, Object> results = new HashMap<String, Object>()
        if (!total){
            total = 0
        }
        results.put("TOTAL",total)
        results.put("LIST",list)
        return  results
    }

    def getUserOpenedQuestCached (userId,limit, offset) {
        def result = memcachedService.get("opened-quest-$userId-$limit-$offset",  CACHE_TIME) {

            def openedQuestList = getUserOpenedQuest(userId,limit, offset)
            def questionnaireList = []

            openedQuestList.get("LIST").each {
                questionnaireList.add([id:it.id, title:it.questionnaire.title, userScore: it.score, score:it.questionnaire.score, startDate: formater.format(it.questionnaire.startDate)])
            }

            ([questionnaireList: questionnaireList, count: openedQuestList.get("TOTAL")] as JSON) as String
        }

        result
    }

    public Map getUserClosedQuest(userId,limit, offset){
        String query = ""
        String queryTotal = ""
        String select = "Select Distinct qu"
        String count = "Select count(Distinct qu)"
        java.sql.Date actualDate =  new  java.sql.Date(System.currentTimeMillis())
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        String formatedDate = dateFormat.format(actualDate)
        query = " from Questionnaire q left join q.questionnaireShiroUser qu left join q.questionnaireProblem qp  where qu.user.id = "+userId+" and q.endDate < '" + formatedDate + "' group by q having count(qp) > 0 order by q.endDate desc"
        queryTotal = " from Questionnaire q left join q.questionnaireShiroUser qu left join q.questionnaireProblem qp  where qu.user.id = "+userId+" and q.endDate < '" + formatedDate + "' group by qu.user.id having count(qp) > 0 order by q.endDate desc"
        ArrayList<QuestionnaireShiroUser> list = QuestionnaireShiroUser.executeQuery(select + query,[max:limit,offset:offset])
        def total = Questionnaire.executeQuery(count + queryTotal)[0]
        Map<String, Object> results = new HashMap<String, Object>()
        if (!total){
            total = 0
        }
        results.put("TOTAL",total)
        results.put("LIST",list)
        return  results
    }

    def getUserClosedQuestCached (userId,limit, offset) {
        def result = memcachedService.get("closed-quest-user-$userId-$limit-$offset",  CACHE_TIME) {

            def closedQuestList = getUserClosedQuest(userId,limit, offset)
            def questionnaireList = []

            closedQuestList.get("LIST").each {
                questionnaireList.add([id:it.id, title:it.questionnaire.title, userScore: it.score, score:it.questionnaire.score])
            }

            ([questionnaireList: questionnaireList, count: closedQuestList.get("TOTAL")] as JSON) as String
        }

        result
    }

    public Map getAdminOpenedQuest(title,limit, offset, groupId){
        String query = ""
        String select = "Select Distinct q "
        String count = "Select count(Distinct q)"
        java.sql.Date actualDate =  new  java.sql.Date(System.currentTimeMillis())
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        String formatedDate = dateFormat.format(actualDate)
        if(groupId == 0){
            query = " from Questionnaire q where q.title like '%" +title+ "%' and q.endDate > '" + formatedDate + "' order by q.endDate desc"
        }else{
            query = " from Questionnaire q inner join q.groups g where q.title like '%" +title+ "%' and g.id = " + groupId + " and q.endDate > '" + formatedDate + "' order by q.endDate desc"
        }
        ArrayList<Questionnaire> list = Questionnaire.executeQuery(select + query,[max:limit,offset:offset])
        def total = Questionnaire.executeQuery(count + query)[0]
        Map<String, Object> results = new HashMap<String, Object>()
        results.put("TOTAL",total)
        results.put("LIST",list)
        return  results
    }

    def getAdminOpenedQuestCached (title,limit, offset, groupId) {
        def result = memcachedService.get("opened-quest-admin-$title-$limit-$offset-$groupId",  CACHE_TIME) {


            def openedQuestList = getAdminOpenedQuest(title,limit, offset, groupId)
            def questionnaireList = []

            openedQuestList.get("LIST").each {
                questionnaireList.add([id:it.id, title:it.title, score:it.score, startDate: formater.format(it.startDate), invalid:(it.questionnaireProblem.size() > 0 ? false : true)])
            }

            ([questionnaireList: questionnaireList, count: openedQuestList.get("TOTAL")] as JSON) as String
        }

        result
    }



    public Map getAdminClosedQuest(title,limit, offset, groupId){
        String query = ""
        String select = "Select Distinct q"
        String count = "Select count(Distinct q)"
        java.sql.Date actualDate =  new  java.sql.Date(System.currentTimeMillis())
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        String formatedDate = dateFormat.format(actualDate)
        if(groupId == 0){
            query = " from Questionnaire q where q.title like '%" +title+ "%' and q.endDate < '" + formatedDate + "' order by q.endDate desc"
        }else{
            query = " from Questionnaire q inner join q.groups g where q.title like '%" +title+ "%' and g.id = " + groupId + " and q.endDate < '" + formatedDate + "' order by q.endDate desc"
        }
        ArrayList<Questionnaire> list = Questionnaire.executeQuery(select + query,[max:limit,offset:offset])
        def total = Questionnaire.executeQuery(count + query)[0]
        Map<String, Object> results = new HashMap<String, Object>()
        results.put("TOTAL",total)
        results.put("LIST",list)
        return  results
    }

    def getAdminClosedQuestCached (title, limit, offset, groupId) {
        def result = memcachedService.get("closed-quest-admin-$title-$limit-$offset-$groupId",  CACHE_TIME) {

            def closedQuestList = getAdminClosedQuest(title, limit, offset, groupId)
            def questionnaireList = []

            closedQuestList.get("LIST").each {
                questionnaireList.add([id:it.id, title:it.title,score:it.score,invalid:(it.questionnaireProblem.size()>0?false:true)])
            }

            ([questionnaireList: questionnaireList, count: closedQuestList.get("TOTAL")] as JSON) as String
        }

        result
    }

    public Map getTeacherOpenedQuest(title,userId,limit, offset, groupId){
        String query = ""
        String select = "Select Distinct q "
        String count = "Select count(Distinct q)"
        java.sql.Date actualDate =  new  java.sql.Date(System.currentTimeMillis())
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        String formatedDate = dateFormat.format(actualDate)
        if(groupId == 0){
            query = " from Questionnaire q inner join q.groups g where q.title like '%" +title+ "%' and g.id in (Select Distinct c.group.id from ClusterPermissions c where c.user.id = " + userId + " and permission > 0) and q.endDate > '" + formatedDate + "' order by q.endDate desc"
        }else{
            query = " from Questionnaire q inner join q.groups g where q.title like '%" +title+ "%' and g.id = " + groupId + " and q.endDate > '" + formatedDate + "' order by q.endDate desc"
        }
        ArrayList<Questionnaire> list = Questionnaire.executeQuery(select + query,[max:limit,offset:offset])
        def total = Questionnaire.executeQuery(count + query)[0]
        Map<String, Object> results = new HashMap<String, Object>()
        results.put("TOTAL",total)
        results.put("LIST",list)
        return  results
    }

    def getTeacherOpenedQuestCached (title, userId, limit, offset, groupId) {
        def result = memcachedService.get("opened-quest-teacher-$title-$userId-$limit-$offset-$groupId",  CACHE_TIME) {


            def openedQuestList = getTeacherOpenedQuest(title, userId, limit, offset, groupId)
            def questionnaireList = []

            openedQuestList.get("LIST").each {
                questionnaireList.add([id:it.id, title:it.title,score:it.score, startDate: formater.format(it.startDate),invalid:(it.questionnaireProblem.size()>0?false:true)])
            }

            ([questionnaireList: questionnaireList, count: openedQuestList.get("TOTAL")] as JSON) as String
        }

        result
    }

    public Map getTeacherClosedQuest(title,userId,limit, offset, groupId){
        String query = ""
        String select = "Select Distinct q"
        String count = "Select count(Distinct q)"
        java.sql.Date actualDate =  new  java.sql.Date(System.currentTimeMillis())
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        String formatedDate = dateFormat.format(actualDate)
        if(groupId == 0){
            query = " from Questionnaire q inner join q.groups g where q.title like '%" +title+ "%' and g.id in (Select Distinct c.group.id from ClusterPermissions c where c.user.id = " + userId + " and permission > 0) and q.endDate < '" + formatedDate + "' order by q.endDate desc"
        }else{
            query = " from Questionnaire q inner join q.groups g where q.title like '%" +title+ "%' and g.id = " + groupId + " and q.endDate < '" + formatedDate + "' order by q.endDate desc"
        }
        ArrayList<Questionnaire> list = Questionnaire.executeQuery(select + query,[max:limit,offset:offset])
        def total = Questionnaire.executeQuery(count + query)[0]
        Map<String, Object> results = new HashMap<String, Object>()
        results.put("TOTAL",total)
        results.put("LIST",list)
        return  results
    }

    def getTeacherClosedQuestCached (title, userId, limit, offset, groupId) {
        def result = memcachedService.get("closed-quest-teacher-$title-$userId-$limit-$offset-$groupId",  CACHE_TIME) {

            def closedQuestList = getTeacherClosedQuest(title, userId, limit, offset, groupId)
            def questionnaireList = []

            closedQuestList.get("LIST").each {
                questionnaireList.add([id:it.id, title:it.title,score:it.score,invalid:(it.questionnaireProblem.size()>0?false:true)])
            }

            ([questionnaireList: questionnaireList, count: closedQuestList.get("TOTAL")] as JSON) as String
        }

        result
    }

    public Map getAdminInstOpenedQuest(title,instId,limit, offset, groupId){
        String query = ""
        String select = "Select Distinct q "
        String count = "Select count(Distinct q)"
        java.sql.Date actualDate =  new  java.sql.Date(System.currentTimeMillis())
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        String formatedDate = dateFormat.format(actualDate)
        if(groupId == 0){
            query = " from Questionnaire q inner join q.groups g where q.title like '%" +title+ "%' and g.id in (Select Distinct c.id from Cluster c where c.institution.id = " + instId + ") and q.endDate > '" + formatedDate + "' order by q.endDate desc"
        }else{
            query = " from Questionnaire q inner join q.groups g where q.title like '%" +title+ "%' and g.id = " + groupId + " and q.endDate > '" + formatedDate + "' order by q.endDate desc"
        }
        ArrayList<Questionnaire> list = Questionnaire.executeQuery(select + query,[max:limit,offset:offset])
        def total = Questionnaire.executeQuery(count + query)[0]
        Map<String, Object> results = new HashMap<String, Object>()
        results.put("TOTAL",total)
        results.put("LIST",list)
        return  results
    }

    def getAdminInstOpenedQuestCached (title, instId, limit, offset, groupId) {
        def result = memcachedService.get("opened-quest-admin-inst-$title-$instId-$limit-$offset-$groupId",  CACHE_TIME) {


            def openedQuestList = getAdminInstOpenedQuest(title, instId, limit, offset, groupId)
            def questionnaireList = []

            openedQuestList.get("LIST").each {
                questionnaireList.add([id:it.id, title:it.title,score:it.score, startDate: formater.format(it.startDate),invalid:(it.questionnaireProblem.size()>0?false:true)])
            }

            ([questionnaireList: questionnaireList, count: openedQuestList.get("TOTAL")] as JSON) as String
        }

        result
    }

    public Map getAdminInstClosedQuest(title,instId,limit, offset,groupId){
        String query = ""
        String select = "Select Distinct q"
        String count = "Select count(Distinct q)"
        java.sql.Date actualDate =  new  java.sql.Date(System.currentTimeMillis())
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        String formatedDate = dateFormat.format(actualDate)
        if(groupId == 0){
            query = " from Questionnaire q inner join q.groups g where q.title like '%" +title+ "%' and g.id in (Select Distinct c.id from Cluster c where c.institution.id = " + instId + ") and q.endDate < '" + formatedDate + "' order by q.endDate desc"
        }else{
            query = " from Questionnaire q inner join q.groups g where q.title like '%" +title+ "%' and g.id = " + groupId + " and q.endDate < '" + formatedDate + "' order by q.endDate desc"
        }
        ArrayList<Questionnaire> list = Questionnaire.executeQuery(select + query,[max:limit,offset:offset])
        def total = Questionnaire.executeQuery(count + query)[0]
        Map<String, Object> results = new HashMap<String, Object>()
        results.put("TOTAL",total)
        results.put("LIST",list)
        return  results
    }

    def getAdminInstClosedQuestCached (title, instId, limit, offset,groupId) {
        def result = memcachedService.get("closed-quest-admin-inst-$title-$instId-$limit-$offset-$groupId",  CACHE_TIME) {

            def closedQuestList = getAdminInstClosedQuest(title, instId, limit, offset,groupId)
            def questionnaireList = []

            closedQuestList.get("LIST").each {
                questionnaireList.add([id:it.id, title:it.title,score:it.score,invalid:(it.questionnaireProblem.size()>0?false:true)])
            }

            ([questionnaireList: questionnaireList, count: closedQuestList.get("TOTAL")] as JSON) as String
        }

        result
    }


    public getLastestQuestionnaires (profile, license, max) {

        def questList = []

        if(license.isStudent()){
            questList.addAll(getUserOpenedQuest(profile.user.id,max,0).get("LIST"))
            questList.addAll(getUserClosedQuest(profile.user.id,max,0).get("LIST"))
        } else if(license.isAdmin()){
            questList.addAll(getAdminOpenedQuest('',max,0,0).get("LIST"))
            questList.addAll(getAdminClosedQuest('',max,0,0).get("LIST"))
        } else if(license.isAdminInst()){
            questList.addAll(getAdminInstOpenedQuest('',license.institution.id,max,0,0).get("LIST"))
            questList.addAll(getAdminInstClosedQuest('',license.institution.id,max,0,0).get("LIST"))
        } else if(license.isTeacher()){
            questList.addAll(getTeacherOpenedQuest('',profile.user.id,max,0,0).get("LIST"))
            questList.addAll(getTeacherClosedQuest('',profile.user.id,max,0,0).get("LIST"))

        }

       return questList;
    }


}
