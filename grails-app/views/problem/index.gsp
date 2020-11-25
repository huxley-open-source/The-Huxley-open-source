<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <link href="<g:resource dir="css" file="problem-accordion.css"/>" type="text/css" rel="stylesheet">
    <link href="<g:resource dir="css" file="problem.css"/>" type="text/css" rel="stylesheet">
    <script src="${resource(dir:'js', file:'problem-accordion.js')}"></script>

    <style>
    #spin {
        padding-top: 90px;
    }

    .problem-slider {
        margin: 10px;
    }

    label {
        margin: 10px 0;
    }

    fieldset {
        margin-bottom: 20px;
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
    .box {
        height: 100%;
        background-color: white;
        border: 1px solid #E6E6E6;
        padding: 10px;
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
    .linenum a {color: #909090;}
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

    </style>
</head>
<body>

<div class="box" style="display: table;">
    <h3><g:message code="problem.find"/></h3>

    <input type="text" name="problema" placeholder="<g:message code="problem.tip.problem"/>" style="width: 80%; margin-bottom: 20px; margin-right: 5px;" class="ui-input" id="input-problem"  />
    <input id="advanced-filter" type="submit" value="Avançado" class="ui-bbutton" />

    <div id="advanced-filter-form" style="display: none;">
        <fieldset>
            <label>
                <strong><g:message code="problem.nd"/>: </strong>
                <span id="nd"></span>
                <div id="nd-slider" class="problem-slider"></div>
            </label>
        </fieldset>
        <fieldset>
            <label>
                <strong><g:message code="problem.includeresolved"/>: </strong>
                <g:if test="${resolved.equals('false')}">
                    <input type="checkbox" name="resolved" id="resolved" />
                </g:if>
                <g:else>
                    <input type="checkbox" checked="checked" name="resolved" id="resolved" />
                </g:else>
            </label>
        </fieldset>

        <huxley:topicFilter/>

        <div class="clear"></div>

    </div>
</div>

<div id="problem-list"></div>
<div id="spin"></div>
<div id="modal"></div>
<div id="modal-correct"></div>
<div id="modal-tip"></div>

<script src="<g:resource dir="js" file="underscore-min.js"/>" type="text/javascript"></script>
<script src="<g:resource dir="js" file="mustache.min.js"/>" type="text/javascript"></script>
<script src="<g:resource dir="js" file="spin.min.js"/>" type="text/javascript"></script>
<script src="http://static.cdn.thehuxley.com/rsc/js/<g:meta name="th.js"/>" type="text/javascript"></script>
<script src="http://static.cdn.thehuxley.com/rsc/js/<g:meta name="th.ga"/>" type="text/javascript"></script>
<script type="text/javascript">
    $.fn.spin = function(opts) {
        this.each(function() {
            var $this = $(this), data = $this.data();
            if (data.spinner) {
                data.spinner.stop();
                delete data.spinner;
            }
            if (opts !== false) {
                data.spinner = new Spinner($.extend({color: $this.css('color')}, opts)).spin(this);
            }
        });
        return this;
    };
</script>

<script type="text/javascript">

    var ndMin = 1;
    var ndMax = 10;
    var offset = 0;
    var end = false;

    $(function () {
        huxleyTopic.setChangeFunction(search);

        $(document).delegate('.problem-help', 'click', function (e) {
            e.preventDefault();
            huxley.openModal('problem-help-modal');
        });


        var problemInputTimeOut;

        $(window).scroll(function (e) {
            var event = e || window.event

            if (!end && ($(window).scrollTop() + $(window).height() > $(document).height() - 200)) {
                offset += 20;
                searchAppend();
            }
        });


        search();
        $('div#nd-slider').slider({
            range: true,
            min: 1,
            max: 10,
            values: [1, 10],
            slide: function (event, ui) {
                $("span#nd").empty().append(ui.values[0] + ' - ' + ui.values[1]);
                ndMin = ui.values[0];
                ndMax = ui.values[1];
                search();
            }
        });

        $("span#nd").empty().append(ndMin + ' - ' + ndMax);

        $('#input-problem').keyup(function() {
            clearTimeout(problemInputTimeOut);
            problemInputTimeOut = setTimeout(function() {
                search();
            }, 2000);
        });

        $('input#resolved').click(search);

        $('div#spin').hide();

        $('input#advanced-filter').click(function () {
            $('div#advanced-filter-form').slideToggle();
        });

    });

    function search () {
        var template = '<h3 id="title-problem-{{id}}" data-id="{{id}}">{{name}}</h3>' +
                '<div id="problem-content-{{id}}" class="problem-content"><div>';

        end = false;
        offset = 0
        $.ajax('/huxley/problem/s', {
            data: {q: $('#input-problem').val(), ndMin: ndMin, ndMax: ndMax, resolved: $('input#resolved').is(':checked'), offset: offset, topicList:huxleyTopic.selectedId},
            type: 'POST',
            dataType: 'json',
            beforeSend: function () {
                $('div#problem-list').empty();
                $('div#spin').fadeIn().spin();
            },
            success: function (data) {
                var problemIds = new Array();
                $('div#problem-list').empty();
                if (data.length < 20) {
                    end = true;
                }
                $.each(data, function(i, problem) {
                    $('div#problem-list').append(Mustache.render(template, problem))
                    problemIds.push(problem.id)
                });
                $('div#spin').fadeOut();
                huxley.accordion('problem-list', {
                    onOpen: function (el) {updateProblemInfo($(el).data().id);},
                    onClose: function () {}
                });
                getProblemStatus(problemIds);
                huxleyProblem.getPendingSubmission();
            }
        });
    }

    function searchAppend () {
        var template = '<h3 id="title-problem-{{id}}" data-id="{{id}}" >{{name}}</h3>' +
                '<div id="problem-content-{{id}}" class="problem-content"><div>';

        $.ajax('/huxley/problem/s', {
            data: {q: $('#input-problem').val(), ndMin: ndMin, ndMax: ndMax, resolved: $('input#resolved').is(':checked'), offset: offset, topicList:huxleyTopic.selectedId},
            type: 'POST',
            dataType: 'json',
            beforeSend: function () {

            },
            success: function (data) {
                var problemIds = new Array();
                if (data.length < 20) {
                    end = true;
                }

                $.each(data, function(i, problem) {
                    $('div#problem-list').append(Mustache.render(template, problem))
                    problemIds.push(problem.id)
                });

                huxley.accordion('problem-list', {
                    onOpen: function (el) {updateProblemInfo($(el).data().id);},
                    onClose: function () {}
                });

                if (problemIds.length > 0) {
                    getProblemStatus(problemIds);
                }

                huxleyProblem.getPendingSubmission();
            }
        });
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
                            $('#title-problem-tip-' + problem.problem_id).on('click',function () { tip(problem.problem_id); });
                        }
                    }
                });
            }
        });
    };

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
                $(spin).css('height', '100px').spin();
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
                    '       <a class="button" href="/huxley/submission/index?problemId={{problem.id}}&userId=${session.profile.user.id}"><g:message code="problem.see.submissions"/></a>' +
                    '       <a class="button" id="example-input-{{problem.id}}" href="/huxley/problem/downloadInput/{{problem.id}}"><g:message code="problem.input.example"/></a>' +
                    '       <a class="button" id="example-output-{{problem.id}}" href="/huxley/problem/downloadOutput/{{problem.id}}"><g:message code="problem.output.example"/></a>' +
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



</script>

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
</body>
</html>