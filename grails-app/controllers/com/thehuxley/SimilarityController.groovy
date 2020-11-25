package com.thehuxley

import com.thehuxley.util.HuxleyProperties
import grails.converters.JSON

class SimilarityController {

    private final static double SIMILARITY_THRESHOLD = Double.parseDouble(HuxleyProperties.getInstance().get("similarity.threshold"))
    def mongoService

    def index() { }

    def list = {
        Submission submission = Submission.get(params.id)
        Profile profile = Profile.findByUser(submission.user)
     [submission:submission,profile:profile]
    }

    def listByQuest = {
        Questionnaire quest = Questionnaire.get(params.questId)
        Cluster group = Cluster.findByHash(params.hash)
        def problemList = []
        def userList = ClusterPermissions.findAllByGroupAndPermission(group,0).user
        def plagList = []
        def plagIdList = []
        def questPlagMap = [:]
        def questProblemMap = [:]
        quest.questionnaireProblem.each {
            questProblemMap.put(it.problem.id, it.id)
        }
        quest.questionnaireProblem.each {

            def submissionSuspect = Submission.executeQuery("Select max(s.id) from Submission s where s.submissionDate < :questEndDate and s.user in :userList and s.evaluation = :evaluation and s.problem.id = :problemId group by s.user", [questEndDate:quest.endDate, userList:userList, evaluation: EvaluationStatus.CORRECT, problemId: it.problem.id])
            if(!submissionSuspect.isEmpty()) {
                submissionSuspect = Submission.getAll(submissionSuspect)
                submissionSuspect.each { submission->
                    QuestionnaireShiroUser.executeQuery("Select q.user.id, q.id, q.score from QuestionnaireShiroUser q where q.user in :uId and q.questionnaire.id = :qId", [uId: userList, qId: quest.id]).each {
                        questPlagMap.put(it[0], [qId:it[1], score:it[2]])
                    }
                    def submissionPlagMap = [:]
                    if (submission.plagiumStatus == Submission.PLAGIUM_STATUS_MATCHED) {
                        Plagium.executeQuery("Select p from Plagium p where p.submission1 = :submission and p.submission1.submissionDate > p.submission2.submissionDate", [submission:submission]).each { plag ->
                            if(!submissionPlagMap[plag.submission2.user]) {
                                submissionPlagMap[plag.submission2.user] = plag
                            } else {
                                if(submissionPlagMap[plag.submission2.user].percentage < plag.percentage) {
                                    submissionPlagMap[plag.submission2.user] = plag
                                }
                            }
                        }
                        Plagium.executeQuery("Select p from Plagium p where p.submission2 = :submission and p.submission2.submissionDate > p.submission1.submissionDate", [submission:submission]).each { plag ->
                            if(!submissionPlagMap[plag.submission1.user]) {
                                submissionPlagMap[plag.submission1.user] = plag
                            } else {
                                if(submissionPlagMap[plag.submission1.user].percentage < plag.percentage) {
                                    submissionPlagMap[plag.submission1.user] = plag
                                }
                            }

                        }
                    }
                    def plag = []
                    submissionPlagMap.keySet().each { userSuspect ->
                        def plagiarism = submissionPlagMap[userSuspect]
                        def language = submission.language
                        if(language.equals('Python')) {
                            language = 'py'
                        } else if(language.equals('Octave')) {
                            language = 'octave'
                        } else {
                            language = 'cpp'
                        }
                        def questMap = questPlagMap.get(submission.user.id)
                        questMap.put('qpId',questProblemMap.get(submission.problem.id))
                        plag = [ user1:huxley.userBox(user:submission.user), user2:huxley.userBox(user:userSuspect), plag:plagiarism, groups:ClusterPermissions.findAllByUser(userSuspect), code1:submission.downloadCode().replaceAll('<','&lt'), code2:plagiarism.submission2!=submission?plagiarism.submission2.downloadCode().replaceAll('<','&lt'):plagiarism.submission1.downloadCode().replaceAll('<','&lt'), subId:plagiarism.submission2==submission?plagiarism.submission2.id:plagiarism.submission1.id, language:language, date1:submission.submissionDate, date2:plagiarism.submission2==submission?plagiarism.submission1.submissionDate:plagiarism.submission2.submissionDate, problem:submission.problem.id, plagId: plagiarism.id, pStatus: submission.plagiumStatus, quest: questMap]
                        if (plagIdList.indexOf(plagiarism.id) == -1) {
                            plagList.add(plag)
                            plagIdList.add(plagiarism.id)
                        }
                        if (problemList.id.indexOf(submission.problem.id) == -1) {
                            problemList.add(submission.problem)
                        }

                    }

                }
            }

        }

        render(contentType: "text/json") {
            result: [list: plagList, problemList: problemList]
        }


    }

