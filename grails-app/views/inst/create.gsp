<%@ page import="com.thehuxley.util.HuxleyProperties" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'fileuploader.js')}"></script>
    <script src="${resource(dir:'js', file:'huxley-double-list-container.js')}"></script>
    <script type="text/javascript">
        function submit(){
            $("#save").submit();
        }
        <g:if test="${instInstance}">
        $(function() {
            $("#inst").val("${instInstance.id}");
        });
        </g:if>
        $(function() {
            createUploader();
        });

        function createUploader(){
            var uploader = new qq.FileUploader({
                element: document.getElementById('file-uploader'),
                action: huxley.root + 'inst/uploadImage',
                allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
                sizeLimit: 1048576,
                onComplete: function(id, fileName, responseJSON) {
                    updateImage(responseJSON.data);
                },
                template: '<div class="qq-uploader">' +
                        '<div class="qq-upload-drop-area"><span><g:message code="fileupload.drop" /></span></div>' +
                        '<div class="qq-upload-button" style="width: 138px;"><g:message code="institution.change.photo" /></div>' +
                        '<ul class="qq-upload-list" style="display: none;"></ul>' +
                        '</div>',
                messages: {
                    typeError: "{file} ha ha ha ha ha ha {extensions} are allowed.",
                    sizeError: "{file} is too large, maximum file size is {sizeLimit}.",
                    minSizeError: "{file} is too small, minimum file size is {minSizeLimit}.",
                    emptyError: "{file} is empty, please select files again without it.",
                    onLeave: "The files are being uploaded, if you leave now the upload will be cancelled."
                }
            });
        }
    function updateImage(fileName){
        console.log(fileName);
        $("#instPhoto").val(fileName);
        $('#img').attr('src', "${HuxleyProperties.getInstance().get("image.profile.dir")}temp/" + fileName );
    }
        $(function() {
            huxleyDLC.initialize('user-list','selected-list');
            $('#input-user').keyup(function() {
                clearTimeout(userSearchInputTimeOut);
                userSearchInputTimeOut = setTimeout(function() {
                    populateLeftList($("#input-user").val());
                }, 1000);
            });
            <g:if test="${instInstance.id}">
                populateRightList();
            </g:if>

        });
        var userSearchInputTimeOut;

        function populateLeftList(name){
            $.ajax({
                url: huxley.root + 'group/getUserBoxLeftList',
                async: true,
                data: 'name=' + name + '&selectedIdList=' + huxleyDLC.selectedId,
                dataType: 'json',
                success: function(data) {
                    huxleyDLC.populateLeftList(data.content);
                }
            });
        }
        <g:if test="${instInstance.id}">
        function populateRightList(){
            $.ajax({
                url: huxley.root + 'inst/getUserBoxRightList',
                data: 'id=' + ${instInstance.id},
                async: true,
                dataType: 'json',
                success: function(data) {
                    huxleyDLC.populateRightInstList(data.content, data.selectedIdList);
                    update();
                }
            });
        }
        </g:if>
        function addToGroupList(userId){
            $("#action-icon-" + userId).empty();
            $("#action-icon-" + userId).append('<a href="javascript:removeFromGroupList(' + userId + ')" class="ui-rbutton" style="float: right; padding: 6px 12px;">-</a>');
            var content = '';
            content += '<div id="s'+userId+'">'+
                    $("#info-"+userId).html()+
                   '</div>';
            huxleyDLC.addToGroupList(userId,content);
            update();
        }
        function removeFromGroupList(userId){
            huxleyDLC.removeFromGroupList(userId);
            update();
        }
        function update(){
            var mL = [];
            $.each(huxleyDLC.selectedId, function(i, idSelected) {
                    mL.push(idSelected);
            });
            console.log(mL);
            $("#sList").val(mL);
        }


    </script>
</head>
<body>
<div class="box"><!-- Courses box -->
    <h3><g:message code="institution.edit"/> <a href="javascript:submit();" class="ui-gbutton"><g:message code="institution.save"/></a></h3>
</div>
<hr /><br />
<div class="box">
    <g:form action="save" name="save">
        <g:if test="${instInstance}">
            <g:hiddenField name="instId" value="${instInstance.id}"></g:hiddenField>
            <g:hiddenField id="instPhoto" name="instPhoto" value="${instInstance.photo}"></g:hiddenField>
            <g:hiddenField name="sList" value="" id="sList"/>
            <div class="photo">
                <div><img id="img" src="${HuxleyProperties.getInstance().get("image.profile.dir")}" border="0" width="200" height="155"/></div>
                <div style=" margin-top: -20px;margin-left: 110px;"><div id="file-uploader"></div></div>
                </br>
            </div>
            <h3><g:message code="institution.name"/> <input type="text" name="name" value="${instInstance.name}" style="float:right;display:table;width: 70%;" class="ui-input2" id="input-group"  /></h3>
            </br>
            <h3><g:message code="institution.phone"/> <input type="text" name="phone" value="${instInstance?.phone}" style="float:right;display:table;width: 70%;" class="ui-input2" id="input-group"  /></h3>
        </g:if>
        <g:else>
            <g:hiddenField id="instPhoto" name="instPhoto" value=""></g:hiddenField>
            <div class="photo">
                <div><img id="img" src="${HuxleyProperties.getInstance().get("image.profile.dir")}" border="0" width="200" height="155"/></div>
            <div style=" margin-top: -20px;margin-left: 110px;"><div id="file-uploader"></div></div>
            </br>
            </div>
            <h3><g:message code="institution.name"/> <input type="text" name="name" placeholder="<g:message code="institution.tip.name"/>" style="float:right;display:table;width: 70%;" class="ui-input2" id="input-group"  /></h3>
            </br>
            <h3><g:message code="institution.phone"/> <input type="text" name="phone" style="float:right;display:table;width: 70%;" class="ui-input2" id="input-group"  /></h3>

        </g:else>
        <br />
    </g:form>
<hr /><br />
    <br />
    <h3><g:message code="institution.admin.institutional"></g:message></h3>
        <input type="text" name="name" placeholder="Procurar usuário..." style="width: 62%;" class="ui-input2" id="input-user"  />
</div>
<hr /><br />
<hr />
<div class="questleft">
    <h3 style="margin-bottom: 0px;">Usuários</h3>
    <div class="scroll-pane" style="height: 315px;" id = "user-list"></div>
</div>
<div class="questright">
    <h3 style="margin-bottom: 0px;">Integrantes</h3>
    <div class="scroll-pane" style="height: 315px;" id="selected-list"></div>
</div>
</div>
</div>
<div class="clear"></div><br />

</body>
</html>