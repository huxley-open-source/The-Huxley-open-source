package com.thehuxley

import com.thehuxley.util.HuxleyProperties

class ProfileTagLib {
    static namespace = "huxley"
    def instService
    def profile = {attrs ->

        def profile = Profile.get(attrs.profile.id)
        def institution
        def showInstitution = attrs.institution != "false"

        try {
            if (profile.institution.id) {
                institution = profile.institution
            } else {
                showInstitution = false
            }
        } catch(Exception e) {
            showInstitution = false
        }

        out << '''
            <div class="profile"><!-- Profile -->
                <div class="photo">
                    <div class="position">''' + profile.user.topCoderPosition + '''</div>
                    <img src="''' + HuxleyProperties.getInstance().get("image.profile.dir") + profile.photo + '''" border="0" width="200" height="155"/>
                </div>
                <div class="up">
                    <div class="name">''' + profile.name + '''</div>'''
                if (showInstitution) {
                    out << '''<div class="school">''' + institution.name + '''</div>'''
                }
                 out << '''<div class="website"><a href="''' + '''" target="_self">''' + '''</a></div>
                </div>
                <div class="down">
                    <div class="position"><b>''' + profile.user.topCoderPosition + '''</b><br/><span><b>''' + g.message(code: "verbosity.position") + '''</b> ''' + g.message(code: "verbosity.inTopCoder") + '''</span></div>
                    <div class="punctuation"><b>'''+g.formatNumber(number: profile.user.topCoderScore, type: "number", maxFractionDigits: 2)+'''</b><br/><span><b>''' + g.message(code: "verbosity.score") + '''</b> ''' + g.message(code: "verbosity.inTopCoder") + '''</span></div>
                    <div class="tempted-problems"><b>''' + profile.problemsTryed + '''</b><br/><span><b>''' + g.message(code: "entity.problems") + '''</b> ''' + g.message(code: "verbosity.thatTempted") + '''</span></div>
                    <div class="hit-problems"><b>''' + profile.problemsCorrect + '''</b><br/><span><b>''' + g.message(code: "entity.problems") + '''</b> ''' + g.message(code: "verbosity.thatHit") + '''</span></div>
                </div>
            </div>
        '''
    }

    def institutionProfile = {attrs ->

        def institution = attrs.institution
        def data = instService.getDataForProfile(institution)

        out << '''
            <div class="profile"><!-- Profile -->
                <div class="photo">
                    <img src="''' + HuxleyProperties.getInstance().get("image.profile.dir") + institution.photo + '''" border="0" width="200" height="155"/>
                </div>
                <div class="up">
                    <div class="name">''' + institution.name + '''<h3 style="float:right;">''' +g.link(action:"create", controller:"inst", id:"${institution.id}", g.message(code: "verbosity.edit"), class:"ui-gbutton", style:"padding:8px 20px;;")  + '''</h3></div>
                    <div class="school"> <a href="''' + '''" target="_self">''' + '''</a></div>
                    <div class="website"><a href="''' + '''" target="_self">''' + """</a></div>
                </div>
                <div class="down">
                    <div class="position"><b>${data.get(instService.DATA_NUMBER_STUDENTS)}</b><br/><span><b>""" + g.message(code: "verbosity.number.of.students") + '''</b> ''' + g.message(code: "verbosity.registered") + """</span></div>
                    <div class="punctuation"><b>${data.get(instService.DATA_NUMBER_MASTERS)} </b><br/><span><b>""" + g.message(code: "verbosity.number.of.masters") + '''</b> ''' + g.message(code: "verbosity.registered") + """</span></div>
                    <div class="tempted-problems"><b>${data.get(instService.DATA_NUMBER_PROBLEMS_TRIED)}</b><br/><span><b>""" + g.message(code: "entity.problems") + '''</b> ''' + g.message(code: "verbosity.total.that.tempted") + """</span></div>
                    <div class="hit-problems"><b>${data.get(instService.DATA_NUMBER_PROBLEMS_HIT)} </b><br/><span><b>""" + g.message(code: "entity.problems") + '''</b> ''' + g.message(code: "verbosity.total.that.hit") + '''</span></div>
                </div>
            </div>
        '''
    }
}
