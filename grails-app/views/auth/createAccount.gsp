<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br, en">
<head>
    <meta name="layout" content="info"/>
    <script type="text/javascript">
        function validateEmail(email){
            var isValid = false;
            $.ajax({
                url: huxley.root + 'auth/validateEmail',
                async: false,
                data:'email='+ email,
                dataType: 'json',
                success: function(data) {
                    if(data.msg.status == 'ok'){
                        isValid = true;
                    }

                }
            });
            return isValid;
        }

        function validateUsername(username){
            var isValid = false;
            $.ajax({
                url: huxley.root + 'auth/validateUsername',
                async: false,
                data:'username='+ username,
                dataType: 'json',
                success: function(data) {
                    if(data.msg.status == 'ok'){
                        isValid = true;
                    }
                }
            });
            return isValid;
        }

        function validatePassword(password){
            if (password.length < 6) {
                return false
            } else {
                return true
            }
        }

        function validateField(field,level,compareTo) {
            field = $(field);
            var help = field.parent().find("span"), emailValido=/^.+@.+\..{2,}$/, compareToHelp, validateChar=/^[a-zA-Z0-9]+$/;
            help.empty();
            if (field.val().length === 0 ) {
                helpError(field,'${message(code: "auth.message.fill.field")}!');
            } else if (((4 & level) > 0) && !emailValido.test(field.val())) {
                helpError(field,'${message(code: "auth.message.invalid.email")}!');
            } else if ((8 & level) && !validaCpf(field.val())) {
                helpError(field,'${message(code: "auth.message.invalid.cpf")}!');
            } else if ((16 & level) && !validatePassword(field.val())) {
                helpError(field,'${message(code: "auth.message.short.password")}!');
            } else if (((32 & level) > 0) && (!validateChar.test(field.val()))) {
                helpError(field,'${message(code: "auth.use.valid.char")}!');
            } else if ((((1 & level) > 0) && compareTo === 'email') && (!validateEmail(field.val()))) {
                helpError(field,'${message(code: "auth.message.in.use")}!');
            } else if ((((1 & level) > 0) && compareTo === 'username') && (!validateUsername(field.val()))) {
                helpError(field,'${message(code: "auth.message.in.use")}!');
            } else if (((2 & level) > 0 ) && ($(compareTo).val() !== field.val())) {
                if (('student-repeat-email' === field.attr('id')) || ('teacher-repeat-email' === field.attr('id'))) {
                    helpError(field,'${message(code: "auth.message.invalid.repeated.email")}!');
                } else {
                    helpError(field,'${message(code: "auth.message.invalid.password")}!');
                }

            } else {
                field.removeClass('error');
            }
        }
        function helpError(field,msg){
            var help = field.parent().find("span");
            help.append(msg);
            field.addClass('error');
        }
        $(function () {
            'use strict';
            $("#institution").typeahead({source: ${institution}});
            $("#teacher-form").hide();
            $("input[name=roleRadio]").change(function (event) {
                $("#teacher-form").toggle();
                $("#student-form").toggle();
            });
            $("#student-name, #teacher-name").blur(function(event){
                validateField(event.target,0);
            });
            $("#student-password, #teacher-password").blur(function(event){
                validateField(event.target,16 + 32);
            });
            $("#student-username, #teacher-username").blur(function(event){
                validateField(event.target,1 + 32,'username');
            });

            $("#teacher-cpf").blur(function(event){
                validateField(event.target,9);
            });

            $("#student-email, #teacher-email").blur(function(event){
                validateField(event.target,5,'email');
            });
            $("#student-repeat-email").blur(function(event){
                validateField(event.target,2, "#student-email");
            });
            $("#teacher-repeat-email").blur(function(event){
                validateField(event.target,2, "#teacher-email");
            });
            $("#student-repeat-password").blur(function(event){
                validateField(event.target,2, "#student-password");
            });
            $("#teacher-repeat-password").blur(function(event){
                validateField(event.target,2, "#teacher-password");
            });
            <g:if test="${svalidate}">
            $("#student-name").blur();
            $("#student-username").blur();
            $("#student-email").blur();
            </g:if>
            <g:if test="${tvalidate}">
            $("#teacherOption").attr("checked",true);
            $("#teacherOption").change();
            $("#teacher-name").blur();
            $("#teacher-username").blur();
            $("#teacher-cpf").blur();
            $("#teacher-email").blur();
            </g:if>
        });

        function validaCpf(cpf){
            var numeros, digitos, soma, i, resultado, digitos_iguais;
            digitos_iguais = 1;
            if (cpf.length < 11)
                return false;
            for (i = 0; i < cpf.length - 1; i++)
                if (cpf.charAt(i) != cpf.charAt(i + 1))
                {
                    digitos_iguais = 0;
                    break;
                }
            if (!digitos_iguais)
            {
                numeros = cpf.substring(0,9);
                digitos = cpf.substring(9);
                soma = 0;
                for (i = 10; i > 1; i--)
                    soma += numeros.charAt(10 - i) * i;
                resultado = soma % 11 < 2 ? 0 : 11 - soma % 11;
                if (resultado != digitos.charAt(0))
                    return false;
                numeros = cpf.substring(0,10);
                soma = 0;
                for (i = 11; i > 1; i--)
                    soma += numeros.charAt(11 - i) * i;
                resultado = soma % 11 < 2 ? 0 : 11 - soma % 11;
                if (resultado != digitos.charAt(1))
                    return false;
                return true;
            }
            else
                return false;
        }
    </script>
    <style type="text/css">
    .form-element .typeahead strong{
        display: inline;
    }
    </style>
