
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main-head"/>
    <script src="${resource(dir:'js', file:'handlebars-v1.1.2.js')}"></script>
    <script type="text/javascript">
        $(function () {
            $("#institution").typeahead({source: ${institution}});
            (function () {var view, collection = new hx.models.TopCoder();
            collection.url = hx.util.url.rest('topcoders');
            view = new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')});
            view.render();
            collection.fetch({reset: true})})();
        });
    </script>

    <style type="text/css">
        h3.page-title {
            background: transparent url('<g:resource dir="images/icons" file="icons.png"/>') no-repeat  -195px -46px;
            padding-left: 30px;
            color: #858484;
            font-family: Arial;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            margin: 25px 0px 30px 0px;
            line-height: 19px;
        }
    </style>
</head>
<body>
<div class="box">
    <h3 class="page-title">Solicitar participação como professor</h3>

    <div class="alert">
        <p>
        Para solicitar acesso como professor você precisa:<br/>
            <br/>
            (i) escolher a instituição onde você é professor;<br/>
            (ii) enviar um comprovante que você de fato é um professor;<br/>
            (iii) guardar a validação do seu cadastro pelo administrador da sua instituição.<br/>
            <br/>
        Você ainda terá acesso ao The Huxley como estudante.
        </p>
    </div>
    <g:form controller="teacher" action="createTeacherAccount">
        <div class="control-group">
            <label class="control-label" for="institution">Instituição: </label>
            <div class="controls">
                <input type="text" name="institution" class="input-xxlarge" id="institution" data-provide="typeahead" autocomplete="off"/>
            </div>
            <div class="alert">Se sua instituição ainda não foi cadastrada! Ao cadastrá-la, você se tornará o administrador institucional.</div>
            <div class="form-actions">
                <input type="submit" class="btn btn-primary right" value="Solicitar participação" />
            </div>
        </div>
    </g:form>
</div>
</body>
</html>