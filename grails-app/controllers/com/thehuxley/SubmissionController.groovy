package com.thehuxley
import java.text.SimpleDateFormat
import grails.converters.JSON

class SubmissionController {

    def submissionService
    def userProblemService

    public static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("HH:mm:ss dd/MM/yyyy");
    public static final SimpleDateFormat SUBMISSION_DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");
    public static final SimpleDateFormat DB_SUBMISSION_DATE_FORMAT = new SimpleDateFormat("yyyy/MM/dd");


    def index() {
        ShiroUser user
        Problem problem
        if(params.userId && !session.license.isStudent()){
            user = ShiroUser.get(params.userId)
        }
        if(params.problemId){
            problem = Problem.get(params.problemId)
        }
        [permission:0,problem:problem ,user: user]

    }

    def getSubmissionInfo () {
        def problemSubmissionInfo = submissionService.getSubmissionInfo(
            session.profile.user,
            Problem.get(params.id)
        )

        render(contentType: "text/json") {
            JSON.parse(problemSubmissionInfo)
        }
            
    }

    def getSubmissionInfoById () {
        def problemSubmissionInfo = '{}'
        if (params.id) {
            problemSubmissionInfo = submissionService.getSubmissionInfoById(params.id)
        }
        render(contentType: "text/json") {
            JSON.parse(problemSubmissionInfo)
        }
    }

    def save = {

        def userInstitutionIds = ClusterPermissions.findAllByUser(session.profile.user as ShiroUser).group.institution.id

        if(params.qqfile && params.qqfile.contains('.')){
            Submission submissionInstance = new Submission()
            int pos = params.qqfile.lastIndexOf('.');
            String extension = params.qqfile.substring(pos + 1);
            extension = extension.toLowerCase()
            if (extension.equals("c")) {
                submissionInstance.language = Language.findByName("C")
            } else if (extension.equals("cpp")) {
                submissionInstance.language = Language.findByName("Cpp")
            } else if (extension.equals("pas")) {
                submissionInstance.language = Language.findByName("Pascal")
            } else if (extension.equals("py")) {
                if(userInstitutionIds.contains(2L) || userInstitutionIds.contains(79L)) {
                    submissionInstance.language = Language.get(2)
                } else {
                    submissionInstance.language = Language.get(5)
                }
            } else if (extension.equals("java")) {
                submissionInstance.language = Language.findByName("Java")
            } else if (extension.equals("m")) {
                submissionInstance.language = Language.findByName("Octave")
            }else{

                flash.message = "Linguagem não suportada."
            }
            if(submissionInstance.language){

                submissionInstance.problem = Problem.get(params.pid)
                submissionInstance.tries = Submission.countByUserAndProblem(session.profile.user, submissionInstance.problem) + 1
                submissionInstance.user = session.profile.user
                submissionInstance.time= -1
                submissionService.createUserDirectory(submissionInstance)
                submissionService.createFiles(request, params,submissionInstance)
                submissionInstance.evaluation = EvaluationStatus.WAITING
                submissionInstance.submissionDate = new GregorianCalendar().getTime()
                submissionInstance.plagiumStatus = Submission.PLAGIUM_STATUS_WAITING
                submissionInstance.cacheProblemName = submissionInstance.problem.name
                submissionInstance.cacheUserName = submissionInstance.user.name
                submissionInstance.cacheUserEmail = submissionInstance.user.email
                submissionInstance.cacheUserUsername = submissionInstance.user.username
                if (submissionInstance.save()) {
                    try{
                        rabbitSend 'submission_queue', submissionInstance.id.toString()
                        ClusterPermissions.findAllByUser(session.profile.user).group.institution.each{
                            CPDQueue queue = new CPDQueue(submissionInstance.problem.id,submissionInstance.language.name,it.id);
                            if (CPDQueue.executeQuery("Select cpd from CPDQueue cpd where cpd.problemId = "+queue.problemId+" and cpd.language = '"+queue.language+"' and cpd.institutionId = " + it.id).size() == 0){
                                queue.save();
                                queue.errors.each{ log.error(it)}
                            }
                        }
                    }catch(Exception e){
                        log.error("Erro ao colocar a submissão ["+submissionInstance.id+"],problema ["+params.pid+"], na fila de avaliação",e);
                    }

                    userProblemService.invalidateCache(session.profile.user)
                    submissionService.invalidateCache(session.profile.user, submissionInstance.problem)

                    render(contentType:"text/json") {
                        submission (id: submissionInstance.id, language: submissionInstance.language.name, tries: submissionInstance.tries)
                    }
                } else {
                    submissionInstance.errors.each {
                        log.error(it)
                    }
                    render(contentType:"text/json") {
                        submission (message: "error")
                    }
                }
            } else {
                render(contentType:"text/json") {
                    submission (message: "error")
                }
            }
            }


    }

