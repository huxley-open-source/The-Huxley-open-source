<%@ page import="com.thehuxley.Profile" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
</head>
<body>
<huxley:profile profile="${profile}" license="${session.license}"/>
<div class="box">
    <table class="standard-table" >
        <tbody>
        <tr><td><span class="similarity-complementary-info" ><g:message code="entity.problem"/>: </span>${submission.problem}</td></tr>
        <tr><td><span class="similarity-complementary-info"><g:message code="submission.try"/>: </span> #${submission.tries}</td></tr>
        <tr><td><span class="similarity-complementary-info"><g:message code="similarity.status"/>: </span>
        <g:if test="${submission.plagiumStatus == com.thehuxley.Submission.PLAGIUM_STATUS_MATCHED}">
            <g:message code="similarity.matched"/>
        </g:if>
        <g:if test="${submission.plagiumStatus == com.thehuxley.Submission.PLAGIUM_STATUS_NOT_MATCHED}">
            <g:message code="similarity.not.matched"/>
        </g:if>
        <g:if test="${submission.plagiumStatus == com.thehuxley.Submission.PLAGIUM_STATUS_TEACHER_CLEAN}">
            <g:message code="similarity.teacher.clean"/>
        </g:if>
        <g:if test="${submission.plagiumStatus == com.thehuxley.Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM}">
            <g:message code="similarity.teacher.plagium"/>
        </g:if>
        <g:if test="${submission.plagiumStatus == com.thehuxley.Submission.PLAGIUM_STATUS_WAITING}">
            <g:message code="similarity.waiting"/>
        </g:if>


        </td></tr>
        </tbody>
    </table>
<hr />
</div>
<huxley:listBySubmission id="${submission.id}" />
</body>
</html>
