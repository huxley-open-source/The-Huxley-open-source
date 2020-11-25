<%@ page import="com.thehuxley.Institution" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>

    <script src="${resource(dir:'js', file:'huxley-double-list-container.js')}"></script>
    <script type="text/javascript">
        var permissionList = [0,0,0];
        var validEmail;
        function save(){
            var mL = [];
            var sL = [];
            $.each(huxleyDLC.selectedId, function(i, idSelected) {
                if($('#r' + idSelected + ' option:selected').val() == "0"){
                    sL.push(idSelected);
                }else{
                    mL.push(idSelected);
                }
            });
            $("#tList").val(mL);
            $("#sList").val(sL);
            $("#uEmail").val($("#input-email").val());
            $("#uName").val($("#input-name").val());
            $("#uInstitution").val($('#institution :selected').val());
            $("#permissionList").val(permissionList);
            if($("#input-name").val().length == 0){
                huxley.error('<g:message code="verbosity.user.name.empty"/>');
                return;
            }
            if($("#input-email").val().length == 0){
                huxley.error('<g:message code="verbosity.user.email.empty"/>');
                return;
            }else{
                validateEmail($("#input-email").val());
                if(validEmail == 0){
                    return;
                }
            }
            if((permissionList[0] == 0) && (permissionList[1] == 0) && (permissionList[2] == 0)){
                huxley.error('<g:message code="verbosity.permission.list.empty"/>');
                return;
            }

            $("#save-form").submit();
        }
        function validateEmail(email){
            $.ajax({
                url: huxley.root + 'user/validateEmail',
                async: false,
                data:'email='+ email,
                dataType: 'json',
                success: function(data) {
                    if(data.msg.status == 'ok'){
                        validEmail = 1;
                    }else{
                        validEmail = 0;
                        huxley.error(data.msg.txt);
                    }

                }
            });
        }

        $(function() {
            $( "#add-license" ).button({
                text: false,
                icons: {
                    primary: "ui-icon-plusthick"
                }
            })
                    .click(function(e) {
                        e.preventDefault();
                        var canAppend = 0;
                        var kind = $("#license-select-list").val().toLowerCase();

                        var toAppend = '<tr id="'+kind+'"class="license-list-item">';
                        if($("#license-select-list").val()=="STUDENT" && permissionList[0]==0){
                            toAppend += "<td><g:message code="license.kind.standard.student"/></td>";
                            permissionList[0]= 1;
                            canAppend = 1;
                        }
                        if($("#license-select-list").val()=="TEACHER" && permissionList[1]==0){
                            toAppend += "<td><g:message code="license.kind.standard.master"/></td>";
                            permissionList[1]= 1;
                            canAppend = 1;
                        }
                        if($("#license-select-list").val()=="ADMININST" && permissionList[2]==0){
                            toAppend += "<td><g:message code="license.kind.standard.admin.inst"/></td>";
                            permissionList[2]= 1;
                            canAppend = 1;
                        }
                        toAppend += '<td style="text-align:center"><a href="javascript:removeLicense(\'' + kind + '\')" ><img src="/huxley/images/icons/error.png" style="width:17px; height:19px; border:0;margin-left: 10px;"/></a></td></tr>';
                        if(canAppend){
                            $("#license-list").append(toAppend);
                            updateLicenseTable();
                        }

                    });
        });
        function removeLicense(kind){
            console.log('chamado: ' + "#" + kind);
            $("#" + kind).remove();
            if(kind == "student"){
                permissionList[0]=0;
            }
            if(kind == "teacher"){
                permissionList[1]=0;
            }
            if(kind == "admininst"){
                permissionList[2]=0;
            }
            updateLicenseTable();
        }
        function updateLicenseTable(){
                if($(".license-list-item").length==0){
                    $("#license-table").hide();
                    $("#license-notify").show();
                }else{
                    $("#license-table").show();
                    $("#license-notify").hide();
                }
        }


    </script>
</head>
<body>
<g:form action="saveSingle" name="save-form">
    <g:hiddenField name="tList" value="" id="tList"/>
    <g:hiddenField name="sList" value="" id="sList"/>
    <g:hiddenField name="userName" value="" id="uName"/>
    <g:hiddenField name="userEmail" value="" id="uEmail" />
    <g:hiddenField name="institution" value="" id="uInstitution" />
    <g:hiddenField name="adminInst" value="" id="uAdminInst"/>
    <g:hiddenField name="permissionList" value="" id="permissionList"/>
</g:form>
<div class="box"><!-- Courses box -->
    <h3>Criando usuário...             <a href="javascript:save()" class="ui-gbutton">Salvar</a></h3>
</div>
<hr /><br />
<div class="box">
        <h3>Nome do usuário <input type="text" name="name" placeholder="Digite o nome do usuário..." style="float:right;display:table;width: 70%;" class="ui-input2" id="input-name"  /></h3>
        <br />
        <h3>Email do usuário <input type="text" name="name" placeholder="Digite o email do usuário..." style="float:right;display:table;width: 70%;" class="ui-input2" id="input-email"  /></h3>
        <br />
</div>
<hr /><br />
<div class="box">
    <h3><g:message code="vebosity.add.license"/>
        <span style="height: 34px;"><span class="ui-custom-select" style="width:450px;margin-top:-5px;">
            <select name="kind" id="license-select-list" style="width:100%;">
                <option value="STUDENT"><g:message code="license.kind.standard.student"/></option>
                <option value="TEACHER"><g:message code="license.kind.standard.master"/></option>
                <option value="ADMININST"><g:message code="license.kind.standard.admin.inst"/></option>
            </select>
        </span>
        <button id="add-license" style="height: 34px; vertical-align: middle; margin-left: -5px;" class="ui-button-topics-search"><g:message code="problem.select.single"/></button></span>
    </h3>
    </div>
    <hr /><br />
    <div class="box">
    <h3><g:message code="verbosity.added.license"/></h3>
        <span id="license-notify"><g:message code="verbosity.license.list.empty"/></span>
    <table id="license-table" class="standard-table" style="display:none;">
        <thead>
        <th style="padding: 15px 15px; width: 700px;"><g:message code="verbosity.kind"/></th>
        <th style="padding: 15px 15px;"><g:message code="verbosity.action"/></th>
        </thead>
        <tbody id="license-list">
        </tbody>
    </table>
</div>
<hr /><br />
<huxley:groupDLC addGroup="true"></huxley:groupDLC>
</body>
</html>
