<%--
  Created by IntelliJ IDEA.
  User: karla
  Date: 17/03/14
  Time: 09:11
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <style>

        .tip-container-box {
            border: 1px #928E8E solid;
            border-radius: 5px;
            width: 900px;

        }
        .test-case-container {
            min-height: 150px;
        }
        .test-case-container span {
            padding-left: 5px;
            display: inline-block;
        }

        .tip-container {
            height: 92px;
        }
        .title {
            font-weight: bold;
            background: white;
            margin-top: -10px;
            margin-left: 5px;
            padding: 0px 5px 0px 5px;
            color: #424242;
        }
        .title-modal {
            font-weight: bold;
            font-size: 20px;
            width: 100px;
            padding: 10px 1px 6px 6px;
        }
        .tip-text {
            font-size: 13px;
            font-family: Arial;
            width: 898px;
            height: 80px;
            border: none;
        }

        .tip-status {
            color: red;
            margin-bottom: 11px;
            text-align: center;
        }

    </style>
    <script src="${resource(dir:'css', file:'huxley.css')}"></script>
    <script src="${resource(dir:'css', file:'ui.css')}"></script>
    <script type="text/javascript">
         var searchTextInputTimeOut;
         var selectedIndexMainSearch = -1;
         var totalIndexMainSearch = -1;
         $(function() {
             $('#input-tip').keyup(function(event) {
                 var valueInput = $(this).val();
                 clearTimeout(searchTextInputTimeOut);
                 searchTextInputTimeOut = setTimeout(function() {

                     if(!(totalIndexMainSearch != -1 && (event.keyCode==40||event.keyCode==38||event.keyCode==13))){
                         if (valueInput != '') {

                             $.ajax({
                                 url: '/huxley/tip/searchProblem',
                                 data: 'ss=' + valueInput,
                                 dataType: 'json',
                                 type: 'POST',
                                 success: function(data) {
                                     selectedIndexMainSearch = -1;
                                     $('#search-suggestion-problem-tip').empty();
                                     totalIndexMainSearch = 0;
                                     $.each(data.problemList, function(i, problem) {
                                         $('#search-suggestion-problem-tip').append(
                                                 '<a class="search-suggestion-problem-box" href="javascript:void(0)" onclick="showProblem(' + problem.id + ')" onmouseover="selectSearchOption('+totalIndexMainSearch+')" id="main-search-'+totalIndexMainSearch+'">' + problem.name + '</a>'
                                         );
                                         totalIndexMainSearch++;
                                     });


                                     totalIndexMainSearch--;
                                     if(totalIndexMainSearch>-1){
                                         selectSearchOption(0);
                                     }

                                     $('#search-suggestion-tip').show().fadeIn('fast');
                                 }
                             });

                             $(document).one("click", function() {
                                 $('#search-suggestion-tip').hide().fadeOut('fast')
                                 selectedIndexMainSearch = -1;
                                 totalIndexMainSearch = -1;
                             });
                         } else {
                             $('#search-suggestion-tip').hide().fadeOut('fast')

                         }

                     }
                 }, 300);
             });
         });

        function showProblem(pId) {

            $('#tip-table').empty().append('<div style="margin: -26px 0px 0px 194px;" id="loading"><p><img src="/huxley/images/icons/loading_icon.gif" /></p></div>');
            var aux, append = '<thead><tr style="background-color:#ffffff;">' +
                                        '<th style="text-align: center; width: 376px;">Problema</th>' +
                                        '<th style="text-align: center">CT/Dica</th>' +
                                        '<th style="text-align: center">Foi util :)</th>' +
                                        '<th style="text-align: center">Não foi útil :(</th>' +
                                        '<th >WA</th> ' +
                                        '<th >PE</th> ' +
                                        '<th >CE</th> ' +
                                        '<th >EA</th> ' +
                                        '<th >RE</th> ' +
                                        '<th >TLE</th></tr></thead><tbody id="tip-list">';


            $.ajax({
                url: '/huxley/tip/searchTestCase',
                data: 'pId=' + pId,
                dataType: 'json',
                type: 'POST',

                success: function(data) {
                    $.each(data.testCaseList, function(i, tc) {
                        aux = '</td><td style="text-align: center">'  + tc.rank + '</td> ' +
                                '<td style="text-align: center">' + tc.unrank + '</td>' +
                                '<td style="text-align: center">' + tc.WA + '</td>'  +
                                '<td style="text-align: center">' + tc.PE + '</td>'  +
                                '<td style="text-align: center">' + tc.CE + '</td>'  +
                                '<td style="text-align: center">' + tc.EA + '</td>'  +
                                '<td style="text-align: center">' + tc.RE + '</td>'  +
                                '<td style="text-align: center">' + tc.TLE + '</td></tr>';
                        if(i%2 == 0) {
                            if(tc.tip == undefined) {
                                append += '<tr style="background-color:#f4f4f4;">' +
                                            '<td><a target="_blank" href="/huxley/problem/show/' + pId + 'target="_blank">' + tc.pName + '</a>' +
                                            '</td><td style="text-align: center"><a href="javascript:void(0);" onclick="openModalEdit(' + tc.tId + ',' + pId + ');">adicionar #' + tc.tId + '</a>' + aux;

                            } else {
                                append += '<tr style="background-color:#f4f4f4;">' +
                                            '<td><a target="_blank" href="/huxley/problem/show/' + pId + '">' + tc.pName + '</a>' +
                                            '</td> <td style="text-align: center"><a href="javascript:void(0);" onclick="openModalEdit(' + tc.tId + ',' + pId + ');"> editar #' + tc.tId + '</a></td>' + aux;
                            }
                        }
                        else {
                            if(tc.tip == undefined) {
                                append += '<tr style="background-color:#ffffff;">' +
                                            '<td><a target="_blank" href="/huxley/problem/show/' + pId + 'target="_blank">' + tc.pName + '</a>' +
                                            '</td><td style="text-align: center" ><a href="javascript:void(0);" onclick="openModalEdit(' + tc.tId + ',' + pId + ');">adicionar #' + tc.tId + '</a></td>' + aux;
                            } else {
                                append += '<tr style="background-color:#ffffff;">' +
                                            '<td><a target="_blank" href="/huxley/problem/show/' + tc.pId + '">' + tc.pName + '</a></td> ' +
                                            '<td style="text-align: center"><a href="javascript:void(0);" onclick="openModalEdit(' + tc.tId + ',' + pId + ')">editar #' + tc.tId + '</a></td>' + aux;
                            }
                        }
                    });
                    append += '</tbody>';
                    $('#tip-table').empty().append(append);
                }
            });
        }

        function showProblemWithTip(sort) {

            if($('#tip-checkbox').is(':checked')) {
                var append, aux;
                $('#tip-table').empty().append('<div style="margin: -26px 0px 0px 194px;" id="loading"><p><img src="/huxley/images/icons/loading_icon.gif" /></p></div>');
                $.ajax({
                    url: '/huxley/tip/searchProblemWithTip',
                    data: 'sort=' + sort,
                    dataType: 'json',
                    type: 'POST',

                    success: function (data){

                        append = '<thead><tr style="background-color:#ffffff;">' +
                                        '<th style="text-align: center; width: 376px;"><a href="javascript:void(0)" onclick="showProblemWithTip(\'problem.name\');">Problema<a></th>' +
                                        '<th style="text-align: center"><a a href="javascript:void(0)" onclick="showProblemWithTip(\'id\');">CT/Dica</a></th>' +
                                        '<th style="text-align: center"><a a href="javascript:void(0)" onclick="showProblemWithTip(\'rank\');">Foi util :)</a></th>' +
                                        '<th style="text-align: center"><a href="javascript:void(0)" onclick="showProblemWithTip(\'unrank\');">Não foi útil :(</a></th>' +
                                        '<th >WA</th> ' +
                                        '<th >PE</th> ' +
                                        '<th >CE</th> ' +
                                        '<th >EA</th> ' +
                                        '<th >RE</th> ' +
                                        '<th >TLE</th></tr></thead><tbody id="tip-list">';

                        $.each(data, function (i, tc) {
                            aux = '<td><a target="_blank" href="/huxley/problem/show/' + tc.pId + '">' + tc.pName + '</a></td> ' +
                                    '<td style="text-align: center"><a href="javascript:void(0);" onclick="openModalEdit(' + tc.tId + ',' + tc.pId + ');"> editar #' + tc.tId + '</a>' +
                                    '</td> <td style="text-align: center">'  + tc.rank + '</td> ' +
                                    '<td style="text-align: center">' + tc.unrank + '</td>' +
                                    '<td style="text-align: center">' + tc.WA + '</td>'  +
                                    '<td style="text-align: center">' + tc.PE + '</td>'  +
                                    '<td style="text-align: center">' + tc.CE + '</td>'  +
                                    '<td style="text-align: center">' + tc.EA + '</td>'  +
                                    '<td style="text-align: center">' + tc.RE + '</td>'  +
                                    '<td style="text-align: center">' + tc.TLE + '</td></tr>';
                            if(i%2 == 0) {
                                append += '<tr style="background-color:#f4f4f4;">' +  aux;

                            }
                            else {
                                append += '<tr style="background-color:#ffffff;">' + aux;
                            }
                        });

                        append += '</tbody>';
                        $('#tip-table').empty().append(append);
                    }

                })

            }
            else {
                $('#tip-table').empty().append('<div style="margin: -26px 0px 0px 194px;" id="loading"><p><img src="/huxley/images/icons/loading_icon.gif" /></p></div>')
                var append = '<thead><tr style="background-color:#ffffff;"><th>Problema </th><th>Dica</th></tr></thead><tbody id="tip-list">';

                $.ajax({
                    url: '/huxley/tip/getProblemList',
                    dataType: 'json',
                    type: 'POST',

                    success: function (data) {

                        $.each(data.problemList, function(i, pl) {
                            if(i%2==0) {
                                append += '<tr style="background-color:#f4f4f4;"><td><a href="/huxley/problem/show/' + pl.id + 'target="_blank">' + pl.name + '</a></td><td><a href="javascript:void(0);" onclick="openModalTC(' + pl.id + ');">adicionar</a></td></tr>';
                            }
                            else {
                                append += '<tr style="background-color:#ffffff;"><td><a href="/huxley/problem/show/' + pl.id + 'target="_blank">' + pl.name + '</a></td><td><a href="javascript:void(0);" onclick="openModalTC(' + pl.id + ');">adicionar</a></td></tr>';
                            }
                        });
                        $('#tip-table').empty().append(append);

                    }
                });
            }
        }

        function openModalEdit(tId, pId) {

            $.ajax({
                url: '/huxley/tip/getTestCaseByProblem',
                data: 'pId=' + pId + '&tId=' + tId,
                dataType: 'json',
                type: 'POST',

                success: function (data) {
                     if(data.testCase.tip == null){
                         data.testCase.tip = '';
                     }

                    var append = '<div class="tip-modal-container"><div class="tip-status tip-status-' + tId + '"></div><a href="javascript:huxley.closeModal()" class="close" style="font-size: 22px; font-weight: bold; color: grey; text-decoration: none">×</a><div class="clear"></div><br>' +
                            '<div class="test-case-container tip-container-box"><h3 class="title" style="width: 180px;">Caso de Teste #' + tId+ '</h3><div class="title-modal">Entrada</div><span>'+ data.testCase.input + '</span>' + '<div class="title-modal">Saida</div><span>' + data.testCase.output + '</span><br></div><br>'  +
                            '<div class="tip-container tip-container-box"><h3 class="title" style="width: 50px">Dica</h3>' +
                            '<textarea class="tip-text" style="font-size: 12px">' + data.testCase.tip + '</textarea><div class="clear"></div></div>' +
                            '<div style="float:right"><ul><li><a class="button" style="background-color:#6db60a; margin: 3px -1px 0px 0px;"  href="javascript:void(0);" onclick="saveTip(' + tId + ','  + pId + ')">Salvar</a></li></ul></div><br></div>';

                    $('#modal-edit-tip').empty().append(append);
                    huxley.openModal('modal-edit-tip')
                }

            });

        }

        function openModalTC(pId) {

            var append, i=0;
            $('#modal-add-tip').empty();
            $.ajax({
                url: '/huxley/tip/getAllTestCaseByProblem',
                data: 'pId=' + pId,
                dataType: 'json',
                type: 'POST',

                success: function (data) {
                    append = '<span style="color: #878787; font-size: 20px;"> ' + data.testCaseList[0].pName + '</span><a href="javascript:huxley.closeModal()" class="close" style="font-size: 22px; font-weight: bold; color: grey; text-decoration: none">×</a><hr>';
                    for(i; i < data.testCaseList.length; ++i) {
                        append += '<div class="tip-modal-container-' + data.testCaseList[i].tId + '"><br><div class="tip-status tip-status-' + data.testCaseList[i].tId + '"></div>' +
                                '<div class="test-case-container tip-container-box"><h3 class="title" style="width: 180px;">Caso de Teste #' + data.testCaseList[i].tId + '</h3><div class="title-modal">Entrada</div><span>'+ data.testCaseList[i].input + '</span>' + '<div class="title-modal">Saida</div><span>' + data.testCaseList[i].output + '</span><br></div><br>' +
                                '<div class="tip-container tip-container-box"><h3 class="title" style="width: 50px">Dica</h3> <textarea class="tip-text" placeholder="Clique aqui para escrever uma dica...."></textarea><div class="clear"></div></div>' +
                                '<div style="float:right"> <ul><li><a class="button" style="background-color:#6db60a; margin: 3px -1px 0px 0px;" href="javascript:void(0);" onclick="saveTip(' + data.testCaseList[i].tId + ','  + pId + ')">Salvar</a></li></ul></div><br></div></div>';

                    }
                    $('#modal-add-tip').append(append);
                    huxley.openModal('modal-add-tip');
                }
            });

        }



        function saveTip(tId, pId) {

           var tipText = $('.tip-text').val()
           if(tipText != '') {
               $.ajax({
                   url: '/huxley/tip/saveTip',
                   data: 'tt=' + tipText + '&tId=' + tId + '&pId=' + pId,
                   dataType: 'json',
                   type: 'POST',
                   success : function (data) {
                       if(data.status == 'ok'){
                            $('.tip-status-' + tId).empty().append('Dica adicionada com sucesso!')
                       } else {
                           $('.tip-status-' + tId).empty().append('Tente Novamente!')
                       }
                   }
               })
           }
        }



    </script>
