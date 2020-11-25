<!doctype html>
<html>
	<head>
		<title>Grails Runtime Exception</title>
		<meta name="layout" content="info">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'errors.css')}" type="text/css">
	</head>
	<body>
            <g:if test="${session && session.license && session.license.isAdmin()}">
                <g:renderException exception="${exception}" />
            </g:if>

            <b><g:message code="error.not.found"></g:message></b></br></br>
            <g:message code="error.not.found2"></g:message></br></br>


    <iframe style="background-color:#FFFFFF;width:700px;height:105px;" frameborder=0 marginwidth="0" marginheight="0" vspace="0" hspace="0" allowtransparency="true" scrolling="no" src="http://www.chucknorris.com.br/p.php"/>

	</body>
</html>