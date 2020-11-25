package com.thehuxley

import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONObject

import java.text.SimpleDateFormat
import com.thehuxley.util.HuxleyProperties
import java.security.MessageDigest

class ProblemController {

    def problemService
    def submissionService
    def referenceSolutionService
    def memcachedService
    def mongoService
    def emailService
    def reportService

    public static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("HH:mm:ss dd/MM/yyyy");

    def index() {
        [resolved: params.resolved, sMsg: params.sMsg, eMsg: params.eMsg]
    }

    def index2() {}

    def s = {
        def problemListJSON

        if (params.resolved && params.resolved == 'false') {
            problemListJSON = problemService.search(params, session.profile.user)
        } else {
            problemListJSON = problemService.search(params)
        }

        render(contentType: "text/json") {
            JSON.parse(problemListJSON)
        }

    }


    def getProblemInfo = {
        def problemInfo = memcachedService.get("problem-id:$params.id", 30 * 24 * 60 * 60) {
            def problem = Problem.get(params.id)
            def exampleTestCase = TestCase.findByProblemAndType(problem, TestCase.TYPE_EXAMPLE)
            boolean hasExample = exampleTestCase ? true : false
            def result = [
                    code: problem.code,
                    dateCreated: problem.dateCreated,
                    description: problem.description,
                    evaluationDetail: problem.evaluationDetail,
                    id: problem.id,
                    inputFormat: problem.inputFormat,
                    lastUpdated: problem.lastUpdated,
                    lessons: problem.lessons.collect {
                        [id: it.id, title: it.title]
                    },
                    level: problem.level,
                    name: problem.name,
                    nd: problem.nd,
                    outputFormat: problem.outputFormat,
                    questionnaireProblem: problem.questionnaireProblem.collect {
                        def questionnaire = it.questionnaire.collect {
                            [id: it.id, title: it.title]
                        }
                        [id: it.id, questionnaire: questionnaire]
                    },
                    status: problem.status,
                    timeLimit: problem.timeLimit,
                    topics: problem.topics.collect {
                        [id: it.id, name: it.name]
                    },
                    hasExample: hasExample
            ]

            if (problem.fastestSubmision) {
                def fastestSubmissionUserProfile = Profile.findByUser(problem.fastestSubmision.user)
                result.put('fastestSubmission', [
                        id: problem.fastestSubmision.id,
                        time: problem.fastestSubmision.time,
                        user: [
                                hash: fastestSubmissionUserProfile.hash,
                                name: fastestSubmissionUserProfile.name,
                                smallPhoto: fastestSubmissionUserProfile.smallPhoto,
                                topcoderPosition: problem.fastestSubmision.user.topCoderPosition,
                                topCoderScore: problem.fastestSubmision.user.topCoderScore
                        ]
                ])
            }

            if (problem.userSuggest) {
                def userSuggestProfile = Profile.findByUser(problem.userSuggest)
                if (userSuggestProfile) {
                    result.put('userSuggest', [
                            hash: userSuggestProfile.hash,
                            name: userSuggestProfile.name,
                            smallPhoto: userSuggestProfile.smallPhoto,
                            topcoderPosition: problem.userSuggest.topCoderPosition,
                            topCoderScore: problem.userSuggest.topCoderScore
                    ])
                }
            }

            if (problem.userApproved) {
                def userApprovedProfile = Profile.findByUser(problem.userApproved)
                if (userApprovedProfile) {
                    result.put('userApproved', [
                            hash: userApprovedProfile.hash,
                            name: userApprovedProfile.name,
                            smallPhoto: userApprovedProfile.smallPhoto,
                            topcoderPosition: problem.userApproved.topCoderPosition,
                            topCoderScore: problem.userApproved.topCoderScore
                    ])
                }
            }

            (result as JSON) as String
        }

        render(contentType: "text/json") {
            JSON.parse(problemInfo)
        }
    }

