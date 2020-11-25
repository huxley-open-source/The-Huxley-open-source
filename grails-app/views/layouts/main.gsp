<%@ page import="com.thehuxley.LicenseType; com.thehuxley.util.HuxleyProperties; com.thehuxley.Profile" %>
<!doctype html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="keywords" content="programação,objetivo,the,huxley,aprendizado" />
    <meta name="description" content="Seu aprendizado em programação é o nosso principal objetivo." />
    <title><g:layoutTitle default="The Huxley"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'reset.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'huxley.css')}" type="text/css">
    <g:javascript library="jquery" plugin="jquery"/>
    <r:require module="jquery-ui"/>
    <r:layoutResources />

    <script src="${resource(dir:'js', file:'huxley.js')}"></script>
    <script src="${resource(dir:'js', file:'huxley-main.js')}"></script>
    <script src="${resource(dir:'js', file:'huxley-problem.js')}"></script>
    <script src="${resource(dir:'js', file:'jquery.jscrollpane.min.js')}"></script>
    <script src="${resource(dir:'js', file:'huxley-main-search.js')}"></script>
    <script src="${resource(dir:'js', file:'fileuploader.js')}"></script>
    <script src="${resource(dir:'js', file:'jquery.countdown.js')}"></script>

    <style type="text/css">

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

    <style type="text/css" id="page-css">
        /* Styles specific to this particular page */
    .scroll-pane
    {
        width: 100%;
        height: 350px;
        overflow: auto;
    }
    </style>
    <style type="text/css">#videogallery a#videolb{display:none}</style>
    <!--[if IE]>
		<style type="text/css"> .ui-search-button { top: 2px; *top: 2px; _top: 2px; } </style>
	    <![endif]-->
    <!--[if IE 5]>
		<style type="text/css"> .ui-search-button { top: 2px; *top: 2px; _top: 2px; } </style>
	    <![endif]-->
    <!--[if gte IE 9]>
		<style type="text/css"> .gradient { filter: none; } </style>
	    <![endif]-->
    <script src="${resource(dir:'js', file:'functions.js')}"></script>

    <script type="text/javascript" id="sourcecode">
        $(function()
        {
            huxley.setRoot(${resource(dir:'/')});
            $('.scroll-pane').jScrollPane();
        });
    </script>
    <script type="text/javascript">
        /* HTML LIGHTBOX */
        $(document).ready(function() {
               huxley.createLightBox();
            $('.contact-send-message').click(function (e) {
                'use strict';
                huxley.openModal('huxley-contact');
            });
        });
        $(function () {
            'use strict';

            $('#contact-message-cancel').click(function () {
                huxley.closeModal();
            });

            $('#contact-message-send').click(function () {
                sendContactMessage();
            });

            $('div#mask-lift').click(function (e) {
                e.preventDefault();
                huxley.closeModal();
            });

            $('div#mask-container').click(function (e) {
                e.stopPropagation();    
            });
            huxley.lookForFeed();
        });

        function sendContactMessage() {
            'use strict';
            var comment = $('#contact-message').val();

            $.ajax({
                url: '/huxley/auth/sendMessage',
                type: 'POST',
                data: {m: comment},
                async: false,
                success: function () {
                    huxley.closeModal();
                }
            });
        };
        <g:if test="${eMsg}">
        $(function () {
        huxley.error('${eMsg}');
            });
        </g:if>
        <g:if test="${sMsg}">
        $(function () {
            huxley.notify('${sMsg}');
        });
        </g:if>
    </script>

    <script src="${resource(dir:'js', file:'th-ga.js')}"></script>

    <g:layoutHead/>

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
                            <img src="${HuxleyProperties.getInstance().get("image.profile.dir") + "thumb/" + session['profile']?.smallPhoto}" width="36px" height="36px" border="0" />
                        </a>
                    </div>

                    <div style="overflow: hidden; text-overflow: ellipsis;  white-space: nowrap;" class="name">
                        <a style="text-decoration:none; color:#FFFFFF" href="/huxley/profile/show">${session['profile']?.name}</a>
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