    def listConfirmedByQuest = {
        Questionnaire quest = Questionnaire.get(params.questId)
        Cluster group = Cluster.findByHash(params.hash)
        def problemList = []
        def userList = ClusterPermissions.findAllByGroupAndPermission(group,0).user
        def plagList = []
        def plagIdList = []
        def questPlagMap = [:]
        def questProblemMap = [:]
        quest.questionnaireProblem.each {
            questProblemMap.put(it.problem.id, it.id)
        }
        quest.questionnaireProblem.each {

            def submissionSuspect = Submission.executeQuery("Select max(s.id) from Submission s where s.submissionDate < :questEndDate and s.user in :userList and s.evaluation = :evaluation and s.problem.id = :problemId group by s.user", [questEndDate:quest.endDate, userList:userList, evaluation: EvaluationStatus.CORRECT, problemId: it.problem.id])
            if(!submissionSuspect.isEmpty()) {
                submissionSuspect = Submission.getAll(submissionSuspect)
                submissionSuspect.each { submission->
                    QuestionnaireShiroUser.executeQuery("Select q.user.id, q.id, q.score from QuestionnaireShiroUser q where q.user in :uId and q.questionnaire.id = :qId", [uId: userList, qId: quest.id]).each {
                        questPlagMap.put(it[0], [qId:it[1], score:it[2]])
                    }
                    def submissionPlagMap = [:]
                    if (submission.plagiumStatus == Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM) {
                        Plagium.executeQuery("Select p from Plagium p where p.submission1 = :submission and p.submission1.submissionDate > p.submission2.submissionDate and p.status = :plagStatus", [submission:submission, plagStatus:Plagium.PlagiarismStatus.CONFIRMED]).each { plag ->
                            if(!submissionPlagMap[plag.submission2.user]) {
                                submissionPlagMap[plag.submission2.user] = plag
                            } else {
                                if(submissionPlagMap[plag.submission2.user].percentage < plag.percentage) {
                                    submissionPlagMap[plag.submission2.user] = plag
                                }
                            }
                        }
                        Plagium.executeQuery("Select p from Plagium p where p.submission2 = :submission and p.submission2.submissionDate > p.submission1.submissionDate and p.status = :plagStatus", [submission:submission, plagStatus:Plagium.PlagiarismStatus.CONFIRMED]).each { plag ->
                            if(!submissionPlagMap[plag.submission1.user]) {
                                submissionPlagMap[plag.submission1.user] = plag
                            } else {
                                if(submissionPlagMap[plag.submission1.user].percentage < plag.percentage) {
                                    submissionPlagMap[plag.submission1.user] = plag
                                }
                            }

                        }
                    }
                    def plag = []
                    submissionPlagMap.keySet().each { userSuspect ->
                        def plagiarism = submissionPlagMap[userSuspect]
                        def language = submission.language
                        if(language.equals('Python')) {
                            language = 'py'
                        } else if(language.equals('Octave')) {
                            language = 'octave'
                        } else {
                            language = 'cpp'
                        }
                        def questMap = questPlagMap.get(submission.user.id)
                        questMap.put('qpId',questProblemMap.get(submission.problem.id))
                        plag = [ user1:huxley.userBox(user:submission.user), user2:huxley.userBox(user:userSuspect), plag:plagiarism, groups:ClusterPermissions.findAllByUser(userSuspect), code1:submission.downloadCode().replaceAll('<','&lt'), code2:plagiarism.submission2!=submission?plagiarism.submission2.downloadCode().replaceAll('<','&lt'):plagiarism.submission1.downloadCode().replaceAll('<','&lt'), subId:plagiarism.submission2==submission?plagiarism.submission2.id:plagiarism.submission1.id, language:language, date1:submission.submissionDate, date2:plagiarism.submission2==submission?plagiarism.submission1.submissionDate:plagiarism.submission2.submissionDate, problem:submission.problem.id, plagId: plagiarism.id, pStatus: submission.plagiumStatus, quest: questMap]
                        if (plagIdList.indexOf(plagiarism.id) == -1) {
                            plagList.add(plag)
                            plagIdList.add(plagiarism.id)
                        }
                        if (problemList.indexOf(submission.problem) == -1) {
                            problemList.add(submission.problem)
                        }

                    }

                }
            }

        }

        render(contentType: "text/json") {
            result: [list: plagList, problemList: problemList]
        }


    }


