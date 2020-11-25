<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="keywords" content="programação, huxley, thehuxley, th, aprendizado, auxiliar" />
    <meta name="description" content="${message(code:'verbosity.description')}" />
    <title>The Huxley</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/vnd.microsoft.icon" href="http://static.cdn.thehuxley.com/rsc/icon/favicon.ico" />
    <link rel="shortcut icon" type="image/x-icon" href="http://static.cdn.thehuxley.com/rsc/icon/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'css', file:'th-web-components.css')}"/>
    <script src="${resource(dir:'js', file:'th-ga.js')}"></script>
  </head>
  <body>
  <header class="bg-gray-darker bg-main">
    <div class="container-fixed">
      <div class="menu menu-small">
        <div class="menu-logo"></div>
        <div class="menu-items">
          <div id="login-button">
            <a href="#">Login</a>
            <div id="login-form">
              <g:form controller="auth" action="signIn" role="form">
                <g:hiddenField name="targetUri" value="${targetUri}" />
                <div class="form-group">
                  <label>
                    <strong>Login</strong>
                    <input class="form-control input-sm" type="text" id="username" name="username" value="${username}"  />
                  </label>
                </div>
                <div class="form-group">
                  <label>
                    <strong>Senha</strong>
                    <input class="form-control input-sm" type="password" id="password" name="password"/>
                  </label>
                </div>
                <div class="submit-area">
                    <input type="submit" class="btn btn-sm btn-primary pull-right" value="LOGIN">
                </div>
              </g:form>
              <g:if test="${flash.message}">
                <div class="login-error">${flash.message}</div>
              </g:if>
              <div class="user-help">
                <g:link controller="auth" action="lostPassword">Perdeu sua senha?</g:link>
              </div>

            </div>
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
            <div class="fb-like" data-href="https://www.facebook.com/huxleyprogramming" data-layout="button" data-action="like" data-show-faces="false" data-share="false"></div>
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

  <div class="bg-gray-darker bg-main">
    <div id="hero" class="container-fixed">
      <div class="hero-main">
        <div class="hero-banner">
          <div class="hero-show">
            <ul class="hero-carousel">
              <li>
                <div id="hero-carousel-item-1"></div>
              </li>
              <li>
                <div id="hero-carousel-item-2"></div>
              </li>
            </ul>
          </div>
          <div class="hero-footer">
            <div class="hero-news">
              <div class="hero-news-label">
                <span>Notícias</span>
              </div>
              <div class="hero-carousel-news">
                <p>Professores e alunos, estamos muito contentes em colocar<br>
                  mais uma versão do Huxley no ar. <a href="https://www.facebook.com/huxleyprogramming/posts/571729496273448" target="_blank">Saiba mais!</a></p>
                <p>Agora o professor pode avaliar a qualidade do código fonte<br>
                   submetido aos questionários. <a href="https://www.facebook.com/huxleyprogramming/posts/571729496273448" target="_blank">Saiba mais!</a></p>
              </div>
            </div>
            <div class="hero-thumbs">
              <ul class="hero-carousel-thumbs">
                <li>
                  <div><img src="${resource(dir: 'images/landing', file: 'thumb02.png')}" alt=""/></div>
                </li>
                <li>
                  <div><img src="${resource(dir: 'images/landing', file: 'thumb01.png')}" alt=""/></div>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div class="hero-form">

          <h5>Cadastre-se!</h5>

          <div class="well-sm text-center">
            <label class="checkbox-inline">
              <input type="radio" name="roleOptions" id="studentOption" value="student" checked><span>Estudante</span>
            </label>
            <label class="checkbox-inline">
              <input type="radio" name="roleOptions" id="teacherOption" value="teacher"><span>Professor</span>
            </label>
          </div>

          <div id="student-form">
            <g:form id="student-account" action="createStudentAccount" class="form-inline" onsubmit="return validateStudentForm()">
              <div class="row">
                <div class="col-xs-12">
                  <input name="name" type="text" class="form-control input-sm" placeholder="Nome Completo">
                  <span class="input-status input-status-name hidden"></span>
                </div>
              </div>
              <div class="row">
                <div class="col-xs-12">
                  <input name="email" type="text" class="form-control input-sm" placeholder="Email">
                  <input name="repeatEmail" type="hidden">
                  <span class="input-status input-status-email hidden"></span>
                </div>
              </div>
              <div class="row">
                <div class="col-xs-6">
                  <input name="username" type="text" class="form-control input-sm" placeholder="Login">
                  <span id="student-username-status" class="input-status input-status-login hidden"></span>
                </div>
                <div class="col-xs-6">
                  <input name="password" type="password" class="form-control input-sm" placeholder="Senha">
                  <input name="repeatPassword" type="hidden">
                  <span class="input-status input-status-password hidden"></span>
                </div>
              </div>
              <div class="error-area">

              </div>
              <div class="row">
                <div class="col-xs-12">
                  <input class="btn btn-primary btn-sm btn-block" type="submit" value="CONFIRMAR">
                </div>
              </div>
            </g:form>
          </div>

          <div id="teacher-form" class="hidden">
            <div class="alert alert-warning alert-sm">
              <p>Para criar uma conta de professor você precisa (i) preencher os campos abaixo; (ii) enviar um comprovante
              de vínculo profissional; (iii) aguardar a validação do seu cadastro pelo administrador de sua instituição.
              Entretanto, ao preencher o cadastro você já terá acesso ao The Huxley com permissões de estudante.
              </p>
            </div>

            <g:form id="teacher-account" action="createTeacherAccount" class="form-inline" onsubmit="return validateTeacherForm()">
              <div class="row">
                <div class="col-xs-12">
                  <input type="text" name="name" class="form-control input-sm" placeholder="Nome Completo">
                  <span class="input-status input-status-name hidden"></span>
                </div>
              </div>
              <div class="row">
                <div class="col-xs-12">
                  <input type="text" name="email" class="form-control input-sm" placeholder="Email">
                  <input name="repeatEmail" type="hidden">
                  <span class="input-status input-status-email hidden"></span>
                </div>
              </div>
              <div class="row">
                <div class="col-xs-12">
                  <input id="institution-field" type="text" name="institution" class="form-control input-sm" data-provide="typeahead" autocomplete="off" placeholder="Instituição">
                    <span class="input-status input-status-institution hidden"></span>
                </div>
              </div>
              <div class="row">
                <div class="col-xs-6">
                  <input type="text" name="username" class="form-control input-sm" placeholder="Login">
                  <span id="student-username-status" class="input-status input-status-login hidden"></span>
                </div>
                <div class="col-xs-6">
                  <input type="password" name="password" class="form-control input-sm" placeholder="Senha">
                  <input name="repeatPassword" type="hidden">
                  <span class="input-status input-status-password hidden"></span>
                </div>
              </div>
              <div class="error-area">

              </div>
              <div class="row">
                <div class="col-xs-12">
                  <input class="btn btn-primary btn-sm btn-block" type="submit" value="CONFIRMAR">
                </div>
              </div>
            </g:form>
          </div>
        </div>
        <div class="hero-end-detail"></div>
      </div>
    </div>
  </div>

  <div>
    <div id="customers" class="container-fixed">
      <span>
        <img src="${resource(dir: 'images/landing', file:'logo-facisa.png')}" alt="FACISA"/>
      </span>
      <span>
        <img src="${resource(dir: 'images/landing', file:'logo-uncisal.png')}" alt="UNCISAL"/>
      </span>
      <span>
        <img src="${resource(dir: 'images/landing', file:'logo-ifal.png')}" alt="IFAL"/>
      </span>
      <span>
        <img src="${resource(dir: 'images/landing', file:'logo-ufal.png')}" alt="UFAL"/>
      </span>
      <span>
        <img src="${resource(dir: 'images/landing', file:'logo-fat.png')}" alt="FAT"/>
      </span>
      <span>
        <img src="${resource(dir: 'images/landing', file:'logo-estacio.png')}" alt="Estácio/FAL"/>
      </span>
      <span>
        <img src="${resource(dir: 'images/landing', file:'logo-ifgo.png')}" alt="IFGO"/>
      </span>
    </div>
  </div>

  <div class="bg-gray-lighter bg-main">
    <div id="topcoder" class="container-fixed">
      <div class="topcoder-title">
        <h3><span>TOP</span>CODER</h3>
      </div>
      <ul class="topcoder"></ul>
    </div>
  </div>

    <div class="bg-gray-lighter bg-main">
      <div id="main" class="container-fixed">
        <div id="teacher-1" class="row announcement">
          <div class="col-md-6 text">
            <h3>Professor</h3>
            <p>O The Huxley foi pensado para ajudá-lo com as aulas de
            programação. Através de nosso sistema você não precisará perder tempo ao corrigir exercícios e provas, elaborar problemas
            e verificar plágios. Além disso, seu email não ficará mais cheio de
            mensagens de alunos com códigos e dúvidas, pois toda a
            interação pode ser feita pelo The Huxley.</p>
          </div>
          <div class="col-md-6 announcement-image announcement-image-right">
            <img src="${resource(dir: 'images/landing', file:'teacher-1.png')}"/>
          </div>
        </div>

        <div id="teacher-2" class="row announcement">
          <div class="col-md-6 announcement-image">
            <img src="${resource(dir: 'images/landing', file:'teacher-2.png')}"/>
          </div>
          <div class="col-md-6 text">
            <p>O The Huxley oferece ainda relatórios detalhados do desempenho
            de sua turma. Seus alunos irão praticar muito mais programação
            e, portanto, aprenderão com mais facilidade. Com as horas
            economizadas com correção de exercícios, provas etc, você
            poderá aplicar seu tempo livre em outras atividades do seu interesse.</p>
          </div>
        </div>

        <div id="institution" class="row announcement">
          <div class="col-md-6 text">
            <h3>Instituição</h3>
            <p>As disciplinas que envolvem programação são responsáveis por uma grande taxa de retenção e evasão. Vários são os motivos para isso, mas um deles é a dificuldade em compreender a lógica de programação. Com o The Huxley, o aluno aprende no seu ritmo e obtem um feedback imediato. Criamos também mecanismos de incentivo como o TopCoder, visando o estímulo à prática e aprendizado, diminuindo assim a taxa de desistência do curso.</p>
          </div>
          <div class="col-md-6 announcement-image announcement-image-right">
            <img src="${resource(dir: 'images/landing', file:'institution.png')}"/>
          </div>
        </div>

        <div id="student" class="row announcement">
          <div class="col-md-6 announcement-image ">
            <img src="${resource(dir: 'images/landing', file:'student.png')}"/>
          </div>
          <div class="col-md-6 text">
            <h3>Aluno</h3>
            <p>Programação só se aprende praticando, e muito! Pensando nisso, criamos uma base de problemas com vários níveis de dificuldade para que você possa praticar programação no seu ritmo. O sistema The Huxley informa automaticamente a validade do código submetido sem a necessidade de espera da correção do professor. Além disso, utilizando-se de nossa ferramenta, você terá acesso a uma série de dicas por problema. Diante de dificuldades você poderá acessar as dicas disponíveis no sistema para obter ajuda na resolução do problema.</p>
          </div>
        </div>
      </div>
    </div>

    <div id="about" class="bg-blue-dark bg-main">
      <div class="container-fixed">
        <h3>The Huxley</h3>
        <p>O The Huxley é gratuito para qualquer estudante, seja ele aluno ou não, de instituição pública ou privada. Porém, como ferramenta, foi pensando para auxiliar o professor dentro e fora de sala de aula. Desta forma, sem o vínculo entre instituição, professor e sistema, uma série de aplicações desta ferramenta ficam restritas à licença padrão de uso. </p>
        <p>Para que um profesor e instituição utilizem-se de todas as funcionalidades oferecidas pelo The Huxley,  criamos uma <span href="#">LICENÇA PREMIUM</span>.</p>
        <p><span>Conheça as vantagens</span> de aderir a uma conta premium e <span href="#">convide sua instituição</span>, por meio de seu professor, a adquirir o pacote completo de funções do sistema.</p>
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

    <script type="text/javascript" src="${resource(dir: 'js', file:'jquery-1.11.0.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file:'bootstrap.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file:'handlebars-v1.1.2.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file:'typeahead.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file:'landing.js')}"></script>

    <script id="topcoder-box" type="text/x-handlebars-template">
      <li>
        <div class="userbox">
          <div class="position">{{ position }}º</div>
          <div class="photo"><img src="http://img.thehuxley.com/data/images/app/profile/thumb/{{ smallPhoto }}" /></div>
          <div class="info">
            <div>
              <div class="name">{{ name }}</div>
              <div class="institution">
                <span class="score">{{ score }}</span>
                {{ institution }}
              </div>
            </div>
          </div>
        </div>
      </li>
    </script>

  <div id="fb-root"></div>
  <script type="text/javascript">
    (function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) return;
      js = d.createElement(s); js.id = id;
      js.src = "//connect.facebook.net/pt_BR/sdk.js#xfbml=1&version=v2.0";
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
  </script>
  </body>
</html>
