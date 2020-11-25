<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script type="text/javascript">
        var lessonSearchInputTimeOut;
        var limit = 5;
        var offset = 0;

        $(function() {

            huxley.generatePagination('course-pagination', getResults, limit, ${total});
            $('#content-search-input').keyup(function() {
                clearTimeout(lessonSearchInputTimeOut);
                lessonSearchInputTimeOut = setTimeout(function() {
                    getResults(offset);
                }, 1000);
            });
        });

        function getResults(offset) {
            $.ajax({
                url: '${resource(dir: '/')}content/ajxGetContentList',
                data: {k: $('#content-search-input').val(), offset: offset, max: limit},
                dataType: 'json',
                success: function (data) {
                    populateResult(data);
                    if(offset == 0 ){
                        huxley.generatePagination('course-pagination', getResults, limit, ${total});
                    }
                }
            });
        };

        function populateResult(data) {
            console.log(data);
            $('#result').empty();
            $.each(data.contents, function (i, content) {
                $('#result').append(
                    '<tr>' +
                    '   <td>' +
                    '       <span class="title">' +
                    '           <a href="${resource(dir: '/')}content/show/' + content.id + '">' + content.title + '</a>' +
                    '           <br>' +
                    '           <i class="description">' +
                    '               <g:message code="verbosity.createBy" />' +
                    '               <a class="userlink" href="${resource(dir: '/')}profile/show/=' + content.ownerHash + '">' + content.ownerName + '</a>' +
                    '               <g:message code="verbosity.updatedAt" />' +
                    '               <span class="date">' + content.lastUpdatedDate + '</span>' +
                    '               ' + content.lastUpdatedHour +
                    '           </i>' +
                    '       </span>' +
                    '       <br>' +
                    '       <br>' +
                    '       <span class="desc">' + content.description + '</span>' +
                    '   </td>' +
                    '</tr>'
                );
            });
        };
    </script>
</head>
<body>
    <div class="box">
        <h3><g:message code="content.list"/></h3>
        <g:form controller="content" action="getContentList">
            <input id="content-search-input" name="title" autocomplete="off" type="text" value="${k}" style="width: 97%;" class="ui-input" placeholder="${g.message(code: 'verbosity.type.content')}" />
        </g:form>
    </div>

    <hr />
    <br />
    <huxley:contents contents="${contents}" max="5" />
</div>

</body>
</html>