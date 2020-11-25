<!doctype html>
<html>
<head>
    <meta name="layout" content="main-head"/>
    <script>
        $(function () {
            var collection = new hx.models.TopCoder();
            collection.url = hx.util.url.rest('topcoders');
            (new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')})).render();
            collection.fetch({reset: true});
        });

    </script>
</head>

<body>
    <h3 style="font-size: 26px; font-weight: bold;">Parabéns, você acaba de adquirir ${payment.quantity} licenças para gerenciar os seus alunos.</h3>
    <p>Agora você pode criar um <g:link controller="group" action="create">grupo</g:link> e começar a utilizar todos os recursos que o The Huxley oferece pra o professor.</p>
</body>
</html>