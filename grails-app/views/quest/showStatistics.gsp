<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'highcharts-2.2.0.js')}"></script>
    <script src="${resource(dir:'js', file:'huxley-problem.js')}"></script>
    <script src="${resource(dir:'js', file:'fileuploader.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'problem-accordion.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'huxley.css')}" type="text/css">
    <script src="${resource(dir:'js', file:'problem-accordion.js')}"></script>
    <script src="<g:resource dir="js" file="underscore-min.js"/>" type="text/javascript"></script>
    <script src="<g:resource dir="js" file="mustache.min.js"/>" type="text/javascript"></script>
    <script src="${resource(dir:'js', file:'moment.min.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shCore.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushPython.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushOctave.js')}"></script>
    <link href="${resource(dir:'css', file:'shCoreDefault.css')}" type="text/css" rel="stylesheet"  />

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

.useritem {
    width: 250px;
    display: table-cell;
}
.similarity-list-item {
    display: table-row;
}

.similarity-list-item img {
    width: 30px;
    vertical-align: middle;
}

.userbox {
    position: absolute;
    width: 240px;
    padding: 10px 0px;
}
.plag-container > .useritem > .userbox {
    position: relative;
}
.alert {
    background-position: -136px;
    width: 16px;
    height: 16px;
    position: absolute;
    top: -7px;
    left: 21px;
}

.plag-container {
    width: 460px;
    display: inline-block;
}
.plag-container > div > div.syntaxhighlighter {
    width: 460px !important;
    overflow: auto !important;
    height: 220px;
    margin-bottom: 0px !important;
}

.quest-tabs a.active {
    background: #fafafa !important;
    padding-bottom: 14px !important;
}

.quest-tabs a:hover {
    background: #fafafa !important;
    padding-bottom: 14px !important;
}

