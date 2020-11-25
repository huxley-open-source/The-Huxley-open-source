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
        <div id="login-button">
          <a href="#">Login</a>

          <div id="login-form">
            <g:form controller="auth" action="signIn" role="form">
              <g:hiddenField name="targetUri" value="${targetUri}"/>
              <div class="form-group">
                <label>
                  <strong>Login</strong>
                  <input class="form-control input-sm" type="text" id="username" name="username" value="${username}"/>
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
            <li><a href="#overview">Visão Geral</a></li>
            <li><a href="#problems">Problemas</a></li>
            <li><a href="#submissions">Submissões</a></li>
            <li><a href="#groups">Grupos</a></li>
            <li><a href="#questionnaires">Questionários</a></li>
            <li><a href="#topcoder">TopCoder</a></li>
            <li><a href="#students-questions">Dúvidas dos Alunos</a></li>
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

<div class="bg-blue-hiw bg-blue-dark bg-main">
  <div class="container-fixed">
    <h3 id="overview">Como funciona o The Huxley?</h3>

    <p class="text-justify">O The Huxley é um sistema que diminui a evasão, melhora a qualidade do aprendizado
    dos alunos de programação e aumenta substancialmente a produtividade do professor.</p>

    <p class="text-justify">Com ele, os alunos praticam muito mais, o próprio sistema realiza correções,
    identifica cópias e alunos com dificuldades e ajuda automaticamente os alunos na
    resolução dos problemas.</p>

    <p class="text-justify">Sem ter que elaborar e nem corrigir exercícios e provas, os professores podem
    utilizar o seu tempo de uma maneira muito mais produtiva.</p>

    <p class="text-justify">Com técnicas de gamefication e auxílios rápidos, os alunos se tornam mais motivados
    fazendo com que a evasão diminua consideravelmente e a prática aumente.</p>
  </div>
</div>

<div class="bg-blue-hiw bg-main">
  <div class="container-fixed">
    <h3>O The Huxley é 100% online</h3>

    <p class="text-justify">Sem a necessidade de qualquer instalação, o The Huxley pode ser acessado de qualquer
    lugar, permitindo que uma atividade possa ser desenvolvida em laboratório ou em casa,
    permitindo que os alunos continuem praticando mesmo fora de sala de aula.</p>
  </div>
</div>

<div class="bg-blue-hiw bg-blue-dark bg-main">
  <div class="container-fixed">
    <h3>Plano Premium por apenas: R$ 9,90 por aluno.</h3>

    <p class="text-justify">É isso mesmo! Nossa Licença Premium possui o valor de apenas R$ 9,90 mensais por aluno.
    Sem custo de implantação, sem contratos de longo prazo e sem taxas escondidas.</p>

    <p class="text-justify">Faça as contas conosco: a adoção do sistema Huxley representa uma economia de 77% para
    instituições. Suponha que o salário médio de um professor é de quatro mil reais que,
    somado aos custos trabalhistas, representa para uma instituição, um investimento de
    aproximadamente seis mil e oitocentos reais com o profissional. Suponha também que 60% do
    tempo deste é dedicado à elaboração e correção de exercícios, representando cerca de quatro
    mil e oitenta reais do investimento que a instituição tem com ele. Ao adotar o The Huxley,
    pressupomos que o tempo dedicado a exercícios será reduzido para o total de apenas 5%, o que
    significa que o custo de quatro mil e oitenta reais passará a ser de apenas trezentos e
    quarenta reais.  Se somarmos a este valor o preço de aquisição de uma conta Premium e,
    considerando uma turma de 60 alunos, chegaremos a um montante equivalente a R$ 934,00. O que
    significa que, para uma instituição, o custo salarial de um professor com correção e
    elaboração de exercícios cairá de quatro mil e oitenta reais para novecentos e trinta e
    quatro reais totais.
    Além disso, o The Huxley dispõe de uma equipe de atendimento
    para ajudar por email ou chat.</p>
  </div>
</div>