    def search = {
        params.userId = session.profile.user.id
        if (params.resolved) {
            params.resolved = params.resolved.equals("true")
        }
        if (params.status && !session.license.isAdmin()) {
            params.userSuggestId = session.profile.user.id
        }
        try {
            params.max = Integer.parseInt(params.max)
        } catch (Exception e) {
            params.max = 20
        }
        try {
            params.levelMax = Integer.parseInt(params.levelMax)
        } catch (Exception e) {
            params.levelMax = 10
        }
        try {
            params.levelMin = Integer.parseInt(params.levelMin)
        } catch (Exception e) {
            params.levelMin = 0
        }
        try {
            params.ndMax = Integer.parseInt(params.ndMax)
        } catch (Exception e) {
            params.ndMax = 10
        }
        try {
            params.ndMin = Integer.parseInt(params.ndMin)
        } catch (Exception e) {
            params.ndMin = 0
        }
        if (!params.topics && (params.topicsCount == "0" || !params.topicsCount)) {
            params.topics = null
            params.topicsCount = null
        } else {
            if (!params.topics) {
                params.exclusive = true
            }
            params.topics = "(" + params.topics + ")"
        }
        if (params.topicsRejected && !params.topicsRejected.isEmpty()) {
            params.topicsRejected = "(" + params.topicsRejected + ")"
        }
        def result = problemService.google(params)
        def problemList = result.get(ProblemService.FILTER_PROBLEM_LIST)
        def problemTotal = result.get(ProblemService.FILTER_SIZE)
        def correct = []
        def tried = []
        def topicTable = new Hashtable<Long, Topic>()
        problemList.each { problem ->
            problem.topics.each {
                if (!topicTable.contains(it.id)) {
                    topicTable.put(it.id, it)
                }
            }
        }

        render(contentType: "text/json") {

            problems = array {
                problemList.each {

                    def info = problemService.getProblemContent(it.id, session.profile.user.id)
                    def recordName
                    def recordTime
                    def recordHash


                    if (info.record.get('user')) {
                        recordName = info.record.get('user').name
                        recordTime = info.record.get('time').toString()
                        recordHash = Profile.findByUser(info.record.get('user')).hash
                    } else {
                        recordName = g.message(code: 'verbosity.problemNeverTried')
                        recordTime = g.message(code: 'verbosity.problemNeverTried')
                        recordHash = g.message(code: 'verbosity.problemNeverTried')

                    }

                    if (info.status == UserProblem.TRIED) {
                        tried.add(it.id)
                    } else if (info.status == UserProblem.CORRECT) {
                        correct.add(it.id)
                    }
                    instance(id: it.id, name: info.name, topics: info.topics, level: info.level, nd: info.nd, userBestTime: info.userRecord, bestTime: recordTime, bestTimeUser: recordName, bestTimeUserHash: recordHash, userSuggest: it.userSuggest.name, dateSuggest: g.formatDate(date: it.dateCreated, format: 'dd MMM yyyy'), userSuggestId: it.userSuggest.id, status: it.status)
                }
            }

            labels(
                    problem: g.message(code: 'problem'),
                    problemTopics: g.message(code: 'problem.topics'),
                    problemLevel: g.message(code: 'problem.level'),
                    problemNd: g.message(code: 'problem.nd'),
                    problemUserBestTime: g.message(code: 'problem.user.best.time'),
                    problemBestTime: g.message(code: 'problem.best.time'),
                    problemLastSubmission: g.message(code: 'problem.last.submission'),
                    problemDescription: g.message(code: 'problem.description'),
                    problemSeeSubmissions: g.message(code: 'problem.see.submissions'),
                    problemSubmit: g.message(code: 'problem.submit'),
                    referenceSolutionLanguage: g.message(code: 'referenceSolution.language'),
                    referenceSolutionState: g.message(code: 'referenceSolution.state'),
                    correct: correct,
                    tried: tried
            )
            total = problemTotal
            topicList = array {
                topicTable.keys().each {
                    topic(id: topicTable.get(it).id, name: topicTable.get(it).name)
                }
            }
        }
    }

    def searchByMongo = {
        if (params.topicsAccepted && !params.topicsAccepted.isEmpty()) {
            params.topics = JSON.parse("[" + params.topicsAccepted + "]")
        }
        if (params.topicsRejected && !params.topicsRejected.isEmpty()) {
            params.nTopics = JSON.parse("[" + params.topicsRejected + "]")
        }
        render(contentType: "text/json") {
            resultSet = mongoService.findProblem(params)
        }

    }


    def getProblemContent = {
        Problem problemInstance = Problem.get(params.id)
        params.userId = session.profile.user.id
        def topics = problemInstance.topics.name
        def status = problemService.generateProblemStatus(problemInstance.id, params.userId)
        Submission userRecordSub = submissionService.getFastestSubmissionByUserAndProblem(params.userId, problemInstance.id)
        Submission submissionLast = submissionService.getLastSubmissionByUserAndProblem(params.userId, problemInstance.id)
        String record = "ninguem conseguiu"
        String userRecord = "Você ainda não acertou, que tal uma tentativa agora?"
        String lastSubmission = "ainda não submeteu"
//        Map<String, String> solutionState = referenceSolutionService.getReferenceSolutionByUserAndProblem(session.profile.user.id, params.id)
        if (problemInstance.fastestSubmision) {
            record = problemInstance.fastestSubmision.user.name + " em " + problemInstance.fastestSubmision.time
        }
        if (userRecordSub) {
            userRecord = userRecordSub.time
        }
        if (submissionLast) {
            lastSubmission = submissionLast
        }


        render(contentType: "application/json") {
            p(id: problemInstance.id, name: problemInstance.name, status: status, description: problemInstance.description,
                    level: problemInstance.level, nd: problemInstance.nd, topics: topics,
                    record: record, input: problemInstance.inputFormat, output: problemInstance.outputFormat, userRecord: userRecord,
                    lastSubmission: lastSubmission)
        }
    }

