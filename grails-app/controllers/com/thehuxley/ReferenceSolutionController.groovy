package com.thehuxley

class ReferenceSolutionController {
    def referenceSolutionService
    def emailService
    def index() { }

    def list = {
        boolean admin = false
        if (session.license.isAdmin()){
            admin = true
        }
        if(!params.order){
            params.order = "desc"
        }
        if(!params.sort){
            params.sort = "submissionDate"
        }
        if(!params.max){
            params.max = 10
        }
        if(!params.offset){
            params.offset = 0
        }
        Map resultMap = referenceSolutionService.listReferenceSolution(params,session.profile.user,admin)
        ArrayList<ReferenceSolution> referenceSolutionList = resultMap.get(referenceSolutionService.REFERENCE_LIST)
        [referenceSolutionList:referenceSolutionList,total:resultMap.get(referenceSolutionService.REFERENCE_LIST_COUNT)]
    }

    def getList = {
        boolean admin = false
        if (session.license.isAdmin()){
            admin = true
        }
        if(!params.order){
            params.order = "desc"
        }
        if(!params.sort){
            params.sort = "submissionDate"
        }
        if(!params.max){
            params.max = 10
        }
        if(!params.offset){
            params.offset = 0
        }
        Map resultMap = referenceSolutionService.listReferenceSolution(params,session.profile.user,admin)
        ArrayList<ReferenceSolution> referenceSolutionList = resultMap.get(referenceSolutionService.REFERENCE_LIST)
        render(contentType:"text/json") {
            referenceList = array{
                referenceSolutionList.each{
                    solution id:it.id, problem:it.problem.name, userSuggest:it.userSuggest.name, language:it.language.name, status:it.status, submissionDate:it.submissionDate.toString()
                }
            }
            total = resultMap.get(referenceSolutionService.REFERENCE_LIST_COUNT)
        }

    }

    def show = {
        def problem
        def language
        ReferenceSolution referenceSolutionInstance
        if(params.id){
            referenceSolutionInstance = ReferenceSolution.get(params.id)
            problem = referenceSolutionInstance.problem
            language = referenceSolutionInstance.language
        }else{
            if (params.probId && params.langId){
                problem = Problem.get(params.probId)
                language = Language.get(params.langId)
            }
            if(params.subId){
                Submission submission = Submission.get(params.subId)
                problem = submission.problem
                language = submission.language
            }

            referenceSolutionInstance = ReferenceSolution.findWhere(problem: problem,language: language, status: ReferenceSolution.STATUS_ACCEPTED)

        }
        if(referenceSolutionInstance){
            boolean submissionCorrect = false
            if(session.license.isStudent()){
                def submission = Submission.findWhere(problem: problem,language: language, evaluation: EvaluationStatus.CORRECT, user: session.profile.user)
                if(submission){
                    submissionCorrect = true;
                }
            }
            if((submissionCorrect||session.license.isAdminInst()||session.license.isTeacher()||session.license.isAdmin())){
                    [justLeft:true,solution: referenceSolutionInstance, code:referenceSolutionInstance.downloadCode().replaceAll('<','&lt')	]
            }else{
                redirect(uri:'/')
                return
            }
        }else{
            redirect(action: "create", params: [id: problem.id, language:language.name])
            return
        }
    }
    def create = {
        [problem:Problem.get(params.id),language: Language.findByName(params.language),justLeft:true]
    }

    def save = {
        Submission submissionInstance = Submission.get(params.id)
        ReferenceSolution referenceSolutionInstance = new ReferenceSolution()
        referenceSolutionInstance.status = 1
        referenceSolutionInstance.problem = submissionInstance.problem
        referenceSolutionInstance.userSuggest = submissionInstance.user
        referenceSolutionInstance.language = submissionInstance.language
        referenceSolutionInstance.submissionDate = new GregorianCalendar().getTime()
        referenceSolutionInstance.referenceSolution = submissionInstance.mountSubmissionPath() + submissionInstance.submission
        referenceSolutionInstance.comment = params.comments
        if (referenceSolutionInstance.save(flush: true)) {
            redirect(action: "compare", id: referenceSolutionInstance.id)
        }
    }

    def compare = {
        boolean admin = true
        ReferenceSolution referenceSolutionInstance = ReferenceSolution.get(params.id)
        if(referenceSolutionInstance.userSuggest.id == session.profile.user.id || admin){
            ReferenceSolution actualReferenceSolution = ReferenceSolution.findWhere(problem:referenceSolutionInstance.problem,language:referenceSolutionInstance.language,status:ReferenceSolution.STATUS_ACCEPTED)
            if(actualReferenceSolution){
                [solution: referenceSolutionInstance, code:referenceSolutionInstance.downloadCode().replaceAll('<','&lt'), actualSolution:actualReferenceSolution,actualCode:actualReferenceSolution.downloadCode().replaceAll('<','&lt'),admin: admin,justLeft:true]
            }else{
                [solution: referenceSolutionInstance, code:referenceSolutionInstance.downloadCode().replaceAll('<','&lt'),admin:admin,justLeft:true]
            }
        }
    }

