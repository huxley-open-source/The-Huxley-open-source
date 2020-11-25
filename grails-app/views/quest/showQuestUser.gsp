<%@ page import="com.thehuxley.Profile" %>
<%@ page import="com.thehuxley.EvaluationStatus" %>
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
        color: #4B94E4;
        text-decoration: none;
        font-size: 12px;
        font-weight: normal;
        float: right;
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
    .alert-confirmed {
        background-position: -104px -66px;
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

    .submission-list-cell.title {
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
    .score-input:focus{
        border: 1px solid #878787;
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
        background-color: #878787;
        cursor: default;
    }
    .code-container > div > div > div {
        width: 550px !important;
        overflow: auto !important;
        height: 450px;
        margin-bottom: 0px !important;
    }

    </style>
    <script src="${resource(dir:'js', file:'moment.min.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shCore.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushPython.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushOctave.js')}"></script>
    <link href="${resource(dir:'css', file:'shCoreDefault.css')}" type="text/css" rel="stylesheet"  />
    <script type="text/javascript">
        function showCode(id,tries,evaluation, containerId){
            var container = $('#code-' + containerId), title = $('#show-code-title-' + containerId), textContainer = $('#comment-' + containerId),  dateTitle = $('#show-code-date-title-' + containerId), date;
            $('#sub-list-' + containerId + ' a').removeClass('active');
            $('#list-'+ containerId+ '-' + id).addClass('active');
            $.ajax({
                url: huxley.root + 'submission/getComment',
                async: true,
                data: {id:id},
                beforeSend: huxley.showLoading(),
                dataType: 'json',
                success: function(data) {
                    huxley.hideLoading();
                    if (data.status ==='ok') {
                        textContainer.val(data.comment);
                    }
                    date = moment(data.date);
                    dateTitle.empty().append('enviado em ' + date.format("DD/MM/YY"));
                }
            });
            $.ajax({
                url: huxley.root + 'submission/downloadCodeSubmission',
                async: true,
                data: {id:id},
                dataType: 'json',
                beforeSend: huxley.showLoading(),
                success: function(data) {
                    huxley.hideLoading();
                    var toAppend = '<div><pre class="brush: ' + data.submission.language + '; toolbar: false; ">' +
                            data.submission.submissionCode +
                            '</pre></div>';
                    container.empty();
                    $('#code-' + containerId).append(toAppend);
                    if (evaluation === ${EvaluationStatus.CORRECT}) {
                        toAppend = '<i class="icon-small problem-correct-icon"></i>';
                    } else {
                        toAppend = '<i class="icon-small problem-wrong-icon"></i>';
                    }
                    toAppend += '<g:message code="questionnaire.show.code"/> ' + tries + ' <a href="/huxley/submission/downloadSubmission?bid=' + id +'"><i class="icon download"></i></a>';
                    title.empty();
                    title.append(toAppend);
                    SyntaxHighlighter.highlight();
                }
            });
        }

        function validate(id) {
            var regex = /^-?\d*(\.\d+)?$/, container = $('#' + id), questProblemId=undefined, statusContainer=undefined;
            if (id !== 'quest-score') {
                questProblemId = id.substring(id.lastIndexOf('-') + 1);
            }
            var label = "", score;
            var parentElem = container.parent(),
                    parentTagName = parentElem.get(0).tagName.toLowerCase();

            if(parentTagName == "label") {
                label = parentElem;
            }
            label.removeClass('error');
            if(regex.test(container.val())){
                    $.ajax({
                        url: huxley.root + 'quest/addQuestUserPenalty',
                        async: true,
                        data: {id:${questUser.id}, score: container.val(), questProblem: questProblemId},
                        dataType: 'json',
                        beforeSend: huxley.showLoading(),
                        success: function(data) {
                            statusContainer=$('#check-status-' + questProblemId);
                            huxley.hideLoading();
                            if(data.status = 'ok') {
                                score = data.score.toString();
                                if (score.indexOf('.') === -1) {
                                    score += '.0';
                                }
                                $('#quest-score').val(score);
                                huxley.notify('<g:message code="quest.score.updated"/>');
                                if (statusContainer.hasClass('uncheck')) {
                                    statusContainer.removeClass('uncheck').addClass('check');
                                }
                            }else{
                                huxley.error('<g:message code="verbosity.error.on.save"/>');
                            }
                        }
                    });
                score = container.val();
                if(score.indexOf('.') === -1) {
                    score += '.0';
                    container.val(score);
                }

            } else {
                label.addClass('error');
            }
        }
        function sendComment(problemId) {
            var submissionId = -1, commentBox = $('#comment-' + problemId);
            $('#submission-list-' + problemId +' .active').each(function() {
                submissionId = this.id.substring(this.id.lastIndexOf('-') + 1);

            });
            if (submissionId !== -1) {
                $.ajax({
                    url: huxley.root + 'submission/createComment',
                    async: true,
                    data: {id:submissionId, comment:commentBox.val()},
                    dataType: 'json',
                    beforeSend: huxley.showLoading(),
                    success: function(data) {
                        huxley.hideLoading();
                        if(data.status == 'ok'){
                            huxley.notify('<g:message code="quest.comment.created"/>');
                        }else{
                            huxley.error('<g:message code="verbosity.error.on.save"/>');
                        }
                    }
                });
            }
        }
        $(function() {
            $('.score-input').each(function (){
               $(this).change(function() {
                   validate(this.id);
               })
            });
            $('.comment-area').each(function() {
                var id = this.id.substring(this.id.indexOf('-') + 1), commentCheck = $('#comment-check-' + id);
                this.onkeyup = function(e) {
                    if (e.keyCode===13 && !e.shiftKey && $('#comment-check-' + id).prop('checked')) {
                        sendComment(id)
                    }
                };
            });
            $('.submission').each(function() {
                var that = this;
                this.onclick = function() {
                    var id = this.id.substring(this.id.lastIndexOf('-') + 1), container = $('#submission-list-' + id), toAppend = '', listContainer = $('#sub-list-' + id), similarityContainer = $('#similarity-' + id), similarityButton = $('#similarity-button-' + id), lastId = 0, tries = 0, evaluation = 0, hasCorrect = false;
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
                                    toAppend += '<ul>';
                                    $.each(data.submissions, function(i, submission){
                                        toAppend+= '<a id="list-' + id + '-' +submission.id +'" href="javascript:showCode(' + submission.id + ', ' + submission.tries + ', \'' + submission.evaluation + '\', ' + id + ');"><li>#' + submission.tries;
                                        if (submission.tries < 10) {
                                            toAppend += ' ';
                                        }
                                        if (submission.evaluation === ${EvaluationStatus.CORRECT}) {
                                            toAppend += '<i class="icon-small problem-correct-icon"></i>';
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
                                    showCode(lastId,tries,evaluation, id);
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

            })

        });


    </script>
</head>
<body>
<huxley:profile profile="${profile}" license="${session.license}"/>
<div class="box">
    <div>
        <span class="similarity-complementary-info" ><g:link action="showStatistics" controller="quest" id="${quest.id}">${quest.title}</g:link></span>
        <span class="th-right"><g:message code="questionnaire.score2"/>: <label><input type="text" class="score-input" value="${questUser.score}" id="quest-score"/>/${quest.score} <i class="icon-small edit bottom"></i></label></span>
    </div>
    <hr />
    <g:each in="${questionnaireProblem}" var="questProblem" status="i">
        <div>
            <h3 class="quest-problem-title">
            <g:if test="${resultMap.get(questProblem.id).checked}">
                <i class="icon check" id="check-status-${questProblem.id}"></i>
            </g:if>
            <g:else>
                <i class="icon uncheck" id="check-status-${questProblem.id}"></i>
            </g:else>
                ${questProblem.problem.name}
                <g:if test="${resultMap.get(questProblem.id) && resultMap.get(questProblem.id).correct}">
                    <g:if test="${resultMap.get(questProblem.id).suspectConfirmed}">
                        <i class="icon alert-confirmed th-right" id="problem-status-${questProblem.id}" data-evaluation="Correct"></i>
                    </g:if>
                    <g:elseif test="${resultMap.get(questProblem.id).suspect}">
                        <i class="icon correct-alert th-right" id="problem-status-${questProblem.id}" data-evaluation="Correct"></i>
                    </g:elseif>
                    <g:else>
                        <i class="icon correct th-right" id="problem-status-${questProblem.id}" data-evaluation="Correct"></i>
                    </g:else>
                </g:if>
                <g:elseif test="${resultMap.get(questProblem.id) && resultMap.get(questProblem.id).tried}">
                    <g:if test="${resultMap.get(questProblem.id).suspect}">
                        <i class="icon wrong-alert th-right" id="problem-status-${questProblem.id}" data-evaluation="Wrong"></i>
                    </g:if>
                    <g:else>
                        <i class="icon wrong th-right" id="problem-status-${questProblem.id}" data-evaluation="Wrong"></i>
                    </g:else>
                </g:elseif>


            </h3>
            <div style="margin-top: -25px;font-size: 10px;margin-bottom: 15px;">
                <div><b>Nível Dinâmico(ND)</b>: ${questProblem.problem.nd}</div>
                <div><b>Tópicos</b>:
                    <g:each in="${questProblem.problem.topics.name}" var="topic" status="index">
                        <g:if test="${index < questProblem.problem.topics.size() - 1}">${topic + ', ' }</g:if>
                        <g:else>${topic}</g:else>
                    </g:each>
                </div>
            </div>
            <div>
                <g:if test="${resultMap.get(questProblem.id).tried}">
                    <a href="javascript:void(0);" class="button submission" id="submission-button-${questProblem.id}">
                </g:if>
                <g:else>
                    <a href="javascript:void(0);" class="button disabled">
                </g:else>
                    <g:message code="questionnaire.show.submission"/></a>
                <span class="th-right"><g:message code="questionnaire.score.trim"/>
                    <label>
                        <input type="text" id="quest-prob-${questProblem.id}" class="score-input" value="${resultMap.get(questProblem.id).score}"/>
                        /${questProblem.score} <i class="icon-small edit bottom"></i></label></span>
            </div>
            <br>
            <div id="submission-list-${questProblem.id}" class="submission-list">
                <div style="display: table-row;">
                    <div style="display: table;">
                        <div style="display: table-row">
                            <div class="submission-list-cell title" style="width: 550px;">
                                <span id="show-code-title-${questProblem.id}"></span>
                                <div style="margin-top: -9px; width: 192px; text-align: right;">
                                    <span style="font-size: 10px; text-align: right;" id="show-code-date-title-${questProblem.id}">enviado em 22/04/87</span>
                                </div>
                            </div>
                            <div class="submission-list-cell title">
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
                            <div class="submission-list-cell comment-area-container"><textarea id="comment-${questProblem.id}" rows="4" cols="50" class="comment-area" placeholder="<g:message code="quest.insert.commment"/>..."></textarea>
                                <div><div class="th-right" style="line-height: 30px;"><a href="javascript:sendComment(${questProblem.id});" class="button th-right" style="margin: 0px 10px;"><g:message code="quest.send.comment"/></a><label style="font-size: 12px;"><input type="checkbox" name="checkbox" value="value" style="vertical-align: middle;" id="comment-check-${questProblem.id}"><g:message code="quest.enter.to.send"/></label></div></div>

                            </div>
                            <div style="width: 45px;"></div>
                        </div>
                    </div>

                </div>
            </div>

            <br>
            <hr />

        </div>
    </g:each>
</div>
</body>
</html>
