package com.thehuxley

import com.thehuxley.container.pendency.Pendency
import com.thehuxley.container.pendency.PendencyGroup

class PendencyController {
    def mongoService
    def emailService
    def licenseService
    def memcachedService

    def create = {

        int kind = Integer.parseInt(params.kind)
        Date dateLastUpdated = params.dateLastUpdated
        Date dateCreated = params.dateCreated
        int status = Integer.parseInt(params.status)
        ArrayList<Profile> observerList = Profile.get(params.observerList)
        Profile userCreated = Profile.get(params.userCreated)
        Institution institution = Institution.get(params.institution)
        Pendency pendency = new Pendency()
        pendency.setDateCreated(dateCreated)
        pendency.setDateLastUpdated(dateLastUpdated)
        pendency.setInstitution(institution)
        pendency.setKind(kind)
        pendency.setUserCreated(userCreated)
        pendency.setObserverList(observerList)
        pendency.setStatus(status)
        String statusReturn = mongoService.createPendency(pendency)? 'ok' : 'error'
        render (contentType: 'application/json') {
            [status: statusReturn]
        }

    }

    def acceptPendency = {
        String statusReturn = 'error'
        def pendency = mongoService.getPendency(params.id)
        Institution institution = Institution.get(pendency.institution.id[0])
        if (pendency.kind[0] == Pendency.KIND_CADASTRE_MASTER) {
            def data = licenseService.getPackInfo(institution)
//            if ((data.get("TOTAL") - data.get("USED")) > 0) {
                ShiroUser user = Profile.get(pendency.userCreated.id[0]).user
                LicenseType type = LicenseType.findByKind(LicenseType.TEACHER)
                if (License.findAllWhere(user:user, institution:institution, type: type).size() == 0){
                    statusReturn = mongoService.acceptPendency(params.id)? 'ok' : 'error'
                    License license = new License()
                    license.institution = institution
                    license.user = user
                    license.active = true
                    license.indefiniteValidity = true
                    license.startDate = new Date()
                    license.endDate = new Date()
                    license.type = type
                    license.save(flush: true)
                    emailService.teacherAcceptedMessage(user.email, user.name, institution.name)

                }
//            }

        } else if ( pendency.kind[0] == Pendency.KIND_CADASTRE_INSTITUTION) {
            statusReturn = mongoService.acceptPendency(params.id)? 'ok' : 'error'
            ShiroUser user = Profile.get(pendency.userCreated.id[0]).user
            LicenseType type = LicenseType.findByKind(LicenseType.ADMIN_INST)
            if (License.findAllWhere(user:user, institution:institution, type: type).size() == 0){
                //admin inst
                License license = new License()
                license.institution = institution
                license.user = Profile.get(pendency.userCreated.id[0]).user
                license.active = true
                license.indefiniteValidity = true
                license.startDate = new Date()
                license.endDate = new Date()
                license.type = LicenseType.findByKind(LicenseType.ADMIN_INST)
                license.save(flush: true)
                //teacher
                license = new License()
                license.institution = institution
                license.user = Profile.get(pendency.userCreated.id[0]).user
                license.active = true
                license.indefiniteValidity = true
                license.startDate = new Date()
                license.endDate = new Date()
                license.type = LicenseType.findByKind(LicenseType.TEACHER)
                license.save(flush: true)
                emailService.institutionAcceptedMessage(user.email, user.name, institution.name)
            }
            institution.status = Institution.STATUS_ACCEPTED
            institution.save()
        }
        render (contentType: 'application/json') {
            [status: statusReturn]
        }
    }

