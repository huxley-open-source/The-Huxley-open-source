package com.thehuxley

import java.text.SimpleDateFormat
import grails.converters.JSON

class LicenseController {

    def licenseService
    def userService
    def index() { }

    def manage() {

        def licenseTypeList
        if(session.license.isAdmin()){
            licenseTypeList = licenseService.getTotalLicenseType();
        }
        if(session.license.isAdminInst()){
            licenseTypeList = licenseService.getTotalLicenseTypeByInstitution(session.license.institution.id)
        }


        [licenseTypeList: licenseTypeList, sMsg:params.sMsg,eMsg:params.eMsg]
    }

    def list = {

        def licenseList
        HashMap searchParams = new HashMap()
        if(session.license.isAdminInst()){
            searchParams.put("INSTITUTION",session.license.institution.id)
        }
        searchParams.put("TYPE",params.t)
        searchParams.put("LIMIT", 5)
        searchParams.put("OFFSET", 0)
        def results = licenseService.getLicense(searchParams)
        [licenseList: results.get("RESULT"), total: results.get("TOTAL"),t:params.t]
    }

    def search = {
        HashMap searchParams = new HashMap()
        if(session.license.isAdminInst()){
            searchParams.put("INSTITUTION",session.license.institution.id)
        }
        if(params.name && !params.name.isEmpty()){
            searchParams.put("NAME",params.name)
        }
        searchParams.put("TYPE",params.t)
        searchParams.put("LIMIT", params.max)
        searchParams.put("OFFSET", params.offset)
        def result = licenseService.getLicense(searchParams)

        render(contentType:"text/json") {
            licenses = array {
                result.get("RESULT").each{
                     license content:huxley.userBox( user:it.user,position:"false", score:"false", email:"true") , hash : it.hash, profile: Profile.findByUser(it.user), email: it.user.email
                }
            }
            total = result.get("TOTAL")
        }

    }

    def create = {
        def instInstance

        instInstance = session.license.institution

        [instInstance: instInstance]
    }

    def edit = {

        def licenseInstance = new License()

        if (params.h) {
            licenseInstance = License.findByHash(params.h)
        } else {
            redirect(action: 'create')
        }

        [licenseInstance: licenseInstance]
    }

    def save = {
        def userList = ""
        def institutionId = 0
        def kind = 2
        def institution = ""
        if (params.kind.equals("STUDENT")){
            kind = 2
        }
        if (params.kind.equals("TEACHER")){
            kind = 3
        }
        if (params.kind.equals("ADMININST")){
            kind = 5
        }
        def licenseToDelete
        def usersToAdd
        if(session.license.isAdminInst()){
            institutionId = session.license.institution.id
        }else{
            institutionId = params.institutionId
        }
        if(!params.sList.isEmpty()){
            String userIdList = "(" + params.sList + ")"
            userList = ShiroUser.executeQuery("Select s from ShiroUser s where s.id in " + userIdList)
            licenseToDelete = License.executeQuery("Select l from License l where l.institution.id = " + institutionId + " and l.type.id = " + kind + " and l.user.id not in " + userIdList)
            usersToAdd = License.executeQuery("Select s from ShiroUser s where s.id in " + userIdList + " and s.id not in (Select l.user.id from License l where l.institution.id =" + institutionId + " and l.type.id = " + kind + ")")
        }else{
            licenseToDelete = License.executeQuery("Select l from License l where l.institution.id =" + institutionId + " and l.type.id = " + kind)
        }
        licenseToDelete.each{
            it.delete()
        }
        usersToAdd.each{
            def licenseInstance = new License()
            licenseInstance.active = true
            licenseInstance.institution = Institution.get(institutionId)
            licenseInstance.indefiniteValidity = true
            licenseInstance.startDate = new Date()
            licenseInstance.endDate = new Date()
            licenseInstance.user = it
            if(kind == 2){
                licenseInstance.type = LicenseType.findByKind(LicenseType.STUDENT)
            }else if (kind == 3){
                licenseInstance.type = LicenseType.findByKind(LicenseType.TEACHER)
            }else if (kind == 5){
                licenseInstance.type = LicenseType.findByKind(LicenseType.ADMIN_INST)
            }
            licenseInstance.save()


        }
        redirect(action:'manage',params: [sMsg:message(code:"verbosity.updated2",args:[message(code:"entity.license")])])

    }

    def reloadPermission = {
        def permissionHandler = PermissionHandler.getInstance()
        permissionHandler.reloadPermissions()
    }

