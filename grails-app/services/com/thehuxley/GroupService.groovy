package com.thehuxley

import java.text.SimpleDateFormat

class GroupService {

    public static final SimpleDateFormat GROUP_DATE_FORMAT = new SimpleDateFormat("MM/dd/yyyy");
    public static final SimpleDateFormat DB_GROUP_DATE_FORMAT = new SimpleDateFormat("yyyy/MM/dd");
    public static final String PERIOD_MONTH = "MONTH"
    public static final String PERIOD_DAY = "DAY"
    public static final String PERIOD_WEEK = "WEEK"

    def institutionService

    public ArrayList<Profile> getStudentList(id,sort,order) {
        String query = "Select Distinct p from Profile p where p.user.id in (Select c1.user.id from ClusterPermissions c1 where group.id = " + id + " and permission = 0 )"
        if(sort && order){
            if(sort.equals("topcoder")){
                sort = 'p.user.topCoderPosition'
            }else if(sort.equals("name")){
                sort = 'name'
            }
            if(sort.equals("correct")){
                sort = 'problemsCorrect'
            }
            if(sort.equals("submission")){
                sort = 'submissionCount'
            }
            if(sort.equals("tryed")){
                sort = 'problemsTryed'
            }
            if(sort.equals('topCoderScore')){
                sort = 'p.user.topCoderScore'
            }

            query+= " order by " + sort + " " + order
        }
        ArrayList<Profile> studentList = Profile.executeQuery(query)
        return studentList
    }

    public ArrayList<Profile> getMasterList(id){
        return Profile.executeQuery("Select p from Profile p where p.user.id in (Select user.id from ClusterPermissions where group.id = "+ id+" and permission > 0)")
    }

    public Map searchUser(params){
        def group = params.get("GROUP")
        def max = params.get("MAX")?params.get("MAX"):10
        def offset = params.get("OFFSET")?params.get("OFFSET"):10
        def userList
        def total
        def permission = ""
        if (params.get("PERMISSION")) {
           permission = " and cp.permission = " + params.get("PERMISSION") + " "
        }
        if (params.get("NAME")) {
            userList = Profile.executeQuery("Select cp from ClusterPermissions cp where cp.group.id = :group " + permission + " and cp.user.name like :name order by cp.user.name",[group:group, max:max, offset: offset, name: "%" + params.get("NAME") + "%"])
            total = Profile.executeQuery("Select count(cp) from ClusterPermissions cp where group.id = :group " + permission + " and cp.user.name like :name",[group:group, name: "%" + params.get("NAME") + "%"])[0]
        } else {
            userList = Profile.executeQuery("Select cp from ClusterPermissions cp where cp.group.id = :group " + permission + " order by cp.user.name",[group:group, max:max, offset: offset])
            total = Profile.executeQuery("Select count(cp) from ClusterPermissions cp where group.id = :group" + permission,[group:group])[0]
        }


        HashMap resultMap = new HashMap<String,Object>()
        resultMap.put("TOTAL", total)
        resultMap.put("RESULT", userList)
        return resultMap
    }

