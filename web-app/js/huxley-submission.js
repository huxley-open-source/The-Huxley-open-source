var huxleySubmission = huxleySubmission || {};
var huxley = huxley || {};

huxleySubmission.limit = 0;
huxleySubmission.problemName = '';
huxleySubmission.userName = '';
huxleySubmission.startDate = '';
huxleySubmission.endDate = '';
huxleySubmission.group = 0;
huxleySubmission.institution = 0;
huxleySubmission.initArg = 0;
huxleySubmission.currentAtributte = '';
huxleySubmission.currentImg = '';
huxleySubmission.order = '';
huxleySubmission.imagePath = '';
huxleySubmission.menuAction = null;

$(function () {
    'use strict';
    $('#forum-submission-cancel').click(function () {
        huxley.closeModal();
    });

    $('#forum-submission-send').click(function () {
        huxleySubmission.sendMessage($('#submission.id').val());
    });
});

huxleySubmission.sendMessage = function () {
    'use strict';
    var comment = $('#forum-message').val();

    $.ajax({
        url: '/huxley/forum/sendMessage',
        type: 'POST',
        data: {sid: $('#submission-id').val(), m: comment},
        async: false,
        success: function () {
            huxley.closeModal();
            $('#forum-message').val('');
        }
    });
};

huxleySubmission.setSubmission = function (sid) {
    'use strict';
    $('#submission-id').val(sid);
};


huxleySubmission.createActionMenu = function () {
    'use strict';
    $('.submission-action-button').unbind('click');
    $('.submission-action-button').click(function (e) {
        e.stopPropagation();
        huxleySubmission.toggleMenuActions(e);
    });
    $('.submission-action-button-arrow').unbind('click');
    $('.submission-action-button-arrow').click(function (e) {
        e.stopPropagation();
        e.target = e.target.parentNode;
        huxleySubmission.toggleMenuActions(e);
    });

    $('.forum-send-message').click(function (e) {
        'use strict';
        huxley.openModal('forum-submission');
    });

};

huxleySubmission.toggleMenuActions = function (e) {
    'use strict';
    huxleySubmission.menuAction = $($(e.target).parent()[0]).find('.submission-actions');
    huxleySubmission.actionTarget = $(e.target);
    $('.submission-action-button-active').addClass('submission-action-button').removeClass('submission-action-button-active');
    $('.submission-action-button-arrow-active').addClass('submission-action-button-arrow').removeClass('submission-action-button-arrow-active');
    huxleySubmission.menuAction.slideToggle(10, function () {
        if (huxleySubmission.menuAction.css('display') === 'block') {
            $('.submission-actions-open').hide().removeClass('submission-actions-open');
            huxleySubmission.menuAction.addClass('submission-actions-open');
            huxleySubmission.actionTarget.addClass('submission-action-button-active');
            huxleySubmission.actionTarget.find('span').addClass('submission-action-button-arrow-active');
            huxleySubmission.actionTarget.removeClass('submission-action-button');
            huxleySubmission.actionTarget.find('span').removeClass('submission-action-button-arrow');
            $(document).one('click', function (e) {
                e.stopPropagation();
                $('.submission-actions-open').slideUp('fast');
                $('.submission-action-button-action').parent().find('div .submission-actions').slideToggle('fast');
                $('.submission-action-button-active').find('span').removeClass('submission-action-button-arrow-active').addClass('submission-action-button-arrow');
                $('.submission-action-button-active').removeClass('submission-action-button-active').addClass('submission-action-button');
                $('.submission-actions-open').removeClass('submission-actions-open');
            });
        } else {
            $('.submission-action-button-active').addClass('submission-action-button').removeClass('submission-action-button-active');
            $('.submission-action-button-arrow-active').addClass('submission-action-button-arrow').removeClass('submission-action-button-arrow-active');
            $('.submission-actions-open').hide().removeClass('submission-actions-open');
        }
    });
};

huxleySubmission.setValues = function (limit) {
    'use strict';
    huxleySubmission.limit = limit;
};

huxleySubmission.changeFunction = function () {
    'use strict';
};

huxleySubmission.setChangeFunction = function (newFunction, initArg) {
    'use strict';
    huxleySubmission.initArg = initArg;
    huxleySubmission.changeFunction = newFunction;
};

huxleySubmission.setProblemName = function (value) {
    'use strict';
    huxleySubmission.problemName = value;
    huxleySubmission.changeFunction(huxleySubmission.initArg);
};

huxleySubmission.setUserName = function (value) {
    'use strict';
    huxleySubmission.userName = value;
    huxleySubmission.changeFunction(huxleySubmission.initArg);
};


huxleySubmission.setEndDate = function (value) {
    'use strict';
    huxleySubmission.endDate = value;
    huxleySubmission.changeFunction(huxleySubmission.initArg);
};

huxleySubmission.setStartDate = function (value) {
    'use strict';
    huxleySubmission.startDate = value;
    huxleySubmission.changeFunction(huxleySubmission.initArg);
};

huxleySubmission.setSort = function (value, img) {
    'use strict';
    if (huxleySubmission.imagePath.length === 0 ) {
        huxleySubmission.imagePath = document.getElementById('img-' + img).src.substring(0, document.getElementById('img-' + img).src.indexOf('_') + 1);
    }

    if (huxleySubmission.currentAtributte === value) {
        huxleySubmission.order = (huxleySubmission.order === 'desc') ? 'asc' : 'desc';
    } else {
        huxleySubmission.order = 'desc';
        if (huxleySubmission.currentAtributte.length !== 0) {
            document.getElementById('img-' + huxleySubmission.currentImg).src = huxleySubmission.imagePath + 'none.gif';
        }
    }
    huxleySubmission.currentAtributte = value;
    huxleySubmission.changeFunction(huxleySubmission.initArg);
    huxleySubmission.currentImg = img;
    document.getElementById('img-' + huxleySubmission.currentImg).src = huxleySubmission.imagePath + huxleySubmission.order + '.gif';
};



