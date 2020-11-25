package com.thehuxley


import jxl.Workbook
import jxl.write.Label
import jxl.write.WritableSheet
import jxl.write.WritableWorkbook
import jxl.write.WritableCellFormat
import jxl.write.WritableFont
import jxl.format.Colour
import java.text.SimpleDateFormat
import java.security.MessageDigest
import jxl.format.Border
import jxl.format.BorderLineStyle
import jxl.format.Alignment


class GroupController {
    public static final SimpleDateFormat GROUP_DATE_FORMAT = new SimpleDateFormat("MM/dd/yyyy");
    public static final SimpleDateFormat DB_GROUP_DATE_FORMAT = new SimpleDateFormat("yyyy/MM/dd");
    public static final String PERIOD_MONTH = "MONTH"
    public static final String PERIOD_DAY = "DAY"
    public static final String PERIOD_WEEK = "WEEK"
    def groupService
    def mongoService
    def userService
    def licenseService
    def memcachedService
    def add = {
        Cluster clusterInstance = Cluster.findByHash(params.id)
        [clusterInstance:clusterInstance]
    }

    def saveUsers = {
        Cluster group = Cluster.get(params.id)
        if(params.sList&&!params.sList.isEmpty()){
            String studentList = "(" + params.sList + ")"
            ClusterPermissions.executeUpdate("Update ClusterPermissions cp set permission = 0 where user.id in " + studentList + " and group.id = " + group.id)
            ShiroUser.executeQuery("Select u from ShiroUser u where u.id in " + studentList).each{
                if(!ClusterPermissions.findByUserAndGroup(it,group)){
                    ClusterPermissions clusterPermission = new ClusterPermissions()
                    clusterPermission.user = it
                    clusterPermission.group = group
                    clusterPermission.permission = 0
                    clusterPermission.save()
                    clusterPermission.updateUserInstitution()

                    Questionnaire.updateUserQuestionnaireList(clusterPermission)
                }
            }
            ClusterPermissions.executeQuery("Select cp from ClusterPermissions cp where user.id not in " + studentList + " and group.id = " + group.id + " and permission = 0 ").each{
                it.delete()
            }
        }else{
            ClusterPermissions.executeQuery("Select cp from ClusterPermissions cp where group.id = " + group.id + " and permission = 0 ").each{
                it.delete()
            }
        }
        if(params.tList&&!params.tList.isEmpty()){
            String masterList = "(" + params.tList + ")"

            ClusterPermissions.executeUpdate("Update ClusterPermissions cp set permission = 30 where user.id in " + masterList + " and group.id = " + group.id)

            ShiroUser.executeQuery("Select u from ShiroUser u where u.id in " + masterList).each{
                if(!ClusterPermissions.findByUserAndGroup(it,group)){
                    ClusterPermissions clusterPermission = new ClusterPermissions()
                    clusterPermission.user = it
                    clusterPermission.group = group
                    clusterPermission.permission = 30
                    clusterPermission.save()
                    clusterPermission.updateUserInstitution()
                }

            }

            ClusterPermissions.executeQuery("Select cp from ClusterPermissions cp where user.id not in " + masterList + " and group.id = " + group.id + " and permission = 30 ").each{
                it.delete()
            }
        }else{
            ClusterPermissions.executeQuery("Select cp from ClusterPermissions cp where group.id = " + group.id + " and permission = 30 ").each{
                it.delete()
            }
        }

        redirect(action: "show", id:group.hash)

    }