    def checkPermission = {
        def permissionHandler = PermissionHandler.getInstance()

        render([
                license: params.l,
                controller: params.c,
                action: params.a,
                allowed: permissionHandler.checkPermission(params.l, params.c, params.a)
            ] as JSON)

    }

    def getUserBoxRightList = {
        def institutionId = 0
        def kind = 2
        if (params.kind.equals("STUDENT")){
            kind = 2
        }
        if (params.kind.equals("TEACHER")){
            kind = 3
        }
        if (params.kind.equals("ADMININST")){
            kind = 5
        }
        if(session.license.isAdminInst()){
            institutionId = session.license.institution.id
        }else{
            institutionId = Long.parseLong(params.institutionId)
        }
        render(contentType:"text/json") {
            content = huxley.userDLCRightBox( license: institutionId, kind: kind, position:"false", score:"false", email:"true", institution: "false")
            selectedIdList = Profile.executeQuery("Select Distinct l.user.id from License l where l.institution.id = " + institutionId + " and l.type.id = " + kind)
        }
    }

    def remove = {
        def msgText
        def license = License.findByHash(params.hash)
        if (license){
            if (session.license.isAdmin() || (session.license.isAdminInst() && session.license.institution.id == license.institution.id)){
                try{
                    ClusterPermissions.executeQuery("select cp from ClusterPermissions cp where cp.user.id = :user and cp.group.institution.id = :institution and permission > 0", [user:license.user.id, institution: license.institution.id]).each {
                        it.delete()
                    }
                    license.delete()
                    msgText = message(code:"verbosity.deleted2",args:[message(code:"entity.license2")])
                    render(contentType:"text/json") {
                        msg( status:'ok', txt:msgText )
                    }
                }catch (e){
                    msgText = message(code:"verbosity.error.on.delete")
                    render(contentType:"text/json") {
                        msg( status:'fail', txt:msgText )
                    }
                }
            }else{
                msgText = message(code:"verbosity.unauthorized.message")
                render(contentType:"text/json") {
                    msg( status:'fail', txt:msgText )
                }
            }
        }else{
            msgText = message(code:"verbosity.not.found2",args:[message(code:"entity.license2")])
            render(contentType:"text/json") {
                msg( status:'fail', txt:msgText )
            }
        }

    }

    def askLicense = {
        def ask = !session.chosenLicense
        render(contentType:"text/json") {
            [ask: ask, kind: session.license.type.kind]
        }
    }

    def listByUser = {

        def licenseList = License.findAllByUser(session.license.user,[sort:'type.kind', order:'desc'])
        def licensesToShow = []

        licenseList.each {
            def map = [id: it.id, type: it.type.name, kind: it.type.kind, institutionName: it.institution?.name, selected: session.license.id == it.id]

            licensesToShow.add(map)
        }



        render(contentType:"text/json") {
            licensesToShow
        }
    }

    def manageTeacher = {
    }

    def manageAdmin = {
        [institutionList:Institution.findAllByStatus(Institution.STATUS_ACCEPTED)]
    }

    def addTeacher = {
        Institution institution = Institution.get(session.license.institution.id)
        //def data = licenseService.getPackInfo(institution)
        def msg
        ShiroUser user = ShiroUser.findByEmail(params.email)
        def permission
        def licenseInstance
        if (user) {
            permission = ClusterPermissions.executeQuery("Select cp from ClusterPermissions cp where cp.user.id = :user and cp.group.institution.id = :institution", [user:user.id, institution: institution.id])
            licenseInstance = License.findWhere(type: LicenseType.findByKind(LicenseType.TEACHER), user: user, institution: institution)
        }
        //if (licenseInstance || permission || (data.get("TOTAL") - data.get("USED")) > 0) {
            if (!user) {
                if (userService.saveUser(params.email,params.email,[],[],request,[0,1,0],institution.id, false)) {
                    msg = [status: 'ok', txt: 'Usuário não cadastrado, convite enviado']
                } else {
                    msg = [status: 'fail', txt: 'Não foi possível enviar o convite']
                }
            } else {
                if (!licenseInstance) {
                    licenseInstance = new License()
                    licenseInstance.active = true
                    licenseInstance.institution = institution
                    licenseInstance.indefiniteValidity = true
                    licenseInstance.startDate = new Date()
                    licenseInstance.endDate = new Date()
                    licenseInstance.user = user
                    licenseInstance.type = LicenseType.findByKind(LicenseType.TEACHER)
                    if (licenseInstance.save()) {
                        msg = [status: 'ok', txt: 'Licença Adicionada com sucesso']
                    } else {
                        msg = [status: 'fail', txt: 'Houve um erro ao tentar adicionar licença']
                    }
                } else {
                    msg = [status: 'fail', txt: 'Usuário já possui uma licença de professor']
                }
            }
            user = ShiroUser.findByEmail(params.email)
            if (user) {
                if (params.group) {
                    if(msg.txt) {
                        msg.txt +='. '
                    }
                    Cluster group = Cluster.get(params.group)
                    if (group) {
                        if(!ClusterPermissions.findByUserAndGroup(user,group)){
                            ClusterPermissions clusterPermission = new ClusterPermissions()
                            clusterPermission.user = user
                            clusterPermission.group = group
                            clusterPermission.permission = 30
                            if (clusterPermission.save()) {
                                msg = [status: 'ok', txt: msg.txt + 'Professor adicionado ao grupo']
                            } else {
                                msg = [status: 'fail', txt: msg.txt + 'Mas ocorreu um erro ao adicionar ao grupo']
                            }
                        } else {
                            msg = [status: 'fail', txt: msg.txt + 'Usuário já está registrado como professor do grupo']
                        }
                    } else {
                        msg = [status: 'fail', txt: msg.txt + 'Mas o grupo não existe']
                    }
                }
            }
        /*} else {
            msg = [status: 'fail', txt: 'Não há licenças disponíveis']
        }  */

        render(contentType:"text/json") {
            msg
        }
    }

