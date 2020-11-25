var huxleyProblem = huxleyProblem || {};
var huxley = huxley || {};
var addProblem = 0;

huxleyProblem.limit = 0;
huxleyProblem.userId = 0;

huxleyProblem.setValues = function (limit) {
    'use strict';
    huxleyProblem.limit = limit;
};

huxleyProblem.name = '';
huxleyProblem.ndMax = 10;
huxleyProblem.ndMin = 1;
huxleyProblem.includeAccepted = true;
huxleyProblem.selectedId = [];
huxleyProblem.selectedCount = 0;
huxleyProblem.initArg = 0;
huxleyProblem.selectedId = [];
huxleyProblem.selectedCount = 0;

huxleyProblem.changeFunction = function () {
    'use strict';
};

huxleyProblem.setChangeFunction = function (newFunction, initArg) {
    'use strict';
    huxleyProblem.initArg = initArg;
    huxleyProblem.changeFunction = newFunction;
};

huxleyProblem.setName = function (value) {
    'use strict';
    huxleyProblem.name = value;
    huxleyProblem.changeFunction(huxleyProblem.initArg);
};

huxleyProblem.setIncludeAccepted = function (value) {
    'use strict';
    huxleyProblem.includeAccepted = value;
    huxleyProblem.changeFunction(huxleyProblem.initArg);
};

huxleyProblem.setNdMax = function (value) {
    'use strict';
    huxleyProblem.ndMax = value;
    huxleyProblem.changeFunction(huxleyProblem.initArg);
};

huxleyProblem.setNdMin = function (value) {
    'use strict';
    huxleyProblem.ndMin = value;
    huxleyProblem.changeFunction(huxleyProblem.initArg);
};

huxleyProblem.indexProblemList = [];

huxleyProblem.getProblemList = function (index) {
    'use strict';
    var offset = index * huxleyProblem.limit;
    $.ajax({
        url: huxley.root + 'problem/search',
        data: 'nameParam=' + huxleyProblem.name + '&resolved=' + huxleyProblem.includeAccepted + '&max=' + huxleyProblem.limit + '&ndMax=' + huxleyProblem.ndMax + '&ndMin=' + huxleyProblem.ndMin + '&topics=' + huxleyProblem.selectedId + '&topicsCount=' + huxleyProblem.selectedCount + '&offset=' + offset,
        async: true,
        dataType: 'json',
        success: function (data) {
            $('#accordion').empty();

            $.each(data.problems, function (i, problem) {
                $('#accordion').append(huxley.createProblemAccordionItem(problem));
            });
            if(offset == 0){
                huxley.generatePagination('problem-pagination',huxleyProblem.getProblemList,huxleyProblem.limit,data.total);
            }
            huxleyProblem.getPendingSubmission();
            huxley.accordion('accordion', {
                onOpen: function (element) {

                    $.each(huxleyProblem.problemReevaluating, function (i, id) {
                        huxley.setProblemWaiting('title-problem-' + id);
                    });

                    $.each(data.labels.tried, function (i, id) {
                        if(huxleyProblem.problemReevaluating.indexOf(id) == -1){
                            huxley.setProblemWrong('title-problem-' + id);
                        }
                    });

                    $.each(data.labels.correct, function (i, id) {
                        if(huxleyProblem.problemReevaluating.indexOf(id) == -1){
                            huxley.setProblemCorrect('title-problem-' + id);
                        }
                    });
                    if($(element).attr('data') != undefined){
                        $.ajax({
                            url: '/huxley/problem/ajxGetProblemContent',
                            data: {id: $(element).attr('data')},
                            dataType: 'json',
                            success: function (data) {
                                huxley.createProblemContent(data.p, data.labels, data.userId);
                            }
                        });

                        huxley.createUploader($(element).attr('data'), 'submit-button-' + $(element).attr('data'));
                    }
                }

            });

        }
    });

};