    def getUserBoxLeftList = {
        if(params.name.equals('undefined')){
            params.name = ''
        }
        if(params.selectedIdList && !params.selectedList.equals("undefined")){
            params.selectedIdList = " and p.user.id not in (" + params.selectedIdList + ")"
        }else{
            params.selectedIdList = ""
        }
        def instList
        if(session.license.isAdmin()){
            instList = Institution.list().id.toString()
        }
        if(session.license.isTeacher()){
            instList = session.license.institution.id.toString()
        }
        if(session.license.isAdminInst()){
            instList = session.license.institution.id.toString()
        }
        if (instList.contains('[')){
            instList = instList.replace('[','')
        }
        if(instList.contains(']')){
            instList = instList.replace(']','')
        }
        render(contentType:"text/json") {
            content = huxley.userDLCLeftBox( selectedIdList:params.selectedIdList, name:params.name, position:"false", score:"false", email:"true", instList: instList)

        }
    }
    def getUserBoxRightList = {
        ArrayList<Long> idList = new ArrayList<Long>()
        ArrayList<Long> permList = new ArrayList<Long>()
        ClusterPermissions.executeQuery("Select Distinct user.id, permission from ClusterPermissions where group.id = " + params.id).each{
            if(!idList.contains(it[0])){
                idList.add(it[0])
                permList.add(it[1])
            }
        }

        render(contentType:"text/json") {
            content = huxley.userDLCRightBox( group:params.id, position:"false", score:"false", email:"true")
            selectedIdList = idList
            roleList = permList
        }
    }

    def getGroupBoxLeftList = {

        if(params.name.equals('undefined')){
            params.name = ''
        }
        if(params.selectedIdList && !params.selectedList.equals("undefined")){
            params.selectedIdList = " and c.id not in  (" + params.selectedIdList + ")"
        }else{
            params.selectedIdList = ""
        }
        def instList
        if(session.license.isAdmin()){
            instList = Institution.list().id.toString()
        }
        if(session.license.isTeacher()){
            instList = session.license.institution.id.toString()
        }
        if(session.license.isAdminInst()){
            instList = session.license.institution.id.toString()
        }
        if (instList.contains('[')){
            instList = instList.replace('[','')
        }
        if(instList.contains(']')){
            instList = instList.replace(']','')
        }
        render(contentType:"text/json") {
            content = huxley.groupDLCLeftBox( name:params.name,instList: instList, selectedIdList : params.selectedIdList)

        }
    }

    def index = {
        def data = licenseService.getPackInfo(session.license.institution)
        if(!params.max){
            params.max = 10
        }
        if (!params.offset){
            params.offset = 0
        }
        if (!params.name){
            params.name = ""
        }
        def groupList
        def totalGroups
        if(session.license.isAdmin()){
            groupList = Cluster.findAllByNameLike("%"+params.name+"%",[max:params.max,offset:params.offset])
            totalGroups = Cluster.count()
        }
        if(session.license.isTeacher()){
            groupList = Cluster.executeQuery("Select Distinct c.group from ClusterPermissions c where c.group.name like '%"+params.name+"%' and permission > 0 and c.user.id = " + session.profile.user.id,[max:params.max,offset:params.offset])
            totalGroups = Cluster.executeQuery("Select Distinct count(c.group) from ClusterPermissions c where c.group.name like '%"+params.name+"%' and permission > 0 and c.user.id = " + session.profile.user.id)[0]
        }
        if(session.license.isAdminInst()){
            groupList = Cluster.executeQuery("Select Distinct c from Cluster c where c.name like '%"+params.name+"%' and c.institution.id = " + session.license.institution.id,[max:params.max,offset:params.offset])
            totalGroups = Cluster.executeQuery("Select Distinct count(c) from Cluster c where c.name like '%"+params.name+"%' and c.institution.id = " + session.license.institution.id)[0]
        }
        [groupList:groupList,total:totalGroups, licenseTotal:data.get("TOTAL") - data.get("USED")]

    }


    def show = {
        def data = licenseService.getPackInfo(session.license.institution)


        def clusterInstance
            if(params.id){
                clusterInstance = Cluster.findByUrl(params.id)
                if (!clusterInstance){
                    clusterInstance = Cluster.findByHash(params.id)
                }
            }
        String query = ""
        if (!clusterInstance) {
            response.sendError(404)
        }else {
            if(session.license.isStudent()){
                redirect (action: 'requestShow', id: clusterInstance.hash)
            } else {
                [clusterInstance: clusterInstance, pendency: params.pendency, total:data.get("TOTAL") - data.get("USED")]
            }

        }
    }

