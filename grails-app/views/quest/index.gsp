<%--
  Created by IntelliJ IDEA.
  User: romero
  Date: 26/06/12
  Time: 12:59
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'huxley-quest.js')}"></script>

    <script type="text/javascript">
        <g:if test="${!session.license.isStudent()}">
        var groupId = 0;
        var totalOpen;
        var totalClosed;
        var questTitle = '';
        </g:if>
        $(function() {
            huxleyQuest.setValues(10);
            huxleyQuest.getQuestionnaires();
            $('#input-quest').keyup(function() {
                clearTimeout(questSearchInputTimeOut);
                questSearchInputTimeOut = setTimeout(function() {
                    questTitle = $("#input-quest").val();
                    huxleyQuest.getQuestionnaires();
                }, 1000);
            });
        });
        var questSearchInputTimeOut;
        function verify(){
            $(function() {

                if(totalClosed == '0'){
                    $("#closed-questionnaires").hide();
                }else{
                    //huxleyQuest.getClosedQuestionnaires(0);
                    $("#closed-questionnaires").show();
                }
                if(totalOpen == 0){
                    $("#open-questionnaires").hide();
                }else{
                    //huxleyQuest.getOpenQuestionnaires(0);
                    $("#open-questionnaires").show();
                }

                if((totalClosed == 0)&&(totalOpen == 0)){
                    $("#separator").hide();
                }else{
                    $("#separator").show();
                }
            });
        }

        huxleyQuest.getQuestionnaires = function(){
            groupId = $("#group-list").val();
            huxleyQuest.getClosedQuestionnaires(0);
            huxleyQuest.getOpenQuestionnaires(0);
            verify();
        }
        huxleyQuest.getClosedQuestionnaires = function(index){
            var offset = index * huxleyQuest.limit;

            $.ajax({
                url: huxley.root + 'quest/getClosedUserQuest',
                beforeSend: huxley.showLoading(),
                type: 'POST',
                <g:if test="${!session.license.isStudent()}">
                data: 'limit=' + huxleyQuest.limit + '&offset=' + offset + '&groupId=' + groupId + '&title=' + questTitle,
                </g:if>
                <g:else>
                data: 'limit=' + huxleyQuest.limit + '&offset=' + offset,
                </g:else>

                async: false,
                dataType: 'json',
                success: function(data) {
                    var toAppend = '';
                    $('#finished-questionnaires-list').empty();

                    $.each(data.questionnaireList, function(i, questionnaire) {
                        toAppend+=
                        <g:if test="${session.license.isStudent()}">
                        '<tr><td style="width:300px;"><a href="' + huxley.root + 'quest/show?qId=' + questionnaire.id + '">' +
                                questionnaire.title + '</a></td>' +

                                '<td style="text-align: center;">' + questionnaire.userScore + '</td>' +
                                </g:if>
                                <g:else>
                                '<tr><td style="width:300px;">';
                        if(questionnaire.invalid){
                            toAppend += '<img src="/huxley/images/icons/error.png" title="<g:message code='questionnaire.invalid'/>" style="width:16px; height:19px; border:0;" />';
                        }
                        toAppend+='<a href="' + huxley.root + 'quest/showStatistics/' + questionnaire.id + '">' +
                                questionnaire.title + '</a></td>' +

                                </g:else>
                                '<td style="text-align: center;">' + questionnaire.score + '</td></tr>';
                    });
                    if(index == 0){
                        huxley.generatePagination('closed-pagination',huxleyQuest.getClosedQuestionnaires,huxleyQuest.limit,data.count);
                        totalClosed = data.count;
                    }
                    $('#finished-questionnaires-list').append(toAppend);
                    huxley.hideLoading();
                }
            });
        };

        huxleyQuest.getOpenQuestionnaires = function(index){
            var offset = index * huxleyQuest.limit;

            $.ajax({
                url: huxley.root + 'quest/getOpenUserQuest',
                beforeSend: huxley.showLoading(),
                type: 'POST',
                <g:if test="${!session.license.isStudent()}">
                data: 'limit=' + huxleyQuest.limit + '&offset=' + offset + '&groupId=' + groupId + '&title=' + questTitle,
                </g:if>
                <g:else>
                data: 'limit=' + huxleyQuest.limit + '&offset=' + offset,
                </g:else>
                async: false,
                dataType: 'json',
                success: function(data) {
                    var toAppend = '';
                    $('#open-questionnaires-list').empty();

                    $.each(data.questionnaireList, function(i, questionnaire) {
                        toAppend+=
                                <g:if test="${session.license.isStudent()}">
                                '<tr><td style="width:300px;"><a href="' + huxley.root + 'quest/show?qId=' + questionnaire.id + '">' +
                                questionnaire.title + '</a></div>' +

                                '<td style="text-align: center;">' + questionnaire.userScore + '</td>' +
                                </g:if>
                                <g:else>
                                        '<tr><td style="width:300px;">';
                        if(questionnaire.invalid){
                            toAppend += '<img src="/huxley/images/icons/error.png" title="<g:message code='questionnaire.invalid'/>" style="width:16px; height:19px; border:0;" />';
                        }
                        toAppend+='<a href="' + huxley.root + 'quest/showStatistics/' + questionnaire.id + '">' +
                                        questionnaire.title + '</a></div>' +

                                        </g:else>
                                '<td style="text-align: center;">' + questionnaire.score + '</td>' +
                                '<td>' + questionnaire.startDate + '</td></tr>';
                    });
                    if(index == 0 ){
                        huxley.generatePagination('open-pagination',huxleyQuest.getOpenQuestionnaires,huxleyQuest.limit,data.count);
                        totalOpen = data.count;
                    }

                    $('#open-questionnaires-list').append(toAppend);
                    huxley.hideLoading();
                }
            });
        };

    </script>
</head>
<body>

    <g:if test="${session.license.isTeacher() || session.license.isAdminInst() || session.license.isAdmin() || session.license.isSystem()}">
        <div class="form-box">
            <h3><g:message code="verbosity.questionnaireList"/></h3>
            <g:link action="create" class="button" style="border: none; float: right;"><g:message code="verbosity.createQuestionnaire"/></g:link>
            <g:if test="${groups.size > 0}">
              <g:link action="coursePlan" class="button" style="border: none; float: right;"><g:message code="verbosity.import.questionnaire"/></g:link>
            </g:if>
            <div style="clear: left;"></div>
        </div>
        <hr class="form-line">
    </g:if>

       <huxley:questList/>
</body>
</html>