    def ajxGetProblemContent = {
        def problem
        if (params.id) {
            problem = Problem.get(params.id)
        }
        if (problem) {
            def info = problemService.getProblemContent(problem.id, session.profile.user.id)
            def recordName
            def recordTime
            def recordHash
            def lastSubmission

            if (info.record.get('user')) {
                recordName = info.record.get('user').name
                recordTime = info.record.get('time').toString()
                recordHash = Profile.findByUser(info.record.get('user')).hash
                recordTime = '<a class="userlink" href="/huxley/profile/show/' + recordHash + '">' + recordName + '</a>' + ' ' + g.message(code: "verbosity.resolvedIn") + ' ' + recordTime + "s"
            } else {
                recordName = ""
                recordTime = g.message(code: 'verbosity.anybodyNeverTry')
                recordHash = ""
            }

            lastSubmission = info.lastSubmission ? g.link(action: 'downloadSubmission', controller: 'submission', params: [bid: info.lastSubmission.id], info.lastSubmission.submission) : g.message(code: 'verbosity.youHaveNotSubmitted')


            info.userRecord = info.userRecord ? info.userRecord + 's' : g.message(code: "verbosity.youNeverTry")

            render(contentType: "text/json") {

                p(id: problem.id, name: info.name, topics: info.topics, level: info.level, nd: info.nd, userBestTime: info.userRecord, bestTime: recordTime, bestTimeUser: recordName, bestTimeUserHash: recordHash, lastSubmission: lastSubmission, input: info.input, output: info.output, description: info.description)
                userId = session.profile.user.id

                labels(
                        problemTopics: g.message(code: 'problem.topics'),
                        problemLevel: g.message(code: 'problem.level'),
                        problemNd: g.message(code: 'problem.nd'),
                        problemUserBestTime: g.message(code: 'problem.user.best.time'),
                        problemBestTime: g.message(code: 'problem.best.time'),
                        problemLastSubmission: g.message(code: 'problem.last.submission'),
                        problemDescription: g.message(code: 'problem.description'),
                        problemSeeSubmissions: g.message(code: 'problem.see.submissions'),
                        problemSubmit: g.message(code: 'problem.submit'),
                        referenceSolutionLanguage: g.message(code: 'referenceSolution.language'),
                        referenceSolutionState: g.message(code: 'referenceSolution.state'),
                        problemInputFormat: g.message(code: 'problem.input.format'),
                        problemOutputFormat: g.message(code: 'problem.output.format'),
                        problemInputExample: g.message(code: 'problem.input.example'),
                        problemOutputExample: g.message(code: 'problem.output.example'),
                        problemResolvedIn: g.message(code: 'verbosity.resolvedIn')
                )
            }
        }

    }

    def ajxGetPendingSubmission = {
        ArrayList<Submission> pendingSubmissions = submissionService.getPendingSubmissions(session.profile.user.id)
        ArrayList<Long> problemList = new ArrayList<Long>()
        pendingSubmissions.each {
            if (!problemList.contains(it.problem.id)) {
                problemList.add(it.problem.id)
            }
        }
        render(contentType: "text/json") {
            pendingList pendingProblemList: problemList, pendingSubmissionList: pendingSubmissions.id.toArray()
        }
    }

    def ajxGetSubmissionStatus = {
        def list = JSON.parse(params.subIdList)
        ArrayList<Submission> submissionList = Submission.getAll(JSON.parse(params.subIdList))
        ArrayList<Long> problemList = new ArrayList<Long>()
        ArrayList<Long> problemStatus = new ArrayList<Long>()
        submissionList.each{
            problemList.add(it.problem.id)
            problemStatus.add(it.evaluation)
        }
        render(contentType:"application/json") {
            resultList problemList:problemList, statusList:problemStatus, submissionList:submissionList.id
        }
    }

    def downloadInput = {
        Problem problemInstance = Problem.get(params.id)
        if (problemInstance) {
            def testCase = TestCase.findByProblemAndType(problemInstance, TestCase.TYPE_EXAMPLE)
            if (testCase) {
                String input = testCase.input
                response.setHeader("Content-Type", "application/txt;")
                response.setHeader("Content-Disposition", "attachment;filename=\"" + problemInstance.getName() + ".in\"")
                response.setHeader("Content-Length", "${input.bytes.size()}")
                response.outputStream << input.bytes
            } else {
                render(contentType:"text/json") {
                    msg:[status:'fail', msg:"Exemplo de entrada não encontrado"]
                }
            }

        } else {
            render(contentType:"text/json") {
                msg:[status:'fail', msg:"Problema não encontrado"]
            }
        }

    }

    def downloadOutput = {
        Problem problemInstance = Problem.get(params.id)
        if (problemInstance) {
            def testCase = TestCase.findByProblemAndType(problemInstance, TestCase.TYPE_EXAMPLE)
            if (testCase) {
                String output = testCase.output
                response.setHeader("Content-Type", "application/txt;")
                response.setHeader("Content-Disposition", "attachment;filename=\"" + problemInstance.getName() + ".out\"")
                response.setHeader("Content-Length", "${output.bytes.size()}")
                response.outputStream << output.bytes
            } else {
                render(contentType:"text/json") {
                    msg:[status:'fail', msg:"Exemplo de entrada não encontrado"]
                }
            }

        } else {
            render(contentType:"text/json") {
                msg:[status:'fail', msg:"Problema não encontrado"]
            }
        }
    }

    def listTopics = {
        List topics
        if (!params.nS || params.nS.equals('undefined')) {
            topics = Topic.list(sort: 'name')
        } else {
            topics = Topic.findAllByNameLike("%" + params.nS + "%", [sort: 'name'])
        }
        render(contentType: "text/json") {
            topicList = array {
                topics.each {
                    topic id: it.id, name: it.name
                }
            }
        }
    }

    def selectedIdList = {
        List topics = new ArrayList<Topic>()
        ArrayList<Integer> idList = new ArrayList<String>()
        if (params.idList) {
            StringTokenizer paramToData = new StringTokenizer(params.idList, ",")
            while (paramToData.hasMoreElements()) {
                String nextToken = paramToData.nextToken()
                if (nextToken.matches("[0-9]+")) {
                    idList.add(Long.parseLong(nextToken))
                }
            }
            if (!idList.isEmpty()) {
                topics = Topic.getAll(idList)
            }
            render(contentType: "text/json") {
                topicList = array {
                    topics.each {
                        topic id: it.id, name: it.name
                    }
                }
            }
        }

    }


    def testProblemSelection = {
        [problem: Problem.get(10)]
    }

