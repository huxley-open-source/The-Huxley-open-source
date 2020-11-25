package com.thehuxley

import com.thehuxley.util.HuxleyProperties
import grails.converters.JSON


class  ProblemService {

    public static final String FILTER_PROBLEM_LIST = "PROBLEM_LIST"
    public static final String FILTER_SIZE = "SIZE"

    def memcachedService
    def userProblemService
    def emailService

    def search(params) {
        if (log.isDebugEnabled()){
            log.debug("Searching problems, params: "+params)
        }
        def problemList = memcachedService.get(
                "problems-params:${params}",
                3 * 24 * 60 * 60
        ) {
            def result = []
            def problems = []
            def topics = ""
            String name = params.q ? params.q : ""
            String ndMax = params.ndMax ? params.ndMax : 10
            String ndMin = params.ndMin ? params.ndMin : 0
            int offset = params.offset ? Integer.parseInt(params.offset) : 10
            if (params.topicList && !params.topicList.isEmpty()) {
                topics = " and t.id in (" + params.topicList + ")"
            }
            problems = Problem.executeQuery("select distinct p  from Problem p left join p.topics t where p.name like '%" + name + "%' and p.nd<=" + ndMax + " and p.nd >= " + ndMin + topics + " and status = " + Problem.STATUS_ACCEPTED, [max: 20, offset: offset])
//            problems = Problem.findAllByNameLikeAndNdBetweenAndStatusAndTopicsInList(
//                "%$params.q%",
//                (params.ndMin as double),
//                (params.ndMax as double),
//                Problem.STATUS_ACCEPTED,
//                topics,
//                [max: 20, offset: params.offset]
//            )

            problems.each {
                result.add([id: it.id, name: it.name])
            }

            (result as JSON) as String
        }

        problemList
    }


    def search(params, user) {

        def userProblemCached = userProblemService.getIdsByUserAndStatus(user, UserProblem.CORRECT)

        if (userProblemCached.miss) {
            memcachedService.delete("problems-params:${params}-user:${user.id}")
        }

        def problemList = memcachedService.get(
                "problems-params:${params}-user:${user.id}",
                3 * 24 * 60 * 60
        ) {
            def result = []
            def problems = []
            def resolved = userProblemCached.result
            def topics = ""
            if (params.topicList && !params.topicList.isEmpty()) {
                topics = " and t.id in (" + params.topicList + ")"
            }
            String resolvedList = resolved.toString().replace("]", "")
            resolvedList = resolvedList.toString().replace("[", "")
            if (resolvedList.size() == 0) {
                resolvedList = ""
            } else {
                resolvedList = "and p.id not in ( " + resolvedList + ")"
            }
            problems = Problem.executeQuery("select distinct p  from Problem p left join p.topics t where p.name like '%" + params.q + "%' and p.nd<=" + params.ndMax + topics + " and p.nd >= " + params.ndMin + " and status = " + Problem.STATUS_ACCEPTED + resolvedList, [max: 20, offset: params.offset])

            problems.each {
                result.add([id: it.id, name: it.name])
            }

            (result as JSON) as String
        }

        problemList
    }

    def mountProblemUsageByGroups(problemList, groupList) {
        def Map<Long, Long> results = new HashMap<Long, Long>()
        def list = Problem.executeQuery("Select up.problem.id, count(up.id) from UserProblem up where up.problem.id in (" + problemList + ") and up.user.id in (Select cp.user.id from ClusterPermissions cp where cp.group.id in (" + groupList + ")) and up.status = " + UserProblem.CORRECT + " group by up.problem.id")
        list.each {
            results.put(it[0], it[1])
        }
        return results
    }

