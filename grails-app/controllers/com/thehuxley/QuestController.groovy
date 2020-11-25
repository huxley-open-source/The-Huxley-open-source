package com.thehuxley

import jxl.Workbook
import jxl.write.Label
import jxl.write.WritableSheet
import jxl.write.WritableWorkbook

import java.text.SimpleDateFormat
import com.thehuxley.util.UtilFacade
import groovy.time.TimeDuration
import groovy.time.TimeCategory
import grails.converters.JSON

class QuestController {
    def questService
    def mongoService
    def index = {
		[groups:ClusterPermissions.findAllByUserAndPermission(session.license.user,30)]
    }

    def getClosedUserQuest = {
        def result

        if(session.license.isStudent()){
            result = questService.getUserClosedQuestCached(session.profile.user.id,params.limit,params.offset)
        }else if (session.license.isAdmin()){
            result = questService.getAdminClosedQuestCached(params.title,params.limit,params.offset,Integer.parseInt(params.groupId))
        }else if (session.license.isTeacher()){
            result = questService.getTeacherClosedQuestCached(params.title,session.profile.user.id,params.limit,params.offset,Integer.parseInt(params.groupId))
        }else if (session.license.isAdminInst()){
            result = questService.getAdminInstClosedQuestCached(params.title,session.license.institution.id,params.limit,params.offset,Integer.parseInt(params.groupId))
        }

        render(contentType:"text/json") {
            JSON.parse(result)
        }
    }

    def getOpenUserQuest = {
        def result

        SimpleDateFormat formater = new SimpleDateFormat("HH:mm dd/MM/yyyy")
        if(session.license.isStudent()){
            result = questService.getUserOpenedQuestCached(session.profile.user.id, params.limit, params.offset)
        }else if (session.license.isAdmin()){
            result = questService.getAdminOpenedQuestCached(params.title, params.limit, params.offset, Integer.parseInt(params.groupId))
        }else if (session.license.isTeacher()){
            result = questService.getTeacherOpenedQuestCached(params.title, session.profile.user.id, params.limit,params.offset, Integer.parseInt(params.groupId))
        }else if (session.license.isAdminInst()){
            result = questService.getAdminInstOpenedQuestCached(params.title, session.license.institution.id, params.limit,params.offset, Integer.parseInt(params.groupId))
        }

        render(contentType:"text/json") {
            JSON.parse(result)
        }

    }

    def listByGroup = {
        render(contentType:"text/json") {
            questionnaires = array {
                Questionnaire.executeQuery("Select q from Questionnaire q inner join q.groups g where g.id = :groupId order by q.startDate", [groupId: Long.parseLong(params.id)]).each {
                    questionnaire name:it.title, score:it.score, questId:it.id
                }
            }
        }
    }

    def show = {

        def questionnaireInstance
        def questUser
        SimpleDateFormat formater = new SimpleDateFormat("HH:mm dd/MM/yyyy")

        if (params.qId) {
           questUser = QuestionnaireShiroUser.get(params.qId)
            if (questUser) {
                questionnaireInstance = questUser.questionnaire
                if (session.license.isStudent() && session.license.user.id != questUser.user.id) {
                    response.sendError(404)
                }
            }
        } else {
            questionnaireInstance = Questionnaire.get(params.id)
            if(questionnaireInstance){
                questUser = QuestionnaireShiroUser.findByUserAndQuestionnaire(session.profile.user, questionnaireInstance)
            } else {
                response.sendError(404)
            }

        }
        if(questionnaireInstance && questUser){
            def averageDifficulty = 0.0
            def weightedAverageDifficulty = 0.0
            def yourScore = questUser.score
            def count = 0
            def questionnaireProblems = questionnaireInstance.questionnaireProblem
            def totalWeight = questionnaireInstance.score
            def endDate = System.currentTimeMillis() > questionnaireInstance.endDate.getTime() ? g.message(code: "verbosity.questionnaireEnded") : formater.format(questionnaireInstance.endDate)
            yourScore = questUser.score
            if (System.currentTimeMillis() > questionnaireInstance.startDate.getTime()) {
                ArrayList<QuestionnaireProblem> questionnaireProblem = questionnaireInstance.questionnaireProblem.sort{it.problem.name}
                Profile profile = Profile.findByUser(questUser.user)
                HashMap<Long, Object> resultMap = new HashMap<Long, Object>()
                questionnaireInstance.questionnaireProblem.each { questProblem ->
                    boolean correct = false, tried = false, commented = false, suspect = false
                    def penalty, score = 0
                    def submissionList = Submission.executeQuery("Select s from Submission s where s.user.id = :userId and s.submissionDate < :endDate and s.problem.id = :problemId",[userId: questUser.user.id, endDate: questionnaireInstance.endDate, problemId: questProblem.problem.id])
                    submissionList.each { submission ->
                        tried = true
                        if(submission.comment && !submission.comment.isEmpty()) {
                            commented = true
                        }
                        if(submission.isCorrect()) {
                            correct = true
                        }
                    }
                    penalty = QuestionnaireUserPenalty.findByQuestionnaireUserAndQuestionnaireProblem(questUser,questProblem)
                    if (correct) {
                        score = questProblem.score
                    }
                    if(penalty){
                        score = score - penalty.penalty
                    }
                    resultMap.put(questProblem.id,[correct: correct, tried: tried, commented:commented, score: score, checked: commented||penalty])
                }
                [profile: profile, questUser: questUser, quest: questionnaireInstance, questionnaireProblem: questionnaireProblem, resultMap: resultMap]
            } else {
                redirect action: 'notStarted'
            }
        } else {
            response.sendError(404)
        }

    }

