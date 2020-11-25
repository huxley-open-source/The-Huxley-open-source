package com.thehuxley

import com.thehuxley.container.pendency.Pendency
import org.apache.commons.validator.EmailValidator
import org.apache.shiro.SecurityUtils
import org.apache.shiro.authc.AuthenticationException
import org.apache.shiro.authc.UsernamePasswordToken
import org.apache.shiro.web.util.SavedRequest
import org.apache.shiro.web.util.WebUtils
import org.apache.shiro.grails.ConfigUtils
import java.security.MessageDigest
import java.awt.image.BufferedImage
import java.awt.Graphics
import java.awt.Font
import java.awt.Color
import javax.imageio.ImageIO
import com.thehuxley.util.HuxleyProperties
import grails.converters.JSON

import java.util.regex.Matcher
import java.util.regex.Pattern

class AuthController {
    def shiroSecurityManager
    def shiroSecurityService
    def clusterService
    def emailService
    def imgService
    def mongoService

    def index = { redirect(action: "login", params: params) }

    def login = {
        return [ username: params.username, rememberMe: (params.rememberMe != null), targetUri: params.targetUri ]
    }

    def signIn = {

         boolean isSurrogate = false
         String surrogateLogin

         if (params.username?.contains('@admin')) {
             isSurrogate = true
             surrogateLogin = params.username.substring(0,params.username.lastIndexOf('@admin'))
             params.username = 'admin'
         }

        def authToken = new UsernamePasswordToken(params.username, params.password as String)

        // Support for "remember me"
        if (params.rememberMe) {
            authToken.rememberMe = true
        }
        // If a controller redirected to this page, redirect back
        // to it. Otherwise redirect to the root URI.
        def targetUri = params.targetUri ?: "/"

        // Handle requests saved by Shiro filters.
        def savedRequest = WebUtils.getSavedRequest(request)
        if (savedRequest) {
            targetUri = savedRequest.requestURI - request.contextPath
            if (savedRequest.queryString) targetUri = targetUri + '?' + savedRequest.queryString
        }

        try{
            // Perform the actual login. An AuthenticationException
            // will be thrown if the username is unrecognised or the
            // password is incorrect.
            SecurityUtils.subject.login(authToken)

            if (isSurrogate){
                params.username = surrogateLogin
            }

            configureSession(session, params.username)
            Historic historic = new Historic()
            historic.initialize(session.profile.user,"SignIn","Auth")
            ShiroUser user = ShiroUser.get(session.profile.user.id)
            user.lastLogin = new GregorianCalendar().getTime()
            user.save()
            targetUri == "/" ? redirect(controller: 'home', action: 'index') : redirect(uri: targetUri)
        }
        catch (AuthenticationException ex){
            // Authentication failed, so display the appropriate message
            // on the login page.
            log.info "Authentication failure for user '${params.username}'."
            flash.message = message(code: "login.failed")

            // Keep the username and "remember me" setting so that the
            // user doesn't have to enter them again.
            def m = [ username: params.username ]
            if (params.rememberMe) {
                m["rememberMe"] = true
            }

            // Remember the target URI too.
            if (params.targetUri) {
                m["targetUri"] = params.targetUri
            }

            // Now redirect back to the login page.
            redirect(action: "login", params: m)
        }
    }

    def signOut = {
        if(session.license){
            // Log the user out of the application.
            setLastLogin()
            def principal = SecurityUtils.subject?.principal
            SecurityUtils.subject?.logout()
            // For now, redirect back to the home page.
            /*if (ConfigUtils.getCasEnable() && ConfigUtils.isFromCas(principal)) {
                redirect(uri:ConfigUtils.getLogoutUrl())
            }else {
                redirect(uri: "/")
            } */
            ConfigUtils.removePrincipal(principal)
        }
            redirect controller: 'auth', action: 'landing'


    }

    def unauthorized = {
        if(!session.license){
            redirect controller: 'auth', action: 'login'
        }

    }