    def show = {
        def problemInstance = Problem.get(params.id)
        if (problemInstance && (problemInstance.status == Problem.STATUS_ACCEPTED || session.license.isAdmin() || (session.profile.user.id == problemInstance.userSuggest.id))) {
            def info = problemService.getProblemContent(problemInstance.id, session.profile.user.id)
            def totalTestCases = TestCase.findAllByProblem(problemInstance).size();
            def exampleTestCase = TestCase.findByProblemAndType(problemInstance, TestCase.TYPE_EXAMPLE)
            boolean hasExample = exampleTestCase ? true : false
            [problemInstance: problemInstance, info: info, totalTestCases: totalTestCases, sMsg: params.sMsg, eMsg: params.eMsg, hasExample: hasExample, languageStatus: problemService.getStatusLanguage(problemInstance, session.profile.user)]
        } else {
            redirect(controller: "errors", action: "notFound")
        }
    }

    def ajxGetPendingSubmissions = {
        session.sP = Submission.findAllByEvaluationAndUser(EvaluationStatus.WAITING, session.profile.user);
        List submissionsList = session.sP
        render(contentType: "text/json") {
            pendingSubmissions = array {
                submissionsList.each {
                    submission id: it.id, pid: it.problem.id
                }
            }
        }
    }

    def ajxGetProblemStatus = {
        Problem problemInstance = Problem.get(params.pid)
        UserProblem problemStatus = UserProblem.findByUserAndProblem(session.profile.user, problemInstance)
        if (problemStatus) {
            render(contentType: "text/json") {
                problem(pid: problemStatus.problem.id, status: problemStatus.status)
            }
        } else {
            render(contentType: "text/json") {
                problem(pid: 'none', status: 'none')
            }
        }
    }

    def getProblemsStatus = {
        def problemList = []
        JSON.parse(params.problems).each {
            problemList.add(it as long)
        }
        def problems = Problem.getAll(problemList)
        def ShiroUser user = session.profile.user
        def userProblems = UserProblem.findAllByUserAndProblemInList(user, problems);

        render(contentType: 'text/json') {
            status = array {
                userProblems.each {
                    element(problem_id: it.problem.id, status: it.status)
                }
            }
        }
    }

    def showProblem = {
        SimpleDateFormat formater = new SimpleDateFormat("hh:mm dd/MM/yyyy")
        Problem problemInstance = Problem.get(Integer.parseInt(params.id))
        String submission
        if (problemInstance.fastestSubmision != null) {
            def profileFastestSubmission = Profile.findByUser(problemInstance.fastestSubmision.user)
            submission = '<a style="color: #015367;" href="' + resource(dir: '/') + 'profile/index?id=' + profileFastestSubmission.hash + '">' + problemInstance.fastestSubmision.user.getName() + "</a> conseguiu em " + problemInstance.fastestSubmision.time + "s."
        } else {
            submission = "Ninguém acertou ainda, você pode ser o primeiro"
        }
        Submission best = problemInstance.fastestSubmissionByUser(session.profile.user.id)
        Submission lastSubmission = Submission.findByUserAndProblem(session.profile.user, problemInstance, [order: "desc", sort: "submissionDate"])
        String last = "Ainda não Submeteu"
        if (lastSubmission != null) {
            String date = formater.format(lastSubmission.submissionDate)
            date = date.substring(0, date.indexOf(" ")) + " de" + date.substring(date.indexOf(" "))
            last = "<a href=\"" + resource(dir: '/') + "submission/downloadLastSubmission?bid=" + lastSubmission.id + "\"> " + lastSubmission.submission + " </a><span> às " + date + "</span>"
        }
        String bestSubmission = ""
        if (best != null) {
            bestSubmission = "Parabéns você acertou em " + best.time + "s."
        } else {
            bestSubmission = "Você ainda não acertou, que tal uma tentativa agora?"
        }
        ArrayList<String> topics = new ArrayList<String>()
        problemInstance.topics.each {
            topics.add(it.name)
        }
        render(contentType: "text/json") {
            problem name: problemInstance.name, level: problemInstance.level, nd: problemInstance.nd, description: problemInstance.description, record: submission, bestTime: bestSubmission, lastSubmissionDownload: last, topic: topics
        }
    }

    def create = {
        def problemInstance
        def error = false
        def eMsg = ""
        if (params.id) {
            problemInstance = Problem.get(params.id as Long)
            if (!session.license.isAdmin() && problemInstance.userSuggest.id != session.profile.user.id) {
                problemInstance = new Problem()
                problemInstance.level = 1
                problemInstance.timeLimit = 1
            }
        } else if (params.problemInstance) {
            problemInstance = new Problem()
            problemInstance.level = Integer.parseInt(params.level)
            problemInstance.timeLimit = Integer.parseInt(params.timeLimit)
            problemInstance.name = params.name
            problemInstance.source = params.source
            params.topics = params.topics.toString().replace('[', '')
            params.topics = params.topics.replace(']', '')
            problemInstance.topics = Topic.executeQuery("Select Distinct t from Topic t where t.id in (" + params.topics + ")")
            if (params.name.isEmpty()) {
                error = true
                eMsg = message(code: "verbosity.problem.name.empty")
            }
        } else {
            problemInstance = new Problem()
            problemInstance.level = 1
            problemInstance.timeLimit = 1
        }

        return [problemInstance: problemInstance, eMsg: (error ? eMsg : null)]
    }

