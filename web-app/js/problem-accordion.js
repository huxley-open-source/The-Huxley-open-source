var qq = qq || {};
var huxley = huxley || {};
var huxleyProblem = huxleyProblem || {};

huxley.pendingSubmissions = [];
huxley.problemSearchInputTimeOut = null;

huxley.setProblemCorrect = function (id) {
    'use strict';
    var content = $('#' + id);
    //content.removeClass();
    content.children('.hx-acc-right-panel').children('.cright').removeClass('problem-waiting-icon');
    content.children('.hx-acc-right-panel').children('.cright').removeClass('problem-wrong-icon');
    content.children('.hx-acc-right-panel').children('.cright').removeClass('problem-correct-icon');
    content.removeClass('problem-wrong-title');
    content.removeClass('problem-waiting-title');
    content.addClass('hx-acc-title problem-correct-title');
    content.children('.hx-acc-right-panel').children('.cright').addClass('problem-correct-icon');
};

huxley.setProblemWaiting = function (id) {
    'use strict';
    var content = $('#' + id);
    //content.removeClass();
    content.children('.hx-acc-right-panel').children('.cright').removeClass('problem-waiting-icon');
    content.children('.hx-acc-right-panel').children('.cright').removeClass('problem-wrong-icon');
    content.children('.hx-acc-right-panel').children('.cright').removeClass('problem-correct-icon');
    content.removeClass('problem-correct-title');
    content.removeClass('problem-wrong-title');
    content.addClass('hx-acc-title problem-waiting-title');
    content.children('.hx-acc-right-panel').children('.cright').addClass('problem-waiting-icon');
    if($('#title-problem-tip-' + id).length !== 0) {
        $('#title-problem-tip-' + id).remove()
    }
};

huxley.setProblemWrong = function (id) {
    'use strict';
    var content = $('#' + id);
    var pid = id.substr(id.lastIndexOf('-') + 1)
    //content.removeClass();
    content.children('.hx-acc-right-panel').children('.cright').removeClass('problem-waiting-icon');
    content.children('.hx-acc-right-panel').children('.cright').removeClass('problem-wrong-icon');
    content.children('.hx-acc-right-panel').children('.cright').removeClass('problem-correct-icon');
    content.removeClass('problem-correct-title');
    content.removeClass('problem-waiting-title');
    content.addClass('hx-acc-title problem-wrong-title');
    content.children('.hx-acc-right-panel').children('.cright').addClass('problem-wrong-icon');
    if($('#title-problem-tip-' + pid).length === 0) {
        $(content).append('<span class="problem-title-tip" id="title-problem-tip-' + pid + '"><a href="javascript:void(0)">Onde estou errando?</a></span>')
        $('#title-problem-tip-' + pid).on('click',function () { tip(pid); });
    }
};

huxley.createUploader = function (problemId, button) {
    'use strict';
    var uploader = new qq.FileUploader({
        element: document.getElementById(button),
        action: huxley.root + 'submission/save',
        allowedExtensions:  ['c', 'pas', 'py', 'cpp', 'java', 'm'],
        sizeLimit: 1048576,
        params: {
            pid: problemId
        },
        messages: {
            typeError: "{file} não possui uma extensão válida. Apenas {extensions} são permitidas.",
            sizeError: "{file} é muito grande, O tamanho máximo do arquivo deve ser {sizeLimit}.",
            emptyError: "{file} está vazio, por favor selecione outro arquivo.",
            onLeave: "O arquivo ainda está sendo enviado."
        },
        template: '<div class="qq-uploader">' +
            '<div id="submission-area"><div style="float: left;" class="qq-upload-drop-area"></div>' +
            '<div class="qq-upload-button" style="font-size: 12px;">Enviar solução</div>' +
            '<ul class="qq-upload-list" style="display: none;"></ul>' +
            '</div></div>',
        onComplete : function (id, fileName, responseJSON) {
            huxley.closeModal();
            huxley.setProblemWaiting('title-problem-' + problemId);
            huxleyProblem.getPendingSubmission();
            huxleyProblem.callGetStatus(responseJSON.submission.id);
        }
    });
};

