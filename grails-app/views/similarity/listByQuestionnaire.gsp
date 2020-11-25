<%@ page import="com.thehuxley.Profile" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shCore.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushPython.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushOctave.js')}"></script>
    <link href="${resource(dir:'css', file:'shCoreDefault.css')}" type="text/css" rel="stylesheet"  />
    <script type="text/javascript">
        var questUserSuspectIdList = [];
        var questUserSuspectNameList = [];
        var questUserSuspectIndex = [];
        var penalty = 0;
        function enterNumber(){
            var e = document.getElementById('score-penalty');

            if (!/^[0-9]+$/.test(e.value))
            {
                e.value = e.value.substring(0,e.value.length-1);
            }
        }
        function updateUserScore(){
            $.ajax({
                url: '${resource(dir:"/")}quest/getQuestionnaireShiroUser',
                data: { 'id':${questUser.id}},
                dataType: 'json',
                success: function(data) {
                    $('#quest-user-score').empty()
                    $('#quest-user-score').append(data.quest.score)
                }
            });
        }
        function penalize(id){
            penalty = 0;
            var toAppend = '<div class="box">' +
                    '<h3 style="color: red"><g:message code="verbosity.penalize"/></h3><br>' +
                    '<span style="font-size: 12px;"><g:message code="verbosity.how.to.penalize"/></span>' +
                    '<br><br><br>' +
                    '<g:message code="verbosity.score.penalty"/>: <input type="text" id="score-penalty" value="0" onkeyup="enterNumber()"><br>' +
                    '<div style="float:right;"><a class="button" href="javascript:void(0);" onclick="penalize2(' + id + ')"><g:message code="verbosity.send"/></a>'+
                    '<a class="button" href="javascript:void(0);" onclick="huxley.closeModal()"><g:message code="verbosity.cancel"/></a></div>'+
                    '</div>';
            $("#penalty-box").empty();
            $("#penalty-box").append(toAppend);

            huxley.openModal('penalty-box');

        }
        function penalize2(id){
            penalty = $('#score-penalty').val();
            $.ajax({
                url: '${resource(dir:"/")}similarity/questPenalty',
                data: { 'qUserId': ${questUser.id}, 'qProbId': id, 'penalty': $('#score-penalty').val()},
                dataType: 'json',
                success: function(data) {
                    if(data.status == 'ok'){
                        updateUserScore();
                        $("#info-link-" + id).click();
                        $("#info" + id).empty();
                        $("#info-link-" + id).click();
                        var index = questUserSuspectIndex.indexOf(id.toString());
                        if(questUserSuspectIdList[index][0].length != 0){
                            var toAppend = '';
                            toAppend +='<g:message code="verbosity.penalize.others"/>'+
                                    '<div id="result" style="width: 500px;margin: 10px 0 10px 0">' +
                                    '<table class="standard-table">' +
                                    '<tbody>';
                            if(id != -1){
                                $.each(questUserSuspectIdList[index],function(i,suspect){
                                    toAppend += '<tr><td style="padding-left: 8px;">' + questUserSuspectNameList[index][i] + '</td><td style="width: 16px; vertical-align:middle; height:16px; display:table-cell; padding-right: 8px;"><a id="quest-user-' + suspect + '" href="javascript:void(0)" onclick="toggleQuest(' + suspect + ')" style="display: block; width: 16px; height: 16px"><img src="/huxley/images/add.png"></a></td></tr>';

                                });
                            }

                            toAppend += '</tbody></table>' +
                                    '</div>' +
                                    '</div>' +
                                    '<div style="float:right;"><a class="button" href="javascript:void(0);" onclick="penalize3(' + id + ')"><g:message code="verbosity.send"/></a>'+
                                    '<a class="button" href="javascript:void(0);" onclick="huxley.closeModal()"><g:message code="verbosity.cancel"/></a></div>'+
                                    '</div>';
                            $("#penalty-box").empty();
                            $("#penalty-box").append(toAppend);
                        }else{
                            huxley.notify('<g:message code="verbosity.saved"/>')
                            huxley.closeModal();
                        }
                    }else{
                        huxley.closeModal();
                        huxley.error('<g:message code="verbosity.error.on.save"/>')
                    }

                }
            });
        }
        function penalize3(id){
            $.ajax({
                url: '${resource(dir:"/")}similarity/questPenalty',
                data: { 'qUserIdList': JSON.stringify(addedQuests), 'qProbId': id, 'penalty': penalty},
                dataType: 'json',
                success: function(data) {
                    huxley.closeModal();
                    if(data.status == 'ok'){
                        huxley.notify('<g:message code="verbosity.saved"/>')
                    }else{
                        huxley.error('<g:message code="verbosity.error.on.save"/>');
                        penalty = 0;
                    }
                }
            });
        }
        function removeItem(removeItem, array) {
            return $.grep(array, function(value) {
                return value != removeItem;
            });
        }
        function removePenalty(id,pId){
            if(confirm('<g:message code="verbosity.are.u.sure"/>')){
                $.ajax({
                    url: '${resource(dir:"/")}similarity/removeQuestPenalty',
                    data: { 'qId': pId},
                    dataType: 'json',
                    success: function(data) {
                        if(data.status == 'ok'){
                            updateUserScore();
                            $("#info-link-" + id).click();
                            $("#info" + id).empty();
                            $("#info-link-" + id).click();
                            huxley.openModal('penalty-box');
                            var index = questUserSuspectIndex.indexOf(id.toString());
                            if(questUserSuspectIdList[index][0].length != 0){
                                var toAppend = '';
                                toAppend +='<g:message code="verbosity.penalize.others"/>'+
                                        '<div id="result" style="width: 500px;margin: 10px 0 10px 0">' +
                                        '<table class="standard-table">' +
                                        '<tbody>';
                                if(id != -1){
                                    $.each(questUserSuspectIdList[index],function(i,suspect){
                                        toAppend += '<tr><td style="padding-left: 8px;">' + questUserSuspectNameList[index][i] + '</td><td style="width: 16px; vertical-align:middle; height:16px; display:table-cell; padding-right: 8px;"><a id="quest-user-' + suspect + '" href="javascript:void(0)" onclick="toggleQuest(' + suspect + ')" style="display: block; width: 16px; height: 16px"><img src="/huxley/images/add.png"></a></td></tr>';

                                    });
                                }

                                toAppend += '</tbody></table>' +
                                        '</div>' +
                                        '</div>' +
                                        '<div style="float:right;"><a class="button" href="javascript:void(0);" onclick="removePenalty2(' + id + ')"><g:message code="verbosity.send"/></a>'+
                                        '<a class="button" href="javascript:void(0);" onclick="huxley.closeModal()"><g:message code="verbosity.cancel"/></a></div>'+
                                        '</div>';
                                $("#penalty-box").empty();
                                $("#penalty-box").append(toAppend);
                            }else{
                                huxley.notify('<g:message code="verbosity.saved"/>')
                                huxley.closeModal();
                            }
                        }else{
                            huxley.closeModal();
                            huxley.error('<g:message code="verbosity.error.on.save"/>')
                        }
                    }
                });
            }



        }
        function removePenalty2(id){
            $.ajax({
                url: '${resource(dir:"/")}similarity/removeQuestPenalty',
                data: { 'qUserIdList': JSON.stringify(addedQuests), 'qProbId': id},
                dataType: 'json',
                success: function(data) {
                    huxley.closeModal();
                    if(data.status == 'ok'){
                        huxley.notify('<g:message code="verbosity.saved"/>')
                    }else{
                        huxley.error('<g:message code="verbosity.error.on.save"/>');
                    }
                }
            });
        }
        function markAsNotPlag(id){
            $.ajax({
                url: '${resource(dir:"/")}similarity/questMarkAsNotPlag',
                data: { 'id': id, 'qId': ${questUser.id}},
                dataType: 'json',
                success: function(data) {
                    huxley.closeModal();
                    if(data.status === 'ok'){
                        huxley.notify('<g:message code="verbosity.saved"/>')
                        $('#' + id).empty().append('<g:message code="similarity.teacher.clean"/>')
                    }else{
                        huxley.error('<g:message code="verbosity.error.on.save"/>');
                    }
                }
            });
        }
        function markAsPlag(id){
            $.ajax({
                url: '${resource(dir:"/")}similarity/questMarkAsPlag',
                data: { 'id': id, 'qId': ${questUser.id}},
                dataType: 'json',
                success: function(data) {
                    huxley.closeModal();
                    if(data.status === 'ok'){
                        huxley.notify('<g:message code="verbosity.saved"/>')
                        $('#' + id).empty().append('<g:message code="similarity.teacher.plagium"/>')
                    }else{
                        huxley.error('<g:message code="verbosity.error.on.save"/>');
                    }
                }
            });
        }
        var addedQuests = [];
        function toggleQuest(id) {

            var image = $('#quest-user-' + id).children(0);

            if ($.inArray(id, addedQuests) >= 0) {
                addedQuests = removeItem(id, addedQuests);
                image.attr('src', '${resource(dir: "/images")}/add.png');
            } else {
                addedQuests.push(id);
                image.attr('src', '${resource(dir: "/images")}/remove.png');
            }
        };
        function getInfo(id,status){
            if($("#info" + id).text().length == 0){
            $.ajax({
                url: huxley.root + 'similarity/listByQuestProblem',
                async: true,
                data: 'id=' + id + '&qUserId=' + ${questUser.id} + '&status=' + status,
                dataType: 'json',
                success: function(data) {
                    var suspect = data.plag;
                    var toAppend = '';
                    toAppend += '<table class="standard-table" >'+
                            '<tbody>'+
                            '<tr><td><span class="similarity-complementary-info" ><g:message code="verbosit.status"/>: </span> <span id="' + suspect.subId + '">';
                    if(data.pStatus == ${com.thehuxley.Submission.PLAGIUM_STATUS_MATCHED}){
                        toAppend += '<g:message code="similarity.matched"/>';
                    }else if(data.pStatus == ${com.thehuxley.Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM}){
                        toAppend += '<g:message code="similarity.teacher.plagium"/>';
                    }
                            toAppend += '</span></td></tr>'+
                            '<tr><td><span class="similarity-complementary-info"><g:message code="verbosit.score"/>: </span>' + data.score + '</td></tr>'+
                            '<tr><td><span class="similarity-complementary-info"><g:message code="verbosit.penalty"/>: </span>';
                    if(data.penalty != 'undefined'){
                        toAppend += data.penalty.penalty + '<a href="javascript:void(0)" onclick="removePenalty(' + id + ',' + data.penalty.id + ')">(<g:message code="verbosity.remove.penalty"/>)</a>';
                    }else{
                        toAppend += '<button style="color:red" href="javascript:void(0)" onclick="penalize(' + id + ')"><g:message code="verbosity.add.penalty"/></a>';
                    }

                    toAppend+= '</td></tr>'+
                    '</td></tr>'+
                            '</tbody>'+
                    '</table>';
                    var indexList = []
                    var nameList = []
                    questUserSuspectIndex.push(id);
                    var indexId = questUserSuspectIndex.indexOf(id);
                        if((suspect.questUserId != 'undefined') && (indexList.indexOf(suspect.questUserId) == -1)){
                            indexList.push(suspect.questUserId);
                            nameList.push(suspect.questUserName);
                        }
                        toAppend += '<div style="float: right; width: 50%;">' + suspect.user1 +
                                '<pre class="brush: ' + suspect.language + '; toolbar: false; ">' +
                                suspect.code1+
                                '</pre></div>' +
                            '<div style="float: right; width: 50%;">' +  suspect.user2 +
                                '<pre class="brush: ' + suspect.language + '; toolbar: false; ">' +
                                suspect.code2 +
                                '</pre></div>' +
                                '<div style="clear:both;"></div><hr/>' +
                                '<div style="text-align: right;"><a href="javascript:markAsPlag(' + suspect.subId + ')" class="ui-rbutton">Marcar como similar</a>' +
                    '<a href="javascript:markAsNotPlag(' +suspect.subId + ')" class="ui-gbutton">Descartar Similaridade</a>' +
                                '</div>';
                    ;

                    questUserSuspectIdList[indexId] = [];
                    questUserSuspectNameList[indexId] = [];
                    questUserSuspectIdList[indexId].push(indexList);
                    questUserSuspectNameList[indexId].push(nameList);
                    $("#info" + id).append(toAppend);
                    SyntaxHighlighter.highlight();
                    $("#info" + id).toggle();
                }
            });
            }else{
                $("#info" + id).toggle();
            }

        }
    </script>
</head>
<body>
<huxley:profile profile="${profile}" license="${session.license}"/>
<div class="box">
    <table class="standard-table" >
        <tbody>
        <tr><td><span class="similarity-complementary-info" ><g:message code="entity.questionnaire"/>: </span>${questUser.questionnaire.title}</td></tr>
        <tr><td><span class="similarity-complementary-info"><g:message code="verbosit.student.score"/>: </span><span id="quest-user-score">${questUser.score}</span</td></tr>
        </td></tr>
        </tbody>
    </table>
</div>
<hr />

<g:each in="${plagiumStatus.keySet()}" var="questProblem" status="i">
<div>
    <h3 class="similarity-problem-title">
        ${questProblem.problem.name}
        <a id="info-link-${questProblem.id}" onclick="getInfo('${questProblem.id}','${plagiumStatus.get(questProblem)}')"><g:message code="verbosity.more.details"/></a>
    </h3>
    <div id="info${questProblem.id}" class="plag-user-box" style="display:none"></div>
    <hr />
</div>
</g:each>
<div id="penalty-box" class="modal"></div>
</body>
</html>