    def listByQuestionnaire = {
        QuestionnaireShiroUser  questUser = QuestionnaireShiroUser.get(params.qId)
        Profile profile = Profile.findByUser(questUser.user)
        Questionnaire quest = questUser.questionnaire
        Map plagiumStatus = new HashMap<QuestionnaireProblem,Integer>()
        quest.questionnaireProblem.each{
            if(!Submission.executeQuery("Select Distinct s from Submission s where user.id = " + questUser.user.id + " and s.plagiumStatus = " + Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM + " and s.submissionDate < '" + quest.endDate + "' and s.problem.id =" + it.problem.id,[max:1]).isEmpty()){
                plagiumStatus.put(it,Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM)
            }else if(!Submission.executeQuery("Select s from Submission s where user.id = " + questUser.user.id + " and s.plagiumStatus = " + Submission.PLAGIUM_STATUS_MATCHED + " and s.submissionDate < '" + quest.endDate + "' and s.problem.id =" + it.problem.id,[max:1]).isEmpty()){
                plagiumStatus.put(it,Submission.PLAGIUM_STATUS_MATCHED)
            }
        }
        [profile:profile,plagiumStatus:plagiumStatus,questUser:questUser]


    }

    def listByQuestProblem = {
        QuestionnaireProblem questProblem = QuestionnaireProblem.get(params.id)
        QuestionnaireShiroUser questUser = QuestionnaireShiroUser.get(params.qUserId)
        ArrayList<Submission> submissions = Submission.executeQuery("Select s from Submission s where user.id = " + questUser.user.id + " and s.plagiumStatus in (2,5) and s.submissionDate < '" + questProblem.questionnaire.endDate + "' and s.problem.id =" + questProblem.problem.id)
        ShiroUser userSuspect = new ShiroUser()
        Submission submissionSuspect = new Submission()
        Plagium plagium = new Plagium()
        QuestionnaireShiroUser questionnaireSuspect = new QuestionnaireShiroUser()
        QuestionnaireUserPenalty questUserPenalty = QuestionnaireUserPenalty.findByQuestionnaireUserAndQuestionnaireProblem(questUser,questProblem)
        boolean sub1 = false
        int status = 0
        submissions.each {
            if(it.plagiumStatus == Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM){
                status = Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM
            }else if(status == 0 && it.plagiumStatus == Submission.PLAGIUM_STATUS_MATCHED){
                status = Submission.PLAGIUM_STATUS_MATCHED
            }
            Plagium.executeQuery("Select Distinct p from Plagium p where p.submission1.id = " + it.id +" and p.percentage > " + SIMILARITY_THRESHOLD + " order by p.percentage desc limit 1").each {
                if(it.percentage > plagium.percentage) {
                    plagium = it
                }
            }
            if (plagium.submission2) {
                userSuspect = plagium.submission2.user
                submissionSuspect = plagium.submission2
            }
            Plagium.executeQuery("Select Distinct p from Plagium p where p.submission2.id = " + it.id +" and p.percentage > " + SIMILARITY_THRESHOLD + " order by p.percentage desc limit 1").each{
                if(it.percentage > plagium.percentage) {
                    plagium = it
                    sub1 = true
                }
            }
        }
        if (sub1) {
            if (plagium.submission1) {
                userSuspect = plagium.submission1.user
                submissionSuspect = plagium.submission1
            }
        }

        QuestionnaireShiroUser questionnaireShiroUser = QuestionnaireShiroUser.findByQuestionnaireAndUser(questProblem.questionnaire,userSuspect)
        if(questionnaireShiroUser){
            questionnaireSuspect = questionnaireShiroUser
        }
        def language = submissionSuspect.language
        if(language.equals('Python')) {
            language = 'py'
        } else if(language.equals('Octave')) {
            language = 'octave'
        } else {
            language = 'cpp'
        }
        render(contentType:"text/json") {
            plag = [ user1:huxley.userBox(user:questUser.user), user2:huxley.userBox(user:userSuspect), plag:plagium, groups:ClusterPermissions.findAllByUser(userSuspect), questUserId:questionnaireSuspect.id?questionnaireSuspect.id:"undefined", questUserName:questionnaireSuspect.id?questionnaireSuspect.user.name:"undefined" , code1:sub1?plagium.submission2.downloadCode().replaceAll('<','&lt'):plagium.submission1.downloadCode().replaceAll('<','&lt'), code2:sub1?plagium.submission1.downloadCode().replaceAll('<','&lt'):plagium.submission2.downloadCode().replaceAll('<','&lt'), subId:sub1?plagium.submission2.id:plagium.submission1.id, language:language, date1:sub1?plagium.submission2.submissionDate:plagium.submission1.submissionDate, date2:sub1?plagium.submission1.submissionDate:plagium.submission2.submissionDate]
            pStatus = status
            score = questProblem.score
            penalty = (questUserPenalty?questUserPenalty:'undefined')

        }
    }
    def questPenalty = {
        boolean save = false
        QuestionnaireProblem questProblem = QuestionnaireProblem.get(params.qProbId)
        Double penalty = Double.parseDouble(params.penalty)
        QuestionnaireShiroUser questUser
        ArrayList<QuestionnaireShiroUser> questUserList = new ArrayList<QuestionnaireShiroUser>()
        if(params.qUserId){
            questUser = QuestionnaireShiroUser.get(params.qUserId)
            if(questUser){
                questUserList.add(questUser)
            }
        }else{
            def questList = QuestionnaireShiroUser.getAll(JSON.parse(params.qUserIdList))
            if(questList){
                questUserList = questList
            }
        }
        questUserList.each{ qUser ->
            QuestionnaireUserPenalty questPenalty = new QuestionnaireUserPenalty()
            questPenalty.questionnaireProblem = questProblem
            questPenalty.questionnaireUser = QuestionnaireShiroUser.get(qUser.id)
            if(penalty == 0 || (qUser.score - penalty <= 0)){
                questPenalty.penalty = qUser.score
                qUser.score = 0
            }else{
                questPenalty.penalty = penalty
                qUser.score = qUser.score - penalty
            }
            qUser.status = QuestionnaireShiroUser.MASTER_CORRECTED
            save = qUser.save()
            if(save){
                save = questPenalty.save()
            }
        }
        String saved = (save?'ok':'error')
            render(contentType: "text/json"){
                status = saved
            }


    }

