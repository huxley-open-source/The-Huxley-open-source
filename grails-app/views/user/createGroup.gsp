<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'huxley-double-list-container.js')}"></script>
    <script src="${resource(dir:'js', file:'fileuploader.js')}"></script>
    <script type="text/javascript">
        var userSelectedId = [];
        var userCreatedId = [];
        $(function(){
            huxley.createUserUploader('submit-button');
        });


        function save(){
            var uN = [];
            var uE = [];
            var mL = [];
            var sL = [];
            var uCE = [];
            $.each(huxleyDLC.selectedId, function(i, idSelected) {
                if($('#r' + idSelected + ' option:selected').val() == "0"){
                    sL.push(idSelected);
                }else{
                    mL.push(idSelected);
                }
            });

            $.each(userSelectedId, function(i, idSelected) {
                uN.push($('#user-' + idSelected + '-name').val());
                uE.push($('#user-' + idSelected + '-email').val());
            });
            $.each(userCreatedId, function(i, idSelected) {
                uCE.push($('#user-' + idSelected + '-email').val());
            });
            $("#tList").val(mL);
            $("#sList").val(sL);
            $("#uEmail").val(uE);
            $("#uCreatedEmail").val(uCE);
            $("#uName").val(uN);
            if($('.user-status-warning-icon').length != 0){
                huxley.error('<g:message code="verbosity.invalid.user.list"/>');
                return;
            }
            $("#save-form").submit();
        }
        function erase(index){
            $("#user-" + index).empty();
            var indexInList = userSelectedId.indexOf(index);
            if(indexInList != -1){
                userSelectedId.splice(indexInList,1);
            }
            indexInList = userCreatedId.indexOf(index);
            if(indexInList != -1){
                userCreatedId.splice(indexInList,1);
            }
        }

        function validate(index){
            clearTimeout(userSearchInputTimeOut);
            userSearchInputTimeOut = setTimeout(function() {
                validateEmail(index);
            }, 1000);
        }

        var userSearchInputTimeOut;
        function validateEmail(index){
            $.ajax({
                url: huxley.root + 'user/validateEmail',
                async: false,
                data:'email='+$('#user-' + index + '-email').val(),
                dataType: 'json',
                success: function(data) {
                    $('#user-' + index + '-status').removeClass();
                    if(data.msg.status == 'ok'){
                        huxley.notify(data.msg.txt);
                        $('#user-' + index + '-status').addClass('user-status-ok-icon');
                        $('#user-' + index + '-email').removeClass('user-email-error');
                        if(userSelectedId.indexOf(index) == -1){
                            userSelectedId.push(index);
                        }
                        var indexInList = userCreatedId.indexOf(index);
                        if(indexInList != -1){
                            userCreatedId.splice(indexInList,1);
                        }
                    }else{
                        huxley.error(data.msg.txt);
                        if(userCreatedId.indexOf(index) == -1){
                            userCreatedId.push(index);
                        }
                        $('#user-' + index + '-status').addClass('user-status-warning-icon');
                        $('#user-' + index + '-email').addClass('user-email-error');
                        var indexInList = userSelectedId.indexOf(index);
                        if(indexInList != -1){
                            userSelectedId.splice(indexInList,1);
                        }

                    }

                }
            });
        }
        var updateIndex = 0;
        function update(data){
            var row = ''

            userSelectedId = [];
            userCreatedId = [];
            console.log(data);
            if(data.msg.status == 'ok'){
                huxley.notify(data.msg.txt);
                $.each(data.list.userList, function(i, user) {
                    userSelectedId.push(updateIndex);
                    row += '<div id="user-' + updateIndex + '"><input style="width:40%;" id="user-' + updateIndex + '-name" type="text" class="ui-input2" value="' + user.name + '"/><input type="text" onkeyup="validate(' + updateIndex + ')" style="width:40%;" id="user-' + updateIndex + '-email" class="ui-input2" value="' + user.email + '"/><span id="user-' + updateIndex + '-status" class="user-status-ok-icon"></span><a href="javascript:erase(' + updateIndex + ')" class="user-status-close-icon"></a></div>';
                    updateIndex ++;
                });
                $.each(data.list.invalidUserList, function(i, user) {
                    updateIndex ++;
                    userCreatedId.push(updateIndex);
                    row += '<div id="user-' + updateIndex + '"><input style="width:40%;"  id="user-' + updateIndex + '-name" type="text" class="ui-input2" value="' + user.name + '"/><input type="text" onkeyup="validate(' + updateIndex + ')" style="width:40%;" id="user-' + updateIndex + '-email" class="ui-input2 , user-email-error" value="' + user.email + '"/><a id="user-' + updateIndex + '-status" href="javascript:void(0)" class="user-status-warning-icon"></a><a href="javascript:erase(' + updateIndex + ')" class="user-status-close-icon"></a><br /></div>';
                });
                row += '<br />';
                $('#user-list-box').append(row);
                $('#user-list-box').show();
                $('#div').show();
            }else{
                huxley.error(data.msg.txt)
            }
        }


    </script>
</head>
<body>
<g:form action="saveGroup" name="save-form">
    <g:hiddenField name="tList" value="" id="tList"/>
    <g:hiddenField name="sList" value="" id="sList"/>
    <g:hiddenField name="userName" value="" id="uName"/>
    <g:hiddenField name="userEmail" value="" id="uEmail" />
    <g:hiddenField name="userCreatedEmail" value="" id="uCreatedEmail" />
</g:form>
<div class="box">
    <h3>Cadastrar Usuários... <a href="javascript:save()" class="ui-gbutton" id="save-button"><g:message code="verbosity.save"/></a></h3>
    <br />
</div>
<hr /><br />
<div class="box">
    <h3>Arquivo com lista de usuários: <div class="ui-gbutton" style="font-size: 15px; color: #fff; position: relative; float:right;" id="submit-button"></div></h3>
    <div style="font-size: 10px;">
        <p style="margin: 7px 0;">Utilize o formato:</p>
        <ul>
            <li style="display: block;">Nome do Usuário 1; email_do_usuario1@email.com</li>
            <li style="display: block;">Nome do Usuário 2; email_do_usuario2@email.com</li>
            <li style="display: block;">Nome do Usuário 3; email_do_usuario3@email.com</li>
            <li style="display: block;">Nome do Usuário 4; email_do_usuario4@email.com</li>
            <li style="display: block;">...</li>
        </ul>
        <p style="margin: 7px 0;">Será enviado um convite por e-mail para cada usuário da lista.</p>
    </div>
    <br />
</div>
<hr /><br />
<div class="box" id="user-list-box" style="display: none"></div>
<span id="div" style="display: none"><hr /><br /></span>
<huxley:groupDLC addGroup="true"></huxley:groupDLC>
</body>
</html>