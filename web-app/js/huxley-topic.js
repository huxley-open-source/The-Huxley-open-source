var huxleyTopic = huxleyTopic || {};


huxleyTopic.selectedId = "";
huxleyTopic.initArg = "";
huxleyTopic.changeFunction = function () {
    'use strict';
};


$(function() {
    var index = 1;
    $('#temp-topic option').each(function() {
        if(index == 1){
            huxleyTopic.selectedId = this.value;
        }else{
            huxleyTopic.selectedId = huxleyTopic.selectedId + "," + this.value;
        }
        index ++;
    });
    if($('#temp-topic option').length > 0){
        huxleyTopic.setTopicList();
        updateSelectedId();
        $('#topic-list-id').attr('value', huxleyTopic.selectedId);
    }
    $('#temp-topic').remove();

});

huxleyTopic.setChangeFunction = function (newFunction, initArg) {
    'use strict';
    huxleyTopic.initArg = initArg;
    huxleyTopic.changeFunction = newFunction;
};

$(function() {
    $( "#add" ).button({
        text: false,
        icons: {
            primary: "ui-icon-plusthick"
        }
    })
        .click(function(e) {
            e.preventDefault();
            var name = $('#topic-search-param').val();
            $.ajax({
                url: '/huxley/problem/topicSave',
                async: false,
                data: 'name=' + name,
				type: 'POST',
                success: function(data) {
                    huxleyTopic.selectedId = data.topic.id;
                    huxleyTopic.setTopicList();
                    updateSelectedId();
                    $('#topic-list-id').attr('value', huxleyTopic.selectedId);
                    huxleyTopic.getTopicList();
                }
            });
        });
    $( "#play" ).button({
        text: false,
        icons: {
            primary: "ui-icon-seek-end"
        }
    })
        .click(function(e) {
            e.preventDefault();
            huxleyTopic.selectedId = $("#box-search").val();
            huxleyTopic.setTopicList();
            updateSelectedId();
            $('#topic-list-id').attr('value', huxleyTopic.selectedId);
            huxleyTopic.refreshTable();
        });
    $( "#forward" ).button({
        text: false,
        icons: {
            primary: "ui-icon-seek-next"
        }
    })
        .click(function(e) {
            e.preventDefault();
            selectAll();
            huxleyTopic.setTopicList();
            updateSelectedId();
            $('#topic-list-id').attr('value', huxleyTopic.selectedId);
            huxleyTopic.refreshTable();
        });
    $( "#rewind" ).button({
        text: false,
        icons: {
            primary: "ui-icon-seek-prev"
        }
    }).click(function(e) {
            e.preventDefault();
            deSelectAll();
            huxleyTopic.getTopicList();
            $('#topic-list-id').attr('value', huxleyTopic.selectedId);
        });
    $( "#beginning" ).button({
        text: false,
        icons: {
            primary: "ui-icon-seek-start"
        }
    }).click(function(e) {
            e.preventDefault();
            huxleyTopic.deselectId();
            huxleyTopic.getTopicList();
            $('#topic-list-id').attr('value', huxleyTopic.selectedId);
        });

    $('#topic-label-search').click(function() {
        if($('#search-container').css('display') == 'none'){
            $('#search-container').slideDown(1000);
            $('#search-container').css('display','inline-block');
        }else{
            $('#search-container').slideToggle(1000);
        }


    });

});

$(function() {
    huxleyTopic.getTopicList();
});

huxleyTopic.withOutAddOption = function(){
    $("#add").remove();
    $("#toolbar ul").css('margin-top','39px');
}

huxleyTopic.getTopicList = function(){
    var searchParam = $('#topic-search-param').val();
    $.ajax({
        url: '/huxley/problem/listTopics',
        dataType: 'json',
        async: false,
        cache: false,
        data: 'nS=' + searchParam,
        success: function(data) {
            var topics = data.topicList
            $('#box-search').empty();
            $.each(topics, function(i, topic) {
                $('#box-search').append(
                    '<option value ="'+topic.id+'" id="value-'+topic.id+'">'+topic.name+'</option>'
                );

            });
            if($("#topic-search-param").val() && $("#topic-search-param").val().length == 0){
                $('#add').button( "option", "disabled", true );
            }else{
                $('#add').button( "option", "disabled", false );
            }
            huxleyTopic.updateBox();
        }
    });

}
huxleyTopic.setTopicList = function(){
    if(huxleyTopic.selectedId){
        $.ajax({
            url: '/huxley/problem/selectedIdList',
            dataType: 'json',
            async: false,
            cache: false,
            data:'idList=' + huxleyTopic.selectedId,
            success: function(data) {
                var topics = data.topicList
                $.each(topics, function(i, topic) {
                    $('#box-selected').append(
                        '<option value ="'+topic.id+'" id="value-selected-'+topic.id+'">'+topic.name+'</option>'
                    );

                });
            }
        });
    }
}

