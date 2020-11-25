<%@ page import="com.thehuxley.util.HuxleyProperties; org.apache.shiro.SecurityUtils"%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>TheHuxley</title>
    <link rel="icon" type="image/vnd.microsoft.icon" href="${resource(dir:'images', file:'favicon.ico')}" />
    <link rel="shortcut icon" type="image/x-icon" href="${resource(dir:'images', file:'favicon.ico')}" />
    <link rel="shortcut icon"  type="image/x-icon" />
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'huxley.css')}" type="text/css">

    <link href="${resource(dir:'css', file:'reset.css')}" type="text/css" rel="stylesheet"   media="all"/>
    <link href="${resource(dir:'css', file:'main.css')}" type="text/css" rel="stylesheet"  media="all" />
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
    <script src="${resource(dir:'js', file:'jquery.tools.min.js')}"></script>
    <script src="${resource(dir:'js', file:'swfobject.js')}"></script>
    <script src="${resource(dir:'js', file:'videolightbox.js')}"></script>
    <script src="${resource(dir:'js', file:'slideshow.js')}"></script>


    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <meta name="keywords" content="programação,objetivo,umbel,aprendizado" />
    <meta name="description" content="${message(code:'verbosity.description')}" />



    <script type="text/javascript">

        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-31438174-1']);
        _gaq.push(['_trackPageview']);

        (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();

    </script>
</head>



<body id="landingpage">
    <script type="text/javascript">
        function onYouTubePlayerReady(playerId) {
            ytplayer = document.getElementById("video_overlay");
            ytplayer.setVolume(100);
        }
    </script>

    <div class="wrapper">
        <div id="logo"><!-- Logo -->
            <a href="#" target="_self"><img src="${resource(dir: 'images/landingpage', file: 'logo.png')}" width="136px" height="25px" border="0" alt="Logo" /></a>
        </div>
    </div>
    <div class="clear"></div>
    <div id="panel"><!-- Panel -->
        <div class="wrapper">
            <div id="preview"><!-- Preview box -->
                <script type="text/javascript">
                    if (!window.slider)
                        var slider={};
                    slider.data=[
                        {"id":"slide01","client":"","desc":""},
                        {"id":"slide02","client":"","desc":""}
                    ];
                </script>
                <div id="slide-holder">
                    <div id="slide-runner">
                        <img id="slide01" src="${resource(dir: 'images/landingpage/slide', file: '01.jpg')}" width="370px" height="320px" border="0" alt="Slide #01" class="slide" />
                        <img id="slide02" src="${resource(dir: 'images/landingpage/slide', file: '01.jpg')}" width="370px" height="320px" border="0" alt="Slide #02" class="slide" />
                        <div id="slide-controls">
                            <p id="slide-nav"></p>
                        </div>
                    </div>
                </div>
            </div>
        <div id="login">
            <h3><g:message code="auth.user.info"/></h3>
        <g:form action="saveUser">
            <input type="hidden" name="targetUri" value="${targetUri}" />


                    <input type="text" name="name" value="${shiroUserInstance?.name}" style="width: 90%;" placeholder="${message(code:'verbosity.name')}" class="ui-input"/>
                    <input type="text" name="email" value="${shiroUserInstance?.email}" style="width: 90%;" placeholder="${message(code:'verbosity.email')}" class="ui-input"/>
                    <input type="text" name="username" value="${shiroUserInstance?.username}" placeholder="${message(code:'verbosity.username')}" style="width: 90%;" class="ui-input"/>
                    <input type="password" name="password" value="" placeholder="${message(code:'verbosity.password')}" style="width: 90%;" class="ui-input"/>
                    <input type="password" name="rPassword" value="" placeholder="${message(code:'verbosity.repeat.password')}" style="width: 90%;" class="ui-input"/>
                <g:hiddenField name="l" value="${l}" />
                    <input type="submit" value="Cadastrar" class="ui-gbutton" />
            <g:if test="${flash.message}">
                <div class="message" style="color: red;">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${shiroUserInstance}">
                <div class="errors"  style="color: red;" ><g:renderErrors bean="${shiroUserInstance}"	as="list" /></div>
            </g:hasErrors>
        </g:form>
            </div>
        </div>
    </div>
    <div class="clear"></div>
    <div id="social"><!-- Social -->
        <div class="wrapper">
            <div class="content">
                <h3><a href="https://twitter.com/the_huxley" target="_blank"><span>@</span>the_huxley</a></h3>
                <p><iframe src="http://s1.rsspump.com/rss.aspx?s=1616231f-a63e-424c-97b9-523f5ae6d067&amp;speed=1&amp;t=0&amp;d=1&amp;u=0&amp;p=0&amp;b=0&amp;ic=6&amp;font=Arial&amp;fontsize=13px&amp;bgcolor=&amp;color=9C9A9A&amp;type=fade&amp;su=0&amp;sub=0&amp;sw=0" frameborder="0" width="100%" height="17" scrolling="no" allowtransparency="true"></iframe></p>
            </div>
        </div>
    </div>
    <div class="clear"></div>
    <div id="content"><!-- Content -->
        <div class="header">
            <h3>${message(code:'verbosity.advantages')}</h3>
            <p id="videogallery">${message(code:'verbosity.tour.part1')} <a rel="#voverlay" href="http://www.youtube.com/v/Wtc_6W2o9jI?autoplay=1&rel=0&enablejsapi=1&playerapiid=ytplayer" class="ui-gbutton">${message(code:'verbosity.tour.part2')}</a></p>
        </div>
        <div class="right"><!-- Right Content -->
            <huxley:topCoder positionAfter="true" max="5"/>
        </div>
        <div class="left"><!-- Left Content -->
            <div class="box" style="margin-right: 65px;"><!-- Teacher box -->
                <img src="${resource(dir: 'images/landingpage', file: 'p01.png')}" width="165px" height="200px" border="0" />
                <h3>${message(code:'verbosity.advantage.for.teacher.part1')} <span>${message(code:'verbosity.advantage.for.teacher.part2')}</span></h3>
                <p>${message(code:'verbosity.advantage.for.teacher.part3')}</p>
            </div>
            <div class="box" style="margin-right: 65px;"><!-- Student box -->
                <img src="${resource(dir: 'images/landingpage', file: 'p02.png')}" width="165px" height="200px" border="0" />
                <h3>${message(code:'verbosity.advantage.for.student.part1')} <span>${message(code:'verbosity.advantage.for.student.part2')}</span></h3>
                <p>${message(code:'verbosity.advantage.for.student.part3')}</p>
            </div>
            <div class="box"><!-- Institution box -->
                <img src="${resource(dir: 'images/landingpage', file: 'p03.png')}" width="165px" height="200px" border="0" />
                <h3>${message(code:'verbosity.advantage.for.institution.part1')} <span>${message(code:'verbosity.advantage.for.institution.part2')}</span></h3>
                <p>${message(code:'verbosity.advantage.for.institution.part3')}</p>
            </div>
        </div>
        <hr />
    </div>
    <div class="clear"></div>
    <div id="footer"><!-- Footer -->
        <div class="right">
            <a href="#" target="_self">${message(code:'verbosity.privacy.policy')}</a> -
            <a href="#" target="_self">${message(code:'verbosity.contact')}</a>
        </div>
        <img src="${resource(dir: 'images', file:  'footer-logo.png')}" width="84px" height="17px" border="0" alt="Footer Logo" />
        <span>&copy; 2012 TheHuxley.com</span>
    </div>
</body>
</html>
