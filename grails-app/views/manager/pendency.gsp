<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main-head"/>
    <link rel="stylesheet" href="${resource(dir: 'js/uploader', file: 'jquery.fileupload-ui.css')}" type="text/css">

    <script type="text/javascript">
        $(function () {
            var collection = new hx.models.TopCoder();
            collection.url = hx.util.url.rest('topcoders');
            (new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')})).render();
            collection.fetch({reset: true});
        });
    </script>

    <script src="${resource(dir:'js/uploader', file:'jquery.ui.widget.js')}"></script>
    <script src="${resource(dir:'js/uploader', file:'tmpl.min.js')}"></script>
    <script src="${resource(dir:'js/uploader', file:'jquery.iframe-transport.js')}"></script>
    <script src="${resource(dir:'js/uploader', file:'jquery.fileupload.js')}"></script>
    <script src="${resource(dir:'js/uploader', file:'jquery.fileupload-process.js')}"></script>
    <script src="${resource(dir:'js/uploader', file:'jquery.fileupload-validate.js')}"></script>
    <script src="${resource(dir:'js/uploader', file:'jquery.fileupload-ui.js')}"></script>

</head>
<body>
    <div id="box-content" class="box">
        <div class="page-header">
            <h3 style="font-size: 1.8em; font-weight: bold;"> Envie o seu comprovante de docência</h3>
        </div>
        <div class="alert">

            <button type="button" class="close" data-dismiss="alert">&times;</button>
            <p>Adicione um documento que comprove que você realmente é professor da ${institutionName}.</p>
            <br>
            <p>Exemplos de documentos são: imagem do site da instituição onde consta o seu nome no corpo docente, cabeçalho do contra-cheque digitalizado ou qualquer outro documento oficial que contenha a sua identificação e o seu cargo.</p>
            <br>
            <p>A sua requisição será enviada para o administrador da sua instituição: ${institutionAdminName}, <a href="mailto:${institutionAdminEmail}">${institutionAdminEmail}</a>. Ele avaliará a sua documentação para aprovar o seu papel como professor.</p>
        </div>
        <form id="fileupload" action="/huxley/manager/save" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${id}">
            <div class="row fileupload-buttonbar">

                <div class="span7">
                    <span class="btn btn-success fileinput-button">
                        <i class="icon-plus icon-white"></i>
                        <span>Adicionar documento...</span>
                        <input type="file" name="files[]" multiple="">
                    </span>
                    <button type="submit" class="btn btn-primary start">
                        <i class="icon-upload icon-white"></i>
                        <span>Iniciar envio</span>
                    </button>
                </div>

                <span class="fileupload-loading"></span>

            </div>
            <table role="presentation" class="table table-striped"><tbody class="files"></tbody></table>
        </form>

        <div class="well well-small muted">
            O tamanho máximo do arquivo é 5MB, apenas arquivos de imagens (jpg, gif, png) serão aceitos.
        </div>
    </div>

    <script id="template-upload" type="text/x-tmpl">
        {% for (var i=0, file; file=o.files[i]; i++) { %}
        <tr class="template-upload fade">
            <td>
                <span class="preview"></span>
            </td>
            <td>
                <p class="name">{%=file.name%}</p>
                {% if (file.error) { %}
                <div><span class="label label-important">Error</span> {%=file.error%}</div>
                {% } %}
            </td>
            <td>
                <p class="size">{%=o.formatFileSize(file.size)%}</p>

                <div class="pull-right">
                    {% if (!o.files.error) { %}
                    <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="bar" style="width:0%;"></div></div>
                    {% } %}
                    {% if (!o.files.error && !i && !o.options.autoUpload) { %}
                    <button class="btn btn-mini btn-primary start">
                        <i class="icon-upload icon-white"></i>
                        <span>Enviar</span>
                    </button>
                    {% } %}
                    {% if (!i) { %}
                    <button class="btn btn-mini btn-warning cancel">
                        <i class="icon-ban-circle icon-white"></i>
                        <span>Cancelar</span>
                    </button>
                    {% } %}
                </div>
            </td>
        </tr>
        {% } %}
    </script>
    <!-- The template to display files available for download -->
    <script id="template-download" type="text/x-tmpl">
        {% for (var i=0, file; file=o.files[i]; i++) { %}
        <tr class="template-download fade">
            <td>
                <span class="preview">
                    {% if (file.thumbnailUrl) { %}
                    <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}" data-gallery><img src="{%=file.thumbnailUrl%}"></a>
                    {% } %}
                </span>
            </td>
            <td>
                <p class="name">
                    <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}" {%=file.thumbnailUrl?'data-gallery':''%}>{%=file.name%}</a>
                </p>
                {% if (file.error) { %}
                <div><span class="label label-important">Erro</span> {%=file.error%}</div>
                {% } %}
            </td>
            <td>
                <span class="size">{%=o.formatFileSize(file.size)%}</span>
            </td>
        </tr>
        {% } %}
    </script>

    <script type="text/javascript">
        $(function () {
            $('#fileupload').fileupload({
                url: '/huxley/manager/save',
                maxFileSize: 5000000,
                acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
                limitMultiFileUploads: 1,
                sequentialUploads: true
            });
        });
    </script>
</body>
</html>