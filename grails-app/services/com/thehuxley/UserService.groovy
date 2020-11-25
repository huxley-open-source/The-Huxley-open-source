package com.thehuxley

class UserService {
    def emailService
    def profileService
	def grailsLinkGenerator
    def saveUser(userName,userEmail,tList,sList,request,licenseType,institution,isAdminInst) {
        ShiroUser shiroUserInstance = new ShiroUser([name: userName.trim(), email: userEmail.trim()])
        shiroUserInstance.status = "INACTIVE"
            if (shiroUserInstance.save(flush: true)) {
                UserLink link = UserLink.generate(shiroUserInstance)
				String path = grailsLinkGenerator.link(absolute: true, action: "authenticate", controller: "auth", params: [l: link.link])
                emailService.sendEmail("user.email.message","user.email.message",[shiroUserInstance.name, path],shiroUserInstance.email)
                if(!tList.isEmpty()){
                    Cluster.executeQuery("Select c from Cluster c where c.id in (" + tList + ")").each {
                        ClusterPermissions permission = new ClusterPermissions()
                        permission.user = shiroUserInstance
                        permission.permission = 30
                        permission.group = it
                        permission.save()
                        Questionnaire.updateUserQuestionnaireList(permission)
                    }
                }
                if(!sList.isEmpty()){
                    Cluster.executeQuery("Select c from Cluster c where c.id in (" + sList + ")").each {
                        ClusterPermissions permission = new ClusterPermissions()
                        permission.user = shiroUserInstance
                        permission.permission = 0
                        permission.group = it
                        permission.save()
                        Questionnaire.updateUserQuestionnaireList(permission)
                    }
                }
                //licenseType um array onde cada posição indica que tipos de licença vão ser associadas [estudante,professor,admin inst], valores possíveis 0 e 1
                if(licenseType.get(1)==1){
                    def licenseInstance = new License()
                    licenseInstance.active = true
                    licenseInstance.institution = Institution.get(institution)
                    licenseInstance.indefiniteValidity = true
                    licenseInstance.startDate = new Date()
                    licenseInstance.endDate = new Date()
                    licenseInstance.user = shiroUserInstance
                    licenseInstance.type = LicenseType.findByKind(LicenseType.TEACHER)
                    licenseInstance.save()
                }
                if(licenseType.get(0)==1){
                    def licenseInstance = new License()
                    licenseInstance.active = true
                    if(institution != -1){
                        licenseInstance.institution = Institution.get(institution)
                    }
                    licenseInstance.indefiniteValidity = true
                    licenseInstance.startDate = new Date()
                    licenseInstance.endDate = new Date()
                    licenseInstance.user = shiroUserInstance
                    licenseInstance.type = LicenseType.findByKind(LicenseType.STUDENT)
                    licenseInstance.save()
                }
                if (licenseType.get(2)==1) {
                    def licenseInstanceAdminInst = new License()

                    licenseInstanceAdminInst.active = true
                    licenseInstanceAdminInst.institution = Institution.get(institution)
                    licenseInstanceAdminInst.indefiniteValidity = true
                    licenseInstanceAdminInst.startDate = new Date()
                    licenseInstanceAdminInst.endDate = new Date()
                    licenseInstanceAdminInst.user = shiroUserInstance
                    licenseInstanceAdminInst.type = LicenseType.findByKind(LicenseType.ADMIN_INST)
                    licenseInstanceAdminInst.save()
                }
                return true
            }else {
                shiroUserInstance.errors.each{
                    println it
                }
                return false
            }

    }

