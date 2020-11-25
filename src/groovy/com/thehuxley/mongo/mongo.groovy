package com.thehuxley.mongo

/**
 * Created with IntelliJ IDEA.
 * User: MRomero
 * Date: 23/01/13
 * Time: 14:40
 * To change this template use File | Settings | File Templates.
 */

import com.mongodb.*
import com.thehuxley.Cluster
import com.thehuxley.Problem
import com.thehuxley.Questionnaire
import com.thehuxley.ShiroUser
import com.thehuxley.Submission
import com.thehuxley.UserProblem
import com.thehuxley.container.forum.ForumProblemReportContainer
import com.thehuxley.stimulusPredictor.StimulusPredictor
import grails.converters.JSON
import com.thehuxley.container.forum.ForumContainer
import com.thehuxley.container.forum.ForumMessage
import com.thehuxley.container.forum.ForumSubmissionContainer
import com.thehuxley.container.forum.UserStatus
import org.bson.types.ObjectId

class Mongo {
    public static MongoClient mongoClient;
    private static DB getDB(String dbName){
        if(!mongoClient){
            mongoClient = new MongoClient( "localhost" , 27017 );
        }
        DB db = mongoClient.getDB(dbName);
        return db
    }

    public static generateProblemList(){
        DB db = getDB( "problemListQuestionnaireCreate2" );
        DBCollection coll = db.getCollection("problem")
        coll.remove(new BasicDBObject())
        Problem.findAllByStatus(Problem.STATUS_ACCEPTED).each{ problem ->
            BasicDBObject problemToInsert = new BasicDBObject("id", problem.id.toString()).
                    append("name", problem.name).
                    append("nd", problem.nd)
            BasicDBList topics = new BasicDBList()
            problem.topics.each{
                BasicDBObject topic = new BasicDBObject();
                topic.append("name",it.name)
                topic.append("id",it.id)
                topics.add(topic)
            }
            problemToInsert.append("topic",topics)
        coll.insert(problemToInsert)
        }
    }

