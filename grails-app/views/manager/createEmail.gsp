<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main" />
    <g:if test = "${count}">
        <script type="text/javascript">
            $(function() {
                $("#results").append('${count} ${g.message(code: "email.sended")}');
            });
        </script>
    </g:if>
</head>
<body>
<g:form action="sendEmail">
    <div class="form-box">
    <div>
        <h3 style="float: none;"><g:message code="email.subject"/></h3>
        <input type="text" name="subject" class="ui-input2">
    </div>
    <br />
    <div>
        <h3 style="float: none;"><g:message code="email.message" /></h3>
        <textarea name="message" style="width: 600px; height: 100px; resize: none; overflow-y: auto;" class="ui-input2"></textarea>

    </div>
    <br />
    <div>
        <h3 style="float: none;"><g:message code="email.for" /></h3>
        <input type="checkbox" name="master"><g:message code="email.master"/><input type="checkbox" name="student"><g:message code="email.student"/><input type="checkbox" name="admin"><g:message code="email.admin.inst"/>
        <input type="checkbox" name="anotherBox"><g:message code="email.another"/><input type="text" name="another" class="ui-input2">
    </div>
    <g:submitButton name="${g.message(code:'email.send')}" style="float:right;" class="ui-gbutton"/>
    <div id="results" style="text-align: center; width: 600px; color: #1bd482;"></div>
    <br />
    </div>

</g:form>
</body>
</html>