    public Map<String,Object> getAccessChart(Map params){
        try{
            //Dados para a tabela de acessos por usuario de um grupo por dia
            String accessQuery = "Select Month(h.date), Day(h.date) , count(Distinct u.id),(Select count(q.id) from Questionnaire q left join q.groups qg where qg.id = "+params.get("id")+" and h.date < q.endDate and h.date > q.startDate), Year(h.date) from ShiroUser u, Historic h where h.user.id = u.id and u.id in (Select cp.user.id from ClusterPermissions cp where cp.group.id = "+params.get("id")+" and permission = 0) and h.action = 'SignIn' "
            if(params.get("endDate")&&!params.get("endDate").isEmpty()){
                accessQuery += " and h.date <= '"+DB_GROUP_DATE_FORMAT.format(GROUP_DATE_FORMAT.parse(params.get("endDate")))+"' "
            }
            if(params.get("startDate")&&!params.get("startDate").isEmpty()){
                accessQuery += " and h.date >= '"+DB_GROUP_DATE_FORMAT.format(GROUP_DATE_FORMAT.parse(params.get("startDate")))+"' "
            }

            accessQuery +=  "group by Year(h.date),Month(h.date)"
            if(params.get("period").equals(PERIOD_DAY)){
                accessQuery +=  ", DAY(h.date)"
            }
            if(params.get("period").equals(PERIOD_WEEK)){
                accessQuery +=  ", Week(h.date)"
            }
            ArrayList<String> categorie = new ArrayList<String>()
            ArrayList<String> accessData = new ArrayList<String>()
            ArrayList<Integer[]> questData = new ArrayList<Integer[]>()
            int lastQuest = 0;
            int lastAccess = 0;
            def dataList = Cluster.executeQuery(accessQuery)
            int totalSize = dataList.size()
            boolean firstTime = true
            dataList.eachWithIndex(){ data,index ->
                categorie.add("'"+data[1] + "/" + data[0]+"/" + data[4]+"'")
                if(firstTime){
                    questData.add([index, data[3]])
                    accessData.add([index, data[2]])
                    firstTime = false
                }else{
                    if(data[3] != lastQuest){
                        questData.add([index - 1, lastQuest])
                        questData.add([index, data[3]])
                        lastQuest = data[3]
                    }else if (index == totalSize-1){
                        questData.add([index, lastQuest])
                    }

                    if(data[2] != lastAccess){
                        accessData.add([index-1, lastAccess])
                        accessData.add([index, data[2]])
                        lastAccess = data[2]
                    }
                    if (index == totalSize-1){
                        if(data[3] == lastQuest){
                            questData.add([index, lastQuest])
                        }
                        if(data[2] == lastAccess){
                            accessData.add([index, lastAccess])
                        }

                    }
                }




            }
            Map<String,Object> resultMap = new HashMap<String, Object>()
            resultMap.put("Categories",categorie)
            resultMap.put("AccessData",accessData)
            resultMap.put("QuestData",questData)
            return resultMap
        }catch (Exception e){
            return null
        }

    }

    public Map<String,Object> getQuestTopicChart(Map params){
        //Dados para a tabela de tentativas por usuario do grupo
        //Problemas que receberam tentivas

        String questQuery = "Select Distinct qs.questionnaire.id  from QuestionnaireStatistics qs left join qs.questionnaire q where qs.group.id = "+params.get("id")+"  "
        if(params.get("endDate")&&!params.get("endDate").isEmpty()){
            questQuery += " and qs.questionnaire.startDate <= '"+DB_GROUP_DATE_FORMAT.format(GROUP_DATE_FORMAT.parse(params.get("endDate")))+"' "
        }
        if(params.get("startDate")&&!params.get("startDate").isEmpty()){
            questQuery +=" and qs.questionnaire.startDate >= '"+DB_GROUP_DATE_FORMAT.format(GROUP_DATE_FORMAT.parse(params.get("startDate")))+"' "
        }
        ArrayList<String> categorie = Questionnaire.executeQuery(questQuery)
        if(!categorie.isEmpty()){
            String questList = "("
            categorie.each{
                questList+= "'"+it + "',"
            }
            questList = questList.substring(0,questList.size() - 1)
            questList += ")"
            String topicQuery = "Select Distinct t.name from QuestionnaireStatistics qs left join qs.questionnaire.questionnaireProblem qp left join qp.problem.topics t where qs.questionnaire.id in "+questList
            String triedQuery = "Select qs.questionnaire, qp.problem, count(Distinct s.user.id) from QuestionnaireStatistics qs left join qs.questionnaire.questionnaireProblem qp, Submission s where qs.questionnaire.id in "+questList+" and s.user.id in (Select cp.user.id from ClusterPermissions cp where cp.group.id = qs.group.id and permission = 0) and s.submissionDate < qs.questionnaire.endDate and s.problem.id = qp.problem.id group by qs, qp "
            String correctQuery = "Select qs.questionnaire, qp.problem, count(Distinct s.user.id) from QuestionnaireStatistics qs left join qs.questionnaire.questionnaireProblem qp, Submission s where qs.questionnaire.id in "+questList+" and s.user.id in (Select cp.user.id from ClusterPermissions cp where cp.group.id = qs.group.id and permission = 0) and s.submissionDate < qs.questionnaire.endDate and s.problem.id = qp.problem.id and s.evaluation = ? group by qs, qp "

            def triedList = Questionnaire.executeQuery(triedQuery)
            def correctList =  Questionnaire.executeQuery(correctQuery,[EvaluationStatus.CORRECT])
            ArrayList<String> topicList = Questionnaire.executeQuery(topicQuery)
            Hashtable<String, Double[]> chartData = new Hashtable<String,Double[]>()

            int instSize = categorie.size()

            topicList.each{
                if(it){
                    chartData.put(it, new double[instSize])
                }
            }
            int questIndex = -1;
            Questionnaire lastQuest = triedList[0][0]
            triedList.eachWithIndex{ qp, index ->
                double value = 0
                if(correctList.size() > index){
                    value = (qp[2]/correctList.get(index)[2])*10
                }
                qp[1].topics.each{ topic->
                    chartData.get(topic.name)[questIndex] = value
                }
                if(!lastQuest.title.equals(qp[0].title)){
                    questIndex++
                    lastQuest = qp[0]
                }
            }

            Map<String,Object> resultMap = new HashMap<String, Object>()
            resultMap.put("Categories",categorie)
            resultMap.put("ChartData",chartData)
            resultMap.put("TopicList",topicList)
            return resultMap

    }else{
            return null
        }
    }

