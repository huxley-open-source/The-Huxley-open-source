var huxleyForum = huxleyForum || {};

huxleyForum.lastSelected = 'opened';

huxleyForum.forumAction = function(id) {
    if (document.getElementById('drop-' + id).style.display == "none") {
        $("#action-forum-dropbox-"+id).addClass("action-forum-dropbox-active");
        document.getElementById('drop-' + id).style.display = "";
        document.getElementById('droplabel-' + id).style.color = "#ffffff";
        document.getElementById('dropshow-' + id).className = "action-forum-show-active";
    } else if (document.getElementById('drop-' + id).style.display == "") {
        $("#action-forum-dropbox-"+id).removeClass("action-forum-dropbox-active");
        document.getElementById('drop-' + id).style.display = "none";
        document.getElementById('droplabel-' + id).style.color = "#616161";
        document.getElementById('dropshow-' + id).className = "action-forum-show";
    }
}

huxleyForum.offset = 0;
huxleyForum.getForum = function(){
    $.ajax({
        url: huxley.root + 'forum/getForum',
        data: 'offset=' + huxleyForum.offset,
        async: false,
        dataType: 'json',
        cache: false,
        beforeSend: function(){
            huxley.showLoading();
            huxleyPaginationWI.loading();
        } ,
        success: function(data) {
            $("#opened-topics").append(data.content);
            if(data.content.length == 0){
                huxleyPaginationWI.stopPaginate();
            }else{
                huxleyPaginationWI.paginate();
            }
            huxley.hideLoading();
            huxleyPaginationWI.loaded();
            huxleyForum.offset+=20;

        }
    });
};

huxleyForum.getForumById = function(id){
    $.ajax({
        url: huxley.root + 'forum/getForumById',
        data: 'id=' + id,
        async: false,
        dataType: 'json',
        cache: false,
        beforeSend: function(){
            huxley.showLoading();
            huxleyPaginationWI.loading();
        } ,
        success: function(data) {
            $("#opened-topics").append(data.content);
            if(data.content.length == 0){
                huxleyPaginationWI.stopPaginate();
            }else{
                huxleyPaginationWI.paginate();
            }
            huxley.hideLoading();
            huxleyPaginationWI.loaded();
            huxleyForum.offset+=20;
        }
    });
};


huxleyForum.sendComment = function(event, id) {
    if (event.keyCode == 13) {
        $.ajax({
            url: huxley.root + 'forum/sendComment',
            type: 'POST',
            data: 'fid=' + id + '&c=' + $('#forum-new-comment-' + id).val(),
            cache: false,
            success: function(data) {
                $("#new-comments-" + id).append(data.content);
                $('#forum-new-comment-' + id).val('');
            }
        });
    }
}

huxleyForum.changeStatus = function(id){
    var status = 'close';
    if(!$("#status-icon-"+id).hasClass('ok-icon-active')){
        status = 'open';
    }
    $.ajax({
        url: huxley.root + 'forum/changeStatus',
        async: false,
        data:'status='+status + '&id=' + id,
        cache: false,
        success: function(data) {
            if(status == 'open'){
                $("#status-icon-"+id).removeClass('ok-icon');
                $("#status-icon-"+id).addClass('ok-icon-active');
            }else{
                $("#status-icon-"+id).removeClass('ok-icon-active');
                $("#status-icon-"+id).addClass('ok-icon');
            }
        }
    });
}

huxleyForum.testForumVisibility = function(){
    $(".topic").each(function( index ) {
        var container =  $(this);
        if(container.hasClass('forum-unread')){
            if(huxley.isScrolledIntoView(container)){
                setTimeout(function(){
                    if(huxley.isScrolledIntoView(container)){
                        $.ajax({
                            url: huxley.root + 'forum/updateForumStatus',
                            async: true ,
                            type: 'POST',
                            dataType: 'json',
                            data: 'id=' + container[0].id ,
                            cache: false,
                            success: function(data) {
                                if(data.status == 'ok'){
                                    container.removeClass('forum-unread');
                                    huxley.lookForFeed();
                                }

                            }
                        });
                        }

                }, 300);
            }
        };
    });
    setTimeout(function(){huxleyForum.testForumVisibility();}, 300);
};
