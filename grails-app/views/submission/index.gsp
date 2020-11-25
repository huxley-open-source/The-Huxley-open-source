<%--
  Created by IntelliJ IDEA.
  User: romero
  Date: 26/06/12
  Time: 12:59
  To change this template use File | Settings | File Templates.
--%>

<html>
<head>
    <meta name="layout" content="main"/>
    <jawr:script src="/i18n/messages.js"/>
    <script src="${resource(dir:'js', file:'huxley-pagination-wi.js')}"></script>
<script src="<g:resource dir="js" file="underscore-min.js"/>" type="text/javascript"></script>
<script src="<g:resource dir="js" file="mustache.min.js"/>" type="text/javascript"></script>

<style>
    .linenum a {color: #909090;}

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
        text-decoration: none;
    }
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
    <script type="text/javascript">
        var offset = 0;
        function getSubmission(index){
            if(index == 0){
                offset = 0;
            }else{
                offset = offset + index;
            }

            var data =  'offset=' + offset + '&max='+huxleySubmission.limit + "&endDate=" + huxleySubmission.endDate + "&beginDate=" + huxleySubmission.startDate + '&order=' + huxleySubmission.order + '&sort=' + huxleySubmission.currentAtributte;
            <g:if test="${user}">
            data += '&userId=' + "${user.id}";
            </g:if>
            <g:if test="${!session.license.isStudent() && !user}">
            data += '&userName=' + huxleySubmission.userName + '&group=' + $("#group-list").val() + '&listBy=group' + '&evaluation=' + $("#evaluation-list").val();
            </g:if>
            <g:if test="${problem}">
                data += '&problemId=' + ${problem.id};
            </g:if>
            <g:if test="${!problem}">
                data += '&problemName=' +huxleySubmission.problemName;
            </g:if>

            $.ajax({
                url: huxley.root + 'submission/search',
                async: true,
                data: data,
                type: 'POST',
                dataType: 'json',
                beforeSend: function(){
                    huxley.showLoading();
                    huxleyPaginationWI.loading();
                    if(offset == 0){
                        $('#submission-list').empty();
                    }
                } ,
                success: function(data) {
                    var toAppend = '';
                    if(data.submissions.length == 0){
                        huxleyPaginationWI.stopPaginate();
                    }else{
                        huxleyPaginationWI.paginate();
                    }
                    $.each(data.submissions, function(i, submission) {
                        var color = '';
                        color = (i%2==0? 'style="background-color:#f4f4f4;"'  : '');
                        var infoColor = '';
                        infoColor = (i%2==0? 'style="background-color:#f4f4f4;display:none;"'  : 'style="display:none;"');
                        toAppend+='<tr ' + color +'>' +
                                <g:if test="${!session.license.isStudent() && !user }">
                                '<td style="text-align: center;"><a href="' + huxley.root + 'profile/show?user='+ submission.userId +'">' + submission.userName + '</a></td>'+
                                </g:if>
                                '<td style="text-align: center;"><a href="' + huxley.root + 'problem/show/' + submission.problemId + '">';
                                if(submission.problemName.length > 18){
                                    toAppend+= submission.problemName.substring(0,15) + '...';
                                }else{
                                    toAppend+= submission.problemName;
                                }
                                toAppend+='</a></td>'+
                                '<td style="text-align: center;">' + submission.submissionDate + '</td>';
                                if(submission.evaluation === huxley.constants.EVALUATION_CORRECT) {

                                    toAppend+='<td style="text-align: center;" id="evaluation-' + submission.id + '">'+huxley.toMsg(submission.evaluation)+'</td>';
                                } else {
                                    toAppend+='<td style="text-align: center;" id="evaluation-' + submission.id + '"><a href="javascript:tip(' + submission.id + ')">'+ huxley.toMsg(submission.evaluation) +' (?)</a></td>';
                                }

                                toAppend+='<td style="text-align: center;"><a class="submission-action-button"><span class="submission-action-button-arrow"></span></a><div class="submission-actions">' +
                                        '<ul>' +
                                        '<li><a href="javascript:void(0);" class="menu-item forum-send-message" onclick="huxleySubmission.setSubmission(' + submission.id + ')">${message(code:'verbosity.sendMessage')}</a></li>' +
                                        '<li><a href="' + huxley.root + 'submission/downloadSubmission?bid=' + submission.id + '" class="menu-item">${message(code:'verbosity.download.code')}</a></li>';
                                        <g:if test="${!session.license.isStudent()}">
                                        toAppend+='<li><a href="' + huxley.root + 'submission/showDiff/' + submission.id + '" class="menu-item">${message(code:'verbosity.diff')}</a></li>' +
                                                '<li><a href="javascript:void(0)" onClick="reEvaluate(' + submission.id + ')" class="menu-item">${message(code:'verbosity.reevaluate')}</a></li>';
                                        </g:if>
                                        toAppend+='</ul>' +
                                        '</div></td><td style="text-align: center;"><a href="javascript:showInfo(' + submission.id + ')" id="details-' + submission.id + '")><g:message code="submission.more.info"/></a></td></tr>';
                        toAppend+='<tr ' + infoColor +' id="info-' + submission.id + '" ><td style="text-align: center;"><g:message code="submission.tries"/> : ' + submission.tries + '</td>'+
                                '<td style="text-align: center;"><g:message code="submission.execute.time"/> : ' + submission.time + '</td>'+
                                '<td style="text-align: center;"><g:message code="submission.language"/> : ' + submission.language + '</td>'+
                                '<td style="text-align: center;"> </td>'+
                                <g:if test="${!session.license.isStudent() && !user}">
                                '<td></td>'+
                                </g:if>
                                '<td></td><td></td></tr>';
                        if(submission.evaluation == huxley.constants.EVALUATION_WAITING ){
                            callGetStatus(submission.id);
                        }
                    });
                    $('#submission-list').append(toAppend);
                    huxleySubmission.createActionMenu();
                    huxley.hideLoading();
                    huxleyPaginationWI.loaded();
                }
            });
        };
        var toReevaluate = [];
        var reEvaluting = 0;
        function reEvaluate(id){
            $.ajax({
                url: huxley.root + 'submission/reEvaluate',
                async: true,
                data: 'id=' + id ,
                success: function(data) {
                    if(data == "ok"){
                        $("#evaluation-" + id).empty();
                        $("#evaluation-" + id).append(huxley.toMsg( huxley.constants.EVALUATION_WAITING));
                        callGetStatus(id)
                    }
                }
            });
        }
        function callGetStatus(id){
            if(toReevaluate.indexOf(id) == -1){
                toReevaluate.push(id);
            }
            if(reEvaluting == 0){
                reEvaluting = 1;
                getStatus();
            }

        }
        function getStatus(){
            if(toReevaluate.length>0){
            $.ajax({
                url: huxley.root + 'submission/getStatus',
                async: true ,
                type: 'POST',
                dataType: 'json',
                data: {id: JSON.stringify(toReevaluate)} ,
                success: function(data) {
                    $.each(data.submissions, function(i, submission) {
                        if(!(submission.evaluation === huxley.constants.EVALUATION_WAITING)){
                            $("#evaluation-" + submission.id).empty();
                            if(submission.evaluation === huxley.constants.EVALUATION_CORRECT) {
                                $("#evaluation-" + submission.id).append(huxley.toMsg(submission.evaluation));
                            } else {
                                $("#evaluation-" + submission.id).append('<a href="javascript:tip(' + submission.id + ')">'+ huxley.toMsg(submission.evaluation)+' (?)</a>');
                            }
                            huxley.removeFromArray(submission.id,toReevaluate);
                        }

                    });

                }
            });
                setTimeout(function(){getStatus();}, 6000);
            }else{
                reEvaluting = 0;
            }

        }
        function showInfo(index){
            $('#details-' + index).empty();
            $('#info-' + index).toggle();
            if($('#info-' + index).is(':visible')){
                $('#details-' + index).append("<g:message code="submission.hide.info"/>");
            }else{
                $('#details-' + index).append("<g:message code="submission.more.info"/>");
            }
        }

        $(function() {
            huxleySubmission.setValues(10);
            huxleySubmission.setSort('s.submissionDate','date');
            huxleySubmission.setChangeFunction(getSubmission,0);
            huxleyPaginationWI.createPagination('submission-pagination',getSubmission,10);
            getSubmission(0);
            <g:if test="${!problem}">
            $('#input-problem').keyup(function() {
                clearTimeout(submissionSearchInputTimeOut);
                submissionSearchInputTimeOut = setTimeout(function() {
                    huxleySubmission.setProblemName($("#input-problem").val());
                }, 1000);
            });
            </g:if>
            <g:if test="${!user}">
            $('#input-user').keyup(function() {
                clearTimeout(submissionSearchInputTimeOut);
                submissionSearchInputTimeOut = setTimeout(function() {
                    huxleySubmission.setUserName($("#input-user").val());
                }, 1000);
            });
            </g:if>
        });
        var submissionSearchInputTimeOut;


        $(function() {
            $( "#from" ).datepicker({
                changeYear: true,
                numberOfMonths: 1,
                dateFormat: 'dd/mm/yy',
                onSelect: function( selectedDate ) {
                    huxleySubmission.setStartDate(selectedDate);
                }
            });
            $( "#to" ).datepicker({
                changeYear: true,
                numberOfMonths: 1,
                dateFormat: 'dd/mm/yy',
                onSelect: function (selectedDate) {
                    huxleySubmission.setEndDate(selectedDate);
                }
            });
        });

    </script>
</head>
<body>
<huxley:submissionList user="${user}" problem="${problem}"/>
<div id="forum-submission" class="modal">
    <h3><g:message code="verbosity.sendMessage"/></h3>
    <hr>
    <div class="box-content">
        <g:textArea id="forum-message" name="forum-message" rows="15" cols="70"></g:textArea>
    </div>

    <g:hiddenField id="submission-id" name="submission-id" />
    <div class="box-content buttons-bar">
        <a id="forum-submission-send" class="button" href="javascript:void(0);"><g:message code="verbosity.send"/></a>
        <a id="forum-submission-cancel" class="button" href="javascript:void(0);"><g:message code="verbosity.cancel"/></a>
    </div>
</div>
<div id="modal-tip"></div>
</body>
</html>