    public static generateGroupCountByProblem(groupId){
        DB db = getDB( "problemListQuestionnaireCreate2" );
        DBCollection coll = db.getCollection("problem")
        BasicDBObject group = new BasicDBObject('group.id',groupId)
        boolean contains = false
        if (coll.find(group).limit(1).count() > 0){
            contains = true
        }
        UserProblem.executeQuery("Select p.id, (Select count(up) from UserProblem up where up.user.id in (Select cp.user.id from ClusterPermissions cp where cp.group.id = " + groupId + " and cp.permission = 0 ) and up.problem.id = p.id group by up.problem.id) from Problem p where p.status = '" + Problem.STATUS_ACCEPTED + "'" ).each{
            def count = it[1]
            if (count == null){
                count = 0
            }
            if (contains){
                BasicDBObject findDocument = new BasicDBObject('id': it[0].toString()).append("group",
                        new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',groupId)));
                coll.update(findDocument,new BasicDBObject('\$set',new BasicDBObject('group.$.count',count)))
            }else{
                BasicDBObject newDocument = new BasicDBObject().append("\$addToSet",
                        new BasicDBObject().append("group", new BasicDBObject().append('id',groupId).append('count',count)));
                coll.update(new BasicDBObject('id',it[0].toString()),newDocument)
            }

        }
    }

    public static ArrayList<Object> findProblem(params){
        DB db = getDB( "problemListQuestionnaireCreate2" );
        DBCollection coll = db.getCollection("problem")
        def ndMin = 1
        def ndMax= 10
        BasicDBObject query = new BasicDBObject()

        if (params.containsKey("ndMin")){
            ndMin = Integer.parseInt(params.get("ndMin"))
        }
        if (params.containsKey("ndMax")){
            ndMax = Integer.parseInt(params.get("ndMax"))
        }
        BasicDBObject ndQ = new BasicDBObject()
        ndQ.append('\$gte',ndMin).append('\$lte',ndMax)
        query.append('nd', ndQ)
        if (params.containsKey('name')){
            def name = params.get('name')
            name = '.*(?i)' + name + '.*'
            def regex = ~name
            assert 'java.util.regex.Pattern' == regex.class.name
            query.append('name',regex)
        }
        if (params.containsKey('topics')){
            if (params.containsKey('nTopics')){
                BasicDBObject topics = new BasicDBObject('\$in',params.get('topics'))
                topics.append('\$nin',params.get('nTopics'))
                query.append('topic.id',topics)
            }else{
                query.append('topic.id',new BasicDBObject('\$in',params.get('topics')))
            }

        }else if (params.containsKey('nTopics')){
            query.append('topic.id',new BasicDBObject('\$nin',params.get('nTopics')))
        }
        ArrayList<Object> result = new ArrayList<Object>()
        coll.find(query).sort( new BasicDBObject('group.count',1) ).each{
            result.add(JSON.parse(it.toString()))
        }
        return result
    }

    public static generateQuestionnairePlagiumList(){
        MongoClient mongoClient = new MongoClient( "localhost" , 27017 )
        DB db = mongoClient.getDB( "questionnairePlagiumList" )
        DBCollection coll = db.getCollection("questionnaire")
        Date today = new GregorianCalendar().getTime()
        Questionnaire.list().each{ quest ->
            try{
                def problemList = ''
                if(quest.endDate > today || coll.find(new BasicDBObject('id',quest.id)).size() == 0){
                    quest.questionnaireProblem.each{
                        problemList += "," + it.problem.id
                    }
                    if(!problemList.isEmpty()){
                        problemList = problemList.replaceFirst(',','')
                    }
                    BasicDBObject questionnaire = new BasicDBObject()
                    questionnaire.append('id',quest.id).append('title',quest.title).append('score',quest.score)
                    BasicDBList groups = new BasicDBList()
                    quest.groups.each{ group->
                        BasicDBList questGroup = new BasicDBList()
                        def list = Questionnaire.executeQuery("Select distinct q from QuestionnaireShiroUser q where q.user.id in (Select Distinct user.id from ClusterPermissions where group.id = '" + group.id + "' and permission = 0) and q.questionnaire.id = " + quest.id)
                        int status = 0;
                        list.each {
                            if(!Submission.executeQuery("Select s from Submission s where user.id = " + it.user.id + " and s.plagiumStatus = " + Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM + " and s.submissionDate < '" + quest.endDate + "' and s.problem.id in (" + problemList + ")",[max:1]).isEmpty()){
                                status = 2
                            }else if(!Submission.executeQuery("Select s from Submission s where user.id = " + it.user.id + " and s.plagiumStatus = " + Submission.PLAGIUM_STATUS_MATCHED + " and s.submissionDate < '" + quest.endDate + "' and s.problem.id in (" + problemList + ")",[max:1]).isEmpty()){
                                status = 1
                            }else{
                                status = 0
                            }
                            BasicDBObject questionnaireUser = new BasicDBObject()
                            questionnaireUser.append('id',it.id).append('status',status).append('name',it.user.name).append('score',it.score)
                            questGroup.add(questionnaireUser)
                        }
                        BasicDBObject groupToAppend = new BasicDBObject()
                        groupToAppend.append('id',group.id).append('hashId',group.hash).append('institution',group.institution.id)
                        groupToAppend.append('questList',questGroup)
                        groups.add(groupToAppend)
                    }
                    questionnaire.append('group',groups)
                    coll.remove(new BasicDBObject('id',quest.id))
                    coll.insert(questionnaire)
                }
            }catch (e){

            }

        }
    }
    public static ArrayList<Object> findByQuestionnaireAndGroup(questionnaireId,groupHash){
        MongoClient mongoClient = new MongoClient( "localhost" , 27017 )
        DB db = mongoClient.getDB( "questionnairePlagiumList" )
        DBCollection coll = db.getCollection("questionnaire")
        BasicDBObject query = new BasicDBObject()
        query.append('id',Long.parseLong(questionnaireId))
        query.append('group.hashId',groupHash)
        ArrayList<Object> results = new ArrayList<Object>()
        coll.find(query).each{
            def questionnaire = JSON.parse(it.toString())
            questionnaire.group.each{ groupInList->
                if (groupInList.hashId.equals(groupHash)){
                    groupInList.questList.each{
                        results.add(it)
                    }
                }
            }

        }
        return results
    }

    public static runStimulusPredicator(){
        try {
            MongoClient mongoClient = new MongoClient( "localhost" , 27017 )
            DB db = mongoClient.getDB( "stimulusPredictor" )
            DBCollection coll = db.getCollection("groups")
            Cluster.list().each{
                int questNumber = Questionnaire.executeQuery("select count(Distinct q.id) from Questionnaire q left join q.groups g where g.id = " + it.id)[0]
                if(questNumber > 0){
                    BasicDBObject query = new BasicDBObject()
                    query.append('id',it.id)
                    if (coll.find(query).count() == 0){
                        Map group = StimulusPredictor.runPredict(it.id)
                        group.put("ID",it.id)
                        persistStimulusPredicatorGroup(group)
                    }else if (coll.find(query).next().nQuest != questNumber){
                        coll.remove(query)
                        Map group = StimulusPredictor.runPredict(it.id)
                        group.put("ID",it.id)
                        persistStimulusPredicatorGroup(group)
                    }
                }
            }
        }catch (e){

        }

    }

    public static persistStimulusPredicatorGroup(Map groupMap){
        DB db = getDB( "stimulusPredictor" );
        DBCollection coll = db.getCollection("groups")
        BasicDBObject groupToInsert = new BasicDBObject("id", groupMap.get("ID")).append("nQuest" , groupMap.get("N_QUEST"))
        BasicDBList users = new BasicDBList()
        ArrayList<Double> userList = groupMap.get("USER_LIST")
        ArrayList<Double> resultList = groupMap.get("RESULT")
        for(int i = 0; i < userList.size(); i++){
                BasicDBObject user = new BasicDBObject();
                user.append("id",userList.get(i))
                user.append("status",resultList.get(i))
                users.add(user)
            }
            groupToInsert.append("userList",users)
            coll.insert(groupToInsert)
    }

    public static Map findStimulusPredicatorGroup(long groupId){
        DB db = getDB( "stimulusPredictor" )
        DBCollection coll = db.getCollection("groups")
        int questNumber = Questionnaire.executeQuery("select count(Distinct q.id) from Questionnaire q left join q.groups g where g.id = " + groupId)[0]
        if(questNumber > 0){
            BasicDBObject query = new BasicDBObject()
            query.append('id',groupId)
            HashMap<String,String> results = new HashMap<String,String>()
            if (coll.find(query).hasNext()){
                coll.find(query).next().userList.each{
                    results.put(it.id.toString(),it.status.toString())
                }
                return results
            }
        }
        return null

    }

    public static boolean createForumSubmission(long userId, String msg, Date dateCreated, long submissionId){
        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum")
        BasicDBObject query = new BasicDBObject("submissionId", submissionId)
        //Verifica se já existe um Forum criado
        if (coll.find(query).count() == 0){
            //Caso tenha sido um aluno que criou o forum, todos os professores das turmas que ele pertence serão notificados
            def userIdList = ShiroUser.executeQuery("Select user.id from ClusterPermissions cp where cp.group.id in (Select Distinct cp2.group.id from ClusterPermissions cp2 where cp2.user.id = " + userId + ") and cp.permission > 0")

            BasicDBObject forumToInsert = new BasicDBObject("submissionId", submissionId).append("lastUpdated" , dateCreated)
            //Adiciona a lista de professores do aluno a lista de interessados
            BasicDBList userList = new BasicDBList()
            userIdList.each{
                if(it != userId){
                    BasicDBObject user = new BasicDBObject();
                    user.append("id",(long) it)
                    user.append("status",0)
                    userList.add(user)
                }

            }
            //Adiciona quem criou o forum a lista de interessados
            BasicDBObject user = new BasicDBObject();
            user.append("id",userId)
            user.append("status",1)
            userList.add(user)
            //Se nao foi o aluno que criou a submissão, ele tem que ser adicionado a lista de interessados
            Submission submissionInstance = Submission.get(submissionId)
            if (userId != submissionInstance.user.id){
                BasicDBObject subUser = new BasicDBObject();
                subUser.append("id",submissionInstance.user.id)
                subUser.append("status",0)
                userList.add(user)
            }
            forumToInsert.append("userList",userList)
            //Adiciona a mensagem para a lista de mensagens do forum
            BasicDBList messageList = new BasicDBList()
            BasicDBObject msgInstance = new BasicDBObject();
            msgInstance.append("id",userId)
            msgInstance.append("message",msg)
            msgInstance.append("dateCreated",dateCreated)
            messageList.add(msgInstance)
            forumToInsert.append("messageList",messageList)
            coll.insert(forumToInsert)
           return true
        }else{
            return false
        }

    }

    public static boolean insertForumSubmissionMessage(long userId, String msg, Date dateCreated, long submissionId){
        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum")
        BasicDBObject query = new BasicDBObject("submissionId", submissionId)

        BasicDBObject msgInstance = new BasicDBObject();
        msgInstance.append("id",userId)
        msgInstance.append("message",msg)
        msgInstance.append("dateCreated",dateCreated)
        if (coll.find(query).count() == 1){
            //Update date
            BasicDBObject updateObject = new BasicDBObject('\$set',new BasicDBObject('lastUpdated',dateCreated))
            //Update MessageList
            updateObject.append('\$push',new BasicDBObject('messageList',msgInstance))
            //Confere se o usuario esta na lista de interessados
            BasicDBObject findDocument = new BasicDBObject('submissionId': submissionId).append("userList",
                    new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId)));
            if (coll.find(findDocument).count() == 0){
                BasicDBObject user = new BasicDBObject();
                user.append("id",userId)
                user.append("status",1)
                updateObject.append('\$push',new BasicDBObject('userList',user))
            }
            //Update UserList
            updateForumSubmissionStatus(userId,submissionId,1)
            BasicDBObject userQuery = new BasicDBObject("submissionId",submissionId)
            BasicDBObject userRestrictQuery = new BasicDBObject("userList",1)
            def userListToUpdate =  coll.find(userQuery,userRestrictQuery).next()
            userListToUpdate.userList.each{
                long nId = it.id
                if(nId != userId){
                    updateForumSubmissionStatus(nId,submissionId,0)
                }
            }
            coll.update(query,updateObject)
            return true
        }else{
            return createForumSubmission(userId,msg, dateCreated, submissionId)
        }

    }

    public static boolean createForumProblemReport(long userId, String msg, Date dateCreated, long problemId){
        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum")
        BasicDBObject query = new BasicDBObject("problemId", problemId)
        Problem problem = Problem.get(problemId)
        //Verifica se já existe um Forum criado
        if (coll.find(query).count() == 0){
            //Lista de ids com o id de quem criou e dos admin gerais
            def userIdList = new ArrayList<Long>()
            if (problem.userSuggest.id != 1){
                userIdList.add(problem.userSuggest.id)
            }
            if (problem.userApproved && problem.userApproved.id != 1){
                    userIdList.add(problem.userApproved.id)
            }
            userIdList.add(1)

            BasicDBObject forumToInsert = new BasicDBObject("problemId", problemId).append("lastUpdated" , dateCreated)
            //Adiciona a lista de interessados
            BasicDBList userList = new BasicDBList()
            userIdList.each{
                if(it != userId){
                    BasicDBObject user = new BasicDBObject();
                    user.append("id",(long) it)
                    user.append("status",0)
                    userList.add(user)
                }

            }
            BasicDBObject subUser = new BasicDBObject();
            subUser.append("id",userId)
            subUser.append("status",0)
            userList.add(subUser)
            forumToInsert.append("userList",userList)
            //Adiciona a mensagem para a lista de mensagens do forum
            BasicDBList messageList = new BasicDBList()
            BasicDBObject msgInstance = new BasicDBObject();
            msgInstance.append("id",userId)
            msgInstance.append("message",msg)
            msgInstance.append("dateCreated",dateCreated)
            messageList.add(msgInstance)
            forumToInsert.append("messageList",messageList)
            coll.insert(forumToInsert)
            return true
        }else{
            return false
        }

    }

    public static boolean insertForumProblemReport(long userId, String msg, Date dateCreated, long problemId){
        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum")
        BasicDBObject query = new BasicDBObject("problemId", problemId)

        BasicDBObject msgInstance = new BasicDBObject();
        msgInstance.append("id",userId)
        msgInstance.append("message",msg)
        msgInstance.append("dateCreated",dateCreated)
        if (coll.find(query).count() == 1){
            //Update date
            BasicDBObject updateObject = new BasicDBObject('\$set',new BasicDBObject('lastUpdated',dateCreated))
            //Update MessageList
            updateObject.append('\$push',new BasicDBObject('messageList',msgInstance))
            //Confere se o usuario esta na lista de interessados
            BasicDBObject findDocument = new BasicDBObject('problemId': problemId).append("userList",
                    new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId)));
            if (coll.find(findDocument).count() == 0){
                BasicDBObject user = new BasicDBObject();
                user.append("id",userId)
                user.append("status",1)
                updateObject.append('\$push',new BasicDBObject('userList',user))
            }
            //Update UserList
            updateForumProblemReportStatus(userId,problemId,1)
            BasicDBObject userQuery = new BasicDBObject("problemId",problemId)
            BasicDBObject userRestrictQuery = new BasicDBObject("userList",1)
            def userListToUpdate =  coll.find(userQuery,userRestrictQuery).next()
            userListToUpdate.userList.each{
                long nId = it.id
                if(nId != userId){
                    updateForumProblemReportStatus(nId,problemId,0)
                }
            }
            coll.update(query,updateObject)
            return true
        }else{
            return createForumProblemReport(userId,msg, dateCreated, problemId)
        }

    }

    public static boolean insertForumMessage(long userId, String msg, Date dateCreated, String forumId){

        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum")
        BasicDBObject query = new BasicDBObject("_id", new ObjectId(forumId))

        BasicDBObject msgInstance = new BasicDBObject();
        msgInstance.append("id",userId)
        msgInstance.append("message",msg)
        msgInstance.append("dateCreated",dateCreated)
        if (coll.find(query).count() == 1){
            //Update date
            BasicDBObject updateObject = new BasicDBObject('\$set',new BasicDBObject('lastUpdated',dateCreated))
            //Update MessageList
            updateObject.append('\$push',new BasicDBObject('messageList',msgInstance))
            //Confere se o usuario esta na lista de interessados
            BasicDBObject findDocument = new BasicDBObject('_id': new ObjectId(forumId)).append("userList",
                    new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId)));
            if (coll.find(findDocument).count() == 0){
                BasicDBObject user = new BasicDBObject();
                user.append("id",userId)
                user.append("status",1)
                updateObject.append('\$push',new BasicDBObject('userList',user))
            }
            //Update UserList
            updateForumStatus(userId,forumId,1)
            BasicDBObject userQuery = new BasicDBObject("_id", new ObjectId(forumId))
            BasicDBObject userRestrictQuery = new BasicDBObject("userList",1)
            def userListToUpdate =  coll.find(userQuery,userRestrictQuery).next()
            userListToUpdate.userList.each{
                long nId = it.id
                if(nId != userId){
                    updateForumStatus(nId,forumId,0)
                }
            }
            coll.update(query,updateObject)
            return true
        }else{
            return false
        }

    }

    public static updateForumSubmissionStatus(long userId, long submissionId, int status){
        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum");
        BasicDBObject findDocument = new BasicDBObject('submissionId': submissionId).append("userList",
                new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId)));
        coll.update(findDocument,new BasicDBObject('\$set',new BasicDBObject('userList.$.status',status)))
    }

    public static updateForumProblemReportStatus(long userId, long problemId, int status){
        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum");
        BasicDBObject findDocument = new BasicDBObject('problemId': problemId).append("userList",
                new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId)));
        coll.update(findDocument,new BasicDBObject('\$set',new BasicDBObject('userList.$.status',status)))
    }

    public static boolean updateForumStatus(long userId, String forumId, int status){
        try{
            DB db = getDB('forum')
            DBCollection coll = db.getCollection("forum");
            BasicDBObject findDocument = new BasicDBObject('_id': new ObjectId(forumId)).append("userList",
                    new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId)));
            coll.update(findDocument,new BasicDBObject('\$set',new BasicDBObject('userList.$.status',status)))
        }catch(e){
            return false
        }
        return true
    }

    public static ArrayList<ForumContainer> getForumList(long userId, int offset, int max){
        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum");
        BasicDBObject findDocument = new BasicDBObject("userList",
                new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId)));
        ArrayList<ForumContainer> forumList = new ArrayList<ForumContainer>()
        coll.find(findDocument).skip(offset).limit(max).sort(new BasicDBObject('lastUpdated',-1)).each{ forumInList ->

            ForumContainer forum
            ArrayList<ForumMessage> messageList = new ArrayList<ForumMessage>()
            forumInList.messageList.each{ messageInList ->
                ForumMessage message = new ForumMessage(ShiroUser.get(messageInList.id),messageInList.message,messageInList.dateCreated)
                messageList.add(message)
            }
            ArrayList<UserStatus> userList = new ArrayList<UserStatus>()
            forumInList.userList.each{ userInList ->
                UserStatus user = new UserStatus(ShiroUser.get(userInList.id), userInList.status)
                userList.add(user)
            }
            if (forumInList.submissionId){
                forum = new ForumSubmissionContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList,Submission.get(forumInList.submissionId))
            }else if (forumInList.problemId){
                forum = new ForumProblemReportContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList,Problem.get(forumInList.problemId))
            }else{
                forum = new ForumContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList)
            }
            forumList.add(forum)
        }

        return forumList
    }

    public static int getForumUnreadCount(long userId){
        int result = -1
        try {
            DB db = getDB('forum')
            DBCollection coll = db.getCollection("forum");
            BasicDBObject findDocument = new BasicDBObject("userList",
                    new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId).append('status',UserStatus.STATUS_UNREAD)));
            result = coll.find(findDocument).count();
        }catch (Exception e){
            println e
        }

        return result
    }

    public static ArrayList<ForumContainer> getForumWithPriority(long userId, int offset, int max){
        try {
            DB db = getDB('forum')
            DBCollection coll = db.getCollection("forum");
            ArrayList<ForumContainer> forumList = new ArrayList<ForumContainer>()
            BasicDBObject findUnreadForum = new BasicDBObject("userList",
                    new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId).append('status',UserStatus.STATUS_UNREAD)));

            coll.find(findUnreadForum).skip(offset).limit(max).sort(new BasicDBObject('lastUpdated',-1)).each{ forumInList ->

                ForumContainer forum
                ArrayList<ForumMessage> messageList = new ArrayList<ForumMessage>()
                forumInList.messageList.each{ messageInList ->
                    ForumMessage message = new ForumMessage(ShiroUser.get(messageInList.id),messageInList.message,messageInList.dateCreated)
                    messageList.add(message)
                }
                ArrayList<UserStatus> userList = new ArrayList<UserStatus>()
                forumInList.userList.each{ userInList ->
                    UserStatus user = new UserStatus(ShiroUser.get(userInList.id), userInList.status)
                    userList.add(user)
                }
                if (forumInList.submissionId){
                    forum = new ForumSubmissionContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList,Submission.get(forumInList.submissionId))
                }else if (forumInList.problemId){
                    forum = new ForumProblemReportContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList,Problem.get(forumInList.problemId))
                }else{
                    forum = new ForumContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList)
                }
                forumList.add(forum)
            }
            max = max - forumList.size()
            if (max > 0){
                BasicDBObject findReadForum = new BasicDBObject("userList",
                        new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId).append('status',UserStatus.STATUS_READ)));

                coll.find(findReadForum).skip(offset).limit(max).sort(new BasicDBObject('lastUpdated',-1)).each{ forumInList ->

                    ForumContainer forum
                    ArrayList<ForumMessage> messageList = new ArrayList<ForumMessage>()
                    forumInList.messageList.each{ messageInList ->
                        ForumMessage message = new ForumMessage(ShiroUser.get(messageInList.id),messageInList.message,messageInList.dateCreated)
                        messageList.add(message)
                    }
                    ArrayList<UserStatus> userList = new ArrayList<UserStatus>()
                    forumInList.userList.each{ userInList ->
                        UserStatus user = new UserStatus(ShiroUser.get(userInList.id), userInList.status)
                        userList.add(user)
                    }
                    if (forumInList.submissionId){
                        forum = new ForumSubmissionContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList,Submission.get(forumInList.submissionId))
                    }else if (forumInList.problemId){
                        forum = new ForumProblemReportContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList,Problem.get(forumInList.problemId))
                    }else{
                        forum = new ForumContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList)
                    }
                    forumList.add(forum)
                }
            }

            return forumList


        }catch (Exception e){
            println e
        }
        return null
    }

    public static ForumContainer getForum(String forumId){
        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum");
        BasicDBObject findDocument = new BasicDBObject("_id", new ObjectId(forumId));
        ForumContainer forum
        def result = coll.find(findDocument)
        if(result.hasNext()){
            def forumInList = result.next()
            ArrayList<ForumMessage> messageList = new ArrayList<ForumMessage>()
            forumInList.messageList.each{ messageInList ->
                ForumMessage message = new ForumMessage(ShiroUser.get(messageInList.id),messageInList.message,messageInList.dateCreated)
                messageList.add(message)
            }
            ArrayList<UserStatus> userList = new ArrayList<UserStatus>()
            forumInList.userList.each{ userInList ->
                UserStatus user = new UserStatus(ShiroUser.get(userInList.id), userInList.status)
                userList.add(user)
            }
            if (forumInList.submissionId){
                forum = new ForumSubmissionContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList,Submission.get(forumInList.submissionId))
            }else if (forumInList.problemId){
                forum = new ForumProblemReportContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList,Problem.get(forumInList.problemId))
            }else{
                forum = new ForumContainer(forumInList.get("_id").toString(),forumInList.lastUpdated, userList,messageList)
            }

        }
        return forum
    }

    public static boolean insertNotification(long userId, long notificationId, Date createdAt, String notificationTitle, String notificationResume){

        DB db = getDB('notifications')
        DBCollection coll = db.getCollection("notifications")
        BasicDBObject qr = new BasicDBObject("notificationId",notificationId)

        if(coll.find(qr).count() == 0){
            BasicDBObject notificationInstance = new BasicDBObject("notificationId",notificationId)
            notificationInstance.append("createdAt", createdAt)
            notificationInstance.append("notificationTitle", notificationTitle)
            notificationInstance.append("notificationResume", notificationResume)

            BasicDBList userList = new BasicDBList()
            UserStatus user = new UserStatus(ShiroUser.get(userId), UserStatus.STATUS_UNREAD)
            userList.add(user)

            notificationInstance.append("userList",userList)
            coll.insert(notificationInstance)
            return true

        }else{
            return false
        }



    }

}