    def search ={
        Hashtable<String, String> data = new Hashtable<String, String>()
        //defaults:
        data.put("sort" , "s.submissionDate")
        data.put("order", "desc")
        if(params.max == null){
            data.put("max",10)
        }else{
            data.put("max",Integer.parseInt(params.max))
        }
        if (params.beginDate && params.beginDate!='undefined'){
            data.put(Submission.PARAMS_BEGIN_DATE, DB_SUBMISSION_DATE_FORMAT.format(SUBMISSION_DATE_FORMAT.parse(params.beginDate)))
        }
        if (params.endDate && params.endDate!='undefined'){
            data.put(Submission.PARAMS_END_DATE, DB_SUBMISSION_DATE_FORMAT.format(SUBMISSION_DATE_FORMAT.parse(params.endDate)))
        }
        if(params.evaluation && !params.evaluation.equals("all")){
            data.put(Submission.PARAMS_EVALUATION, params.evaluation)
        }

        if(params.problemId && params.problemId!='undefined'){
            data.put(Submission.PARAMS_PROBLEM_ID, params.problemId)
        }else if(params.problemName && params.problemName!='undefined'){
            data.put(Submission.PARAMS_PROBLEM_NAME, params.problemName)
        }

        if (session.license.isStudent()){
            data.put(Submission.PARAMS_USER_ID, session.profile.user.id)
        }else if (params.userId && params.userId!='undefined'){
            data.put(Submission.PARAMS_USER_ID, params.userId)
        }else if(params.userName && params.userName!='undefined'){
            data.put(Submission.PARAMS_USER_NAME, params.userName)
        }else if(params.listBy && params.userName =='undefined' ){
            data.put(Submission.PARAMS_USER_ID, session.profile.user.id)
        }
        if(params.sort && params.sort!='undefined'){
            data.put("sort" , params.sort)
        }
        if(params.order && params.order!='undefined'){
            data.put("order", params.order)
        }
        if(params.offset && params.offset!='undefined'){
            data.put("offset", Integer.parseInt(params.offset))
        }else{
            data.put("offset", 0)
        }
        if (params.listBy){

            if(params.group.equals('0')){

                def idList = ''
                if (session.license.isTeacher()){
                    idList = ClusterPermissions.executeQuery("Select distinct c.group.id from ClusterPermissions c where c.user.id = " + session.profile.user.id + " and c.permission > 0").toString()
                    if(idList.contains('[')){
                        idList = idList.replace('[','')
                    }
                    if(idList.contains(']')){
                        idList = idList.replace(']','')
                    }
                    if(idList.isEmpty()){
                        idList = "0"
                    }
                    data.put(Submission.PARAMS_GROUP_ID, idList)
                }else if (session.license.isAdminInst()){
                    data.put(Submission.PARAMS_INSTITUTION_ID,session.license.institution.id)
                }


            }else if ("group".equals(params.listBy)){
                data.put(Submission.PARAMS_GROUP_ID, params.group)
            }
        }
        try{
            Map<String,Object> submissionMap = submissionService.googleWOCount(data)
            def submissionList = submissionMap.get(Submission.FILTER_SUBMISSION_LIST)
            render(contentType:"text/json") {
                submissions = array {
                    submissionList.each {
                        submission id:it.id, userName:it.user.firstName + " "+it.user.lastName,
                                userId:it.user.id,
                                problemName:it.problem.name,
                                problemId:it.problem.id,
                                submissionDate:DATE_FORMAT.format(it.submissionDate),
                                tries:it.tries,
                                language:it.language.name,
                                evaluation:it.evaluation,
                                time:it.time,
                                plagiumStatus:it.plagiumStatus,
                                detailed:it.detailedLog,
                                errorMsg:it.errorMsg
                    }
                }
//                total =  submissionMap.get(Submission.FILTER_SIZE)
            }
        }catch (Exception e){
            log.error(e.getMessage(),e)
        }
    }

    def downloadCodeSubmission = {
        boolean allowed = true
        Submission submissionInstance = Submission.get(params.id)
        def language = submissionInstance.language
        if(language.equals('Python')) {
            language = 'py'
        } else if(language.equals('Octave')) {
            language = 'octave'
        } else {
            language = 'cpp'
        }
        if(session.license.isStudent() && submissionInstance.user.id != session.profile.user.id){
            allowed = false
        }
        if (allowed){
            render(contentType:"text/json") {
                submission submissionCode: submissionInstance.downloadCode().replaceAll('<','&lt'), language:language
            }
        }


    }

    def getStatusSubmission = {
        boolean allowed = true
        Submission submissionInstance = Submission.get(params.sid)
        if(session.license.isStudent() && submissionInstance.user.id != session.profile.user.id){
            allowed = false
        }
        if(allowed){
            render(contentType:"text/json") {
                submission status:submissionInstance.evaluation, problem:submissionInstance.problem.id, dl:submissionInstance.detailedLog, language: submissionInstance.language.id
            }
        }

    }

