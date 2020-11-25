<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script type="text/javascript">
        var limit = 10;
        var order = ''
        var sort = '';
        var imagePath = '';
        var currentImg = '';
        function setSort(value, img) {
            'use strict';
            if (imagePath.length === 0 ) {
                imagePath = document.getElementById('img-' + img).src.substring(0, document.getElementById('img-' + img).src.indexOf('_') + 1);
            }

            if (sort === value) {
                order = (order === 'desc') ? 'asc' : 'desc';
            } else {
                order = 'desc';
                if (sort.length !== 0) {
                    document.getElementById('img-' + currentImg).src = imagePath + 'none.gif';
                }
            }
            sort = value;
            currentImg = img;
            document.getElementById('img-' + currentImg).src = imagePath + order + '.gif';
            getProblem(0);
        };
        function getProblem(index){
            var offset = index * limit;
            var data =  'offset=' + offset + '&max='+limit + '&order=' + order + '&sort=' + sort + '&nameParam=' + $('#input-problem').val() + '&status=' + $("#status-list").val();
            <g:if test="${session.license.isAdmin()}">
            data += '&userNameParam=' + $('#input-user').val();
            </g:if>
            $.ajax({
                url: huxley.root + 'problem/search',
                async: true,
                data: data,
                dataType: 'json',
                type: 'POST',
                success: function(data) {
                    var toAppend = '';
                    $('#problem-list').empty();
                    $.each(data.problems, function(i, problem) {
                        var color = '';
                        color = (i%2==0? 'style="background-color:#f4f4f4;"'  : '');
                        var infoColor = '';
                        infoColor = (i%2==0? 'style="background-color:#f4f4f4;display:none;"'  : 'style="display:none;"');
                        toAppend+='<tr ' + color +'>' +
                                '<td style="text-align: center;"><a href="' + huxley.root + 'problem/show/' + problem.id + '">';
                        if(problem.name.length > 18){
                            toAppend+= problem.name.substring(0,15) + '...';
                        }else{
                            toAppend+= problem.name;
                        }
                        toAppend+='</a></td>'+
                                '<td style="text-align: center;">' + problem.dateSuggest + '</td>'+
                                <g:if test="${session.license.isAdmin()}">
                                '<td style="text-align: center;"><a href="' + huxley.root + 'profile/show?user='+ problem.userSuggestId +'">' + problem.userSuggest + '</a></td>'+
                                </g:if>
                                '<td style="text-align: center;" id="evaluation-' + problem.id + '">' + problem.status + '</td>'+
                                '<td style="text-align: center;"><a href="' + huxley.root + 'problem/create/' + problem.id + '"><img src="/huxley/images/icons/edit.png" style="width:16px; height:19px; border:0;" /></a></td>'+
                                '</tr>';
                    });

                    if(offset == 0){
                        huxley.generatePagination('problem-pagination',getProblem,10,data.total);
                    }

                    $('#problem-list').append(toAppend);
                }
            });
        };
        $(function() {
            setSort('p.dateCreated','date');
            $('#input-problem').keyup(function() {
                clearTimeout(problemSearchInputTimeOut);
                problemSearchInputTimeOut = setTimeout(function() {
                    getProblem(0);
                }, 1000);
            });
            $('#input-user').keyup(function() {
                clearTimeout(problemSearchInputTimeOut);
                problemSearchInputTimeOut = setTimeout(function() {
                    getProblem(0);
                }, 1000);
            });
        });
        var problemSearchInputTimeOut;
    </script>


</head>
<body>
    <div id="app-content">
        <huxley:management/>
    </div>
</body>
</html>
