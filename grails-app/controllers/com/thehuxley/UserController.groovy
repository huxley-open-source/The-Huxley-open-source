package com.thehuxley

import com.thehuxley.stimulusPredictor.StimulusPredictor
import org.apache.commons.validator.EmailValidator
import grails.converters.JSON

class UserController {
    def userService
    def mongoService
    def index() { }

    def createSingle = {

    }

    def createGroup = {
        [sMsg:params.sMsg,eMsg:params.eMsg]
    }

    def saveSingle = {
        boolean save = false
        if(params.permissionList){
            params.permissionList = "[" + params.permissionList + "]"
        }else{
            params.permissionList = "[0,0,0]"
        }

        ArrayList<String> licenseList = JSON.parse(params.permissionList)
        if(params.institution){
            save = userService.saveUser(params.userName,params.userEmail,params.tList,params.sList,request,licenseList,params.institution, params.adminInst == 'true')
        }else{
            save = userService.saveUser(params.userName,params.userEmail,params.tList,params.sList,request,licenseList,session.license.institution.id, false)
        }
        if (save){
                redirect(uri:"/")
            }else {
                redirect(view: "create")
            }

    }

    def saveGroup = {
        params.userName = "[" + params.userName + "]"
        params.userEmail = "[" + params.userEmail + "]"
        params.userCreatedEmail = "[" + params.userCreatedEmail + "]"
        ArrayList<String> newUserList = JSON.parse(params.userName)
        ArrayList<String> newUserEmailList = JSON.parse(params.userEmail)
        newUserList.eachWithIndex { userName , index ->
            if(params.institution){
                userService.saveUserWithPermissions(userName,newUserEmailList.get(index),params.tList,params.sList,request,null,params.institution,false)
            }else{
                userService.saveUserWithPermissions(userName,newUserEmailList.get(index),params.tList,params.sList,request,null,session.license.institution.id,false)
            }
        }
        ArrayList<String> tList = JSON.parse("[" + params.tList + "]")
        ArrayList<String> sList = JSON.parse("[" + params.sList + "]")
        JSON.parse(params.userCreatedEmail).each{
            ShiroUser user = ShiroUser.findByEmail(it)
            userService.updateUserPermissions(user,tList,sList)

        }
        redirect(action:"index", controller: "home",params: [sMsg:message(code:"verbosity.created",args:[message(code:"entity.users")])])
    }

    def validateFile={
        ArrayList<ShiroUser> userList = new ArrayList<ShiroUser>()
        ArrayList<ShiroUser> invalidUserList = new ArrayList<ShiroUser>()
        ShiroUser user
        int lineNumber = 0;
        boolean wrongFormat = false
        boolean emailExists = false
        boolean emailInvalid = false
        String email = null
        InputStream inputStream = null
        BufferedReader reader = null
        def msgText = null

        try{
            inputStream = request.getInputStream()

            if(!params?.codification){
                params.codification = "ISO8859_1"
            }
            reader = new BufferedReader(new InputStreamReader(inputStream, params.codification))
            String strLine = null
            StringTokenizer st = null
            String name
            while( ((strLine = reader.readLine()) != null) && !wrongFormat && !emailInvalid){
                lineNumber++;
                //break comma separated line using ","
                st = new StringTokenizer(strLine, ";");
                while(st.hasMoreElements()){
                    name = ((String)st.nextElement()).trim()
                    if (!st.hasMoreElements()){
                        // Erro, deveria ter um email
                        wrongFormat = true
                        break
                    }
                    email = ((String)st.nextElement()).trim()


                    // Valida o formato do email
                    if (!EmailValidator.getInstance().isValid(email)){
                        emailInvalid = true;
                    }

                    int emailVerification = ShiroUser.countByEmail(email)
                    if (emailVerification>0){
                        emailExists = true
                    }

                    user = new ShiroUser()
                    user.name = name
                    user.email = email
                    if(!emailExists && !emailInvalid){
                        userList.add(user)
                    }else{
                        user.email= (emailExists? message(code:"verbosity.email.exists"): message(code:"verbosity.email.invalid"))
                        user.email+= ": " + email
                        invalidUserList.add(user)
                        emailExists = false
                        emailInvalid = false
                    }

                }

            }

        }catch(Exception e){
            e.printStackTrace()
            wrongFormat = true;
        }finally{
            try{
                reader.close();
            }catch(Exception e){}
        }

        if (lineNumber==0){
            msgText = message(code:"user.file.null")
            render (contentType:"text/json") { msg( status:'fail', txt:msgText ) }
            return
        }

        if (wrongFormat){
            /* mostra uma mensagem que o formato do arquivo está
                * inválido e indica o número da linha onde o erro
                * foi encontrado */
            msgText = message(code:"user.file.fail",args:[lineNumber])
            render (contentType:"text/json") { msg( status:'fail', txt:msgText) }
            return
        }

        // Verifica se existem licenças suficientes na instituição
        boolean allowed = false;
        int usersToCreate = userList.size()
        //ToDo Alterar para verificar licenças
        /*int usersAvailable = License.availableUsers(session.institutionId)
              allowed = ( usersAvailable - usersToCreate > 0)
              */
        allowed = true
        if (allowed){
            // A lista de usuários é válida e será colocada na sessão
            msgText = message(code:"user.file.ok")
            render (contentType:"text/json") {
                msg( status:'ok', txt:msgText)
                list(userList:userList,invalidUserList : invalidUserList)
            }
        }else{
            msgText= message(code:"user.license.insufficient",args:[
                    usersAvailable,
                    usersToCreate
            ])
            // mensagem de erro indicando que não existem licenças suficientes
            render (contentType:"text/json") { msg( status:'fail', txt:msgText) }
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

    def updateUserSettings = {
        ShiroUser.list().each{
            if(!it.settings){
                UserSetting settings = new UserSetting()
                settings.emailNotify = 0
                settings.user = it
                settings.save()
                it.settings = settings
                it.save()
                it.errors.each{
                    println it
                }
            }
        }
    }

    def createStimulusModel = {
        StimulusPredictor.createModel()
        mongoService.runStimulusPredicator()
    }

    def updateProfileSubmissionCount = {
        Profile.list().each{
            int submissionCount = it.user.countSubmissions()
            int submissionCorrectCount = it.user.countCorrectSubmissions()
            it.submissionCount = submissionCount
            it.submissionCorrectCount = submissionCorrectCount
            it.save()
        }
    }

}
