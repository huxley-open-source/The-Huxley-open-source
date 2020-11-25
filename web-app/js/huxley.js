var huxley = huxley || {};

huxley.root = null;

huxley.constants = {
    EVALUATION_CORRECT :0,
    EVALUATION_WRONG_ANSWER :1,
    EVALUATION_WAITING : 6
}

huxley.msgMap = {
    0: 'Correta',
    1: 'Errada',
    2: 'Erro de execução',
    3: 'Erro de compilação',
    4: 'Resposta vazia',
    5: 'Tempo limite excedido',
    6: 'Avaliando',
    7: 'Sem casos de teste',
    8: 'Error no servidor',
    9: 'Erro de formatação',
    '-1': 'Error no servidor'
};

huxley.toMsg = function(code){
    return huxley.msgMap[code];
};


huxley.setRoot = function(root){
    huxley.root = root;
};

huxley.topCoderTagGuests = function(){

    $("#guest").addClass("active");
    $("#general").removeClass("active");
    $("#guest-list").show();
    $("#general-list").hide();

};

huxley.topCoderTagGeneral = function(){

    $("#general").addClass("active");
    $("#guest").removeClass("active");
    $("#general-list").show();
    $("#guest-list").hide();


};

huxley.paginateIndex = [];
huxley.paginateDiv = [];
huxley.paginateTotal = [];


huxley.generatePagination = function(div,functionToPaginate,limit,total){
    $("#"+div).empty();
    var number = total/limit;
    number = Math.ceil(number);
    var pagIndex = huxley.paginateDiv.indexOf(div);
    if(pagIndex == -1){
        pagIndex = huxley.paginateIndex.length;
        huxley.paginateIndex.push(functionToPaginate);
        huxley.paginateDiv.push(div);
        huxley.paginateTotal.push(parseInt(number));
    }else{
        huxley.paginateTotal[pagIndex] = parseInt(number);
    }
    huxley.printPagination(pagIndex,0);
};
huxley.printPagination = function(pagIndex,selectedIndex){
    var div = huxley.paginateDiv[pagIndex];
    var functionToPaginate = huxley.paginateIndex[pagIndex];
    var number = huxley.paginateTotal[pagIndex];
    var i;
    var toAppend ='';
    if(number>1){
        if(number < 12){
            for(i=0;i<number;i++){
                if(i==0){
                    toAppend += '<a name="'+div+'-pag" id="'+div+'-pag-'+i+'" href="javascript:huxley.paginate('+pagIndex+','+i+',\''+div+'\')" class="selected">0</a>';
                }else{
                    toAppend += '<a name="'+div+'-pag" id="'+div+'-pag-'+i+'" href="javascript:huxley.paginate('+pagIndex+','+i+',\''+div+'\')">'+i+'</a>';
                }

            }
        }else{
            for(i=0;i<2;i++){
                if(i==0){
                    toAppend += '<a name="'+div+'-pag" id="'+div+'-pag-'+i+'" href="javascript:huxley.paginate('+pagIndex+','+i+',\''+div+'\')" class="selected">0</a>';
                }else{
                    toAppend += '<a name="'+div+'-pag" id="'+div+'-pag-'+i+'" href="javascript:huxley.paginate('+pagIndex+','+i+',\''+div+'\')">'+i+'</a>';
                }

            }
            var end = number - 2;
            var mid = selectedIndex - 3;
            var k = end - mid;
            if(k < 5){
                mid = end - k;
            }
            if(mid > i){
                if(mid/2 > i){
                    toAppend += '<a name="'+div+'-pag" id="'+div+'-pag-'+parseInt(mid/2)+'" href="javascript:huxley.paginate('+pagIndex+','+parseInt(mid/2)+',\''+div+'\')" >...</a>';
                }else{
                    toAppend += '<a name="'+div+'-pag" id="'+div+'-pag-'+i+'" href="javascript:huxley.paginate('+pagIndex+','+i+',\''+div+'\')" >...</a>';
                }
                i = mid;
            }
            var limit = i + 6;
                for(;(i<number) && (i < limit);i++){
                    toAppend += '<a name="'+div+'-pag" id="'+div+'-pag-'+i+'" href="javascript:huxley.paginate('+pagIndex+','+i+',\''+div+'\')">'+i+'</a>';
                }

            if(end > i){
                if((end - mid)/2 > i - mid){
                    toAppend += '<a name="'+div+'-pag" id="'+div+'-pag-'+parseInt(((end - mid)/2) + mid)+'" href="javascript:huxley.paginate('+pagIndex+','+parseInt(((end - mid)/2) + mid)+',\''+div+'\')" >...</a>';
                }else{
                    toAppend += '<a name="'+div+'-pag" id="'+div+'-pag-'+i+'" href="javascript:huxley.paginate('+pagIndex+','+i+',\''+div+'\')" >...</a>';
                }
                for(i=parseInt(end);i<number;i++){
                    toAppend += '<a name="'+div+'-pag" id="'+div+'-pag-'+i+'" href="javascript:huxley.paginate('+pagIndex+','+i+',\''+div+'\')">'+i+'</a>';

                }
            }else{
                for(;i<number;i++){
                    toAppend += '<a name="'+div+'-pag" id="'+div+'-pag-'+i+'" href="javascript:huxley.paginate('+pagIndex+','+i+',\''+div+'\')">'+i+'</a>';

                }
            }
        }

    }
    $("#"+div).empty();
    $("#"+div).append(toAppend);
}
huxley.paginate = function(pagIndex,index,div){
    huxley.printPagination(pagIndex,index)
    huxley.paginateIndex[pagIndex](index,0);
    $('a[name='+div+'-pag]').removeClass('selected');
    $('#'+div+'-pag-'+index).addClass('selected');
};