huxleyProblem.getProblemContent = function (tabIndex) {
    'use strict';
    var problemId = huxleyProblem.indexProblemList[tabIndex];

    $.ajax({
        url: huxley.root + 'problem/getProblemContent',
        data: 'id=' + problemId,
        async: false,
        dataType: 'json',
        success: function (data) {
            var problem = data.p, topics = '';

            $.each(problem.topics, function (i, topic) {
                if (i !== (problem.topics.length - 1)) {
                    topics += '<a href="#" target="_self">' + topic + '</a>, ';
                } else {
                    topics += '<a href="#" target="_self">' + topic + '</a>';
                }
            });
            $("#problem-last-submission-" + tabIndex).empty();
            $("#problem-last-submission-" + tabIndex).append(problem.lastSubmission);
            $("#problem-topic-list-" + tabIndex).empty();
            $("#problem-topic-list-" + tabIndex).append(topics);
            $("#problem-nd-" + tabIndex).empty();
            $("#problem-nd-" + tabIndex).append(problem.nd);
            $("#problem-user-best-time-" + tabIndex).empty();
            $("#problem-user-best-time-" + tabIndex).append(problem.userRecord);
            $("#problem-best-time-" + tabIndex).empty();
            $("#problem-best-time-" + tabIndex).append(problem.record);

            $("#problem-title-modal-" + tabIndex).empty();
            $("#problem-title-modal-" + tabIndex).append(problem.name);

            $("#problem-topic-list-modal-" + tabIndex).empty();
            $("#problem-topic-list-modal-" + tabIndex).append(topics);
            $("#problem-description-modal-" + tabIndex).empty();
            $("#problem-description-modal-" + tabIndex).append(problem.description);
            $("#problem-input-modal-" + tabIndex).empty();
            $("#problem-input-modal-" + tabIndex).append(problem.input);
            $("#problem-output-modal-" + tabIndex).empty();
            $("#problem-output-modal-" + tabIndex).append(problem.output);
//            huxley.createLightBox();
            huxley.createUploader(problemId, 'submit-button-' + tabIndex);
        }
    });
};
huxleyProblem.tempPendingSubmission = [];
huxleyProblem.tempPendingProblem = [];

huxleyProblem.toReevaluate = new Array();
huxleyProblem.problemReevaluating = [];
huxleyProblem.reEvaluting = 0;

huxleyProblem.callGetStatus = function(submission){
    if(submission != undefined && huxleyProblem.toReevaluate.indexOf(submission) == -1){
        huxleyProblem.toReevaluate.push(submission);
    }
    if(huxleyProblem.reEvaluting == 0){
        huxleyProblem.reEvaluting = 1;
        huxleyProblem.getStatus();
    }

}
huxleyProblem.getStatus = function(){
    if(huxleyProblem.toReevaluate.length>0){
        $.ajax({
            url: huxley.root + 'submission/getStatus',
            async: true ,
            type: 'POST',
            dataType: 'json',
            data: {id: JSON.stringify(huxleyProblem.toReevaluate)} ,
            success: function(data) {
                huxleyProblem.problemReevaluating = [];
                $.each(data.submissions, function(i, submission) {
                    if(!(submission.evaluation == huxley.constants.EVALUATION_WAITING)){
                        huxley.removeFromArray(submission.id,huxleyProblem.toReevaluate);
                        if (submission.evaluation == huxley.constants.EVALUATION_CORRECT) {
                            huxley.setProblemCorrect("title-problem-" + submission.problemId);
                            huxleyProblem.openModalCorrect(submission.id);
                            if($('#title-problem-tip-' + submission.problemId).length !== 0) {
                                $('#title-problem-tip-' + submission.problemId).remove()
                            }
                        } else {
                            huxley.setProblemWrong("title-problem-" + submission.problemId);
                            if($('#title-problem-tip-' + submission.problemId).length === 0) {
                                $('#title-problem-' + submission.problemId).append('<span class="problem-title-tip" id="title-problem-tip-' + submission.problemId + '"><a href="javascript:void(0)">Onde estou errando?</a></span>');
                                $('#title-problem-tip-' + submission.problemId).on('click',function () { tip(submission.problemId); });
                            }
                        }
                    }else{
                        huxley.setProblemWaiting('title-problem-' + submission.problemId);
                        huxleyProblem.problemReevaluating.push(submission.problemId);
                        if($('#title-problem-tip-' + submission.problemId).length !== 0) {
                            $('#title-problem-tip-' + submission.problemId).remove()
                        }
                    }

                });

            }
        });
        setTimeout(function(){huxleyProblem.getStatus();}, 10000);
    }else{
        huxleyProblem.reEvaluting = 0;
        huxleyProblem.problemReevaluating = [];
    }

}

huxleyProblem.openModalCorrect = function (sid) {
        var template = '<div div id="modal-window-correct" class="modal-window">' +
        '   <div class="problem-modal-show">' +
        '       <div>' +
        '           <a href="javascript:huxley.closeModal()" class="close" style="font-size: 22px; font-weight: bold; color: grey;">×</a>' +
        '           <h3 id="problem-info" style="font-weight: bold; font-size: 36px; color: #555;">Parabéns, você acertou o problema {{name}}!!!' +
        '           <div style="text-align: left; font-size: 13px">(*) Recalculamos a pontuação do topcoder somente uma vez por dia. Atualmente, fazemos isso as 03:00hs da manhã</div>' +
        '       </div>';

         $.ajax('/huxley/submission/getSubmissionInfoById', {
                data: {id: sid},
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    $('div#modal-correct').append(Mustache.render(template, {name: data.name, pid: data.pid, id: data.id}));
                    huxley.openModal('modal-window-correct');
                }
            }
        );
    }

