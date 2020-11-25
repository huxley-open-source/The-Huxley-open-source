<%@ page import="com.thehuxley.Profile" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main-head"/>
        <style>
            div.profile {
                background: none repeat scroll 0 0 #FFFFFF;
                height: 155px;
                margin-bottom: 10px;
                padding: 10px;
                width: 695px;
            }

            div.profile > div.photo {
                width: 180px;
                height: 150px;
                margin-right: 10px;
                -webkit-border-radius: 5px;
                border-radius: 5px;
                float: left;
            }

            div.profile > div.photo img{
                height: 100%;
            }

            div.profile > div.photo > div.position {
                background: #fda759;
                color: #fff;
                font-size: 11px;
                font-weight: bold;
                padding: 0px 8px;
                -webkit-border-radius: 4px 0px 0px 4px;
                border-radius: 4px 0px 0px 4px;
                position: relative;
                bottom: -118px;
                right: 0px;
                margin-bottom: -999px;
                float: right;
            }

            div.profile > div.up {
                width: 100%;
                height: auto;
                border-bottom: #f1f1f1 1px solid;
                padding-bottom: 10px;
                margin-bottom: 8px;
            }

            div.profile > div.up > div.name {
                color: #6e6e6e;
                font-size: 19px;
                font-family: Trebuchet MS, Arial;
            }

            div.profile > div.up > div.name > span.gold, span.silver, span.bronze {
                color: #9c9a9a;
                font-family: Arial;
                font-size: 13px;
                padding-left: 16px;
                margin-left: 5px;
            }

            div.profile > div.up > div.name > span.gold {
                background: transparent url('/huxley/static/images/medals.png') no-repeat;
                background-position: 0px 0px;
                margin-left: 15px;
            }

            div.profile > div.up > div.name > span.silver {
                background: transparent url('/huxley/static/images/medals.png') no-repeat;
                background-position: 0px -17px;
            }

            div.profile > div.up > div.name > span.bronze {
                background: transparent url('/huxley/static/images/medals.png') no-repeat;
                background-position: 0px -34px;
            }


            div.profile > div.up > div.school {
                margin-top: 5px;
                color: #9c9a9a;
                font-size: 12px;
                font-family: Arial;
            }

            div.profile > div.up > div.website {
                font-size: 12px;
                font-family: Arial;
            }

            div.profile > div.down {
                width: 380px;
                height: auto;
                float: left;
            }

            div.profile > div.down > div.position, div.punctuation {
                margin-bottom: 5px;
            }

            div.profile > div.down > div.position, div.punctuation, div.tempted-problems, div.hit-problems {
                float: left;
                width: 190px;
            }

            div.profile > div.down > div.position span, div.punctuation span, div.tempted-problems span, div.hit-problems span {
                color: #9c9a9a;
                font-size: 11px;
                font-family: Arial;
                position: relative;
            }

            div.profile > div.down > div.position span b, div.punctuation span b, div.tempted-problems span b, div.hit-problems span b {
                color: #5bc3ce;
                font-size: 11px;
            }

            div.profile > div.down > div.position b, div.punctuation b, div.tempted-problems b, div.hit-problems b {
                color: #6c6c6c;
                font-size: 18px;
                font-family: Arial;
            }

            div.questionnaires h3, div.teacher h3 {
                background: transparent url('/huxley/static/images/icons/icons.png') no-repeat;
                background-position: -195px -46px;
                padding-left: 30px;
                color: #858484;
                font-family: Arial;
                font-size: 15px;
                font-weight: bold;
                cursor: pointer;
                margin: 25px 0px 10px 0px;
                line-height: 19px;
            }

            div.questionnaires h3 a {
                color: #4b94e4;
                text-decoration: none;
                font-size: 12px;
                font-weight: normal;
                float: right;
            }

        </style>
        <script>
            $(function () {
                var collection = new hx.models.TopCoder();
                collection.url = hx.util.url.rest('topcoders');
                (new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')})).render();
                collection.fetch({reset: true});
                $.ajax({
                    url: '/huxley/pendency/countPendency',
                    dataType: 'json',
                    success: function (data) {
                        if(data.count > 0){
                            var alertMsg = "<ul>"
                            if(data.msg != undefined){
                                alertMsg += '<li>' + data.msg + ' <a href="${resource(dir:'/')}' + data.link + '">' + data.msg2 + '</a></li>';
                            }
                            if(data.msg3.data !== undefined){
                                $.each(data.msg3.data, function (group, link) {
                                    alertMsg += "<li>" + data.msg3.msg + ' ' + group + '. <a href="${resource(dir:'/')}group/show/' + link + '?pendency=true">' + data.msg3.msg2 + '</a></li>';

                                });
                            }
                            alertMsg += "</ul>"
                            mainAlert(alertMsg);
                        }
                    }
                });
            });

        </script>
	</head>
	<body>
    <huxley:profile profile="${session.profile}" license="${session.license}"/>

    <div id="box-content" class="box">
        <div class="teacher">
            <h3>Você é professor?</h3>
            <p style="margin: 0 0 0 40px">Como professor você pode criar grupos, verificar a participação de seus estudantes, criar questionários e cadastrar novos problemas. Clique
            <a href="/huxley/teacher/signUp">aqui</a> para solicitar seu acesso como professor de uma instituição.</p>

        </div>
        <div class="questionnaires">
            <h3>Últimos questionários <a href="/huxley/quest/index">Ver Todos</a></h3>
            <table class="table table-striped">
                <tbody>

                </tbody>
            </table>
         </div>
    </div>

    <script type="text/template" id="quest-item">
        <tr>
            <td>
                <div class="row-fluid">
                    <div class="span8">
                        <a href="{{ link }}">{{ title }}</a>
                    </div>

                    <div class="span4 pull-right">
                        <small class="muted pull-right">início: {{ startDate }}</small>
                        <div>
                            <small class="muted pull-right">encerramento: {{ endDate }}</small>
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

            $.ajax({
                url: '/huxley/quest/getLastestQuestionnaires',
                dataType: 'json',
                success: function (data) {
                    $('.questionnaires').find('tbody').empty();
                    $.each(data.questionnaires, function (i, questionnaire) {
                        questionnaire.startDate = moment(questionnaire.startDate).startOf('second').fromNow();
                        questionnaire.endDate = moment(questionnaire.endDate).endOf('second').fromNow();
                        $('.questionnaires').find('tbody').append(_.template($('#quest-item').html(), questionnaire));
                    });
                }
            });
        });
    </script>
	</body>
</html>