    def save = {
        Problem problemInstance
        def topics = []
        def canSendEmail = false

        if (params.id) {
            problemInstance = Problem.get(params.id)
            if (!session.license.isAdmin() && problemInstance.userSuggest.id != session.profile.user.id) {
                problemInstance = new Problem()
                problemInstance.description = ""
                problemInstance.inputFormat = ""
                problemInstance.outputFormat = ""
            }
        } else {
            problemInstance = new Problem()
            problemInstance.description = ""
            problemInstance.inputFormat = ""
            problemInstance.outputFormat = ""
            canSendEmail = true
        }

        problemInstance.name = params.name as String
        problemInstance.level = params.difficultLevel as Integer
        if ((!problemInstance.id) || (problemInstance.id && (Submission.executeQuery("Select count(Distinct s.user) from Submission s where problem_id = " + problemInstance.id)[0] <= 10))) {
            problemInstance.nd = params.difficultLevel as Integer
        }

        problemInstance.timeLimit = params.timeLimit as Integer
        if (!problemInstance.userSuggest) {
            problemInstance.userSuggest = session.profile.user
        }
        problemInstance.status = Problem.STATUS_WAITING
        problemInstance.evaluationDetail = 1
        problemInstance.code = Problem.list([order: "desc", sort: "code", max: "1"]).get(0).code + 1
        if (params.source && !params.source.isEmpty()) {
            problemInstance.source = params.source
        } else {
            problemInstance.source = null
        }


        if (params.topicList) {
            StringTokenizer paramToData = new StringTokenizer(params.topicList, ",")
            while (paramToData.hasMoreElements()) {
                topics.add(Topic.get(Long.parseLong(paramToData.nextToken())))
            }
        }

        if (problemInstance.save(flush: true)) {
            memcachedService.delete("problem-id:$problemInstance.id")

            if(canSendEmail){
                String path = createLink(absolute: true, action: "show", controller: "problem", id: problemInstance.id)
                String email = HuxleyProperties.getInstance().get("email.newproblem")
                String msg = "O usuário " + problemInstance.userSuggest.name + " com o email " + problemInstance.userSuggest.email +
                        " criou o problema " + problemInstance.name + " para acessar use o link " + path
                emailService.sendAdminMessage(email, "Administrador", problemInstance.name + " criado", msg)
            }

            if (problemInstance.topics != null) {
                def toDelete = []
                problemInstance.topics.each {
                    if (!topics.contains(it)) {
                        toDelete.add(it)
                    }
                }

                toDelete.each {
                    it.removeFromProblems(problemInstance)
                }
            }

            topics.each {
                it.addToProblems(problemInstance)
            }

            if(problemInstance.description && problemInstance.inputFormat && problemInstance.outputFormat && problemInstance.topics &&
                TestCase.findAllByProblem(problemInstance) && Submission.findAllByProblem(problemInstance) ) {
                    String path = createLink(absolute: true, action: "show", controller: "problem", id: problemInstance.id)
                    String email = HuxleyProperties.getInstance().get("email.newproblem")
                    String msg = "O usuário " + problemInstance.userSuggest.name + " com o email " + problemInstance.userSuggest.email +
                    " completou as informações sobre problema " + problemInstance.name + " para acessar use o link " + path
                    emailService.sendAdminMessage(email, "Administrador", problemInstance.name + " criado", msg)
            }


            if (!params.saveform) {
                redirect action: 'create2', id: problemInstance.id
            } else {
                redirect action: 'show', id: problemInstance.id
            }
        } else {
            redirect(action: 'create', params: [problemInstance: true, name: problemInstance.name, topics: topics.id, level: problemInstance.level, timeLimit: problemInstance.timeLimit, source: problemInstance.source])
        }
    }

    def create2 = {

        def problemInstance

        if (params.id) {
            problemInstance = Problem.get(params.id)
            if (!session.license.isAdmin() && problemInstance.userSuggest.id != session.profile.user.id) {
                redirect action: 'create'
            }
        } else {
            redirect action: 'create'
        }

        [problemInstance: problemInstance]
    }

    def updateDescription = {
        def problemInstance

        if (params.id) {
            problemInstance = Problem.get(Integer.parseInt(params.id))
            if (!session.license.isAdmin() && problemInstance.userSuggest.id != session.profile.user.id) {
                redirect action: 'create'
            }
            problemInstance.description = params.description
            problemInstance.inputFormat = params.inputFormat
            problemInstance.outputFormat = params.outputFormat

            if (problemInstance.save()) {
                memcachedService.delete("problem-id:$problemInstance.id")
                if (params.saveform) {
                    redirect(action: 'show', id: problemInstance.id)
                } else {
                    redirect(action: 'create3', id: problemInstance.id)
                }
            } else {
                redirect(action: 'create2', problemInstance: problemInstance)
            }

        } else {
            redirect action: 'create'
        }
    }

    def create3 = {
        def problemInstance
        def testCaseList = []
        def testCaseIds = []
        if (params.id) {
            problemInstance = Problem.get(params.id)
            if (!session.license.isAdmin() && problemInstance.userSuggest.id != session.profile.user.id) {
                redirect action: 'create'
            }
        } else {
            redirect action: 'create'
        }

        testCaseList = TestCase.findAllByProblem(problemInstance)

        testCaseList.removeAll {
            it.input.size() == 0 && it.output.size() == 0
        }

        testCaseList.each {
            testCaseIds.add(it.id)
        }

        [problemInstance: problemInstance, testCases: testCaseList, testCasesIds: testCaseIds]
    }

