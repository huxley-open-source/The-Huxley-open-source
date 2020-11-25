<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main-head"/>
    <script type="text/javascript">
        $(function () {
            topcoder();
        });

        function topcoder() {
            var view, collection = new hx.models.TopCoder();
            collection.url = hx.util.url.rest('topcoders');
            view = new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')});
            view.render();
            collection.fetch({reset: true});
        }
        ;
    </script>
    <style>
    h3 {
        font-weight: bold;
        font-size: 20px;
    }

    h5 {
        font-weight: bold;
        margin: 10px 0;
        font-size: 16px;
    }

    ol {
        list-style-type: decimal;
        list-style-position: inside;
        margin: 20px;
        font-siz: 16px;
    }

    </style>
</head>

<body>
<div id="box-content" class="box">
    <div class="clearfix" style="margin-bottom: 20px;">
        <span class="right" style="padding-top: 10px"><a href="/huxley/group/create"
                                                         class="btn btn-success">Novo grupo</a></span>
        <h3>Você ainda não possui grupos</h3>
        <span class="muted th-license-available"><small><g:message code="license.availabe"/> ${total} <g:message code="license.availabe2"/></small></span>

    </div>

    <p>É importante criar grupos, assim você poderá reunir seus alunos, criar questionários e acompanhar progresso de sua turma durante todo o semestre.</p>
    <br/>

    <p>São necessários apenas três passo para que você possa aproveitar todos os recursos que o The Huxley oferece para o professor:</p>
    <ol>
        <li><a href="/huxley/group/create">Criar um grupo</a>;</li>
        <li>Adicionar seus alunos ao grupo</li>
        <li>Criar questionários ou importar um curso completo.</li>
    </ol>
</div>
</body>
</html>