    def rejectPendency = {
        String statusReturn =  mongoService.rejectPendency(params.id)? 'ok' : 'error'
        def pendency = mongoService.getPendency(params.id)
        Institution institution = Institution.get(pendency.institution.id[0])
        if (pendency.kind[0] == Pendency.KIND_CADASTRE_MASTER) {
            ShiroUser user = Profile.get(pendency.userCreated.id[0]).user
            LicenseType type = LicenseType.findByKind(LicenseType.TEACHER)
            License license = License.findWhere(user:user, institution:institution, type: type)
            if (license){
                license.delete()
            }
            if(params.message) {
                emailService.teacherRejectedMessage(user.email, user.name, params.message)
            }
        } else if (pendency.kind[0] == Pendency.KIND_CADASTRE_INSTITUTION) {
            LicenseType type = LicenseType.findByKind(LicenseType.ADMIN_INST)
            LicenseType typeStudent = LicenseType.findByKind(LicenseType.STUDENT)
            def licenseList = License.findAllByInstitution(institution)
            licenseList.each{
                if(it.type != typeStudent){
                    it.delete()
                }
            }
            institution.status = Institution.STATUS_REJECTED
            institution.save()
            ShiroUser user = Profile.get(pendency.userCreated.id[0]).user
            emailService.institutionRejectMessage(user.email, user.name, institution.name)
        }

        render (contentType: 'application/json') {
            [status: statusReturn]
        }
    }

    def listByProfileCreated = {
        long profileId = Long.parseLong(params.id)
        int max = 0
        int offset = 0
        int status = -1
        int kind = -1
        if(params.status){
            status = Integer.parseInt(params.status)
        }
        if (params.kind) {
            kind = Integer.parseInt(params.kind)
        }
        if (params.max){
            max = params.max
        }
        if (params.offset){
            offset = params.offset
        }
        render (contentType: 'application/json') {
            mongoService.getPendencyListByProfileCreated(profileId,offset,max,status,kind)
        }
    }

    def listByInstitution = {

        long institutionId

        if (params.id) {
            institutionId =  Long.parseLong(params.id)
        } else if (session.license.institution) {
            institutionId =  session.license.institution.id
        } else if (session.license.isAdmin()) {
            institutionId = 1;
        }

        int max = 0
        int offset = 0
        int status = -1
        int kind = -1
        if(params.status){
            status = Integer.parseInt(params.status)
        }
        if (params.kind) {
            kind = Integer.parseInt(params.kind)
        }
        if (params.max){
            max = params.max
        }
        if (params.offset){
            offset = params.offset
        }
        render (contentType: 'application/json') {
            mongoService.getPendencyListByInstitution(institutionId,offset,max,status,kind)
        }
    }

    def listByInstitutionCadastre = {
        int max = 0
        int offset = 0
        int status = -1
        int kind = -1
        if(params.status){
            status = Integer.parseInt(params.status)
        }
        if (params.kind) {
            kind = Integer.parseInt(params.kind)
        }
        if (params.max){
            max = params.max
        }
        if (params.offset){
            offset = params.offset
        }
        render (contentType: 'application/json') {
            mongoService.getPendencyOnInstitutionCadastre(offset,max,status,kind)
        }
    }

    def createBaseToTest = {
        Pendency pendency = new Pendency(4, 0, 1, 1, new GregorianCalendar().getTime())
        def document = ['a','b','c']
        pendency.setDocument(document)
        String statusReturn = mongoService.createPendency(pendency)? 'ok' : 'error'
        render (contentType: 'application/json') {
            [status: statusReturn]
        }

    }

