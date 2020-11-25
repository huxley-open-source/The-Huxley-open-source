package com.thehuxley

class SubmissionTagLib {

    static namespace = "huxley"


    def submissionTeacherList = {attrs ->
        def groupList = ClusterPermissions.executeQuery("Select Distinct c.group from ClusterPermissions c where c.user.id = " + session.profile.user.id + " and c.permission > 0")
        groupList.each{
        out << """<option value="${it.id}">${it.name}</option>"""
        }
    }

    def submissionAdminInstList = {attrs ->
        def groupList = ClusterPermissions.executeQuery("Select Distinct c.group from ClusterPermissions c where c.group.institution.id = " + session.license.institution.id)
        groupList.each{
            out << """<option value="${it.id}">${it.name}</option>"""
        }
    }

    def submissionAdminList = {attrs ->
        def groupList = Cluster.list()
        groupList.each{
            out << """<option value="${it.id}">${it.name}</option>"""
        }
    }
        def submissionList = { attrs->
            out << "  ${r.external dir: 'js', file: 'huxley-submission.js', disposition: 'head'}"
            out << """
                <div class="box"><!-- Search box -->
                    <h3>${g.message code:"submission.my.submissions"}</h3>
                    <form action="" method="post">"""
            if(session.license.isStudent()){
                if (!attrs.problem){
                    out << """<input type="text" name="submissao" placeholder="${g.message code:"submission.tip.problem"}" style="width: 62%;" class="ui-input2" id="input-problem"  />"""
                }
            }else if (!attrs.problem&&!attrs.user){
                out << """<input type="text" name="submissao" placeholder="${g.message code:"submission.tip.user"}" style="width: 62%;" class="ui-input2" id="input-user"  />"""
                out << """<input type="text" name="submissao" placeholder="${g.message code:"submission.tip.problem"}" style="width: 62%;" class="ui-input2" id="input-problem"  />"""
            }else if (attrs.user&&!attrs.problem){
                out << """<input type="text" name="submissao" placeholder="${g.message code:"submission.tip.problem"}" style="width: 62%;" class="ui-input2" id="input-problem"  />"""
            }else if (attrs.problem&&!attrs.user){
                out << """<input type="text" name="submissao" placeholder="${g.message code:"submission.tip.user"}" style="width: 62%;" class="ui-input2" id="input-user"  />"""
            }

            out<< """
                        <input type="text" value="${g.message code:"submission.start.date"}" class="ui-ybutton" style="width: 10%;" id="from" name="inputdatainicio" />
                        <input type="text" value="${g.message code:"submission.end.date"}" class="ui-ybutton" style="width: 10%;" id="to" name="inputdatafim" />
                """
        if(!session.license.isStudent() && !attrs.user){
            out << """
                <hr /><br />
                <h3>${g.message code:"entity.group"}
                <span class="ui-custom-select" style="float:right;display:table;width:73%;margin-top:-5px;">
                <select name="inst" id="group-list" style="width:100%;" onchange="getSubmission(0)">
                <option value="0">${g.message(code: "all.groups")}</option>
                """

            if(session.license.isTeacher()){
                out << huxley.submissionTeacherList()
            }else if (session.license.isAdminInst()){
                out << huxley.submissionAdminInstList()
            }else if (session.license.isAdmin()){
                out << huxley.submissionAdminList()
            }
            out<<"""</select>
                    </span>
                    </h3>
                    """
            out << """
                <h3>${g.message code:"vebosity.evaluation"}
                <span class="ui-custom-select" style="float:right;display:table;width:73%;margin-top:-5px;">
                <select name="evaluation" id="evaluation-list" style="width:100%;" onchange="getSubmission(0)">
                <option value="all">${g.message(code: "all.evaluations")}</option>
                <option value="${EvaluationStatus.CORRECT}">${g.message code: "evaluation.correct"}</option>
                <option value="${EvaluationStatus.WRONG_ANSWER}">${g.message code: "evaluation.wrong_answer"}</option>
                <option value="${EvaluationStatus.EMPTY_ANSWER}">${g.message code: "evaluation.empty_answer"}</option>
                <option value="${EvaluationStatus.COMPILATION_ERROR}">${g.message code: "evaluation.compilation_error"}</option>
                <option value="${EvaluationStatus.TIME_LIMIT_EXCEEDED}">${g.message code: "evaluation.time_limit_exceeded"}</option>
                <option value="${EvaluationStatus.RUNTIME_ERROR}">${g.message code: "evaluation.runtime_error"}</option>
                <option value="${EvaluationStatus.PRESENTATION_ERROR}">${g.message code: "evaluation.presentation_error"}</option>
            </select>
                    </span>
                    </h3>
                    """
        }

            if(attrs.user||attrs.problem){
                out << """
                <hr /><br />"""
                if(attrs.user){
                    out<< """<h3>${g.message code:"entity.user"}: ${attrs.user.name}</h3>"""
                }
                if (attrs.problem){
                    out<< """<h3>${g.message code:"entity.problem"}: ${attrs.problem.name}</h3>"""
                }

            }


            out << '''
                </form>
            </div>
            <hr /><br />

    <table class="submission-table">
    <thead> '''
         if (!session.license.isStudent() && !attrs.user){
         out << """ <th onclick = "huxleySubmission.setSort('s.user.name','user')">${g.message code:"submission.user"}<img id="img-user" class="submission-sort" src="${resource(dir:'images/icons', file:'sorted_none.gif')}"/></th> """
        }
        out << """
        <th onclick = "huxleySubmission.setSort('p.name','problem')">${g.message code:"submission.problem"}<img id="img-problem" class="submission-sort" src="${resource(dir:'images/icons', file:'sorted_none.gif')}"/></th>
        <th onclick = "huxleySubmission.setSort('s.submissionDate','date')">${g.message code:"submission.date"}<img id="img-date" class="submission-sort" src="${resource(dir:'images/icons', file:'sorted_desc.gif')}"/></th>
        <th onclick = "huxleySubmission.setSort('s.evaluation','time')">${g.message code:"submission.evaluation"}<img id="img-time" class="submission-sort" src="${resource(dir:'images/icons', file:'sorted_none.gif')}"/></th>
        <th>Ações</th>
        <th></th>
        </thead>
        <tbody id="submission-list"></tbody>
    </table>
    <div id="submission-pagination" ></div>"""


    }
}
