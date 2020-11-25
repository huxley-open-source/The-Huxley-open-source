<%@ page import="com.thehuxley.Profile" %>
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

<div id="box-content" class="box">
    <div class="page-header">
        <h3 style="font-size: 1.8em; font-weight: bold;">Cadastro de Professores</h3>
    </div>
    <div id="pendency-list">
        <table class="table table-striped">
            <tbody>

            </tbody>
        </table>
    </div>
</div>

<div id="pendency-modal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="pendencyModal" aria-hidden="true">

</div>

<script type="text/template" id="reject-modal">
    <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3 style="font-size: 24.5px">{{ userCreated.name }}</h3>
    </div>
    <div class="modal-body">
            <div class="alert">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                Será enviado um e-mail com o motivo da rejeição.
            </div>
            <label>
                Justificativa:
                <textarea style="margin: 0px; height: 160px; width: 524px; resize: none;"></textarea>
            </label>
     </div>
    <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancelar</button>
        <button class="btn btn-danger js-reject-confirm">Rejeitar</button>
    </div>
</script>

<script type="text/template" id="document-modal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 style="font-size: 24.5px">{{ userCreated.name }}</h3>
    </div>
    <div class="modal-body">
        <div id="myCarousel" data-interval="false" class="carousel slide">
            <ol class="carousel-indicators">

            </ol>
            <div class="carousel-inner">

            </div>
            <a class="carousel-control left" href="#myCarousel" data-slide="prev">&lsaquo;</a>
            <a class="carousel-control right" href="#myCarousel" data-slide="next">&rsaquo;</a>
        </div>
    </div>
</script>

<script type="text/template" id="pendency-item">
    <tr>
        <td>
            <div class="row-fluid">
                <div class="span8">
                    {{ userCreated.name }}
                </div>

                <div class="span4">
                    <small class="muted pull-right">{{ dateCreated }}</small>
                </div>
            </div>
            <div class="row-fluid">
                <div class="span2">
                  <span class="label {{ className }}">{{ statusLabel }}</span>
                </div>
                <div class="span10">
                    <div class="pull-right">
                        <buttom class="btn btn-primary btn-small js-show-doc">Ver comprovante</buttom>
                        <buttom {{ status === 1 ? "disabled" : "" }} class="btn btn-success btn-small js-accept">Aceitar</buttom>
                        <buttom {{ status === 2 ? "disabled" : "" }} class="btn btn-danger  btn-small js-reject">Rejeitar</buttom>
                    </div>
                </div>
            </div>
        </td>
    </tr>
</script>

<script type="text/javascript">
    $(function () {

        _.templateSettings = {
            interpolate : /\{\{(.+?)\}\}/g
        };

        moment.lang('pt-br');

        var fetchingPendencies = function () {
            $.ajax({
                url: '/huxley/pendency/listByInstitution',
                data: {kind: 4},
                dataType: 'json',
                success: function (data) {
                    $('#pendency-list').find('tbody').empty();
                    $.each(data, function (i, pendency) {

                        pendency.dateCreated = moment(pendency.dateCreated).startOf('second').fromNow();


                        if (pendency.status === 0) {
                            pendency.statusLabel = "Aguardando"
                            pendency.className = "label-warning"
                        } else if (pendency.status === 1) {
                            pendency.statusLabel = "Aceito"
                            pendency.className = "label-success"
                        } else if (pendency.status === 2) {
                            pendency.statusLabel = "Rejeitado"
                            pendency.className = "label-important"
                        }

                        pendency.title = "Instituição " + pendency.statusLabel;

                        var dom = $(_.template($('#pendency-item').html(), pendency));

                        $('#pendency-list').find('tbody').append(dom);

                        dom.delegate('buttom.js-show-doc:not([disabled])', 'click', function () {
                            var list, inner, template;
                            template= $(_.template($('#document-modal').html(), pendency));
                            list = template.find('.carousel-indicators');
                            inner = template.find('.carousel-inner');
                            $.each(pendency.document, function (i, document) {
                                list.append('<li data-target="#myCarousel" data-slide-to="' + i + '" class="' + (i === 0 ? 'active' : '') + '"></li>');
                                inner.append('<div class="' + (i === 0 ? 'active' : '') + ' item">' +
                                        '<img style="margin: auto; display: block;" src="/data/images/app/doc/' + document + '">' +
                                        '</div>'
                                );
                            });
                            $('#pendency-modal').html(template);
                            $('#pendency-modal').modal();
                        });
                        dom.delegate('buttom.js-accept:not([disabled])', 'click', function () {
                            $.get('/huxley/pendency/acceptPendency', {id: pendency.id}).done(fetchingPendencies);
                        });
                        dom.delegate('buttom.js-reject:not([disabled])', 'click', function () {
                            var template = $(_.template($('#reject-modal').html(), pendency));
                            $('#pendency-modal').html(template);
                            $('#pendency-modal').modal();
                            $(template).delegate('button.js-reject-confirm', 'click', function () {
                                $.post('/huxley/pendency/rejectPendency', {id: pendency.id, message: $(template).find('textarea').val()}).done(fetchingPendencies);
                                $('#pendency-modal').modal('hide');
                            });
                        });
                    });
                }
            });
        }

        fetchingPendencies();

    });


</script>
</body>
</html>