    def removeQuestPenalty = {
        boolean saved = false
        ArrayList<QuestionnaireUserPenalty> questPenalty = new ArrayList<QuestionnaireUserPenalty>()
        if (params.qId){
            questPenalty = new ArrayList<QuestionnaireUserPenalty>()
            questPenalty.add(QuestionnaireUserPenalty.get(params.qId))
        }else{
            questPenalty.add(QuestionnaireUserPenalty.findByQuestionnaireProblemAndQuestionnaireUserInList(QuestionnaireProblem.get(params.qProbId),QuestionnaireShiroUser.getAll(JSON.parse(params.qUserIdList))))
        }
        questPenalty.each {
            QuestionnaireShiroUser questUser = it.questionnaireUser
            questUser.score += it.penalty
            if (questUser && questUser.save()){
                 it.delete()
                 saved = true
            }

        }
        String isSaved = (saved?'ok':'error')
        render(contentType: "text/json"){
            status = isSaved
        }
    }

    def show = {
        Plagium plagium = Plagium.get(params.id)
        if(plagium){
            Submission submissionInstance = plagium.submission1
            Submission submissionInstance2 = plagium.submission2
            if (params.qId) {
                QuestionnaireShiroUser questUser = QuestionnaireShiroUser.get(params.qId)

                QuestionnaireProblem questionnaireProblem = QuestionnaireProblem.findByQuestionnaireAndProblem(questUser.questionnaire, submissionInstance.problem)
                [qpId:questionnaireProblem.id, plag:plagium,submission:submissionInstance,suspect1:Profile.findByUser(submissionInstance.user),suspect2:Profile.findByUser(submissionInstance2.user),code:submissionInstance.downloadCode().replaceAll('<','&lt'), code2:submissionInstance2.downloadCode().replaceAll('<','&lt'),language:submissionInstance.language.name,rId:params.sId,justLeft:true,qId:params.qId]
            }else {
                [plag:plagium,submission:submissionInstance,suspect1:Profile.findByUser(submissionInstance.user),suspect2:Profile.findByUser(submissionInstance2.user),code:submissionInstance.downloadCode().replaceAll('<','&lt'), code2:submissionInstance2.downloadCode().replaceAll('<','&lt'),language:submissionInstance.language.name,rId:params.sId,justLeft:true,qId:params.qId]
            }
        } else {
            response.sendError(404)
        }


    }

