package com.thehuxley

class ProblemTagLib {

    static namespace = "huxley"

    def problemService

    def accordion = {attrs ->

        out << """
        ${r.external dir: 'js', file: 'huxley-problem.js', disposition: 'head'}
        ${r.external dir: 'js', file: 'fileuploader.js', disposition: 'head'}
        ${r.external dir: 'css', file: 'problem-accordion.css', disposition: 'head' }
    """

        out << """
        <script type="text/javascript">
            \$(function() {
                huxleyProblem.setValues($attrs.total);
                huxleyProblem.getProblemList(0);
                huxley.startAccordion('accordion');
                huxleyProblem.setChangeFunction(huxleyProblem.getProblemList,0);
                huxley.createSlider('slider-range','minamount','maxamount',1,10,huxleyProblem.setLevelMin,huxleyProblem.setLevelMax);
                huxley.createSlider('slider-range2','minamount2','maxamount2',1,10,huxleyProblem.setNdMin,huxleyProblem.setNdMax);
                huxleyProblem.getPendingSubmission();
                huxleyProblem.toggleProblemStatus();

                \$('#input-problem').keyup(function() {
                    clearTimeout(problemSearchInputTimeOut);
                    problemSearchInputTimeOut = setTimeout(function() {
                        huxleyProblem.setName(\$("#input-problem").val());
                    }, 1000);
                });
            });

            \$(function() {
                \$('#button-filter').button().click(function() {
                    var options;
                    if (\$(this).text() == '${g.message code: "problem.advanced.filter"}') {
                        options = {
                            label: '${g.message code: "problem.advanced.filter.hide"}'
                        }
                        \$(".advanced-problem-filter").slideDown('fast');
                    } else {
                        options = {
                            label: '${g.message code: "problem.advanced.filter"}'
                        }
                        \$(".advanced-problem-filter").slideUp('fast');
                    }

                    \$(this).button( "option", options );
                });

                \$('#temp-topic option').each(function() {
                    if (index == 1){
                        huxleyProblem.selectedId = this.value;
                    } else {
                        huxleyProblem.selectedId = huxleyProblem.selectedId + "," + this.value;
                    }
                    index ++;
                });

                if (\$('#temp-topic option').length > 0) {
                    huxleyProblem.setTopicList();
                    huxleyProblem.updateSelectedId();
                    \$('#topic-list-id').attr('value', huxleyProblem.selectedId);
                }

                \$('#temp-topic').remove();
            });
            \$(function() {
                \$('#search-param').keyup(function() {
                    clearTimeout(topicSearchInputTimeOut);
                    topicSearchInputTimeOut = setTimeout(function() {
                        huxleyProblem.getTopicList();
                    }, 1000);
                });
            });
            var topicSearchInputTimeOut;
        </script>
    """

        out << """
        ${r.external dir: 'js', file: 'problem-accordion.js', disposition: 'head' }
    """

        out << """
        <div class="box" style="display: table;">
            <h3>${g.message code:"problem.find"}</h3>

            <form action="" method="post">
                <input type="text" name="problema" placeholder="${g.message code:"problem.tip.problem"}" style="width: 80%; margin-bottom: 20px;" class="ui-input" id="input-problem"  />
                <input type="submit" value="Avançado" class="ui-bbutton" />
            </form>

            <h3>${g.message code:"problem.nd"}:</h3>

            <div class="slider">
                <input type="readonly" class="num" id="minamount" style="border:0; float: left;" readonly="readonly"/>
                <div id="slider-range" style="width: 89%; float: left; margin-right: 10px;"></div>
                <input type="readonly" class="num" id="maxamount" style="border:0;" readonly="readonly"/>
            </div>

            <div class="advanced-problem-filter">
                <div style="width: 500px; padding-top: 10px;">
                    <label for="include-accepted">${g.message code:"problem.includeresolved"}:</label><input id="include-accepted" onclick="huxleyProblem.setIncludeAccepted(this.checked)" type="checkbox" name="resolved" value="true" checked="checked" />
                </div>
            </div>

            <div style="float:right;"><button id="button-filter">${g.message code:"problem.advanced.filter"}</button></div>

            <div class="clear"></div>

            <div id ="topic-filter" class ="advanced-problem-filter">
                <input type="text" id="search-param" name="fname" style="margin-left:200px; width:170px;"/>

                <div style="margin-left:200px" >
                    <select name="box-search" multiple="true" id="box-search" style="height:125px; width:175px; float: left;"></select>

                    <span id="toolbar" class="toolbar" style="float: left;" >
                        <ul style="list-style-type: none;">
                            <li><button id="play">${g.message code:"problem.select.single"}</button></li>
                            <li><button id="forward">${g.message code:"problem.select.all"}</button></li>
                            <li><button id="beginning">${g.message code:"problem.deselect.single"}</button></li>
                            <li><button id="rewind">${g.message code:"problem.deselect.all"}</button></li>
                        </ul>
                    </span>

                    <select name="box-selected" multiple="true" id="box-selected" style="height:125px; width:175px; float: left;"></select>
                </div>
            </div>

        </div>
        <hr /><br />
        <div id="accordion">
    """

        String content = ""

        for (int i = 0; i < Integer.parseInt(attrs.total); i++) {
            content += """
            <div class="group" id="tab-$i">
                <h3 id="title-container-$i"><a href="#" id="header-problem-title-$i"></a></h3>

                <div class="tab-panel">
                    <div class="tab-left-panel">
                        <ul>
                            <li><b>${g.message code:"problem.topics"}:</b> <span  id="problem-topic-list-$i"></span></li>
                            <li><b>${g.message code:"problem.nd"}:</b> <span id="problem-nd-$i"></span</li>
                            <li><b>${g.message code:"problem.user.best.time"}:</b> <span id= "problem-user-best-time-$i"></span></li>
                            <li><b>${g.message code:"problem.best.time"}:</b> <span id="problem-best-time-$i"></span></li>
                        </ul>
                    </div>

                    <div class="tab-right-panel">
                        <b>${g.message code: "problem.last.submission"}: <span id="problem-last-submission-$i"></span></b>
                    </div>

                    <div class="clear-both"></div>

                    <div class="menu-panel">
                        ${g.link url: 'javascript:void(0);', onclick: "javascript:huxley.openModal('modal-window-$i')",  target: "_self",  class: "button", g.message(code: "problem.description")}
                        ${g.link target: "_self",  class: "button", g.message(code: "problem.see.submissions")}
                        <div class="ui-gbutton" style="font-size: 15px; color: #fff; position: relative; float:left;" id="submit-button-$i"></div>
                    </div>

                    <div class="clear-both end"></div>
                </div>
            </div>

            <div id="modal-window-$i" class="modal-window">
                <div id="dialog-$i" class="problem-modal-show">
                    <a href="javascript:huxley.closeModal()" class="close" font-size: 22px;>×</a>
                    <h2>${g.message code:"problem.description"}</h2>
                    <hr />
                    <br />
                    <li >${g.message code:"entity.problem"}:&nbsp;<b id="problem-title-modal-$i"></b></li>
                    <hr />
                    <li >${g.message code:"problem.topics"}:&nbsp;<span id="problem-topic-list-modal-$i"></span></li>
                    <hr />
                    <div class="right" id="reference-solution-$i"></div>

                    <div class="left">
                        <h2>${g.message code:"problem.description"}&nbsp;</h2>
                        <div class="problem-description-item" id="problem-description-modal-$i"></div>
                        <h2>${g.message code:"problem.input.format"}&nbsp;</h2>
                        <div class="problem-description-item" id="problem-input-modal-$i"></div>
                        <h2>${g.message code:"problem.output.format"}&nbsp;</h2>
                        <div class="problem-description-item" id="problem-output-modal-$i"></div>
                    </div>

                    <div class="clear-both"></div>
                    <hr />
                    <div class="menu-panel">
                        ${g.link target: "_self",  class: "button", g.message(code: "problem.see.submissions")}
                        ${g.link target: "_self",  class: "button", g.message(code: "problem.input.example")}
                        ${g.link target: "_self",  class: "button", g.message(code: "problem.output.example")}
                    </div>

                    <div class="clear-both end"></div>
                </div>
            </div>
        """
        }

        out << content + "</div>";

        out << '''
        <div id="pagination" class="ui-pagination"></div>
        <div class="clear"></div>
        <br />
    '''
    }

