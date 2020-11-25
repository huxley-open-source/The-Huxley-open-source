<%@ page import="com.thehuxley.Institution" %>
<%@ page import="com.thehuxley.util.HuxleyProperties" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <link rel="stylesheet" href="${resource(dir: 'css/jCrop', file: 'jquery.Jcrop.css')}" type="text/css">
    <script src="${resource(dir:'js', file:'fileuploader.js')}"></script>
    <script src="${resource(dir:'js/jCrop', file:'jquery.Jcrop.min.js')}"></script>

    <style type="text/css" id="page-css">
        .profile-error {
            font-size: .9em;
            color: #AE3232;
        }
    </style>

    <script type="text/javascript">
        var xCrop, yCrop, widthCrop, heightCrop, fileNameToCrop;
        function validateUsername(){
            var isValid = false, statusMsg = $("#profile-username-error"), username = $("#input-username").val();
            statusMsg.empty();
            if (username !== '${profileInstance.user.username}') {
                $.ajax({
                    url: huxley.root + 'auth/validateUsername',
                    async: false,
                    data:'username='+ username,
                    dataType: 'json',
                    success: function(data) {
                        if(data.msg.status == 'ok'){
                            isValid = true;
                        } else {
                            statusMsg.append('${message(code: "auth.message.in.use")}!');
                        }
                    }
                });
            } else {
                isValid = true;
            }

            return isValid;
        }
        function showCoordinates(c)
        {
            xCrop = c.x;
            yCrop = c.y;
            widthCrop = c.w;
            heightCrop = c.h;
        };

        function submit(){
            if(validateUsername()){
                $("#save").submit();
            }

        }
        <g:if test="${profileInstance}">
        $(function() {
            $("#profile").val("${profileInstance.id}");
        });
        </g:if>
        $(function() {
            $("#input-username").blur(function(event){
                validateUsername();
            });

            createUploader();
        });

        function createUploader(){
            var uploader = new qq.FileUploader({
                element: document.getElementById('file-uploader'),
                action: huxley.root + 'profile/uploadImage',
                allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
                sizeLimit: 1048576,
                onComplete: function(id, fileName, responseJSON) {
                    updateImage(responseJSON.data);
                },
                template: '<div class="qq-uploader">' +
                        '<div class="qq-upload-drop-area" style="background: none repeat scroll 0 0 black; bottom: 30px; color: white; float: left; opacity: 0.5; padding: 5px; position: relative; text-align: center; width: 185px;"><g:message code="fileupload.drop.image" /></div>' +
                        '<div class="qq-upload-button" style="background: none repeat scroll 0 0 black; bottom: 30px; color: white; float: left; opacity: 0.5; padding: 5px; position: relative; text-align: center; width: 185px;"><g:message code="profile.change.photo" /></div>' +
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
        fileNameToCrop = fileName;

        var imgLoad = $("<img />");
        imgLoad.attr("src", "${HuxleyProperties.getInstance().get("image.profile.dir")}temp/" + fileName);
        imgLoad.unbind("load");
        imgLoad.bind("load", function () {

            if(this.width > 245 && this.height > 205){
                $('#jCrop').empty().append($('<img id="target" >'))
                huxley.openModal("image-processing");
                $('#target').attr('src', "${HuxleyProperties.getInstance().get("image.profile.dir")}temp/" + fileName );
                $('#target').Jcrop({
                    onSelect: showCoordinates,
                    bgColor:     'black',
                    bgOpacity:   .4,
                    boxWidth: 600,
                    boxHeight: 400,
                    aspectRatio: 195/155,
                    setSelect:   [ 0, 0, 50, 50 ],
                    minSize:[195, 155]
                });

            } else {
                alert("Por favor, envie uma imagem maior que 245x205");
            }
        });
    }

        function jCrop() {
            $.ajax({
                url: huxley.root + 'profile/crop  ',
                data: {x:xCrop, y:yCrop, width:widthCrop, height:heightCrop, image: fileNameToCrop},
                dataType: 'json',
                success: function(data) {
                    console.log(data.status)
                   if(data.status) {
                       huxley.closeModal();
                       console.log('atualizada com sucesso');
                       console.log(data.file)
                       $("#profilePhoto").val(data.file);
                       $('#img').attr('src', "${HuxleyProperties.getInstance().get("image.profile.dir")}temp/" + data.file );
                   } else {
                       alert("Ocorreu um erro ao atualizar a imagem, por favor, tente enviar outra imagem");
                   }

                }
            });
        }


    </script>
</head>
<body>
<div class="box"><!-- Courses box -->
    <h3><g:message code="profile.edit"/> <a href="javascript:submit();"  class="ui-gbutton" id="save-button"><g:message code="profile.save"/></a></h3>
</div>
<hr /><br />
<div class="box">
    <g:form action="save" name="save" id="save-form">
        <g:if test="${profileInstance}">
            <g:hiddenField name="profileId" value="${profileInstance.id}"></g:hiddenField>
            <g:hiddenField id="profilePhoto" name="profilePhoto" value="${profileInstance.photo}"></g:hiddenField>
            <div id="profile" style="width: 200px; float: left;">
                <img id="img" src="${HuxleyProperties.getInstance().get("image.profile.dir") + profileInstance.photo}" border="0" width="195px" height="155"/>
                <div id="file-uploader"></div>
            </div>
             <div style="float: right; width: 470px; height: 156px">
                <table>
                    <tr style="height: 39px">
                        <td style="text-align: right; padding: 0 10px 5px 10px;"><h2><g:message code="profile.name"/>:</h2></td>
                        <td><input type="text" name="name" value="${profileInstance.name}" style="width: 350px;" class="ui-input2" id="input-name"  /></td>
                    </tr>
                    <tr style="height: 39px">
                        <td style="text-align: right; padding: 0 10px 5px 10px;"><h2><g:message code="profile.email"/>:</h2></td>
                        <td><input type="text" name="email" value="${profileInstance.user.email}" style="width: 350px;" class="ui-input2" id="input-email"  /></td>
                    </tr>
                    <tr style="height: 39px">
                        <td style="text-align: right; padding: 0 10px 5px 10px;"><h2><g:message code="verbosity.username"/>:</h2></td>
                        <td><input type="text" name="username" value="${profileInstance.user.username}" style="width: 350px;" class="ui-input2" id="input-username"  />
                        <span class="profile-error" id="profile-username-error"></span></td>
                    </tr style="height: 39px">
                    <g:if test="${session.license.isAdmin()}">
                    <tr style="height: 39px">
                        <td style="text-align: right; padding: 0 10px 5px 10px;"><h2><g:message code="verbosity.institution"/>:</h2></td>
                        <td><g:select name="institution" from="${Institution.list()}" optionKey="id" optionValue="name" value="${profileInstance.institution?.id}"/></td>
                    </tr>
                    </g:if>
                    <g:else>
                    <tr style="height: 39px">
                        <td style="text-align: right; padding: 0 10px 5px 10px;"><h2><g:message code="verbosity.institution"/>:</h2></td>
                        <td><g:select name="institution" from="${institutionList}" optionKey="id" optionValue="name" value="${profileInstance.institution?.id}"/></td>
                    </tr>
                    </g:else>
                </table>
            </div>
        </g:if>
        <g:else>
            <g:hiddenField id="profilePhoto" name="profilePhoto" value=""></g:hiddenField>
            <div style="width: 200px; float: left;">
                <img id="img" src="${HuxleyProperties.getInstance().get("image.profile.dir")}" border="0" width="195px" height="155"/>
                <div id="file-uploader"></div>
            </div>
            <div style="float: right; width: 470px;">
                <table>
                    <tr>
                        <td style="text-align: right; padding: 0 10px 5px 10px;"><h3><g:message code="profile.name"/>:</h3></td>
                        <td><input type="text" name="name" value="${profileInstance.name}" style="width: 350px;" class="ui-input2" id="input-group"  /></td>
                    </tr>
                    <tr>
                        <td style="text-align: right; padding: 0 10px 5px 10px;"><h3><g:message code="profile.email"/>:</h3></td>
                        <td><input type="text" name="email" value="${profileInstance.user.email}" style="width: 350px;" class="ui-input2" id="input-group"  /></td>
                    </tr>
                    <g:if test="${session.license.isAdmin()}">
                    <tr>
                        <td style="text-align: right; padding: 0 10px 5px 10px;"><h3><g:message code="verbosity.institution"/>:</h3></td>
                        <td><g:select name="institution" from="${Institution.list()}" optionKey="id" optionValue="name" value="${profileInstance.institution?.id}"/></td>
                    </tr>
                    </g:if>
                    <g:else>
                    <tr>
                        <td style="text-align: right; padding: 0 10px 5px 10px;"><h3><g:message code="verbosity.institution"/>:</h3></td>
                        <td><g:select name="institution" from="${institutionList}" optionKey="id" optionValue="name" value="${profileInstance.institution?.id}"/></td>
                    </tr>
                    </g:else>
                </table>
            </div>
        </g:else>
        <br />
        <hr/>
        <div style="clear: left;"></div>
        <h3><g:link action="changePassword" class="ui-gbutton"><g:message code="profile.change.password"/></g:link></h3>
        <div style="clear: left; padding-bottom: 20px;"></div>
    </g:form>
</div>
</div>
<hr /><br />
<div id="image-processing" class="modal-window modal">
        <div >
            <div id="jCrop" >

                <img id="target" src="${HuxleyProperties.getInstance().get("image.profile.dir")}"  />

            </div>
            <div style="height: 50px">
                 <hr>
                 <a href="javascript:jCrop();"  class="button" style="background: #1bd482;">Salvar Imagem</a>
                 <a href="javascript:huxley.closeModal()" class="button">Cancelar</a>
            </div>
        </div>
</div>
</body>
</html>
