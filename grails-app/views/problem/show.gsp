<%@ page import="com.thehuxley.EvaluationStatus; com.thehuxley.Submission"%>
<%@ page import="com.thehuxley.UserProblem"%>
<%@ page import="com.thehuxley.Problem"%>

<html xmlns="http://www.w3.org/1999/html">
<head>
<meta name="layout" content="main" />
<script src="${resource(dir:'js', file:'fileuploader.js')}"></script>
<script src="${resource(dir:'js', file:'huxley-problem.js')}"></script>
<link rel="stylesheet" href="${resource(dir: 'css', file: 'problem.css')}" type="text/css">
<link href="<g:resource dir="css" file="problem-accordion.css"/>" type="text/css" rel="stylesheet">
<script src="<g:resource dir="js" file="underscore-min.js"/>" type="text/javascript"></script>
<script src="<g:resource dir="js" file="mustache.min.js"/>" type="text/javascript"></script>
<style>

.linenum a {color: #909090 !important;}

</style>
<script type="text/javascript">
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
                        data.submission.id = id;
                        $("#modal-window-tip").remove();
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

    var interval;

    $(function () {
        $('#div.problem-description-item img').css('max-width', '700px');
        $(document).delegate('.problem-help', 'click', function (e) {
            e.preventDefault();
            huxley.openModal('problem-help-modal');
        });
    });

    $(function () {
        'use strict';
        getPendingSubmissions();
        var uploader = new qq.FileUploader({
            element: document.getElementById('submit-button'),
            action: huxley.root + 'submission/save',
            allowedExtensions: ['c', 'pas', 'py', 'cpp','java','m'],
            sizeLimit: 1048576,
            params: {
                pid: ${problemInstance.id}
            },
            messages: {
                typeError: "{file} não possui uma extensão válida. Apenas {extensions} são permitidas.",
                sizeError: "{file} é muito grande, O tamanho máximo do arquivo deve ser {sizeLimit}.",
                emptyError: "{file} está vazio, por favor selecione outro arquivo.",
                onLeave: "O arquivo ainda está sendo enviado."
            },
            template: '<div class="qq-uploader">' +
                    '<div id="submission-area"><div class="qq-upload-drop-area"></div>' +
                    '<div class="qq-upload-button">Enviar solução</div>' +
                    '<ul class="qq-upload-list" style="display: none;"></ul>' +
                    '</div></div>',
            onSubmit: function(){
                $('#problem-status-icon').attr('src', '${resource(dir:'images', file:'spinner.gif')}');
                $('#problem-status-icon').fadeIn('fast');
                $('#problem-info').removeClass('problem-waiting');
                $('#problem-info').removeClass('problem-wrong');
                $('#problem-info').removeClass('problem-correct');
            },
            onComplete: function(id, fileName, responseJSON) {
                interval = setInterval(function(){updateSubmissionStatus(responseJSON.submission.id);}, 2000);
            }
        });
    });

    $(function(){
        $.ajax({
            url: '${resource(dir:'/')}problem/showProblem',
            data: 'id=' + ${problemInstance.id},
            dataType: 'json',
            success: function(data) {
                if(data.problem){
                    $('#problem-besttime').append(data.problem.bestTime);
                    $('#problem-record').append(data.problem.record);
                    $('#problem-lastsubmission').append(data.problem.lastSubmissionDownload);
                }
            }

        });
    });

    function getPendingSubmissions() {
        $.ajax({
            url: '${resource(dir:'/')}problem/ajxGetPendingSubmissions',
            async: true,
            dataType: 'json',
            success: function(data) {
                $.each(data.pendingSubmissions, function(i, submission) {
                    if (submission.pid == ${problemInstance.id}) {
                        interval = setInterval(function(){updateSubmissionStatus(submission.id);}, 2000);
                    }
                });
            }
        });
    }


    $(function() {
        $.ajax({
            url: '${resource(dir:'/')}problem/ajxGetProblemStatus',
            data: 'pid=' + ${problemInstance.id},
            async: true,
            dataType: 'json',
            success: function(data) {
                if(data!=null){
                    if(data.problem){
                        if ('${UserProblem.CORRECT}' === data.problem.status) {
                            $('#problem-status-icon').attr('src', '${resource(dir:'images/icons', file:'ok.png')}');
                            $('#problem-status-icon').hide().fadeIn('slow');
                            $('#problem-info').addClass('problem-correct');
                            $('#problem-info').removeClass('problem-waiting');
                            $('#problem-info').removeClass('problem-wrong');
                            if($('#title-problem-tip-${problemInstance.id}').length !== 0) {
                                $('#title-problem-tip-${problemInstance.id}').remove()
                            }
                        } else if ('${UserProblem.TRIED}' === data.problem.status) {
                            $('#problem-status-icon').attr('src', '${resource(dir:'images/icons', file:'error.png')}');
                            $('#problem-status-icon').hide().fadeIn('slow');
                            $('#problem-info').addClass('problem-wrong');
                            $('#problem-info').removeClass('problem-waiting');
                            $('#problem-info').removeClass('problem-correct');
                            if($('#title-problem-tip-${problemInstance.id}').length === 0) {
                                $('#problem-info').append('<span class="problem-title-tip" id="title-problem-tip-${problemInstance.id}"><a href="javascript:void(0)"><g:message code="problem.title.tip"/> </a></span>')
                                $('#title-problem-tip-${problemInstance.id}').on('click',function () { tip(${problemInstance.id}); });
                            }
                        }
                    }


                    $('#show-download-test-case').append('<a class="button" href="${resource(dir:"/")}problem/downloadInput/' + ${problemInstance.id}+'"><g:message code="problem.input.example"/></a>' +
                    '<a class="button" href="${resource(dir:'/')}problem/downloadOutput/'+${problemInstance.id} + '"><g:message code="problem.output.example"/></a>');
                }
            }
        });
    });

    function updateSubmissionStatus(sid) {
        $.ajax({
            url: '${resource(dir:'/')}submission/getStatusSubmission',
            data: 'sid=' + sid,
            async: true,
            dataType: 'json',
            beforeSend: function() {

            },
            success: function(data) {
                if($('#title-problem-tip-' + data.submission.problem).length !== 0) {
                    $('#title-problem-tip-' + data.submission.problem).remove()
                }
                var pid = data.submission.problem;
                if (data.submission.status == huxley.constants.EVALUATION_WAITING) {
                    $('#problem-status-icon').attr('src', '${resource(dir:'images', file:'icons/loading.png')}');
                    $('#problem-status-icon').hide().fadeIn('slow');
                    $('#problem-info').attr('status', huxley.constants.EVALUATION_WAITING);
                } else if (data.submission.status == huxley.constants.EVALUATION_CORRECT) {
                    $('#problem-status-icon').attr('src', '${resource(dir:'images', file:'icons/ok.png')}');
                    $('#problem-info').addClass('problem-correct');
                    $('#problem-status-icon').hide().fadeIn('slow')
                    $('#problem-info').removeClass('problem-waiting');
                    $('#problem-info').removeClass('problem-wrong');
                    updateLanguageTable(data.submission.language, data.submission.status);
                    showProblem(data.submission.problem);
                    clearInterval(interval);
                    huxleyProblem.openModalCorrect(sid);

                } else  {
                    $('#problem-status-icon').attr('src', '${resource(dir:'images', file:'icons/error.png')}');
                    $('#problem-info').addClass('problem-wrong');
                    $('#problem-status-icon').hide().fadeIn('slow')
                    $('#problem-info').removeClass('problem-waiting');
                    $('#problem-info').removeClass('problem-correct');
                    updateLanguageTable(data.submission.language, data.submission.status);
                    showProblem(data.submission.problem);
                    clearInterval(interval);
                    if($('#title-problem-tip-' + data.submission.problem).length === 0) {
                        $('#problem-info').append('<span class="problem-title-tip" id="title-problem-tip-' + data.submission.problem + '"><a href="javascript:void(0)"><g:message code="problem.title.tip"/></a></span>')
                        $('#title-problem-tip-' + data.submission.problem).on('click',function () { tip(data.submission.problem); });
                    }
                }

            }
        });
    }

    function updateLanguageTable(lang, status) {
        if(status == huxley.constants.EVALUATION_CORRECT) {
            $('.lang-' + lang).empty().append('<div><img src="/huxley/images/icons/ok.png" /></div>');
        } else {
            $('.lang-' + lang).empty().append('<div><img src="/huxley/images/icons/error.png" /></div>');
        }

    }

    function showProblem(id) {
        $.ajax({
            url: '/huxley/problem/showProblem',
            data: 'id=' + id,
            dataType: 'json',
            success: function(data) {
                if(data.problem){
                    $('#problem-besttime').empty();
                    $('#problem-besttime').append(data.problem.bestTime);

                    $('#problem-record').empty();
                    $('#problem-record').append(data.problem.record);

                    $('#problem-lastsubmission').empty();
                    $('#problem-lastsubmission').append(data.problem.lastSubmissionDownload);
                }
            }

        });

    }

    function goHistory(id, pid) {
        window.location = '${resource(dir:'/')}submission/listByUserAndProblem?problemId='+ id +'&userId=' + pid;
    }


    $(function () {
        $('select#problem-status').change(function () {
            $.ajax({
                url: '/huxley/problem/changeStatus',
                data: {s: $('select#problem-status').find('option:selected').val(), id: ${problemInstance.id}},
                dataType: 'json',
                success: function (data) {
                    $('span#problem-status-msg').hide().text(data.msg).fadeIn('fast');
                }
            });
        });
    });
</script>

</head>
<body>

<div class="problem-show">

    <h3 id="problem-info" style="font-weight: bold; font-size: 16px;">${info.name}<img id="problem-status-icon" style="float: right; border: 0 none; display: none;" src="" /></h3>


        <i class="creator-description">
            ${g.message(code: "verbosity.createdBy")}
            <span style="color: #49D4E7;">${huxley.user(user: problemInstance.userSuggest, problemInstance.userSuggest.name)}</span>
            ${g.message(code: "verbosity.updatedAt")}
            <span class="date">${formatDate(date: problemInstance.lastUpdated, format: 'dd/MM/yyyy')}</span>
            ${formatDate(date: problemInstance.lastUpdated, format: 'HH:mm')}<br>
            <g:message code="verbosity.source"/>:
            <g:if test="${problemInstance.source}">
                ${problemInstance.source}
            </g:if>
            <g:else>
                <g:message code="verbosity.not.informed"/>
            </g:else>
        </i>


    <div style="padding: 10px 0 10px 0; height: 30px;">
        <div class="ui-gbutton" style="font-size: 15px; color: #fff; position: relative; float:right;" id="submit-button"></div>

        <g:link action="index" controller="submission" style="height: 33px!important; line-height: 33px!important; float: right;" params="[problemId: info.id,userId: session.profile.user.id]" class="button"><g:message code="problem.see.submissions"/></g:link>
        <g:if test="${session.license.isAdmin()||session.profile.user.id == problemInstance.userSuggest.id}">
            <g:link action="create" class="ui-rbutton" id="${problemInstance.id}" style="float:right; height: 17px; margin-right: 5px;"><g:message code="verbosity.edit"/></g:link>
            <g:link action="reEvaluate" class="ui-rbutton" id="${problemInstance.id}" style="float:right; height: 17px; margin-right: 5px;"><g:message code="verbosity.reevaluate"/></g:link>
        </g:if>
    </div>
    <div style="float: right;">
        <a class="problem-help" href="#" class="problem-help"  style="font-size: 0.8em;">O que eu posso submeter?</a>
    </div>
    <hr/>
    <div class="tab-left-panel" style=" float: left">
        <ul>
            <li>
                <b><g:message code="problem.topics"/>:</b>
                <span>
                    <g:each status="j" var="topic" in="${info.topics}">
                        <g:if test="${j == (info.topics.size() - 1)}">
                            ${topic}
                        </g:if>
                        <g:else>
                            ${topic},&nbsp
                        </g:else>
                    </g:each>
                </span>
            </li>
            <li><b><g:message code="problem.nd"/>:</b> <span id="problem-nd-$i"><g:formatNumber number="${info.nd}" maxFractionDigits="0"/></span</li>
            <li><b><g:message code="problem.user.best.time"/>:</b> <span id= "problem-user-best-time-$i">

            <g:if test="${info.userRecord}">
                ${info.userRecord}s
            </g:if>
            <g:else>
                <g:message code="verbosity.youNeverTry" />
            </g:else>

            </span></li>

            <li><b><g:message code="problem.best.time"/>:</b><span id="problem-best-time-$i">

            <g:if test="${info.record.user}">
                ${info.record.time}s
                (<huxley:user user="${info.record.user}">${info.record.user.name}</huxley:user>)
            </g:if>
            <g:else>
                <g:message code="verbosity.anybodyNeverTry" />
            </g:else>
            </span></li>
            <g:if test="${session['license'].isAdmin()}">
                <li>
                    <b><g:message code="verbosity.status" />:</b>
                    <select id="problem-status">
                        <option value="${Problem.STATUS_WAITING}" ${problemInstance.status == Problem.STATUS_WAITING ? 'selected="selected"' : ''}><g:message code="verbosity.avaliate" /></option>
                        <option value="${Problem.STATUS_ACCEPTED}" ${problemInstance.status == Problem.STATUS_ACCEPTED ? 'selected="selected"' : ''}><g:message code="verbosity.accepted" /></option>
                        <option value="${Problem.STATUS_REJECTED}" ${problemInstance.status == Problem.STATUS_REJECTED ? 'selected="selected"' : ''}><g:message code="verbosity.rejected" /></option>
                    </select>
                    <span id="problem-status-msg"></span>
                </li>
            </g:if>
            <g:if test="${session['license'].isAdmin()}">
                <li>
                    <b><g:message code="problem.totalTestCases"/>: </b>
                    <span>${totalTestCases}<span>
                <li>
            </g:if>

        </ul>
    </div>

    <div class="language-table" style=" float: right">
        <li><b><p style="text-align: left;font-size: x-small;font-style: italic;color: rgb(143, 109, 23);padding-top: 8px;"><g:message code="submissions.languages"/></p></b><li>
        <table>

            <tr>
                <g:each in="${languageStatus}">
                    <th>${it.name}</th>
                </g:each>
            </tr>
            <tr>
                <g:each in="${languageStatus}">

                    <td class="lang-${it.id}">
                        <g:if test="${it.status == EvaluationStatus.CORRECT}">
                            <img src="/huxley/images/icons/ok.png" />
                        </g:if>
                        <g:elseif test="${it.status == EvaluationStatus.WRONG_ANSWER}">
                            <img src="/huxley/images/icons/error.png" />
                        </g:elseif>
                        <g:else>
                            <img src="/huxley/images/icons/null.jpg" />
                        </g:else>
                    </td>
                </g:each>
            </tr>
        </table>
    </div>



    <div class="left" style="width: 710px; max-width: 710px;">
        <h2><g:message code="problem.description"/>&nbsp;</h2>
        <div class="problem-description-item" id="problem-description-modal-$problem.id">${info.description}</div>
        <h2><g:message code="problem.input.format"/>&nbsp;</h2>
        <div class="problem-description-item" id="problem-input-modal-$problem.id">${info.input}</div>
        <h2><g:message code="problem.output.format"/>&nbsp;</h2>
        <div class="problem-description-item" id="problem-output-modal-$problem.id">${info.output}</div>
    </div>
<g:if test="${hasExample}">
    <hr />
    <div style="float:right;">
    <g:link action= "downloadInput" controller= "problem" id= "${problemInstance.id}"  class= "ui-bbutton"><g:message code= "problem.input.example"/></g:link>
    <g:link action= "downloadOutput" controller= "problem" id= "${problemInstance.id}"  class= "ui-bbutton"><g:message code= "problem.output.example"/></g:link>
    </div>
</g:if>
<div class="clear"></div>
</div>
<br/>

<div id="problem-help-modal" class="modal">
    <style>
    .help {
        color: #8B8B8C;
        font-size: 12px;
    }
    .help table {
        width: 100%;
        margin-bottom: 20px;
    }

    .help tbody {
        display: table-row-group;
        vertical-align: middle;
        border-color: inherit;
    }

    .help tr {
        display: table-row;
        vertical-align: inherit;
        border-color: inherit;
    }
    .help td {
        padding: 8px;
        line-height: 20px;
        text-align: left;
        vertical-align: top;
        border-top: 1px solid #dddddd;
    }
    .help th {
        font-weight: bold;
        color: #666;
    }

    .help h3 {
        font-weight: bold;
        color: #666;
        font-size: 1.6em;
    }
    </style>
    <div class="help">
        <h3>O que você pode submeter</h3>
        <br><br>
        Atualmente o The Huxley suporta as seguintes linguagens de programação:
        <br><br>


        <table class="help">
            <thead>
            <tr><th>Linguagem</th><th>Compilador/Interpretador</th></tr>
            </thead>
            <tbody>
            <tr>
                <td>C</td>
                <td>GCC 4.4.3</td>
            </tr>
            <tr>
                <td>C++</td>
                <td>G++ 4.4.3</td>
            </tr>
            <tr>
                <td>Java</td>
                <td>Oracle Hotspot 1.7.0</td>
            </tr>
            <tr>
                <td>Octave</td>
                <td>GNU Octave, version 3.2.3</td>
            </tr>
            <tr>
                <td>Pascal</td>
                <td>Free Pascal Compiler 2.4.0-2</td>
            </tr>
            <tr>
                <td>Python</td>
                <td>Python 3.2</td>
            </tr>
            </tbody>
        </table>

        Você pode submeter o arquivo com o código-fonte, o The Huxley reconhecerá a <br>linguagem através da extensão no arquivo (c, cpp, java, m, pas, py).
        <div style="float: right; margin-top: 20px;">
            <a href="#" onclick="huxley.closeModal()" class="button">Fechar</a>
        </div>
    </div>
</diV>
<div id="modal-tip"></div>
<div id="modal-correct"></div>
</body>
</html>