    public Map<String,Object> getQuestChart(Map params){
        try{
            Cluster clusterInstance = Cluster.get(params.get("id"))
            String questQuery = "Select qs from QuestionnaireStatistics qs left join qs.questionnaire q where qs.group.id = "+params.get("id")+"  "
            if(params.get("endDate")&&!params.get("endDate").isEmpty()){
                questQuery += " and q.startDate <= '"+DB_GROUP_DATE_FORMAT.format(GROUP_DATE_FORMAT.parse(params.get("endDate")))+"' "
            }
            if(params.get("startDate")&&!params.get("startDate").isEmpty()){
                questQuery += " and q.startDate >= '"+DB_GROUP_DATE_FORMAT.format(GROUP_DATE_FORMAT.parse(params.get("startDate")))+"' "
            }
            ArrayList<QuestionnaireStatistics> statisticsList = QuestionnaireStatistics.executeQuery(questQuery)
            ArrayList<String> categorie = new ArrayList<String>()
            ArrayList<String> tryed = new ArrayList<String>()
            ArrayList<String> notTryed = new ArrayList<String>()
            statisticsList.each{
                categorie.add(it.questionnaire.title)
                tryed.add(it.tryPercentage * 100)
                notTryed.add((1 - it.tryPercentage) * 100)
            }

            Map<String,Object> resultMap = new HashMap<String, Object>()
            resultMap.put("Categories",categorie)
            resultMap.put("TryData",tryed)
            resultMap.put("NotTryData",notTryed)
            return resultMap
        }catch (Exception e){
            return null
        }


    }