    def google(Map params) {
        String nameParam = params.get("nameParam")
        ArrayList<Problem> problemList = new ArrayList<Problem>()
        int ndMax = params.get("ndMax")
        int ndMin = params.get("ndMin")
        String userSuggest = params.get("userNameParam")
        String status = params.get("status")
        String statusWhere = ''
        String userWhere = ''
        String sort = 'p.name'
        String order = 'desc'
        String userSuggestId = ''
        if (params.get("sort") && params.get("order")) {
            sort = params.get("sort")
            order = params.get("order")
        }
        if (params.get("userSuggestId")) {
            userSuggestId = " and p.userSuggest.id = " + params.get("userSuggestId")
        }
        boolean resolved = params.get("resolved")
        if (!params.get("max")) {
            params.put("max", 20)
        }
        if (!params.get("offset")) {
            params.put("offset", 0)
        }
        int userId = params.get("userId")
        int total
        String query = "Select Distinct p from Problem p"
        String name = ""
        //Caso de um nome de usuario ser passado por parametro
        if (userSuggest && userSuggest.length() > 0) {
            userSuggest = userSuggest.replaceAll("'", "''")
            userWhere = " and p.userSuggest.name like '%" + userSuggest + "%'"
        }
        //Caso de um status ser passado por parametro
        if (status && status.length() > 0) {
            statusWhere = " and p.status = " + status
        } else {
            statusWhere = " and p.status = " + Problem.STATUS_ACCEPTED
        }
        //Caso de um nome ser passado como parametro
        if (nameParam != null && nameParam.length() > 0) {
            nameParam = nameParam.replaceAll("'", "''")
            name = " and (p.name like '%" + nameParam + "%' or p.description like '%" + nameParam + "%' or tp.id in (SELECT id FROM Topic t where t.name like '%" + nameParam + "%'))"
        }
        String resolvedQuery = ""
        //Caso de ter que mostrar problemas resolvidos ou não
        if (params.get("resolved") != null && !resolved) {
            resolvedQuery = " and p.id not in (SELECT Distinct up.problem.id FROM UserProblem up where up.user.id = " + userId + " and up.status = 1  )"
        }
        boolean needJoin = (nameParam != null && nameParam.length() > 0) || ((params.get("topics") != null || params.get("topicsRejected") != null))
        String exclusive = ""
        //Caso a busca tenha que retornar um problema com todos os topicos exigidos
        if (params.get("exclusive") != null) {
            exclusive = " group by p.id having count(tp.id) = " + params.get("topicsCount")
        }
        String topic = ""
        String topicsRejected = ""
        //Lista de id's de tópicos
        if (params.get("topics") != null) {
            topic = " and tp.id in " + params.get("topics")
        }
        if (params.get("topicsRejected") != null && !params.get("topicsRejected").isEmpty()) {
            topicsRejected = " and p.id not in (SELECT Distinct p2.id from Problem p2 join p2.topics tp2 where tp2.id in " + params.get("topicsRejected") + ") "
        }
//        try{
//            //Caso o parametro nome seja o code do problema
//            long problemId = Long.parseLong(nameParam)
//            total = 1
//            problemList.add(Problem.findByCodeAndStatus(problemId,Problem.STATUS_ACCEPTED))
//        }catch (Exception e){
        //Caso a tabela de problemas tenha que ser relacionada aos topicos
        if (needJoin) {
            query = "SELECT Distinct p from Problem p join p.topics tp"
        } else {
            query = "SELECT Distinct p FROM Problem p"
        }
        query += " where p.nd >= " + ndMin + " and p.nd <= " + ndMax + resolvedQuery + statusWhere + name + topic + topicsRejected + userSuggestId + exclusive + userWhere + " order by " + sort + " " + order
        problemList = Problem.executeQuery(query, [max: params.get("max"), offset: params.get("offset")])
        total = problemList.size()
        if (total > 0) {
            total = Problem.executeQuery(query.replaceFirst("Distinct p", "count(Distinct p)"))[0]
        }
//        }
        Map<String, Object> table = new Hashtable<String, Object>()
        table.put(FILTER_PROBLEM_LIST, problemList)
        table.put(FILTER_SIZE, total)
        return table
    }

    def generateProblemStatus(problemId, userId) {
        try {
            UserProblem userProblem = UserProblem.findByUserAndProblem(ShiroUser.get(userId), Problem.get(problemId))
            if (userProblem) {
                return userProblem.status
            }
        } catch (e) {

        }
        return UserProblem.NEVER_TRIED

    }