    def showQuestUser = {
        QuestionnaireShiroUser questUser = QuestionnaireShiroUser.get(params.id)
        Questionnaire quest = questUser.questionnaire
        ArrayList<QuestionnaireProblem> questionnaireProblem = quest.questionnaireProblem.sort{it.problem.name}
        Profile profile = Profile.findByUser(questUser.user)
        HashMap<Long, Object> resultMap = new HashMap<Long, Object>()
        quest.questionnaireProblem.each { questProblem ->
            boolean correct = false, tried = false, commented = false, suspect = false, suspectConfirmed = false;
            def penalty, score = 0
            def submissionList = Submission.executeQuery("Select s from Submission s where s.user.id = :userId and s.submissionDate < :endDate and s.problem.id = :problemId",[userId: questUser.user.id, endDate: quest.endDate, problemId: questProblem.problem.id])
            submissionList.each { submission ->
                tried = true
                if (submission.comment && !submission.comment.isEmpty()) {
                    commented = true
                }
                if (submission.isCorrect()) {
                    correct = true
                    if (submission.plagiumStatus.equals(Submission.PLAGIUM_STATUS_MATCHED)) {
                        suspect = true
                    }
                    if (submission.plagiumStatus.equals(Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM)) {
                        suspectConfirmed = true
                        suspect = true
                    }
                }

            }
            penalty = QuestionnaireUserPenalty.findByQuestionnaireUserAndQuestionnaireProblem(questUser,questProblem)
            if (correct) {
                score = questProblem.score
            }
            if(penalty){
                score = score - penalty.penalty
            }
            resultMap.put(questProblem.id,[correct: correct, tried: tried, commented:commented, suspect: suspect, score: score, checked: commented||penalty, suspectConfirmed: suspectConfirmed])
        }
        [profile: profile, questUser: questUser, quest: quest, questionnaireProblem: questionnaireProblem, resultMap: resultMap]
    }


    def notStarted = {

    }

    def showStatistics = {
        SimpleDateFormat formater = new SimpleDateFormat("dd/MM/yyyy HH:mm")
        def questionnaireInstance = Questionnaire.get(params.id)
        if(questionnaireInstance){

        def statistics = QuestionnaireStatistics.findAllByQuestionnaire(questionnaireInstance)
        def averageDifficulty = 0.0
        def weightedAverageDifficulty = 0.0
        def count = 0
        def questionnaireProblems = questionnaireInstance.questionnaireProblem
        def totalWeight = questionnaireInstance.score
        def startDate = formater.format(questionnaireInstance.startDate)
        def endDate = System.currentTimeMillis() > questionnaireInstance.endDate.getTime() ? formater.format(questionnaireInstance.endDate) + ' (' + g.message(code: "verbosity.questionnaireEnded") + ')' : formater.format(questionnaireInstance.endDate)
        if (questionnaireProblems.size() > 0){
            questionnaireProblems.each{
                def difficulty = it.problem.nd
                averageDifficulty += difficulty
                def weight = it.score
                if (totalWeight != 0) {
                    weightedAverageDifficulty += difficulty * (weight / totalWeight)
                } else {
                    weightedAverageDifficulty = 0
                }
                count++
            }
            averageDifficulty = averageDifficulty / count
            [questionnaireProblems: questionnaireProblems, questionnaireInstance: questionnaireInstance, averageDifficulty: averageDifficulty, weightedAverageDifficulty: weightedAverageDifficulty, statistics:statistics, endDate: endDate, startDate: startDate]
        }else{
            [questionnaireProblems: questionnaireProblems, questionnaireInstance: questionnaireInstance, averageDifficulty: averageDifficulty, weightedAverageDifficulty: weightedAverageDifficulty, statistics:statistics, endDate: endDate, startDate: startDate, eMsg:g.message(code: 'questionnaire.invalid')]
        }
        }else{
            redirect(action: 'index')
        }


    }