    def updateTestCase = {
        def data = JSON.parse(params.testCases)
        def updateList = data.update
        def createList = data.create
        def checkDirty = false
        def testCaseIds = []
        def problemInstance = Problem.get(params.id)

        if (!session.license.isAdmin() && problemInstance.userSuggest.id != session.profile.user.id) {
            redirect action: 'index'
        }

        updateList.each {
            def testCaseInstance = TestCase.get(it.id)
            if (testCaseInstance.problem.id == problemInstance.id) {
                testCaseIds.add(testCaseInstance)
                testCaseInstance.input = it.input
                testCaseInstance.output = it.output
                if (it.example) {
                    testCaseInstance.type = TestCase.TYPE_EXAMPLE
                } else {
                    testCaseInstance.type = TestCase.TYPE_NORMAL
                }
                if (!it.tip.isEmpty()) {
                    testCaseInstance.tip = it.tip
                }
                testCaseInstance.calculateMaxOutputSize()
                testCaseInstance.save()
                checkDirty = true;
            }
        }

        def testCaseList = []
        def removeList = []
        testCaseList = TestCase.findAllByProblem(problemInstance)

        testCaseList.each {
            if (!(it in testCaseIds)) {
                removeList.add(it)
            }
        }

        removeList.each {
            def testCase = TestCase.findById(it.id)
            testCase.delete()
        }

        createList.each {
            def testCaseInstance = new TestCase()
            testCaseInstance.problem = problemInstance
            testCaseInstance.input = it.input
            testCaseInstance.output = it.output
            if (it.example) {
                testCaseInstance.type = TestCase.TYPE_EXAMPLE
            } else {
                testCaseInstance.type = TestCase.TYPE_NORMAL
            }
            if (!it.tip.isEmpty()) {
                testCaseInstance.tip = it.tip
            }
            testCaseInstance.calculateMaxOutputSize()
            testCaseInstance.save()
            checkDirty = true;
        }

        if (checkDirty) {
            problemInstance.version++
            if (problemInstance.save()) {
                memcachedService.delete("problem-id:$problemInstance.id")
            }
        }

        redirect(action: 'show', id: problemInstance.id)

    }

    def topicSave = {
        Topic topicInstance = new Topic()
        topicInstance.name = params.name
        if (topicInstance.save(flush: true)) {
            render(contentType: "text/json") { topic id: topicInstance.id }
        }
    }


    def uploadImage = {
        String imageDir = HuxleyProperties.getInstance().get("image.problem.save.dir") + "temp/"
        def list = []
        try {
            def file = request.getFile('files[]')
            String originalFilename = file.getOriginalFilename()
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."), originalFilename.size())
            MessageDigest md
            md = MessageDigest.getInstance("MD5")
            Long time = System.currentTimeMillis()
            String filename = time.toString() + originalFilename
            BigInteger hash = new BigInteger(1, md.digest(filename.getBytes()))
            filename = hash.toString(16)
            filename += extension
            String filePath = imageDir + filename
            file.transferTo(new File(filePath))
            list = [filename]

            render(contentType: "text/json") {
                array {
                    list.each {
                        upload name: originalFilename, size: 902604, url: HuxleyProperties.getInstance().get("image.problem.dir") + "temp/" + filename, thumbnail_url: HuxleyProperties.getInstance().get("image.problem.dir") + "temp/" + filename, delete_url: "../../images/app/problems/" + filename, delete_type: "DELETE"
                    }
                }
            }
        } catch (exception) {
            render(contentType: "text/json") {
                array {
                    list.each {
                        upload name: originalFilename, size: 902604, url: HuxleyProperties.getInstance().get("image.problem.dir") + "temp/" + filename, thumbnail_url: HuxleyProperties.getInstance().get("image.problem.dir") + "temp/" + filename, delete_url: "../../images/app/problems/" + filename, delete_type: "DELETE"
                    }
                }
            }
        }
    }

    def management = {}

	//TODO remover!!!
    def getProblem = {
        render(contentType: "text/json") {
            [id: 2]
        }
    }

    def changeStatus = {
        def problemInstance = Problem.get(params.id)
        def msg = g.message(code: 'verbosity.changeStatusSuccess')
        def status = params.s as short
        String message = ""
        String path = createLink(absolute: true, action: "show", controller: "problem", id: problemInstance.id)

        if (status == Problem.STATUS_WAITING || status == Problem.STATUS_ACCEPTED || status == Problem.STATUS_REJECTED) {
            problemInstance.status = status
            if (problemInstance.save()) {
                memcachedService.delete("problem-id:$problemInstance.id")
            }
            mongoService.generateProblemList()
            if (status == Problem.STATUS_ACCEPTED) {
                message = "O problema " + problemInstance.name + " foi aceito! </br> Clique <a href= \"" + path + "\">aqui</a> para visualizar"
                emailService.sendAdminMessage(problemInstance.userSuggest.email, problemInstance.userSuggest.name, "Problema Aceito!", message)

            } else if (status == Problem.STATUS_REJECTED) {
                message = "O problema " + problemInstance.name + " foi rejeitado. </br> Clique <a href= \"" + path + "\">aqui</a> para visualizar"
                emailService.sendAdminMessage(problemInstance.userSuggest.email, problemInstance.userSuggest.name, "Problema Rejeitado", message)
            }
        } else {
            msg = g.message(code: 'verbosity.changeStatusFail')
        }



        render(contentType: "text/json") {
            [id: problemInstance.id, status: problemInstance.status, msg: msg]
        }
    }

