<%@ page import="com.thehuxley.util.HuxleyProperties" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'fileuploader.js')}"></script>
    <script type="text/javascript">
        var canSubmit = false;
        function submit(){
            $("#save").submit();
        }
        $(function() {
            $("#profile").val("${profileInstance.id}");
        });
        <g:if test = "${msg}">
            $(function() {
                if("${msg}" == "ERROR1"){
                    $("#input-password").css('border-color','red');
                }
                if("${msg}" == "ERROR2"){
                    $("#input-repeat-new-password").css('border-color','red');
                    $("#input-new-password").css('border-color','red');
                }

            });
        </g:if>
        $(function() {
            $('#save-button').click(function(e) {
                if($("#input-repeat-new-password").val().length == 0 && $("#input-new-password").val().length == 0){
                    $("#input-repeat-new-password").css('border-color','red');
                    $("#input-new-password").css('border-color','red');
                    canSubmit = false;
                }
                if($('#input-password').val().length > 0) {
                    if(canSubmit){
                        submit();
                    }

                }else{
                    $("#input-password").css('border-color','red');
                }
            });
        });

        function validate(){
            if($("#input-repeat-new-password").val().length > 0 && $("#input-new-password").val().length > 0){
                if($("#input-repeat-new-password").val() != $("#input-new-password").val()){
                    $("#input-repeat-new-password").css('border-color','red');
                    $("#input-new-password").css('border-color','red');
                    canSubmit = false;
                }else{
                    $("#input-repeat-new-password").css('border-color','');
                    $("#input-new-password").css('border-color','');
                    canSubmit = true;
                }
            }
        }



    </script>
</head>
<body>
<div class="box"><!-- Courses box -->
    <h3><g:message code="profile.change.password"/> <a href="javascript:void(0);" class="ui-gbutton" id="save-button"><g:message code="profile.save"/></a></h3>
</div>
<hr /><br />
<div class="box">
    <g:form action="savePassword" name="save" id="save-form">
            <g:hiddenField name="profileId" value="${profileInstance.id}"></g:hiddenField>
            <h3><g:message code="profile.password"/> <input type="password" name="password" placeholder="<g:message code="profile.tip.password"/>" style="float:right;display:table;width: 70%;" class="ui-input2" id="input-password"  /></h3></br>
            <h3><g:message code="profile.new.password"/> <input type="password" name="newPassword" onblur="validate()" placeholder="<g:message code="profile.tip.new.password"/>" style="float:right;display:table;width: 70%;" class="ui-input2" id="input-new-password"  /></h3></br>
            <h3><g:message code="profile.repeat.new.password"/> <input type="password" name="repeatPassword" onblur="validate()" placeholder="<g:message code="profile.retip.new.password"/>" style="float:right;display:table;width: 70%;" class="ui-input2" id="input-repeat-new-password"  /></h3></br>
            </br>

        <br />
    </g:form>
</div>
</div>
<hr /><br />
</body>
</html>