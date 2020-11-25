package com.thehuxley

class QuestTagLib {

    static namespace = "huxley"

    def questStudentList = {attrs ->
   out << """ 
<div id="open-questionnaires" class="box">
<h3>Questionários abertos</h3>
<table class="standard-table" style="height: 15px;">
    <thead>
        <th style="padding: 7px 7px 7px 10px;">Titulo</th>
        <th style="text-align: center;">Pontuação do usuario</th>
        <th style="text-align: center;">Pontuaçao do questionario</th>
        <th style="text-align: center;">${g.message(code: 'questionnaire.starts')}</th>
    </thead>
    <tbody id="open-questionnaires-list"></tbody>
</table>
<div class="ui-pagination" id="open-pagination"></div>
</br></div>

<div id="separator"><hr /> <br /></div>

<div id="closed-questionnaires" class="box">
<h3>Questionários encerrados</h3>
<table class="standard-table" style="height: 15px;">
    <thead>
        <th style="padding: 7px 7px 7px 10px;">Título</th>
        <th style="text-align: center;">Pontuação do usuário</th>
        <th style="text-align: center;">Pontuação do questionário</th>
    </thead>
    <tbody id="finished-questionnaires-list"></tbody>
</table>
<div class="ui-pagination" id="closed-pagination"><!-- Pagination --></div>
</br></div></div>"""



    }
    def questTeacherList = {attrs ->
        def groupList
        if (session.license.isAdmin()){
            groupList = Cluster.list()
        }else if (session.license.isTeacher()){
            groupList = ClusterPermissions.executeQuery("Select Distinct c.group from ClusterPermissions c where c.user.id = " + session.profile.user.id + " and c.permission > 0")
        }else if (session.license.isAdminInst()){
            groupList = ClusterPermissions.executeQuery("Select Distinct c.group from ClusterPermissions c where c.group.institution.id = " + session.license.institution.id)
        }
        out << """
<div class="box"><!-- Search box -->
    <form action="" method="post">
        <h3>${g.message code:"verbosity.title"}<input type="text" name="name" placeholder="${g.message code:"verbosity.tip.title"}" style="width: 475px;float: right;" class="ui-input2" id="input-quest"  /></h3></br>
        <h3>${g.message code:"entity.group"}
            <span class="ui-custom-select" style="float:right;display:table;width:73%;margin-top:-5px;">
                <select name="inst" id="group-list" style="width:100%;" onchange="huxleyQuest.getQuestionnaires()">
                <option value="0">${g.message(code: "all.groups")}</option>"""
        groupList.each{
            out << """<option value="${it.id}">${it.name}</option>"""
        }
        out<<"""</select>
            </span>
        </h3>
    </form>
</div>
<hr /><br />

<div id="open-questionnaires" class="box">
<h3>Questionários abertos</h3>
<table class="standard-table" style="height: 15px;">
    <thead>
        <th style="padding: 7px 7px 7px 10px;">Título</th>
        <th style="text-align: center;">Pontuação do questionário</th>
        <th style="text-align: center;">${g.message(code: 'questionnaire.starts')}</th>
    </thead>
    <tbody id="open-questionnaires-list"></tbody>
</table>
<div class="ui-pagination" id="open-pagination"></div>
</br></div>

<div id="separator"><hr /> <br /></div>

<div id="closed-questionnaires" class="box">
<h3>Questionários encerrados</h3>
<table class="standard-table" style="height: 15px;">
    <thead>
        <th style="padding: 7px 7px 7px 10px;">Titulo</th>
        <th style="text-align: center;">Pontuação do questionário</th>
    </thead>
    <tbody id="finished-questionnaires-list"></tbody>
</table>
<div class="ui-pagination" id="closed-pagination"><!-- Pagination --></div>
</br></div></div>"""
            }

            def questList = { attrs->
                if(session.license.isStudent()){
                    out << huxley.questStudentList()
                }else{
                    out << huxley.questTeacherList()
                }


            }

        }