    def exportQuest = {

        String groupName = Cluster.get(params.id).name
        String fileName = "notas dos questionários do grupo: " + groupName;
        List listQuest = Questionnaire.executeQuery("Select q from Questionnaire q inner join q.groups g where g.id = :groupId ", [groupId: Long.parseLong(params.id)]);

        if(params.exportType == 'excel') {
            response.setContentType('application/vnd.ms-excel')
            response.setHeader('Content-Disposition', 'Attachment;Filename=' + fileName + '.xls')
            WritableWorkbook workbook = Workbook.createWorkbook(response.outputStream)
            workbook.setColourRGB(Colour.BLUE, 99,187,238)
            workbook.setColourRGB(Colour.LIGHT_BLUE, 170,220,247)

            WritableFont cellTitleFont = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD, false);
            WritableCellFormat cellTitleFormat = new WritableCellFormat (cellTitleFont)
            cellTitleFormat.setBackground(Colour.BLUE)
            cellTitleFormat.setBorder(Border.ALL, BorderLineStyle.THICK)

            WritableCellFormat cellFormat = new WritableCellFormat ()
            cellFormat.setBackground(Colour.LIGHT_BLUE);
            cellFormat.setBorder(Border.RIGHT, BorderLineStyle.THIN)
            cellFormat.setBorder(Border.LEFT, BorderLineStyle.THIN)

            WritableCellFormat cellFormat2 = new WritableCellFormat ()
            cellFormat2.setBorder(Border.RIGHT, BorderLineStyle.THIN)
            cellFormat2.setBorder(Border.LEFT, BorderLineStyle.THIN)


            listQuest.eachWithIndex{ quest, i ->
                WritableSheet sheet = workbook.createSheet(quest.title, i)
                sheet.addCell(new Label(0,0, "ALUNOS", cellTitleFormat))
                sheet.addCell(new Label(1,0, "PONTUAÇÃO", cellTitleFormat))
                sheet.addCell(new Label(1, 1, ".",cellFormat2))
                List questUserList = Questionnaire.executeQuery("Select Distinct q from QuestionnaireShiroUser q where q.user.id in (Select Distinct c1.user.id from ClusterPermissions c1 where group.id = :groupId and permission = 0) and q.questionnaire.id = :questId order by q.user.name ", [groupId: Long.parseLong(params.id), questId: quest.id])
                    questUserList.eachWithIndex{ questUser, j ->
                       String nameUser = questUser.user
                       String score = questUser.score

                       if(j%2) {
                           sheet.addCell(new Label(0,j+=2, nameUser, cellFormat))
                           sheet.addCell(new Label(1,j, score, cellFormat))
                       }else {
                           sheet.addCell(new Label(0,j+=2, nameUser, cellFormat2))
                           sheet.addCell(new Label(1,j, score, cellFormat2))
                        }

                   }


                }
                workbook.write();
                workbook.close();
        }
        else if(params.exportType == 'csv'){

            response.setHeader('Content-Disposition', 'attachment; filename=' + fileName + '.csv')
            response.contentType = "application/vnd.ms-excel"
            def write = 'ALUNO/QUESTIONÁRIO',outs = response.outputStream
            List listUserGroup = ClusterPermissions.executeQuery("select distinct cp.user from ClusterPermissions cp where cp.group.id = :groupId and cp.permission = 0 order by cp.user.name", [groupId: Long.parseLong(params.id)])
            List listQuestGroup =  Questionnaire.executeQuery("select distinct q from Questionnaire q inner join q.groups g where g.id = :groupId order by q.startDate", [groupId:Long.parseLong(params.id)])
            listQuestGroup.each {  quest ->
                write += ';' +  quest.title;
            }
            write += '\n\n'
            listUserGroup.each { userGroup ->
                List userScore = QuestionnaireShiroUser.executeQuery("select q.score from QuestionnaireShiroUser q where q.user.id = :userId and q.questionnaire in :questList order by q.questionnaire.startDate", [userId:userGroup.id, questList:listQuestGroup])
                write+= userGroup.name;
                userScore.each { score ->
                    write += ';' +  score
                }
                write += '\n'
            }

            outs << write
            outs.flush()
            outs.close()
        }


    }

    def submissionChart = {
        //Dados para a tabela de acessos por usuario de um grupo por dia

        Map<String,Object> resultMap = groupService.getSubmissionChart(params)
        if(resultMap){
            render(contentType:"text/json") {
                categories = resultMap.get("Categories")
                data = 	resultMap.get("AccessData")
                qData =	resultMap.get("QuestData")
            }
        }else{
            render(contentType:"text/json") {
                msg = 'error'
            }
        }

    }
    def questChart = {
        Map<String,Object> resultMap = groupService.getQuestChart(params)
        if(resultMap){
            render(contentType:"text/json") {
                categories = resultMap.get("Categories")
                tryData = resultMap.get("TryData")
                notTryData = resultMap.get("NotTryData")
            }
        }else{
            render(contentType:"text/json") {
                msg = 'error'
            }
        }


    }

    def questTopicChart = {
        Map<String,Object> resultMap = groupService.getQuestTopicChart(params)
        if (resultMap){
            render(contentType:"text/json") {
                categories = resultMap.get("Categories")
                data = resultMap.get("ChartData")
                topics = resultMap.get("TopicList")

            }
        }else{
            render(contentType:"text/json") { categories = "empty" }
        }
    }

   def create = {
       Cluster clusterInstance = new Cluster()
       def instList
       if(session.license.isAdmin()){
           instList = Institution.list()
       }
       if(session.license.isTeacher()){
           instList = session.license.institution
       }
       if(session.license.isAdminInst()){
           instList = session.license.institution
       }
       if(params.id){
           clusterInstance = Cluster.findByHash(params.id)
       }
       [instList : instList, clusterInstance: clusterInstance, testForm: params.testForm]


   }

    def save = {
        Cluster cluster = new Cluster()
        if(params.groupId){
            cluster = Cluster.get(params.groupId)
        }else{
            MessageDigest md = MessageDigest.getInstance("MD5")
            BigInteger generatedHash = new BigInteger(1, md.digest((System.nanoTime().toString()).getBytes()))
            cluster.hash = generatedHash.toString(16)
        }
        cluster.name = params.name
        cluster.description = params.description
        cluster.url = params.url
        def dateFormat = new SimpleDateFormat("dd/MM/yyyy")

        if(!params.startDateString.isEmpty()){
            cluster.startDate = dateFormat.parse(params.startDateString)
        }
        if(!params.endDateString.isEmpty()){
            cluster.endDate = dateFormat.parse(params.endDateString)
        }
        if (!params.inst){
            params.inst = License.get(session.license.id).institution.id
        } else {
            cluster.institution = Institution.get(params.inst)
        }

        if (cluster.save()){
            if(session.license.isTeacher()){
                def user = License.get(session.license.id).user
                if(!ClusterPermissions.findByUserAndGroup(user,cluster)){
                    ClusterPermissions clusterPermission = new ClusterPermissions()
                    clusterPermission.user = user
                    clusterPermission.group = cluster
                    clusterPermission.permission = 30
                    clusterPermission.save()
                    clusterPermission.updateUserInstitution()
                }
            }
            if(params.quickCreate){
                render(contentType:"text/json") { msg(status:'ok', txt:message(code:"verbosity.created",args:[cluster.name])) }
            }else{
                redirect(action: "show", id: cluster.url)
            }

        }else{
            if(params.quickCreate){
                render(contentType:"text/json") { msg(status:'fail', txt:message(code:"verbosity.error.create",args:[message(code:"entity.group")])) }
            }else{
                render(view: "create", model: [clusterInstance: clusterInstance, testForm: true])
            }
        }

    }



    def accessChart = {

        def groupStartDate = Cluster.get(params.id).startDate;

        if(!params.startDate){
            if(groupStartDate){
                params.startDate = GroupService.GROUP_DATE_FORMAT.format(groupStartDate)
            }
        }

        Map<String,Object> resultMap = groupService.getAccessChart(params)
        if (resultMap){
            render(contentType:"text/json") {
                categories = resultMap.get("Categories")
                data = 	resultMap.get("AccessData")
                qData =	resultMap.get("QuestData")
            }
        }else{
            render(contentType:"text/json") {
                msg = 'error'
            }
        }

    }


    def getMasters = {
        ArrayList<Profile> masterList = groupService.getMasterList(params.id)
        render(contentType:"text/json") {
            masters = array {
                masterList.each{
                    master id:it.id, name:it.name, hash:it.hash, photo: it.photo
                }
            }
        }
    }

    def getStudents = {
        ArrayList<Profile> studentList = groupService.getStudentList(params.id,params.sort,params.order)
        Map userStatus = mongoService.findStimulusPredicatorGroup(Long.parseLong(params.id))
        if (userStatus){
            render(contentType:"text/json") {
                status = true
                students = array {
                    studentList.each{
                        List clusterPermission = ClusterPermissions.findAllWhere([user: Profile.get(it.id).user, group: Cluster.get(params.id), permission: 0])
                        student userStatusGroup: clusterPermission[0].statusUser, id:it.id, name:it.name, hash:it.hash, problemsTryed:it.problemsTryed, problemsCorrect:it.problemsCorrect, topCoderPosition:it.user.topCoderPosition, topCoderScore:it.user.topCoderScore, status:userStatus.get(it.id.toString()), submissionCount: it.submissionCount, photo: it.photo
                    }
                }
            }
        }else{
            render(contentType:"text/json") {
                students = array {
                    studentList.each{
                        List clusterPermission = ClusterPermissions.findAllWhere([user: Profile.get(it.id).user, group: Cluster.get(params.id), permission: 0])
                        student  userStatusGroup: clusterPermission[0].statusUser, id:it.id, name:it.name, hash:it.hash, problemsTryed:it.problemsTryed, problemsCorrect:it.problemsCorrect, topCoderPosition:it.user.topCoderPosition, topCoderScore:it.user.topCoderScore, submissionCount: it.submissionCount, photo: it.photo
                    }
                }
            }
        }

    }

    def search = {
        if(!params.max){
            params.max = 10
        }
        if (!params.offset){
            params.offset = 0
        }
        def groupList
        def totalGroups
        if(session.license.isAdmin()){
            groupList = Cluster.findAllByNameLike("%"+params.name+"%",[max:params.max,offset:params.offset])
            totalGroups = Cluster.countByNameLike("%"+params.name+"%")
        }
        if(session.license.isTeacher()){
            groupList = Cluster.executeQuery("Select Distinct c.group from ClusterPermissions c where c.group.name like '%"+params.name+"%' and permission > 0 and c.user.id = " + session.profile.user.id,[max:params.max,offset:params.offset])
            totalGroups = Cluster.executeQuery("Select Distinct count(c.group) from ClusterPermissions c where c.group.name like '%"+params.name+"%' and permission > 0 and c.user.id = " + session.profile.user.id)[0]
        }
        if(session.license.isAdminInst()){
            groupList = Cluster.executeQuery("Select Distinct c from Cluster c where c.name like '%"+params.name+"%' and c.institution.id = " + session.license.institution.id,[max:params.max,offset:params.offset])
            totalGroups = Cluster.executeQuery("Select Distinct count(c) from Cluster c where c.name like '%"+params.name+"%' and c.institution.id = " + session.license.institution.id)[0]
        }
        render(contentType:"text/json") {
            groups = array {
                groupList.each{
                    group id:it.id, name:it.name, hash:it.hash
                }
            }
            total = totalGroups
        }
    }

    def ajxGetCurrentGroupList = {

        def groupList =  groupService.getGroupByInstitutionAndNameLike(session.license.institution, params.q)

        render(contentType: "text/json") {
            groups = array {
                groupList.each {
                    group name: it.name, id: it.id
                }
            }
        }
    }

    def ajxGetCurrentGroupListTeacher = {
        def clusterPermissionsList = ClusterPermissions.executeQuery("select Distinct cp from ClusterPermissions cp where cp.user.id = " + session.profile.user.id + " and cp.permission = " + 30 + " and cp.group.name like '%" + params.q + "%'")

        def groupsId = []
        def groupList = []
        
        clusterPermissionsList.each {
            if (!groupsId.contains(it.group.id)) {
                groupsId.add(it.group.id)    
            }
        }
        
        if (groupsId.size() > 0) {
            groupList = Cluster.getAll(groupsId)
        }

        render(contentType: "text/json") {
            groups = array {
                groupList.each {
                    group name: it.name, id: it.id    
                }    
            }    
        }


    }

    def ajxGetGroupsByQuestionnaire = {
        def groupList = Questionnaire.get(params.qid).groups

        render(contentType: "text/json") {
            groups = array {
                groupList.each {
                    group id:it.id, name:it.name
                }
            }
        }
    }

    def remove = {
        def group = Cluster.findByHash(params.id)
        if((session.license.isAdmin()) || (session.license.isAdminInst() && session.license.institution.id == group.institution.id) || (session.license.isTeacher() && ClusterPermissions.findWhere(group: group,permission: 30,user: License.get(session.license.id).user))){
            ClusterPermissions.findAllByGroup(group).each{
                it.delete()
            }
            QuestionnaireStatistics.findAllByGroup(group).each{
                it.delete()
            }
            Questionnaire.executeQuery("Select q from Questionnaire q left join q.groups g where g.id = " + group.id).each{
                it.removeFromGroups(group)
            }
            group.delete()
        }
        redirect(action:"index")



    }

    def list = {


    }

    def validateURL = {
        int urlVerification = 0
        if(params.id){
            urlVerification = Cluster.findAllByUrlAndIdNotEqual(params.url, params.id).size()
        } else {
            urlVerification = Cluster.findAllByUrl(params.url).size()
        }
        if (urlVerification>0){
            render (contentType:"text/json") { msg( status:'fail',txt:message(code:"verbosity.url.exists")) }
        }else{
            render (contentType:"text/json") { msg( status:'ok',txt:message(code:"verbosity.url.valid")) }
        }
    }

    def generateAccessKey = {
        Cluster group =  Cluster.get(params.id)
        MessageDigest md = MessageDigest.getInstance("MD5")
        BigInteger generatedHash = new BigInteger(1, md.digest((System.nanoTime().toString()).getBytes()))
        group.accessKey = generatedHash.toString(16)
        group.accessKey = group.accessKey.substring(0,4) + group.id
        def permission = ClusterPermissions.findWhere(user: session.license.user, permission:30, group: group)
        if (permission) {
            if(group.save()){
                render (contentType:"text/json") { msg( status:'ok',accessKey:group.accessKey) }
            }else{
                render (contentType:"text/json") { msg( status:'fail' ) }

            }
        } else {
            render (contentType:"text/json") { msg( status:'fail', txt:'Não existem permissões para esse grupo' ) }
        }

    }
    def  requestShow = {
        Cluster clusterInstance = Cluster.findByHash(params.id)
        [clusterInstance:clusterInstance, msg:params.msg]
    }

    def welcome = {
        def data = licenseService.getPackInfo(session.license.institution)
        [total:data.get("TOTAL") - data.get("USED")]
    }

    def overview = {
        def data = licenseService.getPackInfo(session.license.institution)
        [total:data.get("TOTAL") - data.get("USED")]
    }

    def getGroupInfo = {

        def clusterPermissions = ClusterPermissions.executeQuery("select c from ClusterPermissions c where c.user = :user and c.permission = 30 group by c.group order by c.group.lastUpdated desc", [user: session.profile.user]);
        def result = []
        def simpleDateFormat = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss")


        clusterPermissions.each {
            result.add([
                id: it.group.id,
                dateCreated: it.group.dateCreated ? simpleDateFormat.format(it.group.dateCreated) : null,
                description: it.group.description,
                endDate: it.group.endDate ? simpleDateFormat.format(it.group.endDate) : null,
                hash: it.group.hash,
                intitution: [
                    id: it.group.institution.id,
                    name: it.group.institution.name
                ],
                lastUpdated: it.group.lastUpdated ? simpleDateFormat.format(it.group.lastUpdated) : null,
                name: it.group.name,
                startDate: it.group.startDate ? simpleDateFormat.format(it.group.startDate) : null,
                url: it.group.url,
                userTotal: ClusterPermissions.findAllByGroupAndPermissionNotEqual(it.group, 30).size(),
                questionnaireTotal: Questionnaire.executeQuery("select q from Questionnaire q where :group in elements(q.groups)", [group: it.group]).size()
            ])
}

        render (contentType: "text/json") {
            result
        }
    }

    def manage = {
        Cluster group = Cluster.findByHash(params.id)
        if (group){
            ClusterPermissions groupPermission = ClusterPermissions.findWhere(user: session.license.user, group: group, permission: 30)
            if (!groupPermission && !(session.license.isAdminInst() && session.license.institution.id == group.institution.id)) {
                redirect(controller: 'home')
            }
        } else {
            redirect(controller: 'home')
        }
        [group: group]

    }

    def addStudent = {
        def group = Cluster.get(params.id)
        def msg = [status: 'ok', txt: '']
        boolean fail = false
        if (group) {
            Institution institution = group.institution
            def data = licenseService.getPackInfo(institution)
            ShiroUser user = ShiroUser.findByEmail(params.email)
            def permission
            def licenseInstance
            if (user) {
                permission = ClusterPermissions.executeQuery("Select cp from ClusterPermissions cp where cp.user.id = :user and cp.group.institution.id = :institution", [user:user.id, institution: institution.id])
                licenseInstance = License.findWhere(type: LicenseType.findByKind(LicenseType.TEACHER), user: user, institution: institution)
            }
            if (licenseInstance || permission || (data.get("TOTAL") - data.get("USED")) > 0) {
                if (!user) {
                    if (userService.saveUser(params.email,params.email,[],[],request,[1,0,0],-1, false)) {
                        msg = [status: 'ok', txt: 'Usuário não cadastrado, convite enviado']
                        memcachedService.delete("packinfo-params:${institution.id}")
                    } else {
                        fail = true
                        msg = [status: 'fail', txt: 'Não foi possível enviar o convite']
                    }
                    user = ShiroUser.findByEmail(params.email)
                }
                if (!fail){
                    if(!ClusterPermissions.findByUserAndGroup(user,group)){
                        ClusterPermissions clusterPermission = new ClusterPermissions()
                        clusterPermission.user = user
                        clusterPermission.group = group
                        clusterPermission.permission = 0
                        if (clusterPermission.save()) {
                            clusterPermission.updateUserInstitution()
                            Questionnaire.updateUserQuestionnaireList(clusterPermission)
                            if (msg.txt){
                                msg.txt += '. '
                            } else {
                                msg.txt = ''
                            }
                            msg = [status: 'ok', txt: msg.txt + 'Usuário adicionado ao grupo']
                            memcachedService.delete("packinfo-params:${institution.id}")
                        } else {
                            msg = [status: 'fail', txt: 'Houve um erro ao tentar adicionar o usuário ao grupo']
                        }

                    } else {
                        msg = [status: 'fail', txt: 'Usuário já está no grupo']
                    }
                }
            } else {
                msg = [status: 'fail', txt: 'Não há licenças disponíveis']
            }
        } else {
            msg = [status: 'fail', txt: 'Grupo não encontrado']
        }
        render(contentType:"text/json") {
            msg
        }
    }

    def addByAccessKey = {
        def msg = [status: 'ok', txt: '']
        if (params.accessKey && !params.accessKey.isEmpty()) {
            def group = Cluster.findByAccessKey(params.accessKey)
            boolean fail = false
            if (group) {
                Institution institution = group.institution
                def data = licenseService.getPackInfo(institution)

                ShiroUser user = session.license.user
                def permission
                def licenseInstance
                if (user) {
                    permission = ClusterPermissions.executeQuery("Select cp from ClusterPermissions cp where cp.user.id = :user and cp.group.institution.id = :institution", [user:user.id, institution: institution.id])
                    licenseInstance = License.findWhere(type: LicenseType.findByKind(LicenseType.TEACHER), user: user, institution: institution)
                }
                if (licenseInstance || permission || (data.get("TOTAL") - data.get("USED")) > 0) {
                    if (!fail){
                        if(!ClusterPermissions.findByUserAndGroup(user,group)){
                            ClusterPermissions clusterPermission = new ClusterPermissions()
                            clusterPermission.user = user
                            clusterPermission.group = group
                            clusterPermission.permission = 0
                            if (clusterPermission.save()) {
                                clusterPermission.updateUserInstitution()
                                Questionnaire.updateUserQuestionnaireList(clusterPermission)
                                if (msg.txt){
                                    msg.txt += '. '
                                } else {
                                    msg.txt = ''
                                }
                                msg = [status: 'ok', txt: msg.txt + 'Usuário adicionado ao grupo', group: group]
                                memcachedService.delete("packinfo-params:${institution.id}")
                            } else {
                                msg = [status: 'fail', txt: 'Houve um erro ao tentar adicionar o usuário ao grupo']
                            }

                        } else {
                            msg = [status: 'ok', txt: 'Usuário já está no grupo', group: group]
                        }
                    }
                } else {
                    msg = [status: 'fail', txt: 'Não é possível adicionar, contate o administrador do grupo']
                }
            } else {
                msg = [status: 'fail', txt: 'Chave inválida']
            }
        } else {
            msg = [status:'fail', txt:'Chave nula ou vazia']
        }
        render(contentType:"text/json") {
            msg
        }
    }

    def listUser = {
        HashMap searchParams = new HashMap()
        searchParams.put("GROUP",Long.parseLong(params.id))
        if(params.name && !params.name.isEmpty()){
            searchParams.put("NAME",params.name)
        }
        if(params.max){
            searchParams.put("LIMIT", params.max)
        }
        if(params.offset) {
            searchParams.put("OFFSET", params.offset)
        }
        if(params.permission) {
            if (params.permission == "t") {
                searchParams.put("PERMISSION", 30)
            } else {
                searchParams.put("PERMISSION", 0)
            }
        }

        def result = groupService.searchUser(searchParams)

        render(contentType:"text/json") {
            users = array {
                result.get("RESULT").each{
                    users content:huxley.userBox( user:it.user,position:"false", score:"false", email:"true") , profile: Profile.findByUser(it.user), email: it.user.email, permission: it.permission>0?'Professor':'Aluno', id: it.id
                }
            }
            total = result.get("TOTAL")
        }

    }
        def removeUser = {
            def clusterPermission = ClusterPermissions.get(params.id)
            def msg
            if (clusterPermission) {
                if (!clusterPermission.delete()) {
                    msg = [status : 'ok', txt : 'Atualizado com sucesso']
                } else {
                    msg = [status : 'fail', txt : 'Ocorreu um erro']
                }
            } else {
                msg = [status : 'fail', txt : 'Permissão não encontrada']
            }
            render(contentType:"text/json") {
                msg
            }
        }

    def markQuitter = {

        List clusterPermission = ClusterPermissions.findAllWhere([user:Profile.get(params.sId).user, group: Cluster.get(params.gId), permission: 0])
        if(params.mark == '1') {
            clusterPermission[0].statusUser = ClusterPermissions.USER_QUITTER
        } else {
            clusterPermission[0].statusUser = ClusterPermissions.USER_ACTIVE
        }


         if(clusterPermission[0].save()) {
             render(contentType:"text/json") {
                 status = 'ok'
             }
         }
    }
}