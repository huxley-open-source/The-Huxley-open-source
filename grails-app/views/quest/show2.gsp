<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'huxley-problem.js')}"></script>
    <script src="${resource(dir:'js', file:'fileuploader.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'problem-accordion.css')}" type="text/css">
    <script src="${resource(dir:'js', file:'problem-accordion.js')}"></script>
<script src="<g:resource dir="js" file="underscore-min.js"/>" type="text/javascript"></script>
<script src="<g:resource dir="js" file="mustache.min.js"/>" type="text/javascript"></script>

<style>
.linenum a {color: #909090 !important;}

TD.linenum {
    text-align: right;
    vertical-align: top;
    font-weight: bold;
    border-right: 1px solid black;}
.diff-table {overflow:auto; max-height:270px; max-width: 950px; margin-top: 10px;}
.diff-table table {
    min-width: 500px;
}
TD.removed,TD.added,TD.modified { background-color: #f9ad81; padding: 0px 0px 0px 15px;white-space: pre-wrap; font-family: "Lucida Console", Monaco, monospace; font-size:14px}
TD.normal {background-color: #FFFFE1;padding: 0px 0px 0px 15px;white-space: pre-wrap; font-family: "Lucida Console", Monaco, monospace; font-size:14px}
TD.break-line {padding: 0px 0px 0px 15px;}
u {
    border-bottom: 2px red solid;
    text-decoration: none;
}
.legend { background-color: #fff799; padding: 0px 0px 0px 15px;}
.diff-legend-header {
    border-top-left-radius: 20px;
    border-top-right-radius: 20px;
    padding: 10px 0px 0px 15px;
}
.legend-box {
    position:absolute;
    top:0px;
    right: 0px;
    font-size:14px;
    border-left: 1px solid #928E8E;
    border-bottom: 1px solid #928E8E;
}
.title {
    font-weight: bold;
    background: white;
    margin-top: -10px;
    margin-left: 5px;
    padding: 0px 5px 0px 5px;
    color: #424242;
}
.subtitle {
    color: #424242;
    font-weight: bold;
    font-style: italic;
    margin: 5px 0px 0px 5px;
}

.tip-container {
    border: 1px #928E8E solid;
    border-radius: 5px;
}
.tip-container span {
    padding-left: 5px;
    display: inline-block;
}
.session {
    margin-top: 10px;
    border-top: 1px #928E8E solid;
    position: relative;

}
.session span {
    padding: 5px;
}
.input-example {
    white-space:pre;
    font-weight: bold;
    padding-left: 25px;
}
.console {
    font-size: 14px;
    color: white;
    font-weight: bold;
    background-color: black;
    white-space: pre;
    font-family: monospace;
    display: inline-block;
    margin: 6px 6px 6px 6px;
    padding: 12px 12px 12px 12px;
    border-style: solid;
    border-width: thin;
    border-color: black;
    max-height: 160px;
    overflow-y: auto;
}
.problem-modal-show a {
    color: #0DC9BA;
    text-decoration: none;
}

.language-table {
    width: 420px;
    max-width: 420px;
    height: 60px;
    margin: 0px 0 0px 0;
    text-align: center;
    color: #878787;
    font-size: 12px;
}

.language-table table {
    border: 1px solid #efefef;
    border-radius: 10px;
    text-align: center;
    width: 80%;
    height: 60%;
    font-size: 10px;
}
.language-table th {
    background: #efefef;
    text-align: center;
}

.language-table td {
    border: 1px solid #efefef;
}
</style>
<script type="text/javascript">

    $(function(){
        showProblems();
    });

    function showProblems() {
        var problemIds = new Array();
        <g:if test="${questionnaireProblems.size() > 0}">
        <g:each in="${questionnaireProblems}">
        var template = '<h3 id="title-problem-' + '${it.problem.id}' + '" data-id="' + '${it.problem.id}' + '">' + "${it.problem.name}" + '<span style="font-weight: normal; font-size: 11px; margin-left: 10px; color: #AAA;">Pontuação:<span style="font-weight: bold;">' + '${it.score}' + '</span></span></h3>' +
                '<div id="problem-content-' + '${it.problem.id}' + '" class="problem-content"><div>';

        $('#problem-list').append(template);
        problemIds.push(${it.problem.id})
        </g:each>
        </g:if>
        <g:else>
        <g:message code="questionnaire.with.empty.problems"/>
        </g:else>

        huxley.accordion('problem-list', {
            onOpen: function (el) {updateProblemInfo($(el).data().id);},
            onClose: function () {}
        });
        getProblemStatus(problemIds);
        huxleyProblem.getPendingSubmission();
    }

    function getProblemStatus (problemIds) {
        $.ajax('/huxley/problem/getProblemsStatus', {
            data: {problems: JSON.stringify(problemIds)},
            type: 'GET',
            dataType: 'json',
            success: function (data) {
                $.each(data.status, function (i, problem) {
                    if (problem.status == 1) {
                        huxley.setProblemCorrect('title-problem-' + problem.problem_id);
                        if($('#title-problem-tip-' + problem.problem_id).length !== 0) {
                            $('#title-problem-tip-' + problem.problem_id).remove()
                        }
                    } if (problem.status == 2) {
                        huxley.setProblemWrong('title-problem-' + problem.problem_id);
                        if($('#title-problem-tip-' + problem.problem_id).length === 0) {
                            $('#title-problem-' + problem.problem_id).append('<span class="problem-title-tip" id="title-problem-tip-' + problem.problem_id + '"><a href="javascript:void(0)"><g:message code="problem.title.tip"/> </a></span>')
                            $('#title-sproblem-tip-' + problem.problem_id).on('click',function () { tip(problem.problem_id); });
                        }
                    }
                });
            }
        });
    };

    function updateProblemInfo(id) {

        var template =  '<div class="tab-left-panel">' +
                '   <ul>' +
                '   <li><b><g:message code="problem.topics"/>:</b> <span>{{topics}}</span></li>' +
                '   <li><b><g:message code="problem.nd"/>:</b> <span>{{nd}}</span</li>' +
                '   <li><b><g:message code="problem.user.best.time"/>:</b> <span id="user-record-{{id}}">{{userRecord}}</span></li>' +
                '   <li><b><g:message code="problem.best.time"/>:</b><span> {{& record}}</span></li>' +
                '   </ul>' +
                '</div>' +
                '<div class="tab-right-panel">' +
                '   <b><g:message code="problem.last.submission"/>:</b> <span id="last-submission-{{id}}">{{& lastSubmission}}</span>' +
                '</div>' +
                '<div style="clear: left;"></div>' +
                '<div class="menu-panel">' +
                '</div>' +
                '<div style="clear: left;"></div><hr/>' +
                '<div class="menu-panel">' +
                '   <a class="button modal-button" href="#" data-id="{{id}}"><g:message code="problem.description"/></a>' +
                '   <a class="button" href="/huxley/submission/index?problemId={{id}}&userId=${session.profile.user.id}"><g:message code="problem.see.submissions"/></a>' +
                '   <a id="button-uploader-{{id}}"class="button" href="#" style="background: #1bd482;"></a>' +
                '   <a class="problem-help" href="#" class="problem-help"  style="font-size: 0.8em;">O que eu posso submeter?</a>' +
                '</div>' +
                '<div style="clear: left;"></div>';

        $.ajax('/huxley/problem/getProblemInfo', {
            data: {id: id},
            type: 'GET',
            dataType: 'json',
            beforeSend: function () {
                var spin = document.createElement('div');
                $('div#problem-content-' + id).empty().append(spin);

            },
            success: function (data) {
                var topics = "", problem = {}, recordInfo;

                $.each(data.topics, function (i, topic) {
                    if (i < (data.topics.length - 1)) {
                        topics += topic.name + ", ";
                    } else {
                        topics += topic.name;
                    }
                });

                problem.topics = topics;
                problem.nd = data.nd.toFixed(0);
                problem.id = data.id;

                if (data.fastestSubmission != null) {
                    problem.record = Mustache.render('{{time}}s <a href="/huxley/profile/show/{{hash}}">({{name}})</a>', {name: data.fastestSubmission.user.name, hash: data.fastestSubmission.user.hash, time: data.fastestSubmission.time.toFixed(4)});
                } else {
                    problem.record = '<g:message code="verbosity.anybodyNeverTry"/>';
                }

                recordInfo = getSubmissionInfo(data.id);
                problem.userRecord = recordInfo.userRecord
                problem.lastSubmission = recordInfo.lastSubmission
                $('div#problem-content-' + id).empty().append(Mustache.render(template, problem));
                huxley.createUploader(data.id, 'button-uploader-' + data.id);
                setButtonModalFunctions()
            }
        });
    };

    function getSubmissionInfo (pid) {
        var problem = {};
        $.ajax('/huxley/submission/getSubmissionInfo', {
            data: {id: pid},
            type: 'GET',
            dataType: 'json',
            success: function (data) {
                if (data.userRecord != null) {
                    problem.userRecord = data.userRecord.time.toFixed(4) + 's';
                } else {
                    problem.userRecord = '<g:message code="verbosity.youNeverTry"/>';
                }

                if (data.submissionLast != null) {
                    problem.lastSubmission = Mustache.render('<a href="/huxley/submission/downloadSubmission?bid={{id}}">{{submission}}</a>', {id: data.submissionLast.id, submission: data.submissionLast.submission});
                } else {
                    problem.lastSubmission = '<g:message code="verbosity.youHaveNotSubmitted"/>';
                }

                $('span#last-submission-' + pid).empty().append(problem.lastSubmission);
                $('span#user-record-' + pid).empty().append(problem.userRecord);
            }
        });

        return problem;
    }

    function setButtonModalFunctions () {
        $('a.modal-button').click(function (e) {
            e.preventDefault();
            var id = $(e.target).data().id;
            var template =  '<div id="modal-window" class="modal-window">' +
                    '   <div class="problem-modal-show">' +
                    '       <div>' +
                    '           <a href="javascript:huxley.closeModal()" class="close" style="font-size: 22px; font-weight: bold; color: grey;">×</a>' +
                    '           <h3 style="font-weight: bold; color: grey; font-size: 24px;">{{problem.name}}</h3>' +
                    '           <hr />' +
                    '       </div>'+
                    '           <div style="float: left; max-width: 445px; min-width: 445px;">' +
                    '               <ul>' +
                    '                   <li><b><g:message code="problem.topics"/>:</b> <span>{{problem.topics}}</span></li>' +
                    '                   <li><b><g:message code="problem.nd"/>:</b> <span>{{problem.nd}}</span</li>' +
                    '                   <li><b><g:message code="problem.user.best.time"/>:</b> <span>{{problem.userRecord}}</span></li>' +
                    '                   <li><b><g:message code="problem.best.time"/>:</b><span> {{& problem.record}}</span></li>' +
                    '               </ul>' +
                    '           </div>' +
                    '           <div style=" float: right; max-width: 420px; min-width: 420px;">' +
                    '               <ul>' +
                    '                   <li><b><g:message code="problem.last.submission"/>:</b> <span>{{& problem.lastSubmission}}</span><li>' +
                    '               </ul>' +
                    '           </div>' +
                    '           <div class="language-table" style=" float: right">' +
                    '               <ul>' +
                    '                   <li><b><p style="text-align: left;font-size: x-small;font-style: italic;color: rgb(143, 109, 23);padding-top: 8px;"><g:message code="submissions.languages"/></p></b><li>' +
                    '               </ul>' +
                    '           <table>' +
                    '                   <tr>' +
                    '               {{#statusMap}}' +
                    '                       <th>' +
                    '                           {{name}}' +
                    '                       </th>' +
                    '               {{/statusMap}}' +
                    '                   </tr>' +
                    '                   <tr>' +
                    '               {{#statusMap}}' +
                    '                       <td>' +
                    '                               <img src="{{img}}" />' +
                    '                       </td>' +
                    '               {{/statusMap}}' +
                    '                   </tr>' +
                    '           </table>' +
                    '           </div> <hr>' +
                    '           <div class="left" style="width:100%;max-width: 100%;">' +
                    '               <h2><g:message code="problem.description"/> </h2>' +
                    '               <div class="problem-description-item" id="problem-description-modal">{{& problem.description}}</div>' +
                    '               <h2><g:message code="problem.input.format"/> </h2>'  +
                    '               <div class="problem-description-item" id="problem-input-modal">{{& problem.input}}</div>' +
                    '               <h2><g:message code="problem.output.format"/> </h2>' +
                    '               <div class="problem-description-item" id="problem-output-modal">{{& problem.output}}</div>' +
                    '           </div>' +
                    '           <div class="clear-both"></div>' +
                    '   <hr />' +
                    '   <div class="menu-panel">' +
                    '       <a class="button" href="/huxley/submission/index?problemId={{id}}&userId=${session.profile.user.id}"><g:message code="problem.see.submissions"/></a>' +
                    '       <a class="button" id="example-input-{{id}}" href="/huxley/problem/downloadInput/{{id}}"><g:message code="problem.input.example"/></a>' +
                    '       <a class="button" id="example-output-{{id}}" href="/huxley/problem/downloadOutput/{{id}}"><g:message code="problem.output.example"/></a>' +
                    '       <a id="button-modal-uploader-{{problem.id}}"class="button" href="#" style="background: #1bd482;"></a>' +
                    '   </div>' +
                    '   <div class="clear-both end"></div>' +
                    '   </div>' +
                    '</div>';

            $.ajax('/huxley/problem/getProblemInfo', {
                data: {id: id},
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    var topics = "", problem = {};
                    $('div#modal').empty();

                    $.each(data.topics, function (i, topic) {
                        if (i < (data.topics.length - 1)) {
                            topics += topic.name + ", ";
                        } else {
                            topics += topic.name;
                        }
                    });

                    problem.id = data.id;
                    problem.name = data.name;
                    problem.nd = data.nd.toFixed(2);
                    problem.topics = topics;
                    problem.description = data.description;
                    problem.input = data.inputFormat;
                    problem.output = data.outputFormat;

                    var hasExample = data.hasExample;

                    if (data.fastestSubmission != null) {
                        problem.record = Mustache.render('{{time}}s <a href="/huxley/profile/show/{{hash}}">({{name}})</a>', {name: data.fastestSubmission.user.name, hash: data.fastestSubmission.user.hash, time: data.fastestSubmission.time.toFixed(4)});
                    } else {
                        problem.record = '<g:message code="verbosity.anybodyNeverTry"/>';
                    }

                    $.ajax('/huxley/submission/getSubmissionInfo', {
                        data: {id: id},
                        type: 'GET',
                        dataType: 'json',
                        success: function (data) {
                            if (data.userRecord != null) {
                                problem.userRecord = data.userRecord.time.toFixed(4) + 's';
                            } else {
                                problem.userRecord = '<g:message code="verbosity.youNeverTry"/>';
                            }

                            if (data.submissionLast != null) {
                                problem.lastSubmission = Mustache.render('<a href="/huxley/submission/downloadSubmission?bid={{id}}">{{submission}}</a>', {id: data.submissionLast.id, submission: data.submissionLast.submission});
                            } else {
                                problem.lastSubmission = '<g:message code="verbosity.youHaveNotSubmitted"/>';
                            }

                            $.ajax('/huxley/problem/getStatusLanguage', {
                                data: {id: problem.id},
                                type: 'GET',
                                dataType: 'json',
                                success: function (data) {
                                    var statusMap = [];
                                    $.each(data.languageMap, function(i, language) {
                                        var instance = [];
                                        instance.name = language.name
                                        if(language.status === 'CORRECT') {
                                            instance.img = '/huxley/images/icons/ok.png';
                                        } else if(language.status === 'WRONG_ANSWER') {
                                            instance.img = '/huxley/images/icons/error.png';
                                        } else {
                                            instance.img = '/huxley/images/icons/null.jpg';
                                        }
                                        statusMap.push(instance)
                                    });
                                    $('div#modal').append(Mustache.render(template, {problem: problem, statusMap: statusMap}));
                                    huxley.openModal('modal-window');
                                    huxley.createUploader(id, 'button-modal-uploader-' + id);
                                    if(!hasExample){
                                        $("#example-input-" + id).remove();
                                        $("#example-output-" + id).remove();
                                    }

                                }

                            });




                        }
                    });



                }
            });
        });
    };

    function tip(id) {
        var template = '<div div id="modal-window-tip" class="modal-window" style="min-width: 500px;">' +
                '   <div class="problem-modal-show" style="color: #8B8B8C;">' +
                '           <a href="javascript:huxley.closeModal()" class="close" style="font-size: 22px; font-weight: bold; color: grey;">×</a>' +
                '<div class="clear"></div>'+
                '       <div class="tip-container">' +
                '           <h3 id="problem-info" class="title" style="width: 175px;"><g:message code="problem.title.tip"/></h3>' +
                '           <span id="problem-info" style="font-size: 12px;">{{evaluation}} </span><br>' +
                '{{#errorMsg}}'+
                '<div><span class="console">{{errorMsg}}</span>' +
                '{{#commonErrors}}' +
                '<span>' +
                '    {{{commonErrors}}}' +
                '</span>' +
                '{{/commonErrors}}' +
                '</div>' +
                '{{/errorMsg}}' +
                '       </div>' +
                '{{#hasDiff}}' +
                '       <br>'+
                '       <div class="tip-container">' +
                '           <h3 class="title" style="width: 110px;"><g:message code="problem.tip.diff"/></h3>'+
                '           <span style="font-size:12px"><g:message code="problem.tip.diff.explain"/></span><br>'+
                '{{#input}}'+
                '<div class="session">'+
                '                   <h3 class="subtitle"><g:message code="submission.input.case" /></h3>'+
                '           <span style="font-size:12px"><g:message code="submission.input.case.explain"/></span><br><br>'+
                '                   <div style="padding: 5px;overflow: auto; max-height: 150px;">' +
                '                       <div class="input-example">' +
                '<span>{{input}}</span>' +
                '                       </div>' +
                '                   </div>'+
                '</div>' +
                '{{/input}}'+
                '{{#diff}}'+
                '<div class="session">'+
                '               <h3 class="subtitle"><g:message code = "problem.show.diff" /></h3>'+
                '           <span style="font-size:12px"><g:message code="submission.show.diff.explain"/></span><br><br><br>'+
                '                       {{{diff}}}'+
                '       </div>'+
                '</div>' +
                '           <h3 style="font-weight: bold; font-size:12px; text-align:right;">*<g:message code="problem.tip.diff.explain2"/></h3>'+
                '{{/diff}}' +
                '{{^diff}}' +
                '</div>' +
                '{{/diff}}'+
                '{{/hasDiff}}' +
                '       {{#tip}}' +
                '       <br>'+
                '   <div class="tip-container">'+
                '           <h3 class="title" style="width: 50px"><g:message code="problem.tip"/></h3>'+
                '       <div style="float:right">' +
                '           <ul>' +
                '               <li><a class="button" style="background-color:#6db60a; margin: -6px 3px 3px 0px;" href="javascript:showTip({{tip}})"><g:message code="problem.get.tip"/></a></li>' +
                '           </ul>' +
                '   </div>' +
                '           <span style="font-size:12px"><g:message code="problem.tip.explain"/></span><br>'+
                '<div class="clear"></div>' +
                '</div>' +
                '{{/tip}}' +
                '</div>';


        $.ajax('/huxley/problem/getTip', {
                    data: {id: id},
                    type: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        $("#modal-window-tip").remove();
                        $('div#modal-tip').append(Mustache.render(template, data));
                        huxley.openModal('modal-window-tip');
                    }
                }
        );

    }

    function showTip(id) {
        var template = '<div div id="modal-window-tip" class="modal-window">' +
                '   <div class="problem-modal-show" style="color: #8B8B8C;">' +
                '<a href="javascript:huxley.closeModal()" class="close" style="font-size: 22px; font-weight: bold; color: grey;">×</a>' +
                '<div class="clear"></div>'+
                '   <div class="tip-container">'+
                '           <h3 id="problem-info" class="title" style="width: 50px"><g:message code="problem.tip"/></h3>' +
                '           <span id="problem-info" style="font-size: 12px; white-space: pre-wrap;">{{tip}}</span><br><br>' +
                '       </div>' +
                '<div style="text-align:right;"><span id="vote-bar" style="font-size: 12px">ESTA DICA FOI ÚTIL? <a href="javascript:voteTip({{id}},\'yes\')">SIM</a> / <a href="javascript:voteTip({{id}},\'no\')">NÃO</a></span></div>'+
                '</div>';

        $.ajax('/huxley/problem/showTip', {
                    data: {id: id},
                    type: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        $("#modal-window-tip").remove();
                        data.submission.id = id;
                        $('div#modal-tip').append(Mustache.render(template, data.submission));
                        huxley.openModal('modal-window-tip');
                    }
                }
        );
    }
    function voteTip(id,vote){
        $.ajax('/huxley/problem/voteTip', {
                    data: {id: id, vote:vote},
                    type: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        $("#vote-bar").empty();
                        $("#vote-bar").append('Obrigado!')
                    }
                }
        );
    }