    def create = {
        def questionnaireInstance = new Questionnaire()

        if (params.id) {
            questionnaireInstance = Questionnaire.get(params.id)
        }

        [questionnaire:questionnaireInstance]
    }

    def createGroup = {
        def questionnaireInstance = new Questionnaire()

        if (params.id) {
            questionnaireInstance = Questionnaire.get(params.id)
        }

        [questionnaire:questionnaireInstance, groups: "{'groups': [{'id': '$params.gid'}]}"]
    }

    def save = {
        def questionnaireInstance
        if (params.id) {
            questionnaireInstance = Questionnaire.get(params.id)
        } else {
            questionnaireInstance = new Questionnaire()
        }
        questionnaireInstance.title = params.title
        questionnaireInstance.description = params.description
        if(!params.startDateString.isEmpty() && !params.startHour.isEmpty() && !params.startMinute.isEmpty()
                && !params.endDateString.isEmpty() && !params.endHour.isEmpty() && !params.endMinute.isEmpty()){
            def dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm")
            questionnaireInstance.startDate = dateFormat.parse(params.startDateString + " "+ params.startHour + ":" + params.startMinute)
            questionnaireInstance.endDate = dateFormat.parse(params.endDateString + " "+ params.endHour + ":" + params.endMinute)
        }

        if(!params.groups.isEmpty() && !params.title.isEmpty() && !params.startDateString.isEmpty() && !params.endDateString.isEmpty()){
            def groups = []
            questionnaireInstance.evaluationDetail = params.evaluationDetail ? 2 : 1


            JSON.parse(params.groups).groups.each {
                groups.add(Cluster.get(it.id))
            }

            questionnaireInstance.groups = groups

            try {

                questionnaireInstance.save(flush: true);
                QuestionnaireStatistics.findAllByQuestionnaire(questionnaireInstance).each{ qS ->
                    if(!questionnaireInstance.groups.contains(qS.group)){
                        ClusterPermissions.findAllByGroupAndPermission(qS.group,0).each{ cP->
                            QuestionnaireShiroUser qU = QuestionnaireShiroUser.findByUserAndQuestionnaire(cP.user,questionnaireInstance)
                            if(qU){
                                questionnaireInstance.removeFromQuestionnaireShiroUser(qU)
                                qU.delete()
                            }
                        }
                        qS.delete()
                    }
                }

                questionnaireInstance.groups.each{ group ->
                    if(!QuestionnaireStatistics.findByQuestionnaireAndGroup(questionnaireInstance,group)){
                        QuestionnaireStatistics questStatistics = new QuestionnaireStatistics()
                        questStatistics.questionnaire = questionnaireInstance
                        questStatistics.group = group
                        questStatistics.averageNote = 0
                        questStatistics.standartDeviaton = 0
                        questStatistics.greaterThenEqualsSeven = 0
                        questStatistics.lessSeven = 0
                        questStatistics.tryPercentage = 0
                        questStatistics.save()
                        ClusterPermissions.findAllByGroupAndPermission(group,0).each{ cP ->
                            def questUser = questionnaireInstance.addToQuestionnaireShiroUser(cP.user)
                        }
                    }
                }
                if(questionnaireInstance.questionnaireProblem && !questionnaireInstance.questionnaireProblem.isEmpty() ){
                    rabbitSend 'quest_queue', questionnaireInstance.id.toString()
                }
                redirect(action: 'create2', id: questionnaireInstance.id)
            } catch (Exception e) {
                log.error(e.getMessage(),e)
            }
        } else {
            render(view: "create", model: [questionnaire: questionnaireInstance, testForm: true])
        }

    }
    def downloadNotes = {

        String questName = Questionnaire.get(params.qId).title
        List questUserList = Questionnaire.executeQuery("Select Distinct q from QuestionnaireShiroUser q where q.user.id in (Select Distinct c1.user.id from ClusterPermissions c1 where group.hash = :groupHash  and permission = 0) and q.questionnaire.id = :questId order by q.user.name ", [groupHash: params.hash, questId: Long.parseLong(params.qId)])
		String fileName = "nota do questionário " +  questName;
		questName = questName.replaceAll("-", "").replaceAll("/", "")

        if(params.exportType == 'excel') {

            response.setContentType('application/vnd.ms-excel')
            response.setHeader('Content-Disposition', 'Attachment;Filename=' + fileName + '.xls')

            WritableWorkbook workbook = Workbook.createWorkbook(response.outputStream)

            WritableSheet sheet1 = workbook.createSheet(questName, 0)


            sheet1.addCell(new Label(0,0, "ALUNOS"))
            sheet1.addCell(new Label(1,0, "PONTUAÇÃO"))


            questUserList.eachWithIndex{ questUser, i ->
                String nameUser = questUser.user
                String score = questUser.score
                sheet1.addCell(new Label(0,i+=2, nameUser))
                sheet1.addCell(new Label(1,i, score))
            }
            workbook.write();
            workbook.close();
        }
        else if (params.exportType == 'csv') {

            response.contentType = "application/vnd.ms-excel"
            response.setHeader('Content-Disposition', 'Attachment; Filename=' + fileName + '.csv')
            def write='ALUNOS;PONTUAÇÃO\n',outs = response.outputStream
            questUserList.each { qUser ->

                write = write +  qUser.user + ';' + qUser.score + '\n';

            }
            outs << write
            outs.flush()
            outs.close()
        }
    }