.score-input {
    font-size: 18px;
    font-weight: bold;
    width: 35px;
    vertical-align: sub;
    border: 1px solid transparent;
    text-align: right;
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

.modal-window {
    display: none;
}
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

.expanded {
    width: 920px !important;
    background-color: white;
    padding: 15px 15px !important;
}

.table {
    display: table;
    width: 920px;
}

.table-row {
    display: table-row;
    line-height: 44px;
}

.table-cell {
    display: table-cell;
}

.th {
    background: #EFEFEF;
}

.table-row h4, .table-row p, .table-row a {
    padding-left: 15px;
}

.table-row a {
    color: #878787;
    font-size: 14px;
}

.th h4, .th p, .th a {
    font-weight: bold;
}

.icon {
    background: transparent url("${resource(dir: 'images', file: 'questionnaire_statistics.png')}") no-repeat;
    display: inline-block;
    width: 30px;
    height: 30px;
    vertical-align: middle;
}
.pointer {
    width: 68px;
    background-position-x: -53px;
    margin-top: 10px;
}
.icon-small {
    background: transparent url("${resource(dir: 'images', file: 'questionnaire_view.png')}") no-repeat;
    display: inline-block;
    width: 16px;
    height: 16px;
    vertical-align: middle;
}
.edit {
    background-position: -76px -39px;
}

.alert {
    background-position: -136px -7px;
    width: 16px;
    height: 16px;
    margin-top: 10px;
}

.imagebox {
    padding-right: 4px;
    vertical-align: baseline !important;
}

.disabled {
    background-color: #878787;
    cursor: default;
}

.info span {
    text-overflow: ellipsis;
    width: 180px;
    white-space: nowrap;
    overflow: hidden;
    display: block;
}


</style>




<script type="text/javascript">
        var questId = '${questionnaireInstance.id}';
        $(function(){
            showGroups();
        });

        Highcharts.setOptions({
            lang: {
                shortMonths: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'],
                months: ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro']
            }
        });
        function showInfo(hash){
            if($('#score').html().length === 0 ) {
                $.ajax({

                    url: huxley.root + 'quest/getQuestUserByGroup',
                    data: 'questId=' + questId + '&hash=' + hash,
                    async: false,
                    dataType: 'json',
                    beforeSend: huxley.showLoading(),
                    success: function (data) {
                        var toAppend = '<div class="table"><div class="table-row"><div class="table-cell th"><p><g:message code="questionnaire.user"/></p></div><div class="table-cell th"><p><g:message code="questionnaire.score"/></p></div></div>';
                        $.each(data.questionnaireList, function (i, questionnaire) {
                            var score = questionnaire.userScore.toString();
                            if (score.indexOf('.') === -1) {
                                score += '.0';
                            }
                            toAppend += '<div class="table-row"><div class="table-cell"><a href="' + huxley.root + 'quest/showQuestUser/' + questionnaire.id + '">' +
                                    questionnaire.name + '</a></div>' +
                                    '<div class="table-cell" style="padding-left: 20px;"><p data-qid="' + questionnaire.id + '">' + score + '</p></div></div>' +
                                    '<div class="table-row"><div class="table-cell"><hr></div><div class="table-cell"><hr></div></div>';


                        });
                        toAppend += '</div>'
                        $('#score').append(toAppend);

                    }
                });
            }
        }                          //<a ><span class="submission-action-button-arrow"></span></a><div class="submission-actions">
        var hash ='';
        function toolbar(newHash){
            hash = newHash;
            $('#groups').empty();
            $('#groups').append('<div class="box expanded"><div id="th-quest-tabs" class="quest-tabs"><a href="javascript:void(0)" id="score-tab" onClick="changeContext(\'score\') "><b><g:message code="questionnaire.score"/></b></a><a href="javascript:void(0)" id="similarity-tab" onClick="changeContext(\'similarity\') "><b><g:message code="questionnaire.similarity"/></b></a><a href="javascript:void(0)" id="confirmed-tab" onClick="changeContext(\'confirmed\') "><b><g:message code="questionnaire.confirmed"/></b></a><a href="javascript:void(0)" onClick="changeContext(\'charts\')" id="charts-tab" "><b><g:message code="questionnaire.chart" /></b></a>  <a href="javascript:void(0)" id="closed" onclick="showGroups()"><g:message code="questionnaire.hide.info"/></a></div>');
            $('#th-quest-tabs').append('<div id="th-export"  class="th-right quest-tabs">' +
                                '<a id="th-export-notes" onclick="openMenu(event)">Exportar notas<i class="th-arrow-icon" /></a></br>' +
                                    '<div id="th-menu-export">' +
                                        '<ul id="th-menu" class="th-dropdown-menu" >' +
                                            '<li><a href="' + huxley.root + 'quest/downloadNotes?exportType=excel&qId=' + questId + '&hash=' + hash + '"><i class="excel-icon"/>Excel</a></li>' +
                                            '<li><a href="' + huxley.root + 'quest/downloadNotes?exportType=csv&qId=' + questId + '&hash=' + hash + '"><i class="csv-icon"/>CSV</a></li>' +
                                        '</ul>'  +
                                        '</div>' +
                                    '</div><hr>');
            $('#groups').append('<div id="score" class="tab-content box expanded" style="display:none;"></div>');
            $('#groups').append('<div id="similarity" class="tab-content box" style="display:none; width:946px;"></div>');
            $('#groups').append('<div id="confirmed" class="tab-content box" style="display:none; width:946px;"></div>');
            $('#groups').append('<div id="charts" class="tab-content box expanded" style="display:none;"></div></div>');
            changeContext('score');
        }
        function openMenu(ev) {
            $('#th-menu').toggleClass('th-open-menu');
            $('#th-export').toggleClass('th-change-color');
            ev.stopPropagation();
            if ($('.th-open-menu').is(':visible')) {
                $(document).one('click', function () {
                    $('#th-menu').removeClass('th-open-menu')
                    $('#th-export').removeClass('th-change-color');
                });
            }
        }

        function changeContext(context){
            if (context === 'score') {
                showInfo(hash);
            } else if (context === 'similarity') {
                showSimilarity(hash);
            } else if(context === 'confirmed') {
                showConfirmed(hash);
            } else if (context === 'charts') {
                showChart(hash);
            }
            $('.tab-content').hide();
            $('.quest-tabs a').removeClass("active");
            $('#' + context).show();
            $('#' + context + '-tab').addClass("active");
            huxley.hideLoading();
        }

        function showGroups(){
            var toAppend='<div class="box expanded"><tdiv class="table">'+
                    '<div class="table-row">'+
                    '<div class="table-cell th"><h4><g:message code="entity.group"/></h4></div><div class="table-cell th"><h4><g:message code="statistics.average.note"/></h4></div><div class="table-cell th"><h4><g:message code="statistics.try.percentage"/></h4></div><div class="table-cell th"></div>'+
                    '</div>';
                    <g:each in="${statistics}" var="statistic">
                    toAppend+='<div class="table-row"><div class="table-cell"><g:link action="show" controller="group" id="${statistic.group.hash}">${statistic.group.name}</g:link></div><div class="table-cell"><p><g:formatNumber number="${statistic.averageNote}" type="number" maxFractionDigits="2" /></p></div><div class="table-cell"><p><g:formatNumber number="${statistic.tryPercentage * 100}" type="number" maxFractionDigits="2" />%</P></div><div class="table-cell"><a href="javascript:void(0)" onclick="toolbar(\'${statistic.group.hash}\')" ><g:message code="questionnaire.more.details"/></a></div></div>';
                    </g:each>
            toAppend+='</tbody></div>'+
            '</table>';
            $('#groups').empty();
            $('#groups').append(toAppend);
        }

        function createChart(divId,type,series,categories,title,yAxisTitle) {

            chart1 = new Highcharts.Chart({

                chart: {

                    renderTo: divId,

                    type: type

                },

                title: {

                    text: title

                },

                xAxis: {
                    type: 'datetime',
                    dateTimeLabelFormats: {
                        day: '%e. %b'
                    },
                    categories: categories

                },

                yAxis: {

                    title: {

                        text: yAxisTitle

                    }

                },

                tooltip: {

                    formatter: function() {
                        if(type == "pie"){
                            return '<b>'+ this.point.name +'</b>: '+ this.percentage.toFixed(2) +' %';
                        }else{
                            var date = new Date(this.x);
                            return '<b>'+ this.series.name +'</b><br/>Data:' + Highcharts.dateFormat('%e de %B', date) + '<br/>Submissões: '+ this.y;

                        }
                    }

                },

                series: series


            });


        }


        function showChart(hash) {
            if($('#charts').html().length === 0 ) {
                $('#charts').append('<div class="box"><table class="show-list">' +
                        '<thead><tr><th><h3 class="quest-chart-title"><g:message code="questionnaire.chart.submission"/></h3></th></thead></table>' +
                        '<div id="placeholder" style="width:920px;height:300px"></div>' +
                        '<table class="show-list">' +
                        '<thead><tr><th><h3 class="quest-chart-title"><g:message code="questionnaire.chart.tryes"/></h3></th></thead></table>' +
                        '<div id="placeholder2" style="width:920px;height:300px"></div>' +
                        '<table class="show-list">' +
                        '<thead><tr><th><h3 class="quest-chart-title"><g:message code="questionnaire.chart.greater.seven"/></h3></th></thead></table>' +
                        '<div id="placeholder3" style="width:920px;height:300px"></div></div>');
                var options = {
                    lines: { show: true },
                    points: { show: true },
                    xaxis: { tickDecimals: 0, tickSize: 1 }
                };
                var data = [];
                var placeholder = $("#placeholder");
                $("#placeholder").dialog("open");
                $.ajax({
                    url: '${resource(dir:'/')}quest/chart/',
                    data: 'questId=' + questId + '&hash=' + hash,
                    dataType: 'json',
                    async: false,
                    beforeSend: huxley.showLoading(),
                    success: function (result) {
                        var gTryed = result.gTryed;
                        var gS = result.gS;
                        var lS = result.lS;
                        var sub = result.submissions;
                        createChart('placeholder', 'line', sub, '', '', 'Submissões');

                        var notTryed = 1 - gTryed;
                        var formatter = "formatter: function() { return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';   }";
                        var pie1 = [
                            {
                                data: [
                                    {
                                        name: 'Alunos que Tentaram',
                                        y: gTryed,
                                        sliced: true,
                                        selected: true
                                    },
                                    {
                                        name: 'Alunos que não Tentaram',
                                        y: notTryed
                                    }
                                ]
                            }
                        ];
                        createChart('placeholder2', 'pie', pie1, '', '');

                        var totalS = lS + gS;
                        var tGS = 0;
                        if (gS != 0) {
                            tGS = (gS * 100) / totalS;
                        }
                        var tLS = 0;
                        if (lS != 0) {
                            tLS = (lS * 100) / totalS;
                        }
                        var pie2 = [
                            {
                                data: [
                                    {
                                        name: 'Notas Maiores ou Iguais a 7',
                                        y: tGS,
                                        sliced: true,
                                        selected: true
                                    },
                                    {
                                        name: 'Notas Menores que 7',
                                        y: tLS
                                    }
                                ]
                            }
                        ];
                        createChart('placeholder3', 'pie', pie2, '', '', '');

                    }
                });
            }
        }

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
                    '       <a class="button" id="example-output-{{problem.id}}" href="/huxley/problem/downloadOutput/{{problem.id}}"><g:message code="problem.output.example"/></a>' +                    '       <a id="button-modal-uploader-{{problem.id}}"class="button" href="#" style="background: #1bd482;"></a>' +
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

    function showSimilarity(hash) {
        if($('#similarity').html().length === 0 ) {
            $.ajax({
                url: '${resource(dir:'/')}similarity/listByQuest/',
                data: 'questId=' + questId + '&hash=' + hash,
                dataType: 'json',
                async: false,
                beforeSend: huxley.showLoading(),
                success: function (result) {
                    if (result.problemList.length > 0) {
                        var toAppend = '<div style="margin-top: -5px">';
                        $.each(result.problemList, function (i, problem) {
                            toAppend += '<div class="box expanded" style="margin-top: 5px; padding: 5px 15px !important;"><div style="padding: 2px 2px; background: #e7f1f6; width: 100%; margin-bottom: 2px;"><b><i class="icon"></i>' + problem.name + '</b></div>' +
                                    '<div id="suspect-list-' + problem.id + '"><div>' +
                                    '<div style="display: table-cell; width: 100px;"><b>Nota:</b></div>' +
                                    '<div style="display: table-cell; width: 250px;"><b>Aluno Suspeito:</b></div>' +
                                    '<div style="display: table-cell; width: 121px;"></div>' +
                                    '<div style="display: table-cell; width: 260px;"><b>Primeiro a submeter:</b></div>' +
                                    '<div style="display: table-cell; width: 100px;"><b>Status:</b></div>' +
                                    '</div></div></div>';
                        });
                        toAppend += '</div>';
                        $('#similarity').append(toAppend);

                        $.each(result.list, function (i, plag) {
                            var confirmed = false, discarded = false, date1 = moment(plag.date1), date2 = moment(plag.date2), score;
                            score = plag.quest.score.toString();
                            if (score.indexOf('.') === -1) {
                                score += '.0';
                            }
                            toAppend = '<div style="border-top: 1px solid #ebebeb; height: 50px;"><div class="similarity-list-item">' +
                                    '<div style="display: table-cell; padding: 10px 40px 10px 10px; width: 60px;"><label><input type="text" data-plagId="' + plag.plagId + '" data-qId="' + plag.quest.qId + '" data-qpId="' + plag.quest.qpId + '" class="score-input" value="' + score + '" id="quest-score-' + plag.plagId + '"/><i class="icon-small edit bottom" style="margin-left: 5px"></i></label></div>';


                            toAppend += '<div class="user-suspect-info">' + plag.user1 +
                                    '<div class="date">' + date1.format('DD/MM') + ' às ' + date1.format('hh:mm') + '</div></div>' +
                                    '<div style="display: table-cell; padding: 0px 50px 0px 0px;"><i class="icon pointer"></i></div>' +
                                    '<div class="user-suspect-info">' +
                                    plag.user2 +
                                    '<div class=date>' + date2.format('DD/MM') + ' às ' + date2.format('hh:mm') + '</div></div>';
                            toAppend += '<div style="display: table-cell;text-align: right;"><div style="width: 100px; display: inline-block; text-align: left;" id="similarity-status-1-' + plag.plagId + '">';
                            if (plag.pStatus === ${com.thehuxley.Submission.PLAGIUM_STATUS_MATCHED}) {
                                toAppend += '<g:message code="similarity.matched"/>';
                            } else if (plag.pStatus === ${com.thehuxley.Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM}) {
                                confirmed = true;
                                toAppend += '<g:message code="similarity.teacher.plagium.2"/>';
                            }
                            toAppend += '</div><a class="ui-gbutton" href="javascript:void(0);" id="show-' + plag.plagId + '" style="float: none;" >Exibir</a></div></div></div>';
                            toAppend += '<div id="similarity-' + plag.plagId + '" style="margin-top: 5px"></div>';
                            $('#suspect-list-' + plag.problem).append(toAppend);
                            $('.user-suspect-info').each(function () {
                                var time = $(this).find('.date').html();
                                $(this).find('.date').remove();
                                $(this).find('.score').text(time);
                            });
                            toAppend = '';
                            toAppend += '<table class="standard-table" >' +
                                    '<tbody>' +
                                    '<tr><td><span class="similarity-complementary-info" ><g:message code="verbosit.status"/>: </span> <span id="similarity-status-' + plag.plagId + '">';
                            if (plag.pStatus === ${com.thehuxley.Submission.PLAGIUM_STATUS_MATCHED}) {
                                toAppend += '<g:message code="similarity.matched"/>';
                            } else if (plag.pStatus === ${com.thehuxley.Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM}) {
                                confirmed = true;
                                toAppend += '<g:message code="similarity.teacher.plagium.2"/>';
                            }
                            if (plag.pStatus === ${com.thehuxley.Submission.PLAGIUM_STATUS_TEACHER_CLEAN}) {
                                discarded = true;
                            }

                            toAppend += '</span></td></tr>' +
                                    '</tbody>' +
                                    '</table>' +
                                    '<div><div class="plag-container">' + plag.user1 +

                                    '<pre class="brush: ' + plag.language + '; toolbar: false; ">' +
                                    plag.code1 +
                                    '</pre></div>' +
                                    '<div class="plag-container">' + plag.user2 +
                                    '<pre class="brush: ' + plag.language + '; toolbar: false; ">' +
                                    plag.code2 +
                                    '</pre>' +
                                    '</div></div>' +
                                    '<div style="clear:both;"></div><hr>' +
                                    '<div style="text-align: right; height: 39px;"><a href="javascript:markAsPlag(' + plag.subId + ", 'quest-score-" + plag.plagId + "'" + ')" id="plag-button-' + plag.plagId + '" class="ui-rbutton';
                            if (confirmed) {
                                toAppend += ' disabled ';
                            }
                            toAppend += '">Marcar como similar</a>' +
                                    '<a href="javascript:markAsNotPlag(' + plag.subId + ", 'quest-score-" + plag.plagId + "'" + ')" id="not-plag-button-' + plag.plagId + '" class="ui-gbutton';
                            if (discarded) {
                                toAppend += ' disabled ';
                            }
                            toAppend += '">Descartar Similaridade</a></div>';
                            $('#similarity-' + plag.plagId).append(toAppend);
                            $('.userbox > .icon').remove();
                            $('#similarity-' + plag.plagId).hide();
                            $('#show-' + plag.plagId).on('click', function () {
                                $('#similarity-' + plag.plagId).toggle();
                            });
                        });
                        $('.similarity-list-item').find('.imagebox').each(function (i, item) {
                            if (i % 2 === 0) {
                                $(item).append('<i class="icon alert" style="margin-left: 5px"></i>')
                            }
                        });
                        SyntaxHighlighter.highlight();
                        $('.score-input').each(function () {
                            $(this).change(function () {
                                validate(this.id);
                            })
                        });
                    } else {
                        var toAppend = '<div style="margin-top: -5px;" class="expanded"><g:message code="quest.plag.not.found"/></div>';
                        $('#similarity').append(toAppend);
                    }

                }
            });
        }
    }
    function showConfirmed(hash) {
        if($('#confirmed').html().length === 0 ) {
            $.ajax({
                url: '${resource(dir:'/')}similarity/listConfirmedByQuest/',
                data: 'questId=' + questId + '&hash=' + hash,
                dataType: 'json',
                async: false,
                beforeSend: huxley.showLoading(),
                success: function (result) {
                    if (result.problemList.length > 0) {
                        var toAppend = '<div style="margin-top: -5px">';
                        $.each(result.problemList, function (i, problem) {
                            toAppend += '<div class="box expanded" style="margin-top: 5px; padding: 5px 15px !important;"><div style="padding: 2px 2px; background: #e7f1f6; width: 100%; margin-bottom: 2px;"><b><i class="icon"></i>' + problem.name + '</b></div>' +
                                    '<div id="suspect-list-' + problem.id + '"><div>' +
                                    '<div style="display: table-cell; width: 100px;"><b>Nota:</b></div>' +
                                    '<div style="display: table-cell; width: 250px;"><b>Aluno Suspeito:</b></div>' +
                                    '<div style="display: table-cell; width: 121px;"></div>' +
                                    '<div style="display: table-cell; width: 260px;"><b>Primeiro a submeter:</b></div>' +
                                    '<div style="display: table-cell; width: 100px;"><b>Status:</b></div>' +
                                    '</div></div></div>';
                        });
                        toAppend += '</div>';
                        $('#confirmed').append(toAppend);

                        $.each(result.list, function (i, plag) {
                            var confirmed = false, discarded = false, date1 = moment(plag.date1), date2 = moment(plag.date2), score;
                            score = plag.quest.score.toString();
                            if (score.indexOf('.') === -1) {
                                score += '.0';
                            }
                            toAppend = '<div style="border-top: 1px solid #ebebeb; height: 50px;"><div class="similarity-list-item">' +
                                    '<div style="display: table-cell; padding: 10px 40px 10px 10px; width: 60px;"><label><input type="text" data-plagId="' + plag.plagId + '" data-qId="' + plag.quest.qId + '" data-qpId="' + plag.quest.qpId + '" class="score-input" value="' + score + '" id="quest-score-' + plag.plagId + '"/><i class="icon-small edit bottom" style="margin-left: 5px"></i></label></div>';


                            toAppend += '<div class="user-suspect-info">' + plag.user1 +
                                    '<div class="date">' + date1.format('DD/MM') + ' às ' + date1.format('hh:mm') + '</div></div>' +
                                    '<div style="display: table-cell; padding: 0px 50px 0px 0px;"><i class="icon pointer"></i></div>' +
                                    '<div class="user-suspect-info">' +
                                    plag.user2 +
                                    '<div class=date>' + date2.format('DD/MM') + ' às ' + date2.format('hh:mm') + '</div></div>';
                            toAppend += '<div style="display: table-cell;text-align: right;"><div style="width: 100px; display: inline-block; text-align: left;" id="similarity-status-1-' + plag.plagId + '">';
                            if (plag.pStatus === ${com.thehuxley.Submission.PLAGIUM_STATUS_MATCHED}) {
                                toAppend += '<g:message code="similarity.matched"/>';
                            } else if (plag.pStatus === ${com.thehuxley.Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM}) {
                                confirmed = true;
                                toAppend += '<g:message code="similarity.teacher.plagium.2"/>';
                            }
                            toAppend += '</div><a class="ui-gbutton" href="javascript:void(0);" id="show-' + plag.plagId + '" style="float: none;" >Exibir</a></div></div></div>';
                            toAppend += '<div id="similarity-' + plag.plagId + '" style="margin-top: 5px"></div>';


                            $('#suspect-list-' + plag.problem).append(toAppend);
                            $('.user-suspect-info').each(function () {
                                var time = $(this).find('.date').html();
                                $(this).find('.date').remove();
                                $(this).find('.score').text(time);
                            });
                            toAppend = '';
                            toAppend += '<table class="standard-table" >' +
                                    '<tbody>' +
                                    '<tr><td><span class="similarity-complementary-info" ><g:message code="verbosit.status"/>: </span> <span id="similarity-status-' + plag.plagId + '">';
                            if (plag.pStatus === ${com.thehuxley.Submission.PLAGIUM_STATUS_MATCHED}) {
                                toAppend += '<g:message code="similarity.matched"/>';
                            } else if (plag.pStatus === ${com.thehuxley.Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM}) {
                                confirmed = true;
                                toAppend += '<g:message code="similarity.teacher.plagium.2"/>';
                            }
                            if (plag.pStatus === ${com.thehuxley.Submission.PLAGIUM_STATUS_TEACHER_CLEAN}) {
                                discarded = true;
                            }

                            toAppend += '</span></td></tr>' +
                                    '</tbody>' +
                                    '</table>' +
                                    '<div><div class="plag-container">' + plag.user1 +

                                    '<pre class="brush: ' + plag.language + '; toolbar: false; ">' +
                                    plag.code1 +
                                    '</pre></div>' +
                                    '<div class="plag-container">' + plag.user2 +
                                    '<pre class="brush: ' + plag.language + '; toolbar: false; ">' +
                                    plag.code2 +
                                    '</pre>' +
                                    '</div></div>' +
                                    '<div style="clear:both;"></div><hr>' +
                                    '<div style="text-align: right; height: 39px;"><a href="javascript:markAsPlag(' + plag.subId + ", 'quest-score-" + plag.plagId + "'" + ')" id="plag-button-' + plag.plagId + '" class="ui-rbutton';
                            if (confirmed) {
                                toAppend += ' disabled ';
                            }
                            toAppend += '">Marcar como similar</a>' +
                                    '<a href="javascript:markAsNotPlag(' + plag.subId + ", 'quest-score-" + plag.plagId + "'" + ')" id="not-plag-button-' + plag.plagId + '" class="ui-gbutton';
                            if (discarded) {
                                toAppend += ' disabled ';
                            }
                            toAppend += '">Descartar Similaridade</a></div>';
                            $('#similarity-' + plag.plagId).append(toAppend);
                            $('.userbox > .icon').remove();
                            $('#similarity-' + plag.plagId).hide();
                            $('#show-' + plag.plagId).on('click', function () {
                                $('#similarity-' + plag.plagId).toggle();
                            });
                        });
                        $('.similarity-list-item').find('.imagebox').each(function (i, item) {
                            if (i % 2 === 0) {
                                $(item).append('<i class="icon alert" style="margin-left: 5px"></i>')
                            }
                        });
                        SyntaxHighlighter.highlight();
                        $('.score-input').each(function () {
                            $(this).change(function () {
                                validate(this.id);
                            })
                        });
                    } else {
                        var toAppend = '<div style="margin-top: -5px;" class="expanded"><g:message code="quest.plag.confirmed.not.found"/></div>';
                        $('#confirmed').append(toAppend);
                    }

                }
            });
        }
    }
    $(function(){
       $('.right').hide();
       $('.left').css('width','100%');
    });
        function validate(id) {
            var regex = /^-?\d*(\.\d+)?$/, container = $('#' + id), questProblemId=container.data('qpid'), questUserId=container.data('qid'), plagId = container.data('plagId');
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
                    data: {id:questUserId, score: container.val(), id: questUserId},
                    dataType: 'json',
                    beforeSend: huxley.showLoading(),
                    success: function(data) {
                        huxley.hideLoading();
                        if(data.status = 'ok') {
                            score = data.score.toString();
                            if (score.indexOf('.') === -1) {
                                score += '.0';
                            }
                            $('*[data-qid="' + questUserId + '"]').empty().append(score);
                            $('*[data-qid="' + questUserId + '"]').val(score);
                            huxley.notify('<g:message code="quest.score.updated"/>');
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

        function markAsNotPlag(id, scoreId){
            var container = $('#' + scoreId), questProblemId=container.data('qpid'), questUserId=container.data('qid'), plagId = container.data('plagid');
             $.ajax({
                url: '${resource(dir:"/")}similarity/questMarkAsNotPlag',
                data: { 'id': id, 'qId': questUserId, 'pId': plagId},
                dataType: 'json',
                beforeSend: huxley.showLoading(),
                success: function(data) {
                    huxley.hideLoading();
                    if(data.status == 'ok'){
                        huxley.notify('<g:message code="quest.submission.status.updated"/>')
                        $('#similarity-status-' + plagId).empty().append('<g:message code="similarity.teacher.clean.2"/>');
                        $('#similarity-status-1-' + plagId).empty().append('<g:message code="similarity.teacher.clean.2"/>');
                        $('#plag-button-' + plagId).removeClass('disabled');
                        $('#not-plag-button-' + plagId).addClass('disabled');
                    }else{
                        huxley.error('<g:message code="verbosity.error.on.save"/>');
                    }
                }
            });
        }
        function markAsPlag(id,scoreId){
            var container = $('#' + scoreId), questProblemId=container.data('qpid'), questUserId=container.data('qid'), plagId = container.data('plagid');
            $.ajax({
                url: '${resource(dir:"/")}similarity/questMarkAsPlag',
                data: {'id': id, 'qId': questUserId, 'pId': plagId},
                dataType: 'json',
                beforeSend: huxley.showLoading(),
                success: function(data) {
                    huxley.hideLoading();
                    if(data.status == 'ok'){
                        huxley.notify('<g:message code="quest.submission.status.updated"/>')
                        $('#similarity-status-' + plagId).empty().append('<g:message code="similarity.teacher.plagium.2"/>');
                        $('#similarity-status-1-' + plagId).empty().append('<g:message code="similarity.teacher.plagium.2"/>');
                        $('#plag-button-' + plagId).addClass('disabled');
                        $('#not-plag-button-' + plagId).removeClass('disabled');
                        container.val(0);
                        validate(scoreId);
                    }else{
                        huxley.error('<g:message code="verbosity.error.on.save"/>');
                    }
                }
            });
        }


</script>

</head>
<body>
<div><span style="float: left;"><h4 class="questionnaire-title"><g:message code="entity.questionnaire" />: <span style="color: #f2b500;">${questionnaireInstance.title}</span></h4></span><span style="float: right;"><g:message code="" /><g:link class="ui-gbutton" action="duplicate" id="${questionnaireInstance.id}"><g:message code="verbosity.duplicate"/></g:link><g:link style="margin: 0 4px;" class="ui-bbutton" action="create" id="${questionnaireInstance.id}"><g:message code="verbosity.edit" /></g:link><g:link class="ui-rbutton" action="remove" id="${questionnaireInstance.id}" onclick="return confirm('${message code:'verbosity.are.u.sure'}')"><g:message code="verbosity.remove" /></g:link></span></div>
<hr/>
<br><br>
<div class="box expanded" >
    <div class="table">
        <div class="table-row th"><h4><g:message code="questionnaire.description" /></h4></div>
        <div class="table-row th"><div class="questionnaire-description"><p>${questionnaireInstance.description}</p></div></div>
    </div>
    <div class="table">
        <div class="table-row">
            <div class="table-cell th"><h4><g:message code="questionnaire.averageDifficulty" /></h4></div>
            <div class="table-cell th"><h4><g:message code="questionnaire.weightedAverageDifficulty" /></h4></div>
            <div class="table-cell th"><h4><g:message code="questionnaire.totalScore" /></h4></div>
        </div>
        <div class="table-row">
            <div class="table-cell"><p><g:formatNumber number="${averageDifficulty}" maxFractionDigits="2"/> </p></div>
            <div class="table-cell"><p><g:formatNumber number="${weightedAverageDifficulty}" maxFractionDigits="2"/> </p></div>
            <div class="table-cell"><p><g:formatNumber number="${questionnaireInstance.score}" maxFractionDigits="2"/> </p></div>
        </div>
    </div>
    <div class="table">
        <div class="table-row">
            <div class="table-cell th"><h4><g:message code="questionnaire.starts" /></h4></div>
            <div class="table-cell th"><h4><g:message code="questionnaire.ends" /></h4></div>
        </div>
        <div class="table-row">
            <div class="table-cell"><p>${startDate}</p></div>
            <div class="table-cell"><p class="finished">${endDate}</p></div>
        </div>

    </div>
</div>
<div style="clear: left;"/>
<hr/>
<br>
<div style="width: 920px;" id="groups">
</div>

<div  id="export-excel"></div>
</div>

<div style="clear: left; overflow: hidden;"></div>

<hr/>
<br/>

<div class="box expanded">
    <h3>Lista de Problemas</h3>
        <hr />
<g:each in="${questionnaireProblems}" var="questProblem" status="i">
    <div>
        <span class="th-right"><g:message code="questionnaire.score.trim"/>
                ${questProblem.score}</span>
        <h6 class="quest-problem-title">
            ${questProblem.problem.name}
        </h6>

        <div style="margin-top: -25px;font-size: 10px;margin-bottom: 15px;">
            <div><b>Nível Dinâmico(ND)</b>: ${questProblem.problem.nd}</div>
            <div><b>Tópicos</b>:
            <g:each in="${questProblem.problem.topics.name}" var="topic" status="index">
                <g:if test="${index < questProblem.problem.topics.size() - 1}">${topic + ', ' }</g:if>
                <g:else>${topic}</g:else>
            </g:each>
            </div>
        </div>

        <hr />

    </div>
</g:each>
</div>
<div id="spin"></div>
<div id="modal"></div>


</body>
</html>
