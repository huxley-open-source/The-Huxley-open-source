package com.thehuxley

import com.mongodb.BasicDBList
import com.mongodb.BasicDBObject
import com.mongodb.DB
import com.mongodb.DBCollection
import com.mongodb.MongoClient
import com.thehuxley.container.forum.ForumContainer
import com.thehuxley.container.forum.ForumMessage
import com.thehuxley.container.forum.ForumProblemReportContainer
import com.thehuxley.container.forum.ForumSubmissionContainer
import com.thehuxley.container.forum.UserStatus
import com.thehuxley.container.pendency.Pendency
import com.thehuxley.container.pendency.PendencyGroup
import com.thehuxley.stimulusPredictor.StimulusPredictor
import grails.converters.JSON
import org.bson.types.ObjectId

class MongoService {

    def MongoClient mongoClient;
    MongoService(){
        mongoClient = new MongoClient( "localhost" , 27017 );
    }
    /**
     * Instancia e retorna uma instancia do banco
     * @param dbName, nome do db
     * @return db
     */
    private DB getDB(String dbName){
        DB db
        try{
            db = mongoClient.getDB(dbName);
        }catch (Exception e){
            println e
        }

        return db
    }
    /**
     * Gera a lista de problemas para tela de questionario
     */
    public generateProblemList(){
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
    /**
     * Gera a contagem de tentativas dos grupos para os problemas
     * @param groupId
     * @return
     */
    public generateGroupCountByProblem(groupId){
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
    /**
     * Busca de problemas para tela de questionario
     * @param params
     * @return
     */
    public ArrayList<Object> findProblem(params){
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
    /**
     * Busca de problemas para tela de questionario
     * @param params
     * @return
     */
    public ArrayList<Object> findQuestionnaireProblem(params){
        DB db = getDB( "problemListQuestionnaireCreate2" );
        DBCollection coll = db.getCollection("problem")
        BasicDBObject query = new BasicDBObject()


        BasicDBObject ndQ = new BasicDBObject()
        if (params.containsKey('idList')){
                query.append('id',new BasicDBObject('\$in',params.get('idList')))
        }
        ArrayList<Object> result = new ArrayList<Object>()
        coll.find(query).each{
            result.add(JSON.parse(it.toString()))
        }
        return result
    }
    /**
     * Gera a lista de suspeitas de plagio
     * @return
     */
    public generateQuestionnairePlagiumList(){
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
    /**
     * Gera a lista de suspeitas de plagio
     * @return
     */
    public updateQuestionnairePlagiumList(questionnaireId){
        MongoClient mongoClient = new MongoClient( "localhost" , 27017 )
        DB db = mongoClient.getDB( "questionnairePlagiumList" )
        DBCollection coll = db.getCollection("questionnaire")
        Date today = new GregorianCalendar().getTime()
        Questionnaire quest = Questionnaire.get(questionnaireId)
            try{
                def problemList = ''
                if(coll.find(new BasicDBObject('id',quest.id)).size() != 0) {
                    coll.remove(new BasicDBObject('id',quest.id))
                }
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
                            if(status == 2) {
                                it.plagiumStatus  = QuestionnaireShiroUser.PLAGIUM_STATUS_TEACHER_PLAGIUM
                            } else {
                                it.plagiumStatus = 0
                            }
                            it.save()
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

                    coll.insert(questionnaire)

            }catch (e){

            }


    }
    /**
     * Retorna a lista de suspeita de plagio de um questionario
     * @param questionnaireId, id do questionario
     * @param groupHash, hash do grupo
     * @return Lista com status da analise
     */
    public ArrayList<Object> findByQuestionnaireAndGroup(questionnaireId,groupHash){
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
    /**
     * Executa o analisador de estimulo
     * @return
     */
    public runStimulusPredicator(){
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
    /**
     * Salva os resultados encontrados pelo analisador de estimulo
     * @param groupMap, mapa contendo os resultados
     * @return
     */
    public persistStimulusPredicatorGroup(Map groupMap){
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
    /**
     * Retorna um mapa contendo o resultado de estimulos dos alunos
     * @param groupId, id do grupo
     * @return mapa com resultados, a chave para o mapa eh o id do usuario que retorna o status
     */
    public Map findStimulusPredicatorGroup(long groupId){
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
    /**
     * Cria um forum relacionado a uma submissao
     * @param userId, id do usario quem criou
     * @param msg, mensagem
     * @param dateCreated, data de criacao
     * @param submissionId, id da submissao
     * @return true se tiver atualizado, false caso contrario
     */
    public boolean createForumSubmission(long userId, String msg, Date dateCreated, long submissionId){
        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum")
        BasicDBObject query = new BasicDBObject("submissionId", submissionId)
        //Verifica se já existe um Forum criado
        if (coll.find(query).count() == 0){
            //Caso tenha sido um aluno que criou o forum, todos os professores das turmas que ele pertence serão notificados
            def userIdList = ShiroUser.executeQuery("Select Distinct user.id from ClusterPermissions cp where cp.group.id in (Select Distinct cp2.group.id from ClusterPermissions cp2 where cp2.user.id = " + userId + ") and cp.permission > 0")

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
    /**
     * Insere uma mensagem a um forum relacionado a uma submissao, cria o forum caso ele nao esteja criado
     * @param userId, id do usuario
     * @param msg, mensagem
     * @param dateCreated, data de criacao
     * @param submissionId, id da submissao
     * @return true se tiver atualizado, false caso contrario
     */
    public boolean insertForumSubmissionMessage(long userId, String msg, Date dateCreated, long submissionId){
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
    /**
     * Cria um forum problem report
     * @param userId, id do usuario quem criou
     * @param msg, mensagem
     * @param dateCreated, data de criacao
     * @param problemId, id do problema
     * @return true se tiver atualizado, false caso contrario
     */
    public boolean createForumProblemReport(long userId, String msg, Date dateCreated, long problemId){
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
    /**
     * Insere uma nova mensagem a um forum relacionado a um problema, cria o forum caso o mesmo nao esteja criado.
     * Note que o forum e unico por problema
     * @param userId, id do usuario
     * @param msg, mensagem
     * @param dateCreated, data de criaçao
     * @param problemId, id do problema
     * @return true se tiver criado, false caso contrario
     */
    public boolean insertForumProblemReport(long userId, String msg, Date dateCreated, long problemId){
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
    /**
     * Insere uma nova mensagem em um forum
     * @param userId, id do usuario que criou a msg
     * @param msg, mensagem
     * @param dateCreated, data de criacao da msg
     * @param forumId, id do forum na qual a msg vai ser inserida
     * @return true se tiver inserido, false caso contrario
     */
    public boolean insertForumMessage(long userId, String msg, Date dateCreated, String forumId){

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
    /**
     * Atualiza um forum de acordo com a submissao que ele esta relacionado
     * @param userId, id do usuario
     * @param submissionId, id da submissao
     * @param status, novo status
     * @return true se tiver atualizado, false caso contrario
     */
    public updateForumSubmissionStatus(long userId, long submissionId, int status){
        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum");
        BasicDBObject findDocument = new BasicDBObject('submissionId': submissionId).append("userList",
                new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId)));
        coll.update(findDocument,new BasicDBObject('\$set',new BasicDBObject('userList.$.status',status)))
    }
    /**
     * Atualiza um forum de acordo com o problema que ele esta relacionado
     * @param userId, id do usuario
     * @param problemId, id do problema
     * @param status, novo status
     * @return true se tiver atualizado, false caso contrario
     */
    public updateForumProblemReportStatus(long userId, long problemId, int status){
        DB db = getDB('forum')
        DBCollection coll = db.getCollection("forum");
        BasicDBObject findDocument = new BasicDBObject('problemId': problemId).append("userList",
                new BasicDBObject().append("\$elemMatch", new BasicDBObject().append('id',userId)));
        coll.update(findDocument,new BasicDBObject('\$set',new BasicDBObject('userList.$.status',status)))
    }
    /**
     * Atualiza o status de um forum
     * @param userId, id do usuario
     * @param forumId, id do forum a ser atualizado
     * @param status, novo status do forum
     * @return true se tiver atualizado, false caso contrario
     */
    public boolean updateForumStatus(long userId, String forumId, int status){
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
    /**
     * Retorna uma lista de foruns
     * @param userId, id do usuario
     * @param offset
     * @param max
     * @return Lista contendo foruns
     */
    public ArrayList<ForumContainer> getForumList(long userId, int offset, int max){
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
    /**
     * Retorna uma contagem de msgs nao lidas
     * @param userId
     * @return
     */
    public int getForumUnreadCount(long userId){
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
    /**
     *retorna uma lista de foruns buscando primeiramente os abertos
     *@param long userId, id do usuario
     *@param offset
     *@max max
     *@return Lista contendo foruns
     */
    public ArrayList<ForumContainer> getForumWithPriority(long userId, int offset, int max){
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
    /**
     *Retorna um forum a partir  de um dia
     *@param forumId id do forum
     *@return Forum desejado
     */
    public ForumContainer getForum(String forumId){
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

    /**
     * Cria uma pendência
     * @return true se tiver criado, false caso contrario
     */
    public boolean createPendency(Pendency pendency){
        try{
            DB db = getDB('pendency')
            DBCollection coll = db.getCollection("pendency")
            BasicDBObject user = new BasicDBObject();
            user.append("id",(long) pendency.getUserCreated().id)
            user.append("name", pendency.getUserCreated().name)
            user.append("email", pendency.getUserCreated().user.email)
            BasicDBObject pendencyToInsert = new BasicDBObject("userCreated", user)

            pendencyToInsert.append("dateCreated", pendency.getDateCreated())
            pendencyToInsert.append("dateLastUpdated", pendency.getDateLastUpdated())


            BasicDBList observerList = new BasicDBList()
            pendency.getObserverList().each{
                user = new BasicDBObject();
                user.append("id",(long) it.id)
                user.append("name", it.name)
                observerList.add(user)

            }
            pendencyToInsert.append("status", pendency.getStatus())
            pendencyToInsert.append("kind", pendency.getKind())
            BasicDBObject institution = new BasicDBObject();
            institution.append("id", pendency.getInstitution().id)
            institution.append("name", pendency.getInstitution().name)
            pendencyToInsert.append("institution", institution)
            if(pendency.getDocument() != null){
                pendencyToInsert.append("document", pendency.getDocument())
            }
            if(pendency.getRelatedPendency() != null){
                pendencyToInsert.append("relatedPendency", pendency.getRelatedPendency())
            }
            coll.insert(pendencyToInsert)
            return true
        }catch (Exception e) {
            println e
            return false
        }


    }

    /**
     * Cria uma pendência
     * @return true se tiver criado, false caso contrario
     */
    public boolean createGroupPendency(PendencyGroup pendency){
        try{
            DB db = getDB('pendency')
            DBCollection coll = db.getCollection("pendency")
            BasicDBObject query = new BasicDBObject("userCreated.id",(long) pendency.getUserCreated().id)
            query.append("group.id", pendency.getGroup().id)
            println coll.find(query).count()
            //Verifica se já existe um Forum criado
            if (coll.find(query).count() == 0){
                BasicDBObject user = new BasicDBObject();
                user.append("id",(long) pendency.getUserCreated().id)
                user.append("name", pendency.getUserCreated().name)
                user.append("email", pendency.getUserCreated().user.email)
                BasicDBObject pendencyToInsert = new BasicDBObject("userCreated", user)
                pendencyToInsert.append("dateCreated", pendency.getDateCreated())
                pendencyToInsert.append("dateLastUpdated", pendency.getDateLastUpdated())


                BasicDBList observerList = new BasicDBList()
                pendency.getObserverList().each{
                    user = new BasicDBObject();
                    user.append("id",(long) it.id)
                    user.append("name", it.name)
                    observerList.add(user)

                }
                pendencyToInsert.append("status", pendency.getStatus())
                pendencyToInsert.append("kind", pendency.getKind())
                BasicDBObject institution = new BasicDBObject();
                institution.append("id", pendency.getInstitution().id)
                institution.append("name", pendency.getInstitution().name)
                pendencyToInsert.append("institution", institution)
                BasicDBObject group = new BasicDBObject();
                group.append("id", pendency.getGroup().id)
                group.append("name", pendency.getGroup().name)
                pendencyToInsert.append("group", group)
                coll.insert(pendencyToInsert)

            }
            return true

        }catch (Exception e) {
            println e
            return false
        }


    }

    public def getPendency(String id){
        DB db = getDB('pendency')
        DBCollection coll = db.getCollection("pendency")
        BasicDBObject findDocument = new BasicDBObject('_id': new ObjectId(id));
        def result = coll.find(findDocument)
        ArrayList<Object> resultList = new ArrayList<Object>()
        result.each{
            it.put('id',it.get("_id").toString())
            resultList.add(it)
        }
        return resultList
    }

    public def getPendencyByRelated(String id){
        DB db = getDB('pendency')
        DBCollection coll = db.getCollection("pendency")
        BasicDBObject findDocument = new BasicDBObject('relatedPendency': id)
        def result = coll.find(findDocument)
        ArrayList<Object> resultList = new ArrayList<Object>()
        result.each{
            it.put('id',it.get("_id").toString())
            resultList.add(it)
        }
        return resultList
    }

    /**
     * Retorna uma lista de pendência de um dado id de profile
     * @param profileId id do profile
     * @param offset
     * @param max número maximo de instâncias esperadas, caso = 0, retorna todas as intâncias
     * @return Lista de pendências
     */
    public def getPendencyListByProfileCreated(long profileId, int offset, int max, int status, int kind){
        DB db = getDB('pendency')
        DBCollection coll = db.getCollection("pendency")
        BasicDBObject findDocument = new BasicDBObject("userCreated.id",profileId);
        ArrayList<Pendency> pendencyList = new ArrayList<Pendency>()
        def result
        if(status != -1){
            findDocument.append("status",status)
        }
        if(kind != -1){
            findDocument.append("kind",kind)
        }
        if (max != 0){
            result = coll.find(findDocument).skip(offset).limit(max).sort(new BasicDBObject('dateCreated',-1))
        } else {
            result = coll.find(findDocument).sort(new BasicDBObject('dateCreated',-1))
        }
        ArrayList<Object> resultList = new ArrayList<Object>()
        result.each{
            it.put('id',it.get("_id").toString())
            resultList.add(it)
        }
        return resultList
    }
    /**
     * Retorna uma lista de pendência de um dado id de instituição
     * @param institutionId id da instituição
     * @param offset
     * @param max número maximo de instâncias esperadas, caso = 0, retorna todas as intâncias
     * @return Lista de pendências
     */
    public def getPendencyListByInstitution(long institutionId, int offset, int max, int status, int kind){
        DB db = getDB('pendency')
        DBCollection coll = db.getCollection("pendency")
        BasicDBObject findDocument = new BasicDBObject("institution.id",institutionId);
        def result
        if(status != -1){
            findDocument.append("status",status)
        }
        if(kind != -1){
            findDocument.append("kind",kind)
        }
        if (max != 0){
            result = coll.find(findDocument).skip(offset).limit(max).sort(new BasicDBObject('dateCreated',-1))
        } else {
            result = coll.find(findDocument).sort(new BasicDBObject('dateCreated',-1))
        }
        ArrayList<Object> resultList = new ArrayList<Object>()
        result.each{
            it.put('id',it.get("_id").toString())
            resultList.add(it)
        }
        return resultList
    }

    /**
     * Retorna uma lista de pendência de um dado id de instituição
     * @param institutionId id da instituição
     * @param offset
     * @param max número maximo de instâncias esperadas, caso = 0, retorna todas as intâncias
     * @return Lista de pendências
     */
    public def getPendencyOnInstitutionCadastre(int offset, int max, int status, int kind){
        DB db = getDB('pendency')
        DBCollection coll = db.getCollection("pendency")
        BasicDBObject findDocument = new BasicDBObject("kind",Pendency.KIND_CADASTRE_INSTITUTION);
        def result
        if(status != -1){
            findDocument.append("status",status)
        }
        if(kind != -1){
            findDocument.append("kind",kind)
        }
        if (max != 0){
            result = coll.find(findDocument).skip(offset).limit(max).sort(new BasicDBObject('dateCreated',-1))
        } else {
            result = coll.find(findDocument).sort(new BasicDBObject('dateCreated',-1))
        }
        ArrayList<Object> resultList = new ArrayList<Object>()
        result.each{
            it.put('id',it.get("_id").toString())
            resultList.add(it)
        }
        return resultList
    }

    /**
     * Retorna uma lista de pendência de um dado id de grupo
     * @param groupId id do grupo
     * @param offset
     * @param max número maximo de instâncias esperadas, caso = 0, retorna todas as intâncias
     * @return Lista de pendências
     */
    public def getPendencyListByGroup(long groupId, int offset, int max, int status, int kind){
        DB db = getDB('pendency')
        DBCollection coll = db.getCollection("pendency")
        BasicDBObject findDocument = new BasicDBObject("group.id",groupId);
        def result
        if(status != -1){
            findDocument.append("status",status)
        }
        if(kind != -1){
            findDocument.append("kind",kind)
        }
        if (max != 0){
            result = coll.find(findDocument).skip(offset).limit(max).sort(new BasicDBObject('dateCreated',-1))
        } else {
            result = coll.find(findDocument).sort(new BasicDBObject('dateCreated',-1))
        }
        ArrayList<Object> resultList = new ArrayList<Object>()
        result.each{
            it.put('id',it.get("_id").toString())
            resultList.add(it)
        }
        return resultList
    }

    /**
     * Retorna uma lista de pendência de um dado id de grupo
     * @param groupId id do grupo
     * @param offset
     * @param max número maximo de instâncias esperadas, caso = 0, retorna todas as intâncias
     * @return Lista de pendências
     */
    public def getPendencyListByGroupInList(ArrayList<Long> groupIdList, int offset, int max, int status, int kind){
        DB db = getDB('pendency')
        DBCollection coll = db.getCollection("pendency")
        BasicDBObject groupIdListObject = new BasicDBObject('\$in',groupIdList)
        BasicDBObject findDocument = new BasicDBObject("group.id",groupIdListObject);
        def result
        if(status != -1){
            findDocument.append("status",status)
        }
        if(kind != -1){
            findDocument.append("kind",kind)
        }
        if (max != 0){
            result = coll.find(findDocument).skip(offset).limit(max).sort(new BasicDBObject('dateCreated',-1))
        } else {
            result = coll.find(findDocument).sort(new BasicDBObject('dateCreated',-1))
        }
        ArrayList<Object> resultList = new ArrayList<Object>()
        result.each{
            it.put('id',it.get("_id").toString())
            resultList.add(it)
        }
        return resultList
    }

    public ArrayList<Pendency> convertResultIntoPendencyList(def result){
        ArrayList<Pendency> pendencyList = new ArrayList<Pendency>()
        result.each{ pendecyInList ->
            Pendency pendency = new Pendency(pendecyInList.kind, pendecyInList.status, pendecyInList.userCreated, pendecyInList.institution, pendecyInList.dateCreated)
            pendency.setId(pendecyInList.get("_id").toString())
            pendencyList.add(pendency)
        }
        return pendencyList
    }

    public boolean acceptPendency(String id){
        try{
            DB db = getDB('pendency')
            DBCollection coll = db.getCollection("pendency")
            BasicDBObject findDocument = new BasicDBObject('_id': new ObjectId(id));
            coll.update(findDocument,new BasicDBObject('\$set',new BasicDBObject('status',Pendency.STATUS_ACCEPTED).append('dateLastUpdated',new GregorianCalendar().getTime())))
        }catch(e){
            return false
        }
        return true
    }

    public boolean rejectPendency(String id){
        try{
            DB db = getDB('pendency')
            DBCollection coll = db.getCollection("pendency")
            BasicDBObject findDocument = new BasicDBObject('_id': new ObjectId(id));
            coll.update(findDocument,new BasicDBObject('\$set',new BasicDBObject('status',Pendency.STATUS_REJECTED).append('dateLastUpdated',new GregorianCalendar().getTime())))
        }catch(e){
            return false
        }
        return true
    }

    public boolean blockPendency(String id){
        try{
            DB db = getDB('pendency')
            DBCollection coll = db.getCollection("pendency")
            BasicDBObject findDocument = new BasicDBObject('_id': new ObjectId(id));
            coll.update(findDocument,new BasicDBObject('\$set',new BasicDBObject('status',Pendency.STATUS_USER_BLOCKED).append('dateLastUpdated',new GregorianCalendar().getTime())))
        }catch(e){
            return false
        }
        return true
    }

    public boolean appendDocumentInPendency(String id, String document){
        try{
            DB db = getDB('pendency')
            DBCollection coll = db.getCollection("pendency")
            BasicDBObject findDocument = new BasicDBObject('_id': new ObjectId(id));
            BasicDBObject listItem = new BasicDBObject("document",document)
            BasicDBObject updateQuery = new BasicDBObject('\$push',listItem)
            coll.update(findDocument,updateQuery)
            return true
        }catch (e) {
            return false
        }

    }
}