<div id="spinner" style="display: none; width: 100%; background: rgba(0, 0, 0, .5); float: left; position: absolute; z-index: 10; text-align: center; color: white; font-size: 11px;padding: 6px 0 6px 0;"><g:message code="verbosity.loading"/></div>
    <div id="menu-panel">
        <div id="menu-panel-content">
            <div id="config-menu">
                <ul>

                    <li><a class="menu-item" href="javascript:void(0);" onclick="huxley.openModal('license-selection');">${message(code:'verbosity.changeLicense')}</a></li>
                    <g:if test="${!session?.license?.isStudent()}">
                        <li class="menu-line"></li>
                        <li><g:link controller="problem" action="management" class="menu-item">${message(code:'problem.manage')}</g:link></li>
                    </g:if>
                    <g:if test="${session?.license?.isAdmin()}">
                        <li><g:link controller="license" action="manage" class="menu-item">${message(code:'license.manage')}</g:link></li>
                        <li><g:link controller="license" action="manageAdmin" class="menu-item">${message(code:'license.manage.admin.inst')}</g:link></li>
                        <li><g:link controller="admin" action="pendencies" class="menu-item">Gerenciar Instituições</g:link></li>
                        <li class="menu-line"></li>
                        <li><g:link controller="tip" action="index" class="menu-item">Estatística das dicas</g:link></li>
                    </g:if>
                    <g:if test="${session?.license?.isAdminInst()}">
                        <li><g:link controller="license" action="manage" class="menu-item">${message(code:'license.manage')}</g:link></li>
                        <li><g:link controller="license" action="manageTeacher" class="menu-item">Gerenciar Professores</g:link></li>
                    </g:if>
                    <li class="menu-line"></li>
                    <li><g:link action="create" controller="profile" class="menu-item">${message(code:'verbosity.edit.profile')}</g:link></li>
                    <li><g:link action="show" controller="profile" class="menu-item">${message(code:'verbosity.see.profile')}</g:link></li>
                    <li class="menu-line"></li>
                    <g:if test="${session?.license?.isAdmin()}">
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


    <div class="clear"></div>
<!-- Main menu -->
    <huxley:mainMenu permission="30"/>
<!-- Teacher main-menu
    <div id="tmain-menu">
        <li><a href="problems.html" target="_self"><div class="problems">Problemas</div></a></li>
        <li><a href="submissions.html" target="_self"><div class="submissions">Submissões</div></a></li>
        <li><a href="questionnaires.html" target="_self"><div class="questionnaires">Questionários</div></a></li>
        <li><a href="courses.html" target="_self"><div class="courses">Cursos</div></a></li>
        <li><a href="teacher_groups.html" target="_self"><div class="groups">Grupos</div></a></li>
    </div> -->
    <div class="clear"></div>

    <div id="content"><!-- Content -->
        <div class="wrapper">
            <div class="header"><!-- Last Access & Breadcrumb -->
                <div class="right">
                    <huxley:lastAccess  profile="${session['profile']}"/>
                </div>
                <div class="breadcrumb">
                    <huxley:navigation/>
                </div>
                <hr />
                <div><span id="system-msg"></span></div>
            </div>
        <g:if test="${!justLeft}">
            <div class="right"><!-- Right content -->
                <huxley:problemCounter profile="${session['profile']}"/>
                <huxley:topCoder max="10"/>
            </div>
        </g:if>
            <div class="left"><!-- Left content -->
                <g:layoutBody />
            </div>
        </div>
        <div class="clear"></div><br/>
    </div>
    <div class="clear"></div>

    <div id="footer"><!-- Footer -->
        <div class="footer-panel">
            <div class="wrapper">
                <div id="footer-logo">
                    <img src="/huxley/images/footer-logo.png" width="84px" height="17px" border="0" alt="Footer Logo" />
                </div>
                <div id="footer-copy">
                    <span>&copy; <g:message code="years.current"/> TheHuxley.com</span>
                </div>
                <div id="footer-right">
                    <g:link controller="auth" action="policy" target="_blank">Política de Privacidade</g:link> -
                    <g:link controller="auth" action="contact" target="_blank">Contato</g:link>
                </div>
            </div>
        </div>
    </div>

    <div id="mask-lift">
        <div id="mask-outer">
            <div id="mask-inner">
                <div id="mask-container"></div>
            </div>
        </div>
    </div>

    <huxley:changeLicense/>

<script type="text/javascript">
    var uvOptions = {};
    (function() {
        var uv = document.createElement('script'); uv.type = 'text/javascript'; uv.async = true;
        uv.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'widget.uservoice.com/rCrNrtS8TsDPDG6jwK6mg.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(uv, s);
    })();
</script>
<r:layoutResources />

<div id="huxley-contact" class="modal">
    <h3><g:message code="verbosity.sendMessage"/></h3>
    <hr>
    <div class="box-content">
        <g:textArea id="contact-message" name="contact-message" rows="15" cols="70"></g:textArea>
    </div>
    <div class="box-content buttons-bar">
        <a id="contact-message-send" class="button" href="javascript:void(0);"><g:message code="verbosity.send"/></a>
        <a id="contact-message-cancel" class="button" href="javascript:void(0);"><g:message code="verbosity.cancel"/></a>
    </div>
</div>
</body>
</html>
