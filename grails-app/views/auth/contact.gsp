<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br, en">
<head>
    <meta name="layout" content="info"/>
</head>
<body>
    <div class="box">
        <h3><g:message code="auth.contact"/></h3>
        <p>Não esqueça de informar o seu email, entraremos em contato o mais breve possível.</p>
             <g:form action="sendMessage" name="message-form">
                 <div class="form-element">
                     <fieldset>
                         <label>
                             <strong>${message(code:'verbosity.name')}</strong>
                             <input type="text" name="name" class="medium" />
                         </label>
                     </fieldset>
                </div>
                 <div class="form-element">
                     <fieldset>
                         <label>
                             <strong>${message(code:'verbosity.email')}</strong>
                             <input type="text" name="email" class="medium" />
                         </label>
                     </fieldset>
                 </div>
                 <div class="form-element">
                     <fieldset>
                         <label>
                             <strong>Mensagem</strong>
                             <textarea name="m" class="medium"></textarea>
                         </label>
                     </fieldset>
                 </div>
                 <input type="submit" value="${message(code:'verbosity.confirm')}" class="btn btn-blue" />
            </g:form>
    </div>
</body>
</html>