huxleyTopic.updateBox = function(){
    if(huxleyTopic.selectedId != undefined){
        var splitIdList = huxleyTopic.selectedId.split(',');
        $.each(splitIdList, function(i, topic) {
            $('#value-'+topic).remove();

        });
        huxleyTopic.changeFunction();
    }
}
function selectAll(){
    var index = 1;
    $('#box-search option').each(function() {
        if(index == 1){
            huxleyTopic.selectedId = this.value;
        }else{
            huxleyTopic.selectedId = huxleyTopic.selectedId + "," + this.value;
        }
        index ++;
    });

}
function deSelectAll(){
    huxleyTopic.selectedId = "";
    $('#box-selected').empty();

}
function updateSelectedId(){
    var index = 1;
    $('#box-selected option').not(':selected').each(function() {
        if(index == 1){
            huxleyTopic.selectedId = this.value;
        }else{
            huxleyTopic.selectedId = huxleyTopic.selectedId + "," + this.value;
        }
        index ++;
    });
    huxleyTopic.updateBox();

}
huxleyTopic.deselectId = function(){
    var list = $("#box-selected").val();
    $.each(list, function(i, topic) {
        if(huxleyTopic.selectedId.indexOf(topic) != -1){
            $('#value-selected-'+topic).remove();
            if(huxleyTopic.selectedId.length == 1){
                huxleyTopic.selectedId = huxleyTopic.selectedId.replace(topic,"");
            }else{
                huxleyTopic.selectedId = huxleyTopic.selectedId.replace(topic+",","");
            }
        }
    });
}

$(function() {
    $('#topic-search-param').keyup(function() {
        clearTimeout(topicSearchInputTimeOut);
        topicSearchInputTimeOut = setTimeout(function() {
            huxleyTopic.getTopicList();
        }, 1000);
    });
});
var topicSearchInputTimeOut;

huxleyTopic.acceptedSubTopic = [];
huxleyTopic.rejectedSubTopic = [];
huxleyTopic.elementList = []
huxleyTopic.rejectedIdList = "";
huxleyTopic.putOnTable = function(name,id){
    if((huxleyTopic.selectedId.indexOf(id) == -1) && (huxleyTopic.elementList[id] == undefined)){
        huxleyTopic.elementList[id] = 1;
        huxleyTopic.acceptedSubTopic.push(id);
        $('#topic-box').append('<a id="box-element-' + id + '" href="javascript:void(0)" onclick="huxleyTopic.updateTableElement(' + id + ')" class="topic-table-accepted">' + name + '</a>');

    }
}

huxleyTopic.updateTableElement = function(elementId){

    if(huxleyTopic.elementList[elementId] == 1){
        huxleyTopic.acceptedSubTopic.splice(huxleyTopic.acceptedSubTopic.indexOf(elementId),1);
        huxleyTopic.elementList[elementId] = 2;
        huxleyTopic.rejectedSubTopic.push(elementId);
        $('#box-element-' + elementId).removeClass('topic-table-accepted');
        $('#box-element-' + elementId).addClass('topic-table-rejected');
    }else{
        huxleyTopic.rejectedSubTopic.splice(huxleyTopic.rejectedSubTopic.indexOf(elementId),1);
        huxleyTopic.acceptedSubTopic.push(elementId);
        huxleyTopic.elementList[elementId] = 1;
        $('#box-element-' + elementId).removeClass('topic-table-rejected');
        $('#box-element-' + elementId).addClass('topic-table-accepted');
    }
    huxleyTopic.rejectedIdList = huxleyTopic.rejectedSubTopic.toString();
    huxleyTopic.changeFunction();
}

huxleyTopic.refreshTable = function(){
    $('#topic-box').empty();
    huxleyTopic.acceptedSubTopic = [];
    huxleyTopic.rejectedSubTopic = [];
    huxleyTopic.elementList = []
    huxleyTopic.rejectedIdList = "";
}