    def accept = {
        ReferenceSolution referenceSolutionInstance = ReferenceSolution.get(params.id)
        ReferenceSolution.executeUpdate("update ReferenceSolution r set r.status = 3 where r.status = 2 and r.language.id = "+ referenceSolutionInstance.language.id + "and r.problem.id = " + referenceSolutionInstance.problem.id)
        referenceSolutionInstance.status = ReferenceSolution.STATUS_ACCEPTED
        referenceSolutionInstance.userApproved = session.profile.user
        referenceSolutionInstance.save()
        String path = createLink(absolute: true, action: "show", controller: "referenceSolution", id: referenceSolutionInstance.id)
        String message = "Sua solução refência para o problema " + referenceSolutionInstance.problem.name + " foi aceita! </br> Clique <a href= \"" + path + "\">aqui</a> para visualizar"
        emailService.sendAdminMessage(referenceSolutionInstance.userSuggest.email, referenceSolutionInstance.userSuggest.name, "Solução Referência Aceita!", message)
        redirect(action: "show", id: referenceSolutionInstance.id)
    }
    def reject = {
        ReferenceSolution referenceSolutionInstance = ReferenceSolution.get(params.id)
        referenceSolutionInstance.status = ReferenceSolution.STATUS_REJECTED
        referenceSolutionInstance.reply = params.comments
        referenceSolutionInstance.save()
        String path =request.getRequestURL()
        path = createLink(absolute: true, action: "compare", controller: "referenceSolution", id: referenceSolutionInstance.id)
        String rejectMessage = ""
        if(params.comments && params.comments.size() > 0){
            rejectMessage += "Pois: " + params.comments + " </br>"
        }
        String message = "Sua solução refência para o problema "+ referenceSolutionInstance.problem.name + " foi rejeitada. </br> " + rejectMessage + " Clique <a href= \"" + path + "\">aqui</a> para visualizar"
        emailService.sendAdminMessage(referenceSolutionInstance.userSuggest.email, referenceSolutionInstance.userSuggest.name, "Solução Referência Rejeitada", message)
        redirect(action: "compare", id: referenceSolutionInstance.id)
    }
    def updateReferencePath = {
        ReferenceSolution referenceSolutionInstance = ReferenceSolution.get(params.id)
        ReferenceSolution.findAllWhere(status: "ACCEPTED", problem:referenceSolutionInstance.problem,language:referenceSolutionInstance.language).each{
            it.status = ReferenceSolution.STATUS_REJECTED
            it.save()
        }
        referenceSolutionInstance.status = ReferenceSolution.STATUS_ACCEPTED
        referenceSolutionInstance.save()
    }

    def listByProblem = {
        ShiroUser user = License.get(session.license.id).user
        Problem problem = Problem.get(params.id)
        ArrayList<ReferenceSolution> availableList = ReferenceSolution.findAllByProblemAndStatus(problem, ReferenceSolution.STATUS_ACCEPTED)
        ArrayList<Language> notAvailable = new ArrayList<Language>()
        String queryCorrectLanguageList = "SELECT Distinct s.language.name FROM Submission s WHERE s.user.id= ? and s.problem.id = ? and s.evaluation = ?"
        ArrayList<String> correctLanguages = Language.executeQuery(queryCorrectLanguageList,[session.license.user.id, params.id, EvaluationStatus.CORRECT])
        if(availableList.size()){
            notAvailable = Language.findAllByNameNotInList(availableList.language.name)
        }else{
            notAvailable = Language.list()
        }
        render(contentType:"text/json") {
            referenceList = array{
                availableList.each{
                    if((user.id == problem.userSuggest.id) || (session.license.isAdmin()) ||(correctLanguages.contains(it.language.name))){
                        solution id:it.id, language:it.language.name
                    }else{
                        solution id:0, language:it.language.name
                    }
                }
            }
            notAvaiableList = array {
                notAvailable.each{
                    if((user.id == problem.userSuggest.id) || (session.license.isAdmin()) ||(correctLanguages.contains(it.name))){
                        language name:it.name, status : "ok"
                    }else{
                        language name:it.name, status : "notOk"
                    }
                }
            }
        }
    }

}