    def problems = { attrs ->

        def problems = []
        def user
        def total = 0
        def questProblems = [:]

        if (!attrs.user) {
            user = session.profile.user
        } else {
            user = attrs.user
        }

        if (!attrs.problems && !attrs.questionnaireProblems) {
            def parameters = [:]
            try{
                parameters.ndMax = Integer.parseInt(parameters.ndMax)
            }catch (Exception e){
                parameters.ndMax = 10
            }
            try{
                parameters.ndMin = Integer.parseInt(parameters.ndMin)
            }catch(Exception e){
                parameters.ndMin = 0
            }
            if(parameters.topicsCount == "0" || !parameters.topicsCount){
                parameters.topics = null
                parameters.topicsCount = null
            }else{
                parameters.topics = "(" + parameters.topics +")"
                parameters.exclusive = true
            }
            if(attrs.resolved){
                parameters.put('resolved', false)
            }else{
                parameters.put('resolved', true)
            }

            parameters.put('max', attrs.total)
            parameters.put('userId', user.id)

            def result = problemService.google(parameters)
            problems = result.get(ProblemService.FILTER_PROBLEM_LIST)
            total = result.get(ProblemService.FILTER_SIZE)
        } else {
            if (attrs.problems) {
                problems = attrs.problems
            } else if (attrs.questionnaireProblems) {
                attrs.questionnaireProblems.each {
                    problems.add(it.problem)
                    questProblems.put(it.problem.id, it.score);
                }
            }

        }
        out << """
            ${r.external dir: 'js', file: 'huxley-problem.js', disposition: 'head'}
            ${r.external dir: 'js', file: 'fileuploader.js', disposition: 'head'}
            ${r.external dir: 'js', file: 'problem-accordion.js', disposition: 'head'}
            ${r.external dir: 'css', file: 'problem-accordion.css', disposition: 'head'}
            <script type="text/javascript">
                \$(function() {
                """
        if (attrs.resolved){
            out << """\$('input[name=resolved]').attr('checked',$attrs.resolved);
                    huxleyProblem.includeAccepted = $attrs.resolved;
                    """
        }

        out <<"""huxley.accordion('accordion', {
                        onOpen: function(element) {
                            huxley.createUploader(\$(element).attr('data'), 'submit-button-' + \$(element).attr('data'));
                        }
                    });
                    changeStatus();
                    huxleyProblem.getPendingSubmission();
                    huxleyProblem.setValues(20);
                    huxley.generatePagination('problem-pagination',huxleyProblem.getProblemList,huxleyProblem.limit,${total});
                huxleyProblem.setChangeFunction(huxleyProblem.getProblemList,0);
                huxley.createSlider('slider-range','minamount','maxamount',1,10,huxleyProblem.setNdMin,huxleyProblem.setNdMax);
                });

            \$(function() {
                \$('#input-problem').keyup(function() {
                    clearTimeout(problemSearchInputTimeOut);
                    problemSearchInputTimeOut = setTimeout(function() {
                          huxleyProblem.setName(\$("#input-problem").val());
                    }, 1000);
                });
            });
            var problemSearchInputTimeOut;
            function toggleFilter(){
                    if (\$('#button-filter').hasClass('ui-bbutton')) {
                          \$('#button-filter').empty();
                          \$('#button-filter').removeClass('ui-bbutton')
                          \$('#button-filter').append('${g.message code: "problem.advanced.filter.hide"}');
                          \$('#button-filter').addClass('ui-rbutton')

                        \$(".advanced-problem-filter").slideDown('fast');
                    } else {
                        \$('#button-filter').empty();
                            \$('#button-filter').removeClass('ui-rbutton')
                            \$('#button-filter').append('${g.message code: "problem.advanced.filter"}');
                            \$('#button-filter').addClass('ui-bbutton')

                        \$(".advanced-problem-filter").slideUp('fast');
                    }


                };


            huxley.createReferenceSolutionTable = function (id) {
                \$.ajax({
                    url: '/huxley/referenceSolution/listByProblem',
                    data: {id: id},
                    dataType: 'json',
                    success: function(data) {
                        var row;
                        var index = 0;
                        \$('#problem-reference-list-' + id).empty();
                        \$.each(data.referenceList, function(i, reference) {
                            index ++;
                            if(index%2==0){
                                row = '<tr class="odd">';
                            }else{
                                row = '<tr class="even">';
                            }

                            if (reference.id != 0) {
                                row += '<td class="list-label">' + reference.language + '</td><td class="list-label"><a href="${resource(dir:'/')}referenceSolution/show/'+reference.id+'">${g.message(code: "reference.solution.visualize")}</a></td></tr>';

                            }else{
                                row += '<td class="list-label">' + reference.language + '</td><td class="list-label">${g.message(code: "reference.solution.permission")}</td></tr>';
                            }
                            \$('#problem-reference-list-' + id).append(row);
                        });
                        \$.each(data.notAvaiableList, function(i, reference) {
                            index ++;
                            if(index%2==0){
                                row = '<tr class="odd">';
                            }else{
                                row = '<tr class="even">';
                            }
                            if(reference.status == "ok"){
                                row += '<td class="list-label">'+reference.name + '</td><td class="list-label"><a href="${resource(dir:'/')}referenceSolution/create?id=' +id +'&language='+reference.name+'"> ${g.message code: "reference.solution.create"}</a></td></tr>';
                            }else{
                                row += '<td class="list-label">' + reference.name + '</td><td class="list-label">${g.message code: "reference.solution.none"}</td></tr>';
                            }

                            \$('#problem-reference-list-' + id).append(row);

                        });
                    }

                });
            };

            \$(function() {
                \$('#temp-topic option').each(function() {
                    if (index == 1){
                        huxleyProblem.selectedId = this.value;
                    } else {
                        huxleyProblem.selectedId = huxleyProblem.selectedId + "," + this.value;
                    }
                    index ++;
                });

                if (\$('#temp-topic option').length > 0) {
                    huxleyProblem.setTopicList();
                    huxleyProblem.updateSelectedId();
                    \$('#topic-list-id').attr('value', huxleyProblem.selectedId);
                }

                \$('#temp-topic').remove();
            });

            function openProblemModal(id) {
                huxley.openModal('modal-window-' + id);
                huxley.createReferenceSolutionTable(id);
            }
             \$(function() {
                \$('#search-param').keyup(function() {
                    clearTimeout(topicSearchInputTimeOut);
                    topicSearchInputTimeOut = setTimeout(function() {
                        huxleyProblem.getTopicList();
                    }, 1000);
                });
            });
            var topicSearchInputTimeOut;
            </script>
        """
        if (attrs.search != 'false') {
            out << """
                <div class="box" style="display: table;">
                    <h3>${g.message code:"problem.find"}</h3>

                    ${g.form(action: 'index', controller:'problem', """
                        <input type="text" name="problem" placeholder="${g.message code:"problem.tip.problem"}" style="width: 80%; margin-bottom: 20px;" class="ui-input" id="input-problem"  />
                        <span class="ui-bbutton" id="button-filter" onClick="toggleFilter()" style="float:right;">${g.message code:"problem.advanced.filter"}</span>

                    """)}


                    <h3>${g.message code:"problem.nd"}:</h3>

            <div class="slider">
                <input type="readonly" class="num" id="minamount" style="border:0; float: left;" readonly="readonly"/>
                <div id="slider-range" style="width: 89%; float: left; margin-right: 10px;"></div>
                <input type="readonly" class="num" id="maxamount" style="border:0;" readonly="readonly"/>
            </div>

            <div class="advanced-problem-filter">
                <div style="width: 500px; padding-top: 10px;">
                    <label for="include-accepted">${g.message code:"problem.includeresolved"}:</label><input id="include-accepted" onclick="huxleyProblem.setIncludeAccepted(this.checked)" type="checkbox" name="resolved" value="true" checked="checked" />
                </div>
            </div>



            <div class="clear"></div>

            <div id ="topic-filter" class ="advanced-problem-filter">
                <input type="text" id="search-param" name="fname" style="margin-left:200px; width:170px;"/>

                <div style="margin-left:200px" >
                    <select name="box-search" multiple="true" id="box-search" style="height:125px; width:175px; float: left;"></select>

                    <span id="toolbar" class="toolbar" style="float: left;" >
                        <ul style="list-style-type: none;">
                            <li><button id="play">${g.message code:"problem.select.single"}</button></li>
                            <li><button id="forward">${g.message code:"problem.select.all"}</button></li>
                            <li><button id="beginning">${g.message code:"problem.deselect.single"}</button></li>
                            <li><button id="rewind">${g.message code:"problem.deselect.all"}</button></li>
                        </ul>
                    </span>

                    <select name="box-selected" multiple="true" id="box-selected" style="height:125px; width:175px; float: left;"></select>
                </div>
            </div>

        </div>
                <hr/>
                <br/>
            """
        }
        out << """
            <div id="accordion">
        """
        def changeStatus = "";

        problems.eachWithIndex {problem, i ->
            def info = problemService.getProblemContent(problem.id, user.id)

            if (info.status == UserProblem.TRIED) {
                changeStatus += "huxley.setProblemWrong('title-problem-$problem.id');\n"
            } else if (info.status == UserProblem.CORRECT) {
                changeStatus += "huxley.setProblemCorrect('title-problem-$problem.id');\n"
            }

            out << """
                <h3 id="title-problem-$problem.id" data="$problem.id">$info.name""" 

            if (attrs.questionnaireProblems) {
                out << """
                    <span style="font-weight: normal; font-size: 11px; margin-left: 10px; color: #AAA;">${g.message code: 'questionnaire.score'}: <span style="font-weight: bold;">${questProblems.get(problem.id)}</span></span>
                """
            }
                
            out << """</h3>
                <div class="problem-content">
                    <div class="tab-left-panel">
                        <ul>
                            <li><b>${g.message code:"problem.topics"}:</b> <span  id="problem-topic-list-$i">
            """
            info.topics.eachWithIndex {topic, j ->
                if (j == (info.topics.size() - 1)) {
                    out << "$topic"
                } else {
                    out << "$topic, "
                }
            }

            out << """
                            </span></li>
                            <li><b>${g.message code:"problem.nd"}:</b> <span id="problem-nd-$i">${g.formatNumber([number: info.nd, formatName: "huxley.format"])}</span</li>
                            <li><b>${g.message code:"problem.user.best.time"}:</b> <span id= "problem-user-best-time-$i">${info.userRecord ? info.userRecord + 's': g.message(code: "verbosity.youNeverTry") }</span></li>
                            <li><b>${g.message code:"problem.best.time"}:</b><span id="problem-best-time-$i"> ${info.record.user ? info.record.time + 's' + ' ' + '(' +  huxley.user(user: info.record.user, info.record.user.name) + ')' + ' ': g.message(code: "verbosity.anybodyNeverTry")}</span></li>
                        </ul>
                    </div>

                    <div class="tab-right-panel">
                        <b>${g.message code: "problem.last.submission"}:</b> <span id="problem-last-submission-$i">${info.lastSubmission ? g.link(action: 'downloadSubmission', controller: 'submission', params: [bid: info.lastSubmission.id], info.lastSubmission.submission) : g.message(code: 'verbosity.youHaveNotSubmitted')}</span>
                    </div>

                    <div style="clear: left;"></div>

                    <div class="menu-panel">
                        ${g.link url: 'javascript:void(0);', onclick: "javascript:openProblemModal($problem.id)",  target: "_self",  class: "button", g.message(code: "problem.description")}
                        ${g.link action: 'index', controller: 'submission', params: ['problemId': "$info.id",'userId': "$user.id"],  class: "button", g.message(code: "problem.see.submissions")}
                        <div class="ui-gbutton" style="font-size: 15px; color: #fff; position: relative; float:left;" id="submit-button-$problem.id"></div>
                    </div>

                    <div style="clear: left;"></div>

                    <div id="modal-window-$problem.id" class="modal-window">
                        <div id="dialog-$problem.id" class="problem-modal-show">
                            <a href="javascript:huxley.closeModal()" class="close" font-size: 22px;>×</a>
                            <h2>${g.message code:"problem.description"}</h2>
                            <hr />
                            <br />
                            <span >${g.message code:"entity.problem"}:&nbsp;<b id="problem-title-modal-$problem.id"></b>$problem.name</span>
                            <hr />
                            <br>
                            <span >${g.message code:"problem.topics"}:&nbsp;<span id="problem-topic-list-modal-$problem.id"></span>$info.topics</span>
                            <hr />
                            <br>
                            <i class="creator-description">
                                ${g.message(code: "verbosity.createdBy")}
                                <span id="user-created-$problem.id">${huxley.user(user: problem.userSuggest, problem.userSuggest.name)}</span>
                                ${g.message(code: "verbosity.updatedAt")}
                                    <span class="date" id="date-created-$problem.id">${formatDate(date: problem.lastUpdated, format: 'dd/MM/yyyy')}</span>
                                <span id="date-created2-$problem.id" ${formatDate(date: problem.lastUpdated, format: 'HH:mm')}</span>
                                    ${g.message(code:"verbosity.source")}:
                                    """
                                if (problem.source){
                                out << """${problem.source}"""
                                }else{
                                    out << """ ${g.message(code:"verbosity.not.informed")}"""
                                }

                            out << """</i>
                            <div class="left" style="width: 100%; max-width: 100%;">
                                <h2>${g.message code:"problem.description"}&nbsp;</h2>
                                <div class="problem-description-item" id="problem-description-modal-$problem.id">$info.description</div>
                                <h2>${g.message code:"problem.input.format"}&nbsp;</h2>
                                <div class="problem-description-item" id="problem-input-modal-$problem.id">$info.input</div>
                                <h2>${g.message code:"problem.output.format"}&nbsp;</h2>
                                <div class="problem-description-item" id="problem-output-modal-$problem.id">$info.output</div>
                            </div>

                            <div class="clear-both"></div>
                            <hr />
                            <div class="menu-panel">
                                ${g.link action: 'index', controller: 'submission', params: ['problemId': "$info.id",'userId': "$user.id"],  class: "button", g.message(code: "problem.see.submissions")}
                                ${g.link action: 'downloadInput', controller: 'problem', id: "$info.id",  class: "button", g.message(code: "problem.input.example")}
                                ${g.link action: 'downloadOutput', controller: 'problem', id: "$info.id",  class: "button", g.message(code: "problem.output.example")}
                            </div>

                            <div class="clear-both end"></div>
                        </div>
                    </div>
                </div>
        """
        }

        out << """
            </div>
            <div id="problem-pagination" class="ui-pagination" style="margin:4px; text-align:center; float:none"></div>
            <script type="text/javascript">
                function changeStatus() {
                    $changeStatus
                };
            </script>
        """
    }

