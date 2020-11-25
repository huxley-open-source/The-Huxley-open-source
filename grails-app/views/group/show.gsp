<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
<script src="${resource(dir:'js', file:'highcharts-2.2.0.js')}"></script>
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
<style type="text/css" id="page-css">
    .status-accepted{
        background: #1BD482;
        color: white !important;
    }
    .status-rejected{
        background: #CB4848;
        color: white !important;
    }
    .status-waiting{
        background: #5BC3CE;
        color: white !important;
    }
    .status{
        padding: 1px 5px;
        font-family: Arial;
        text-decoration: none !important;
        border: 0px;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        border-radius: 5px;
        line-height: 1.5em !important;
        font-size: 12px;
    }
    .quitter-icon {
        background: url("/huxley/images/icons/quitter.png") no-repeat 3px 9px;
        height: 26px;
        overflow: hidden;
        width: 26px;

    }
   .quitter-icon2  {
        background: url("/huxley/images/icons/quitter.png") no-repeat -28px 9px;
        height: 26px;
        overflow: hidden;
        width: 26px;
    }

    #quitter a:hover {
        background: url("/huxley/images/icons/quitter.png") no-repeat -28px 9px  !important;
        overflow: hidden;
        height: 26px;
        width: 26px;
    }

</style>
<script type="text/javascript">
    var groupId = ${clusterInstance?.id};
    var chartType = 1;
    var period = 'DAY';
    var tabChoosen = 0;
    var tabTotal = 4;
    var uri = window.location.protocol + "//" + window.location.host + "/huxley/group/show/";



    function generateAccessKey(){
        $.ajax({
            url: '${resource(dir:'/')}group/generateAccessKey/',
            data: 'id=' + groupId,
            dataType: 'json',
            async: false,
            success: function(data) {
                if(data.msg.status == 'ok'){
                    $('#accessKey').empty();
                    $('#accessKey').append(data.msg.accessKey);
                }
            }
        });
    }

    function acceptPendency(id){
        $.ajax({
            url: '${resource(dir:'/')}pendency/acceptGroupPendency/',
            data: 'id=' + id,
            dataType: 'json',
            async: false,
            success: function(data) {
                if(data.status == 'ok'){
                    $('#status-' + id).empty();
                    $('#status-' + id).append('<span class="status status-accepted" style="width: auto; line-height: 1.5em !important;font-size: 12px; margin-left: 10px; margin-top: 27px;"><g:message code='group.accepted'/></span>');
                    $('#button-' + id).empty();
                    $('#button-' + id).append('<buttom class="ui-gbutton" id="accept-' + id + '"disable="disabled" style="opacity:0.5; cursor: auto;"><g:message code="group.accept"/></buttom>'+
                            '<buttom class="ui-rbutton" id="reject-' + id + '"><g:message code="group.reject"/></buttom>');
                    $('#accept-' + id).click(function(){
                        acceptPendency(id)
                    });
                    $('#reject-' + id).click(function(){
                        rejectPendency(id)
                    });
                }
            }
        });
    }
    function rejectPendency(id){
        $.ajax({
            url: '${resource(dir:'/')}pendency/rejectGroupPendency/',
            data: 'id=' + id,
            dataType: 'json',
            async: false,
            success: function(data) {
                if(data.status == 'ok'){
                    $('#status-' + id).empty();
                    $('#status-' + id).append('<span class="status status-rejected" style="width: auto; line-height: 1.5em !important;font-size: 12px; margin-left: 10px; margin-top: 27px;"><g:message code='group.rejected'/></span>');
                    $('#button-' + id).empty();
                    $('#button-' + id).append('<buttom class="ui-gbutton" id="accept-'+id +'"id="accept-'+id +'"><g:message code="group.accept"/></buttom>'+
                            '<buttom class="ui-rbutton" disabled="disabled" id="reject-' + id + '" style="opacity:0.5; cursor: auto;"><g:message code="group.reject"/></buttom>');
                    $('#accept-' + id).click(function(){
                        acceptPendency(id)
                    });
                    $('#reject-' + id).click(function(){
                        rejectPendency(id)
                    });
                }
            }
        });
    }

    function updateTabs(){
        for(i = 0; i < tabTotal; i++){
            document.getElementById('header-' + i).className = "";
            document.getElementById('tabs-' + i).style.display = "none"
        }
        document.getElementById('header-' + tabChoosen).className = "active";
        document.getElementById('tabs-' + tabChoosen).style.display = ""

    }

    $(function() {
        accessChart();
        $( "#begin-date" ).datepicker();
        $( "#end-date" ).datepicker();
        updateTabs();

    });
    $(function() {
        $('#period').change(function() {

            if($('#period').val() == '${message(code:'group.period.day')}'){
                period = 'DAY';
            }
            if($('#period').val() == '${message(code:'group.period.week')}'){
                period = 'WEEK';
            }
            if($('#period').val() == '${message(code:'group.period.month')}'){
                period = 'MONTH';
            }
            if(chartType == 1){
                accessChart();
            }
            if(chartType == 2){
                submissionChart();
            }
            if(chartType == 3){
                questChart();
            }
            if(chartType == 4){
                questTopicChart();
            }
        });
        $('#begin-date').change(function() {
            if(chartType == 1){
                accessChart();
            }
            if(chartType == 2){
                submissionChart();
            }
            if(chartType == 3){
                questChart();
            }
        });
        $('#end-date').change(function() {
            if(chartType == 1){
                accessChart();
            }
            if(chartType == 2){
                submissionChart();
            }
            if(chartType == 3){
                questChart();
            }
            if(chartType == 4){
                questTopicChart();
            }
        });
    });

    function accessChart() {
        loading();
        chartType = 1;
        $.ajax({
            url: '/huxley/group/accessChart',
            data: 'id=' + groupId + '&startDate='+$('#begin-date').val()+'&endDate='+$('#end-date').val()+'&period=' + period,
            dataType: 'json',
            success: function(data) {
                $('#group-chart').empty();
                if(!data.msg){
                    chart = new Highcharts.Chart({
                        chart: {
                            renderTo: 'group-chart',
                            defaultSeriesType: 'spline'
                        },
                        title: {
                            text:'${message(code:'group.access.chart')}'
                        },
                        subtitle: {
                            text: '${message(code:'group.access.chart.description')}'
                        },
                        xAxis: {
                            categories: data.categories,
                            labels: {
                                formatter: function() {
                                    return null
                                }
                            }
                        },
                        yAxis: {
                            title: {
                                text: '${message(code:'group.access.chart.number')}'
                            },
                            labels: {
                                formatter: function() {
                                    return this.value
                                }
                            }
                        },
                        tooltip: {
                            crosshairs: true,
                            shared: true
                        },
                        plotOptions: {
                            spline: {
                                marker: {
                                    radius: 4,
                                    lineColor: '#666666',
                                    lineWidth: 1
                                }
                            }
                        },
                        series: [{
                            name: '${message(code:'group.access')}',
                            marker: {
                                symbol: 'square'
                            },
                            data: data.data

                        },
                            {
                                name: '${message(code:'group.questionnaire')}',
                                marker: {
                                    symbol: 'circle'
                                },
                                data: data.qData

                            }]
                    });

                    $('#chart-group-title').empty();
                    $('#chart-group-title').append('${message(code: 'group.access.chart')}');
                    $('#chart-group-menu').slideUp('fast');
                }else{
                    $('#chart-group-title').empty();
                    $('#chart-group-title').append('${message(code: 'group.access.chart')}');
                    $('#chart-group-menu').slideUp('fast');
                    $('#group-chart').append('<div style="width:678px; height: 400px; display: table-cell; vertical-align: middle; text-align: center;">${message(code:'verbosity.error.request.data')}</div>');
                }



            }



        });


    }

    function submissionChart() {
        loading();
        chartType = 2;
        $.ajax({
            url: '/huxley/group/submissionChart',
            data: 'id=' + groupId + '&startDate='+$('#begin-date').val()+'&endDate='+$('#end-date').val()+'&period=' + period,
            dataType: 'json',
            success: function(data) {
                $('#group-chart').empty();
                if(!data.msg){
                    chart = new Highcharts.Chart({
                        chart: {
                            renderTo: 'group-chart',
                            defaultSeriesType: 'spline'
                        },
                        title: {
                            text:'${message(code:'group.submission.chart')}'
                        },
                        subtitle: {
                            text: '${message(code:'group.submission.chart.description')}'
                        },
                        xAxis: {
                            categories: data.categories,
                            labels: {
                                formatter: function() {
                                    return null
                                }
                            }
                        },
                        yAxis: {
                            title: {
                                text: '${message(code:'group.submission.chart.number')}'
                            },
                            labels: {
                                formatter: function() {
                                    return this.value
                                }
                            }
                        },
                        tooltip: {
                            crosshairs: true,
                            shared: true
                        },
                        plotOptions: {
                            spline: {
                                marker: {
                                    radius: 4,
                                    lineColor: '#666666',
                                    lineWidth: 1
                                }
                            }
                        },
                        series: [{
                            name: '${message(code:'group.submission')}',
                            marker: {
                                symbol: 'square'
                            },
                            data: data.data

                        },
                            {
                                name: '${message(code:'group.questionnaire')}',
                                marker: {
                                    symbol: 'circle'
                                },
                                data: data.qData

                            }]
                    });

                    $('#chart-group-title').empty();
                    $('#chart-group-title').append('${message(code: 'group.submission.chart')}');
                    $('#chart-group-menu').slideUp('fast');
                }else{
                    $('#chart-group-title').empty();
                    $('#chart-group-title').append('${message(code: 'group.submission.chart')}');
                    $('#chart-group-menu').slideUp('fast');
                    $('#group-chart').append('<div style="width:678px; height: 400px; display: table-cell; vertical-align: middle; text-align: center;">${message(code:'verbosity.error.request.data')}</div>');
                }
            }

        });


    }

    function questChart() {
        loading();
        chartType = 3;
        $.ajax({
            url: '/huxley/group/questChart',
            data: 'id=' + groupId + '&startDate='+$('#begin-date').val()+'&endDate='+$('#end-date').val(),
            dataType: 'json',
            success: function(data) {
                $('#group-chart').empty();
                if(!data.msg){
                    chart = new Highcharts.Chart({
                        chart: {
                            renderTo: 'group-chart',
                            defaultSeriesType: 'column'
                        },
                        title: {
                            text: '${message(code:'group.questionnaire.chart')}'
                        },
                        subtitle: {
                            text: '${message(code:"group.questionnaire.chart.description")}'
                        },
                        xAxis: {
                            categories: data.categories,
                            labels: {
                                formatter: function() {
                                    return null
                                }
                            }
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: '${message(code:'group.questionnaire.chart.percentage')}'
                            }
                        },
                        tooltip: {
                            formatter: function() {
                                return ''+
                                        this.x + ' ' + this.series.name +': '+ this.y.toFixed(2) +' %';
                            }
                        },
                        plotOptions: {
                            column: {
                                pointPadding: 0.2,
                                borderWidth: 0
                            }
                        },
                        series: [{
                            name: '${message(code:'group.tryed')}',
                            data: data.tryData

                        }, {
                            name: '${message(code:'group.notTryed')}',
                            data: data.notTryData

                        }]
                    });


                    $('#chart-group-title').empty();
                    $('#chart-group-title').append('${message(code: 'group.questionnaire.chart')}');
                    $('#chart-group-menu').slideUp('fast');
                }else{
                    $('#chart-group-title').empty();
                    $('#chart-group-title').append('${message(code: 'group.questionnaire.chart')}');
                    $('#chart-group-menu').slideUp('fast');
                    $('#group-chart').append('<div style="width:678px; height: 400px; display: table-cell; vertical-align: middle; text-align: center;">${message(code:'verbosity.error.request.data')}</div>');
                }
            }

        });


    }

    function loading(){
        $('#group-chart').empty();
        $('#group-chart').append('<div style="text-align: center; font-size:20px; line-height:420px;">'+
                '${message(code: 'group.loading')}'+
                '<img style="border: 0 none; margin-left:10px;" src="/huxley/images/spinner.gif" /></div>');

    }

    function questTopicChart() {
        loading();
        chartType = 4;
        $.ajax({
            url: '/huxley/group/questTopicChart',
            data: 'id=' + groupId + '&startDate='+$('#begin-date').val()+'&endDate='+$('#end-date').val(),
            dataType: 'json',
            success: function(data) {
                if(data.categories != 'empty'){
                    $('#group-chart').empty();
                    chart = new Highcharts.Chart({
                        chart: {
                            renderTo: 'group-chart',
                            defaultSeriesType: 'column'
                        },
                        title: {
                            text: '${message(code:'group.questionnaire.topic.chart')}'
                        },
                        subtitle: {
                            text: '${message(code:'group.questionnaire.topic.chart.description')}'
                        },
                        xAxis: {
                            categories: data.categories,
                            labels: {
                                formatter: function() {
                                    return null
                                }
                            }
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: '${message(code:'group.questionnaire.topic.chart.percentage')}'
                            }
                        },
                        tooltip: {
                            formatter: function() {
                                return ''+
                                        this.x + ' ' + this.series.name +': '+ this.y.toFixed(2) +' %';
                            }
                        },
                        plotOptions: {
                            column: {
                                pointPadding: 0.2,
                                borderWidth: 0
                            }
                        }
                    });
                    var index = 0;
                    $.each(data.topics, function(i, topic) {
                        var series = {
                            id: 'series',
                            name: topic,
                            data: data.data[topic]
                        }
                        chart.addSeries(series,false);

                        chart.redraw(false);

                    });
                    var series = chart.series;

                    for (var i = 1; i < series.length; i++)
                    {
                        series[i].hide();
                    }
                    $('#chart-group-title').empty();
                    $('#chart-group-title').append('${message(code: 'group.questionnaire.topic.chart')}');
                    $('#chart-group-menu').slideUp('fast');
                }else{
                    chart = new Highcharts.Chart({
                        chart: {
                            renderTo: 'group-chart',
                            defaultSeriesType: 'column'
                        },
                        title: {
                            text: '${message(code:'group.questionnaire.topic.chart')}'
                        },
                        subtitle: {
                            text: '${message(code:'group.questionnaire.topic.chart.description')}'
                        },
                        xAxis: {
                            categories: data.categories,
                            labels: {
                                formatter: function() {
                                    return null
                                }
                            }
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: '${message(code:'group.questionnaire.topic.chart.percentage')}'
                            }
                        },
                        legend: {
                            layout: 'vertical',
                            backgroundColor: '#FFFFFF',
                            align: 'left',
                            verticalAlign: 'top',
                            x: 100,
                            y: 70,
                            floating: true,
                            shadow: true
                        },
                        tooltip: {
                            formatter: function() {
                                return ''+
                                        this.x + ' ' + this.series.name +': '+ this.y.toFixed(2) +' %';
                            }
                        },
                        plotOptions: {
                            column: {
                                pointPadding: 0.2,
                                borderWidth: 0
                            }
                        }
                    });

                    $('#chart-group-title').empty();
                    $('#chart-group-title').append('${message(code: 'group.questionnaire.topic.chart')}');
                    $('#chart-group-menu').slideUp('fast');
                    $('#group-chart').append('${message(code:'group.questionnaire.empty.list')}');
                }


            }

        });


    }


    $(function() {
        <g:if test="${pendency}">
            showPendencies();
        </g:if>
        <g:else>
            showProfile();
        </g:else>

    }); // END TABS
    var order = 'asc';
    var sort = 'name';
    function showProfile(){
        tabChoosen = 0;
        updateTabs();
        if( $('#profile').length ==0) {

            $('#tabs-0').append(
                    '<div id="profile" class="show-info">'+
                            '<table class="standard-table" id="profile-tab" style="display: table;">'+
                            '<tbody>'+
                            '<tr><td><span class="profile-complementary-info"><g:message code="group.name"/></span><span>${clusterInstance.name}</span></td></tr>'+
                            '<tr><td><span class="profile-complementary-info"><g:message code="group.institution"/></span><span>${clusterInstance.institution.name}</span></td></tr>'+
                            <g:if test="${clusterInstance.url}">
                            '<tr><td><span class="profile-complementary-info"><g:message code="group.link"/></span><span>' + uri + '${clusterInstance.url}</span></td></tr>'+
                            </g:if>
                            <g:else>
                            '<tr><td><span class="profile-complementary-info"><g:message code="group.link"/></span><span><g:message code="group.define.url"/> </span></td></tr>'+
                            </g:else>
                            '<tr><td><span class="profile-complementary-info"><g:message code="group.access.key"/></span><span id="accessKey" style="width: 25%">${clusterInstance.accessKey}</span><span style="width: 25%"><a href="javascript:generateAccessKey()" class="ui-gbutton" style="background: #1BD482 !important; padding: 8px 20px !important; cursor: pointer !important; color: white !important; font-size: 10px !important;"><g:message code='group.generate.key'/></a></span></td></tr>'+

                    '</tbody>'+
            '</table>'+
                            '</div>'
            );

            $.ajax({
                url: '${resource(dir:'/')}group/getMasters/',
                data: 'id=' + groupId,
                dataType: 'json',
                async: false,
                success: function(data) {
                    var masters = data.masters;
                    $('#profile').append('<table class="standard-table" >'+
                            '<thead>' +
                            '<tr>' +
                            '<th style="text-align: center; padding: 7px;">Nome do professor</th>' +
                            '</tr>' +
                            '</thead>'  +
                            '<tbody id="master-list"">'+
                            '</tbody>' +
                            '</table>' +
                            '</div>'
                    );

                    $.each(masters, function(i, master) {
                            $('#master-list').append('<tr><td  style="text-align: center;"><a href="${resource(dir:'/')}profile/show/' + master.hash + '">' + master.name +'</a></td></tr>');
                                            });

                    $('#profile').append(
                            '</tbody>' +
                                    '</table>'
                    );
                }
            });
        }
    }

    function showQuestionnaire(){
        tabChoosen = 1;
        updateTabs();
        if( $('#questionnaire').length ==0) {

            $('#tabs-1').append(
                    '<div id="questionnaire" class="show-info">' +
                            '</div>' +
                    '<hr><div id="th-export" class="th-right">' +
                        '<b>EXPORTAR NOTAS:</b>' +
                            '<a href="/huxley/group/exportQuest/'+groupId+'/?exportType=excel"><i class="excel-icon"/>Excel</a></li>' +
                            '<a href="/huxley/group/exportQuest/'+groupId+'/?exportType=csv"><i class="csv-icon"/>Csv</a>' +
                    '</div>'
            );

            $.ajax({
                url: '${resource(dir:'/')}quest/listByGroup/',
                data: 'id=' + groupId + '&sort=' + sort + '&order=' + order,
                dataType: 'json',
                async: false,
                success: function(data) {
                    var questionnaires = data.questionnaires;
                    $('#questionnaire').append(
                            '<table class="standard-table" >'+
                                    '<thead>'+
                                    '<tr>'+
                                    '<th style="text-align: center; padding: 7px;"><g:message code="variable.title"/></th>'+
                                    '<th style="text-align: center; padding: 7px;"><g:message code="profile.questionnaire.score"/></th>'+
                                    '</tr>'+
                                    '</thead>'  +
                                    '<tbody id="questionnaire-list" align="center">'
                    );

                    $.each(questionnaires, function(i, questionnaire) {

                            $('#questionnaire-list').append(
                                    '<tr>' +
                                            '<td><a href="${resource(dir:'/')}quest/showStatistics/'+questionnaire.questId+'">'+questionnaire.name+'</a></td>' +
                                            '<td>'+questionnaire.score+'</td>' +
                                            '</tr>'
                            );
                    });


                }
            });
        }

    }


    function showStudents(){
        tabChoosen = 2;
        updateTabs();
        if( $('#students').length ==0)
        {
            $('#tabs-2').append('<div id="students" class="show-info">'+
                    '</div>');
            $('#students').append('<table class="standard-table" >'+
                    '<div style="width: 303px; float: right;">*Clique na <div style="width: 20px; display: inline-block;" class="quitter-icon"></div> para marcar o aluno como desistente</div><hr>' +
                    '<thead>' +
                    '<tr id="student-table">'+
                    '<th onclick="orderBy(\'topcoder\')" style="text-align: center; padding: 7px;"><g:message code="variable.topCoderPosition"/> <img id="img-topcoder" src="/huxley/images/icons/sorted_none.gif"/></th>' +
                    '<th style="text-align: center; width: 20px">Desistente</th>' +
                    '<th onclick="orderBy(\'name\')" style="text-align: left; padding: 20px;"><g:message code="variable.name"/> <img id="img-name" src="/huxley/images/icons/sorted_none.gif"/></th>' +
                    '<th onclick="orderBy(\'tryed\')" style="text-align: center; padding: 7px;"><g:message code="variable.problem.tryed"/> <img id="img-tryed" src="/huxley/images/icons/sorted_none.gif"/></th>' +
                    '<th onclick="orderBy(\'correct\')" style="text-align: center; padding: 7px;"><g:message code="variable.problem.correct"/> <img id="img-correct" src="/huxley/images/icons/sorted_none.gif"/></th>' +
                    '<th onclick="orderBy(\'topCoderScore\')" style="text-align: center; padding: 7px;"><g:message code="variable.user.topCoderScore"/> <img id="img-topCoderScore" src="/huxley/images/icons/sorted_none.gif"/></th>' +
                    '<th onclick="orderBy(\'submission\')" style="text-align: center; padding: 7px;"><g:message code="variable.user.submission.count"/> <img id="img-submission" src="/huxley/images/icons/sorted_none.gif"/></th>' +
                    '</tr>'+
                    '</thead>'  +
                    '<tbody id="student-list" align="center">'+
                    '</tbody>'                                      +
                    '</table>' +
                    '</div>');
        }

        $.ajax({
            url: '${resource(dir:'/')}group/getStudents/',
            data: 'id=' + groupId + '&order='+order+'&sort='+sort,
            dataType: 'json',
            async: false,
            success: function(data) {
                $('#student-list').empty();
                var students = data.students;
                $.each(students, function(i, student) {
                    var row = '<tr>' +
                        '<td>'+student.topCoderPosition+'</td>';

                    if(student.userStatusGroup == 0) {
                        row +=  '<td id="quitter" style="padding-right: 0px;"><a title="Marcar o aluno como desistente!"  style="margin-left: -11px;" id = "th-quitter-' + student.id + '" class="quitter-icon tooltip" href="javascript:void(0)" onclick="markQuitter('+ student.id + ');"></a></td>';
                    } else {
                        row +=  '<td id="quitter" style="padding-right: 0px;"><a  title="Desmarcar o aluno como desistente!" style="margin-left: -11px;" id = "th-quitter-' + student.id + '" class="quitter-icon2 tooltip" href="javascript:void(0)" onclick="markQuitter('+ student.id + ');"></a></td>';
                    }

                    row +=  '<td  style="text-align: left; width: 276px;"><a href="${resource(dir:'/')}profile/show/'+ student.hash +'">'+student.name+'</a></td>' +
                        '<td>'+student.problemsTryed+'</td>' +
                        '<td>'+student.problemsCorrect+'</td>' +
                        '<td>'+student.topCoderScore.toFixed(2)+'</td>' +
                        '<td>'+student.submissionCount+'</td></tr>';

                    $('#student-list').append(row);
                });


            }
        });


    }


    function markQuitter(sId) {

        var aux = 1;
        if($('#th-quitter-' + sId).hasClass('quitter-icon2')) {
            aux = 0;
        }

        $.ajax({
            url: '/huxley/group/markQuitter',
            data: 'sId=' + sId + '&gId=' + groupId + '&mark=' + aux,
            dataType: 'json',

            success: function(data) {
               if(data.status == 'ok') {
                   if(aux == 1) {
                       $('#th-quitter-' + sId).removeClass('quitter-icon');
                       $('#th-quitter-' + sId).addClass('quitter-icon2');
                       $('#th-quitter-' + sId).attr('title', 'Desmarcar aluno como desistente!');
                   } else {
                       $('#th-quitter-' + sId).removeClass('quitter-icon2');
                       $('#th-quitter-' + sId).addClass('quitter-icon');
                       $('#th-quitter-' + sId).attr('title', 'Marcar aluno como desistente!')
                   }
               }
            }
        })
    }

    function showPendencies(){
        tabChoosen = 3;
        updateTabs();
        var row = '';
        if($("#invite-list").html().length == 0){
            $.ajax({
                url: '${resource(dir:'/')}pendency/listGroupPendencies/',
                data: 'id=' + groupId,
                dataType: 'json',
                async: false,
                success: function(data) {
                    $('#student-list').empty();
                    var students = data;
                    $.each(students, function(i, student) {
            row = '<tr>'+
                    '<td>'+
            '<div>'+
                '<div >'+
                    '<div class="user-box">'+
                        '<div class="picture" style="float:left;"><img src="http://img.thehuxley.com/data/images/app/profile/thumb/' + student.userCreated.photo + '" alt="' + student.userCreated.name + '"></div>'+
                        '<div class="info">'+
                        '<ul>'+
                            '<li class="name"><a href="/huxley/profile/show/' + student.userCreated.hash + '">' + student.userCreated.name + '</a></li>'+
                        '</ul>'+
                    '</div>'+
                '</div>'+
                '</div>'+
            '</div>'+
            '<div>'+
                '<div id="status-' + student.id + '">';
                    if(student.status == 1){
                        row += '<span class="status status-accepted" style="width: auto; line-height: 1.5em !important;font-size: 12px; margin-left: 10px; margin-top: 27px;"><g:message code='group.accepted'/></span>';
                    }else if(student.status == 2){
                        row += '<span class="status status-rejected" style="width: auto; line-height: 1.5em !important;font-size: 12px; margin-left: 10px; margin-top: 27px;"><g:message code='group.rejected'/></span>';
                    }else if(student.status == 0){
                        row += '<span class="status status-waiting" style="width: auto; line-height: 1.5em !important;font-size: 12px; margin-left: 10px; margin-top: 27px;"><g:message code='group.waiting'/></span>';
                    }
                row += '</div>'+
                '<div style="float: right; margin-top:25px;">'+
                    '<div id="button-' + student.id + '">';
                        if(student.status == 1){
                            row += '<buttom class="ui-gbutton" disable="disabled" id="accept-'+student.id +'" style="opacity:0.5; cursor: auto;"><g:message code="group.accept"/></buttom>'+
                                    '<buttom class="ui-rbutton" id="reject-'+student.id +'"><g:message code="group.reject"/></buttom>';
                        }else if(student.status == 2){
                            row += '<buttom class="ui-gbutton" id="accept-'+student.id +'" ><g:message code="group.accept"/></buttom>'+
                                    '<buttom class="ui-rbutton" disabled="disabled" id="reject-'+student.id +'" style="opacity:0.5; cursor: auto;"><g:message code="group.reject"/></buttom>';
                        }else if(student.status == 0){
                            row += '<buttom class="ui-gbutton" id="accept-'+student.id +'" ><g:message code="group.accept"/></buttom>'+
                                    '<buttom class="ui-rbutton" id="reject-'+student.id +'" ><g:message code="group.reject"/></buttom>';
                        }
                        row +=
                    '</div>'+
                '</div>'+
            '</div>'+
                    '</td>'+
                    '</tr>';
                        $("#invite-list").append(row);
                        $('#accept-'+student.id).click(function(){
                            acceptPendency(student.id)
                        });
                        $('#reject-'+student.id).click(function(){
                            rejectPendency(student.id)
                        });
                    });


                }
            });
        }
    }
    function orderBy(attribute){
        sort = attribute;
        var imgId = '#img-'+attribute
        $('#img-topcoder').attr('src','/huxley/images/icons/sorted_none.gif');
        $('#img-tryed').attr('src','/huxley/images/icons/sorted_none.gif');
        $('#img-correct').attr('src','/huxley/images/icons/sorted_none.gif');
        $('#img-name').attr('src','/huxley/images/icons/sorted_none.gif');

        if ('desc' == order){
            order = "asc";
            $(imgId).attr('src','${resource(dir:'images/icons', file:'sorted_asc.gif')}');
        }else{
            order = "desc";
            $(imgId).attr('src','${resource(dir:'images/icons', file:'sorted_desc.gif')}');
        }
        $('#student-list').empty();
        showStudents();
    }


    $(function() {
        $('#chart-menu-button').click(function(e) {
            $('#chart-group-menu').slideDown('fast');
            e.stopPropagation();
            $(document).one("click", function() {
                $('#chart-group-menu').slideUp('fast');
            });
        });
        if($("#group-name").text().length > 40){
            $("#group-name").css('font-size','14px');
        }

    });

    $(document).ready(function(){
        $('.tooltip').tooltip();
    });