    def countPendency = {
        int count = 0
        String link = "", id=""
        def result
        String msg, msg2
        HashMap<String, Object> msg3 = new HashMap<String, Object>()
        if(session.license.isTeacher()){
            HashMap<String, String> groupMap = new HashMap<String, String>()
            ArrayList<Long> idListTest = ClusterPermissions.findAllByUserAndPermission(session.license.user, 30).group.id
            mongoService.getPendencyListByGroupInList(idListTest,0,0,0,-1).each{
                count = 1
                Cluster cluster = Cluster.get(it.group.id)
                if(!groupMap.containsKey(cluster.name)){
                    if(cluster.url && !cluster.url.isEmpty()){
                        groupMap.put(cluster.name, cluster.url)
                    } else {
                        groupMap.put(cluster.name, cluster.hash)
                    }

                }
            }
            if(count > 0){
                msg3.put("msg", "${message(code:'alert.group.pendencies.found')} ")
                msg3.put("msg2", "${message(code:'alert.click.here.to.visualize')}")
                msg3.put("data", groupMap)
            }
        }


        if(session.license.isAdmin()){
            result =  mongoService.getPendencyOnInstitutionCadastre(0,0,0,-1)
            if(result != null && !result.isEmpty()){
                link = 'admin/pendencies'
                count = 1
                msg = "${message(code:'alert.pendencies.found')} "
                msg2 = "${message(code:'alert.click.here.to.visualize')}"
            }
        }else if(session.license.isStudent()){
            result = mongoService.getPendencyListByProfileCreated(Profile.findByUser(session.license.user).id,0,0,0,Pendency.KIND_DOCUMENT_MASTER)
            if(result != null && !result.isEmpty()){
                id = result.id[0]
                link = 'manager/pendency/' + id
                count = 1
                msg = "${message(code:'alert.document.master.pendent')}"
                msg2 = "${message(code:'alert.click.here.to.send')}"
            }
            result =  mongoService.getPendencyListByProfileCreated(Profile.findByUser(session.license.user).id,0,0,0,Pendency.KIND_DOCUMENT_INSTITUTION)
            if(result != null && !result.isEmpty()){
                id = result.id[0]
                link = 'manager/institutionPendency/' + id
                count = 1
                msg = "${message(code:'alert.document.institution.pendent')}"
                msg2 = "${message(code:'alert.click.here.to.send')}"
            }
        }else if(session.license.isAdminInst()){
            result = mongoService.getPendencyListByInstitution(session.license.institution.id,0,0,0,Pendency.KIND_CADASTRE_MASTER)
            if(result != null && !result.isEmpty()){
                link = 'manager/pendencies'
                count = 1
                msg = "${message(code:'alert.pendencies.found')} "
                msg2 = "${message(code:'alert.click.here.to.visualize')}"
            }
        }
        render (contentType: 'application/json') {
            [count: count, link: link, msg: msg, msg2: msg2, msg3: msg3]
        }
    }

    def addDocument = {
        String statusReturn = mongoService.appendDocumentInPendency(params.id,params.document)? 'ok' : 'error'
        render (contentType: 'application/json') {
            [status: statusReturn]
        }

    }

    def limeira = {
        emailService.institutionAcceptedMessage("limeira@ufac.br", "Manoel Limeira de Lima Júnior", "UFAC - Universidade Federal do Acre")
        emailService.institutionAcceptedMessage("galvao@icomp.ufam.edu.br", "Leandro Silva Galvão de Carvalho", "Universidade Federal do Amazonas")
        render("Limeira")
    }

    def requestGroupInvite = {
        Cluster group = Cluster.get(params.id)
        def createPendency = !(params.accessKey && !params.accessKey.isEmpty() && group.accessKey && (group.accessKey == params.accessKey))
        if (!createPendency) {
            ClusterPermissions permission = ClusterPermissions.findByUserAndGroup(session.license.user, group)
            Institution institution = group.institution
            def data = licenseService.getPackInfo(institution)

            if(!permission && (data.get("TOTAL") - data.get("USED")) > 0) {
                permission = new ClusterPermissions()
                permission.user = session.license.user
                permission.group = group
                permission.permission = 0
                if(permission.save()){
                    memcachedService.delete("packinfo-params:${institution.id}")
                    Questionnaire.updateUserQuestionnaireList(permission)
                    Profile profile = Profile.findByUser(permission.user)
                    if(!profile.institution){
                        profile.institution = permission.group.institution
                        profile.save()
                    }
                    redirect(action: "requestShow", controller: "group", params: [id: group.hash, msg: g.message(code:'group.request.accepted')] )
                }
            } else {
                createPendency = true
            }
        }
        if (createPendency) {
            PendencyGroup groupPendency = new PendencyGroup(Pendency.KIND_STUDENT_REQUEST_INVITE, Pendency.STATUS_WAITING, Profile.findByUser(session.license.user).id, group.id, new Date())
            mongoService.createGroupPendency(groupPendency)
            redirect(action: "requestShow", controller: "group", params: [id: group.hash, msg: g.message(code:'group.request.sended')] )
        }
    }