    def reEvaluate = {
        def submissionReevaluateErrors = new ArrayList<Long>()
        def errMsg = ""
        def returnMsg = ""
        if (params.id) {
            def problemInstance = Problem.get(params.id)
            if (problemInstance) {
                try {
                    def counter = 0
                    def startTime = System.currentTimeMillis()
                    UserProblem.findAllByProblem(problemInstance).each {
                        it.status = UserProblem.TRIED
                        it.save()
                        counter++

                    }
                    def endTime = System.currentTimeMillis()

                    if (log.isDebugEnabled()) {
                        log.debug((endTime - startTime) / 1000.0 + " seconds to update " + counter + " UserProblems")
                    }

                    counter = 0
                    startTime = System.currentTimeMillis()
                    Submission.findAllByProblem(problemInstance).each {
                        it.evaluation = EvaluationStatus.WAITING
                        rabbitSend('submission_queue', it.id.toString())
                        if (!it.save()) {
                            submissionReevaluateErrors.add(it.id)
                        }
                        counter++
                    }
                    endTime = System.currentTimeMillis()

                    if (log.isDebugEnabled()) {
                        log.debug((endTime - startTime) / 1000.0 + " seconds to update " + counter + " Submissions")
                    }

                } catch (Exception e) {
                    log.error(e)
                    errMsg = g.message(code: 'verbosity.reEvaluting.error')
                    redirect(action: 'show', params: [eMsg: errMsg, id: problemInstance.id])
                    return
                }
                returnMsg = g.message(code: 'verbosity.submissions.reEvaluating')
                if (session.license.isAdmin() && !submissionReevaluateErrors.isEmpty()) {
                    returnMsg = g.message(code: 'verbosity.submissions.reEvaluating.with.errors', args: [submissionReevaluateErrors])
                }
                if (log.isDebugEnabled()) {
                    log.debug("exiting ... redirect to show")
                }
                redirect(action: 'show', params: [sMsg: returnMsg, id: problemInstance.id])
                return
            } else {
                errMsg = g.message(code: 'verbosity.not.found', args: [g.message(code: 'entity.problem')])
                redirect(action: 'index', params: [sMsg: errMsg])
                return
            }
        } else {
            errMsg = g.message(code: 'verbosity.not.found', args: [g.message(code: 'entity.problem')])
            redirect(action: 'index', params: [sMsg: errMsg])
            return
        }

    }
    def findUsage = {

        render(contentType:"text/json") {
            problemUsage : problemService.mountProblemUsageByGroups(params.problemList,params.groupList)
        }
    }

    def updateMongoCache = {
        mongoService.generateProblemList()
        redirect(controller: 'home', action: 'index', params: [sMsg: 'Generated'])
    }

    def calculateND = {
        Problem.calculateNd()
        redirect(controller: 'home', action: 'index', params: [sMsg: 'Calculated'])
    }

    def flushMemcached = {
        memcachedService.clear()
        redirect(controller: 'home', action: 'index', params: [sMsg: 'Clear'])
    }

    def management2 = {}

    def getTopicInfo = {
        if (params.idList && !params.idList.isEmpty()) {
            def topicList = Topic.getAll(JSON.parse("[" + params.idList + "]"))
            render(contentType: "text/json") {
                topics = array {
                    topicList.each {
                        def problemList = Topic.executeQuery("Select p from Problem p left join p.topics t where t.id = ?",[it.id])
                        String problemIdList = problemList.id.toString()
                        problemIdList = problemIdList.replace('[','')
                        problemIdList = problemIdList.replace(']','')
                        if(problemList.size() > 0){
                            topic id:it.id,name:it.name,problemCount:problemList.size(),submissionCount:Submission.executeQuery("Select count(s) from Submission s where s.problem.id in (" + problemIdList +")")[0],submissionCorrectCount:Submission.executeQuery("Select count(s) from Submission s where s.problem.id in (" + problemIdList +") and s.evaluation = '" + EvaluationStatus.CORRECT + "'")[0]
                        }else{
                            topic id:it.id,name:it.name,problemCount:0,submissionCount:0,submissionCorrectCount:0
                        }

                    }
                }
            }
        } else {
            render(contentType: "text/json") {
                msg txt: "fail"
            }

        }
    }

    def getProblemInfoByTopic = {
        if (params.id && !params.id.isEmpty()) {
            def problemList = Topic.executeQuery("Select p from Problem p left join p.topics t where t.id = ?" ,[params.id])
            if (problemList.isEmpty()) {
                render(contentType: "text/json") {
                    msg txt: "empty"
                }
            } else {
                render(contentType: "text/json") {
                    problems = array {
                        problemList.each {
                            problemInstance name:it.name,submissionCount:Submission.executeQuery("Select count(s) from Submission s where s.problem.id =" + it.id)[0],submissionCorrectCount:Submission.executeQuery("Select count(s) from Submission s where s.problem.id = " + it.id +" and s.evaluation = '" + EvaluationStatus.CORRECT + "'")[0],testCount:TestCase.countByProblem(it),solutionCount:ReferenceSolution.countByProblemAndStatus(it,ReferenceSolution.STATUS_ACCEPTED),date:DATE_FORMAT.format(it.dateCreated)
                        }
                    }
                    name = Topic.get(params.id).name
                }
            }
        } else {
            render(contentType: "text/json") {
                msg txt: "fail"
            }
        }
    }

    def calculateTestCaseMaxOutputSize = {
        TestCase.list().each {
            it.maxOutputSize = it.calculateMaxOutputSize()
            it.save()
        }
    }

