package com.thehuxley

class ReportService {
    def emailService

    def reportFunction(Cluster group) {
        def endDate = new GregorianCalendar().getTime()
        def startDate = endDate.minus(7)
        def userList = ClusterPermissions.findAllByGroupAndPermission(group, 0).user
        def profileList = Profile.findAllByUserInList(userList)
        def profileMap = new Hashtable<Long,Profile>()
        def userListInfo = new ArrayList<Object>()


        profileList.each {
            profileMap.put(it.user.id, new Hashtable<String,Object>())
            profileMap.get(it.user.id).put("PROFILE",it)
            profileMap.get(it.user.id).put("PROBLEM_TRIED",0)
            profileMap.get(it.user.id).put("PROBLEM_CORRECT",0)
            profileMap.get(it.user.id).put("SUBMISSION_TRIED",0)
            profileMap.get(it.user.id).put("SUBMISSION_CORRECT",0)
            profileMap.get(it.user.id).put("SUBMISSION_AVERAGE",0)
            profileMap.get(it.user.id).put("ACCESS_NUMBER",0)

        }
        def topFive = new ArrayList<Object>(), botFive = new ArrayList<Object>(), tryList = new ArrayList<Object>(), limit = (int) 5, lowUsage = new ArrayList<Object>()
        if (!userList.isEmpty()) {
            Submission.executeQuery("Select distinct s.user.id, count(distinct problem.id) from Submission s where s.user in :userList and s.submissionDate < :endDate and s.submissionDate > :startDate group by s.user.id", [userList: userList, startDate: startDate, endDate: endDate]).each{
                profileMap.get(it[0]).put("PROBLEM_TRIED",it[1])
            }
            Submission.executeQuery("Select distinct s.user.id, count(distinct problem.id) from Submission s where s.user in :userList and evaluation = :evaluation and s.submissionDate < :endDate and s.submissionDate > :startDate group by s.user.id", [userList: userList, evaluation:EvaluationStatus.CORRECT, startDate: startDate, endDate: endDate]).each{
                profileMap.get(it[0]).put("PROBLEM_CORRECT",it[1])
            }

            profileMap.sort{-it.value.get("PROBLEM_CORRECT")}.each {
                if (topFive.size() < 5 && profileMap.get(it.getKey()).get("PROBLEM_CORRECT") > 0) {
                    topFive.add(it.getKey())
                }

            }

           /* profileMap.sort{it.value.get("PROBLEM_CORRECT")}.each {
                if (botFive.size() < 5 && !topFive.contains(it.getKey())) {
                    botFive.add(it.getKey())
                }

            }*/

            Submission.executeQuery("Select distinct s.user.id, count(distinct s.id) from Submission s where s.user in :userList and s.submissionDate < :endDate and s.submissionDate > :startDate group by s.user.id", [userList: userList, startDate: startDate, endDate: endDate]).each{
                profileMap.get(it[0]).put("SUBMISSION_TRIED",it[1])
            }
            Submission.executeQuery("Select distinct s.user.id, count(distinct s.id) from Submission s where s.user in :userList and evaluation = :evaluation and s.submissionDate < :endDate and s.submissionDate > :startDate group by s.user.id", [userList: userList, evaluation: EvaluationStatus.CORRECT, startDate: startDate, endDate: endDate]).each{
                profileMap.get(it[0]).put("SUBMISSION_CORRECT",it[1])
                def submissionCorrect = it[1],  submissionTried = profileMap.get(it[0]).get("SUBMISSION_TRIED")
                if (submissionTried != 0) {
                    profileMap.get(it[0]).put("SUBMISSION_AVERAGE", submissionTried * ( 1 - submissionCorrect / submissionTried ))
                } else {
                    profileMap.get(it[0]).put("SUBMISSION_AVERAGE",0)
                }
            }
            Historic.executeQuery("Select h.user.id, count(distinct h.id) as accessCount from Historic h where h.user in :userList and h.action = 'SignIn' and h.date < :endDate and h.date > :startDate group by h.user.id order by accessCount asc", [userList: userList, startDate: startDate, endDate: endDate]).each {
                profileMap.get(it[0]).put("ACCESS_NUMBER",it[1])
            }

            profileMap.sort{-it.value.get("SUBMISSION_AVERAGE")}.each {
                if ((tryList.size() < limit) && (!topFive.contains(it.key))) {
                    tryList.add(it.key)
                }
            }

            profileMap.findAll{it.value.get("ACCESS_NUMBER") == 0}.each {
                if(!topFive.contains(it.key) && (!tryList.contains(it.key))) {
                    lowUsage.add(it.key)
                }
            }

            if(lowUsage.size() < limit) {
                profileMap.findAll{it.value.get("ACCESS_NUMBER") > 0}.sort{it.value.get("SUBMISSION_TRIED")}.each {
                    if((lowUsage.size() < limit) && (!topFive.contains(it.key)) && (!tryList.contains(it.key))) {
                        lowUsage.add(it.key)
                    }
                }
            }
            def returnMap = ["TOPFIVE": topFive, "BOTFIVE": botFive, "TRYLIST": tryList, "LOWUSAGE": lowUsage, "STARTDATE": startDate, "ENDDATE": endDate, "PROFILEMAP": profileMap, "GROUP": group]
            return returnMap
        }
    }
    def generateHtml( map, owner) {
        def group = map.get("GROUP"), topFive = map.get("TOPFIVE"), botFive = map.get("BOTFIVE"), tryList = map.get("TRYLIST"), lowUsage = map.get("LOWUSAGE"), startDate = map.get("STARTDATE"), endDate = map.get("ENDDATE"), profileMap = map.get("PROFILEMAP")

        def html = """<center>
    <table cellpadding="8" cellspacing="0" style="width:100%!important;background:#ffffff;margin:0;padding:0" border="0">
        <tbody>
        <tr>
            <td valign="top">
                <table cellpadding="0" cellspacing="0" align="center" border="0">
                    <tbody>
                    <tr bgcolor="#272b31">
                        <td width="36"></td>
                        <td style="font-size:0px" height="60">
                            <img src="http://static.cdn.thehuxley.com/rsc/images/logo-white.png" alt="">
                        </td>
                        <td width="36"></td>
                    </tr>
                    <tr bgcolor="#f3f3f3">
                        <td colspan="3">
                            <table cellpadding="0" cellspacing="0" style="border-left:1px #B8B8B8 solid;border-right:1px #B8B8B8 solid;border-bottom:1px #B8B8B8 solid;border-radius:0px 0px 4px 4px" border="0" align="center">
                                <tbody>
                                <tr>
                                    <td colspan="3" height="36"></td>
                                </tr>
                                <tr>
                                    <td width="36"></td>
                                    <td width="554" style="font-size:14px;color:#444444;font-family:'Open Sans','Lucida Grande','Segoe UI',Arial,Verdana,'Lucida Sans Unicode',Tahoma,'Sans Serif';border-collapse:collapse" align="left" valign="top">
                                        <h2>Olá professor(a) ${owner},</h2>

                                    </td>
                                    <td width="36"></td>
                                </tr>
                                <tr>
                                    <td width="36"></td>
                                    <td width="554" style="font-size:14px;color:#444444;font-family:'Open Sans','Lucida Grande','Segoe UI',Arial,Verdana,'Lucida Sans Unicode',Tahoma,'Sans Serif';border-collapse:collapse" align="left" valign="top">
                                        Seguem as principais informações sobre o uso do The Huxley da sua turma '${group}' durante essa semana (${startDate.format('dd/MM/yy')} ~ ${endDate.format('dd/MM/yy')}).<br>

                                        """
                                    if(topFive.size() > 0){
                                     html += """<h3>Alunos que resolveram mais problemas</h3>
                                                <table style="color: gray; font-size: 14px;">"""
                                            topFive.each(){ id ->
                                                    html+= """<tr><td><img style="height: 40px; vertical-align: middle;"src="http://img.thehuxley.com/data/images/app/profile/thumb/${profileMap.get(id).get("PROFILE").smallPhoto}" alt=""> <span style="color: black; font-weight: bold;">${profileMap.get(id).get("PROFILE").name}</span>, resolveu <span style="color: black; font-weight: bold;">${profileMap.get(id).get("PROBLEM_CORRECT")}</span> problema(s) </td><td><a href="mailto:${profileMap.get(id).get("PROFILE").user.email}" style="background: url('http://www.thehuxley.com/huxley/static/images/icons/icons.png')  no-repeat scroll -35px -38px transparent; display: inline-block; height: 14px; width: 20px;"></a></td></tr>"""
                                            }
                                        html += """</table>"""
                                    }

                                    if(botFive.size() > 0) {
                                     html += """<h3>Alunos que resolveram menos problemas</h3>
                                        <table style="color: gray; font-size: 14px;">"""
                                            botFive.each(){ id->
                                                html += """<tr><td><img style="height: 40px; vertical-align: middle;"src="http://img.thehuxley.com/data/images/app/profile/thumb/${profileMap.get(id).get("PROFILE").smallPhoto}" alt=""> <span style="color: black; font-weight: bold;">${profileMap.get(id).get("PROFILE").name}</span>, resolveu <span style="color: black; font-weight: bold;">${profileMap.get(id).get("PROBLEM_CORRECT")}</span> problema(s)</td><td><a href="mailto:${profileMap.get(id).get("PROFILE").user.email}?body=${emailService.msg('email.template.motivate',null,[profileMap.get(id).get("PROFILE").user.name, owner])}" style="background: url('http://www.thehuxley.com/huxley/static/images/icons/icons.png')  no-repeat scroll -35px -38px transparent; display: inline-block; height: 14px; width: 20px;"></a></td></tr>"""
                                            }
                                        html += """
                                        </table>"""
                                     }
                                    if(tryList.size() > 0) {
                                        html += """<h3>Alunos com dificuldades</h3>
                                        <table style="color: gray; font-size: 14px;">"""
                                            tryList.each(){ id->
                                                html += """<tr><td><img style="height: 40px; vertical-align: middle;"src="http://img.thehuxley.com/data/images/app/profile/thumb/${profileMap.get(id).get("PROFILE").smallPhoto}" alt=""> <span style="color: black; font-weight: bold;">${profileMap.get(id).get("PROFILE").name}</span> submeteu <span style="color: black; font-weight: bold;">${profileMap.get(id).get("SUBMISSION_TRIED")}</span> vezes e acertou <span style="color: black; font-weight: bold;">${profileMap.get(id).get("SUBMISSION_CORRECT")}</span></td><td><a href="mailto:${profileMap.get(id).get("PROFILE").user.email}?body=${emailService.msg('email.template.motivate',null,[profileMap.get(id).get("PROFILE").user.name, owner])}" style="background: url('http://www.thehuxley.com/huxley/static/images/icons/icons.png')  no-repeat scroll -35px -38px transparent; display: inline-block; height: 14px; width: 20px;"></a></td></tr>"""
                                            }
                                        html+= """</table>"""
                                    }

                                    if(lowUsage.size() > 0) {
                                        html += """<h3>Alunos com baixo engajamento</h3>"""
                                        if(Questionnaire.executeQuery("select count(q) from Questionnaire q left join q.groups g where g.id = :groupId and q.startDate >= :startDate and q.startDate <= :endDate", [groupId: group.id , startDate: endDate , endDate: endDate.plus(7)])[0] == 0) {
                                            html += """<h5><font face="Verdana">Aumente o engajamento dos seus alunos, <a href="http://localhost:8080/huxley/quest/createGroup?gId=${group.id}">crie um questionário!</a><br></font></h5>"""
                                        }

                                        html += """<table style="color: gray; font-size: 14px;">"""
                                        lowUsage.each() { id->
                                            if(profileMap.get(id).get("ACCESS_NUMBER") == 0){
                                                html += """<tr><td><img style="height: 40px; vertical-align: middle;"src="http://img.thehuxley.com/data/images/app/profile/thumb/${profileMap.get(id).get("PROFILE").smallPhoto}" alt=""> <span style="color: black; font-weight: bold;">${profileMap.get(id).get("PROFILE").name}</span>, esta semana <span style="color: black; font-weight: bold;">não acessou</span></td><td><a href="mailto:${profileMap.get(id).get("PROFILE").user.email}?body=${emailService.msg('email.template.motivate',null,[profileMap.get(id).get("PROFILE").user.name, owner])}" style="background: url('http://www.thehuxley.com/huxley/static/images/icons/icons.png')  no-repeat scroll -35px -38px transparent; display: inline-block; height: 14px; width: 20px;"></a></td></tr>"""
                                            } else {
                                                html += """<tr><td><img style="height: 40px; vertical-align: middle;"src="http://img.thehuxley.com/data/images/app/profile/thumb/${profileMap.get(id).get("PROFILE").smallPhoto}" alt=""> <span style="color: black; font-weight: bold;">${profileMap.get(id).get("PROFILE").name}</span>, acessou <span style="color: black; font-weight: bold;">${profileMap.get(id).get("ACCESS_NUMBER")}</span> vez(es)"""
                                                if(profileMap.get(id).get("SUBMISSION_TRIED") == 0) {
                                                    html += """ e <span style="color: black; font-weight: bold;">não submeteu</span></td><td><a href="mailto:${profileMap.get(id).get("PROFILE").user.email}?body=${emailService.msg('email.template.motivate',null,[profileMap.get(id).get("PROFILE").user.name, owner])}" style="background: url('http://www.thehuxley.com/huxley/static/images/icons/icons.png')  no-repeat scroll -35px -38px transparent; display: inline-block; height: 14px; width: 20px;"></a></td></tr>"""
                                                } else {
                                                    html += """ e submeteu apenas <span style="color: black; font-weight: bold;">${profileMap.get(id).get("SUBMISSION_TRIED")}</span> vez(es)</td><td><a href="mailto:${profileMap.get(id).get("PROFILE").user.email}?body=${emailService.msg('email.template.motivate',null,[profileMap.get(id).get("PROFILE").user.name, owner])}" style="background: url('http://www.thehuxley.com/huxley/static/images/icons/icons.png')  no-repeat scroll -35px -38px transparent; display: inline-block; height: 14px; width: 20px;"></a></td></tr>"""
                                                }
                                            }

                                        }
                                        html +="""</table>"""
                                    }


                                html +="""</td>
                                    <td width="36"></td>
                                <tr>
                                    <td width="36"></td>
                                    <td width="554" style="font-size:14px;color:#444444;font-family:'Open Sans','Lucida Grande','Segoe UI',Arial,Verdana,'Lucida Sans Unicode',Tahoma,'Sans Serif';border-collapse:collapse" align="left" valign="top">
                                        <br><br>
                                        Obrigado,
                                        <br><br>
                                        - The Huxley Team
                                        <br>
                                    </td>
                                    <td width="36"></td>
                                </tr>
                                                         </tr>
                                                         <td><hr></td><td><hr></td><td><hr></td>
                                                                <tr>
                                    <td width="36"></td>
                                    <td width="554" style="font-size:14px;color:#444444;font-family:'Open Sans','Lucida Grande','Segoe UI',Arial,Verdana,'Lucida Sans Unicode',Tahoma,'Sans Serif';border-collapse:collapse" align="left" valign="top">
                                        <table style="font-size: 10px; color: gray;">
                                            <tbody>
                                                <tr><td style="padding-bottom: 3px;">- Você recebeu esse email porque a sua turma continua ativa durante essa semana. Se a sua turma já encerrou, por favor, edite as configurações do seu grupo e corrija a data final;</br></td></tr>
                                                <tr><td style="padding-bottom: 3px;">- Caso existam alunos que já desistiram da matéria, trancaram o curso ou por qualquer outro motivo não estejam mais participando, é interessante que você os remova do grupo, assim você receberá informações com os alunos que realmente estão participando da sua turma.</br></td></tr>
                                                <tr><td style="padding-bottom: 3px;">- A prática é muito importante para o aprendizado de programação. Procure criar exercícios no The Huxley e estimule os seus alunos a fazerem. Muitos professores consideram os exercícios como parte da nota da disciplina.</br></td></tr>
                                                <tr><td style="padding-bottom: 3px;">- Não deseja mais receber nossos relatórios semanais? Envie um email para support@thehuxley.com</br></td></tr>
                                            </tbody>
                                        </table>
                                        <br>
                                    </td>
                                    <td width="36"></td>
                                </tr>

                                <tr>
                                    <td colspan="3" height="36"></td>
                                </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>

                    </tbody>
                </table>
                <table cellpadding="0" cellspacing="0" align="center" border="0">
                    <tbody>
                    <tr>
                        <td height="10"></td>
                    </tr>
                    <tr>
                        <td style="padding:0;border-collapse:collapse">
                            <table cellpadding="0" cellspacing="0" align="center" border="0">
                                <tbody>
                                <tr style="color:#B8B8B8;font-size:11px;font-family:'Open Sans','Lucida Grande','Segoe UI',Arial,Verdana,'Lucida Sans Unicode',Tahoma,'Sans Serif'" valign="top">
                                    <td align="left">2014 <span>The Huxley</span></td>
                                </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </td>
        </tr>
        </tbody>
    </table>
</center>"""
        return html
    }
    def test() {
        def endDate = new GregorianCalendar().getTime()
        def startDate = endDate.minus(7)
        println endDate
        String returnHtml = ""

        Cluster.executeQuery("Select c from Cluster c where c.startDate <= :startDate and c.endDate >= :endDate", [startDate:startDate, endDate:endDate]).each{
            println it
            def map = reportFunction(it)
            if (map) {
                ClusterPermissions.findAllByGroupAndPermission(it,30).each(){
                    try {
                        returnHtml += generateHtml(map, it.user)
                        emailService.sendSimpleEmail(generateHtml(map, it.user), "Relatório da turma " + it.group.name + " de " + startDate.format('dd/MM/yy') + " ~ " + endDate.format('dd/MM/yy'), "support@thehuxley.com")
                        println generateHtml(map, it.user)
                        println "======="
                    } catch (e) {
                    }

                }
            }

        }
        return returnHtml
    }

    def sendReports() {
        def endDate = new GregorianCalendar().getTime()
        def startDate = endDate.minus(7)
        Cluster.executeQuery("Select c from Cluster c where c.startDate <= :startDate and c.endDate >= :endDate", [startDate:startDate, endDate:endDate]).each{
            def map = reportFunction(it)
            if (map) {
                ClusterPermissions.findAllByGroupAndPermission(it,30).each(){
                    try {
                        if (it.user.id != 2042) {
                            emailService.sendSimpleEmail(generateHtml(map, it.user), "Relatório da turma " + it.group.name + " de " + startDate.format('dd/MM/yy') + " ~ " + endDate.format('dd/MM/yy'), it.user.email)
                        }

                    } catch (e) {
                    }

                }
            }

        }
    }
}