    def listGroupPendencies = {
        def pendencyList = mongoService.getPendencyListByGroup(Long.parseLong(params.id),0,0,0,-1)
        mongoService.getPendencyListByGroup(Long.parseLong(params.id),0,0,1,-1).each{
            pendencyList.add(it)
        }

        mongoService.getPendencyListByGroup(Long.parseLong(params.id),0,0,2,-1).each{
            pendencyList.add(it)
        }

        Profile tempProfile
        pendencyList.each{
            tempProfile = Profile.get(it.userCreated.id)
            it.userCreated.put('photo',tempProfile.smallPhoto)
            it.userCreated.put('hash',tempProfile.hash)
        }
        render (contentType: 'application/json') {
            pendencyList
        }

    }

    def acceptGroupPendency = {
        String statusReturn = ''
        def pendency = mongoService.getPendency(params.id)
        def group = Cluster.get(pendency.group.id[0])
        ClusterPermissions permission = ClusterPermissions.findByUserAndGroup(Profile.get(pendency.userCreated.id[0]).user, group)
        def data = licenseService.getPackInfo(group.institution)
        def msg
        if ((data.get("TOTAL") - data.get("USED")) > 0) {
            if(!permission){
                permission = new ClusterPermissions()
                permission.user = Profile.get(pendency.userCreated.id[0]).user
                permission.group = Cluster.get(pendency.group.id[0])
                permission.permission = 0
                if(permission.save()){
                    Questionnaire.updateUserQuestionnaireList(permission)
                    Profile profile = Profile.findByUser(permission.user)
                    if(!profile.institution){
                        profile.institution = permission.group.institution
                        profile.save()
                    }
                    emailService.sendGroupAcceptedRequestMessage(profile.user.email, profile.name, permission.group.name)
                    if (mongoService.acceptPendency(params.id)) {
                        msg = [status :'ok', txt : 'Usuário adicionado ao grupo com sucesso']
                    } else {
                        msg = [status :'fail', txt : 'Usuário já se encontra no grupo. Mas ocorreu um erro ao aceitar pendência']
                    }
                } else {
                    msg = [status :'fail', txt : 'Ocorreu um erro ao salvar permissão']
                }

            } else {
                if (mongoService.acceptPendency(params.id)) {
                    msg = [status :'ok', txt : 'Usuário já se encontra no grupo. E pendência foi aceita com sucesso']
                } else {
                    msg = [status :'fail', txt : 'Usuário já se encontra no grupo. Mas ocorreu um erro ao aceitar pendência']
                }
            }
        } else {
            msg = [status :'fail', txt : 'Não há licenças disponíveis']
        }

        render (contentType: 'application/json') {
            msg
        }
    }

    def rejectGroupPendency = {
        String statusReturn =  ''
        def pendency = mongoService.getPendency(params.id)
        def msg
        ClusterPermissions permission = ClusterPermissions.findByUserAndGroup(Profile.get(pendency.userCreated.id[0]).user, Cluster.get(pendency.group.id[0]))
        if(permission){
            if(permission.delete()){
                if (mongoService.rejectPendency(params.id)) {
                    msg = [status :'ok', txt : 'Usuário excluído do grupo com sucesso']
                } else {
                    msg = [status :'fail', txt : 'Usuário excluído do grupo. Mas não foi possível rejeitar pendência']
                }
            } else {
                msg = [status :'fail', txt : 'Não foi possível excluir usuário do grupo']
            }
        } else {
            if (mongoService.rejectPendency(params.id)) {
                msg = [status :'ok', txt : 'Pendência rejeitada com sucesso']
            } else {
                msg = [status :'fail', txt : 'Não foi possível rejeitar pendência']
            }
        }

        render (contentType: 'application/json') {
            msg
        }
    }

}