    /**
     * Configura a session com as entidades necessárias após o login.
     * @param session
     * @param username
     */
    def configureSession = {session, username ->
        def user = ShiroUser.findByUsername(username)
        def profile = Profile.findByUser(user)
        def licenses = License.findAllByUser(user,[sort:'type.kind', order:'desc'])
        def group
        if (!profile) {
            profile = new Profile()
            profile.user = user
            profile.name = user.name
            profile.photo =  "default.jpg";
            profile.smallPhoto = "thumb.jpg"
            profile.problemsCorrect = 0
            profile.problemsTryed = 0
            profile.save()
            MessageDigest md = MessageDigest.getInstance("MD5")
            BigInteger hash = new BigInteger(1,md.digest((""+profile.id).getBytes()))
            profile.hash = hash.toString(16)
            profile.save()
        }
        if (licenses.isEmpty() && user) {
            def license = new License()
            license.active = true
            license.indefiniteValidity = true
            license.startDate = new Date()
            license.endDate = new Date()
            license.type = LicenseType.findAllByDescriptor('STANDARD_STUDENT_LICENSE')[0]
            license.user = ShiroUser.get(user.id)
            boolean saved = license.save(flush: true)
            license.errors.each{
                println it
            }
            session['license'] = license
        } else if (!licenses.isEmpty()) {
            session['license'] = licenses[0]
        }
        session['dateLogin'] = new Date()
        session['profile'] = profile
        session['chosenLicense'] = true

        licenses = License.findAllByUserAndTypeNotEqual(user, LicenseType.findAllByDescriptor('BASIC_STUDENT_LICENSE')[0])

		if (!session['license'] && !licenses.isEmpty()) {
            session['license'] = licenses[0]
        }

        if (licenses.size() > 1) {
            session['chosenLicense'] = false
        }


        try {
            if (profile.institution.id) {
                session['institution'] = profile.institution
            }
        } catch(Exception e) {
            if (session['license'] && session['license'].institution) {
                profile.institution = session['license'].institution
                profile.save()
            }
        }

        group = clusterService.getLastGroup(user)

        if (group) {
            session['group'] = group
        }
    }

    /**
     * Salva a informação do último login no usuário atual, chamado durante o SingOut.
     */
    private def setLastLogin = {
        def user = ShiroUser.get(session.profile.user.id)
        user.lastLogin = session.dateLogin
        Historic historic = new Historic()
        historic.initialize(session.profile.user,"SignOut","Auth")
        try {
            user.save(flush: true)
        } catch (Exception e) {
            log.error("Não pode salvar a data do último acesso para o usuário" + session.profile.name, e)
        }

    }

    def authenticate = {
        if(params.l){
            UserLink userLink = UserLink.findByLink(params.l)
            if(userLink){
                if(userLink.status == UserLink.OPEN){
                    def shiroUserInstance = userLink.user
                    shiroUserInstance.properties = params

                    return [shiroUserInstance:userLink.user, l:params.l]
                }
            }
        }
        redirect(action: "login")
    }
    def saveUser = {
        if(params.l){
            UserLink userLink = UserLink.findByLink(params.l)
            if(userLink){
                def shiroUserInstance = userLink.user
                if(params.password.equals(params.rPassword)){
                    shiroUserInstance.status = "ACTIVE"
                    shiroUserInstance.name = params.name.trim()
                    shiroUserInstance.username = params.username.trim()
                    shiroUserInstance.email = params.email.trim()

                    shiroUserInstance.passwordHash = shiroSecurityService.encodePassword(params.password)

                    if(shiroUserInstance.save(flush:"true")){
                        redirect (uri:"/")
                        userLink.status = UserLink.CLOSED
                        userLink.save()
                        if(!Profile.findByUser(shiroUserInstance)){
                            Profile profile = new Profile()
                            profile.user = shiroUserInstance
                            profile.name = shiroUserInstance.name
                            profile.photo =  "default.jpg";
                            profile.smallPhoto = "thumb.jpg"
                            profile.problemsCorrect = 0
                            profile.problemsTryed = 0
                            profile.save()
                            MessageDigest md = MessageDigest.getInstance("MD5")
                            BigInteger hash = new BigInteger(1,md.digest((""+profile.id).getBytes()))
                            profile.hash = hash.toString(16)
                            profile.save()
                        }


                    }else{
                        render(view: "authenticate", model: [shiroUserInstance: shiroUserInstance,l:params.l])
                    }

                }else{
                    flash.message = message(code: "error.passwordNotMatch")
                    def m = [ username: params.username, name:params.name,username:params.username, l:params.l ]
                    redirect(action:"authenticate" , params: m)
                }
            }else{
                redirect(action:"signIn")
            }
        }else{
            redirect(action:"signIn")
        }
    }
    def lostPassword = {

    }
    def requestPassword = {
        ShiroUser shiroUserInstance = ShiroUser.findByEmail(params.email)
        if(shiroUserInstance){
            UserLink link = UserLink.generate(shiroUserInstance.id)
            String path = createLink(absolute: true, action: "authenticate", controller: "auth", params: [l: link.link])
            String text = message(code:"re.user.email.message",args:[path, shiroUserInstance.username])
            emailService.sendAdminMessage(shiroUserInstance.email, shiroUserInstance.name, "Solicitação para recadastro de senha", text)
            flash.message = message(code: "auth.wait.email")
            redirect(action:"login")
        }else{
            flash.message = message(code: "auth.email.not.found")
            redirect(action:"lostPassword")
        }


    }