huxleyProblem.getPendingSubmission = function(){
    'use strict';
        $.ajax({
            url: huxley.root + 'problem/ajxGetPendingSubmission',
            async: false,
            method: 'POST',
            dataType: 'json',
            success: function (data) {
                    $.each(data.pendingList.pendingSubmissionList, function (problemIndex, pending) {
                        huxleyProblem.callGetStatus(pending);
                    });
                $.each(data.pendingList.pendingProblemList, function (problemIndex, problem) {
                    huxley.setProblemWaiting('title-problem-' + problem);
                });
            }
        });
};

huxleyProblem.selectedId = [];
huxleyProblem.selectedCount = 0;

huxleyProblem.updateBox = function () {
    'use strict';
    if (huxleyProblem.selectedId !== undefined && huxleyProblem.selectedId.length > 0) {
        var splitIdList = huxleyProblem.selectedId;

        if (huxleyProblem.selectedId.length > 1) {
            splitIdList = huxleyProblem.selectedId.split(',');
        }

        $.each(splitIdList, function (i, topic) {
            $('#value-' + topic).remove();
        });
    }
};

huxleyProblem.selectAll = function () {
    'use strict';
    var index = 1;

    $('#box-search option').each(function () {
        huxleyProblem.selectedCount += 1;
        if (index === 1) {
            huxleyProblem.selectedId = this.value;
        } else {
            huxleyProblem.selectedId = huxleyProblem.selectedId + "," + this.value;
        }
        index += 1;
    });

};

huxleyProblem.deSelectAll = function () {
    'use strict';
    huxleyProblem.selectedId = "";
    $('#box-selected').empty();

};

huxleyProblem.updateSelectedId = function () {
    'use strict';

    var index = 1;

    huxleyProblem.selectedCount = 0;

    $('#box-selected option').not(':selected').each(function () {
        huxleyProblem.selectedCount += 1;
        if (index === 1) {
            huxleyProblem.selectedId = this.value;
        } else {
            huxleyProblem.selectedId = huxleyProblem.selectedId + "," + this.value;
        }
        index += 1;
    });
    huxleyProblem.updateBox();

};

huxleyProblem.deselectId = function () {
    'use strict';

    var list = $("#box-selected").val();

    $.each(list, function (i, topic) {
        huxleyProblem.selectedCount -= 1;
        if (huxleyProblem.selectedId.indexOf(topic) !== -1) {
            $('#value-selected-' + topic).remove();
            if (huxleyProblem.selectedId.length === 1) {
                huxleyProblem.selectedId = huxleyProblem.selectedId.replace(topic, "");
            } else {
                huxleyProblem.selectedId = huxleyProblem.selectedId.replace(topic + ",", "");
            }
        }


    });
};

huxleyProblem.getTopicList = function () {
    'use strict';

    var searchParam = $('#search-param').val();
    $.ajax({
        url: '/huxley/problem/listTopics',
        dataType: 'json',
        async: false,
        data: 'nS=' + searchParam,
        success: function (data) {
            var topics = data.topicList;

            $('#box-search').empty();
            $.each(topics, function (i, topic) {
                $('#box-search').append(
                    '<option value = "' + topic.id + '" id="value-' + topic.id + '">' + topic.name + '</option>'
                );

            });

            if (topics.length === 0) {
                $('#add').button("option", "disabled", false);
            } else {
                $('#add').button("option", "disabled", true);
            }

            huxleyProblem.updateBox();
        }
    });

};

huxleyProblem.setTopicList = function () {
    'use strict';
    $.ajax({
        url: '/huxley/problem/selectedIdList',
        dataType: 'json',
        async: false,
        data: 'idList=' + huxleyProblem.selectedId,
        success: function (data) {
            var topics = data.topicList;

            $.each(topics, function (i, topic) {
                $('#box-selected').append(
                    '<option value ="' + topic.id + '" id="value-selected-' + topic.id + '">' + topic.name + '</option>'
                );

            });
        }
    });

};

huxleyProblem.selectedProblems = [];

huxleyProblem.selectProblem = function (id, score) {
    'use strict';
    if (score === undefined) {
        score = 0;  
    }
    if (huxleyProblem.selectedProblems.indexOf(id) === -1) {
        if($('#problem-box-' + id).length != 0){
            addProblem++
            $('.cont-problem').empty().append('<span style=" float: right; position: relative; padding: 5px 2px 0px 0px; background: white;"><b>' + addProblem + '</b> problemas adicionados</span>');
            $('#selected-list').append($('#problem-box-' + id)
                .attr('id', 'problem-box-added-' + id)
                .find("#problem-button-" + id).css('background', 'red').empty().append('-').removeAttr('onclick').unbind('click').click(function () {huxleyProblem.removeProblem(id); })
                .end().find('.problem-box').append($('<div id="problem-value- ' + id + '"><span class="label">Pontuação: </span><input id="problem-score-' + id + '" style="width: 60px" value="' + score + '" /></div>')).end())
                .find("#description-button-" + id).css('background', 'red');

        }


        huxleyProblem.selectedProblems.push(id);
    }
};

