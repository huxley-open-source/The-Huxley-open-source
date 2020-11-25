<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main-head"/>
    <script type="text/javascript">
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

        huxley.showLoading = function () {
            $('div#spinner').slideDown('fast');
        };

        huxley.hideLoading = function () {
            $('div#spinner').slideUp('fast');
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
    </script>
    <style type="text/css">
    .th-field-error {
        font-size: .8em;
        color: #AE3232;
    }

    .th-warning {
        font-size: .8em;
        color:  #C09853;
    }

    .th-success {
        font-size: .8em;
        color:  #356635;
    }

    .th-right {
        float: right;
    }

    .th-input-3 {
        width: 45%;
        background: #F9F9F9;
        color: #999797;
        padding: 10px 10px;
        font-size: 12px;
        border: #F2F2F2 1px solid;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        border-radius: 5px;
    }

    .th-tabbed-pane {
        border-bottom: 1px solid transparent;
        border-color: #DDD;
    }
    .box.tabbed {
        border-top: 0px;

    }
    .th-tabbed-pane ul{
        list-style: none;
        padding: 0;
        margin-top: 0;
        margin-bottom: 0;
        display: inline-block;
    }

    .th-tabbed-pane li{
        display: inline-block;
        margin-bottom: -1px;
    }

    .th-tabbed-pane-tab {
        display: inline-block;
        padding: 8px 12px 7px;
        border: 1px solid transparent;
        border-bottom: 0;
        font-size: 14px;
        line-height: 20px;
        color: #666;
        text-decoration: none !important;
    }

    .th-tabbed-pane-tab.selected {
        border-color: #DDD;
        border-radius: 3px 3px 0 0;
        background-color: white;
        color: #333;
    }

    .th-input {
        background: #F9F9F9 !important;
        color: #999797 !important;
        font-size: 12px !important;
        border: #F2F2F2 1px solid !important;
        -moz-border-radius: 5px !important;
        -webkit-border-radius: 5px !important;
        border-radius: 5px !important;
        margin-bottom: 0px !important;
    }
    input {
        box-shadow: none !important;
    }

    .user-box {
        display: table;
        width: 100%;
        padding: 1px 0px;
    }
    .user-box div {
        display: table-cell;
        vertical-align: middle;
    }
    .user-box div.picture {
        display: table-cell;
        height: 40px;
        width: 40px;
    }
    .info.license {
        width: 267px;
    }

    .user-box div.info ul {
        margin-left: 6px;
    }

    .user-box div.info ul li {
        line-height: 1.1em;
    }

    .user-box div.info ul .name a {
        font-weight: bold;
        color: #767676;
    }

    .th-clear {
        clear:both;
    }

    .th-license-list-header {
        margin-bottom: 10px;
        border-bottom: 1px solid #F3F3F3;
    }

    .th-license-user-box {
        margin: 10px;
        width: 320px;
        display: inline-block;
        background-color: #F9F9F9;
    }

        /* Pagination */
    .ui-pagination {
        margin: 0px 2px;
        float: right;
    }
    .ui-pagination a {
        background: #fdfefe;
        padding: 4px 7px;
        color: #adadad;
        font-size: 12px;
        text-decoration: none;
    }
    .ui-pagination a:hover {
        background: #c5c5c5;
        color: #fff !important;
    }
    .ui-pagination a.selected {
        background: #adadad;
        color: #fff !important;
    }
    .th-close {
        font-size: 19px;
        color: #959595 !important;
    }
    .th-close:hover {
        color: #666 !important;
    }
    .th-license-available {
        line-height: 40px;
    }

    .th-access-key-container {
        width: 400px;
        line-height: 100px;
        font-size: 20px;
        font-weight: bold;
        text-align: center;
        border: 1px solid #5A5A5A;
        height: 100px;
    }

    .th-access-key-info-container {
        width: 400px;
        margin-left: 150px;
    }

    .th-search-result-container {
        position: absolute;
        width: 320px;
        float: left;
        border: 1px solid #F2F2F2;
        border-top: 0px;
        top: -3px;
        background-color: white;
        opacity: 0.95;
        z-index: 1;
    }
    .th-search-container {
        position: absolute;
    }
    .th-search-user-box {
        width: 320px;
        display: inline-block;
        cursor: pointer;
    }

    .th-search-user-box.selected {
        background-color: #F9F9F9;
    }



    </style>
    <script type="text/javascript">
        var limit= 8, name= "", licenseSearchInputTimeOut, lastIndex, permission= 't';



        function addTeacherTab() {
            $('.th-tabbed-pane-tab').removeClass('selected');
            $('#teacher-tab').addClass('selected');
            $(".box.tabbed").hide();
            $('#add-teacher').show();
            activeBar= 'TEACHER';
            permission= 't';
            $('#search-title').empty().append('<g:message code="license.group.list.teacher"/> ' +
            '<g:link action="show" id="${group.hash}" >${group.name}</g:link>');
            getLicense(0);
        }
        function addStudentTab() {
            $('.th-tabbed-pane-tab').removeClass('selected');
            $('#student-tab').addClass('selected');

            $(".box.tabbed").hide();
            $('#add-student').show();
            $('#search-title').empty().append('<g:message code="license.group.list.student"/> ' +
                    '<g:link action="show" id="${group.hash}" >${group.name}</g:link>');
            activeBar= 'STUDENT';
            permission= 's';
            getLicense(0);
        }

        function managePendenciesTab() {
            $('.th-tabbed-pane-tab').removeClass('selected');
            $('#pendencies-tab').addClass('selected');
            $(".box.tabbed").hide();
            $('#manage-pendencies').show();
        }

        function manageKeyTab() {
            $('.th-tabbed-pane-tab').removeClass('selected');
            $('#key-tab').addClass('selected');
            $(".box.tabbed").hide();
            $('#manage-access-key').show();
        }
        function generateAccessKey(){
            $.ajax({
                url: '/huxley/group/generateAccessKey/',
                data: 'id=${group.id}',
                dataType: 'json',
                async: false,
                success: function(data) {
                    if(data.msg.status == 'ok'){
                        $('#access-key').empty();
                        $('#access-key').append(data.msg.accessKey);
                    }
                }
            });
        }

        function getLicense(index){
            var offset = index * limit;
            $.ajax({
                url: hx.util.url('group/listUser'),
                data: 'offset=' + offset + '&max='+limit + '&name=' + name + '&id=${group.id}&permission=' + permission,
                beforeSend: huxley.showLoading(),
                dataType: 'json',
                success: function(data) {
                    lastIndex = index;
                    var toAppend = '';
                    $('#license-list').empty();
                    $.each(data.users, function(i, license) {
                        if (license.profile !== null) {
                            toAppend += '<div class="th-license-user-box">' +
                                    '<div class="user-box">'+
                                    '<div class="picture"><img src="http://img.thehuxley.com/data/images/app/profile/thumb/' + license.profile.smallPhoto + '" alt="' + license.profile.name + '"></div>'+
                                    '<div class="info license">'+
                                    '<ul>'+
                                    '<li class="name"><a href="/huxley/profile/show/' + license.profile.hash + '">' + license.profile.name + '</a></li>'+
                                    '<li>' + license.email + '</li>'+
                                    '<li>' + license.permission + '</li>'+
                                    '</ul>'+
                                    '</div>'+
                                    '<a href="javascript:void(0)" onclick="removeLicense(' + license.id + ')"><span class="th-close">×</span></a>'+
                                    '</div></div>';
                        } else {
                            toAppend += '<div class="th-license-user-box">' +
                                    '<div class="user-box">'+
                                    '<div class="picture"><img src="http://img.thehuxley.com/data/images/app/profile/thumb/default.jpg" alt="' + license.email + '"></div>'+
                                    '<div class="info license">'+
                                    '<ul>'+
                                    '<li>' + license.email + '</li>'+
                                    '<li class="muted"><small>Aguardando confirmação de cadastro</small></li>'+
                                    '</ul>'+
                                    '</div>'+
                                    '<a href="javascript:void(0)" onclick="removeLicense(' + license.id + ')"><span class="th-close">×</span></a>'+
                                    '</div></div>';
                        }

                    });
                    if(offset == 0){
                        huxley.generatePagination('license-pagination',getLicense,limit,data.total);
                    }
                    $('#license-list').append(toAppend);
                    huxley.hideLoading();

                }
            });
        };
        function removeLicense(id){
            $.ajax({
                url: '/huxley/group/removeUser',
                data: 'id=' + id,
                beforeSend: huxley.showLoading(),
                dataType: 'json',
                success: function(data) {
                    if(data.status=="ok"){
                        huxley.notify(data.txt);
                        updateTotal();
                        getLicense(lastIndex);
                    }else{
                        huxley.error(data.txt);
                    }
                    huxley.hideLoading();
                }
            });
        };
        var selectedOption;
        var searchUserTextInputTimeOut;
        var totalIndexUserSearch = -1;
        var emailList = []
        var activeBar = 'TEACHER';
        var inputEmail, resultList;
        $(function() {
            $('#teacher-input-email, #student-input-email').keyup(function(event) {
                clearTimeout(searchUserTextInputTimeOut);
                searchUserTextInputTimeOut = setTimeout(function() {
                    if(activeBar === "TEACHER") {
                        inputEmail = $("#teacher-input-email");
                        resultList = $("#teacher-search-list");
                    } else {
                        inputEmail = $("#student-input-email")
                        resultList = $("#student-search-list");
                    }
                    if(!(totalIndexUserSearch != -1 && (event.keyCode==40||event.keyCode==38||event.keyCode==13))){
                        if (inputEmail.val() != '') {
                            $.ajax({
                                url: hx.util.url('profile/search'),
                                data: 'offset=0&max=5&name=' + inputEmail.val() ,
                                beforeSend: huxley.showLoading(),
                                dataType: 'json',
                                success: function(data) {
                                    $("#teacher-search-list, #student-search-list").empty();
                                    totalIndexUserSearch = -1;
                                    var toAppend = '<ul>';
                                    $.each(data.profileList, function(i, license) {
                                        totalIndexUserSearch ++;
                                        emailList[i] = license.user.email;
                                        if (license.profile !== null) {
                                            toAppend += '<li><div class="th-search-user-box" id="search-user-box-' + i + '">' +
                                                    '<div class="user-box">'+
                                                    '<div class="picture"><img src="http://img.thehuxley.com/data/images/app/profile/thumb/' + license.profile.smallPhoto + '" alt="' + license.profile.name + '"></div>'+
                                                    '<div class="info license">'+
                                                    '<ul>'+
                                                    '<li class="name">' + license.profile.name + '</li>'+
                                                    '<li>' + license.user.email + '</li>'+
                                                    '</ul>'+
                                                    '</div>'+
                                                    '</div></div></li>';
                                        } else {
                                            toAppend += '<li><div class="th-search-user-box" id="search-user-box-' + i + '">' +
                                                    '<div class="user-box">'+
                                                    '<div class="picture"><img src="http://img.thehuxley.com/data/images/app/profile/thumb/default.jpg" alt="' + license.user.email + '"></div>'+
                                                    '<div class="info license">'+
                                                    '<ul>'+
                                                    '<li>' + license.user.email + '</li>'+
                                                    '<li class="muted"><small>Aguardando confirmação de cadastro</small></li>'+
                                                    '</ul>'+
                                                    '</div>'+
                                                    '</div></div></li>';
                                        }

                                    });
                                    toAppend += '</ul>';
                                    resultList.append(toAppend);
                                    $('.th-search-user-box').hover(function () {
                                        selectUserSearchOption(this.id.substring(16,17)) ;
                                    })
                                    $('.th-search-user-box').click(function () {
                                        selectUserSearchOption(this.id.substring(16,17)) ;
                                        inputEmail.val(emailList[selectedOption]);
                                        resultList.hide().fadeOut('fast');
                                        totalIndexUserSearch = 0;
                                        selectedOption = -1;
                                    });
                                    selectUserSearchOption(0);
                                    huxley.hideLoading();

                                }
                            });
                            $(document).one("click", function() {
                                resultList.hide().fadeOut('fast')
                                selectedOption = -1;
                                totalIndexUserSearch = -1;
                            });
                            resultList.show().fadeIn('fast');
                        } else {
                            resultList.hide().fadeOut('fast')

                        }

                    }
                }, 300);
            });

            $('#teacher-input-email, #student-input-email').keydown(function(event) {
                if(totalIndexUserSearch != -1 && (event.keyCode==40||event.keyCode==38||event.keyCode==13)){
                    switch (event.keyCode){
                        case 13:
                            if (totalIndexUserSearch === 0) {
//                                validateEmail();
                                selectedOption = -1;

                            }
                            inputEmail.val(emailList[selectedOption]);
                            resultList.hide().fadeOut('fast');
                            totalIndexUserSearch = 0;
                            break;
                        case 38 :
                            selectedOption = (selectedOption === 0)?totalIndexUserSearch:selectedOption - 1;
                            selectUserSearchOption(selectedOption);
                            break;
                        case 40 :
                            selectedOption = (selectedOption===totalIndexUserSearch)?0:selectedOption + 1;
                            selectUserSearchOption(selectedOption);
                            break;
                    }

                }
            });


        });

        function selectUserSearchOption(option) {
            selectedOption = option;
            $('.th-search-user-box').removeClass('selected');
            $('#search-user-box-' + option).addClass('selected');
        }
        function validateTeacherEmail() {
            var emailMsgContainer = $('#teacher-email-msg');
            emailMsgContainer.empty();
            emailMsgContainer.removeClass();
            if (!$('#create-teacher').hasClass('disabled')) {
                var validEmail=/^.+@.+\..{2,}$/;
                if(validEmail.test($('#teacher-input-email').val())){
                    emailMsgContainer.append('<g:message code="verbosity.adding"/>');
                    emailMsgContainer.addClass('th-warning');
                    $.ajax({
                        url: '/huxley/license/addTeacher',
                        data: 'group=${group.id}&email=' + $('#teacher-input-email').val(),
                        beforeSend: huxley.showLoading(),
                        dataType: 'json',
                        success: function(data) {
                            emailMsgContainer.empty();
                            emailMsgContainer.removeClass();
                            if(data.status=="ok") {
                                emailMsgContainer.addClass('th-success');
                                updateTotal();
                                getLicense(lastIndex);
                            } else {
                                emailMsgContainer.addClass('th-field-error');
                            }
                            emailMsgContainer.append(data.txt);
                            huxley.hideLoading();
                        },
                        error: function () {
                            emailMsgContainer.empty();
                            emailMsgContainer.removeClass();
                            emailMsgContainer.addClass('th-field-error');
                            emailMsgContainer.append('Ocorreu um erro, tente novamente mais tarde');
                            huxley.hideLoading();
                        }
                    });
                } else {
                    emailMsgContainer.append('<g:message code="verbosity.email.invalid"/>');
                    emailMsgContainer.addClass('th-field-error');
                }
            } else {
                emailMsgContainer.addClass('th-field-error');
                emailMsgContainer.append('Não há licenças disponíveis')
            }
        }
        function validateStudentEmail() {
            var emailMsgContainer = $('#student-email-msg');
            emailMsgContainer.empty();
            emailMsgContainer.removeClass();
            if (!$('#create-student').hasClass('disabled')) {
                var validEmail=/^.+@.+\..{2,}$/;
                if(validEmail.test($('#student-input-email').val())){
                    emailMsgContainer.append('<g:message code="verbosity.adding"/>');
                    emailMsgContainer.addClass('th-warning');
                    $.ajax({
                        url: '/huxley/group/addStudent',
                        data: 'id=${group.id}&email=' + $('#student-input-email').val(),
                        beforeSend: huxley.showLoading(),
                        dataType: 'json',
                        success: function(data) {
                            emailMsgContainer.empty();
                            emailMsgContainer.removeClass();
                            if(data.status=="ok") {
                                emailMsgContainer.addClass('th-success');
                                updateTotal();
                                getLicense(lastIndex);
                            } else {
                                emailMsgContainer.addClass('th-field-error');
                            }
                            emailMsgContainer.append(data.txt);
                            huxley.hideLoading();
                        },
                        error: function () {
                            emailMsgContainer.empty();
                            emailMsgContainer.removeClass();
                            emailMsgContainer.addClass('th-field-error');
                            emailMsgContainer.append('Ocorreu um erro, tente novamente mais tarde');
                            huxley.hideLoading();
                        }
                    });
                } else {
                    emailMsgContainer.append('<g:message code="verbosity.email.invalid"/>');
                    emailMsgContainer.addClass('th-field-error');
                }
            } else {
                emailMsgContainer.addClass('th-field-error');
                emailMsgContainer.append('Não há licenças disponíveis')
            }
        }

        $(function() {
            addTeacherTab();
            $('#create-teacher').on('click', validateTeacherEmail);
            $('#create-student').on('click', validateStudentEmail);
            $('#input-license').keyup(function() {
                clearTimeout(licenseSearchInputTimeOut);
                licenseSearchInputTimeOut = setTimeout(function() {
                    name = $("#input-license").val();
                    getLicense(0);
                }, 1000);
            });
            var collection = new hx.models.TopCoder();
            collection.url = hx.util.url.rest('topcoders');
            (new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')})).render();
            collection.fetch({reset: true});
        });



        function updateTotal() {
            $.ajax({
                url: '/huxley/license/getLicensePackInfo',
                data: 'groupId=${group.id}',
                dataType: 'json',
                success: function(data) {
                    var msgContainer = $('#teacher-licenses-available-create, #student-licenses-available-create, #licenses-available-pendencies'), createTeacherButtom = $('#create-teacher, #create-student'), acceptButtons = $('.js-accept');
                    msgContainer.empty();
                    msgContainer.append('Existem ' + (data['TOTAL'] - data['USED']) + ' licenças disponíveis');

                }
            });
        }

    </script>
</head>
<body>
<div class="th-tabbed-pane"><ul><li><a class="th-tabbed-pane-tab selected" id="teacher-tab" href="javascript:addTeacherTab()"><g:message code="license.add.teacher"/></a></li><li><a class="th-tabbed-pane-tab" id="student-tab" href="javascript:addStudentTab()"><g:message code="license.add.student"/></a></li><li><a class="th-tabbed-pane-tab" id="pendencies-tab" href="javascript:managePendenciesTab()">Gerenciar Pendências</a></li><li><a class="th-tabbed-pane-tab" id="key-tab" href="javascript:manageKeyTab()">Chave de Acesso</a></li></ul></div>
<div class="box tabbed" id="add-teacher">

    <span class="th-right muted th-license-available"><small id="teacher-licenses-available-create"></small></span>
    <h3><g:message code="license.create.teacher.license"/></h3>
    <div class="th-clear"></div>
    <div>
        <input type="text" name="name" placeholder="${message(code: 'verbosity.add.user.by.email')}" autocomplete="off" style="width: 62%;" class="th-input" id="teacher-input-email"  /><a class="btn btn-success" id="create-teacher"><g:message code="license.add"/></a>
    </div>
    <span id="teacher-email-msg"></span>
    <div class="th-search-container">
        <div id="teacher-search-list" class="th-search-result-container"></div>
    </div>

</div>
<div class="th-clear"></div>

<div class="box tabbed" id="add-student">

    <span class="th-right muted th-license-available"><small id="student-licenses-available-create"></small></span>
    <h3><g:message code="license.create.student.license"/></h3>
    <div class="th-clear"></div>
    <div>
        <input type="text" name="name" placeholder="${message(code: 'verbosity.add.user.by.email')}" autocomplete="off" style="width: 62%;" class="th-input" id="student-input-email"  /><a class="btn btn-success" id="create-student"><g:message code="license.add"/></a>
    </div>
    <span id="student-email-msg"></span>
    <div class="th-search-container">
        <div id="student-search-list" class="th-search-result-container"></div>
    </div>
</div>
<div class="th-clear"></div>

<div class="box tabbed" id="manage-pendencies">
    <span class="th-right muted th-license-available"><small id="licenses-available-pendencies"></small></span>
    <h3><g:message code="license.teacher.pendencies"/></h3>
    <div class="th-clear"></div>

    <div id="pendency-list">
        <table class="table table-striped">
            <tbody>

            </tbody>
        </table>
    </div>
</div>

<div class="box tabbed" id="manage-access-key">
    <div class="th-access-key-info-container">
        <g:message code="group.access.key.create.now"/>
        <div class="th-access-key-container" id="access-key">
            ${group.accessKey}
        </div>
        <a href="javascript:generateAccessKey()" class="btn btn-success th-right"><g:message code="group.access.key.generate"/></a>
        <div><small><g:message code="group.access.key.explanation"/></small></div>

    </div>
</div>


<hr /><br />


<div class="box"><!-- Search box -->
    <div class="th-license-list-header">
        <h3 id="search-title" ></h3>
        <input type="text" name="name" placeholder="${message(code: 'verbosity.search.user')}" class="th-input th-right" id="input-license"  />
    <div class="th-clear"></div>
    </div>


    <div id="license-list">
    </div>

<span id="license-pagination" class="ui-pagination"></span>
    <div class="th-clear"></div>
</div>

<div id="pendency-modal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="pendencyModal" aria-hidden="true">

</div>

<script type="text/template" id="reject-modal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 style="font-size: 24.5px">{{ userCreated.name }}</h3>
    </div>
    <div class="modal-body">
        <div class="alert">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            Será enviado um e-mail com o motivo da rejeição.
        </div>
        <label>
            Justificativa:
            <textarea style="margin: 0px; height: 160px; width: 524px; resize: none;"></textarea>
        </label>
    </div>
    <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">Cancelar</button>
        <button class="btn btn-danger js-reject-confirm">Rejeitar</button>
    </div>
</script>

<script type="text/template" id="document-modal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 style="font-size: 24.5px">{{ userCreated.name }}</h3>
    </div>
    <div class="modal-body">
        <div id="myCarousel" data-interval="false" class="carousel slide">
            <ol class="carousel-indicators">

            </ol>
            <div class="carousel-inner">

            </div>
            <a class="carousel-control left" href="#myCarousel" data-slide="prev">&lsaquo;</a>
            <a class="carousel-control right" href="#myCarousel" data-slide="next">&rsaquo;</a>
        </div>
    </div>
</script>

<script type="text/template" id="pendency-item">
    <tr>
        <td>
            <div class="row-fluid">
                <div class="span8">
                    {{ userCreated.name }}
                </div>

                <div class="span4">
                    <small class="muted pull-right">{{ dateCreated }}</small>
                </div>
            </div>
            <div class="row-fluid">
                <div class="span2">
                    <span class="label {{ className }}">{{ statusLabel }}</span>
                </div>
                <div class="span10">
                    <div class="pull-right">
                        <buttom class="btn btn-primary btn-small js-show-doc">Ver comprovante</buttom>
                        <buttom {{ status === 1 ? "disabled" : "" }} class="btn btn-success btn-small js-accept">Aceitar</buttom>
                        <buttom {{ status === 2 ? "disabled" : "" }} class="btn btn-danger  btn-small js-reject">Rejeitar</buttom>
                    </div>
                </div>
            </div>
        </td>
    </tr>
</script>

<script type="text/javascript">
    $(function () {

        _.templateSettings = {
            interpolate : /\{\{(.+?)\}\}/g
        };

        moment.lang('pt-br');

        var fetchingPendencies = function () {
            var msgContainer = $('#licenses-available-pendencies');
            $.ajax({
                url: '/huxley/pendency/listGroupPendencies/',
                data: {id: ${group.id}},
                dataType: 'json',
                success: function (data) {
                    $('#pendency-list').find('tbody').empty();
                    if (data.length > 0) {
                        $.each(data, function (i, pendency) {

                            pendency.dateCreated = moment(pendency.dateCreated).startOf('second').fromNow();


                            if (pendency.status === 0) {
                                pendency.statusLabel = "Aguardando"
                                pendency.className = "label-warning"
                            } else if (pendency.status === 1) {
                                pendency.statusLabel = "Aceito"
                                pendency.className = "label-success"
                            } else if (pendency.status === 2) {
                                pendency.statusLabel = "Rejeitado"
                                pendency.className = "label-important"
                            }

                            pendency.title = "Instituição " + pendency.statusLabel;

                            var dom = $(_.template($('#pendency-item').html(), pendency));

                            $('#pendency-list').find('tbody').append(dom);

                            dom.delegate('buttom.js-show-doc:not([disabled])', 'click', function () {
                                var list, inner, template;
                                template= $(_.template($('#document-modal').html(), pendency));
                                list = template.find('.carousel-indicators');
                                inner = template.find('.carousel-inner');
                                $.each(pendency.document, function (i, document) {
                                    list.append('<li data-target="#myCarousel" data-slide-to="' + i + '" class="' + (i === 0 ? 'active' : '') + '"></li>');
                                    inner.append('<div class="' + (i === 0 ? 'active' : '') + ' item">' +
                                            '<img style="margin: auto; display: block;" src="/data/images/app/doc/' + document + '">' +
                                            '</div>'
                                    );
                                });
                                $('#pendency-modal').html(template);
                                $('#pendency-modal').modal();
                            });

                            dom.delegate('buttom.js-accept:not([disabled])', 'click', function () {
                                $(this).siblings('small').text('Surprise!');
                                if (!$(this).hasClass('disabled')) {
                                    $.get('/huxley/pendency/acceptGroupPendency', {id: pendency.id}).done(function () {
                                        getLicense(lastIndex);
                                        fetchingPendencies();
                                    });
                                    msgContainer.empty();
                                    msgContainer.append('Atualizando...');
                                }

                            });
                            dom.delegate('buttom.js-reject:not([disabled])', 'click', function () {
                                var template = $(_.template($('#reject-modal').html(), pendency));
                                $('#pendency-modal').html(template);
                                $('#pendency-modal').modal();
                                $(template).delegate('button.js-reject-confirm', 'click', function () {
                                    $.post('/huxley/pendency/rejectGroupPendency', {id: pendency.id, message: $(template).find('textarea').val()}).done(function () {
                                        getLicense(lastIndex);
                                        fetchingPendencies();
                                    });
                                    $('#pendency-modal').modal('hide');
                                    msgContainer.empty();
                                    msgContainer.append('Atualizando...');
                                });
                            });
                        });
                    } else {
                        $("#pendency-list").empty();
                        $("#pendency-list").append('<g:message code="pendencies.search.empty"/>');
                    }
                    updateTotal();
                }
            });
        }

        fetchingPendencies();

    });


</script>
</body>
</html>