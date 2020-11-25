package com.thehuxley

import java.text.SimpleDateFormat

class MainTagLib {

    static namespace = "huxley"

    def profileService

    def problemCounter = {attrs ->
        String problemsToBeSolved = """<h3>""" + profileService.problemsToBeSolved(attrs.profile)+ """</h3>"""
        out << """
            <div class="problems">""" + g.link(action:"index",controller:"problem",problemsToBeSolved, params:[resolved:'false'] ,style: "text-decoration: none;") +
                """<b>""" + g.message(code: "verbosity.problemsTo") + """<span class="ui-wmarker">""" + g.message(code: "verbosity.BeSolved") + """</span></b>
            </div>
        """
    }

    def lastAccess = {attrs ->

        def dateFormat = new SimpleDateFormat("dd/MM/yyyy")
        def hourFormat = new SimpleDateFormat("hh:mm")

		if (attrs.profile && attrs.profile.user) {
			if (!attrs.profile.user.lastLogin) {
				attrs.profile.user.lastLogin = new Date();
			}

			out << '''
            <b>''' + g.message(code: "verbosity.lastAccess") + ''':</b>
            <span>''' + hourFormat.format(attrs.profile.user.lastLogin) + ''' | ''' + dateFormat.format(attrs.profile.user.lastLogin) + '''</span>
        	'''
		}
    }

    def navigation = { attrs ->
        boolean more = true
        out << '''<b>''' + g.link(controller:"home", action:"index", "The Huxley")
        if(controllerName.equals("profile")){
        out << ''' / ''' + g.link(controller:"profile", action:"show", g.message(code: "entity.profile"))
        }else if(controllerName.equals("submission")){
            out<< header() << ''' <script type="text/javascript">
                                $(function(){
                                    $(".submission-button").addClass('submission-button-active');
                                    $("#submission-icon").addClass('submission-icon-active');
                                });
                              </script>'''
            out << ''' / ''' + g.link(controller:"submission", action:"index", g.message(code: "entity.submission"))
        }else if(controllerName.equals("group")){
            out<< header() << ''' <script type="text/javascript">
                                $(function(){
                                    $(".group-button").addClass('group-button-active');
                                    $("#group-icon").addClass('group-icon-active');
                                    $("#group").addClass('group-button-active2');
                                    $(".icon-group").addClass('group-icon-active2');
                                });
                              </script>'''
            if (session.license.isStudent()) {
                out << ''' / ''' + g.link(controller:"group", action:"list", g.message(code: "entity.group"))
            }else {
                out << ''' / ''' + g.link(controller:"group", action:"index", g.message(code: "entity.group"))
            }
            if(actionName.equals("manage")) {
                out << ''' / ''' + g.message(code:"group.manage.users")
            }

        }else if(controllerName.equals("problem")){
            out<< header() << ''' <script type="text/javascript">
                                $(function(){
                                    $(".problem-button").addClass('problem-button-active');
                                    $("#problem-icon").addClass('problem-icon-active');
                                });
                              </script>'''
            out << ''' / ''' + g.link(controller:"problem", action:"index", g.message(code: "entity.problems"))
        }else if(controllerName.equals("quest")){
            out<< header() << ''' <script type="text/javascript">
                                $(function(){
                                    $(".quest-button").addClass('quest-button-active');
                                    $("#quest-icon").addClass('quest-icon-active');
                                });
                              </script>'''
            out << ''' / ''' + g.link(controller:"quest", action:"index", g.message(code: "entity.questionnaires"))
        }else if(controllerName.equals("course")){
            out<< header() << ''' <script type="text/javascript">
                                $(function(){
                                    $(".course-button").addClass('course-button-active');
                                    $("#course-icon").addClass('course-icon-active');
                                });
                              </script>'''
                out << ''' / ''' + g.link(controller:"course", action:"index", g.message(code: "entity.course"))
        }else if(controllerName.equals("similarity")){
            out << ''' / ''' + g.message(code: "entity.similarity")
        }else if(controllerName.equals("content")){
            out << ''' / ''' + g.link(controller:"content", action:"index", g.message(code: "entity.content"))

        }else if(controllerName.equals("forum")){
            out << ''' / ''' + g.link(controller:"forum", action:"index", g.message(code: "entity.forum"))

        }else if(controllerName.equals("referenceSolution")){
            out << ''' / ''' + g.link(controller:"referenceSolution", action:"list", g.message(code: "entity.reference.solutions"))

        }else if(controllerName.equals("user")){
            out << ''' / ''' + g.message(code: "entity.users")

        }else if(controllerName.equals("help")){
            out << ''' / ''' + g.link(controller:"help", action:"index", g.message(code: "entity.help"))

        }else if(controllerName.equals("license")){
            if (session.license.isAdminInst()){
                out << ''' / ''' + g.message(code: "entity.license")
            } else if (session.license.isAdmin()) {
                out << ''' / ''' + g.message(code: "entity.license")
            }


        }else if(controllerName.equals("auth")){
            if (actionName.equals("contact")){
                out << ''' / ''' + g.message(code: "auth.contact")
            }
        }else{
            more = false
            out << ''' / Home '''
        }

        if(more){
            if (actionName.equals("list") || actionName.equals('index')){
                out << ''' / ''' + g.message(code: "variable.list")
            }
            if (actionName.equals("show") || actionName.equals("showStatistics")){
                out << ''' / ''' + g.message(code: "variable.show")
            }
            if (actionName.equals("compare")){
                out << ''' / ''' + g.message(code: "variable.compare")
            }
            if (actionName.equals("create") || actionName.equals("management") || actionName.equals("createSingle") || actionName.equals("createGroup")){
                out << ''' / ''' + g.message(code: "variable.manage")
            }
            if (actionName.equals("create2")){
                out << ''' / ''' + g.message(code: "variable.manage") + ''' / ''' + g.message(code: "variable.second.step")
            }
            if (actionName.equals("create3")){
                out << ''' / ''' + g.message(code: "variable.manage") + ''' / ''' + g.message(code: "variable.third.step")
            }
            if (controllerName.equals('group') && actionName.equals("add")){
                out << ''' / ''' + g.message(code: "variable.add.user")
            }
            if(actionName.equals("changePassword")){
                out << ''' / ''' + g.message(code: "verbosity.change.password")
            }
            if(actionName.equals("showDiff")){
                out << ''' / ''' + g.message(code: "verbosity.diff")
            }
        }





        out << '''</b>'''
    }
    def mainMenu = {attrs->
        String questContent = """<div class="menu-icon">
                        <div id="quest-icon"></div>
                    </div>
                    <div class="label">${message(code:'entity.quests')}</div>
                    <div class="line" id="quest-line"></div>
                    """
//        String courseContent = """<div class="menu-icon">
//                        <div id="course-icon"></div>
//                    </div>
//                    <div class="label">${message(code:'entity.courses')}</div>
//                    <div class="line" id="course-line"></div> """
        String problemContent = """ <div class="menu-icon">
                        <div id="problem-icon"></div>
                    </div>
                    <div class="label">${message(code:'entity.problems')}</div>
                    <div class="line" id="problem-line"></div> """
        String submissionContent = """   <div class="menu-icon">
                        <div id="submission-icon"></div>
                    </div>
                    <div class="label">${message(code:'entity.submissions')}</div>
                    <div class="line" id="submission-line"></div> """

        out << """<div id="main-menu">
        <ul>
            <li>
            ${g.link elementId:"problem-button", class:"menu-button problem-button", controller:"problem",problemContent}
            </li>

            <li>
            ${g.link elementId:"submission-button", class:"menu-button submission-button", controller:"submission", submissionContent}
            </li>

            <li>
                ${g.link elementId:"quest-button", class:"menu-button quest-button", controller:"quest", questContent}
            </li>

             """

//        <li>
//                ${g.link elementId:"course-button", class:"menu-button course-button", controller:"course", courseContent}
//        </li>

        if(!session.license?.isStudent()){
            String groupContent = """ <div class="menu-icon">
            <div id="group-icon"></div>
                    </div>
            <div class="label">${message(code:'entity.group')}</div>
                    <div class="line" id="group-line"></div>"""

           out << """ <li>
           ${g.link elementId:"group-button", class:"menu-button group-button", controller:"group",groupContent}
            </li>   """
       } else {
            String groupContent = """ <div class="menu-icon">
            <div id="group-icon"></div>
                    </div>
            <div class="label">${message(code:'entity.group')}</div>
                    <div class="line" id="group-line"></div>"""

            out << """ <li>
           ${g.link elementId:"group-button", class:"menu-button group-button", controller:"group", action: "list",groupContent}
            </li>   """
        }
        out << '''</ul>
    </div>'''
    }