    public Map<String, Object> generateStatus(List<Problem> problemList, long userId) {
        Map<String, Object> table = new Hashtable<String, Object>()
        if (problemList.size() > 0) {
            String idList = "( "
            problemList.each {
                idList += it.id + ", "
            }
            idList = idList.substring(0, idList.lastIndexOf("," - 1))
            idList += ")"
            String queryCorrect = "SELECT Distinct up.problem.id FROM UserProblem up where up.user.id = " + userId + " and up.problem.id in " + idList + " and up.status = " + UserProblem.CORRECT
            List resultCorrectList = UserProblem.executeQuery(queryCorrect)
            String queryTried = "SELECT Distinct up.problem.id FROM UserProblem up where up.user.id = " + userId + " and up.problem.id in " + idList + " and up.status <> " + UserProblem.CORRECT
            List resultTriedList = UserProblem.executeQuery(queryTried)

            problemList.each {
                table.put(it.id, UserProblem.NEVER_TRIED)
            }
            resultTriedList.each {
                table.put(it, UserProblem.TRIED)
            }
            resultCorrectList.each {
                table.put(it, UserProblem.CORRECT)
            }
        }
        return table
    }

    def String mountProblemRoot(problemId) {
        return HuxleyProperties.getInstance().get("problemdb.dir") + problemId + System.getProperty("file.separator");
    }

    public String mountInput(problemId) {
        return HuxleyProperties.getInstance().get("problemdb.dir") + problemId + System.getProperty("file.separator") + HuxleyProperties.getInstance().get("problemdb.inputfile.name");
    }

    public String mountOutput(problemId) {
        return HuxleyProperties.getInstance().get("problemdb.dir") + problemId + System.getProperty("file.separator") + HuxleyProperties.getInstance().get("problemdb.outputfile.name");
    }

    public String mountInputExample(problemId) {
        return HuxleyProperties.getInstance().get("problemdb.dir") + problemId + System.getProperty("file.separator") + HuxleyProperties.getInstance().get("problemdb.example.inputfile.name");
    }

    public String mountOutputExample(problemId) {
        return HuxleyProperties.getInstance().get("problemdb.dir") + problemId + System.getProperty("file.separator") + HuxleyProperties.getInstance().get("problemdb.example.outputfile.name");
    }

    def isCorrect = { problem, user ->

        def userProblemInstance = UserProblem.findByUserAndProblem(user, problem)

        if (userProblemInstance && userProblemInstance.status == UserProblem.CORRECT) {
            return true
        }

        return false
    }

    def getStatus = { problem, user ->

        def userProblemInstance = UserProblem.findByUserAndProblem(user, problem)

        if (userProblemInstance) {
            return userProblemInstance.status
        }

        return -1
    }

    def changeStatus = { problem, user, status ->

        def userProblemInstance = UserProblem.findByUserAndProblem(user, problem)

        userProblemInstance.status = status

        userProblemInstance.save()

    }

    def getProblemContent = { problemId, userId ->

        Problem problemInstance = Problem.get(problemId)

        def topics = problemInstance.topics.name
        def status = generateProblemStatus(problemId, userId)

        Submission userRecordSub = Submission.executeQuery("Select s from Submission s, Problem p where s.user.id=? and p.id=? and s.evaluation = ? and p.id = s.problem.id and s.time > 0 order by s.submissionDate desc",[userId,problemId,EvaluationStatus.CORRECT], [max: 1])[0]
        Submission submissionLast = Submission.findByUserAndProblem(ShiroUser.get(userId), Problem.get(problemId), [order: "desc", sort: "submissionDate"])

//        Map<String, String> solutionState = getReferenceSolutionByUserAndProblem(userId, problemId)

        def record = [:]

        if (problemInstance.fastestSubmision) {
            record = [user: problemInstance.fastestSubmision.user, time: problemInstance.fastestSubmision.time]
        }

        def userRecord

        if (userRecordSub) {
            userRecord = userRecordSub.time
        }

        def lastSubmission

        if (submissionLast) {
            lastSubmission = submissionLast
        }
// TODO remover
//        def referenceList = []
//
//        solutionState.keySet().each {
//            referenceList.add([language: it, state: solutionState.get(it)])
//        }

        return [id: problemInstance.id, name: problemInstance.name, status: status, description: problemInstance.description, level: problemInstance.level, nd: problemInstance.nd, topics: topics, record: record, input: problemInstance.inputFormat, output: problemInstance.outputFormat, userRecord: userRecord, lastSubmission: lastSubmission]
    }