</head>
<body>

<div class="tip-box" style="background: white">

    <h3 style="font-size: 15px; margin: -10px 0px -5px 9px;">Lista de Problemas</h3>
    <input type="text" name="dicas" placeholder="Digite o nome do problema..." style="width: 50%; float: left; margin: 17px 0px 12px 9px;" class="ui-input" id="input-tip"/>
    <div id="search-suggestion-tip" style="display: none; border: 1px solid #272B31; background: #F6F6F6; z-index: 30; width: 371px; box-shadow: 0px 3px 7px #333; position: absolute; margin-top: 45px; margin-left: 10px;">
        <div id="search-suggestion-problem-tip"></div>
    </div>

    <div id="filter-form-tip" style="display:inline-block; margin: 16px 0px 1px 10px;">
        <span class="tip-problem">Problemas com dicas: </span>
        <div style="display: inline-block;margin: -13px 0px 1px 140px;position: absolute;"><input type="checkbox" id="tip-checkbox" onclick="showProblemWithTip('unrank')"/></div>
    </div>
    <hr>
    <table id="tip-table">
        <thead>
            <tr style="background-color:#ffffff;">
                <th>Problema</th>
                <th>Dica</th>
            </tr>
        </thead>
        <tbody id="tip-list">
            <g:each status="i" in="${problemList}"  var="it">
                <g:if test="${i%2==0}">
                    <tr style="background-color:#f4f4f4;">
                        <td><a href="/huxley/problem/show/${it.id}" target="_blank">${it}</a></td>
                        <td><a href="javascript:void(0);" onclick="openModalTC('${it.id}');">adicionar</a></td>
                    </tr>
                </g:if>
                <g:else>
                    <tr style="background-color:#ffffff;">
                        <td><a href="/huxley/problem/show/${it.id}" target="_blank">${it}</a></td>
                        <td><a href="javascript:void(0);" onclick="openModalTC('${it.id}');">adicionar</a></td>
                    </tr>
                </g:else>
            </g:each>
        </tbody>
    </table>
</div>

<div id="modal-add-tip" ></div>
<div id="modal-edit-tip" ></div>


</body>
</html>