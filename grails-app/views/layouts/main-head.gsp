<%@ page import="com.thehuxley.LicenseType; com.thehuxley.util.HuxleyProperties; com.thehuxley.Profile" %>
<!doctype html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="keywords" content="programação,objetivo,the,huxley,aprendizado" />
    <meta name="description" content="Seu aprendizado em programação é o nosso principal objetivo." />
    <title><g:layoutTitle default="The Huxley"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'bootstrap.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'style.css')}" type="text/css">

    <r:layoutResources />

    <script src="${resource(dir:'js', file:'hx-ui-vendors-0.0.1.js')}"></script>
    <script src="${resource(dir:'js', file:'hx-ui-0.0.1.js')}"></script>
    <script src="${resource(dir:'js', file:'huxley-main.js')}"></script>
    <script src="${resource(dir:'js', file:'huxley-main-search.js')}"></script>
    <script src="${resource(dir:'js', file:'moment.min.js')}"></script>
    <script src="${resource(dir:'js', file:'global.js')}"></script>
    <g:layoutHead/>

    <style type="text/css">
        .group-button-active2 {
            border-bottom: 1px solid;
        }
        .group-icon-active2 {
            background: url("../images/groups.png") no-repeat scroll 0px -28px transparent !important;
        }
        .menu-line{
            background: #ddd;
            font-size: 0;
            height: 1px;
            line-height: 0;
            margin: 6px 7px;
        }
        .li {
            style="border-bottom: white;
        }
    </style>

  <script src="${resource(dir:'js', file:'th-ga.js')}"></script>
</head>
<body id="innerpage">
<div id="header">
    <div class="wrapper">
        <div id="header-panel">
            <div class="logo"><!-- Logo -->
                <g:link controller="home"><img src="${resource(dir: 'images', file: 'logo.png')}" width="136px" height="25px" border="0" alt="Logo" /></g:link>
            </div>

            <div class="separator"></div>

            <div id="home">
                <g:link controller="home" class="active">${message(code:'verbosity.home')}</g:link>
            </div>

            <div class="separator"></div>

            <div id="header-search">
                <label id="header-search-label" for="search">${g.message(code: 'search.label')}</label>
                <div style="height: 40px; overflow: hidden; width: 329px;">
                    <div style="display: inline;">
                        <input type="text" name="search" style="width: 263px;" class="ui-search" id="search-text-input" placeholder="<g:message code="main.search"/>" autocomplete="off" value=""/>
                    </div>
                    <div style="display: inline;">
                        <input type="submit" value="Buscar" class="ui-search-button" onclick="javascript:submitSearch();" />
                    </div>
                </div>
                <div id="search-suggestion" style="display: none; border: 1px solid #272B31; background: #F6F6F6; z-index: 30; width: 329px; box-shadow: 0px 3px 7px #333; position: absolute; margin-top: 1px; margin-left: -2px;">
                    <div id="search-suggestion-user-title" style="width: 100%; padding: 5px; color: #666; display: none;"><g:message code="main.search.user"/></div>
                    <div id="search-suggestion-user"></div>
                    <div id="search-suggestion-group-title" style="width: 100%; padding: 5px; color: #666; display: none;"><g:message code="main.search.group"/></div>
                    <div id="search-suggestion-group"></div>
                    <div id="search-suggestion-problem-title" style="width: 100%; padding: 5px; color: #666; display: none;"><g:message code="main.search.problem"/></div>
                    <div id="search-suggestion-problem"></div>
                </div>
            </div>

            <div class="separator"></div>

            <div id="header-forum" class="header-forum">
                <div id="notification">
                    <div id="new-message-count-container" style="display:none;"><div class="new-message-highlight" id="new-message-count"></div></div>
                </div>

            </div>

            <div class="plseparator"></div>

            <div id="header-profile" style="cursor: default">
                <div class="photo">
                    <a href="/huxley/profile/show">
                        <img src="${HuxleyProperties.getInstance().get("image.profile.dir") + "thumb/" + session['profile'].smallPhoto}" width="36px" height="36px" border="0" />
                    </a>
                </div>

                <div style="overflow: hidden; text-overflow: ellipsis;  white-space: nowrap;" class="name">
                    <a style="text-decoration:none; color:#FFFFFF" href="/huxley/profile/show">${session['profile'].name}</a>
                </div>
            </div>

            <div class="prseparator"></div>

            <div id="header-config">
                <div id="config-menu-button">
                    <div id="config-menu-icon"></div>
                </div>

                <div class="arrow">
                    <div id="carrow" class="carrowd"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="menu-panel">
    <div id="menu-panel-content">
        <div id="config-menu">
            <ul>
                <li><a href="#" class="menu-item" id="changeLicense">${message(code:'verbosity.changeLicense')}</a></li>

                <g:if test="${!session.license.isStudent()}">
                    <li class="menu-line"></li>
                    <li><g:link controller="problem" action="management" class="menu-item">${message(code:'problem.manage')}</g:link></li>
                </g:if>
                <g:if test="${session.license.isAdmin()}">
                    <li><g:link controller="license" action="manage" class="menu-item">${message(code:'license.manage')}</g:link></li>
                    <li><g:link controller="license" action="manageAdmin" class="menu-item">${message(code:'license.manage.admin.inst')}</g:link></li>
                    <li><g:link controller="admin" action="pendencies" class="menu-item">Gerenciar Instituições</g:link></li>
                    <li class="menu-line"></li>
                    <li><g:link controller="tip" action="index" class="menu-item">Estatística das dicas</g:link></li>
                </g:if>
                <g:if test="${session.license.isAdminInst()}">
                    <li><g:link controller="license" action="manage" class="menu-item">${message(code:'license.manage')}</g:link></li>
                    <li><g:link controller="license" action="manageTeacher" class="menu-item">Gerenciar Professores</g:link></li>
                </g:if>
                <li class="menu-line"></li>
                <li><g:link action="create" controller="profile" class="menu-item">${message(code:'verbosity.edit.profile')}</g:link></li>
                <li><g:link action="show" controller="profile" class="menu-item">${message(code:'verbosity.see.profile')}</g:link></li>
                <li class="menu-line"></li>
                <g:if test="${session.license.isAdmin()}">
                    <li><g:link class="menu-item" action="list" controller="referenceSolution">${message(code:'entity.reference.solutions')}</g:link></li>
                </g:if>
                <li><g:link class="menu-item" action="index" controller="help">${message(code:'verbosity.help')}</g:link></li>
                <li class="menu-line"></li>
                <li><g:link controller="auth" action="signOut" class="menu-item">${message(code:'verbosity.logout')}</g:link></li>

            </ul>
        </div>

        <div id="forum-menu" class="forum-menu">
            <span class="pointer-top" style="position: relative;top: -11px;left: 110px;"></span>
            <span class="pointer-top" style="position: relative;top: -10px;left: 107px;border-bottom-color:white;"></span>
            <div id="forum-menu-comment-list"></div>
            <div id="forum-menu-footer" class="forum-menu-see-all"></div>

        </div>
    </div>
