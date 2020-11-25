<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br, en">
<head>
    <meta charset="utf-8">
    <meta name="keywords" content="programação, huxley, thehuxley, th, aprendizado, auxiliar" />
    <meta name="description" content="${message(code:'verbosity.description')}" />
    <title><g:layoutTitle default="The Huxley"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <g:javascript library="jquery" plugin="jquery"/>
    <r:require module="jquery-ui"/>
    <link rel="icon" type="image/vnd.microsoft.icon" href="http://static.cdn.thehuxley.com/rsc/icon/favicon.ico" />
    <link rel="shortcut icon" type="image/x-icon" href="http://static.cdn.thehuxley.com/rsc/icon/favicon.ico" />
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'bootstrap.css')}" type="text/css">
    <link href="http://static.cdn.thehuxley.com/rsc/css/<g:meta name="th.css"/>" type="text/css" rel="stylesheet">
    <r:layoutResources />
    <script src="${resource(dir:'js', file:'huxley.js')}"></script>
    <script src="${resource(dir:'huxley/js/vendor', file:'bootstrap.min.js')}"></script>
    <script type="text/javascript" id="sourcecode">
        $(function()
        {
            huxley.setRoot(${resource(dir:'/')});
        });
    </script>

    <script src="${resource(dir:'js', file:'th-ga.js')}"></script>
    <g:layoutHead/>


</head>
<body>
    <div id="head" class="head-info">
        <div class="container">
            <div>
                <h1 class="head-logo-info">
                    <g:link controller="home" action="index" params="${[ref: 'logo']}">The Huxley</g:link>
                </h1>
            </div>
        </div>
    </div>
    <div class="container content">
        <g:layoutBody/>
    </div>
    <div class="container footer">
        <div class="right">
            <g:link controller="auth" action="contact">Contato</g:link>
        </div>
        <div class="left">
            <img src="../images/footer-logo.png" alt="Footer Logo" />
        </div>
        <span>&copy; 2013 TheHuxley.com</span>
    </div>

</body>
</html>