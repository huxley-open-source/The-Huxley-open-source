var huxley = huxley || {};

$(function () {
    'use strict';

    $('#header-profile').click(function (e) {
        e.stopPropagation();
        huxley.toggleProfileMenu();
    });

    $('#header-forum').click(function (e) {
        e.stopPropagation();
        if($("#forum-menu-comment-list").text().length == 0){
            huxley.updateForumMenuComments();
        }
        huxley.toggleForumMenu();
    });

    $('#header-config').click(function (e) {
        e.stopPropagation();
        huxley.toggleConfigMenu();
    });

    $('#problem-button').mouseover(function () {
        $('#problem-button').addClass('problem-button-hover');
        $('#problem-icon').addClass('problem-icon-hover');
    }).mouseout(function () {
        $('#problem-button').removeClass('problem-button-hover');
        $('#problem-icon').removeClass('problem-icon-hover');
    });

    $('#submission-button').mouseover(function () {
        $('#submission-button').addClass('submission-button-hover');
        $('#submission-icon').addClass('submission-icon-hover');
    }).mouseout(function () {
        $('#submission-button').removeClass('submission-button-hover');
        $('#submission-icon').removeClass('submission-icon-hover');
    });

    $('#quest-button').mouseover(function () {
        $('#quest-button').addClass('quest-button-hover');
        $('#quest-icon').addClass('quest-icon-hover');
    }).mouseout(function () {
        $('#quest-button').removeClass('quest-button-hover');
        $('#quest-icon').removeClass('quest-icon-hover');
    });

    $('#course-button').mouseover(function () {
        $('#course-button').addClass('course-button-hover');
        $('#course-icon').addClass('course-icon-hover');
    }).mouseout(function () {
        $('#course-button').removeClass('course-button-hover');
        $('#course-icon').removeClass('course-icon-hover');
    });

    $('#group-button').mouseover(function () {
        $('#group-button').addClass('group-button-hover');
        $('#group-icon').addClass('group-icon-hover');
    }).mouseout(function () {
        $('#group-button').removeClass('group-button-hover');
        $('#group-icon').removeClass('group-icon-hover');
    });

    $('#language-button').mouseover(function () {
        $('#language-button').addClass('language-button-hover');
        $('#language-icon').addClass('language-icon-hover');
    }).mouseout(function () {
        $('#language-button').removeClass('language-button-hover');
        $('#language-icon').removeClass('language-icon-hover');
    });

    $('#topic-button').mouseover(function () {
        $('#topic-button').addClass('topic-button-hover');
        $('#topic-icon').addClass('topic-icon-hover');
    }).mouseout(function () {
        $('#topic-button').removeClass('topic-button-hover');
        $('#topic-icon').removeClass('topic-icon-hover');
    });

    huxley.lookForFeed();
});


huxley.toggleConfigMenu = function () {
    $('#profile-menu').slideUp(50, function() {
        huxley.changeProfileMenuStyle(true);
    });
    $('#forum-menu').slideUp(50, function() {
        huxley.changeForumMenuStyle(true);
    });
    huxley.changeConfigMenuStyle();
    $('#config-menu').slideToggle(50, function () {
        $(document).one('click', function (e) {
            e.stopPropagation();
            $('#config-menu').slideUp(50, function() {
                huxley.changeConfigMenuStyle(true);
            });
    });

    });
};

huxley.toggleProfileMenu = function () {
    $('#config-menu').slideUp(50, function() {
        huxley.changeConfigMenuStyle(true);
    });
    $('#forum-menu').slideUp(50, function() {
        huxley.changeForumMenuStyle(true);
    });
    huxley.changeProfileMenuStyle();
    $('#profile-menu').slideToggle(50, function () {
        $(document).one('click', function (e) {
            e.stopPropagation();
            $('#profile-menu').slideUp(50, function() {
                huxley.changeProfileMenuStyle(true);
            });
        });
    });
};