huxley.getProblemContent = function(problemId){
    var result = [];
    $.ajax({
        url: huxley.root+'problem/getProblemContent',
        data: 'id=' + problemId ,
        async: false,
        dataType: 'json',
        success: function(data) {
            result = data
        }
    });
    return result;
};

huxley.getUserClosedQuestionnaires = function(userId,limit,offset){
    var result = null;
    $.ajax({
        url: huxley.root+'quest/getClosedUserQuest',
        data: 'userId='+userId+'&limit='+limit+'&offset='+offset,
        async: false,
        dataType: 'json',
        success: function(data) {
            result = data.questionnaireList;
        }
    });
    return result;
};

huxley.toggleConfigMenu = function () {
    huxley.changeConfigMenuStyle();
    $('#config-menu').slideToggle('fast', function () {
        if ($('#config-menu').css('display') == "block") {
            $(document).one('click', function () {
                $('#config-menu').slideUp('fast');
            });
        }
    });
};

huxley.changeConfigMenuStyle = function() {

    $('#config-menu-button').css('background', '#05C629');

};

huxley.startAccordion = function(div) {
    $( "#"+div )
        .accordion({
            header: "> div > h3"
        })
        .sortable({
            axis: "y",
            handle: "h3",
            stop: function( event, ui ) {
                // IE doesn't register the blur when sorting
                // so trigger focusout handlers to remove .ui-state-focus
                ui.item.children( "h3" ).triggerHandler( "focusout" );
            }
        });
};

huxley.restartAccordion = function(div){
    $('#'+div).accordion("destroy").accordion({
        collapsible: true,
        changestart: function(event, ui) {

        }
    });

}

huxley.createLightBox = function(){
    $('a[name=modal]').click(function(e) {
        e.preventDefault();

        var id = $(this).attr('href');

        var maskHeight = $(document).height();
        var maskWidth = $(window).width();

        $('#mask').css({'width':maskWidth,'height':maskHeight});

        $('#mask').fadeIn(100);
        $('#mask').fadeTo("slow",0.7);

        //Get the window height and width
        var winH = $(window).height();
        var winW = $(window).width();

        $(id).css('top',  winH/2-$(id).height()/2);
        $(id).css('left', winW/2-$(id).width()/2);

        $(id).fadeIn(500);

    });

    $('.window .close').click(function (e) {
        e.preventDefault();

        $('#mask').hide();
        $('.window').hide();
    });

    $('#mask').click(function () {
        $(this).hide();
        $('.window').hide();
    });
};



huxley.createUserUploader = function(button){
    var uploader = new qq.FileUploader({
        element: document.getElementById(button),
        action: huxley.root+'user/validateFile',
        allowedExtensions:  ['txt'],
        sizeLimit: 1048576,
        messages: {
            typeError: "{file} não possui uma extensão válida. Apenas {extensions} são permitidas.",
            sizeError: "{file} é muito grande, O tamanho máximo do arquivo deve ser {sizeLimit}.",
            emptyError: "{file} está vazio, por favor selecione outro arquivo.",
            onLeave: "O arquivo ainda está sendo enviado."
        },
        template: '<div class="qq-uploader">' +
            '<div id="submission-area"><div style="float: left;" class="qq-upload-drop-area"><span style="width: 100px; display: block; text-align: center;">solte</span></div>' +
            '<div class="qq-upload-button">enviar</div>' +
            '<ul class="qq-upload-list" style="display: none;"></ul>' +
            '</div></div>',
        onComplete: function(id, fileName, responseJSON){
            update(responseJSON);
        }

    });
};