    def getQuestUserByGroup = {
        Questionnaire quest = Questionnaire.get(params.questId)
        List questUserList = Questionnaire.executeQuery("Select distinct q from QuestionnaireShiroUser q where q.user.id in (Select Distinct user.id from ClusterPermissions where group.hash = '" + params.hash + "' and permission = 0) and q.questionnaire.id = " + params.questId + " order by q.user.name ")
        List questList = mongoService.findByQuestionnaireAndGroup(params.questId,params.hash)
        if((System.currentTimeMillis() > quest.endDate.getTime()) && (questList.size() == 0)) {
            mongoService.updateQuestionnairePlagiumList(params.questId)
            questList = mongoService.findByQuestionnaireAndGroup(params.questId,params.hash)
        }
        HashMap<Long, Integer> questStatusMap = new HashMap<Long, Integer>()
        questList.each{
            questStatusMap.put((long) it.id, it.status)
        }
        render(contentType:"text/json") {
            questionnaireList = array {
                questUserList.each {
                    if(it.plagiumStatus == QuestionnaireShiroUser.PLAGIUM_STATUS_TEACHER_PLAGIUM) {
                        questionnaire id:it.id, title:quest.title, userScore: it.score, score:quest.score, name:it.user.name, status:2
                    }
                    else {
                        questionnaire id:it.id, title:quest.title, userScore: it.score, score:quest.score, name:it.user.name, status:questStatusMap.containsKey(it.id)?questStatusMap.get(it.id):3
                    }
                }
            }
        }


    }

