<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="keywords" content="programação, huxley, thehuxley, th, aprendizado, auxiliar"/>
  <meta name="description" content="${message(code: 'verbosity.description')}"/>
  <title>The Huxley</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/vnd.microsoft.icon" href="http://static.cdn.thehuxley.com/rsc/icon/favicon.ico"/>
  <link rel="shortcut icon" type="image/x-icon" href="http://static.cdn.thehuxley.com/rsc/icon/favicon.ico"/>
  <link rel="stylesheet" type="text/css" href="${resource(dir: 'css', file: 'th-web-components.css')}"/>
  <script src="${resource(dir:'js', file:'th-ga.js')}"></script>
</head>

<body>
<header class="bg-gray-darker bg-main">
  <div class="container-fixed">
    <div class="menu menu-small">
      <div class="menu-logo"></div>

      <div class="menu-items">
        <div id="account-button">
          <g:link controller="auth" action="landing">Cadastre-se</g:link>
        </div>

        <div id="about-huxley" class="btn-group">
          <button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown">
            Como funciona <span class="caret"></span>
          </button>
          <ul class="dropdown-menu" role="menu">
            <li><a href="/huxley/auth/howItWorks#overview">Visão Geral</a></li>
            <li><a href="/huxley/auth/howItWorks#problems">Problemas</a></li>
            <li><a href="/huxley/auth/howItWorks#submissions">Submissões</a></li>
            <li><a href="/huxley/auth/howItWorks#groups">Grupos</a></li>
            <li><a href="/huxley/auth/howItWorks#questionnaires">Questionários</a></li>
            <li><a href="/huxley/auth/howItWorks#topcoder">TopCoder</a></li>
            <li><a href="/huxley/auth/howItWorks#students-questions">Dúvidas dos Alunos</a></li>
          </ul>
        </div>

        <div id="contact">
          <g:link controller="auth" action="contact" target="_blank" class="glyphicon glyphicon-send"></g:link>
        </div>

        <div class="facebook-like">
          <div class="fb-like" data-href="https://www.facebook.com/huxleyprogramming" data-layout="button"
               data-action="like" data-show-faces="false" data-share="false"></div>
        </div>
      </div>
    </div>
  </div>
</header>

<div id="brand" class="bg-gray-lighter bg-main">
  <div class="container-fixed">
    <a href="http://www.thehuxley.com/huxley?ref=logo">The Huxley</a>
  </div>
</div>

<div class="container-fixed content">
  <div id="login-panel" class="panel panel-default">
    <div class="panel-body">
      <g:form action="signIn">
        <g:hiddenField name="targetUri" value="${targetUri}" />
        <div class="form-group">
          <label for="username">Login</label>
          <input class="form-control input-sm" type="text" id="username" name="username" value="${username}" />
        </div>
        <div class="form-group">
          <label for="password">Senha</label>
          <input class="form-control input-sm" type="password" id="password" name="password"/>
        </div>

        <button type="submit" class="btn btn-primary btn-sm btn-block">Login</button>
      </g:form>
      <g:if test="${flash.message}">
        <div class="login-error">${flash.message}</div>
      </g:if>
      <hr/>
      <div class="pull-right" >
        <g:link action="lostPassword">Perdeu sua senha?</g:link>
      </div>

    </div>
  </div>
</div>


<footer class="bg-black bg-main">
  <div class="container-fixed">
    <div class="footer">
      <div class="logo"><a href="http://www.thehuxley.com/huxley?ref=logo">The Huxley</a></div>

      <div class="copyright hidden-xs">© 2014 TheHuxley.com</div>

      <div class="privacy"><g:link controller="auth" action="policy" target="_blank">Política de Privacidade</g:link></div>
    </div>
  </div>
</footer>

<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery-1.11.0.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'bootstrap.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'handlebars-v1.1.2.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'typeahead.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'landing.js')}"></script>

<div id="fb-root"></div>
<script type="text/javascript">
  (function (d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s);
    js.id = id;
    js.src = "//connect.facebook.net/pt_BR/sdk.js#xfbml=1&version=v2.0";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));
</script>
</body>
</html>