$(function () {
    'use strict';
    $("#play").button({
        text: false,
        icons: {
            primary: "ui-icon-seek-end"
        }
    }).click(function () {
        huxleyProblem.selectedId = $("#box-search").val();
        huxleyProblem.setTopicList();
        huxleyProblem.updateSelectedId();
        $('#topic-list-id').attr('value', huxleyProblem.selectedId);
        huxleyProblem.getProblemList(0);
    });

    $("#forward").button({
        text: false,
        icons: {
            primary: "ui-icon-seek-next"
        }
    }).click(function () {
        huxleyProblem.selectAll();
        huxleyProblem.setTopicList();
        huxleyProblem.updateSelectedId();
        $('#topic-list-id').attr('value', huxleyProblem.selectedId);
        huxleyProblem.getProblemList(0);
    });

    $("#rewind").button({
        text: false,
        icons: {
            primary: "ui-icon-seek-prev"
        }
    }).click(function () {
        huxleyProblem.selectedCount = 0;
        huxleyProblem.deSelectAll();
        huxleyProblem.getTopicList();
        $('#topic-list-id').attr('value', huxleyProblem.selectedId);
        huxleyProblem.getProblemList(0);
    });

    $("#beginning").button({
        text: false,
        icons: {
            primary: "ui-icon-seek-start"
        }
    }).click(function () {
        huxleyProblem.deselectId();
        huxleyProblem.getTopicList();
        $('#topic-list-id').attr('value', huxleyProblem.selectedId);
        huxleyProblem.getProblemList(0);
    });

    huxleyProblem.getTopicList();
});

huxley.createProblemAccordionItem = function (problem) {
    'use strict';

    var title = document.createElement('h3'),
        content = document.createElement('div'),
        item = document.createDocumentFragment();

    $(title).attr('data', problem.id);
    $(title).attr('id', 'title-problem-' + problem.id);
    $(content).attr('id', 'problem-content-' + problem.id);

    $(title).append(problem.name);
    item.appendChild(title);
    item.appendChild(content);

    return item;
};

