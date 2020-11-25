package com.thehuxley

import grails.converters.JSON
import org.apache.shiro.SecurityUtils
import org.apache.shiro.authc.AuthenticationException
import org.apache.shiro.authc.UsernamePasswordToken


class ProfileController {

    def profileService
    def groupService
    def imgService
    def shiroSecurityService
    def questService
    def memcachedService

    def index() {
    }

    def uploadImage = {
        String name = imgService.uploadImage(params,request)
        render (contentType:"text/json") {
            data = name
        }

    }


    def show = {
      Profile profile
        if (params.id){
            profile = Profile.findByHash(params.id)
        } else  if(params.user){
            profile = Profile.findByUser(ShiroUser.get(params.user))
        } else {
            profile = Profile.findByUser(session.license.user)
        }
        if(profile){
            ArrayList<QuestionnaireShiroUser> questList = questService.getUserQuest(profile.user.id).get("LIST")
            ArrayList<UserProblem> probList = UserProblem.findAllByUser(profile.user)
            [profile:profile,questList:questList,probList:probList, groupList:groupService.listGroupPosition(profile.user.topCoderPosition,profile.user.id)]
        } else {
            response.sendError(404)
        }

    }

    def getDataForChart = {
        def result = memcachedService.get("data-chart-$params.id", 7 * 24 * 60 * 60) {
            Map mapData = profileService.mountDataForChart(params.id)
            ArrayList<String> categoriesList  = new ArrayList<String>()
            ArrayList<String> dataList  = new ArrayList<String>()
            mapData.keySet().each{
                categoriesList.add(it)
                dataList.add(mapData.get(it))
            }

            ([data: dataList, categories: categoriesList] as JSON) as String
        }

        render(contentType:"text/json") {
            JSON.parse(result)
        }
    }

    def create = {
        Profile profileInstance
        def institutionList = []

        ClusterPermissions.findAllByUser(session.profile.user).each {
            if (it.group.institution && !institutionList.contains(it.group.institution)) {
                institutionList.add(it.group.institution)
            }    
        }

        if(session.profile){
            profileInstance = session.profile
        }
        [profileInstance:profileInstance, institutionList : institutionList]
    }

    def changePassword = {
        Profile profileInstance = session.profile
        if(params.msg){
            [profileInstance:profileInstance, msg:params.msg]
        }else{
            [profileInstance:profileInstance]
        }

    }

    def save = {
        println '>>>>>>> ' + params
        Profile profile = Profile.get(session.profile.id)
        if((!profile.photo.equals(params.profilePhoto))){
            println "oi: >>>" + params.profilePhoto
            imgService.chooseImg(params.profilePhoto)
        }
        if (!profile.name.equals(params.name)){
            Historic historic = new Historic()
            historic.initialize(session.profile.user,"ChangeName: " + profile.name + " -> " + params.name,"Profile")
        }
        profile.name = params.name
        profile.photo = params.profilePhoto
        profile.smallPhoto = params.profilePhoto
        profile.institution = Institution.get(params.institution)
        if(profile.save()){
            ShiroUser user = profile.user
            if ((user.email != params.email) ||
                    (user.name != params.name) ||
                    (user.username != params.username)) {
            user.email = params.email
            user.name = params.name
            user.username = params.username
            if (user.save()) {
                Submission.executeUpdate("update Submission s set s.cacheUserUsername = :username, s.cacheUserName = :name, s.cacheUserEmail = :email where s.user.id = :id", [username: user.username, name: user.name, email: user.email, id: user.id])
            }

            }

        }
        session.profile = profile

        redirect (action: "show")
    }

    def savePassword = {
        try{
            def authToken = new UsernamePasswordToken(session.profile.user.username, params.password as String)
            // Perform the actual login. An AuthenticationException
            // will be thrown if the username is unrecognised or the
            // password is incorrect.
            SecurityUtils.subject.login(authToken)
            if(params.newPassword.equals(params.repeatPassword)){
                ShiroUser user = ShiroUser.get(session.profile.user.id)

                user.passwordHash = shiroSecurityService.encodePassword(params.newPassword)
                user.save()
                session.profile.user = user
            } else {
                redirect(action: "changePassword", params: ["msg":"ERROR2"])
                return
            }
        }
        catch (AuthenticationException ex){
            redirect(action: "changePassword", params: ["msg":"ERROR1"])
            return
        }
        redirect (action: "create")
    }

    def resetInstitution = {
        def profileList = Profile.list()
        profileList.each {
            def license= License.findAllByUser(it.user)[0]

            if (license && license.institution) {
                it.institution = license.institution
                it.save()
            }
        }
    }

    def search = {
        def resultList = ShiroUser.findAllByNameLikeOrEmailLike("%$params.name%", "%$params.name%", [max:params.max, offset: params.offset])
        render(contentType:"text/json") {
            profileList = array {
                resultList.each {
                    userInfo user: it,  profile: Profile.findByUser(it)
                }
            }
        }
    }

    def crop = {
        def msg = [status:'fail']
        def status = false
        try {
            float x = Float.parseFloat(params.x)
            float y = Float.parseFloat(params.y)
            float height = Float.parseFloat(params.height)
            float width = Float.parseFloat(params.width)
            status = imgService.crop(params.image, x, y, width, height)
            println(status)
        } catch (e) {
            println(e)
        }
        params.image = "c" + params.image
        render(contentType:"text/json") {
            [file: params.image, status: status]
        }
    }
}