    def chart = {
        ArrayList<String> problemList = new ArrayList<String>()
        Map<String,ArrayList<Long[]>> resultMap = new HashMap<String,ArrayList<Long[]>>()
        def statistics = QuestionnaireStatistics.findByQuestionnaireAndGroup(Questionnaire.get(params.questId),Cluster.findByHash(params.hash))
        String query = "Select s.submissionDate, qp.problem.name, count(s.id) from Submission s, QuestionnaireProblem qp where qp.questionnaire.id = "+params.questId+" and s.user.id in (Select u.user.id from ClusterPermissions u where u.permission = 0 and u.group.hash = '"+params.hash+"') and s.problem.id = qp.problem.id and s.submissionDate > qp.questionnaire.startDate and s.submissionDate < qp.questionnaire.endDate group by year(s.submissionDate),month(s.submissionDate),day(s.submissionDate), qp.problem.id"
        String totalQuery = "Select s.submissionDate, 'Total', count(s.id) from Submission s, QuestionnaireProblem qp where qp.questionnaire.id = "+params.questId+" and s.user.id in (Select u.user.id from ClusterPermissions u where u.permission = 0 and u.group.hash = '"+params.hash+"') and s.problem.id = qp.problem.id and s.submissionDate > qp.questionnaire.startDate and s.submissionDate < qp.questionnaire.endDate group by year(s.submissionDate),month(s.submissionDate),day(s.submissionDate)"
        def subCountByDayAndProb = Submission.executeQuery(query)
        if(!subCountByDayAndProb.isEmpty()){
                subCountByDayAndProb.each{
                    if(!resultMap.containsKey(it[1])){
                        resultMap.put(it[1],new ArrayList<Long>())
                    }
                    resultMap.get(it[1]).add([it[0].getTime(),it[2]])

                }
            subCountByDayAndProb = Submission.executeQuery(totalQuery)
            subCountByDayAndProb.each{
                if(!resultMap.containsKey(it[1])){
                    resultMap.put(it[1],new ArrayList<Long>())
                }
                resultMap.get(it[1]).add([it[0].getTime(),it[2]])

            }

        }else{
            resultMap.put("Total",[[0,0]])
            problemList.add("Total")
        }
        render(contentType:"text/json") {
            gTryed = statistics.tryPercentage
            gS = statistics.greaterThenEqualsSeven
            lS = statistics.lessSeven
            submissions = array {
                resultMap.keySet().each {
                    data name:it, data: resultMap.get(it)

                }

            }

        }
    }

    def create2 = {

        def questionnaireInstance

        if (params.id) {
            questionnaireInstance = Questionnaire.get(params.id)
        } else {
            redirect action: 'create'
        }

        questionnaireInstance.groups.each{
            mongoService.generateGroupCountByProblem(it.id)
        }

        [questionnaireInstance: questionnaireInstance]
    }
    def saveProblems = {

        def selectedProblems = JSON.parse(params.selectedProblems)

        def problemList = []
        def problemScore = []
        def questionnaireInstance = Questionnaire.get(params.id)
        def questionnaireProblemList = questionnaireInstance.questionnaireProblem
        def removeQuestionnaireProblemList = []
        def addQuestionnaireProblemList = []

        selectedProblems.problems.each {
            problemList.add(it)
            problemScore.add(it.score)
        }

        questionnaireProblemList.each {
            def questionnaireProblem = it
            def toRemove = true

            problemList.each {
                if (it.id == questionnaireProblem.problem.id) {
                    questionnaireProblem.score =  Double.parseDouble(it.score.toString())
                    toRemove = false
                }
            }

            if (toRemove) {
                removeQuestionnaireProblemList.add(questionnaireProblem);
            }

        }

        problemList.each {
            def problem = it.id
            def toAdd = true

            questionnaireProblemList.each {
                if (problem == it.problem.id) {
                    toAdd = false
                }
            }

            if (toAdd) {
                def questionnaireProblem = new QuestionnaireProblem();
                questionnaireProblem.problem = Problem.get(problem);
                questionnaireProblem.score = Double.parseDouble(it.score.toString())
                questionnaireProblem.questionnaire = questionnaireInstance
                addQuestionnaireProblemList.add(questionnaireProblem);
            }
        }

        questionnaireInstance.questionnaireProblem.removeAll(removeQuestionnaireProblemList)
        questionnaireInstance.questionnaireProblem.addAll(addQuestionnaireProblemList)

        def scoreTotal = 0.0;
        questionnaireInstance.questionnaireProblem.each {
            scoreTotal += it.score * 1000
        }
        scoreTotal = scoreTotal/1000

        questionnaireInstance.score = scoreTotal
        try {
            questionnaireInstance.save(flush: true)
            rabbitSend 'quest_queue', questionnaireInstance.id.toString()
            redirect(action: 'showStatistics', id: questionnaireInstance.id)
        } catch (Exception e) {
            log.error(e.getMessage(),e)
        }
        render "erro"
    }

    def getQuestionnaireProblem = {

        def problemScoreList = []
        def questionnaireInstance = Questionnaire.get(params.id)

        QuestionnaireProblem.findAllByQuestionnaire(questionnaireInstance).each {
            problemScoreList.add([id: it.problem.id, score: it.score]);
        }

        render problemScoreList as JSON

    }