</div>

<div class="main-menu-container">
    <div class="container menu-container">
        <ul class="main-menu">
            <li><a href="/huxley/problem/index" class="underline-green"><div class="menu-icon"><span><i class="icon-problem"></i></span></div>Problemas<span class="underline underline-green"></span></a></li>
            <li><a href="/huxley/submission/index" class="underline-orange"><div class="menu-icon"><span><i class="icon-submission"></i></span></div>Submissões<span class="underline underline-orange"></span></a></li>
            <li><a href="/huxley/quest/index" class="underline-blue"><div class="menu-icon"><span><i class="icon-questionnaire"></i></span></div>Questionário<span class="underline underline-blue"></span></a></li>
            <g:if test="${!session.license.isStudent()}">
                <li><a id="group" href="/huxley/group/index" class="underline-purple"><div class="menu-icon"><span><i class="icon-group"></i></span></div>Grupos<span class="underline underline-purple"></span></a></li>
            </g:if>
            <g:else>
                <li><a id="group" href="/huxley/group/list" class="underline-purple"><div class="menu-icon"><span><i class="icon-group"></i></span></div>Grupos<span class="underline underline-purple"></span></a></li>

            </g:else>
        </ul>
    </div>
</div>

<div id="message-field" class="container"></div>

<div class="container content">
    <div class="row-fluid">
        <div class="span6 breadcrumb">
            <huxley:navigation/>
        </div>
        <div class="span3">
            <div class="pull-right">
                <ul class="nav nav-pills" style="margin-bottom: 0">
                    <li>
                        <a href="#">
                            <i class="icon-user"></i>
                            <span id="active-license">Estudante</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="span3">

            <div class="last-access">
                <huxley:lastAccess  profile="${session['profile']}"/>
            </div>
        </div>
    </div>
    <hr>
    <div class="container">
        <div class="left-content">
            <g:layoutBody/>
        </div>
        <div class="right-sidebar">
            <huxley:problemCounter profile="${session['profile']}"/>
            <div id="topcoder"></div>
        </div>
    </div>

