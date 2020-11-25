<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'huxley-group.js')}"></script>
    <script type="text/javascript">
    var returnMsg = '<g:message code="verbosity.are.u.sure"/>';
    $(function() {
        huxleyGroup.setValues(10);
        huxley.generatePagination('group-pagination',huxleyGroup.getGroup,10,${total});
        huxleyGroup.setChangeFunction(huxleyGroup.getGroup,0);
        $('#input-problem').keyup(function() {
            clearTimeout(groupSearchInputTimeOut);
            groupSearchInputTimeOut = setTimeout(function() {
                huxleyGroup.setName($("#input-problem").val());
            }, 1000);
        });
    });
    var groupSearchInputTimeOut;


</script>
</head>
<body>
<div class="box"><!-- Search box -->
    <h3>Lista de grupos <g:link action="create" class="ui-gbutton">Novo grupo</g:link></h3>
    <g:form action="index">
        <input type="text" name="name" placeholder="Digite o nome do grupo..." style="width: 62%;" class="ui-input2" id="input-problem"  autocomplete="off"/>
    </g:form>
    <span class="th-right"><small><g:message code="license.availabe"/> ${licenseTotal} <g:message code="license.availabe2"/></small></span>
</div>
<hr /><br />
<table class="standard-table">
    <thead>
    <th style="padding: 15px 15px;">Nome</th>
    <th style="padding: 15px 15px;">Ações</th>
    </thead>
    <tbody id="group-list">
    <g:each in="${groupList}">
        <tr>
            <td style="width: 85%;"><g:link action="show" id="${it.hash}" class="grouplink">${it.name}</g:link></td>
            <td style="width: 15%;">
                <g:link action="create" id="${it.hash}"><img src="/huxley/images/icons/edit.png" style="width:16px; height:19px; border:0;" /></g:link><g:link action="manage" id="${it.hash}"><img src="/huxley/images/icons/add-user.png" style="width:17px; height:19px; border:0; margin-left: 10px;" /></g:link><g:link action="remove" id="${it.hash}" onclick="return confirm('${message code:'verbosity.are.u.sure'}')"><img src="/huxley/images/icons/error.png" style="width:17px; height:19px; border:0;margin-left: 10px;"/></g:link>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>
<div class="ui-pagination" id="group-pagination"></div>
</body>
</html>