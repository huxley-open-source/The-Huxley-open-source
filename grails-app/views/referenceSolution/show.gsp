<%@ page import="com.thehuxley.Submission; com.thehuxley.ReferenceSolution" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'huxley-reference-solution.js')}"></script>
    <script src="${resource(dir:'js', file:'fileuploader.js')}"></script>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shCore.js')}"></script>
    <g:if test='${solution.language.name.equals("C")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    </g:if>
    <g:if test='${solution.language.name.equals("Cpp")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    </g:if>
    <g:if test='${solution.language.name.equals("Python3.2")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushPython.js')}"></script>
    </g:if>
    <g:if test='${solution.language.name.equals("Python")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushPython.js')}"></script>
    </g:if>
    <g:if test='${solution.language.name.equals("Octave")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushOctave.js')}"></script>
    </g:if>
    <link href="${resource(dir:'css', file:'shCoreDefault.css')}" type="text/css" rel="stylesheet"  />



    <script type="text/javascript">
        var subId;
        var interval;
        var typed = false;
        var comment = false;
        var showButton = false;
        var tryText = "${message(code: 'reference.solution.send')}";
        $(function() {
            $('#text').keyup(function() {
                if($('#text').val().length>9){
                    $('#text-size').empty();
                    comment = true;
                    canSend();
                    typed = false;
                }else if(typed == false && $('#text').val().length<=9){
                    $('#text-size').append('<font color="red"><span style="font-size: 10px; font-weight: bold; "><g:message code="reference.solution.too.short.comment" /></span></font>')
                    typed = true;
                    comment = false;
                }
            });
        });
        function canSend(){

            var commentText = $('#text').val();
            if(comment == true && solution == true && showButton == false){
                $('#problem-info').append('<div><span style="font-size: 12px; font-weight: bold;"><g:message code ="reference.solution.to.evaluate"/></span></div>');
                $('#problem-info').append('<g:hiddenField name="id" value="" id="id" />');
                $("#id").val(subId);
                $('#problem-info').append('<div style="float:right"><h3><g:submitButton name="create" class="ui-gbutton" value="${message(code: 'reference.solution.send')}"/></h3></div></br>');

                showButton = true;

            }
        }

        huxley.setProblemCorrect = function (id) {
            'use strict';
            var content = $('#' + id);
            content.removeClass();
            content.addClass('problem-correct-title');
            $("#submission-area").empty();
            $("#submission-area").append('<h3><h3><span style="font-size: 12px; font-weight: bold;"><g:message code ="reference.solution.correct"/></span><a class="problem-correct-icon" href="#"></a></h3>')
            $('#text').show();
            $('#comment-text').show();
            showCode();
        };

        huxley.setProblemWaiting = function (id) {
            'use strict';
            var content = $('#' + id);
            content.removeClass();
            content.addClass('problem-waiting-title');
            $("#submission-area").empty();
            $("#submission-area").append('<h3>avaliando... <a class="problem-waiting-icon" href="#"></a></h3>')
        };
        huxley.setProblemWrong = function (id) {
            'use strict';
            tryText = "${message(code: 'reference.solution.send.again')}";
            var content = $('#' + id);
            content.removeClass();
            content.addClass('problem-wrong-title');
            $("#submission-area").empty();
            $("#submission-area").append('<h3><span style="font-size: 12px; font-weight: bold;"><g:message code ="reference.solution.rejected.by.evaluation"/></span><a class="problem-wrong-icon" href="#"></a></h3>')
            createUploader();
        };

        $(function(){
            SyntaxHighlighter.all();
            createUploader();
        });
        function createUploader(){
            $('#submission-area').append('<h3 id="submission-button"><a class="ui-gbutton" id="submission"></a></h3>');
            var uploader = new qq.FileUploader({
                element: document.getElementById('submission'),
                action: huxley.root + 'submission/save',
                <g:if test='${solution.language.name.equals("C")}'>
                allowedExtensions:  ['c'],
                </g:if>
                <g:if test='${solution.language.name.equals("Cpp")}'>
                allowedExtensions:  ['cpp'],
                </g:if>
                <g:if test='${solution.language.name.equals("Python3.2")}'>
                allowedExtensions:  ['py'],
                </g:if>
                <g:if test='${solution.language.name.equals("Python")}'>
                allowedExtensions:  ['py'],
                </g:if>
                <g:if test='${solution.language.name.equals("Octave")}'>
                allowedExtensions:  ['m'],
                </g:if>
                sizeLimit: 1048576,
                params: {
                    pid: '${solution.problem.id}'
                },
                messages: {
                    typeError: "{file} não possui uma extensão válida. Apenas {extensions} são permitidas.",
                    sizeError: "{file} é muito grande, O tamanho máximo do arquivo deve ser {sizeLimit}.",
                    emptyError: "{file} está vazio, por favor selecione outro arquivo.",
                    onLeave: "O arquivo ainda está sendo enviado."
                },
                template: '<div class="qq-uploader">' +
                        '<div id="submission-area"><div style="float: left;" class="qq-upload-drop-area"><span style="width: 100px; display: block; text-align: center;">solte</span></div>' +
                        '<div class="qq-upload-button" style="overflow:visible !important;">' + tryText + '</div>' +
                        '<ul class="qq-upload-list" style="display: none;"></ul>' +
                        '</div></div>',
                onComplete : function (id, fileName, responseJSON) {
                    huxley.setProblemWaiting('submission-area');
                    subId = responseJSON.submission.id;
                    updateSubmissionStatus();
                    interval = setInterval(function(){updateSubmissionStatus(responseJSON.submission.id);}, 2000);
                }
            });
        }
        function updateSubmissionStatus() {
            console.log('updating');
            $.ajax({
                url: '${resource(dir:'/')}submission/getStatusSubmission',
                data: 'sid=' + subId,
                async: true,
                dataType: 'json',
                success: function(data) {
                    console.log(" status " + data.submission.status);
                    if (data.submission.status == '${EvaluationStatus.WAITING}') {
                        huxley.setProblemWaiting('submission-area');
                    } else if (data.submission.status == '${EvaluationStatus.CORRECT}') {
                        huxley.setProblemCorrect('submission-area');
                        clearInterval(interval);
                        solution = true;

                    } else  {
                        huxley.setProblemWrong('submission-area');
                        clearInterval(interval);

                    }

                }
            });
        }
        function showCode(){
            $.ajax({
                url: '${resource(dir:'/')}submission/downloadCodeSubmission',
                data: 'id=' + subId,
                async: true,
                dataType: 'json',
                success: function(data) {
                    $('#submitted').show();
                    $('#submitted-code').append(
                            <g:if test='${solution.language.name.equals("C")}'>
                            '<pre class="brush: cpp;  toolbar: false;">'+
                                    </g:if>
                                    <g:if test='${solution.language.name.equals("Cpp")}'>
                                    '<pre class="brush: cpp; toolbar: false;">'+
                                    </g:if>
                                    <g:if test='${solution.language.name.equals("Python3.2")}'>
                                    '<pre class="brush: py; toolbar: false;">'+
                                    </g:if>
                                    <g:if test='${solution.language.name.equals("Python")}'>
                                    '<pre class="brush: py; toolbar: false;">'+
                                    </g:if>
                                    <g:if test='${solution.language.name.equals("Octave")}'>
                                    '<pre class="brush: octave; toolbar: false;">'+
                                    </g:if>
                                    data.submission.submissionCode+
                                    '</pre>');
                    SyntaxHighlighter.highlight();
                }
            });

        }

    </script>
