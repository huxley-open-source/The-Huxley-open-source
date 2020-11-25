package com.thehuxley

import java.text.SimpleDateFormat;

class HomeTagLib {
    static namespace = "huxley"
    def questService
    def home = { attrs->
        Profile profile = attrs.profile
        def questList = []
        SimpleDateFormat dateFormater = new SimpleDateFormat("dd/MM/yyyy")
        SimpleDateFormat timeFormater = new SimpleDateFormat("HH:mm")
        def currentTime = new Date()
        
        if(session.license.isStudent()){
            questList.addAll(questService.getUserOpenedQuest(profile.user.id,attrs.max,0).get("LIST"))
            questList.addAll(questService.getUserClosedQuest(profile.user.id,attrs.max,0).get("LIST"))
        } else if(session.license.isAdmin()){
            questList.addAll(questService.getAdminOpenedQuest('',attrs.max,0,0).get("LIST"))
            questList.addAll(questService.getAdminClosedQuest('',attrs.max,0,0).get("LIST"))
        } else if(session.license.isAdminInst()){
            questList.addAll(questService.getAdminInstOpenedQuest('',session.license.institution.id,attrs.max,0,0).get("LIST"))
            questList.addAll(questService.getAdminInstClosedQuest('',session.license.institution.id,attrs.max,0,0).get("LIST"))
        } else if(session.license.isTeacher()){
            questList.addAll(questService.getTeacherOpenedQuest('',profile.user.id,attrs.max,0,0).get("LIST"))
            questList.addAll(questService.getTeacherClosedQuest('',profile.user.id,attrs.max,0,0).get("LIST"))

        }

        if (questList.size() > 0) {
            out << """
            <div class="questionnaires"><!-- Questionnaires -->
                <h3>Últimos questionários ${g.link(controller: 'quest', action: 'index',g.message(code: 'verbosity.seeAll'))}</h3>
            """
            questList.each{
                if(session.license.isStudent()){
                    out << """
                    <li>
                    """

                    out << """
                        <span class="title"> ${g.link(controller: 'quest', action: 'show',params: [qId:it.id], it.questionnaire.title) }</span>
                    """
                    if (((currentTime.getTime() - it.questionnaire.startDate.getTime()) < 0)) {
                        out << """
                            <span> <i>iniciará às</i> ${timeFormater.format(it.questionnaire.startDate)}  <i>do dia</i> ${dateFormater.format(it.questionnaire.startDate)} e <i>terminará às</i> ${timeFormater.format(it.questionnaire.endDate)}  <i>do dia</i> ${dateFormater.format(it.questionnaire.endDate)}.</span>
                        """
                    } else if (((currentTime.getTime() - it.questionnaire.startDate.getTime()) >= 0) && ((currentTime.getTime() - it.questionnaire.endDate.getTime()) < 0)) {
                        out << """
                            <span> <i>iniciou às</i> ${timeFormater.format(it.questionnaire.startDate)}  <i>do dia</i> ${dateFormater.format(it.questionnaire.startDate)} e <i>terminará às</i> ${timeFormater.format(it.questionnaire.endDate)}  <i>do dia</i> ${dateFormater.format(it.questionnaire.endDate)}.</span>
                        """
                    } else if(((currentTime.getTime() - it.questionnaire.endDate.getTime()) >= 0)) {
                        out << """
                            <span> <i>iniciou às</i> ${timeFormater.format(it.questionnaire.startDate)}  <i>do dia</i> ${dateFormater.format(it.questionnaire.startDate)} e <i>terminou às</i> ${timeFormater.format(it.questionnaire.endDate)}  <i>do dia</i> ${dateFormater.format(it.questionnaire.endDate)}.</span>
                        """
                    }

                    out << """
                        </span>
                    </li>
                   """
                } else {
                    out << """
                    <li>
                    """

                    out << """
                        <span class="title"> ${g.link(controller: 'quest', action: 'showStatistics', id: it.id, it.title) }</span>
                    """
                    if (((currentTime.getTime() - it.startDate.getTime()) < 0)) {
                        out << """
                            <span> <i>iniciará às</i> ${timeFormater.format(it.startDate)}  <i>do dia</i> ${dateFormater.format(it.startDate)} e <i>terminará às</i> ${timeFormater.format(it.endDate)}  <i>do dia</i> ${dateFormater.format(it.endDate)}.</span>
                        """
                    } else if (((currentTime.getTime() - it.startDate.getTime()) >= 0) && ((currentTime.getTime() - it.endDate.getTime()) < 0)) {
                        out << """
                            <span> <i>iniciou às</i> ${timeFormater.format(it.startDate)}  <i>do dia</i> ${dateFormater.format(it.startDate)} e <i>terminará às</i> ${timeFormater.format(it.endDate)}  <i>do dia</i> ${dateFormater.format(it.endDate)}.</span>
                        """
                    } else if(((currentTime.getTime() - it.endDate.getTime()) >= 0)) {
                        out << """
                            <span> <i>iniciou às</i> ${timeFormater.format(it.startDate)}  <i>do dia</i> ${dateFormater.format(it.startDate)} e <i>terminou às</i> ${timeFormater.format(it.endDate)}  <i>do dia</i> ${dateFormater.format(it.endDate)}.</span>
                        """
                    }

                    out << """
                        </span>
                    </li>
                   """
                }

            }

            out << """
            </div>
            <hr />
             """
        }

        out << """
           </div>
        """
    }
}
