package com.thehuxley

import com.thehuxley.container.pendency.Pendency

class   ManagerController {

    def managerService;
    def mongoService;
    def emailService
    def pendencies() { }

    def pendency() {

        if (params.id) {
            def pendency = mongoService.getPendency(params.id)
            if (pendency){
                Institution institution =  Institution.get(pendency.institution.id[0])
                License license = License.findByInstitutionAndType(institution,LicenseType.findByKind(LicenseType.ADMIN_INST))
                return [id: params.id, institutionName: institution.name, institutionAdminName: license.user.name, institutionAdminEmail: license.user.email]
            }
        }

        render(status: 404);
    }

    def institutionPendency() {
        if (params.id) {
            return [id: params.id]
        }
        render(status: 404);
    }

    def save () {
        def pendency = mongoService.getPendencyByRelated(params.id)
        def result = managerService.saveDocument(params,request)
        if (pendency.isEmpty()){
            mongoService.acceptPendency(params.id)
            def relatedPendency = mongoService.getPendency(params.id)
            if (relatedPendency.kind[0] == Pendency.KIND_DOCUMENT_MASTER){
                pendency = new Pendency(Pendency.KIND_CADASTRE_MASTER, Pendency.STATUS_WAITING, relatedPendency.userCreated.id[0], relatedPendency.institution.id[0], new GregorianCalendar().getTime())
                //Pegando instituição relacionada
                Institution institution =  Institution.get(relatedPendency.institution.id[0])
                License license = License.findByInstitutionAndType(institution,LicenseType.findByKind(LicenseType.ADMIN_INST))
                //Enviando email ao professor novo
                emailService.documentTeacherSentMessage(relatedPendency.userCreated.email[0], relatedPendency.userCreated.name[0],institution.name,license.user.name)

                //Email ao admin inst
                emailService.teacherPendencyMessage(license.user.email, license.user.name, relatedPendency.userCreated.name[0])
            } else {
                pendency = new Pendency(Pendency.KIND_CADASTRE_INSTITUTION, Pendency.STATUS_WAITING, relatedPendency.userCreated.id[0], relatedPendency.institution.id[0], new GregorianCalendar().getTime())
                emailService.documentInstitutionSentMessage(relatedPendency.userCreated.email[0], relatedPendency.userCreated.name[0])
            }
            pendency.setRelatedPendency(params.id)
            result.each{
                it.put('url', '/data/images/app/doc/' + it.hash)
                pendency.pushDocument(it.hash)
            }
            mongoService.createPendency(pendency)
        } else {
            result.each{
                it.put('url', '/data/images/app/doc/' + it.hash)
                mongoService.appendDocumentInPendency(pendency.id[0],it.hash)
            }
        }
        render (contentType:"text/json") {
            [files: result]
        }

    }
    def createEmail = {
        [count: params.count]
    }
    def sendEmail = {
        int count = EmailToSend.count()
        ArrayList<Long> idList = new ArrayList<Long>()
        if(params.student){
            LicenseType studentLicenseType = LicenseType.findByKind(LicenseType.STUDENT)
            License.findAllByType(studentLicenseType).each{
                if(!idList.contains(it.user.id)){
                    emailService.sendAdminMessage(it.user.email, it.user.name, params.subject, params.message)
                    idList.add(it.user.id)
                }
            }
        }
        if(params.admin){
            LicenseType adminLicenseType = LicenseType.findByKind(LicenseType.ADMIN_INST)
            License.findAllByType(adminLicenseType).each{
                if(!idList.contains(it.user.id)){
                    emailService.sendAdminMessage(it.user.email, it.user.name, params.subject, params.message)
                    idList.add(it.user.id)
                }
            }
        }
        if(params.master){
            LicenseType masterLicenseType = LicenseType.findByKind(LicenseType.TEACHER)
            License.findAllByType(masterLicenseType).each{
                if(!idList.contains(it.user.id)){
                    emailService.sendAdminMessage(it.user.email, it.user.name, params.subject, params.message)
                    idList.add(it.user.id)
                }
            }
        }
        if(params.anotherBox){
            ShiroUser user = ShiroUser.findByEmail(params.another)
            if(user){
                if(!idList.contains(user.id)){
                    emailService.sendAdminMessage(user.email, user.name, params.subject, params.message)
                    idList.add(user.id)
                }

            }
        }
        count = EmailToSend.count() - count
        redirect(action: "createEmail", params: [count:count])

    }
}