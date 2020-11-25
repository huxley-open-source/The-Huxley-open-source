<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main-head" />
    <script type="text/javascript">
        $(function () {
            $('p#test').append(new EJS({url: '/huxley/templates/problem-counter.ejs'}).render({name: 'marcio'}));
        });
    </script>
</head>
<body>
    <table class="table">

    </table>
</body>
</html>