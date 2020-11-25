<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script type="text/javascript">
        $(function() {
            huxleyTopic.setChangeFunction(getTopicInfo);
        });
        function getTopicInfo(){
            $('#topic-info-table').slideUp(1000);
            $.ajax({
                url: huxley.root + 'problem/getTopicInfo',
                async: true,
                data: 'idList=' + huxleyTopic.selectedId,
                dataType: 'json',
                success: function(data) {
                    if(!data.msg){
                        $('#topic-info-list').empty()
                        var toAppend = '';
                        $.each(data.topics, function(i, topic) {
                            toAppend+='<tr>' +
                                    '<td style="text-align: center;">';
                            if(topic.name.length > 18){
                                toAppend+= topic.name.substring(0,15) + '...';
                            }else{
                                toAppend+= topic.name;
                            }
                            toAppend+='</td>'+
                                    '<td style="text-align: center;">' + topic.problemCount + '</td>'+
                                    '<td style="text-align: center;">' + topic.submissionCount + '</td>'+
                                    '<td style="text-align: center;">' + topic.submissionCorrectCount + '</td>'+
                                    '<td style="text-align: center;"><a href="javascript:void(0)" onclick="getProblemTopicInfo(' + topic.id + ')">${g.message(code:"verbosity.show.problem")}</a></td>'+
                                    '</tr>';
                        });
                        $('#topic-info-list').append(toAppend);
                        $('#topic-info-table').slideDown(1000);
                    }
                }
            });
        };
        function getProblemTopicInfo(id){
            $('#topic-problem-info-table').slideUp(1000);
            $.ajax({
                url: huxley.root + 'problem/getProblemInfoByTopic',
                async: true,
                data: 'id=' + id,
                dataType: 'json',
                success: function(data) {
                    if(!data.msg){
                        $('#topic-problem-info-list').empty()
                        var toAppend = '';
                        $.each(data.problems, function(i, problem) {
                            toAppend+='<tr>' +
                                    '<td style="text-align: center;">';
                            if(problem.name.length > 18){
                                toAppend+= problem.name.substring(0,15) + '...';
                            }else{
                                toAppend+= problem.name;
                            }
                            toAppend+='</td>'+
                                    '<td style="text-align: center;">' + problem.submissionCount + '</td>'+
                                    '<td style="text-align: center;">' + problem.submissionCorrectCount + '</td>'+
                                    '<td style="text-align: center;">' + problem.testCount + '</td>'+
                                    '<td style="text-align: center;">' + problem.solutionCount + '</td>'+
                                    '<td style="text-align: center;">' + problem.date + '</td>'+

                                    '</tr>';
                        });
                        $('#topic-problem-info-list').append(toAppend);
                        $('#topic-highlight').empty();
                        $('#topic-highlight').append(data.name);
                        $('#topic-problem-info-table').slideDown(1000);
                    }
                }
            });
        };

        $(function() {
            $('#topic-info-table').hide();
            $('#topic-info').click(function() {
                $('#topic-info-table').slideToggle(1000);
            });
            $('#topic-problem-info-table').hide();
            $('#topic-problem-info').click(function() {
                $('#topic-problem-info-table').slideToggle(1000);
            });
        });
        onload = function(){
            $('#topic-label-search').click();
        }
    </script>


</head>
<body>
<div class="box"><huxley:topicFilter /></div>
<hr><br>

<div class="box">
    <h3 id="topic-info" style="cursor: pointer;"><g:message code="verbosity.general.info"/></h3>
    <table class="standard-table" style="height: 15px;" id="topic-info-table">
        <thead>
        <th style="padding: 7px 7px 7px 10px;"><g:message code="verbosity.name"/></th>
        <th style="text-align: center;"><g:message code="verbosity.problem.number"/></th>
        <th style="text-align: center;"><g:message code="verbosity.submission.number"/></th>
        <th style="text-align: center;"><g:message code="verbosity.submission.correct.number"/></th>
        <th style="text-align: center;"></th>
        </thead>
        <tbody id="topic-info-list"></tbody>
    </table>
</div>
<hr><br>

<div class="box">
    <h3 id="topic-problem-info" style="cursor: pointer;"><g:message code="verbosity.topic.problem.list"/> <span id="topic-highlight"></span></h3>
    <table class="standard-table" style="height: 15px;" id="topic-problem-info-table">
        <thead>
        <th style="padding: 7px 7px 7px 10px;"><g:message code="verbosity.name"/></th>
        <th style="text-align: center;"><g:message code="verbosity.submission.number"/></th>
        <th style="text-align: center;"><g:message code="verbosity.submission.correct.number"/></th>
        <th style="text-align: center;"><g:message code="verbosity.submission.test.cases.number"/></th>
        <th style="text-align: center;"><g:message code="verbosity.submission.reference.solution.number"/></th>
        <th style="text-align: center;"><g:message code="verbosity.submission.date.created"/></th>
        <th style="text-align: center;"></th>
        </thead>
        <tbody id="topic-problem-info-list"></tbody>
    </table>

</div>

<div id="topic-charts">

</div>

</br>


</body>
</html>
