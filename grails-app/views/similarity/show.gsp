<%@ page import="com.thehuxley.Profile" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shCore.js')}"></script>
    <g:if test='${language.equals("C")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    </g:if>
    <g:if test='${language.equals("Cpp")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    </g:if>
    <g:if test='${language.equals("Python")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushPython.js')}"></script>
    </g:if>
    <g:if test='${language.equals("Octave")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushOctave.js')}"></script>
    </g:if>
    <link href="${resource(dir:'css', file:'shCoreDefault.css')}" type="text/css" rel="stylesheet"  />
    <script type="text/javascript">
        SyntaxHighlighter.all();
    </script>
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
        $.ajax({
            url: '${resource(dir:"/")}similarity/markAsPlag',
            data: { 'id': ${rId}, 'qId': ${qId}},
            dataType: 'json'
        });
    }
    function penalize2(id){
        penalty = $('#score-penalty').val();
        $.ajax({
            url: '${resource(dir:"/")}similarity/questPenalty',
            data: { 'qUserId': ${qId}, 'qProbId': id, 'penalty': $('#score-penalty').val()},
            dataType: 'json',
            success: function(data) {
                if(data.status == 'ok'){
                    huxley.notify('<g:message code="verbosity.saved"/>')
                    huxley.closeModal();
                }else{
                    huxley.closeModal();
                    huxley.error('<g:message code="verbosity.error.on.save"/>')
                }

            }
        });
    }
</script>
</head>
<body>
<div class="box" style="border-bottom: #FBFBFB 3px solid; width: 950px;">
    <div style="float:right;">
        <g:if test="${qId}">
        <a id="info-link-${qpId}" href="javascript:void(0)" onclick="penalize('${qpId}')" class="ui-rbutton"><g:message code="submission.mark.as.plag" /></a>
        </g:if>
        <g:else>
            <g:link action="markAsPlag" class="ui-rbutton" params="${[id:rId]}"><g:message code="submission.mark.as.plag" /></g:link>
        </g:else>

        <g:link action="markNotPlag" class="ui-gbutton"  id="${rId}"><g:message code="submission.mark.as.not.plag" /></g:link>

        <g:if test="${qId}">
            <g:link action="listByQuestionnaire" class="ui-bbutton" params="${[qId:qId]}"><g:message code="variable.return" /></g:link>
        </g:if>
        <g:else>
            <g:link action="list" class="ui-bbutton" id="${rId}"><g:message code="variable.return" /></g:link>
        </g:else>
    </div>
    </br>

</div>
<div class="box" style="width: 950px;">
    <div style="float: right; width: 50%" >
        <huxley:userBox profile="${suspect1}"></huxley:userBox>
        <br/>
        <hr />
        <div class="code">
            <g:if test='${language.equals("C")}'>
                <pre class="brush: cpp; toolbar: false; ">
                    ${code}
                </pre>
            </g:if>

            <g:if test='${language.equals("Cpp")}'>
                <pre class="brush: cpp; toolbar: false;">
                    ${code}
                </pre>
            </g:if>

            <g:if test='${language.equals("Python")}'>
                <pre class="brush: py; toolbar: false;">
                    ${code}
                </pre>
            </g:if>

            <g:if test='${language.equals("Octave")}'>
                <pre class="brush: octave; toolbar: false;">
                    ${code}
                </pre>
            </g:if>
        </div>
    </div>
    <div style="float: left; width: 50%" >
        <huxley:userBox profile="${suspect2}"></huxley:userBox>
        <br/>
        <hr />
        <div class="code">
            <g:if test='${language.equals("C")}'>
                <pre class="brush: cpp; toolbar: false; ">
                    ${code2}
                </pre>
            </g:if>

            <g:if test='${language.equals("Cpp")}'>
                <pre class="brush: cpp; toolbar: false;">
                    ${code2}
                </pre>
            </g:if>
            <g:if test='${language.equals("Python")}'>
                <pre class="brush: py; toolbar: false;">
                    ${code2}
                </pre>
            </g:if>
            <g:if test='${language.equals("Octave")}'>
                <pre class="brush: octave; toolbar: false;">
                    ${code2}
                </pre>
            </g:if>
        </div>
    </div>
    <div style="clear: both; overflow: hidden;"></div>
</div>
<div id="penalty-box" class="modal"></div>
</body>
</html>
