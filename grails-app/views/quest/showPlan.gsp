<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main-head"/>
    <link rel="stylesheet" href="${resource(dir: 'css/smoothness', file: 'jquery-ui-1.10.4.custom.min.css')}" type="text/css">
    <link href="<g:resource dir="css" file="problem-accordion.css"/>" type="text/css" rel="stylesheet">
    <script src="<g:resource dir="js" file="underscore-min.js"/>" type="text/javascript"></script>
    <script src="<g:resource dir="js" file="mustache.min.js"/>" type="text/javascript"></script>
    <script src="${resource(dir:'js', file:'jquery.jscrollpane.min.js')}"></script>
    <script src="${resource(dir:'js', file:'jquery-ui-1.10.4.custom.min.js')}"></script>
    <script src="${resource(dir:'js', file:'huxley.js')}"></script>
    <style type="text/css">
        div#mask-lift {
            overflow-x: auto;
            overflow-y: hidden;
            background: rgba(0, 0, 0, 0.8);
            position: fixed;
            top: 0;
            bottom: 0;
            right: 0;
            left: 0;
            z-index: 500;
            display: none;
        }

        div#mask-lift > div#mask-outer {
            display: table;
            height: 100%;
            width: 100%;
            table-layout: fixed;
        }

        div#mask-lift > div#mask-outer > div#mask-inner {
            display: table-cell;
            vertical-align: middle;
            width: 100%;
            text-align: center;
        }

        div#mask-lift > div#mask-outer > div#mask-inner > div#mask-container {
            display: inline-block;
            margin: 20px 0;
            outline: medium none;
            text-align: left;
        }

        div#mask-lift > div#mask-outer > div#mask-inner > div#mask-container .huxley-modal {
            background: white;
            padding: 20px;
            border-radius: 6px;
            overflow-x: hidden;
        }
        .topic {
            padding: 5px 5px;
            margin: 0px 1px;
            background-color: #B3B3B3;
            border-radius: 5px;
            font-size: 16px;
            line-height: 31px;
        }
        .nd {
            float:right;
            position: relative;
            padding: 20px 10px 15px;
            background-color: #5BC3CE;
            border-radius: 5px;
            color: white;
        }
        .nd span {
            font-size: 50px;
        }
        .nd-legend {
            position: absolute;
            right: 2px;
            bottom: -1px;
        }
        .description {
            border: 1px dashed #F5DEDE;
            padding: 10px;
            width: 475px;
        }
        .quest-list {
            overflow-x: auto;
            width: 100%;
        }
        .quest-list li {
            display: table-cell;
        }
        .quest-box{
            min-width: 150px;
            max-width: 150px;
            width: 150px;
            overflow-y:hidden;
            font-size: 12px;
            cursor: pointer;
        }
        .quest-box h5 {
            font-size: 14px;
        }
        .icon-questionnaire {
            background: url("/huxley/static/images/questionnaire.png") no-repeat scroll left bottom transparent;
            height: 21px;
            width: 34px;
        }
        .huxley-modal {
            background: white;
            padding: 20px;
            border-radius: 6px;
            max-width: 900px;
            max-height: 600px;
            overflow: auto;
        }
        .problem-modal-show .left {
            width: 870px;
            max-width: none;
        }


    </style>
    <script type="text/javascript">
    var isValid = false, importing;
        $(function () {
            topcoder();
            $('div#mask-lift').click(function (e) {
                e.preventDefault();
                closeModal();
            });
        });
        function openModal(container) {
            'use strict';
            huxley.closeMask();
            var div = document.getElementById(container);
            $('#mask-container').append($(div));
            $(div).addClass('huxley-modal').show();
            huxley.openMask();
        };

        function closeModal() {
            'use strict';
            $('.huxley-modal').hide();
            $('body').append($('#mask-container .huxley-modal'));
            huxley.closeMask();
        };
        var qId= [], questionnaireInfo = [], duration, factor = 1, startCourse, endCourse;
        function topcoder() {
            var view, collection = new hx.models.TopCoder();
            collection.url = hx.util.url.rest('topcoders');
            view = new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')});
            view.render();
            collection.fetch({reset: true});
        }
        $(function () {
            $( "#questionnaire-start-date" ).datepicker({dateFormat: 'dd/mm/yy',
            onSelect: function () {
                startCourse = $(this).val();
                createPlan();
            }});
            $( "#questionnaire-end-date" ).datepicker({dateFormat: 'dd/mm/yy',
                onSelect: function () {
                    endCourse = $(this).val();
                    createPlan();
                }});
            var profileTemplate = '<div class="user-box">' +
                    '<div class="picture"><img src="http://img.thehuxley.com/data/images/app/profile/thumb/{{owner.smallPhoto}}" alt="{{owner.name}}}"></div>' +
                    '<div class="info">' +
                    '<ul>' +
                    '<li class="name"><a href="/huxley/profile/show/{{owner.hash}}}">{{owner.name}}</a></li>' +
                    '</ul>' +
                    '</div>' +
                    '</div>';
            var template = '<h3 id="title">{{title}}</h3><br>' +
                    '<div class="right"> ' +
                    profileTemplate +
                    '</div>' +
                    '<span>Criado em {{dateCreated}}</span><br>'+
                    '<span><b><g:message code="questionnaire.description"/>: </b></span><br>'+
                    '<span style="font-size: 12px;">{{description}}</span>';

            var toAppend = '';
            $.ajax('/huxley/quest/getCourse', {
                type: 'GET',
                data: {id:${id}},
                dataType: 'json',
                success: function (data) {
                    moment.lang('pt-br');
                    data.plan.dateCreated = moment(data.plan.dateCreated).format('LL');
                    $("#course-info").append(Mustache.render(template, data.plan));
                    duration = data.plan.duration;
                    $.each(data.questionnaireList, function (i, questionnaire) {
                        var topicList = [];
                        var topics = '';
                        $.each(questionnaire.problemList, function (i, problem) {
                            $.each(problem.topic, function (i, topic) {
                                if(topicList.indexOf(topic) === -1) {
                                    if(topicList.length === 0){
                                        topics += '<span>' + topic + '</span>'
                                    } else {
                                        topics += '<span>, ' + topic + '</span>'
                                    }
                                    topicList.push(topic);
                                }
                            });
                        });
                        questionnaire.topic = topicList;
                        questionnaireInfo[questionnaire.id] = questionnaire;
                        qId.push(questionnaire.id);
                        printQuestionnaires();
                    });
                }
            });


        });
        function printQuestionnaires() {
        $('#quest-show').empty();
        $('#quest-show').append('<h3><g:message code="course.plan.questionnaire.list"/></h3>');
            $.each(qId, function (i, id){
                showQuestionnaire(id);
            });
            setButtonModalFunctions();
        }
        function updateQuestDates() {
            var t = moment(startCourse, 'DD-MM-YYYY'),
                    t2;
            $.each(qId, function (i, id){
                var questionnaire = questionnaireInfo[id], qStartDate = moment(questionnaire.startDate), qEndDate = moment(questionnaire.endDate);
                t.hour(qStartDate.hour());
                t.minute(qStartDate.minute());
                t.add(parseInt(questionnaire.interval * factor),'days');
                t2 = moment(t);
                questionnaire.initDate = t.format('DD/MM/YYYY HH:mm');
                t2.add(parseInt(questionnaire.duration * factor), 'days');
                t2.hour(qEndDate.hour());
                t2.minute(qEndDate.minute());


                questionnaire.finishDate = t2.format('DD/MM/YYYY HH:mm');
                t = moment(t2);
            });
            printQuestionnaires();
        }

        function createPlan() {
            $("#error-msg").empty();
            if(startCourse !== undefined && endCourse !== undefined) {
                var t = moment(startCourse, 'DD/MM/YYYY'),t2 = moment(endCourse, 'DD/MM/YYYY'), durationCourse = t2.diff(t,'days');
                if (t2.diff(t) >= 0) {

                    if(duration > durationCourse) {
                        factor = durationCourse/duration;
                    }
                    isValid = true;
                    updateQuestDates();
                } else {
                    isValid = false;
                    $("#error-msg").append('<g:message code="quest.invalid.period"/>');
                    $(".quest-period").empty().append('<g:message code="questionnaire.start.date.undefined"/>');
                }
            }
        }


        function showQuestionnaire(id) {
            var template = '<div>' +
                    '<div style="display:table-cell;" class="box">' +
                    '<span><b>De</b></span><br><span class="quest-period" id="startDate">'+
                    '{{#initDate}}'+
                    '{{initDate}}'+
                    '{{/initDate}}'+
                    '{{^initDate}}'+
                    '<span class="quest-period"><g:message code="questionnaire.start.date.undefined"/></span>'+
                    '{{/initDate}}'+
                    '</span><br>'+
                    '<span><b>À</b></span><br><span class="quest-period" id="endDate">'+
                    '{{#finishDate}}'+
                    '{{finishDate}}'+
                    '{{/finishDate}}'+
                    '{{^finishDate}}'+
                    '<span class="quest-period"><g:message code="questionnaire.start.date.undefined"/></span>'+
                    '{{/finishDate}}'+
                    '</span><br>'+
                    '</div>' +
                    '<div class="box" style="display:table-cell; width: 100%;">' +
                    '<div class="nd"><span id="ndMed">{{ndMed}}</span><div class="nd-legend">ND</div></div>'+
                    '<h3>{{title}}</h3>' +
                    '<div id="description" class="description">{{description}}</div><br>'+
                    '<div id="topics" class="topic-list">' +
                    '{{#topic}}' +
                    '<span class="topic"> {{.}} </span>' +
                    '{{/topic}}'+
                    '</div><br>'+
                    '<div style="float:right; font-size: 12px"><a href="javascript:toggleProblem({{id}})"><g:message code="questionnaire.problem.click.to.show"/></a></div>'+
                    '<div style="clear:both"></div><div id="problem-list-{{id}}" class="box" style="display:none; background-color: cornsilk;">'+
                    '<h3>Lista de problemas</h3>'+
                    '{{#problemList}}'+
                    '<hr>'+
                        '<span class="right">{{score}} ponto(s)</span><h5><a class="modal-button" href="#" data-id="{{id}}">{{name}}</a></h5><br>' +
                        '<span><b><g:message code="problem.nd"/>: </b></span><span>{{nd}}</span><br>' +
                        '<span><b><g:message code="group.questionnaire.topic.list"/>: </b></span><span class="topic-list">' +
                        '{{#topic}}' +
                        '<span class="topic"> {{.}} </span>' +
                        '{{/topic}}'+
                        '</span>'+
                    '{{/problemList}}'+
                    '</div></div></div>';

            $('#quest-show').append(Mustache.render(template, questionnaireInfo[id]));


        }
        function toggleProblem(id){
            $('#problem-list-' + id).toggle();
        }
        function setButtonModalFunctions () {
            $('a.modal-button').click(function (e) {
                e.preventDefault();
                var id = $(e.target).data().id;
                var template =  '<div id="modal-window" class="modal-window">' +
                        '   <div class="problem-modal-show">' +
                        '       <div>' +
                        '           <a href="javascript:huxley.closeModal()" class="close" style="font-size: 22px; font-weight: bold; color: grey;">×</a>' +
                        '           <h3 style="font-weight: bold; color: grey; font-size: 24px;">{{name}}</h3>' +
                        '           <hr />' +
                        '       </div>'+
                        '           <div style="float: left; max-width: 560px; min-width: 560px;">' +
                        '               <ul>' +
                        '                   <li><b><g:message code="problem.topics"/>:</b> <span>{{topics}}</span></li>' +
                        '                   <li><b><g:message code="problem.nd"/>:</b> <span>{{nd}}</span</li>' +
                        '                   <li><b><g:message code="problem.user.best.time"/>:</b> <span>{{userRecord}}</span></li>' +
                        '                   <li><b><g:message code="problem.best.time"/>:</b><span> {{& record}}</span></li>' +
                        '               </ul>' +
                        '           </div>' +
                        '           <div style="clear: left;"></div><hr/>' +
                        '           <div class="left">' +
                        '               <h2><g:message code="problem.description"/> </h2>' +
                        '               <div class="problem-description-item" id="problem-description-modal">{{& description}}</div>' +
                        '               <h2><g:message code="problem.input.format"/> </h2>'  +
                        '               <div class="problem-description-item" id="problem-input-modal">{{& input}}</div>' +
                        '               <h2><g:message code="problem.output.format"/> </h2>' +
                        '               <div class="problem-description-item" id="problem-output-modal">{{& output}}</div>' +
                        '           </div>' +
                        '           <div class="clear-both"></div>' +
                        '   <hr />' +
                        '   <div class="menu-panel">' +
                        '       <a class="button" id="example-input-{{id}}" href="/huxley/problem/downloadInput/{{id}}"><g:message code="problem.input.example"/></a>' +
                        '       <a class="button" id="example-output-{{id}}" href="/huxley/problem/downloadOutput/{{id}}"><g:message code="problem.output.example"/></a>' +
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



                                $('div#modal').append(Mustache.render(template, problem));
                                openModal('modal-window');
                                createReferenceSolution(id);
                                if(!hasExample){
                                    $("#example-input-" + id).remove();
                                    $("#example-output-" + id).remove();
                                }
                            }
                        });
                        function createReferenceSolution(id) {
                            $.ajax({
                                url: '/huxley/referenceSolution/listByProblem',
                                data: {id: id},
                                dataType: 'json',
                                success: function(data) {
                                    var row;
                                    var index = 0;
                                    $('#problem-reference-list-' + id).empty();
                                    $.each(data.referenceList, function(i, reference) {
                                        index ++;
                                        if(index%2==0){
                                            row = '<tr class="odd">';
                                        }else{
                                            row = '<tr class="even">';
                                        }

                                        if (reference.id != 0) {
                                            row += '<td class="list-label">' + reference.language + '</td><td class="list-label"><a href="/huxley/referenceSolution/show/'+reference.id+'"><g:message code="reference.solution.visualize"/></a></td></tr>';

                                        }else{
                                            row += '<td class="list-label">' + reference.language + '</td><td class="list-label"><g:message code= "reference.solution.permission"/></td></tr>';
                                        }
                                        $('#problem-reference-list-' + id).append(row);
                                    });
                                    $.each(data.notAvaiableList, function(i, reference) {
                                        index ++;
                                        if(index%2==0){
                                            row = '<tr class="odd">';
                                        }else{
                                            row = '<tr class="even">';
                                        }
                                        if(reference.status == "ok"){
                                            row += '<td class="list-label">'+reference.name + '</td><td class="list-label"><a href="/huxley/referenceSolution/create?id=' +id +'&language='+reference.name+'"> <g:message code="reference.solution.create"/></a></td></tr>';
                                        }else{
                                            row += '<td class="list-label">' + reference.name + '</td><td class="list-label"><g:message code="reference.solution.none"/></td></tr>';
                                        }

                                        $('#problem-reference-list-' + id).append(row);

                                    });
                                }

                            });
                        };
                    }
                });
            });
        }

    function submit(){
        var questList = [];
        if (isValid && !importing) {
            importing = true;
            $.each(qId, function(i, id) {
                var quest = questionnaireInfo[id];
                var questInfo = {id: quest.id, startDate: quest.initDate, endDate: quest.finishDate};
                questList.push(questInfo);
            });
            $.ajax('/huxley/quest/importCourse', {
                data: {groupId: ${params.groupId}, questList: JSON.stringify(questList)},
                type: 'POST',
                beforeSend: function () {
                    $('#import-button').empty();
                    mainAlert('Importando...');
                },
                dataType: 'json',
                success: function (data) {
                    if (data.status === 'ok'){
                        mainAlert('Importado com sucesso! <a href="/huxley/group/show/${hash}">Clique aqui para visualizar o grupo</a>');
                    } else {
                        $('#import-button').append('<a href="javascript:submit()" class="button" style="float:right;"><g:message code="quest.course.import"/></a>');
                        mainAlert('Não foi possível importar, ' + data.msg);
                    }

                    importing = false;
                },
                error: function() {
                    $('#import-button').append('<a href="javascript:submit()" class="button" style="float:right;"><g:message code="quest.course.import"/></a>');
                    mainAlert('Ocorreu um erro no sistema e não foi possível importar, tente novamente mais tarde');
                    importing = false;
                }

            });
        } else if (!isValid && (startCourse === undefined && endCourse === undefined)) {
            $("#error-msg").empty().append('<g:message code="quest.period.undefined"/>');
            $(".quest-period").empty().append('<g:message code="questionnaire.start.date.undefined"/>');

        }


    }


    </script>
    <style>
    h3 {
        font-weight: bold;
        font-size: 20px;
    }
    h5 {
        font-weight: bold;
        font-size: 16px;
    }
    .scroll-pane
    {
        width: 100%;
        height: 350px;
        overflow: auto;
    }

    </style>
</head>

<body>
<div id="box-content" class="box">
    <span id="import-button" style="float:right;"><a href="javascript:submit()" class="button" style="float:right;"><g:message code="quest.course.import"/></a></span>
    <div class="clearfix" id="course-info">

    </div>
    <br>
    <h5><g:message code="quest.course.period"/></h5>
    <input id="questionnaire-start-date"  style="width: 80px; background: #fff; border: #ccc 1px solid;  color: #888 !important;" name="startDateString" placeholder="Início"  type="text"  />
    <input id="questionnaire-end-date" style="width: 80px; background: #fff; border: #ccc 1px solid;  color: #888 !important;" name="startDateString" placeholder="Fim"  type="text"  /><span style="font-size:10px; color: red;" id="error-msg"></span><br>
    <span style="font-size:10px">*<g:message code="quest.course.tip"/></span>
    <div id="quest-show"></div>
</div>
<div id="modal"></div>

<div id="mask-lift" style="display: none;">
    <div id="mask-outer">
        <div id="mask-inner">
            <div id="mask-container"></div>
        </div>
    </div>
</div>

</body>
</html>