    def getQuestionnaireProblemByMongo = {

        def problemScoreList = []
        def questionnaireInstance = Questionnaire.get(params.id)
        String problemList = "["
        questionnaireInstance.questionnaireProblem.each{
            problemList += ",'" + it.problem.id+ "'"
        }
        problemList += "]"
        problemList = problemList.replaceFirst(',','')
        Map searchParams = new HashMap<>()
        searchParams.put('idList',JSON.parse(problemList))
        searchParams.put('groupId',params.groupId)
        Map scoreMap = new HashMap()
        def result = mongoService.findQuestionnaireProblem(searchParams)
        questionnaireInstance.questionnaireProblem.each {
            scoreMap.put(it.problem.id,it.score)
        }
        result.each{
            it.putAt('score', scoreMap.get(Long.parseLong(it.id)))
        }
        render result as JSON

    }

    def duplicate = {
        def questionnaireInstance = new Questionnaire()
        def questionnaire = Questionnaire.get(params.id)
        def suffix = Questionnaire.findAllByTitleLike(questionnaire.title + '%').size
        def questions = QuestionnaireProblem.findAllByQuestionnaire(questionnaire)
        def questionnaireProblemList = []
        def score = 0.0

        questionnaireInstance.questionnaireProblem = []

        questionnaireInstance.title = questionnaire.title + ' (' + suffix + ')'
        questionnaireInstance.description = questionnaire.description
        questionnaireInstance.evaluationDetail = questionnaire.evaluationDetail
        questionnaireInstance.startDate = questionnaire.startDate
        questionnaireInstance.endDate = questionnaire.endDate

        questions.each {
            def questionnaireProblem = new QuestionnaireProblem()
            questionnaireProblem.problem = it.problem
            questionnaireProblem.score = it.score
            questionnaireProblem.questionnaire = questionnaireInstance
            questionnaireProblemList.add(questionnaireProblem)
            score = score + it.score
        }

        questionnaireInstance.questionnaireProblem.addAll(questionnaireProblemList)
        questionnaireInstance.score = score

        if (questionnaireInstance.save()) {
            redirect action: 'create', id: questionnaireInstance.id
        }



    }

    def remove = {
        def questionnaireInstance = Questionnaire.get(params.id)
            questionnaireInstance.questionnaireProblem.each{
                it.delete()
            }
            questionnaireInstance.questionnaireShiroUser.each{
                it.delete()
            }
            questionnaireInstance.delete()
            redirect(action:'index')
    }

    def getQuestionnaireShiroUser = {
        QuestionnaireShiroUser questUser = QuestionnaireShiroUser.get(params.id)
        render(contentType: "text/json"){
            quest = questUser
        }
    }

    def generatePlagiumList = {
        mongoService.generateQuestionnairePlagiumList()
    }

    def durationTime = {
        def questionnaire = Questionnaire.get(params.id)

        def TimeDuration td = TimeCategory.minus(questionnaire.endDate, questionnaire.startDate)

        render(contentType:"text/json") {
            [years: td.getYears(), months: td.getMonths(),days: td.getDays(), hours: td.getHours(), minutes: td.getMinutes(), seconds: td.getSeconds()]
        }

    }

    def remainingTime = {
        def questionnaire = Questionnaire.get(params.id)

        def TimeDuration td = TimeCategory.minus(questionnaire.endDate, new Date())

        render(contentType:"text/json") {
            [years: td.getYears(), months: td.getMonths(),days: td.getDays(), hours: td.getHours(), minutes: td.getMinutes(), seconds: td.getSeconds()]
        }

    }

    def getLastestQuestionnaires = {
        def questionnaireList = questService.getLastestQuestionnaires(session.profile, session.license, 10)
        def simpleDateFormat = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss")
        def questionnaireToShow = []


        if (session.license.isStudent()) {
            questionnaireList.each {
                questionnaireToShow.add(it.questionnaire)
            }
        } else {
            questionnaireToShow = questionnaireList
        }

        render(contentType: "text/json") {
            questionnaires = array  {
                questionnaireToShow.each {
                    def link = "/huxley"

                    if (session.license.isStudent()) {
                        link += "/quest/show/" + it.id
                    } else {
                        link += "/quest/showStatistics/" + it.id
                    }
                    questionnaire title: it.title, startDate: simpleDateFormat.format(it.startDate), endDate: simpleDateFormat.format(it.endDate), link: link
                }
            }
        }
    }