    def markAsPlag= {
        Submission submission = Submission.get(params.id)
        submission.markAsPlag()
        if (params.pId) {
            def plagium = Plagium.get(params.pId)
            plagium.status = Plagium.PlagiarismStatus.CONFIRMED
            plagium.save()
        }
        if (params.qId) {
            def info = QuestionnaireShiroUser.get(params.qId);
            info.plagiumStatus = QuestionnaireShiroUser.PLAGIUM_STATUS_TEACHER_PLAGIUM;
            info.save();
        }
        redirect(action:"list" , params:[id:params.id])
    }

    def markNotPlag= {
        Submission submission = Submission.get(params.id)
        submission.markAsNotPlag()
        if (params.pId) {
            def plagium = Plagium.get(params.pId)
            plagium.status = Plagium.PlagiarismStatus.DISCARDED
            plagium.save()
        }
        redirect(action:"list" , params:[id:params.id])
    }

    def questMarkAsPlag = {
        Submission submission = Submission.get(params.id)
        submission.markAsPlag()
        def msg = [status:'ok']
        if (params.qId) {
            def info = QuestionnaireShiroUser.get(params.qId);
            mongoService.updateQuestionnairePlagiumList(info.questionnaire.id)
            info.plagiumStatus = QuestionnaireShiroUser.PLAGIUM_STATUS_TEACHER_PLAGIUM;
            if (!info.save()) {
                msg.status = 'fail'
            }
        }
        if (params.pId) {
            def plagium = Plagium.get(params.pId)
            plagium.status = Plagium.PlagiarismStatus.CONFIRMED
            plagium.save()
        }
        render(contentType: 'text/json') {
            msg
        }

    }

    def questMarkAsNotPlag = {
        Submission submission = Submission.get(params.id)
        submission.markAllAsNotPlag()
        if (params.qId) {
            def info = QuestionnaireShiroUser.get(params.qId);
            mongoService.updateQuestionnairePlagiumList(info.questionnaire.id)

        }
        if (params.pId) {
            def plagium = Plagium.get(params.pId)
            plagium.status = Plagium.PlagiarismStatus.DISCARDED
            plagium.save()
        }
        def msg = [status:'ok']
        render(contentType: 'text/json') {
            msg
        }
    }
}