    public Map<String,Object> getSubmissionChart(Map params){
        try{
            //Dados para a tabela de acessos por usuario de um grupo por dia
            String accessQuery = "Select Month(s.submissionDate), Day(s.submissionDate) , count(Distinct u.id),(Select count(q.id) from Questionnaire q left join q.groups qg where qg.id = "+params.get("id")+" and s.submissionDate < q.endDate and s.submissionDate > q.startDate), Year(s.submissionDate) from ShiroUser u, Submission s where s.user.id = u.id and u.id in (Select cp.user.id from ClusterPermissions cp where cp.group.id = "+params.get("id")+" and permission = 0) "
            if(params.get("endDate")&&!params.get("endDate").isEmpty()){
                accessQuery += " and s.submissionDate <= '"+DB_GROUP_DATE_FORMAT.format(GROUP_DATE_FORMAT.parse(params.get("endDate")))+"' "
            }
            if(params.get("startDate")&&!params.get("startDate").isEmpty()){
                accessQuery += " and s.submissionDate >= '"+DB_GROUP_DATE_FORMAT.format(GROUP_DATE_FORMAT.parse(params.get("startDate")))+"' "
            }

            accessQuery +=  "group by Year(s.submissionDate),Month(s.submissionDate)"
            if(params.get("period").equals(PERIOD_DAY)){
                accessQuery +=  ", Day(s.submissionDate)"
            }
            if(params.get("period").equals(PERIOD_WEEK)){
                accessQuery +=  ", Week(s.submissionDate)"
            }
            ArrayList<String> categorie = new ArrayList<String>()
            ArrayList<Integer[]> accessData = new ArrayList<Integer[]>()
            ArrayList<Integer[]> questData = new ArrayList<Integer[]>()
            int lastQuest = 0;
            int lastAccess = 0;
            def dataList = Cluster.executeQuery(accessQuery)
            int totalSize = dataList.size()
            boolean firstTime = true
            dataList.eachWithIndex(){ data,index ->
                categorie.add("'"+data[1] + "/" + data[0]+"/" + data[4]+"'")
                if(firstTime){
                    questData.add([index, data[3]])
                    accessData.add([index, data[2]])
                    firstTime = false
                }else{
                    if(data[3] != lastQuest){
                        questData.add([index - 1, lastQuest])
                        questData.add([index, data[3]])
                        lastQuest = data[3]
                    }else if (index == totalSize-1){
                        questData.add([index, lastQuest])
                    }

                    if(data[2] != lastAccess){
                        accessData.add([index-1, lastAccess])
                        accessData.add([index, data[2]])
                        lastAccess = data[2]
                    }
                    if (index == totalSize-1){
                        if(data[3] == lastQuest){
                            questData.add([index, lastQuest])
                        }
                        if(data[2] == lastAccess){
                            accessData.add([index, lastAccess])
                        }

                    }
                }




            }
            Map<String,Object> resultMap = new HashMap<String, Object>()
            resultMap.put("Categories",categorie)
            resultMap.put("AccessData",accessData)
            resultMap.put("QuestData",questData)
            return resultMap
        }catch(Exception e){
            return null
        }
    }

    def listGroupPosition(position,id){
        ShiroUser user = ShiroUser.get(id)
        List groupList = ClusterPermissions.findAllByUserAndPermission(user, 0).group
        if (!groupList.isEmpty()) {
            groupList =  ClusterPermissions.executeQuery("Select Distinct c.group,count(Distinct c.user.id) from ClusterPermissions c where c.group.id in :groupList and c.permission = 0 and c.user.topCoderPosition <> 0 and c.user.topCoderPosition <= :position group by c.group.id order by c.user.topCoderPosition asc ", [groupList: groupList.id, position: position])
        }
        ClusterPermissions.findAllByUserAndPermission(user, 30).each {
            groupList.add([it.group, 0])
        }

        return groupList
    }

    def getGroupByInstitutionAndNameLike(Institution institution, String name) {
        Cluster.findAllByInstitutionAndNameLike(institution, "%$name%")
    }

    def publicFields(Cluster instance, lazy = false) {
        def result = [
                id: instance.hash,
                name: instance.name,
                description: instance.description,
                dateCreated: instance.dateCreated,
                lastUpdated: instance.lastUpdated
        ]

        if (!lazy) {
            result.putAll([
                institution: institutionService.publicFields(instance.institution, true),
                //users: userService.publicFields(instance.users, true)   //Lazy
            ])
        }

        result
    }

    def publicFields(List<Cluster> list, lazy = false) {

        def result = []

        list.each {
            result.add(publicFields(it, lazy))
        }

        result
    }

}