    def getTip = {
        //    def testDiff = '<tr><td width="50%">\n<table id="legend-table">\n    <tr>\n        <td class="modified">Linhas Modificadas:&nbsp;</td>\n        <td class="modified"><a href="#F1_1">1</a>, <a href="#F1_2">2</a></td>\n    </tr>\n    <tr>\n        <td class="added">Linhas adicionadas:&nbsp;</td>\n        <td class="added">None</td>\n    </tr>\n    <tr>\n        <td class="removed">Linhas Removidas:&nbsp;</td>\n        <td class="removed">None</td>\n    </tr>\n    <tr>\n        <th>&nbsp;</th>\n<th width="45%"><strong><big>Resposta Esperada</big></strong></th>\n        <th>&nbsp;</th>\n        <th>&nbsp;</th>\n<th width="45%"><strong><big>Resposta Obtida</big></strong></th>\n    </tr>\n    <tr>\n        <td width="16">&nbsp;</td>\n        <td>\n        3 lines<br/>\n        11 bytes<br/>\n        <hr/>\n        </td>\n        <td width="16">&nbsp;</td>\n        <td width="16">&nbsp; </td>\n        <td>\n        3 lines<br/>\n        13 bytes<br/>\n        <hr/>\n        </td>\n    </tr>\n\n\n    <tr>\n        <td class="linenum"><a name="F1_1">1</a></td>\n        <td class="modified">555</td>\n        <td width="16">&nbsp;</td>\n        <td class="linenum">1</td>\n        <td class="modified">555</td>\n    </tr>\n\n\n    <tr>\n        <td class="linenum"><a name="F1_2">2</a></td>\n        <td class="modified">666</td>\n        <td width="16">&nbsp;</td>\n        <td class="linenum">2</td>\n        <td class="modified">666</td>\n    </tr>\n\n\n    <tr>\n        <td class="linenum">3</td>\n        <td class="normal">777</td>\n        <td width="16">&nbsp;</td>\n        <td class="linenum">3</td>\n        <td class="normal">777</td>\n    </tr>\n\n\n'
        Submission submissionLast
        if (params.sId) {
            submissionLast = Submission.get(params.sId)
        } else {
            submissionLast = submissionService.getLastSubmissionByUserAndProblem(session.license.user.id, params.id)
        }
        Historic historic = new Historic()

        historic.initialize((ShiroUser) session.license.user, "getTip?id=" + submissionLast.problem.id, "Problem")
        def evaluationMsgKey = EvaluationStatus.getMsg(submissionLast.evaluation)
        def evaluationMsg = g.message(code:evaluationMsgKey)
        def evaluationTip = g.message(code:'evaluation.result', args: [evaluationMsg])

        if (submissionLast.isWrongAnswer()) {
            evaluationTip += g.message(code:'evaluation.tip.wrong_answer')
        } else if (submissionLast.isCompilationError()) {
            evaluationTip += g.message(code:'evaluation.tip.compilation_error')
        } else if (submissionLast.isEmptyAnswer()) {
            evaluationTip += g.message(code:'evaluation.tip.empty_answer')
        } else if (submissionLast.isRuntimeError()) {
            evaluationTip += g.message(code:'evaluation.tip.runtime_error')
        } else if (submissionLast.isPresentationError()) {
            evaluationTip += g.message(code:'evaluation.tip.presentation_error')
        } else if (submissionLast.isTimeLimitExceeded()) {
            evaluationTip += g.message(code:'evaluation.tip.time_limit_exceeded')
        } else if (submissionLast.isHuxleyError()) {
            evaluationTip += g.message(code:'evaluation.tip.huxley_error')
            log.error(evaluationTip+ ". Submission: "+submissionLast)
        }
        def testCase
        if (submissionLast.inputTestCase) {
            testCase = TestCase.findByInputAndProblem(submissionLast.inputTestCase, submissionLast.problem)
        }
        def submission = [id: submissionLast.id, evaluation: evaluationTip]
        if (submissionLast.detailedLog && (!submissionLast.isCorrect() && !submissionLast.isCompilationError())) {
            submission.hasDiff = true
            submission.diff = submissionLast.getDiff()
            submission.input = submissionLast.inputTestCase
        }
        if ((!submissionLast.isCorrect() && !submissionLast.isCompilationError()) && testCase && testCase.tip && !testCase.tip.isEmpty()) {
            submission.tip = testCase.id
        }
        if ((submissionLast.errorMsg && !submissionLast.errorMsg.isEmpty())
                && (submissionLast.isCompilationError() || submissionLast.isRuntimeError())) {
            submission.errorMsg = submissionLast.errorMsg
            CommonErrors.list().each {
                if (submission.errorMsg.contains(it.errorMsg)) {
                    submission.commonErrors = submission.commonErrors == null ? "<li style=\"font-size: 12px\">*" + it.comment + "<li>" : submission.commonErrors + "<li style=\"font-size: 12px\">*" + it.comment + "<li>"
                }
            }
        }
        render(contentType: "text/json") {
            submission
        }
    }

    def showTip = {
        def testCase = TestCase.get(params.id)
        Historic historic = new Historic()
        historic.initialize((ShiroUser) session.license.user, "ShowTip/" + testCase.problem.id, "Problem")
        render(contentType: "text/json") {
            submission tip: testCase.tip

        }
    }

    def voteTip = {
        def testCase = TestCase.get(params.id)
        Historic historic = new Historic()
        historic.initialize((ShiroUser) session.license.user, "ShowTip?id=" + testCase.problem.id + "&vote=" + params.vote, "Problem")
        if (params.vote.equals("yes")) {
            testCase.rank = testCase.rank + 1
        } else {
            testCase.unrank = testCase.unrank + 1
        }
        testCase.save()
        render(contentType: "text/json") {
            status = 'ok'
        }
    }

    def getStatusLanguage = {
        render(contentType: "text/json") {
            languageMap = problemService.getStatusLanguage(Problem.get(params.id), session.license.user)
        }
    }

    def report = {
        [report: reportService.test()]

    }

    def sendReports = {
        reportService.sendReports()

    }

    def getRecommendation = {
        problemService.getRecommendation(session.profile.user.id)
    }

}
