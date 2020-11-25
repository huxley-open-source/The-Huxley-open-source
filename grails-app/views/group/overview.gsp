
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main-head"/>
    <script src="${resource(dir:'js', file:'handlebars-v1.1.2.js')}"></script>
    <script type="text/javascript">
        $(function () {
            topcoder();

            Handlebars.registerHelper('groupStatus', function (userTotal, questionnaireTotal) {
                var countPendency = 2;

                if (userTotal === 0) {
                    countPendency--;
                }

                if (questionnaireTotal === 0) {
                    countPendency--;
                }

                return new Handlebars.SafeString("(" + countPendency + "/2)");

            });

            Handlebars.registerHelper('fromNow', function (lastUpdated) {

                return new Handlebars.SafeString( moment(lastUpdated).startOf('minute').fromNow())

            });

            Handlebars.registerHelper('groupQuestionnairesCheck', function (questionnaireTotal) {
                var src = "${resource(dir: 'images', file: 'glyphicons_152_check.png')}";

                if (questionnaireTotal === 0) {
                    src = "${resource(dir: 'images', file: 'glyphicons_153_unchecked.png')}";
                }

                return new Handlebars.SafeString(src);
            });

            Handlebars.registerHelper('groupUsersCheck', function (userTotal) {
                var src = "${resource(dir: 'images', file: 'glyphicons_152_check.png')}";

                if (userTotal <= 1) {
                    src = "${resource(dir: 'images', file: 'glyphicons_153_unchecked.png')}";
                }

                return new Handlebars.SafeString(src);
            });

            Handlebars.registerHelper('userLabel', function (userTotal) {
                return new Handlebars.SafeString(userTotal === 0 ? '': (userTotal > 1 ? "(" + userTotal + " alunos)" : "(" + userTotal + " aluno)"));
            });

            Handlebars.registerHelper('questionnaireLabel', function (questionnaireTotal) {
                return new Handlebars.SafeString(questionnaireTotal === 0 ? '': (questionnaireTotal > 1 ? "(" + questionnaireTotal + " questionários)" : "(" + questionnaireTotal + " questionário)"));
            });

            $.ajax('/huxley/group/getGroupInfo', {
                dataType: 'json',
                success: function (data) {
                    var template =  Handlebars.compile($('#overview-row-template').html());
                    $.each(data, function (i, group) {
                        $('#group-overview').append(template(group));
                    })
                }
            });
        });

        function topcoder() {
            var view, collection = new hx.models.TopCoder();
            collection.url = hx.util.url.rest('topcoders');
            view = new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')});
            view.render();
            collection.fetch({reset: true});
        };
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
            margin: 25px 0px 10px 0px;
            line-height: 19px;
        }

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
    </style>
</head>
<body>
    <huxley:profile profile="${session.profile}" license="${session.license}"/>

    <div id="box-content" class="box">
        <h3 class="page-title">Meus Grupos</h3> <span class="right muted th-license-available"><small><g:message code="license.availabe"/> ${total} <g:message code="license.availabe2"/></small></span>
        <table id="group-overview" class="table table-striped">

        </table>
    </div>

    <script type="text/x-handlebars-template" id="overview-row-template">
        <tr>
            <td>
                <div class="row-fluid">
                    <div class="span6">
                        <a href="/huxley/group/show/{{ hash }}">{{ name }}</a> <small class="muted">{{groupStatus userTotal questionnaireTotal}}</small>
                        <div style="font-size: 10px; color: #aaa;">Atualizado há {{fromNow lastUpdated }}</div>
                        <div><small>{{ description }}</small></div>
                    </div>
                    <div class="span6">
                        <div><span><img src="{{groupUsersCheck userTotal}}"/></span><small> <a href="/huxley/group/manage/{{ hash }}">Adicionar alunos</a> ao grupo. <span class="muted">{{userLabel userTotal}}</span></small></div>
                        <div><span><img src="{{groupQuestionnairesCheck questionnaireTotal}}"/></span><small> <a href="/huxley/quest/createGroup?gid={{ id }}">Criar questionário</a> ou <a href="/huxley/quest/coursePlan/{{ id }}">Importar questionários</a>. <span class="muted">{{questionnaireLabel questionnaireTotal}}</span></small></div>
                    </div>
                </div>
            </td>
        </tr>
    </script>
</body>
</html>