    def addAdminInst = {
        Institution institution = Institution.get(params.institution)
        def msg
        ShiroUser user = ShiroUser.findByEmail(params.email)
            if (!user) {
                if (userService.saveUser(params.email,params.email,[],[],request,[0,0,1],institution.id, false)) {
                    msg = [status: 'ok', txt: 'Usuário não cadastrado, convite enviado']
                } else {
                    msg = [status: 'fail', txt: 'Não foi possível enviar o convite']
                }
            } else {
                def licenseInstance = License.findWhere(type: LicenseType.findByKind(LicenseType.ADMIN_INST), user: user, institution: institution)
                if (!licenseInstance) {
                    licenseInstance = new License()
                    licenseInstance.active = true
                    licenseInstance.institution = institution
                    licenseInstance.indefiniteValidity = true
                    licenseInstance.startDate = new Date()
                    licenseInstance.endDate = new Date()
                    licenseInstance.user = user
                    licenseInstance.type = LicenseType.findByKind(LicenseType.ADMIN_INST)
                    if (licenseInstance.save()) {
                        msg = [status: 'ok', txt: 'Licença Adicionada com sucesso']
                    } else {
                        msg = [status: 'fail', txt: 'Houve um erro ao tentar adicionar licença']
                    }
                } else {
                    msg = [status: 'fail', txt: 'Usuário já possui uma licença de professor']
                }

            }
            user = ShiroUser.findByEmail(params.email)
            if (user) {
                if (params.group) {
                    if(msg.txt) {
                        msg.txt +='. '
                    }
                    Cluster group = Cluster.get(params.group)
                    if (group) {
                        if(!ClusterPermissions.findByUserAndGroup(user,group)){
                            ClusterPermissions clusterPermission = new ClusterPermissions()
                            clusterPermission.user = user
                            clusterPermission.group = group
                            clusterPermission.permission = 30
                            if (clusterPermission.save()) {
                                msg = [status: 'ok', txt: msg.txt + 'Professor adicionado ao grupo']
                            } else {
                                msg = [status: 'fail', txt: msg.txt + 'Mas ocorreu um erro ao adicionar ao grupo']
                            }
                        } else {
                            msg = [status: 'fail', txt: msg.txt + 'Usuário já está registrado como professor do grupo']
                        }
                    } else {
                        msg = [status: 'fail', txt: msg.txt + 'Mas o grupo não existe']
                    }
                }
            }


        render(contentType:"text/json") {
            msg
        }
    }

    def getLicensePackInfo = {
        def institution = session.license.institution
        if (params.groupId && !params.groupId.isEmpty()) {
            institution = Cluster.get(params.groupId).institution
        }
        render(contentType:"text/json") {

            licenseService.getPackInfo(institution)
        }
    }

    def createLicensePack = {
        def msg = [status: 'ok']
        try{
            def pack =  new LicensePack()
            def dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm")
            pack.institution = Institution.get(params.id)
            pack.total = Integer.parseInt(params.total)
            pack.startDate = dateFormat.parse(params.startDate + " 00:00")
            pack.endDate = dateFormat.parse(params.endDate + " 00:00")
            if (!pack.save()) {
                msg.status = 'fail'
            }
        } catch (e) {
            msg.status = 'fail'
        }
        render(contentType: "text/json") {
            msg
        }
    }


}