    def changeLicense = {attrs ->
        def licenses = []
		if (session.profile) {
			licenses = License.findAllByUser(session.profile.user)
		}

        def targetUri = request.forwardURI.replace(request.contextPath, "")
        targetUri += request.queryString ? ("?" +  request.queryString) : ""

        out << '''<script>$(function () {$('button#cancel-change-license').click(function(e) {e.preventDefault(); huxley.closeModal();}); });</script>'''
        out << """
        <div id="license-selection" class="modal" style="color: #858484;">
        <h3 style="font-size: 16x; font-weight: bold; padding-bottom: 20px;">${g.message code: "verbosity.whatLicense"}<hr /></h3>
        <form action="/huxley/home/changeLicense">
        <input type="hidden" name="targetUri" value="${targetUri}" id="targetUri">
        """
        def licenseId = 0
        if (session.license){
            licenseId = session.license.id
        }

        licenses.eachWithIndex {license, i ->
            out << """
            <div style="padding-bottom: 10px; display: table;">
                    <div style="display: table-cell; vertical-align: middle; padding-right: 10px;">${g.radio name: "license", value: license.id, id: "license-" + license.id, checked: (licenseId==0)&&(i == 0)||(licenseId==license.id)}</div>
                    <div style="display: table-cell; vertical-align: middle;">
                        <div style="font-weight: bold; font-size: 14px;"><label for"license-$license.id">${license.type?.name}</label></div>
            <div style="font-size: 10px;">${license.institution ? license.institution.name : g.message(code: "verbosity.institutionNotAssociated")}</div>
                    </div>
            </div>
            """
        }

        out << """
        <div style="float: right;">
        <button class="button" style="border: none; background-color: #1BD482;" onclick="huxley.closeModal();" id="cancel-change-license">${g.message code: "verbosity.cancel"}</button>
            ${g.submitButton style: "border: none;", class: "button", name: "license-selection", value: g.message( code: "verbosity.select")}
        </div>
        </form>
        </div>
        """
        if (!session.chosenLicense) {
            out << """
                <script type="text/javascript">
                    \$(function() {huxley.openModal('license-selection');});
                </script>
            """
        }
    }

}
