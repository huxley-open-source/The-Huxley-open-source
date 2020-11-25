<%@ page import="com.thehuxley.ReferenceSolution" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'huxley-reference-solution.js')}"></script>
<script type="text/javascript">
    $(function() {
        huxleyReference.setValues(10);
        huxley.generatePagination('reference-pagination',huxleyReference.getReference,10,${total});
        huxleyReference.setChangeFunction(huxleyReference.getReference,0);
        $('#input-problem').keyup(function() {
            clearTimeout(referenceSearchInputTimeOut);
            referenceSearchInputTimeOut = setTimeout(function() {
                huxleyReference.setName($("#input-problem").val());
            }, 1000);
        });
    });
    huxleyReference.getReference = function(index){
        var offset = index * huxleyReference.limit;
        $.ajax({
            url: huxley.root + 'referenceSolution/getList',
            async: true,
            data: 'offset=' + offset + '&max='+huxleyReference.limit + '&searchParam=' + huxleyReference.name,
            dataType: 'json',
            success: function(data) {
                var toAppend = '';
                $('#reference-list').empty();
                $.each(data.referenceList, function(i, reference) {
                    toAppend+='<tr>' +
                    '<td >' + reference.problem + '</td>'+
                    '<td style="text-align: center;">' + reference.language + '</td>';
                    if(reference.status == "${ReferenceSolution.STATUS_ACCEPTED}"){
                        toAppend+='<td style="color: green;text-align: center;"><g:message code="reference.accepted"/></td>';
                    }
                    if(reference.status == "${ReferenceSolution.STATUS_REJECTED}"){
                        toAppend+='<td style="color: red;text-align: center;"><g:message code="reference.rejected"/></td>';
                    }
                    if(reference.status == "${ReferenceSolution.STATUS_WAITING}"){
                        toAppend+='<td style="text-align: center;"><g:message code="reference.waiting"/></td>';
                    }
                    toAppend += '<td style="text-align: center;">' + reference.submissionDate + '</td>';
                    <g:if test="${session.license.isAdmin()}">
                    toAppend +='<td style="text-align: center;">' + reference.userSuggest + '</td>';
                    </g:if>
                    if((reference.status == "${ReferenceSolution.STATUS_ACCEPTED}") ){
                        toAppend +='<td ><a href="' + huxley.root + 'referenceSolution/show/' + reference.id + '">+detalhes</a></td>';
                    }else{
                        toAppend +='<td ><a href="' + huxley.root + 'referenceSolution/compare/' + reference.id + '">+detalhes</a></td>';
                    }


                    toAppend += '</tr>';
                });

                if(offset == 0){
                    huxley.generatePagination('reference-pagination',huxleyReference.getReference,10,data.total);
                }
                $('#reference-list').append(toAppend);
            }
        });
    };
    var referenceSearchInputTimeOut;


</script>
</head>
<body>
<div class="box"><!-- Search box -->
    <g:form action="index">
        <input type="text" name="name" placeholder="Digite o nome do problema..." style="width: 62%;" class="ui-input2" id="input-problem"  />
    </g:form>
</div>
<hr /><br />
<h3>Grupos Existentes</h3>
<table class="standard-table">
    <thead>
    <th style="padding: 15px 15px;"><g:message code="entity.problem"/></th>
    <th style="padding: 15px 15px;text-align: center;"><g:message code="entity.language"/></th>
    <th style="padding: 15px 15px;text-align: center;"><g:message code="reference.status"/></th>
    <th style="padding: 15px 15px;text-align: center;"><g:message code="reference.date"/></th>
    <g:if test="${session.license.isAdmin()}">
        <th style="padding: 15px 15px;text-align: center;"><g:message code="reference.user.suggest"/></th>
    </g:if>
    <th style="padding: 15px 15px;"></th>
    </thead>
    <tbody id="reference-list">
    <g:each in="${referenceSolutionList}" var="reference">
        <tr>
            <td >${reference.problem.name}</td>
            <td style="text-align: center;">${reference.language.name}</td>
            <g:if test = "${reference.status == ReferenceSolution.STATUS_ACCEPTED}">
                <td style="color: green;text-align: center;"><g:message code="reference.accepted"/></td>
            </g:if>
            <g:if test = "${reference.status == ReferenceSolution.STATUS_REJECTED}">
                <td style="color: red;text-align: center;"><g:message code="reference.rejected"/></td>
            </g:if>
            <g:if test = "${reference.status == ReferenceSolution.STATUS_WAITING}">
                <td style="text-align: center;"><g:message code="reference.waiting"/></td>
            </g:if>
            <td style="text-align: center;">${reference.submissionDate}</td>
            <g:if test="${session.license.isAdmin()}">
                <td style="text-align: center;">${reference.userSuggest.name}</td>
            </g:if>
            <g:if test="${reference.status == ReferenceSolution.STATUS_ACCEPTED}">
                <td ><g:link action="show" id="${reference.id}">+detalhes</g:link></td>
            </g:if>
            <g:else>
                <td ><g:link action="compare" id="${reference.id}">+detalhes</g:link></td>
            </g:else>
        </tr>
    </g:each>
    </tbody>
</table>
<div class="ui-pagination" id="reference-pagination"></div>
</body>
</html>