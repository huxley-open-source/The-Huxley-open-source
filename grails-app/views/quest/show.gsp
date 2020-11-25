<%@ page import="com.thehuxley.EvaluationStatus; com.thehuxley.Profile" %>
<!doctype html>
<html>
<head>
<meta name="layout" content="main"/>
    <style type="text/css">

    .quest-problem-title {
        color: #858484;
        font-family: Arial;
        font-size: 15px;
        font-weight: bold;
        margin: 25px 0px 30px 0px !important;
    }

    .quest-problem-title > a{
        text-decoration: none !important;
        font-size: 18px !important;
        font-weight: normal;
        float: none !important;
        margin-bottom: 0px !important;
    }
    .icon-small {
        background: transparent url("${resource(dir: 'images', file: 'questionnaire_view.png')}") no-repeat;
        display: inline-block;
        width: 16px;
        height: 16px;
        vertical-align: middle;
    }
    .icon {
        background: transparent url("${resource(dir: 'images', file: 'questionnaire_view.png')}") no-repeat;
        display: inline-block;
        width: 33px;
        height: 33px;
        vertical-align: middle;
    }
    .icon.bottom, .icon-small.bottom {
        vertical-align: bottom;
    }

    .check {
        background-position: 0px 0px;
    }
    .uncheck {
        background-position: -34px 0px;
    }
    .download {
        background-position: 0px -61px
    }
    .edit {
        background-position: -76px -39px;
    }
    .wrong {
        background-position: -70px -99px;;
    }
    .wrong-alert {
        background-position: -105px -99px;
    }
    .correct {
        background-position: -35px -99px;
    }
    .correct-alert {
        background-position: 0px -99px;;
    }
    .untried {
        background: none;
    }

    .box {
        padding: 22px 15px !important;
    }

    .submission-list {
        background-color: #f1f1f1;
        width: 660px;
        margin-top: 19px;
        display: none;
    }

    .submission-list-cell {
        display: table-cell;
        border: 1px solid #878787;
        padding: 5px;
        font-family: monospace;
    }

    .submission-list-cell.quest-title {
        vertical-align: middle;
    }

    .submission-list-cell ul {
        height: 450px;
        overflow-y: auto;
    }

    .submission-list-cell li {
        display: block !important;
        text-align: center;
    }

    .submission-list {
        text-decoration: none;
    }
    .code-container {
        background-color: #ffffff;
        width: 550px;
    }
    .similarity-show {
        width: 660px;
        display: none;
        border: 1px solid #878787;
        margin-top: 19px;
    }
    .comment-area {
        margin: 0px;
        width: 550px;
        height: 76px;
        resize: vertical;
        border: none;
        padding: 10px;
    }
    .comment-area-container {
        border-top: 0px;
        padding: 0px !important;
    }
    .score-input {
        border: 0px;
        width: 25px;
        text-align: right;
        border: 1px solid transparent;
    }
    .error input {
        color: red;
    }
    .error .edit {
        background-position: -97px -39px;
    }
    .active li{
        background-color: #878787;
    }
    a {
        text-decoration: none;
        color: #878787;
    }
    a.active  {
        color: #000000 !important;
    }
    a:hover{
        border-bottom: 0px !important;
    }
    .disabled {
        background-color: #878787 !important;
        cursor: default !important;
    }
    .code-container > div > div > div {
        width: 550px !important;
        overflow: auto !important;
        height: 450px;
        margin-bottom: 0px !important;
    }
    .cntSeparator {
        line-height: 37px !important;
    }

    </style>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shCore.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushPython.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushOctave.js')}"></script>
    <script src="<g:resource dir="js" file="mustache.min.js"/>" type="text/javascript"></script>
    <link href="${resource(dir:'css', file:'shCoreDefault.css')}" type="text/css" rel="stylesheet"  />
    <link href="${resource(dir:'css', file:'problem.css')}" type="text/css" rel="stylesheet"  />
    <link href="${resource(dir:'css', file:'problem-accordion.css')}" type="text/css" rel="stylesheet"  />
    <script src="${resource(dir:'js', file:'fileuploader.js')}"></script>
    <script src="${resource(dir:'js', file:'moment.min.js')}"></script>
    <script type="text/javascript">
    var submissionWaitingList = [], reEvaluating = 0, codeOnShow = '', problemWaitingMap = {};
        function showCode(aId){
            if (aId !== null || aId !== undefined) {
                var set = $('#' + aId).data();
                codeOnShow = {id:set.sid};
                var container = $('#code-' + set.id), title = $('#show-code-title-' + set.id), textContainer = $('#comment-' + set.id), dateTitle = $('#show-code-date-title-' + set.id), date, tip = $('#problem-tip-' + set.id);
                tip.hide();
                $('#sub-list-' + set.id + ' a').removeClass('active');
                $('#list-'+ set.id+ '-' + set.sid).addClass('active');
                $.ajax({
                    url: huxley.root + 'submission/getComment',
                    async: true,
                    data: {id:set.sid},
                    beforeSend: huxley.showLoading(),
                    dataType: 'json',
                    success: function(data) {
                        huxley.hideLoading();
                        if (data.status ==='ok') {
                            if(data.comment.length > 0) {
                                textContainer.val(data.comment);
                                textContainer.show();
                            } else {
                                textContainer.hide();
                            }

                            date = moment(data.date);
                            dateTitle.empty().append('enviado em ' + date.format("DD/MM/YY"));
                        }
                    }
                });
                $.ajax({
                    url: huxley.root + 'submission/downloadCodeSubmission',
                    async: true,
                    data: {id:set.sid},
                    dataType: 'json',
                    beforeSend: huxley.showLoading(),
                    success: function(data) {
                        huxley.hideLoading();
                        var toAppend = '<div><pre class="brush: ' + data.submission.language + '; toolbar: false; ">' +
                                data.submission.submissionCode +
                                '</pre></div>';
                        container.empty();
                        $('#code-' + set.id).append(toAppend);
                        if (set.evaluation === ${EvaluationStatus.CORRECT}) {
                            toAppend = '<i class="icon-small problem-correct-icon"></i>';
                        } else if (set.evaluation === ${EvaluationStatus.WAITING}) {
                            toAppend = '<i class="icon-small problem-evaluating-icon"></i>';
                        } else {
                            toAppend = '<i class="icon-small problem-wrong-icon"></i>';
                            tip.show();
                            tip.attr('href','javascript:tip(' + set.sid + ')');
                        }
                        toAppend += '<g:message code="questionnaire.show.code"/> ' + set.tries + ' <a href="/huxley/submission/downloadSubmission?bid=' + set.sid +'"><i class="icon download"></i></a>';
                        title.empty();
                        title.append(toAppend);
                        SyntaxHighlighter.highlight();
                    }
                });
            }

        }

        function getStatus() {
            if(reEvaluating == 0 && submissionWaitingList.length > 0 ){
                var submissionContainer, icon, problemStatusContainer, problemStatusContainer2, valueMap, problemId, problemInput;
                reEvaluating = 1;
                $.ajax({
                    url: huxley.root + 'submission/getStatus',
                    async: true ,
                    type: 'POST',
                    dataType: 'json',
                    data: {id: JSON.stringify(submissionWaitingList)} ,
                    success: function(data) {
                        $.each(data.submissions, function(i, submission) {
                            reEvaluating = 0;
                            problemId = problemWaitingMap[submission.id] + '';
                            problemStatusContainer = $('#status-' + problemId);
                            problemStatusContainer2 = $('#status-' + problemId + ' i ');
                            if(!(submission.evaluation === ${EvaluationStatus.WAITING})){
                                submissionContainer = $('[data-sid="' + submission.id + '"]');

                                delete problemWaitingMap[submission.id];
                                valueMap = $.map(problemWaitingMap, function(v, i){
                                    return v;
                                });
                                if (valueMap.indexOf(problemId) === -1) {
                                    problemStatusContainer2.addClass('untried');
                                    problemStatusContainer2.removeClass('problem-evaluating-icon');
                                }
                                huxley.removeFromArray(submission.id,submissionWaitingList);
                                if (submission.evaluation === ${EvaluationStatus.CORRECT}) {
                                    problemStatusContainer.removeClass('untried');
                                    problemStatusContainer.removeClass('wrong');
                                    problemStatusContainer.addClass('correct');
                                    problemInput = $('#quest-prob-' + problemId)
                                    problemInput.val(problemInput.data('max'));
                                } else {
                                    if (problemStatusContainer.hasClass('untried')) {
                                        problemStatusContainer.removeClass('untried');
                                        problemStatusContainer.addClass('wrong');
                                    }

                                }
                                if (submissionContainer.length > 0) {
                                    submissionContainer.data('evaluation', submission.evaluation);
                                    icon = $('#' + submissionContainer.attr('id') + ' i ');

                                    icon.removeClass('problem-evaluating-icon');
                                    if (submission.id === codeOnShow.id){
                                        showCode(submissionContainer.attr('id'));
                                    }
                                    if (submission.evaluation === ${EvaluationStatus.CORRECT}) {
                                        icon.addClass('problem-correct-icon');

                                    } else {
                                        icon.addClass('problem-wrong-icon');
                                    }
                                }
                            } else {
                                if(!problemStatusContainer2.hasClass('problem-evaluating-icon')) {
                                    problemStatusContainer2.addClass('problem-evaluating-icon');
                                }

                            }
                            setTimeout(function(){getStatus();}, 6000);
                        });
                    }
                });
            }
        }

        function createUploader(problemId, button, quest) {
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
                    var submission = responseJSON.submission;
                    var  problemStatusContainer = $('#status-' + quest + ' i ');
                    if (!$('#show-submission-' + quest).hasClass('disabled')) {
                        var aId = 'list-' + quest + '-' +submission.id;
                        var toAppend = '<a data-sId="' + submission.id + '" data-tries="' + submission.tries + '" data-evaluation="WAITING" data-id="' + quest + '" id="' + aId +'" href="javascript:showCode(\''+ aId +'\');"><li>#' + submission.tries;
                        if (submission.tries < 10) {
                            toAppend += ' ';
                        }
                        toAppend += '<i class="icon-small problem-evaluating-icon"></i>' +
                        '</li></a>';

                        $('#ul-' + quest).append(toAppend)

                    }
                    $('#show-submission-' + quest).removeClass('disabled');
                    problemStatusContainer.removeClass('untried');
                    problemStatusContainer.addClass('problem-evaluating-icon');
                    if (submissionWaitingList.indexOf(submission.id)) {
                        submissionWaitingList.push(submission.id);
                        problemWaitingMap[submission.id] = quest;
                        getStatus();
                    }

                }
            });
        };

        $(function() {
            $.ajax('/huxley/quest/remainingTime', {
                data: {id: ${quest.id}},
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
                        timerEnd: function() {
                            $('#counter').empty().css('margin-left','0px').append('Questionário Encerrado!');
                            $('.submit').remove();
                        },
                        digitImages: 6,
                        digitWidth: 34,
                        digitHeight: 45,
                        image: "/huxley/images/digits2.png"
                    });
                }
            });
            $('.submit').each(function() {
                var id = this.id.substring(this.id.lastIndexOf('-') + 1);
                createUploader(id, this.id, this.id.substring(15,this.id.lastIndexOf('-')));
            });


            $('.submission').each(function() {
                var that = this;
                this.onclick = function() {
                    var id = this.id.substring(this.id.lastIndexOf('-') + 1), container = $('#submission-list-' + id), toAppend = '', listContainer = $('#sub-list-' + id), similarityContainer = $('#similarity-' + id),lastId = 0, tries = 0, evaluation = 0, hasCorrect = false, aId = '';
                    if (!$(this).hasClass('disabled')) {
                        if (container.data('status') === undefined) {
                            $.ajax({
                                url: huxley.root + 'submission/listByQuestProblem',
                                async: true,
                                data: {id:'${questUser.id}', problemId:id},
                                dataType: 'json',
                                beforeSend: huxley.showLoading(),
                                success: function(data) {
                                    huxley.hideLoading();
                                    toAppend += '<ul id="ul-' + id + '">';
                                    $.each(data.submissions, function(i, submission){
                                        aId = 'list-' + id + '-' +submission.id;
                                        toAppend += '<a data-sId="' + submission.id + '" data-tries="' + submission.tries + '" data-evaluation="' + submission.evaluation + '" data-id="' + id + '" id="list-' + id + '-' +submission.id +'" href="javascript:showCode(\''+ aId +'\');"><li>#' + submission.tries;
                                        if (submission.tries < 10) {
                                            toAppend += ' ';
                                        }
                                        if (submission.evaluation === ${EvaluationStatus.CORRECT}) {
                                            toAppend += '<i class="icon-small problem-correct-icon"></i>';
                                        } else if (submission.evaluation === ${EvaluationStatus.WAITING}) {
                                            toAppend += '<i class="icon-small problem-evaluating-icon"></i>';
                                            if (submissionWaitingList.indexOf(submission.id)) {
                                                submissionWaitingList.push(submission.id);
                                                problemWaitingMap[submission.id] = id;
                                                getStatus();
                                            }

                                        } else {
                                            toAppend += '<i class="icon-small problem-wrong-icon"></i>';
                                        }

                                        toAppend += '</li></a>';
                                        if (hasCorrect || submission.evaluation === ${EvaluationStatus.CORRECT}) {
                                            hasCorrect = true;
                                            if(hasCorrect && submission.evaluation === ${EvaluationStatus.CORRECT}) {
                                                lastId = submission.id;
                                                tries = submission.tries;
                                                evaluation = submission.evaluation;
                                            }
                                        } else {
                                            lastId = submission.id;
                                            tries = submission.tries;
                                            evaluation = submission.evaluation;
                                        }
                                    });
                                    toAppend += '</ul>';
                                    listContainer.append(toAppend);
                                    container.data('status','loaded');
                                    $('#submission-list-' + id).css('display','table');
                                    showCode(aId);
                                    getStatus();
                                    if (container.is(":visible")) {
                                        $(that).empty().append('<g:message code="questionnaire.hide.submission"/>');
                                    } else {
                                        $(that).empty().append('<g:message code="questionnaire.show.submission"/>');
                                    }
                                }
                            });
                        } else {
                            container.toggle();
                            if (container.is(":visible")) {
                                $(that).empty().append('<g:message code="questionnaire.hide.submission"/>');
                            } else {
                                $(that).empty().append('<g:message code="questionnaire.show.submission"/>');
                            }

                        }
                    }
                };

            });

        });

        showProblemModal = function(id) {
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
                    '                   <li><b><g:message code="problem.nd"/>:</b> <span>{{problem.nd}}</span></li>' +
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
                    '       <a class="button" id="example-input-{{problem.id}}" href="/huxley/problem/downloadInput/{{problem.id}}"><g:message code="problem.input.example"/></a>' +
                    '       <a class="button" id="example-output-{{problem.id}}" href="/huxley/problem/downloadOutput/{{problem.id}}"><g:message code="problem.output.example"/></a>' +
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
                                        if(language.status === huxley.constants.EVALUATION_CORRECT) {
                                            instance.img = '/huxley/images/icons/ok.png';
                                        } else if(language.status === huxley.constants.EVALUATION_WRONG_ANSWER) {
                                            instance.img = '/huxley/images/icons/error.png';
                                        } else {
                                            instance.img = '/huxley/images/icons/null.jpg';
                                        }
                                        statusMap.push(instance)
                                    });
                                    $('div#modal').append(Mustache.render(template, {problem: problem, statusMap: statusMap}));
                                    huxley.openModal('modal-window');
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

        }

        function tip(id) {
            var template = '<div div id="modal-window-tip" class="modal-window" style="min-width: 500px;">' +
                    '   <div class="problem-modal-show" style="color: #8B8B8C;">' +
                    '           <a href="javascript:huxley.closeModal()" class="close" style="font-size: 22px; font-weight: bold; color: grey;">×</a>' +
                    '<div class="clear"></div>'+
                    '       <div class="tip-container">' +
                    '           <h3 id="problem-info" class="title" style="width: 175px;"><g:message code="problem.title.tip"/></h3>' +
                    '           <span id="problem-info" style="font-size: 12px;">{{evaluation}}</span><br>' +
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
                    '           <h3 class="subtitle"><g:message code = "problem.show.diff" /></h3>'+
                    '           <span style="font-size:12px"><g:message code="submission.show.diff.explain"/></span><br><br><br>'+
                    '           {{{diff}}}'+
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
                        data: {sId: id},
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
</head>
<body>
<huxley:profile profile="${profile}" license="${session.license}"/>
<div class="box"><div id="counter" style="margin-left: 180px; font-size: 18px; font-weight: bold; text-align: center; line-height: 40px;"></div></div>
<div class="box">
    <div>
        <span class="similarity-complementary-info" >${quest.title}</span>
        <span class="th-right"><g:message code="questionnaire.score2"/>:<input readonly="readonly" type="text" class="score-input" value="${questUser.score}" id="quest-score"/>/${quest.score}</span>
    </div>
    <hr />
    <g:each in="${questionnaireProblem}" var="questProblem" status="i">
        <div>
            <h3 class="quest-problem-title">
                <a href="javascript:showProblemModal(${questProblem.problem.id})">${questProblem.problem.name}</a>
                <g:if test="${resultMap.get(questProblem.id) && resultMap.get(questProblem.id).correct}">
                    <i class="icon correct th-right" id="status-${questProblem.id}"><i class="icon-small th-right untried" style="margin-top: 19px;"></i></i>
                </g:if>
                <g:elseif test="${resultMap.get(questProblem.id) && resultMap.get(questProblem.id).tried}">
                    <i class="icon wrong th-right" id="status-${questProblem.id}"><i class="icon-small th-right untried" style="margin-top: 19px;"></i></i>
                </g:elseif>
                <g:else>
                    <i class="icon th-right untried" id="status-${questProblem.id}"><i class="icon-small th-right untried" style="margin-top: 19px;"></i></i>
                </g:else>
            </h3>
            <div style="margin-top: -25px;font-size: 10px;margin-bottom: 15px;"><div><b>Nível Dinâmico(ND)</b>: ${questProblem.problem.nd}</div><div><b>Tópicos</b>:
            <g:each in="${questProblem.problem.topics.name}" var="topic" status="index">
                <g:if test="${index < questProblem.problem.topics.size() - 1}">${topic + ', ' }</g:if>
                <g:else>${topic}</g:else>
            </g:each>
            </div></div>
            <div>
                <a href="javascript:showProblemModal(${questProblem.problem.id})" class="button"><g:message code="problem.description"/></a>
                <g:if test="${resultMap.get(questProblem.id).tried}">
                    <a href="javascript:void(0);" class="button submission" id="show-submission-${questProblem.id}">
                </g:if>
                <g:else>
                    <a href="javascript:void(0);" class="button submission disabled" id="show-submission-${questProblem.id}">
                </g:else>
                    <g:message code="questionnaire.show.submission"/></a>
                <button id="submit-problem-${questProblem.id}-${questProblem.problem.id}" class="button submit" style="background: #1bd482; border: none;">></button>
                <span class="th-right"><g:message code="questionnaire.score.trim"/>
                        <input readonly="readonly" type="text" id="quest-prob-${questProblem.id}" class="score-input" data-max="${questProblem.score}" value="${resultMap.get(questProblem.id).score}"/>
                        /${questProblem.score}</span>
            </div>
            <br>
            <div id="submission-list-${questProblem.id}" class="submission-list">
                <div style="display: table-row;">
                    <div style="display: table;">
                        <div style="display: table-row">
                            <div class="submission-list-cell quest-title" style="width: 550px;">
                                <span id="show-code-title-${questProblem.id}"></span>
                                <a href="javascript:tip(12);" id="problem-tip-${questProblem.id}" style="cursor: pointer; display: none; float: right; margin-top: 10px;color: blue;"><g:message code="problem.title.tip"/></a>
                                <div style="margin-top: -9px; width: 192px; text-align: right;">
                                    <span style="font-size: 10px; text-align: right;" id="show-code-date-title-${questProblem.id}">enviado em 22/04/87</span>
                                </div>
                            </div>
                            <div class="submission-list-cell quest-title">
                                <span><g:message code="questionnaire.submission.list"/></span>
                            </div>
                        </div>
                        <div style="display: table-row;">
                            <div class="submission-list-cell code-container" id="code-${questProblem.id}">

                            </div>
                            <div class="submission-list-cell" id="sub-list-${questProblem.id}">

                            </div>
                        </div>
                    </div>

                </div>
                <div style="display: table-row">
                    <div style="display: table">
                        <div style="display: table-row">
                            <div style="width: 45px;"></div>
                            <div class="submission-list-cell comment-area-container"><textarea readonly="readonly" id="comment-${questProblem.id}" rows="4" cols="50" class="comment-area" placeholder="<g:message code="quest.insert.commment"/>..."></textarea>
                            </div>
                            <div style="width: 45px;"></div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </g:each>
</div>
<div id="modal"></div>
<div id="modal-tip"></div>
</body>
</html>
