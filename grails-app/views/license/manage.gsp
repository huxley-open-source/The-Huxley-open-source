<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'huxley-license.js')}"></script>
</head>
<body>

    <div class="box">
        <h3>
            <g:message code="verbosity.existing.licenses"/>
            <g:link controller="license" action="create" class="button"><g:message code="license.new"/></g:link>
        </h3>

    </div>
    <hr>
    <table class="standard-table">
        <tbody>
            <tr>
                <th><g:message code="entity.license.type"/></th>
                <th><g:message code="verbosity.quantity"/></th>
            </tr>
           <g:each status="i" in="${licenseTypeList}" var="licenseType">
               <tr class="${ (i % 2) == 0 ? 'even' : 'old'}">
                   <td><g:link controller="license" action="list" params="[t: licenseType[0].type.id]">${licenseType[0].type.name}</g:link></td>
                   <td>${licenseType[1]}</td>
               </tr>
           </g:each>
        </tbody>
    </table>
</body>
</html>