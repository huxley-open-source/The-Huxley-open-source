<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br, en">
<head>
    <meta name="layout" content="info"/>
</head>
<body>
    <div class="box">
        <h3><g:message code="auth.lost.password"/></h3>
        <p>${message(code:'verbosity.recovery.password.info')}</p>
        <g:form action="requestPassword">
            <g:if test="${flash.message}">
                <div class="alert alert-error">
                    <button type="button" class="close">×</button>
                    <div class="error">${flash.message}</div>
                </div>
            </g:if>
            <div class="form-element">
                <fieldset>
                    <label>
                        <strong>${message(code:'verbosity.email')}</strong>
                        <input type="text" name="email" class="medium" />
                    </label>
                </fieldset>
            </div>
            <input type="submit" value="${message(code:'verbosity.confirm')}" class="btn btn-blue" />
        </g:form>
    </div>
</body>

