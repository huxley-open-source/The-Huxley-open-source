package com.thehuxley

import com.thehuxley.container.pendency.Pendency
import com.thehuxley.util.HuxleyProperties
import grails.converters.JSON

class TeacherController {

    def emailService;
    def mongoService;

    def signUp() {
        [institution: JSON.parse(Institution.findAllByStatus(Institution.STATUS_ACCEPTED).toString())]
    }

    def createTeacherAccount = {
        Profile profile = session.profile
        ShiroUser shiroUser = session.profile.user
        Pendency pendency
        Institution institution = Institution.findByName(params.institution)

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
        emailService.welcomeMessage(shiroUser.email, shiroUser.name)

        redirect (controller: 'home', action: 'index')
    }
}