    def getStatusLanguage = { problem, user ->


        HashMap<Language, String> info = new HashMap<Language, String>()
        def languageMap = [:]
        Language.list().each {
            languageMap.put(it.id,it)
        }
        Submission.executeQuery("Select s from Submission s where s.user.id = :userId and s.problem.id = :problemId group by s.language,s.evaluation",[userId:user.id, problemId:problem.id]).each {
            if (!info.get(it.language.id).equals(EvaluationStatus.CORRECT)) {
                info.put(it.language.id, it.evaluation)
            }


        }
        languageMap.keySet().each {
            if (!info.containsKey(it)) {
                info.put(it,null)
            }
        }

        def result = [], name
        info.keySet().each {
            name = languageMap.get(it).name
            if (!name.equals("Python")) {
                if(name == "Python3.2") {
                    name = "Python"
                }
                if (info.get(it) == null) {
                    result.add([id: it, name: name, status: "NULL"])
                } else if (info.get(it).equals(EvaluationStatus.CORRECT)) {
                    result.add([id: it, name: name, status: EvaluationStatus.CORRECT])
                } else {
                    result.add([id: it, name: name, status: EvaluationStatus.WRONG_ANSWER])
                }
            }
        }

        result
    }

	//TODO remover
    public getReferenceSolutionByUserAndProblem(userId, problemId) {
        log.warn("Chamando getReferenceSolutionByUserAndProblem. Esse método não deveria ser mais chamado!!!!")
        ArrayList<Language> allowedList = Submission.executeQuery("Select s.language from Submission s where s.problem.id = ? and s.evaluation = ? and s.user.id = ? group by s.language",[problemId, EvaluationStatus.CORRECT, userId])
        ArrayList<ReferenceSolution> referenceList = ReferenceSolution.findAllByProblem(Problem.get(2))
        Map<String, String> solutionMap = new HashMap<String, String>()
        Language.list().each {
            solutionMap.put(it.name, "Nao Existe")
        }
        allowedList.each {
            solutionMap.put(it.name, "Submeta Uma")
        }
        referenceList.each {
            if (solutionMap.containsKey(it.language.name)) {
                solutionMap.put(it.language.name, "baixe aqui")
            } else {
                solutionMap.put(it.language.name, "sem permissao")
            }
        }
        return solutionMap
    }

    def sendEmailtoUser() {
        Problem.executeQuery("Select p.id from Problem p where p.id not in (select t.problem.id from TestCase t group by problem) and exists(select p.description, p.inputFormat, p.outputFormat, p.fastestSubmision from Problem p)").each() {
            def date = new Date();
            if (it.dateCreated - date == 2 || it.dateCreated - date == 5 || it.dateCreated - date == 7) {
                emailService.sendSimpleEmail("O problema que você cadastrou no thehuxley.com não está finalizado, por favor termine-o.", "Cadastro de problema", ShiroUser.get(it.userSuggestId).email);
            }
        }
    }

    def getRecommendation(userId) {
        /*  Todos os tópicos e a quantidade de questões de cada um.  */
        HashMap<String, Double> result = new HashMap<String, Double>();
        /* Quantidade de questões corretas por tópico. */
        HashMap<String, Double> result2 = new HashMap<String, Double>();

        Topic.executeQuery("Select t from Topic t").each {
            result.put(it.name, it.problems.size())
        }

        result.each{
            result2.put(it.key,0)
        }

        Problem.executeQuery("Select s.problem from Submission s where s.user.id=? and s.evaluation=?",[userId,EvaluationStatus.CORRECT]).each {
            it.topics.each {
                Double value = result2.get(it.name)
                result2.put(it.name, value+1)
            }
        }

        result.each {
            Double value = result.get(it.key)
            result2.put(it.key, (value/it.value) * 100)
        }

        result2 = result2.sort{
            a,b -> a.value <=> b.value
        }

        def counter = 0
        def topic = [];
        result2.each{
            if(it.value!=0 && counter<5){
                topic.add(it.key)
                counter++;
            }
        }

        List list;
        if(topic.size()==0){
            Problem.executeQuery("select distinct p  from Problem p left join p.topics t where t.name="+ "iniciante" + "")
        } else {
            def topicNumber = Math.abs(new Random().nextInt() % 3)

            Double level = ((result.get(topic.get(0)))/10).toInteger()
            list = Problem.executeQuery("select distinct p  from Problem p left join p.topics t where t.name='"+ topic.get(topicNumber) + "' and p.level="+level+"")

            if(list.size()==0) {
                while (list.size()==0) {
                    list = Problem.executeQuery("select distinct p  from Problem p left join p.topics t where t.name='" + topic.get(topicNumber) + "' and p.level=" + level + "")
                    level++
                }
            }
        }
        print list
    }
}