huxleyProblem.removeProblem = function (id) {
    'use strict';
    addProblem--;
    $('.cont-problem').empty().append('<span style=" float: right; position: relative; padding: 5px 2px 0px 0px; background: white;">' + addProblem + ' problemas adicionados</span>');
    $('#problem-box-added-' + id).remove();
    huxleyProblem.selectedProblems = huxleyProblem.removeElement(huxleyProblem.selectedProblems, id);
};

huxleyProblem.removeElement = function (a, e) {
    'use strict';

    var i, b = [];

    for (i = 0; i < a.length; i = i + 1) {
        if (a[i] !== e) {
            b.push(a[i]);
        }
    }

    return b;
};

huxleyProblem.getSelectedProblems = function () {
    'use strict';

    var data = {problems: []};

    $.each(huxleyProblem.selectedProblems, function (i, problem) {
        data.problems.push({id: problem, score: $('#problem-score-' + problem).val()});
    });

    return data;
};

huxleyProblem.createProblemBox = function(problem, groupList){
    var toAppend = "";
    var usage = 0;
    var topics = '';
    var topicsList = problem.topic;
    if(groupList != undefined){
        $.each(problem.group, function(i, group) {
            if(groupList.indexOf(group.id) != -1){
                usage+= group.count;
            }
        });
    }

    $.each(problem.topic, function(i, topic) {
        huxleyTopic.putOnTable(topic.name,topic.id);
        if (i == (topicsList.length - 1)) {
            topics = topics + topic.name;
        } else {
            topics = topics + topic.name + ", "
        }
    });

    toAppend+='<div class="problem-item" id="problem-box-' + problem.id + '">' +
        '   <div class="problem-box">' +
        '       <div class="title">' + problem.name + '</div>' +
        '       <div><span class="label">Nível Dinâmico: </span>' + problem.nd.toFixed(2) + '</div>' +
        '       <div style="max-width: 250px;"><span class="label">Tópicos: </span>' + topics + '</div>';
    if(usage == 0){
        toAppend += '       <div><span class="label"> Ainda não foi resolvido</span></div>';
    }else if (usage == 1){
        toAppend += '       <div>' + usage +'<span class="label"> aluno já resolveu</span></div>';
    }else{
        toAppend += '       <div>' + usage +'<span class="label"> alunos já resolveram</span></div>';
    }

    toAppend += '   </div>' +
        '   <div class="icon">' +
        '       <span id="problem-button-' + problem.id + '" class="ui-bbutton" style="float: right; padding: 6px 10px;" onclick="huxleyProblem.selectProblem(' + problem.id + ');"">+</span>' +
        '   </div>' +
        '   <div class="icon">' +
        '       <span onclick="huxleyProblem.openModalDescription(' + problem.id + ')" id="description-button-' + problem.id + '" class="ui-bbutton" style="float: right; padding: 4px 3px; margin: -22px 0px 0px 0px;"> Descrição</span>' +
        '   </div>' +
        '   <div style="clear: left;"></div>' +
        '</div>';

    return toAppend;

};

huxleyProblem.openModalDescription = function(pId) {

    var template = '<div><a href="javascript:huxley.closeModal();" class="close" style="font-size: 22px; font-weight: bold; color: grey;">×</a>' +
        '<h3 style="font-weight: bold; color: grey; font-size: 24px;">  {{ pName }} </h3><hr>' +
        '</div>' +
        '<div class="left" style="width:100%;max-width: 100%;">' +
        '<h2>Descrição</h2><div class="problem-description-item" id="problem-description-modal">  {{{ description }}}  </div>' +
        '<h2>Formato de entrada </h2><div class="problem-description-item" id="problem-input-modal"> {{{ inputFormat }}} </div>' +
        '<h2>Formato de saída </h2><div class="problem-description-item" id="problem-output-modal"> {{{ outputFormat }}} </div></div>' +
        '<div class="clear-both"></div><hr>';

    $.ajax({

        url: '/huxley/problem/getProblemInfo',
        data: 'id=' +  pId,
        type: 'GET',
        dataType: 'json',

        success: function (data) {

            $('div#description-modal-show').empty().append(Mustache.render(template, {pName: data.name, description: data.description, inputFormat: data.inputFormat, outputFormat: data.outputFormat}));
            huxley.openModal('description-modal-show');

        }
    });

}