    def generateCoursePlan = {
        ShiroUser user = ShiroUser.get(params.id)
        Profile profile = Profile.findByUser(ShiroUser.get(params.id))
        ClusterPermissions.findAllByUserAndPermission(user, 30).each {
            CoursePlan course = new CoursePlan()
            Questionnaire.executeQuery("select q from Questionnaire q where :group in elements(q.groups) order by q.startDate", [group: it.group]).each { quest ->
                course.addToQuestionnaire(quest)
            }
            course.owner = profile
            course.description = "Essa turminha vai aprontar enormes confusões"
            course.title = "um titulo beem legal"
            course.save()

        }
        render(contentType: "text/json") {
            CoursePlan.list()
        }
    }

    def createCoursePlan = {
        Profile profile = Profile.findByUser(ShiroUser.get(session.license.user.id))
        CoursePlan course = new CoursePlan()
        course.owner = profile
        course.description = params.description
        course.title = params.title
        JSON.parse(params.questionnaireList).each {
            course.addToQuestionnaire(Questionnaire.get(it))
        }
        if(course.save()) {
            render(contentType: "text/json") {
                course
            }
        } else {
            String errorMsg = ""
            course.errors.each{
                errorMsg += it + ";"
            }
            render(contentType: "text/json") {
                errorMsg
            }
        }
    }

    def coursePlan = {
        if(params.id) {
            [groupId:params.id]
        } else {
            def groupList = ClusterPermissions.findAllByUserAndPermission(session.license.user, 30).group
            [groupList: groupList, groupId:groupList[0].id]
        }

    }


    def getPlanList = {
        render(contentType: "text/json") {
            plans = array{
                CoursePlan.list().each {
                    plan id:it.id, title:it.title, description: it.description, owner: it.owner, institution: it.owner.institution.name
                }
            }
        }
    }

    def showPlan = {
        [id:params.id, groupId:params.groupId, hash:Cluster.get(params.groupId).hash]
    }

    def getCourse = {
        def coursePlan = CoursePlan.get(params.id)
        def lastDate = 0
        def minStartDate = null
        def greaterEndDate = null
        def duration = 0
        render(contentType: "text/json") {
            questionnaireList = array {
                coursePlan.questionnaire.each{
                    def startDate = it.startDate
                    def endDate = it.endDate
                    if (lastDate != 0 ) {
                        use(groovy.time.TimeCategory) {
                            lastDate = startDate - lastDate
                            lastDate = lastDate.days
                            duration = endDate - startDate
                            duration = duration.days
                            if (!minStartDate || minStartDate > startDate) {
                                minStartDate = startDate
                            }
                            if (!greaterEndDate || greaterEndDate < endDate) {
                                greaterEndDate = endDate
                            }
                        }
                    } else {
                        use(groovy.time.TimeCategory) {
                            duration = endDate - startDate
                            duration = duration.days
                            if (!minStartDate || minStartDate > startDate) {
                                minStartDate = startDate
                            }
                            if (!greaterEndDate || greaterEndDate < endDate) {
                                greaterEndDate = endDate
                            }
                        }
                    }
                    def problemList = []
                    def ndMed = 0
                    def problemCount = 0
                        it.questionnaireProblem.each {
                            problemList.add(id: it.problem.id, name:it.problem.name, score: it.score, nd:it.problem.nd, topic: it.problem.topics.name)
                            ndMed += it.problem.nd
                            problemCount ++
                        }
                    ndMed = problemCount ==0? 0:(int) (ndMed / problemCount)

                    questionnaire id: it.id, title: it.title, description: it.description, interval:lastDate, duration: duration == null? 0: duration, problemList: problemList, ndMed: ndMed, startDate:it.startDate, endDate:it.endDate

                    lastDate = it.endDate


                }
            }
            use(groovy.time.TimeCategory) {
                duration = greaterEndDate - minStartDate
                duration = duration.days

            }
            plan id:coursePlan.id, title:coursePlan.title, description: coursePlan.description, owner: coursePlan.owner, dateCreated: coursePlan.dateCreated, duration: duration
        }
    }