huxley.changeConfigMenuStyle = function(hidden) {
    if ($('#config-menu').css('display') == 'none' && !hidden) {
        $('#header-config').addClass('header-configd');
        $('#carrow').addClass('carrowu');
        $('#carrow').removeClass('carrowp');
        $('#config-menu-icon').addClass('config-menu-icon-active');
    } else {
        $('#header-config').removeClass('header-configd');
        $('#carrow').addClass('carrowp');
        $('#carrow').removeClass('carrowu');
        $('#config-menu-icon').removeClass('config-menu-icon-active');

    }
};

huxley.changeProfileMenuStyle = function(hidden) {
    if ($('#profile-menu').css('display') == 'none' && !hidden) {
        $('#header-profile').addClass('header-profiled');
        $('#parrow').addClass('parrowu');
        $('#parrow').removeClass('parrowp');
    } else {
        $('#header-profile').removeClass('header-profiled');
        $('#parrow').addClass('parrowp');
        $('#parrow').removeClass('parrowu');
    }
};

huxley.toggleForumMenu = function () {
    $('#config-menu').slideUp(50, function() {
        huxley.changeConfigMenuStyle(true);
    });
    $('#profile-menu').slideUp(50, function() {
        huxley.changeProfileMenuStyle(true);
    });
    huxley.changeForumMenuStyle();
    $('#forum-menu').slideToggle(50, function () {
        $(document).one('click', function (e) {
            e.stopPropagation();
            $('#forum-menu').slideUp(50, function() {
                huxley.changeForumMenuStyle(true);
            });
        });
    });
};
huxley.feedCount = 0
huxley.lookForFeed = function(){
    var result = 0;
    $.ajax({
        url: '/huxley/forum/getNewMessageCount',
        dataType: 'json',
        success: function(data) {
            result = data.total;

            if(huxley.feedCount != result){
                huxley.updateForumMenuComments();
                huxley.feedCount = result;
            }
            if(huxley.feedCount > 0){
                $("#new-message-count").empty();
                $("#new-message-count-container").show();
                if(huxley.feedCount < 10){
                    $("#new-message-count").append(huxley.feedCount);
                }else{
                    $("#new-message-count").append("10+");
                }
            }else{
                $("#new-message-count-container").hide();
            }
        }
    });


    setTimeout(huxley.lookForFeed, (60 * 1000));
}

huxley.changeForumMenuStyle = function(hidden) {
    if ($('#forum-menu').css('display') == 'none' && !hidden) {
        $('#header-forum').addClass('.header-forum-highlight');
    } else {
        $('#header-forum').removeClass('.header-forum-highlight');
    }
};


huxley.updateForumMenuComments = function(){
        $.ajax({
            url: '/huxley/forum/getLastCommentList',
            async: false,
            dataType: 'json',
            success: function(data) {
                $("#forum-menu-footer").empty();
                if(data.comment.length == 0){
                    $("#forum-menu-footer").append("Não existem mensagens disponíveis");
                }else{
                    $("#forum-menu-comment-list").empty();
                    $("#forum-menu-comment-list").append(data.comment);
                    $("#forum-menu-comment-list .comment").each(function(){ // cada elemento da class .div
                        if($(this).attr('id') != undefined){
                            $(this).click(function (e) {
                                window.location.replace("/huxley/forum/show/" + $(this).attr('id'))
                            });
                        }

                    }); // fim do each
                    $(".forum-menu .comment > .comment").each(function(){ // cada elemento da class .div
                        if($(this).text().length > 50){
                            var newText = $(this).text().substring(0,50) + "...";
                            $(this).empty();
                            $(this).append(newText);
                        }

                    });
                    $("#forum-menu-footer").append("<a href='/huxley/forum/index'>Visualizar todas as mensagens</a>");
                }
            }
        });
};


huxley.removeFromArray = function(value,array){
    if(array.indexOf(value) != -1){
        array.splice(array.indexOf(value),1);
    }
};