</script>

    <script type="text/javascript">
        $(function() {
            $.ajax('/huxley/quest/remainingTime', {
                data: {id: ${questionnaireInstance.id}},
                dataType: 'json',
                success: function(data) {

                var days = data.days < 0 ? 0 : data.days, 
                    hours = data.hours < 0 ? 0 : data.hours, 
                    minutes = data.minutes < 0 ? 0 : data.minutes, 
                    seconds = data.seconds < 0 ? 0 : data.seconds;


                var startTime = days + ":" + hours + ":" + minutes + ":" + seconds;

                  $('#counter').countdown({
                        stepTime: 60,
                        format: 'dd:hh:mm:ss',
                        startTime: startTime,
                        timerEnd: function() {},
                        image: "/huxley/images/digits_transparent.png"
                    });   
                }
            });
        });
        huxley.createUploader = function (problemId, button) {
            'use strict';
            var uploader = new qq.FileUploader({
                element: document.getElementById(button),
                action: huxley.root + 'submission/save',
                allowedExtensions:  ['c', 'pas', 'py', 'cpp', 'java', 'm'],
                sizeLimit: 1048576,
                params: {
                    pid: problemId
                },
                messages: {
                    typeError: "{file} não possui uma extensão válida. Apenas {extensions} são permitidas.",
                    sizeError: "{file} é muito grande, O tamanho máximo do arquivo deve ser {sizeLimit}.",
                    emptyError: "{file} está vazio, por favor selecione outro arquivo.",
                    onLeave: "O arquivo ainda está sendo enviado."
                },
                template: '<div class="qq-uploader">' +
                        '<div id="submission-area"><div style="float: left;" class="qq-upload-drop-area"></div>' +
                        '<div class="qq-upload-button" style="font-size: 12px;">Enviar solução</div>' +
                        '<ul class="qq-upload-list" style="display: none;"></ul>' +
                        '</div></div>',
                onComplete : function (id, fileName, responseJSON) {
                    huxley.setProblemWaiting('title-problem-' + problemId);
                    huxleyProblem.getPendingSubmission();
                    huxleyProblem.callGetStatus(responseJSON.submission.id);
                }
            });
        };


    </script>
    <style type="text/css">
        .modal-window {
            display: none;
        }
    </style>