huxley.createSlider = function(slider,minAmount,maxAmount,minValue,maxValue,minVar,maxVar){
        $( "#"+slider ).slider({
            range: true,
            min: minValue,
            max: maxValue,
            values: [ minValue, maxValue ],
            slide: function( event, ui ) {
                $( "#"+minAmount ).val( ui.values[ 0 ] );
                $( "#"+maxAmount ).val( ui.values[ 1 ] );
                minVar(ui.values[ 0 ]);
                maxVar(ui.values[ 1 ]);
            }
        });
        $( "#"+minAmount ).val( $( "#"+slider ).slider( "values", 0 ) );
        $( "#"+maxAmount ).val( $( "#"+slider ).slider( "values", 1 ) );

};

huxley.openMask = function () {
    'use strict';
    $('#mask-lift').fadeIn('fast');
    $('body').addClass('theater');
};

huxley.closeMask = function () {
    'use strict';
    $('#mask-lift').hide();
    $('body').removeClass('theater');
    $('#mask-container').empty();
};

huxley.openModal = function (container) {
    'use strict';
    huxley.closeMask();
    var div = document.getElementById(container);
    $('#mask-container').append($(div));
    $(div).addClass('modal').show();
    huxley.openMask();
};

huxley.closeModal = function () {
    'use strict';
    $('.modal').hide();
    $('body').append($('#mask-container .modal'));
    huxley.closeMask();
};

huxley.accordion = function (id, properties) {
    'use strict';
    var elName = '#' + id;
    var accordion = $('#' + id);
    var titles;
    var rightPanel = document.createElement('span');
    var containnerLeft = document.createElement('span');
    var containnerRight = document.createElement('span');

    $(rightPanel).append(containnerLeft);
    $(rightPanel).append(containnerRight);

    $(containnerRight).addClass('cright');
    $(containnerLeft).addClass('cleft');


    $(rightPanel).addClass('hx-acc-right-panel');

    accordion.addClass('hx-acc');

    titles = accordion.children('h3');
    titles.next('div').hide();
    titles.removeClass('hx-acc-active');
    $(elName).find('h3:not(:has(span.hx-acc-right-panel))').append(rightPanel);
    titles.addClass('hx-acc-title');
    $(titles.next('div')).addClass('hx-acc-content');

    titles.click(function() {
        if (!$(this).hasClass('hx-acc-active')) {
            $('.hx-acc > .hx-acc-active').next('div').slideToggle('fast');
            if ($('.hx-acc > .hx-acc-active').length > 0) {
                if ($.isFunction($(properties.onClose))) {
                    properties.onClose($('.hx-acc > .hx-acc-active'));
                }
            }
            $('.hx-acc > .hx-acc-active').removeClass('hx-acc-active');
            $(this).addClass('hx-acc-active');
            $(this).next('div').slideToggle('fast');
            properties.onOpen(this);
        }
    });
    $(titles[0]).addClass('hx-acc-active').next('div').slideDown('fast');
    properties.onOpen(titles[0]);

};

huxley.showLoading = function () {
    $('div#spinner').slideDown('fast');
};

huxley.hideLoading = function () {
    $('div#spinner').slideUp('fast');
};

String.prototype.replaceAll = function(de, para){
    var str = this;
    var pos = str.indexOf(de);
    while (pos > -1){
        str = str.replace(de, para);
        pos = str.indexOf(de);
    }
    return (str);
};

huxley.error = function(msg){
    $("#system-msg").empty();
    $("#system-msg").attr('class','error-msg');
    $("#system-msg").append(msg);
};

huxley.notify = function(msg){
    $("#system-msg").empty();
    $("#system-msg").removeClass();
    $("#system-msg").attr('class', '');
    $("#system-msg").append(msg);
};

huxley.isScrolledIntoView = function(elem)
{
    var docViewTop = $(window).scrollTop();
    var docViewBottom = docViewTop + $(window).height();

    var elemTop = $(elem).offset().top;
    var elemBottom = elemTop + $(elem).height();
    return ((docViewTop < elemTop) && (docViewBottom > elemBottom));
}