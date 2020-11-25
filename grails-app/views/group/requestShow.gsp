<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta name="layout" content="main-head"/>
<script type="text/javascript">
    <g:if test="${msg}">
    $(function (){
        $('#message-field').addClass("alert");
        $('#message-field').html("${msg}").alert();
    });
    </g:if>
    $(function () {
        var collection = new hx.models.TopCoder();
        collection.url = hx.util.url.rest('topcoders');
        (new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')})).render();
        collection.fetch({reset: true, data: {id: '${clusterInstance.hash}'}});
    });
    $(function(){
        getStudents();
        getMaster();
        $("#request-modal").modal();
    });
    function createBox(user){
        var box = '<div class="group-show-user"><div class="user-box">'+
                '<div class="picture"><img src="http://img.thehuxley.com/data/images/app/profile/thumb/' + user.photo + '" alt="' + user.name + '"></div>'+
                '<div class="info">'+
                '<ul>'+
                '<li class="name"><a href="/huxley/profile/show/' + user.hash + '">' + user.name + '</a></li>';
        if(user.institution != undefined){
            box += '<li class="institution">' + user.institution +'</li>';
        }
                box += '</ul>'+
                '</div>'+
                '</div></div>';
        return box;
    }
    function getStudents(){
        $.ajax({
            url: '${resource(dir:'/')}group/getStudents/',
            data: 'id=${clusterInstance.id}',
            dataType: 'json',
            async: false,
            success: function(data) {
                $('#student-list').empty();
                var students = data.students;
                $.each(students, function(i, student) {
                    $('#student-list').append(createBox(student));
                });
            }
        });

    }
    function getMaster(){
        $.ajax({
            url: '${resource(dir:'/')}group/getMasters/',
            data: 'id=${clusterInstance.id}',
            dataType: 'json',
            async: false,
            success: function(data) {
                $('#master-list').empty();
                var students = data.masters;
                $.each(students, function(i, student) {
                    $('#master-list').append(createBox(student));
                });
            }
        });
    }

    function send() {
        $("#request-form").submit();
    }
</script>
</head>
<body>
<div class="container content">
<div class="container">
<div class="left-content">

<div id="box-content" class="box"><div class="group-show-header">
    <a href="#request-modal" role="button" data-toggle="modal" class="btn btn-small btn-success pull-right" style="margin-top: 6px;"><g:message code="group.join"/></a><h1 class="page-title">${clusterInstance.name}</h1>
</div>
<div class="group-show-members group-list clearfix" id="student-list">

</div>
<div class="group-show-header">
    <h2><g:message code="group.teacher.monitor"/></h2>
</div>
<div class="group-show-teachers group-list clearfix" id="master-list">
</div>

</div>

</div>

</div>
<div class="clear"></div><br />
</div>
<div id="request-modal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-show="false">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3><g:message code="group.confirm.join"/></h3>
    </div>
    <div class="modal-body">
        <g:form class="form-inline" action="requestGroupInvite" controller="pendency" name="request-form">
            <h3><g:message code="group.request.text"/></h3>
            <label for="accessKey" ><g:message code="group.access.key"/>:&nbsp </label><input type="text" name="accessKey" id="accessKey" class="input-small"/>
            <h6 style="font-size: 10px;"><g:message code="group.access.key.text"/></h6>
            <g:hiddenField name="id" value="${clusterInstance.id}"/>
        </g:form>
    </div>
    <div class="modal-footer">
        <button class="btn btn-small btn-danger" data-dismiss="modal" aria-hidden="true"><g:message code="group.cancel"/></button>
        <a href="javascript:send();" class="btn btn-small btn-success pull-right btn-primary"><g:message code='group.join'/></a>
    </div>
</div>
</body>
</html>