    def saveUserWithPermissions(userName,userEmail,tList,sList,request,licenseType,institution,isAdminInst) {
        ShiroUser shiroUserInstance = new ShiroUser([name: userName.trim(), email: userEmail.trim()])
        shiroUserInstance.status = "INACTIVE"
        if (shiroUserInstance.save(flush: true)) {
            UserLink link = UserLink.generate(shiroUserInstance)
            String path = grailLinkGenerator.link(absolute: true, action: "authenticate", controller: "auth", params: [l: link.link])
            emailService.sendEmail("user.email.message","user.email.message",[shiroUserInstance.name, path],shiroUserInstance.email)
            if(!tList.isEmpty()){
                Cluster.executeQuery("Select c from Cluster c where c.id in (" + tList + ")").each {
                    ClusterPermissions permission = new ClusterPermissions()
                    permission.user = shiroUserInstance
                    permission.permission = 30
                    permission.group = it
                    permission.save()
                    Questionnaire.updateUserQuestionnaireList(permission)
                }
            }
            if(!sList.isEmpty()){
                Cluster.executeQuery("Select c from Cluster c where c.id in (" + sList + ")").each {
                    ClusterPermissions permission = new ClusterPermissions()
                    permission.user = shiroUserInstance
                    permission.permission = 0
                    permission.group = it
                    permission.save()
                    Questionnaire.updateUserQuestionnaireList(permission)
                }
            }

            if(licenseType){
                def licenseInstance = new License()
                licenseInstance.active = true
                licenseInstance.institution = Institution.get(institution)
                licenseInstance.indefiniteValidity = true
                licenseInstance.startDate = new Date()
                licenseInstance.endDate = new Date()
                licenseInstance.user = shiroUserInstance
                licenseInstance.type = LicenseType.get(licenseType)
                licenseInstance.save()
            }

            if(!tList.isEmpty()){
                def licenseInstance = new License()
                licenseInstance.active = true
                licenseInstance.institution = Institution.get(institution)
                licenseInstance.indefiniteValidity = true
                licenseInstance.startDate = new Date()
                licenseInstance.endDate = new Date()
                licenseInstance.user = shiroUserInstance
                licenseInstance.type = LicenseType.findByKind(LicenseType.TEACHER)
                licenseInstance.save()
            }
            if(!sList.isEmpty()){
                def licenseInstance = new License()
                licenseInstance.active = true
                licenseInstance.institution = Institution.get(institution)
                licenseInstance.indefiniteValidity = true
                licenseInstance.startDate = new Date()
                licenseInstance.endDate = new Date()
                licenseInstance.user = shiroUserInstance
                licenseInstance.type = LicenseType.findByKind(LicenseType.STUDENT)
                licenseInstance.save()
            }
            if (isAdminInst) {
                def licenseInstanceAdminInst = new License()

                licenseInstanceAdminInst.active = true
                licenseInstanceAdminInst.institution = Institution.get(institution)
                licenseInstanceAdminInst.indefiniteValidity = true
                licenseInstanceAdminInst.startDate = new Date()
                licenseInstanceAdminInst.endDate = new Date()
                licenseInstanceAdminInst.user = shiroUserInstance
                licenseInstanceAdminInst.type = LicenseType.findByKind(LicenseType.ADMIN_INST)
                licenseInstanceAdminInst.save()
            }
            return true
        }else {
            shiroUserInstance.errors.each{
                println it
            }
            return false
        }

    }

    def updateUserPermissions(user,tList,sList){
        tList.each{
            Cluster group = Cluster.get(it)
            ClusterPermissions permission = ClusterPermissions.findByUserAndGroup(user,group)
            if(!permission){
                permission = new ClusterPermissions()
                permission.user = user
                permission.group = group
            }
            permission.permission = 30
            permission.save()
            permission.errors.each{
            }
        }
        sList.each{
            Cluster group = Cluster.get(it)
            ClusterPermissions permission = ClusterPermissions.findByUserAndGroup(user,group)
            if(!permission){
                permission = new ClusterPermissions()
                permission.user = user
                permission.group = group
            }
            permission.permission = 0
            permission.save()
        }
    }

    def publicFields (ShiroUser instance, lazy = false) {
        profileService.publicFields(Profile.findByUser(instance), lazy)
    }

    def publicFields (List<ShiroUser> list, lazy = false) {
        profileService.publicFields(Profile.findAllByUserInList(list), lazy)
    }
}
