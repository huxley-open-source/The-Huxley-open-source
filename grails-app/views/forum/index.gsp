<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'huxley-forum.js')}"></script>
    <script src="${resource(dir:'js', file:'huxley-pagination-wi.js')}"></script>
    <script type="text/javascript">
        $(function() {
            huxleyForum.getForum();
            huxleyPaginationWI.createPagination('forum-pagination',huxleyForum.getForum,20);
            huxleyForum.testForumVisibility();
        });

    </script>
</head>
<body>

<hr /><br />
<div id="opened-topics">

</div>
<div id="forum-pagination" ></div>
<div class="clear"></div><br />
</body>
</html>