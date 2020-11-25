<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'huxley-course.js')}"></script>
    <script type="text/javascript">
        var lessonSearchInputTimeOut;
        var limit = 10;
        var offset = 0;

        $(function() {

            huxley.generatePagination('course-pagination', getResults(offset), limit, ${total});
            $('#course-search-input').keyup(function() {
                clearTimeout(lessonSearchInputTimeOut);
                lessonSearchInputTimeOut = setTimeout(function() {
                    getResults(offset);
                }, 1000);
            });
        });

        function getResults(offset) {
            $.ajax({
                url: '${resource(dir: '/')}course/ajxGetCourseList',
                data: {k: $('#course-search-input').val(), offset: offset},
                dataType: 'json',
                success: function (data) {
                    populateResult(data);
                }
            });
        };

        function populateResult(data) {
            $('#result').empty();
            $.each(data, function (i, course) {
                $('#result').append(
                    '<tr>' +
                    '   <td>' +
                    '       <span class="title">' +
                    '           <a href="${resource(dir: '/')}course/show/' + course.id + '">' + course.title + '</a>' +
                    '           <br>' +
                    '           <i class="description">' +
                    '               <g:message code="verbosity.createBy" />' +
                    '               <a class="userlink" href="${resource(dir: '/')}profile/show/=' + course.ownerHash + '">' + course.ownerName + '</a>' +
                    '               <g:message code="verbosity.updatedAt" />' +
                    '               <span class="date">' + course.lastUpdatedDate + '</span>' +
                    '               ' + course.lastUpdatedHour +
                    '           </i>' +
                    '       </span>' +
                    '       <br>' +
                    '       <br>' +
                    '       <span class="desc">' + course.description + '</span>' +
                    '   </td>' +
                    '   <td>' +
                    '       <div class="progress-bar">' +
                    '           <span class="current-progress-number">' + course.progress + '%</span>' +
                    '           <div class="current-progress" style="width: ' + course.progress + '%;"></div>' +
                    '       </div>' +
                    '   </td>' +
                    '</tr>'
                );
            });
        };
    </script>
</head>
<body>
    <div class="box"><!-- Courses box -->
        <h3><g:message code="course.list"/><g:if test="${!session.license.isStudent()}"><g:link action="index" controller="content"  class="ui-bbutton"><g:message code="content.list" /></g:link></g:if></h3>
        <g:form controller="course" action="getCourseList">
            <input id="course-search-input" name="title" autocomplete="off" type="text" value="${k}" style="width: 97%;" class="ui-input" placeholder="${g.message(code: 'verbosity.TypeCourse')}" />
        </g:form>
    </div>

    <hr />
    <br />
    <huxley:courses lessons="${lessons}" max="20" />
</div>

</body>
</html>