    def problemBox= { attrs, body ->

        def problem, user, topics = ""

        if (attrs.problem) {
            problem = attrs.problem
        } else if (attrs.id) {
            problem = Problem.get(attrs.id)
        }

        if (attrs.user) {
            user = attrs.user
        } else {
            user = session.profile.user
        }

        problem.topics.eachWithIndex {topic, j ->
            if (j == (problem.topics.size() - 1)) {
                topics = topics + "${topic.name}"
            } else {
                topics = topics + "${topic.name}, "
            }
        }

        if (problem) {

            out << """
                <div class="problem-item" id="problem-box-${problem.id}">
                    <div class="problem-box">
                        <div class="title">${problem.name}</div>
                        <div><span class="label" style="margin-left: 15px;">${g.message(code: "problem.nd")}: </span>${g.formatNumber([number: problem.nd, formatName: "huxley.format"])}</div>
                        <div><span class="label">${g.message(code: "problem.topics")}: </span>${topics}</div>
                    </div>
                    <div class="icon">
                        ${body()}
                    </div>
                    <div style="clear: left;"></div>
                </div>
            """
        }
    }

    def problemSelection = { attrs ->

        def problemList = Problem.list()


        out << """
            <div class="box">
                <h3>Adicionando problemas</h3>
                <g:form action="index">
                    <input id="input-problem" class="ui-input2" type="text" style="width: 62%;" placeholder="Procurar problema..." name="name">
                    <h3 class="problem-form-slide-label">${g.message code:"problem.initial.dinamic.level"}: <span id="difficulty-level"></span></h3>
                    <div class="slider">
                        <input type="readonly" class="num" id="minamount" style="border:0; float: left;" readonly="readonly"/>
                        <div id="topic-slider-range" style="width: 89%; float: left; margin-right: 10px;"></div>
                        <input type="readonly" class="num" id="maxamount" style="border:0;" readonly="readonly"/>
                    </div>
                </g:form>
            </div>"""
        if (attrs.topicFilter){
            out << """<hr><br><div class="box">${huxley.topicFilter(topicFilter:"true")}</div>"""
        }
        out<< """
            <hr>
            <br>
            <div id="box-problem" style="border: 1px solid #E6E6E6;">
                <div style="height: 20px; background: white;"class="cont-problem"></div>
                <div class="questleft">
                    <h3 style="margin-bottom: 0px;">Problemas</h3>
                    <div id="problem-list" style="height: 555px; overflow-y: auto; padding: 0px; width: 351px;"></div>
                </div>
                <div class="questright">
                    <h3 style="margin-bottom: 0px;">Selecionados</h3>
                    <div id="selected-list" style="height: 555px; overflow-y: auto; padding: 0px; width: 351px;"></div>
                </div>
                <div style="clear: both;"></div>
            </div>

        """
    }