    def downloadSubmission = {
        int index
        try {
            if (params.id) {
                index = params.id
            } else {
                index = Integer.parseInt(params.bid)
            }
            Submission submissionInstance = Submission.get(index)
            if ((!session.license.isStudent()) || (submissionInstance.user.id == session.profile.user.id)) {
                String name = submissionInstance.generateName()
                File file = submissionInstance.downloadLastSubmission()
                response.setHeader("Content-Type", "application/txt;")
                response.setHeader("Content-Disposition", "attachment;filename=\"" + name + "\"")
                response.setHeader("Content-Length", "${file.size()}")
                response.outputStream << file.newInputStream()
            }
        } catch(e) {
            log.error(e.getMessage(),e)
            redirect(controller:'errors', action:'notFound')
        }

    }

    def showDiff = {
        Submission submissionInstance = Submission.get(Integer.parseInt(params.id))
        def submissionDiff
        def profile = Profile.findByUser(submissionInstance.user);
        if((submissionInstance.user == session.profile.user && submissionInstance.isDetailedLog()) || session.license.isAdmin() || session.license.isAdminInst() || session.license.isTeacher()) {
            submissionDiff = submissionInstance.getDiff()
        }else {
            submissionDiff = "${message(code: "variable.permissionDenied")}"
        }
        return [submissionInstance : submissionInstance, errorLog : submissionDiff, testCase:submissionInstance.inputTestCase, profile: profile]
    }

    def getDiff = {
        Submission submissionInstance = Submission.get(Integer.parseInt(params.id))
        def submissionDiff
        def profile = Profile.findByUser(submissionInstance.user);
        if((submissionInstance.user == session.profile.user && submissionInstance.isDetailedLog()) || session.license.isAdmin() || session.license.isAdminInst() || session.license.isTeacher()) {
            submissionDiff = submissionInstance.getDiff()
        }else {
            submissionDiff = "${message(code: "variable.permissionDenied")}"
        }
        render(contentType:"text/json") {
            submission diff : submissionDiff, input:submissionInstance.inputTestCase

        }
    }

    def reEvaluate = {
        Submission submissionInstance = Submission.get(Integer.parseInt(params.id))
        submissionInstance.evaluation = EvaluationStatus.WAITING
        if(submissionInstance.save()){
            rabbitSend('submission_queue', submissionInstance.id.toString())
            render("ok")
        }
    }

    def reEvaluateFromId = {
        def msg = [status: "fail"]
        try {
            Long initId = Long.parseLong(params.id)
            def s = Submission.list([max:1, order: "desc", sort: "id"])[0], count = 0
            Submission.executeUpdate('update Submission s set s.evaluation = :evaluation where s.id >= :sId', [evaluation: Submission.WAITING, sId: initId])
            for(;initId <= s.id; initId++) {
                rabbitSend('submission_queue', s.id.toString())
                count++
            }
            msg.status = "ok"
            msg.txt = count + " id(s) colocados na fila, de " + params.id + " até " + s.id
        } catch (e) {
            msg.txt = e.message
        }
        render(contentType: "text/json"){
            msg
        }

    }

    def getStatus = {
        def idList = []
        JSON.parse(params.id).each {
            idList.add(it as long)
        }
        def submissionList = Submission.getAll(idList)
        render(contentType: "text/json"){
            submissions = array {
                submissionList.each{
                    submission id:it.id, evaluation:it.evaluation, problemId:it.problem.id
                }
            }
        }

    }

    def listByQuestProblem = {
        QuestionnaireShiroUser questUser = QuestionnaireShiroUser.get(params.id)
        QuestionnaireProblem questProblem = QuestionnaireProblem.get(params.problemId)
        Questionnaire quest = questUser.questionnaire
        def submissionList = Submission.executeQuery("Select s from Submission s where s.user.id = :userId and s.problem.id = :problemId and s.submissionDate <= :endDate ",[userId: questUser.user.id, problemId: questProblem.problem.id, endDate: quest.endDate])
        render(contentType: "text/json"){
            submissions = array {
                submissionList.each{
                    submission id:it.id, tries: it.tries, comment: it.comment? true:false, evaluation:it.evaluation
                }
            }
        }

    }

    def createComment = {
        Submission submission = Submission.get(params.id)
        def msg = [status: 'fail']
        submission.comment = params.comment
        if (submission.save()) {
            msg.status = 'ok'
        }

        render(contentType: "text/json") {
            msg
        }
    }

    def getComment = {
        Submission submission = Submission.get(params.id)
        def msg = [status:submission?'ok':'fail',comment:submission.comment?submission.comment:'', date:submission.submissionDate]

        render(contentType: "text/json") {
            msg
        }
    }

    def reEvaluateAll = {
        def list = Submission.findAll([sort: 'id', order: 'desc', max: 1])
        for (int i = 1; i <= list[0].id; i++) {
            rabbitSend('submission_queue', i as String)
        }
    }
}
