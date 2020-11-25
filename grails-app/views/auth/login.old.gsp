<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="keywords" content="programação, huxley, thehuxley, th, aprendizado, auxiliar" />
    <meta name="description" content="${message(code:'verbosity.description')}" />
    <title>The Huxley</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/vnd.microsoft.icon" href="http://static.cdn.thehuxley.com/rsc/icon/favicon.ico" />
    <link rel="shortcut icon" type="image/x-icon" href="http://static.cdn.thehuxley.com/rsc/icon/favicon.ico" />
    <g:if env="development">
        <link href="<g:resource dir="css/thehuxley-ui" file="huxley.css"/>" type="text/css" rel="stylesheet">
        <link href="<g:resource dir="css/smoothness" file="jquery-ui-1.9.2.custom.min.css"/>" type="text/css" rel="stylesheet">
    </g:if>
    <g:else>
        <link href="http://static.cdn.thehuxley.com/rsc/css/<g:meta name="th.css"/>" type="text/css" rel="stylesheet">
    </g:else>
</head>
<body>
    <div id="head">
        <div class="container">
            <div>
                <h1 class="head-logo">
                    <g:link controller="home" action="index" params="${[ref: 'logo']}">The Huxley</g:link>
                </h1>
            </div>
        </div>
    </div>
    <div class="login-message">
        <div class="container">
            <div id="incompatibility-message" class="alert hide">
                <button type="button" class="close">×</button>
                <h3>Note que o The Huxley não é compatível com as versões 7 e 8 do Internet Explorer.</h3>
                <p>Recomendamos atualizar para a ultima versão do Internet Explorer, Firefox ou Google Chrome</p>
            </div>
        </div>
    </div>
    <div id="panel" class="panel">
        <div class="container">
            <div id="preview" class="preview panel-contents">
                <img src="http://static.cdn.thehuxley.com/rsc/images/01.jpg" alt="The Huxley"/>
            </div>
            <div id="invite" class="invite panel-contents">
                <div class="invite-message">
                    <h3>Divirta-se, aprenda e compartilhe!</h3>
                    <p>Seu <span>aprendizado em programação</span> é o nosso principal objetivo.</p>
                    <br>
                    <div style="text-align: right"><a href="/huxley/auth/createAccount" class="btn btn-red">Cadastre-se</a></div>
                </div>
            </div>
            <div id="login" class="login panel-contents">
                <div class="login-box">
                    <h3>Login</h3>
                    <g:form action="signIn">
                        <g:hiddenField name="targetUri" value="${targetUri}" />
                        <div class="form-element">
                            <fieldset>
                                <label>
                                    <strong>Nome de Usuário</strong>
                                    <input type="text" id="username" name="username" value="${username}" />
                                </label>
                            </fieldset>
                        </div>
                        <div class="form-element">
                            <fieldset>
                                <label>
                                    <strong>Senha</strong>
                                    <input type="password" id="password" name="password"/>
                                </label>
                            </fieldset>
                        </div>
                        <div class="form-element">
                            <fieldset>
                                <input type="submit" class="btn btn-blue" value="Entrar">
                            </fieldset>
                        </div>
                    </g:form>
                    <g:if test="${flash.message}">
                        <div class="login-error">${flash.message}</div>
                    </g:if>
                    <hr/>
                    <g:link action="lostPassword">Perdeu sua senha?</g:link>
                </div>
            </div>
        </div>
    </div>
    <div id="advantages" class="advantages">
        <div class="container">
            <div class="advantages-tour">
            </div>
        </div>
    </div>
    <div id="content">
        <div class="container">
            <div id="advantages-content" class="advantages-content">
                <div class="advantage-box teacher">
                    <img src="http://static.cdn.thehuxley.com/rsc/images/p01.png" alt="Para o professor"/>
                    <h3>Para o <span>professor</span></h3>
                    <p>Não perca tempo corrigindo códigos-fonte e nem elaborando exercícios</p>
                </div>
                <div class="advantage-box student">
                    <img src="http://static.cdn.thehuxley.com/rsc/images/p02.png" alt="Para o aluno"/>
                    <h3>Para o <span>aluno</span></h3>
                    <p>Aprenda no seu ritmo e obtenha feedback instantâneo sobre os seus programas</p>
                </div>
                <div class="advantage-box institution">
                    <img src="http://static.cdn.thehuxley.com/rsc/images/p03.png" alt="Para a instituição"/>
                    <h3>Para a <span>instituição</span></h3>
                    <p>Acompanhe facilmente o desempenho dos alunos e professores em tempo real</p>
                </div>
            </div>
            <div class="login-sidebar">
                <div class="spin" id="topcoder-content"></div>
            </div>
            <hr/>
        </div>
    </div>

    <div class="container footer">
        <div class="right footer-contact" style="width: 200px; text-align: right;">
            <g:link controller="auth" action="policy" target="_blank">Política de Privacidade</g:link> -
            <g:link controller="auth" action="contact" target="_blank">Contato</g:link>
        </div>
        <div class="left" style="width: 210px; text-align: left;">
            <img src="http://static.cdn.thehuxley.com/rsc/images/footer-logo.png" alt="Footer Logo" />
        </div>
        <span>&copy; <g:message code="years.current"/> TheHuxley.com</span>
    </div>

    <g:if env="development">
        <script src="<g:resource dir="js/thehuxley-ui/" file="jquery-1.8.3.min.js"/>" type="text/javascript"></script>
        <script src="<g:resource dir="js/thehuxley-ui/" file="jquery-ui-1.9.2.custom.min.js"/>" type="text/javascript"></script>
        <script src="<g:resource dir="js/thehuxley-ui/" file="underscore-min.js"/>" type="text/javascript"></script>
        <script src="<g:resource dir="js/thehuxley-ui/" file="spin.min.js"/>" type="text/javascript"></script>
        <script src="<g:resource dir="js/thehuxley-ui/" file="mustache.min.js"/>" type="text/javascript"></script>
        <script src="<g:resource dir="js/thehuxley-ui/" file="thehuxley-ui.js"/>" type="text/javascript"></script>
        <script src="<g:resource dir="js/thehuxley-ui/" file="thehuxley-ui-login.js"/>" type="text/javascript"></script>
    </g:if>
    <g:else>

        <script src="http://static.cdn.thehuxley.com/rsc/js/<g:meta name="th.js.jquery"/>" type="text/javascript"></script>
        <script src="http://static.cdn.thehuxley.com/rsc/js/<g:meta name="th.js.jquery-ui"/>" type="text/javascript"></script>
        <script src="http://static.cdn.thehuxley.com/rsc/js/<g:meta name="th.js.underscore"/>" type="text/javascript"></script>
        <script src="http://static.cdn.thehuxley.com/rsc/js/<g:meta name="th.js.mustache"/>" type="text/javascript"></script>
        <script src="http://static.cdn.thehuxley.com/rsc/js/<g:meta name="th.js.spin"/>" type="text/javascript"></script>
        <script src="http://static.cdn.thehuxley.com/rsc/js/<g:meta name="th.js"/>" type="text/javascript"></script>
        <script src="http://static.cdn.thehuxley.com/rsc/js/<g:meta name="th.js.login"/>" type="text/javascript"></script>
    </g:else>

    <div id="tour-modal" class="modal">
        <div class="modal-header">
            <button type="button" class="close">&times;</button>
            <h3>Faça um tour</h3>
        </div>
        <div class="modal-body">
            <div class="info">
            </div>
        </div>
        <div class="modal-footer">
            <button id="tour-close-modal"class="btn">Fechar</button>
        </div>
    </div>

    <script type="text/javascript">
        $(function() {
            $.ajax('http://api.twitter.com/1/statuses/user_timeline.json', {
                type: 'GET',
                data: {screen_name: 'the_huxley', count: 5, include_rts: true, include_entities: true},
                dataType: 'jsonp',
                success: function (data, textStatus, xhr) {
                    var i = 0;   
                    var d = new Date(data[i++].created_at); 
                    if ($.browser.msie) {
                        d = Date.parse(dateString.replace(/( \+)/, ' UTC$1'));
                    }
 
                    $('span#tweets').empty().append(data[i++].text).fadeIn('slow'); 
                    setInterval(function () {
                        $('span#tweets').fadeOut('slow', function() {                            
                            $('span#tweets').empty().append(data[i++].text).fadeIn('slow');    
                            i >= data.length ? i = 0:{}; 
                        });                  
                    }, 5000);

                }
            })
        });
    </script>
</body>
</html>