</div>

<div class="container footer">
    <div class="right footer-contact" style="width: 200px; text-align: right;">
        <g:link controller="auth" action="policy" target="_blank">Política de Privacidade</g:link> -
        <g:link controller="auth" action="contact">Contato</g:link>
    </div>
    <div class="left" style="width: 210px; text-align: left;">
        <img src="http://static.cdn.thehuxley.com/rsc/images/footer-logo.png" alt="Footer Logo" />
    </div>
    <span>&copy; <g:message code="years.current"/> TheHuxley.com</span>
</div>

<div id="license-modal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="license-modal" aria-hidden="true">

</div>

<script id="license-modal-template" type="text/template">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 style="font-size: 1.8em; font-weight: bold;">Escolha sua licença: </h3>
    </div>
    <form action="/huxley/home/changeLicense">
        <input type="hidden" name="targetUri" value="${request.queryString ? (request.forwardURI.replace(request.contextPath, "") + "?" +  request.queryString) : (request.forwardURI.replace(request.contextPath, ""))}" id="targetUri">
        <div class="modal-body">

        </div>
        <div class="modal-footer">
            <button type="submit" class="btn" data-dismiss="modal" aria-hidden="true">Cancelar</button>
            <button class="btn btn-primary">Selecionar</button>
        </div>
    </form>
</script>

<script type="text/template" id="alert-template">
    <div class="alert {{ className }}" style="margin-top: 10px;">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        <span>{{ message }}</span>
    </div>
</script>

<script type="text/template" id="license-template">
    <div class="form-element">
        <label>
            <input type="radio" name="license" value="{{ id }}" {{ selected }}>
            {{ label }} <small class="muted"> {{ institutionName }}</small>
        </label>
    </div>
</script>

<script type="text/javascript">

    var openLicenseModal = function () {
        $.ajax({
            url: '/huxley/license/listByUser',
            dataType: 'json',
            success: function (data) {
                var list, template;
                $('#license-modal').html(_.template($('#license-modal-template').html()));
                list = $('#license-modal').find('.modal-body');
                list.empty();
                $.each(data, function (i, license) {
                    if (license.kind === 'STUDENT') {
                        license.label = 'Estudante'
                    } else if (license.kind === 'ADMIN') {
                        license.label = 'Administrador Geral'
                    } else if (license.kind === 'SYSTEM') {
                        license.label = 'Administrador do Sistema'
                    } else if (license.kind === 'ADMIN_INST') {
                        license.label = 'Administrador Institucional'
                    } else if (license.kind === 'TEACHER') {
                        license.label = 'Professor'
                    } else if (license.kind === 'TEACHER_ASSISTANT') {
                        license.label = 'Monitor'
                    } else {
                        license.label = 'Indefinida'
                    }

                    if (license.selected) {
                        license.selected = "checked"
                    } else {
                        license.selected = ""
                    }
                    var t = $(_.template($('#license-template').html(), license));
                    list.append(t);
                    $('#license-modal').modal();
                });
            }
        });

    };

    $(function () {
        _.templateSettings = {
            interpolate : /\{\{(.+?)\}\}/g
        };

        $('#changeLicense').click( openLicenseModal);

        window.mainAlert = function (message, className) {
            $('#message-field').html(_.template($('#alert-template').html(), {message: message, className: className}));
        }

        $.ajax({
            url: '/huxley/license/askLicense',
            dataType: 'json',
            success: function (data) {

                if (data.kind === 'STUDENT') {
                    data.label = 'Estudante'
                } else if (data.kind === 'ADMIN') {
                    data.label = 'Administrador Geral'
                } else if (data.kind === 'SYSTEM') {
                    data.label = 'Administrador do Sistema'
                } else if (data.kind === 'ADMIN_INST') {
                    data.label = 'Administrador Institucional'
                } else if (data.kind === 'TEACHER') {
                    data.label = 'Professor'
                } else if (data.kind === 'TEACHER_ASSISTANT') {
                    data.label = 'Monitor'
                } else {
                    data.label = 'Indefinida'
                }

                $('#active-license').html(data.label);
                $('#active-license').parent().click(function (e) {
                    e.preventDefault();
                    openLicenseModal();
                });

                if (data.ask) {
                    openLicenseModal();
                }
            }
        });


    });

</script>

</body>
</html>
