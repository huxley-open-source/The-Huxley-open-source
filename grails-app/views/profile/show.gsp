<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'highcharts-spider.js')}"></script>
    <script src="${resource(dir:'js', file:'highcharts-more.js')}"></script>
    <script type="text/javascript">
        $(function() {
            changeContext('profile');
            $.ajax({
                url: '${resource(dir:'/')}profile/getDataForChart/',
                data: 'id=${profile.user.id}',
                dataType: 'json',
                async: true,
                success: function(data) {
                    var categories = data.categories;
                    var data = data.data;

                    if(Object.keys(data).length != 0 ){
                        chart1 = new Highcharts.Chart({

                            chart: {
                                renderTo: 'chart',
                                polar: true,
                                type: 'line'
                            },


                            title: {
                                text: '<g:message code="profile.chart.description"/>',
                                x: -80
                            },

                            pane: {
                                size: '80%'
                            },

                            xAxis: {
                                categories: categories,
                                tickmarkPlacement: 'on',
                                lineWidth: 0
                            },

                            yAxis: {
                                gridLineInterpolation: 'polygon',
                                lineWidth: 0,
                                min: 0
                            },

                            tooltip: {
                                shared: true,
                                valueSuffix: '%',
                                valueDecimals: 2
                            },

                            legend: {
                                align: 'right',
                                verticalAlign: 'top',
                                y: 100,
                                layout: 'vertical'
                            },

                            series: [{
                                name: '<g:message code="profile.hit.percentage"/>',
                                data: data,
                                pointPlacement: 'on',
                                showInLegend: false
                            }]

                        });
                    }
                }

             });



        });

        function changeContext(id){
            $("#tabs  a").removeClass("active");
            $(".standard-table").hide();
            $("#" + id).addClass("active");
            $("#" + id + "-tab").show();
        };
    </script>
</head>
<body>
<huxley:profile profile="${profile}" license="${session.license}"/>
</br>
<div id="chart"></div>
<br>
<h3><g:message code="profile.complementary.info"/></h3>
<hr />
</br>
<div class="profile-tabs" id="tabs"><a id="profile" href="javascript:changeContext('profile')"><g:message code="profile.general"/></a><a id="score" href="javascript:changeContext('score')"><g:message code="profile.score"/></a> <a id="problem" href="javascript:changeContext('problem')"><g:message code="profile.problem"/></a><a id="groups" href="javascript:changeContext('groups')"><g:message code="profile.groups"/></a></div>

    <table class="standard-table" id="profile-tab">
        <tbody>
            <tr><td><span class="profile-complementary-info" ><g:message code="profile.email"/>: </span>${profile.user.email}</td><td><span class="profile-complementary-info"><g:message code="profile.last.access"/>: </span> <g:formatDate format="hh:MM dd-MM-yyyy" date="${profile.user.lastLogin}"/></td></tr>
            <tr><td><span class="profile-complementary-info"><g:message code="profile.topcoder.position"/>: </span> ${profile.user.topCoderPosition}</td><td><span class="profile-complementary-info"><g:message code="profile.problem.tries"/>: </span>${profile.problemsTryed}</td></tr>
            <tr><td><span class="profile-complementary-info"><g:message code="profile.topcoder.score"/>: </span> <g:formatNumber number="${profile.user.topCoderScore}" maxFractionDigits="2"/> </td><td><span class="profile-complementary-info"><g:message code="profile.problem.hit"/>: </span> ${profile.problemsCorrect}</td></tr>
        </tbody>
    </table>

    <table class="standard-table" id="score-tab" style="display:none">
        <thead>
            <th class="profile-complementary-info" style="padding: 10px;"><g:message code="profile.title"/></th><th class="profile-complementary-info" style="text-align: center;"><g:message code="profile.user.score"/></th><th class="profile-complementary-info" style="text-align: center;"><g:message code="profile.questionnaire.score"/></th>
        </thead>
        <tbody>
        <g:each in="${questList}" var="quest">
            <g:if test="${session.license.isStudent()}">
            <tr><td>${quest.questionnaire.title}</td><td style="text-align: center;">${quest.score}</td><td style="text-align: center;">${quest.questionnaire.score}</td></tr>
            </g:if>
            <g:else>
                <tr><td><g:link action="show" controller="quest" params='[qId:"${quest.id}"]'>${quest.questionnaire.title}</g:link></td><td style="text-align: center;">${quest.score}</td><td style="text-align: center;">${quest.questionnaire.score}</td></tr>
            </g:else>
        </g:each>

        </tbody>
    </table>

<table class="standard-table" id="problem-tab" style="display:none">
    <thead>
    <th class="profile-complementary-info" style="padding: 10px;"><g:message code="profile.title"/></th><th class="profile-complementary-info" style="text-align: center;"><g:message code="profile.problem.status"/></th>
    </thead>
    <tbody>
    <g:each in="${probList}" var="prob">
        <g:if test="${session.license.isStudent()}">
            <tr><td>${prob?.problem?.name}</td>
        </g:if>
        <g:else>
            <tr><td><g:link params='[userId:"${profile.user.id}",problemId:"${prob.problem.id}"]' action="index" controller="submission">${prob?.problem?.name}</g:link></td>
        </g:else>

            <g:if test="${prob?.status == com.thehuxley.UserProblem.CORRECT}">
                <td><div class="problem-correct-icon" style="margin:0 auto;"></div></td>
            </g:if>
            <g:else>
                <td><div class="problem-wrong-icon" style="margin:0 auto;"></div></td>
            </g:else>


        </tr>
    </g:each>

    </tbody>
</table>

<table class="standard-table" id="groups-tab" style="display:none">
    <thead>
    <th class="profile-complementary-info" style="padding: 10px;"><g:message code="profile.group"/></th><th class="profile-complementary-info" style="text-align: center;"><g:message code="profile.topcoder.position"/></th>
    </thead>
    <tbody>
    <g:each in="${groupList}" var="group">
        <g:if test="${group[0]}">
            <tr><td>${group[0]?.name}</td><td style="text-align: center">${group[1]}</td>
        </g:if>

        </tr>
    </g:each>

    </tbody>
</table>



</body>
</html>