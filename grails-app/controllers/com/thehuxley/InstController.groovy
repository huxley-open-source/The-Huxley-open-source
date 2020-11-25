package com.thehuxley

class InstController {

    def imgService

    def index() { }

    def create = {
        Institution instInstance = new Institution()
        if(params.id){
            instInstance = Institution.get(params.id)
        }
        [instInstance:instInstance]
    }

    def show = {
        Institution institutionInstance = Institution.get(params.id)
        [institutionInstance:institutionInstance, teacherList:ClusterPermissions.executeQuery("Select Distinct u.user from ClusterPermissions u left join u.group g where permission > 0 and g.institution.id = " + institutionInstance.id)]
    }

    def uploadImage = {
        String name = imgService.uploadImage(params,request)
        render (contentType:"text/json") {
            data = name
        }

    }

    def save = {
        println params
        Institution inst = new Institution()
        boolean setImage = true
        println "esta vazio?" + params.instId.isEmpty()
        if (params.instId && !params.instId.isEmpty()){
            inst = Institution.get(params.instId)
            setImage = (!inst.photo.equals(params.instPhoto))
        }
        if(!params.instPhoto.isEmpty()){
            if (setImage){
                imgService.chooseImg(params.instPhoto)
                inst.photo = params.instPhoto
            }
        }else{
            inst.photo = "defaultInst.jpg"
        }

        inst.name = params.name
        inst.phone = params.phone
        if(inst.save()){
            String adminIdList = "(" + params.sList + ")"
            def adminList = ShiroUser.executeQuery("Select s from ShiroUser s where s.id in " + adminIdList)
            inst.users = adminList
            redirect(action: "show", id: inst.id)
        }else{
            inst.errors.each{
                println it
            }
        }



    }
    def getUserBoxRightList = {
        ArrayList<Long> idList = new ArrayList<Long>()
        ArrayList<Long> permList = new ArrayList<Long>()


        render(contentType:"text/json") {
            content = huxley.userDLCRightBox( institution:params.id, position:"false", score:"false", email:"true")
            selectedIdList = Profile.executeQuery("Select Distinct user.id from Institution i left join i.users user where i.id = " + params.id)
        }
    }
}