huxley.createProblemContent = function (problem, labels, userId) {
    'use strict';
    var content = $('#problem-content-' + problem.id), url = huxley.root + 'submission/index?name=' + problem.name.replaceAll(' ', '+') + '&userId=' + userId, url2 = huxley.root + 'problem/downloadInput/' + problem.id, url3 = huxley.root + 'problem/downloadOutput/' + problem.id, userTime, bestTime, topics, j;

    userTime = problem.userBestTime;
    bestTime = problem.bestTime;

    topics = "";

    for (j = 0; j < problem.topics.length; j = j + 1) {
        if (j === (problem.topics.length - 1)) {
            topics +=  problem.topics[j];
        } else {
            topics += problem.topics[j] + ", ";
        }
    }

    $(content).empty();
    $(content).addClass('problem-content');
    $(content).append($('<div class="tab-left-panel"/>')
                .append($('<ul/>')
                    .append($('<li/>')
                        .append($('<span style="font-weight: bold;"/>').append(labels.problemTopics + ': '))
                        .append($('<span/>').append(topics))
                    )
                    .append($('<li/>')
                        .append($('<span style="font-weight: bold;"/>').append(labels.problemNd + ': '))
                        .append($('<span/>').append(problem.nd.toFixed(2)))
                    )
                    .append($('<li/>')
                        .append($('<span style="font-weight: bold;"/>').append(labels.problemUserBestTime + ': '))
                        .append($('<span/>').append(userTime))
                    )
                    .append($('<li/>')
                        .append($('<span style="font-weight: bold;"/>').append(labels.problemBestTime + ': '))
                        .append($('<span/>').append(bestTime))
                    )
                )
              )
        .append($('<div class="tab-right-panel">')
            .append($('<ul/>')
                .append($('<li/>')
                    .append($('<span style="font-weight: bold;"/>').append(labels.problemLastSubmission + ': '))
                    .append($('<span/>').append(problem.lastSubmission)))
                )
            )
        .append($('<div/>').css('clear', 'left'))
        .append($('<div class="menu-panel" />')
            .append($('<a class="button"/>').append(labels.problemDescription).click(function () {huxley.openModal("modal-window-" + problem.id); }))
            .append($('<a href="href="" class="button"/>').attr("href", url).append(labels.problemSeeSubmissions))
            .append($('<div class="ui-gbutton submission-button"/>').attr('id', 'submit-button-' + problem.id))
            )
        .append($('<div/>').css('clear', 'left'))
        .append($('<div class="modal-window" />').attr('id', 'modal-window-' + problem.id)
            .append($('<div class="problem-modal-show"/>').attr('id', 'dialog-' + problem.id)
                .append($('<a href="javascript:huxley.closeModal();" class="close"/>').append($('<img src="huxley/images/icons/close.png" width="21px" height="22px" border="0" />')))
                .append($('<h2/>').append(labels.problemDescription))
                .append($('<hr/>'))
                .append($('<br/>'))
                .append($('<span/>').append($('<span style="font-weight: bold;"/>').append("Problema: "))).append(problem.name).append($('<br/>'))
                .append($('<hr/>'))
                .append($('<span/>').append($('<span style="font-weight: bold;"/>').append(labels.problemTopics + ": "))).append(topics).append($('<br/>'))
                .append($('<hr/>'))

                .append($('<div class="left" style="width:100%; max-width: 100%;"/>')
                    .append($('<h2/>').append(labels.problemDescription))
                    .append($('<div class="problem-description-item" />').append(problem.description))
                    .append($('<h2/>').append(labels.problemInputFormat))
                    .append($('<div class="problem-description-item"/>').append(problem.input))
                    .append($('<h2/>').append(labels.problemOutputFormat))
                    .append($('<div class="problem-description-item" />').append(problem.output))
                    )
                .append($('<div class="clear-both"/>'))
                .append($('<hr/>'))
                .append($('<div class="menu-panel"/>')
                    .append($('<a class="button"/>').append(labels.problemSeeSubmissions).attr("href", url))
                    .append($('<a class="button"/>').append(labels.problemInputExample).attr("href", url2))
                    .append($('<a class="button"/>').append(labels.problemOutputExample).attr("href", url3))
                    )
                .append($('<div class="clear-both"/>'))
                )
            );
    huxley.createReferenceSolutionTable(problem.id);
    huxley.createUploader(problem.id, 'submit-button-' + problem.id);
    huxley.createUploader(problem.id, 'modal-submit-button-' + problem.id);

};


$(function () {
    'use strict';

//    huxley.problemAccordionTimeOut = null;
//
//    $('#input-problem').keyup(function () {
//        clearTimeout(huxley.problemAccordionTimeOut);
//
//        huxley.problemAccordionTimeOut = setTimeout(function () {
//            huxley.getProblemResults();
//        }, 800);
//    });
});

huxley.getProblemResults = function () {
    'use strict';
    $.ajax({
        url: '/huxley/problem/search',
        data: {nameParam: $('#input-problem').val()},
        dataType: 'json',
        success: function (data) {
            $('#accordion').empty();

            $.each(data.problems, function (i, problem) {
                $('#accordion').append(huxley.createProblemAccordionItem(problem));
            });

            huxley.accordion('accordion', {
                onOpen: function (element) {

                    $.ajax({
                        url: '/huxley/problem/ajxGetProblemContent',
                        data: {id: $(element).attr('data')},
                        dataType: 'json',
                        success: function (data) {
                            huxley.createProblemContent(data.p, data.labels);
                        }
                    });

                    huxley.createUploader($(element).attr('data'), 'submit-button-' + $(element).attr('data'));
                }
            });

            $.each(data.labels.tried, function (i, id) {
                huxley.setProblemWrong('title-problem-' + id);
            });
        }
    });
};