</head>
    <body>
        <h4 class="questionnaire-title"><g:message code="entity.questionnaire" />: <span style="color: #f2b500;">${questionnaireInstance.title}</span></h4>

        <hr/>
            <div>
                <g:if test="${!session.license.isStudent()}">
                    <div class="column">
                        <h4><g:message code="questionnaire.user" /></h4>
                        <div class="questionnaire-description"><p>${user}</p></div>
                    </div>
                </g:if>
                <div class="column">
                    <h4><g:message code="questionnaire.description" /></h4>
                    <div class="questionnaire-description"><p>${questionnaireInstance.description}</p></div>
                </div>
                <div class="column" style="width: 33.3%;">
                    <h4><g:message code="questionnaire.averageDifficulty" /></h4>
                    <p><g:formatNumber number="${averageDifficulty}" maxFractionDigits="2"/> </p>
                </div>
                <div class="column" style="width: 33.3%;">
                    <h4><g:message code="questionnaire.weightedAverageDifficulty" /></h4>
                    <p><g:formatNumber number="${weightedAverageDifficulty}" maxFractionDigits="2"/></p>
                </div>
                <div class="column" style="width: 33.3%;">
                    <h4><g:message code="questionnaire.ends" /></h4>
                    <p class="finished">${endDate}</p>
                </div>
                <div class="column" style="width: 50%;">
                    <h4><g:message code="questionnaire.totalScore" /></h4>
                    <p><g:formatNumber number="${questionnaireInstance.score}" maxFractionDigits="2"/></p>
                </div>
                <div class="column" style="width: 50%;">
                    <h4><g:message code="questionnaire.yourScore" /></h4>
                    <p><g:formatNumber number="${yourScore}" maxFractionDigits="2"/></p>
                </div>
            </div>
            <div style="clear: left;"/>
        <hr/>
        <div style="display: table; text-align: right; width: 100%; margin: 5px;">
            <div style="display: table-cell; width: 260px;"></div>
            <div style="display: table-cell">
                <div id="counter"></div>
            </div>        
        </div>
        <hr/>
        <br>


    </div>
    <div id="problem-list"></div>
    <div id="spin"></div>
    <div id="modal"></div>
    <div id="modal-tip"></div>
    <div id="modal-correct"></div>
    </body>
</html>