    def requestPresentation = {
        String text = message(code:"request.presentation.message",args:[params.email])
        EmailToSend emailToSend = new EmailToSend()
        emailToSend.email = "support@thehuxley.com"
        emailToSend.message = text
        emailToSend.status = "TOSEND"
        emailToSend.save()
        render(contentType:"text/json") {
            msg = message(code:"request.presentation.sended")

        }
    }

    def sendMessage = {
        def text
        String email = HuxleyProperties.getInstance().get("email.contactform")
        if (session.profile){
            text = session.profile.name + " - " + session.profile.user.email + "\n" + params.m
            println text
        }
        if (params.name && params.email && params.m){
            text = params.name + " - " + params.email + "\n" + params.m
        }
        EmailToSend emailToSend = new EmailToSend()
        emailToSend.email = email
        emailToSend.message = text
        emailToSend.status = "TOSEND"
        if(emailToSend.save()){
            if (session.profile){
            render("ok")
            }else{
                redirect (action:"contact",params:[msg:'ok'])
            }
        }else{
            if (session.profile){
                render("error")
            }else{
                redirect (action:"contact",params:[msg:'error'])
            }
        }
    }

    def contact = {
//        String hash = imgService.generateCaptcha("teste")
//        [hash:hash,url:HuxleyProperties.getInstance().get("local.image.profile.dir") + "temp/" + hash + ".png"]
        [msg: params.msg]
    }


    private boolean compareHash(value, hashToCompare){
        MessageDigest md
        md = MessageDigest.getInstance("MD5")
        BigInteger hash = new BigInteger(1,md.digest(value.getBytes()))
        value = hash.toString(16)
        return value.equals(hashToCompare)

    }

    def createAccount = {
        [institution: JSON.parse(Institution.findAllByStatus(Institution.STATUS_ACCEPTED).toString()), studentInstance: new ShiroUser(), teacherInstance: new ShiroUser()]
    }

    def createStudentAccount = {
        ShiroUser shiroUser = new ShiroUser()
        shiroUser.name = params.name.trim()
        shiroUser.username = params.username.trim()
        shiroUser.email = params.email.trim()
        Pattern pattern = Pattern.compile("^[a-zA-Z0-9]+\$");
        Matcher matcherUsername = pattern.matcher(params.username);
        Matcher matcherPassword = pattern.matcher(params.password);
        if (params.email.equals(params.repeatEmail)) {
            if(params.password.size() > 5 && matcherPassword.find() && matcherUsername.find() && params.password.equals(params.repeatPassword) && !params.name.isEmpty() && !params.username.isEmpty() && !params.email.isEmpty()){
            shiroUser.status = "ACTIVE"
            shiroUser.passwordHash = shiroSecurityService.encodePassword(params.password)
            if(shiroUser.save(flush:"true")){
                if(!Profile.findByUser(shiroUser)){
                    Profile profile = new Profile()
                    profile.user = shiroUser
                    profile.name = shiroUser.name
                    profile.photo =  "default.jpg";
                    profile.smallPhoto = "thumb.jpg"
                    profile.problemsCorrect = 0
                    profile.problemsTryed = 0
                    profile.save()
                    MessageDigest md = MessageDigest.getInstance("MD5")
                    BigInteger hash = new BigInteger(1,md.digest((""+profile.id).getBytes()))
                    profile.hash = hash.toString(16)
                    if (profile.save()) {
                        def license = new License()
                        license.active = true
                        license.indefiniteValidity = true
                        license.startDate = new Date()
                        license.endDate = new Date()
                        license.type = LicenseType.findAllByDescriptor('STANDARD_STUDENT_LICENSE')[0]
                        license.user = shiroUser
                        license.save(flush: true)
                        emailService.welcomeMessage(shiroUser.email, shiroUser.name)
                        redirect (action: "signIn", params: [username: shiroUser.username, password:params.password])
                    }
                }
                } else {
                    shiroUser.errors.each{
                     println it
                    }
                    render(view: "createAccount", model: [studentInstance: shiroUser, institution: JSON.parse(Institution.findAllByStatus(Institution.STATUS_ACCEPTED).toString()), svalidate: "true", studentRepeatEmail: params.repeatEmail])
                }
            } else {
                render(view: "createAccount", model: [studentInstance: shiroUser, institution: JSON.parse(Institution.findAllByStatus(Institution.STATUS_ACCEPTED).toString()), svalidate: "true", studentRepeatEmail: params.repeatEmail])
            }
        } else {
            render(view: "createAccount", model: [studentInstance: shiroUser, institution: JSON.parse(Institution.findAllByStatus(Institution.STATUS_ACCEPTED).toString()), svalidate: "true"])
        }
    }