    def management = {
        out << """
                <div class="box">
                    <h3>${g.message code:"entity.problem"}"""
                if (session.license.isAdmin()){
                    out << "${g.link( action:"management2", class:"ui-rbutton",  style:"float:right;", "${g.message(code:'verbosity.advanced')}")}"
                }
                out << """${g.link( action:"create", class:"ui-gbutton",  style:"float:right;", "${g.message(code:'problem.create')}")}

                </h3>
                    <form action="" method="post">
                """
        if(session.license.isAdmin()){
                out << """<input type="text" name="submissao" placeholder="${g.message code:"submission.tip.user"}" style="width: 62%;" class="ui-input2" id="input-user"  />"""
        }
        out << """<input type="text" name="submissao" placeholder="${g.message code:"submission.tip.problem"}" style="width: 62%;" class="ui-input2" id="input-problem"  />
                <hr /><br />
                <h3>${g.message code:"vebosity.status"}
                <span class="ui-custom-select" style="float:right;display:table;width:73%;margin-top:-5px;">
                <select name="status" id="status-list" style="width:100%;" onchange="getProblem(0)">
                <option value="1">${g.message(code: "verbosity.waiting")}</option>
                <option value="2">${g.message(code: "verbosity.accepted")}</option>
                <option value="3">${g.message(code: "verbosity.rejected")}</option>
            </select>
                    </span>
                    </h3></form>
            </div>
            <hr /><br />

    <table class="submission-table">
    <thead>
        <th onclick = "setSort('p.name','problem')">${g.message code:"entity.problem"}<img id="img-problem" class="submission-sort" src="${resource(dir:'images/icons', file:'sorted_none.gif')}"/></th>
        <th onclick = "setSort('p.dateCreated','date')">${g.message code:"verbosity.date.suggest"}<img id="img-date" class="submission-sort" src="${resource(dir:'images/icons', file:'sorted_none.gif')}"/></th>"""
        if(session.license.isAdmin()){
            out << """<th onclick = "setSort('p.userSuggest.name','user')">${g.message code:"entity.user"}<img id="img-user" class="submission-sort" src="${resource(dir:'images/icons', file:'sorted_none.gif')}"/></th>"""
        }
        out << """<th>${g.message code:"vebosity.status"}</th>
        <th>Ações</th>
        </thead>
        <tbody id="problem-list"></tbody>
    </table>
    <div class="ui-pagination" id="problem-pagination"></div>"""


    }

}

