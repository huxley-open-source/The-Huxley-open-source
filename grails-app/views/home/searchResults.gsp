<%@ page import="com.thehuxley.Profile" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <script type="text/javascript">
        var max = 10;
        <g:if test="${profileCount > 10}">
        $(function() {
            huxley.generatePagination('profile-pagination',getProfile,10,${profileCount});
        });
        function getProfile(index){
            var offset = index * max;
            $.ajax({
                url: huxley.root + 'home/searchProfileAjax',
                async: true,
                data: 'offset=' + offset + '&max='+max + '&ss=${name}',
                dataType: 'json',
                success: function(data) {
                    $('#searchResults-suggestion-user').empty();
                    $('#searchResults-suggestion-user').append(data.content);
                }
            });
        }
        </g:if>
        <g:if test="${problemCount > 10}">
        $(function() {
            huxley.generatePagination('problem-pagination',getProblem,10,${problemCount});
        });
        function getProblem(index){
            var offset = index * max;
            var toAppend = "";
            $.ajax({
                url: huxley.root + 'home/searchProblemAjax',
                async: true,
                data: 'offset=' + offset + '&max='+max + '&ss=${name}',
                dataType: 'json',
                success: function(data) {
                    $('#searchResults-suggestion-problem').empty();
                    $.each(data.problemList, function(i, problem) {
                        toAppend+='<a class="search-suggestion-problem-box" href="${resource(dir:'/')}problem/show?id=' + problem.id + '">' + problem.name + '</a>';
                    });
                    $('#searchResults-suggestion-problem').append(toAppend);
                }
            });
        }
        </g:if>

    </script>
</head>
<body>

<g:if test="${profileCount == 0 && problemCount == 0}">
    <div style="width: 100%; padding: 5px; color: #666; font-size: 17px; font-weight: bold;"><g:message code="main.search.empty"/></div>
</g:if>
<g:else>
    <g:if test="${profileCount != 0}">
        <div class="box">
            <div id="searchResults-suggestion-user-title" style="width: 100%; padding: 5px; color: #666; font-size: 17px; font-weight: bold;"><g:message code="main.search.user"/></div>
            <div id="searchResults-suggestion-user">
                <g:each in="${profiles}" var="profile">
                    <huxley:user class="search-suggestion-user-box" profile="${profile}">${profile.name}</huxley:user>

                </g:each>

            </div>
            <div class="ui-pagination" id="profile-pagination" style="float:none;text-align: center; margin: 0px;"></div>
        </div>
        <hr>
        <br>

    </g:if>
    <g:if test="${problemCount != 0}">
        <div class="box">
            <div id="searchResults-suggestion-problem-title" style="width: 100%; padding: 5px; color: #666; font-size: 17px; font-weight: bold;"><g:message code="main.search.problem"/></div>
            <div id="searchResults-suggestion-problem">
                <g:each in="${problems}" var="problem">
                    <a class="search-suggestion-problem-box" href="${resource(dir:'/')}problem/show?id=${problem.id}">${problem.name}</a>
                </g:each>


            </div>
            <div class="ui-pagination" id="problem-pagination" style="float:none;text-align: center; margin: 0px;"></div>
        </div>
    </g:if>
</g:else>


</body>
</html>