</head>
<body>
<div class="box" style="width: 950px;">
    <span style="font-size: 18px; font-weight: bold;">${solution.problem.name}</span>
    <br/>
    <span style="font-size: 16px; font-weight: bold;"><g:message code="entity.language" />: ${solution.language}</span>
    <br/>
    <span style="font-size: 12px; font-weight: bold;"><g:message code="reference.solution.user.suggest" />: ${solution.userSuggest.name} <g:message code = "reference.solution.in.date"/>: <g:formatDate format="dd/MM/yyyy HH:mm" date="${solution.submissionDate}"/></span>
    <br/>
    <br/>
    <div>
        <div style="float:left; width:50%;">
            <span style="font-size: 12px; font-weight: bold;"><g:message code="reference.solution.actual" /></span>
            <g:if test='${solution.language.name.equals("C")}'>
                <pre class="brush: cpp; toolbar: false; ">
                    ${code}
                </pre>
            </g:if>

            <g:if test='${solution.language.name.equals("Cpp")}'>
                <pre class="brush: cpp; toolbar: false;">
                    ${code}
                </pre>
            </g:if>

            <g:if test='${solution.language.name.equals("Python3.2")}'>
                <pre class="brush: py; toolbar: false;">
                    ${code}
                </pre>
            </g:if>

            <g:if test='${solution.language.name.equals("Python")}'>
                <pre class="brush: py; toolbar: false;">
                    ${code}
                </pre>
            </g:if>

            <g:if test='${solution.language.name.equals("Octave")}'>
                <pre class="brush: octave; toolbar: false;">
                    ${code}
                </pre>
            </g:if>
        </div>
        <div style="float:left; width:50%; display: none;" id="submitted">
            <span style="font-size: 12px; font-weight: bold;"><g:message code="reference.solution.suggested" /></span>

            <div id="submitted-code">

            </div>

        </div>
    </div>
    <div style="clear: both; overflow: hidden;"></div>
    <div style="margin-top: 30px;">
        <span style="font-size: 12px; font-weight: bold;"><g:message code="reference.solution.suggest" /></span>
        <br/>
        <span style="font-size: 10px; "><g:message code="reference.solution.how.to" /></span>
        <div id="submission-area" style="height:80px;">
        </div>
    </div>
    <g:form action="save" method="post" enctype="multipart/form-data">
        <div id="problem-info" style="width: 500px; padding: 10px; border-radius: 14px; margin: 0;">
        <div>
            <div style=" height: 16px;"><span style="font-size: 12px; display:none;" id="comment-text"><g:message code="reference.solution.motive" /></span>    <span style="float: right;"><img align="Absbottom" id="problem-status-icon" style="border: 0 none;" src="" /></span></div>
        </br>
        <textarea id="text" name="comments" rows="5" style="margin-top:5px; max-height: 300px; max-width: 500px;  min-width: 500px; min-height: 100px; display:none;"></textarea>
        <div id="text-size"></div>
        </div>
    </g:form>
    </div>
    </div>

</div>
</body>
</html>