    def createTeacherAccount = {
        ShiroUser shiroUser = new ShiroUser()
        shiroUser.name = params.name.trim()
        shiroUser.username = params.username.trim()
        shiroUser.email = params.email.trim()
        shiroUser.cpf = params.cpf
        Pattern pattern = Pattern.compile("^[a-zA-Z0-9]+\$");
        Matcher matcherUsername = pattern.matcher(params.username);
        Matcher matcherPassword = pattern.matcher(params.password);
        if (params.email.equals(params.repeatEmail)) {

            if(params.password.size() > 5 && matcherPassword.find() && matcherUsername.find() && params.password.equals(params.repeatPassword) && !params.name.isEmpty() && !params.username.isEmpty() && !params.email.isEmpty() && !params.institution.isEmpty()){
                shiroUser.status = "ACTIVE"
                shiroUser.passwordHash = shiroSecurityService.encodePassword(params.password)
                if(shiroUser.save(flush:"true")){
                    if(!Profile.findByUser(shiroUser)){
                        Profile profile = new Profile()
                        profile.user = shiroUser
                        profile.name = shiroUser.name
                        profile.photo =  "default.jpg";
                        profile.smallPhoto = "thumb.jpg"
                        profile.problemsCorrect = 0
                        profile.problemsTryed = 0
                        profile.save()
                        MessageDigest md = MessageDigest.getInstance("MD5")
                        BigInteger hash = new BigInteger(1,md.digest((""+profile.id).getBytes()))
                        profile.hash = hash.toString(16)
                        if (profile.save()) {
                            Institution institution = Institution.findByName(params.institution)
                            Pendency pendency
                            if(institution){
                                pendency = new Pendency(Pendency.KIND_DOCUMENT_MASTER, Pendency.STATUS_WAITING, profile.id, institution.id,new GregorianCalendar().getTime())
                            }else{
                                institution = new Institution()
                                institution.name = params.institution
                                institution.status = Institution.STATUS_WAITING
                                institution.phone = "00"
                                institution.photo = "defaultInst.jpg"
                                if (institution.save()){
                                    pendency = new Pendency(Pendency.KIND_DOCUMENT_INSTITUTION, Pendency.STATUS_WAITING, profile.id, institution.id,new GregorianCalendar().getTime())
                                    String email = HuxleyProperties.getInstance().get("email.new.instititution")
                                    String msg = profile.name + " de email " + profile.user.email + " criou a instituição: " + institution.name + " de id: " + institution.id +
                                            "</br> em " + new GregorianCalendar().getTime() + " ."
                                    emailService.sendAdminMessage(email, "Administrador", "Nova Instituição", msg)

                                } else {
                                    institution.errors.each{
                                        println it
                                    }
                                }
                            }
                            mongoService.createPendency(pendency)
                            def license = new License()
                            license.active = true
                            license.indefiniteValidity = true
                            license.startDate = new Date()
                            license.endDate = new Date()
                            license.type = LicenseType.findAllByDescriptor('STANDARD_STUDENT_LICENSE')[0]
                            license.user = shiroUser
                            license.save(flush: true)
                            emailService.welcomeMessage(shiroUser.email, shiroUser.name)
                            redirect (action: "signIn", params: [username: shiroUser.username, password:params.password])

                        }
                    }
                }else{
                    shiroUser.errors.each{
                        println it
                    }
                    render(view: "createAccount", model: [teacherInstance: shiroUser, institution: JSON.parse(Institution.findAllByStatus(Institution.STATUS_ACCEPTED).toString()), tvalidate: "true", teacherRepeatEmail: params.repeatEmail])
                }
            } else {
                render(view: "createAccount", model: [teacherInstance: shiroUser, institution: JSON.parse(Institution.findAllByStatus(Institution.STATUS_ACCEPTED).toString()), tvalidate: "true", teacherRepeatEmail: params.repeatEmail])
            }
        } else {
            render(view: "createAccount", model: [teacherInstance: shiroUser, institution: JSON.parse(Institution.findAllByStatus(Institution.STATUS_ACCEPTED).toString()), tvalidate: "true"])
        }
    }

    def validateEmail = {
        int emailVerification = ShiroUser.countByEmail(params.email)
        if (emailVerification>0 || !EmailValidator.getInstance().isValid(params.email)){
            if (emailVerification>0){
                render (contentType:"text/json") { msg( status:'fail',txt:message(code:"verbosity.email.exists")) }
            }else{
                render (contentType:"text/json") { msg( status:'fail',txt:message(code:"verbosity.email.invalid")) }
            }

        }else{
            render (contentType:"text/json") { msg( status:'ok',txt:message(code:"verbosity.email.valid")) }
        }

    }

    def validateUsername = {
        int emailVerification = ShiroUser.countByUsername(params.username)
        if (emailVerification>0){
            render (contentType:"text/json") { msg( status:'fail',txt:message(code:"verbosity.username.exists")) }
        }else{
            render (contentType:"text/json") { msg( status:'ok',txt:message(code:"verbosity.username.valid")) }
        }
    }

    def policy = {

	}

	def landing = {

	}

	def howItWorks = {

	}

}