</head>
<body>
<div class="box">
    <h3><g:message code="auth.create.account"/></h3>
    <label class="radio">
        <input type="radio" name="roleRadio" id="studentOption" checked>
        <g:message code="verbosity.student"/>
    </label>
    <label class="radio">
        <input type="radio" name="roleRadio" id="teacherOption" >
        <g:message code="verbosity.master"/>
    </label>

    <div id="student-form">
        <g:form action="createStudentAccount" >
            <div class="form-element">
                <fieldset>
                    <label>
                        <strong>${message(code:'verbosity.name.complete')}*</strong>
                        <input type="text" name="name" class="medium" id="student-name" value="${studentInstance?.name}"/>
                        <span class="help-inline error"></span>
                    </label>
                </fieldset>
            </div>
            <div class="form-element">
                <fieldset>
                    <label>
                        <strong>${message(code:'verbosity.username')}*</strong>
                        <input type="text" name="username" class="medium" id="student-username" value="${studentInstance?.username}"/>
                        <span class="help-inline error"></span>
                    </label>
                </fieldset>
            </div>
            <div class="form-element">
                <fieldset>
                    <label>
                        <strong>${message(code:'verbosity.email')}*</strong>
                        <input type="text" name="email" class="medium" id="student-email" value="${studentInstance?.email}" />
                        <span class="help-inline error"></span>
                    </label>
                </fieldset>
            </div>
            <div class="form-element">
                <fieldset>
                    <label>
                        <strong>${message(code:'verbosity.repeat.email')}*</strong>
                        <input type="text" name="repeatEmail" class="medium" id="student-repeat-email" value="${studentRepeatEmail}"/>
                        <span class="help-inline error"></span>
                    </label>
                </fieldset>
            </div>
            <div class="form-element">
                <fieldset>
                    <label>
                        <strong>${message(code:'verbosity.password')}*</strong>
                        <input type="password" name="password" class="medium" id="student-password"/>
                        <span class="help-inline error"></span>
                    </label>
                </fieldset>
            </div>
            <div class="form-element">
                <fieldset>
                    <label>
                        <strong>${message(code:'verbosity.repeat.password')}*</strong>
                        <input type="password" name="repeatPassword" class="medium" id="student-repeat-password"/>
                        <span class="help-inline error"></span>
                    </label>
                </fieldset>
            </div>
            <input type="submit" value="${message(code:'verbosity.confirm')}" class="btn btn-blue" />
            <span class="help-inline error"></span>
        </g:form>
    </div>
    <div id="teacher-form">
        <div class="alert">
            <g:message code="account.master.info"/>
        </div>
        <g:form action="createTeacherAccount" >
        <div class="form-element">
            <fieldset>
                <label>
                    <strong>${message(code:'verbosity.name.complete')}*</strong>
                    <input type="text" name="name" class="medium" id="teacher-name" value="${teacherInstance?.name}"/>
                    <span class="help-inline error"></span>
                </label>
            </fieldset>
        </div>
        <div class="form-element">
            <fieldset>
                <label>
                    <strong>${message(code:'verbosity.username')}*</strong>
                    <input type="text" name="username" class="medium" id="teacher-username" value="${teacherInstance?.username}"/>
                    <span class="help-inline error"></span>
                </label>
            </fieldset>
        </div>
        <div class="form-element">
            <fieldset>
                <label>
                    <strong>${message(code:'verbosity.email')}*</strong>
                    <input type="text" name="email" class="medium" id="teacher-email" value="${teacherInstance?.email}"/>
                    <span class="help-inline error"></span>
                </label>
            </fieldset>
        </div>
        <div class="form-element">
            <fieldset>
                <label>
                    <strong>${message(code:'verbosity.repeat.email')}*</strong>
                    <input type="text" name="repeatEmail" class="medium" id="teacher-repeat-email" value="${teacherRepeatEmail}"/>
                    <span class="help-inline error"></span>
                </label>
            </fieldset>
        </div>
        <div class="form-element">
            <fieldset>
                <label>
                    <strong>${message(code:'verbosity.cpf')}*</strong>
                    <input type="text" name="cpf" class="medium" id="teacher-cpf" value="${teacherInstance?.cpf}"/>
                    <span class="help-inline error"></span>
                </label>
            </fieldset>
        </div>
        <div class="form-element">
            <fieldset>
                <label>
                    <strong>${message(code:'verbosity.password')}*</strong>
                    <input type="password" name="password" class="medium" id="teacher-password"/>
                    <span class="help-inline error"></span>
                </label>
            </fieldset>
        </div>
        <div class="form-element">
            <fieldset>
                <label>
                    <strong>${message(code:'verbosity.repeat.password')}*</strong>
                    <input type="password" name="repeatPassword" class="medium" id="teacher-repeat-password"/>
                    <span class="help-inline error"></span>
                </label>
            </fieldset>
        </div>
            <div class="alert">
                <g:message code="account.institution.info"/>
            </div>
            <div class="form-element form-inline">
                <fieldset>
                    <label>
                        <strong>${message(code:'verbosity.institution')}*</strong>
                        <input type="text" name="institution" class="medium" id="institution" data-provide="typeahead" autocomplete="off"/>
                        <span class="help-inline error"></span>
                    </label>
                </fieldset>
            </div>
        <input type="submit" value="${message(code:'verbosity.confirm')}" class="btn btn-blue" />
    </g:form>
</div>

</div>
</body>
</html>