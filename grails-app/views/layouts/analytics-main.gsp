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
    <link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
    <link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'reset.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'huxley.css')}" type="text/css">

    <g:javascript library="jquery" plugin="jquery"/>
    <r:require module="jquery-ui"/>
    <r:layoutResources />

    <script src="${resource(dir:'js', file:'huxley.js')}"></script>
    <script src="${resource(dir:'js', file:'huxley-main.js')}"></script>
    <script src="${resource(dir:'js', file:'jquery.jscrollpane.min.js')}"></script>
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
        });
    </script>
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
            </div>
        </div>
    </div>



    <div class="clear"></div>
<!-- Main menu -->
    <div id="main-menu">
        <ul>
            <li>
                <a href="javascript:huxleyAnalytics.changeContext('submission')" id="submission-button" class="menu-button submission-button" >
                    <div class="menu-icon">
                        <div id="submission-icon"></div>
                    </div>
                    <div class="label">${message(code:'entity.submissions')}</div>
                    <div class="line" id="submission-line"></div>
                </a>
            </li>

            <li>
                <a href="javascript:huxleyAnalytics.changeContext('topic')" class="menu-button topic-button" id="topic-button">
                    <div class="menu-icon">
                        <div id="topic-icon"></div>
                    </div>
                    <div class="label">${message(code:'entity.topics')}</div>
                    <div class="line" id="topic-line"></div>
                </a>
            </li>

            <li>
                <a href="javascript:huxleyAnalytics.changeContext('language')" id="language-button" class="menu-button course-button" >
                    <div class="menu-icon">
                        <div id="language-icon"></div>
                    </div>
                    <div class="label">${message(code:'entity.languages')}</div>
                    <div class="line" id="language-line"></div>
                </a>
            </li>
        </ul>
    </div>
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
        <div class="wrapper" id="analytics-wrapper">
            <div class="header"><!-- Last Access & Breadcrumb -->
                <div class="breadcrumb">
                    <b><a href="home.html" target="_self">The Huxley</a> / Home</b>
                </div>
                <hr />
            </div>
                <g:layoutBody />
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

<script type="text/javascript">
    var uvOptions = {};
    (function() {
        var uv = document.createElement('script'); uv.type = 'text/javascript'; uv.async = true;
        uv.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'widget.uservoice.com/rCrNrtS8TsDPDG6jwK6mg.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(uv, s);
    })();
</script>
<r:layoutResources />
</body>
</html>