</script>
</head>
<body>
<div class="box"><!-- Courses box -->
    <h3><span id="group-name">${clusterInstance.name}</span> <g:link action="remove" id="${clusterInstance.hash}" class="ui-rbutton" onclick="return confirm('${message code:'verbosity.are.u.sure'}')"><g:message code="group.remove"/></g:link><g:link action="manage" style="margin: 0 4px;" id="${clusterInstance.hash}" class="ui-bbutton"><g:message code="verbosity.add.user"/></g:link><g:link action="create" id="${clusterInstance.hash}" class="ui-gbutton"><g:message code="verbosity.edit"/></g:link></h3>
</div>
<span class="th-right muted th-license-available"><small><g:message code="license.availabe"/> ${total} <g:message code="license.availabe2"/></small></span>
<hr /><br />
<div class="box">
    <div style="border: 1px solid #0174aa; margin-top: 10px; margin-bottom: 20px;">
        <div style="background:url('${resource(dir:'images', file:'background-component.png')}') no-repeat #0174aa; width: 100%; height: 30px; line-height: 30px;">
            <div style="color: #fff; font-weight: bold; margin-left: 0;">
                <span id="chart-group-title" style="max-width: 140px; font-size: 12px;"><g:message code="group.access.chart"/></span>
                <span class="chart-menu-button" id="chart-menu-button" style="position: relative; left: 150px;"></span>
                <span style="float: right;" >
                    <input id="begin-date" type="text"  placeholder="${g.message(code:'variable.startdate')}" style="background: #fff; height: 18px;  width: 80px; border-radius: 3px;" />
                    <input id="end-date" type="text" placeholder="${g.message(code:'variable.enddate')}" style="background: #fff; height: 18px; width: 80px; border-radius: 3px;"/>
                    <g:select id="period" name="period" style="background: #fff;height: 19px; width: 130px; border-radius: 3px; border: 1px solid #eee; margin-right: 5px;" from="${[message(code:'group.period.day'),message(code:'group.period.week'),message(code:'group.period.month')]}" noSelection="${['0':message(code:'group.period.choose')]}" />
                </span>
            </div>
            <div>
                <div id="chart-group-menu" style="display: none; border: 1px solid #eee; z-index: 9999; position: relative; background:url('${resource(dir:'images', file:'background-component.png')}') no-repeat #ffffff; opacity: 0.85; width: 175px; box-shadow: 0px 2px 5px #eee; margin-left: 0px;">
                    <ul style="list-style: none; overflow: hidden;">
                        <li class="chart-menu-item" onclick="accessChart()"><g:message code="group.access.chart"/></li>
                        <li class="chart-menu-item" onclick="submissionChart()"><g:message code="group.submission.chart"/></li>
                        <li class="chart-menu-item" onclick="questChart()"><g:message code="group.questionnaire.chart"/></li>
                        <li class="chart-menu-item" onclick="questTopicChart()"><g:message code="group.questionnaire.topic.chart"/></li>
                    </ul>
                </div>
            </div>

        </div>
        <div style="margin: 0 auto; width:100%; height: 100%;" id="group-chart"></div>
    </div>
</div>
<hr />
<div class="profile-tabs"><!-- Top coder -->
    <div class="title">Informações complementares</div>
    <div class="tabs">
        <span id="header-0" style="padding: 10px 23px;" onclick="showProfile()" class="active">Geral</span>
        <span id="header-1" style="padding: 10px 23px;" onclick="showQuestionnaire()">Lista de questionários</span>
        <span id="header-2" style="padding: 10px 23px;" onclick="showStudents()">Lista de estudantes</span>
        <span id="header-3" style="padding: 10px 23px;" onclick="showPendencies()">Usuários Pendentes</span>
    </div>
    <li class="content" id="tabs-0" style="display:none;width:100%;"></li>
    <li class="content" id="tabs-1" style="display:none;width:100%;"></li>
    <li class="content" id="tabs-2" style="display:none;width:100%;"></li>
    <li class="content" id="tabs-3" style="display:none;width:100%;">

    <div id="pendency-list">
        <table class="standard-table">
            <tbody id="invite-list"></tbody>
        </table>
    </div>
    </div>
    </li>
</div>
</div>
</div>
<div class="clear"></div><br />
</div>
</body>
</html>