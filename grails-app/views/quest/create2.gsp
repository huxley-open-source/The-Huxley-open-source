<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main" />
    <script src="${resource(dir:'js', file:'huxley-problem.js')}"></script>
    <script src="<g:resource dir="js" file="underscore-min.js"/>" type="text/javascript"></script>
    <script src="${resource(dir:'js', file:'mustache.min.js')}"></script>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'problem-accordion.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'problem.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'huxley.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'reset.css')}" type="text/css">



    <script type="text/javascript">
        var lvlMin = 1;
        var lvlMax = 10;
        $(function() {
            $('#questionnaire-save').click(function() {
                $('#selectedProblems').val(JSON.stringify(huxleyProblem.getSelectedProblems()));
                $('#questionnaire-save-problem').submit();
            });
        });
        function setMinLvl(value){
            lvlMin = value;
        }
        function setMaxLvl(value){
            lvlMax = value;
        }
        $(function () {
            'use strict';
            huxleyProblem.setChangeFunction(huxley.problemSelectionSearch);
            huxleyTopic.setChangeFunction(huxley.problemSelectionSearch);
            huxley.createSlider('topic-slider-range','minamount','maxamount',1,10,huxleyProblem.setNdMin,huxleyProblem.setNdMax);
            huxley.problemAccordionTimeOut = null;
            huxley.problemSelectionSearch();
                    $('#input-problem').keyup(function () {
                clearTimeout(huxley.problemAccordionTimeOut);

                huxley.problemAccordionTimeOut = setTimeout(function () {
                    huxley.problemSelectionSearch();
                }, 800);
            });
        });

        $.ajax({
            url: '/huxley/quest/getQuestionnaireProblemByMongo',
            data: {id: ${questionnaireInstance?.id}},
            dataType: 'json',
            cache: false,
            assync:false,
            success: function (data) {
                var toAppend = "";
                        $.each(data, function(i, problem) {
                    toAppend += huxleyProblem.createProblemBox(problem,groupList);
                            $('div#problem-list').append(toAppend);
                    huxleyProblem.selectProblem(problem.id, problem.score);
                });
                        $('div#problem-list').append(toAppend);
            }

        });

        huxley.problemSelectionLine = 0;
        var groupList = '${questionnaireInstance?.groups?.id}';
        huxley.problemSelectionSearch = function () {
            'use strict';
            huxley.problemSelectionLine++;
            var ticket = huxley.problemSelectionLine;
            setTimeout(function() {
                if(huxley.problemSelectionLine == ticket){
                    $.ajax({
                        url: '/huxley/problem/searchByMongo',
                        beforeSend: huxley.showLoading(),
                        data: {name: $('#input-problem').val(), ndMin: huxleyProblem.ndMin, ndMax: huxleyProblem.ndMax, topicsAccepted: huxleyTopic.selectedId,topicsRejected: huxleyTopic.rejectedIdList},
                        dataType: 'json',
                        Type: 'POST',
                        assync:false,
                        success: function (data) {
                            var toAppend = '';
                            console.log(huxleyProblem.selectedProblems);
                            $.each(data.resultSet, function(i, problem) {
                                if(huxleyProblem.selectedProblems.indexOf(problem.id) == -1){
                                    toAppend += huxleyProblem.createProblemBox(problem,groupList);
                                }
                            });
                            $('div#problem-list').empty();
                            $('div#problem-list').append(toAppend);
                            huxley.hideLoading();


                        }
                    });
                }
            }, 1000);
        };


    </script>
</head>
<body>
    <div class="form-box">
        <h3>${questionnaireInstance.title}</h3>
            <input id="questionnaire-save" type="button" value="${g.message(code:'verbosity.save')}" class="button" style="border: none; float: right;">
            <div style="clear: left;"></div>
    </div>
    <hr class="form-line">
    <g:form name="questionnaire-save-problem" id="${questionnaireInstance.id}" action="saveProblems">
        <g:hiddenField id="selectedProblems" name="selectedProblems" value=""></g:hiddenField>
    </g:form>
    <huxley:problemSelection questionnaire="${questionnaireInstance}" topicFilter="true"/>

    <div id="description-modal-show" class="problem-modal-show"></div>
</body>
</html>