<div class="bg-gray-lighter bg-main">
  <div id="how-it-works" class="container-fixed">

    <h3 class="title">Funcionalidades:</h3>
    <h3 id="problems">Problemas:</h3>

    <p class="text-justify">Você terá acesso a uma base crescente de problemas que atualmente já conta com mais de 300 problemas.
    Os problemas estão categorizados por nível de dificuldade e os assuntos necessários para resolvê-los.
    Os alunos podem resolver os problemas nas principais linguagens de programação.
    </p>

    <div class="row">
      <div class="col-md-4">
        <img src="${resource(dir: "images/howitworks", file: "1.png")}" />
      </div>
      <div class="col-md-8">
        <h4>Visualizar problemas</h4>
        <p class="text-justify">O aluno e o professor possuem acesso a todos os problemas do The Huxley. Esses problemas possuem
        uma descrição e especificam claramente o que o aluno deve esperar como parâmetro de entrada e como
        ele deve gerar a saída.Você terá acesso a uma base crescente de problemas que atualmente já conta
        com mais de 300 problemas. Os problemas estão categorizados por nível de dificuldade e os assuntos
        necessários para resolvê-los. Os alunos podem resolver os problemas nas principais linguagens de
        programação.</p>
      </div>
    </div>

    <div class="row">
      <div class="col-md-6">
        <h4>Busca avançada de problemas</h4>
        <p class="text-justify">Busque problemas de acordo com o nível de dificuldade, assunto ou pelo nome.</p>
      </div>
      <div class="col-md-6 text-right">
        <img src="${resource(dir: "images/howitworks", file: "2.png")}" />
      </div>
    </div>


    <div class="row">
      <div class="col-md-12">
        <h4>Cadastrar um problema</h4>
        <p class="text-justify">Se você é professor e possui algum problema que gostaria
        que seus alunos resolvessem, você pode cadastrar o seu próprio problema.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "3.png")}" />
      </div>
    </div>


    <h3 id="submissions">Submissões</h3>

    <div class="row">
      <div class="col-md-6">
        <h4>Submeter código fonte com a solução para um problema</h4>
        <p class="text-justify">Você pode submeter a solução de um problema em várias linguagens de programação diferentes.</p>
      </div>

      <div class="col-md-6 text-right">
        <img src="${resource(dir: "images/howitworks", file: "4.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-7">
        <img src="${resource(dir: "images/howitworks", file: "5.png")}" />
      </div>

      <div class="col-md-5">
        <h4>Visualizar a resposta da sua própria submissão</h4>
        <p class="text-justify">Você visualiza “na hora” se o seu código está certo ou errado.</p>
      </div>
    </div>

    <div class="row">
      <div class="col-md-5">
        <h4>Visualizar as submissões de todos os estudantes</h4>
        <p class="text-justify">Se você é um professor, você poderá ver as submissões de seus alunos.</p>
      </div>

      <div class="col-md-7 text-right">
        <img src="${resource(dir: "images/howitworks", file: "6.png")}" />
      </div>
    </div>


    <div class="row">
      <div class="col-md-12">
        <h4>Visualizar as submissões suspeitas de serem cópias</h4>
        <p class="text-justify">Caso o The Huxley encontre uma submissão similar a outra ele lhe indicará e você poderá avaliar se foi realmente uma cópia.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "7.png")}" />
      </div>
    </div>


    <div class="row">
      <div class="col-md-5">
        <img src="${resource(dir: "images/howitworks", file: "8.png")}" />
      </div>

      <div class="col-md-7">
        <h4>Baixar o código-fonte submetido pelo aluno</h4>
        <p class="text-justify">Se você quiser, pode baixar o código fonte do seu aluno para uma análise mais detalhada.</p>
      </div>

    </div>


    <div class="row">
      <div class="col-md-12">
        <h4>Visualizar erro do aluno</h4>
        <p class="text-justify">Caso seu aluno esteja errando um problema, você pode ver exatamente qual foi o caso de entrada
        que originou o erro, bem como ver a resposta correta esperada e qual é a resposta dada pelo código
        do seu aluno.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12 text-center">
        <img src="${resource(dir: "images/howitworks", file: "9.png")}" />
      </div>
    </div>




    <h3 id="groups">Grupos</h3>

    <div class="row">
      <div class="col-md-12">
        <h4>Criação, edição e remoção de grupos (turmas)</h4>
        <p class="text-justify">No Huxley, suas turmas de alunos são representados por grupos. Se você é um professor, você pode
        criar quantos grupos quiser.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "11.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Adição e remoção de usuários aos grupos</h4>
        <p class="text-justify">Adicione e remova usuários de forma simples. Você pode criar uma chave de acesso e compartilhar
        com os seus alunos para que eles se adicionem sem a necessidade da sua aprovação; alternativamente
        você pode adicionar os alunos um a um; ou ainda solicitar que seus alunos solicitem a associação ao
        grupo e você depois autoriza.</p>
      </div>
    </div>
    <div class="row text-center">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "12.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Gráfico de acesso</h4>
        <p class="text-justify">Veja quantos alunos acessaram o The Huxley.</p>
      </div>
    </div>
    <div class="row text-right">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "13.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Gráfico de submissões</h4>
        <p class="text-justify">Acompanhe quantos alunos estão submetendo soluções.</p>
      </div>
    </div>
    <div class="row text-right">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "14.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Gráfico de questionários</h4>
        <p class="text-justify">Acompanhe como anda a participação dos seus alunos questionário a questionário.</p>
      </div>
    </div>
    <div class="row text-right">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "15.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Gráfico de tópicos</h4>
        <p class="text-justify">Em cada questionário, veja como foi o índice de acerto por assunto.</p>
      </div>
    </div>
    <div class="row text-right">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "16.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Visualizar o número de problemas tentados, corretos, submissões e a pontuação de
        todos os alunos do grupo</h4>
        <p class="text-justify">Acompanhe em detalhes como anda a participação dos alunos da sua turma.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12 ">
        <img src="${resource(dir: "images/howitworks", file: "17.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Acessar o perfil dos alunos dos seus grupos</h4>
        <p class="text-justify">Se você é professor, você poderá acessar em detalhes o perfil de cada aluno. Isso inclui
        saber quais exercícios ele já respondeu, quais as notas nos questionários, os tópicos em que
        ele precisa melhorar, dentre outras informações.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "18.png")}" />
      </div>
    </div>

    <h3 id="questionnaires">Questionários</h3>

    <div class="row">
      <div class="col-md-12">
        <h4>Criar, editar e remover questionários</h4>
        <p class="text-justify">Mantenha seus alunos praticando com questionários a serem resolvidos em casa. Além disso,
        você pode fazer suas provas online.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "20.png")}" />
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <p class="text-justify">Você pode escolher os problemas que farão parte do questionário de acordo com o nível de
        dificuldade e assuntos. Além disso, antes de você escolher o problema, o The Huxley mostra pra
        você quantos alunos da sua turma já resolveram aquele problema, assim, você pode fazer um
        questionário somente com problemas que ninguém tenha feito, por exemplo.</p>
      </div>
    </div>
    <div class="row text-center">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "19.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Visualizar a média de dificuldade, a média de dificuldade ponderada, pontuação total,
        média das notas dos alunos e o percentual de alunos que tentaram resolver um determinado
        questionário</h4>
        <p class="text-justify">Você pode acompanhar o desempenho da sua turma em cada questionário. Além disso, de
        acordo com os problemas selecionados, o The Huxley calcula a média de dificuldade do
        questionário. Assim, você pode ir criando questionários com níveis de dificuldade
        crescente ao longo do curso.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "21.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Visualizar a pontuação de cada aluno no questionário</h4>
        <p class="text-justify">Veja as notas de cada aluno nos questionários. Você pode exportar facilmente essas notas
        para arquivos do excel ou csv.</p>
      </div>
    </div>
    <div class="row text-right">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "22.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Visualizar alunos com submissões similares a outros estudantes dentro de um questionário</h4>
        <p class="text-justify">Caso o nosso algoritmo de similaridades indique que uma submissão de um aluno é parecida com outra
        submissão, você pode visualizar ambas as submissões lado a lado e avaliar se realmente um aluno
        copiou do outro.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "23.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Visualizar gráficos de submissão por problema de um questionário</h4>
        <p class="text-justify">Identifique quais são os problemas que os alunos estão encontrando mais dificuldade em um determinado
        questionário.</p>
      </div>
    </div>
    <div class="row text-right">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "24.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Visualizar gráfico da porcentagem de alunos que tentaram responder cada problema</h4>
        <p class="text-justify">Veja como anda a participação do aluno em cada problema do questionário.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "25.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Visualizar gráfico da porcentagem de notas (dentre os alunos que tentaram)</h4>
        <p class="text-justify">Com esse gráfico, você irá acompanhar o desempenho da sua turma durante o semestre, questionário
        a questionário. Você verá quantos alunos tiraram notas maiores que 7 e quantos foram menores.</p>
      </div>
    </div>
    <div class="row text-right">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "26.png")}" />
      </div>
    </div>

    <h3 id="topcoder">TopCoder</h3>


    <div class="row">
      <div class="col-md-12">
        <p class="text-justify">O topcoder é um ranking que dá destaque aos melhores de cada turma do The Huxley
        como um todo. É um excelente incentivo para que os seus alunos continuem praticando.</p>
        <p class="text-justify">Alguns professores distribuem pontos extras na nota para os alunos que terminam o semestre
        dentro do TopCoder da turma.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12 text-center">
        <img src="${resource(dir: "images/howitworks", file: "27.png")}" />
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Acumular pontos a cada submissão correta</h4>
        <p class="text-justify">Quando um aluno acerta um problema, ele acumula pontos para o TopCoder. Quanto mais difícil é
        o problema, mais pontos o aluno acumula. Com isso, os alunos se sentem estimulados a buscar
        problemas cada vez mais difíceis.</p>
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <h4>Concorrer ao TopCoder</h4>
        <p class="text-justify">Alguns usuários não aparecem no TopCoder, mesmo que tenham acumulados pontos. Com essa
        funcionalidade habilitada, caso o aluno possua pontos suficientes, ele aparecerá no TopCoder.</p>
      </div>
    </div>

    <h3 id="students-questions">Dúvidas dos Alunos</h3>

    <div class="row">
      <div class="col-md-12">
        <h4>Solicitar ajuda ao professor sobre uma determinada submissão</h4>
        <p class="text-justify">O aluno poderá solicitar ajuda ao professor diretamente pelo sistema. Basta que ele submeta uma solução e depois solicite ajuda.</p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "28.png")}" />
      </div>
    </div>


    <div class="row">
      <div class="col-md-12">
        <h4>Receber e responder as dúvidas dos alunos pelo próprio Huxley, sem a necessidade da utilização do e-mail</h4>
        <p class="text-justify">O professor terá acesso a uma série de informações úteis para responder a dúvida do aluno.</p>
      </div>
    </div>
    <div class="row text-right">
      <div class="col-md-12">
        <img src="${resource(dir: "images/howitworks", file: "29.png")}" />
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