    def importCourse = {
        Cluster groupInstance = Cluster.get(params.groupId)
        def dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm")
        def msg = [status: "ok"]
        if(groupInstance) {
            ArrayList<Cluster> groups = new ArrayList<Cluster>()
            groups.add(groupInstance)
            def questList = JSON.parse(params.questList)
            def validPeriods = true
            questList.each{
                validPeriods = !validPeriods? validPeriods: dateFormat.parse(it.startDate) < dateFormat.parse(it.endDate)
            }
            if(validPeriods) {
                questList.each {
                    Questionnaire quest = Questionnaire.get(it.id)
                    Questionnaire newQuest = new Questionnaire()
                    newQuest.startDate = dateFormat.parse(it.startDate)
                    newQuest.endDate = dateFormat.parse(it.endDate)
                    newQuest.title = quest.title
                    newQuest.description = quest.description
                    newQuest.evaluationDetail = quest.evaluationDetail
                    newQuest.score = quest.score
                    newQuest.groups = groups
                    try {
                        def questions = QuestionnaireProblem.findAllByQuestionnaire(quest)
                        def questionnaireProblemList = []
                        def score = 0.0
                        questions.each {
                            def questionnaireProblem = new QuestionnaireProblem()
                            questionnaireProblem.problem = it.problem
                            questionnaireProblem.score = it.score
                            questionnaireProblem.questionnaire = newQuest
                            questionnaireProblemList.add(questionnaireProblem)
                            score = score + it.score
                        }
                        newQuest.questionnaireProblem = []
                        newQuest.questionnaireProblem.addAll(questionnaireProblemList)


                        if(newQuest.save(flush: true)){
                            newQuest.groups.each{ group ->
                                if(!QuestionnaireStatistics.findByQuestionnaireAndGroup(newQuest,group)){
                                    QuestionnaireStatistics questStatistics = new QuestionnaireStatistics()
                                    questStatistics.questionnaire = newQuest
                                    questStatistics.group = group
                                    questStatistics.averageNote = 0
                                    questStatistics.standartDeviaton = 0
                                    questStatistics.greaterThenEqualsSeven = 0
                                    questStatistics.lessSeven = 0
                                    questStatistics.tryPercentage = 0
                                    questStatistics.save()
                                    ClusterPermissions.findAllByGroupAndPermission(group,0).each{ cP ->
                                        def questUser = newQuest.addToQuestionnaireShiroUser(cP.user)
                                    }
                                }
                            }
                            if(newQuest.questionnaireProblem && !newQuest.questionnaireProblem.isEmpty() ){
                                rabbitSend 'quest_queue', newQuest.id.toString()
                            }
                        }


                    } catch (Exception e) {
                        log.error(e.getMessage(),e)
                        msg.status = "fail"
                        msg.msg = "Ocorreu um erro"
                    }
                }
            } else {
                msg.status = "fail"
                msg.msg = "Período inválido"
            }


        } else {
            msg.status = "fail"
            msg.msg = "Grupo não encontrado"
        }
        render(contentType: "text/json"){
            msg
        }
    }

    def addQuestUserPenalty = {
        def score = Double.parseDouble(params.score), correct, msg = [status:'ok'], saved = true
        QuestionnaireShiroUser questUser = QuestionnaireShiroUser.get(params.id)
        if(params.questProblem) {
            QuestionnaireProblem questProblem = QuestionnaireProblem.get(params.questProblem)
            QuestionnaireUserPenalty questUserProblemPenalty = QuestionnaireUserPenalty.findByQuestionnaireUserAndQuestionnaireProblem(questUser, questProblem)
            Questionnaire quest = questProblem.questionnaire
            if(!questUserProblemPenalty){
                questUserProblemPenalty = new QuestionnaireUserPenalty()
                questUserProblemPenalty.questionnaireUser = questUser
                questUserProblemPenalty.questionnaireProblem = questProblem
            }
            questUser.score+= questUserProblemPenalty.penalty
            correct = Submission.executeQuery("Select count(s) from Submission s where s.user.id = :userId and s.submissionDate >= :startDate and s.submissionDate <= :endDate and s.problem.id = :problemId and s.evaluation = :evaluation",[userId: questUser.user.id, startDate: quest.startDate, endDate: quest.endDate, problemId: questProblem.problem.id, evaluation:EvaluationStatus.CORRECT])[0] > 0
            if(correct) {
                questUserProblemPenalty.penalty = questProblem.score - score
            } else {
                questUserProblemPenalty.penalty = - score
            }
            saved = questUserProblemPenalty.save()
            questUser.score+= - questUserProblemPenalty.penalty
        } else {
            questUser.score = score
        }
        questUser.score = questUser.score < 0? 0 : questUser.score
        msg.score = questUser.score
        questUser.status = QuestionnaireShiroUser.MASTER_CORRECTED
        if(!saved || !questUser.save()){
            msg.status = 'fail'
        }
        render(contentType:"text/json") {
            msg
        }


    }

}
