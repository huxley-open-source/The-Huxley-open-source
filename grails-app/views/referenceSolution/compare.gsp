<%@ page import="com.thehuxley.ReferenceSolution; com.thehuxley.util.HuxleyProperties" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'SyntaxHighlighter/shCore.js')}"></script>
    <g:if test='${solution.language.name.equals("C")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    </g:if>
    <g:if test='${solution.language.name.equals("Cpp")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushCpp.js')}"></script>
    </g:if>
    <g:if test='${solution.language.name.equals("Python")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushPython.js')}"></script>
    </g:if>
    <g:if test='${solution.language.name.equals("Octave")}'>
        <script src="${resource(dir:'js', file:'SyntaxHighlighter/shBrushOctave.js')}"></script>
    </g:if>
    <link href="${resource(dir:'css', file:'shCoreDefault.css')}" type="text/css" rel="stylesheet"  />
    <script type="text/javascript">
        SyntaxHighlighter.all();
    </script>
</head>
<body>
<div class="box" style="width: 950px;">
    <span style="font-size: 18px; font-weight: bold;">${solution.problem.name} </span>
    <br/>
    <span style="font-size: 16px; font-weight: bold;"><g:message code="reference.status" />:


        <g:if test='${solution.status == ReferenceSolution.STATUS_ACCEPTED}'>
            <span style="color:green; font-size:16px;"><g:message code="reference.accepted"/></span>
        </g:if>
        <g:if test='${solution.status == ReferenceSolution.STATUS_REJECTED}'>
            <span style="color:red; font-size:16px;"><g:message code="reference.rejected"/></span>
        </g:if>
        <g:if test='${solution.status == ReferenceSolution.STATUS_WAITING}'>
            <span style="font-size:16px;"><g:message code="reference.waiting"/></span>
        </g:if>

    </span>
    <br/>
    <span style="font-size: 16px; font-weight: bold;"><g:message code="entity.language" />: ${solution.language}</span>
    <br/>
    <span style="font-size: 12px; font-weight: bold;"><g:message code="reference.solution.user.suggest" />: ${solution.userSuggest.name} <g:message code = "reference.solution.in.date"/>: <g:formatDate format="dd/MM/yyyy HH:mm" date="${solution.submissionDate}"/></span>
    <br/>
    <g:if test='${solution.comment}'>
        <span style="font-size: 12px; font-weight: bold;"><g:message code="reference.comment" />: </span> <span style="font-size: 12px;">${solution.comment}</span>
    </g:if>
    <br/>
    <br/>
    <div>
    <g:if test='${actualCode}'>
        <div style="float:left; width:50%;">
            <span style="font-size: 12px; font-weight: bold;"><g:message code="reference.solution.actual" /></span>
            <g:if test='${solution.language.name.equals("C")}'>
                <pre class="brush: cpp; toolbar: false; ">
                    ${actualCode}
                </pre>
            </g:if>

            <g:if test='${solution.language.name.equals("Cpp")}'>
                <pre class="brush: cpp; toolbar: false;">
                    ${actualCode}
                </pre>
            </g:if>

            <g:if test='${solution.language.name.equals("Python")}'>
                <pre class="brush: py; toolbar: false;">
                    ${actualCode}
                </pre>
            </g:if>
            <g:if test='${solution.language.name.equals("Octave")}'>
                <pre class="brush: octave; toolbar: false;">
                    ${actualCode}
                </pre>
            </g:if>
        </div>
        </div>
    </g:if>
    <div>
        <div style="float:left; width:50%;">
            <span style="font-size: 12px; font-weight: bold;"><g:message code="reference.solution.suggested" /></span>
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
    </div>
    <div style="clear: both; overflow: hidden;"></div>
    <g:if test='${solution.status == ReferenceSolution.STATUS_REJECTED}'>
        <div id="problem-info" style="width: 500px; padding: 10px; border-radius: 14px; margin: 0;">
            <div>
                <div style=" height: 16px;"><span style="font-size: 12px;" ><g:message code="reference.solution.motive.to.reject" /></span></div>
            </br>
                <span style="font-family: courier; font-size: 14px;">${solution.reply}</span>

            </div>
        </div>
    </g:if>

    <g:if test='${session.license.isAdmin()}'>

        <g:form action="reject" method="post" enctype="multipart/form-data">
            <g:hiddenField name="id" value="${solution.id}" />
            <div id="problem-info" style="width: 500px; padding: 10px; border-radius: 14px; margin: 0;">
    <div>
      <div style=" height: 16px;"><span style="font-size: 12px;" id="comment-text"><g:message code="reference.solution.motive.to.reject.form" />:</span></div>
        </br>
            <textarea id="text" name="comments" rows="5" style="margin-top:5px; max-height: 300px; max-width: 500px;  min-width: 500px; min-height: 100px;"></textarea>
            <div id="text-size"></div>
            </div>
            <div >
                <div id = "file-submit">
                    <span id="submission-button"></span>
                </div>
                <h3><g:link controller="referenceSolution" action="reject" class="ui-rbutton" id = "${solution.id}" ><g:message code="reference.solution.reject" /></g:link>
                <g:link controller="referenceSolution" action="accept" class="ui-gbutton" id = "${solution.id}" ><g:message code="reference.solution.accept" /></g:link></h3>
                </br>
            </div>
        </g:form>
        </div>

    </g:if>

    </div>
</div>
</body>
</html>