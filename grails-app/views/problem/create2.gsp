<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main" />
    <resource:richTextEditor type="advanced" />
    <link rel="stylesheet" href="${resource(dir:'js/fileuploader', file:'jquery.fileupload-ui.css')}" />

    <script type="text/javascript">
        $(function() {
            $('#accordion').accordion({
                collapsible: false
            });
        });



        $(function () {
            'use strict';

            // Initialize the jQuery File Upload widget:
            $('#fileupload').fileupload();

            // Load existing files:
            $.getJSON($('#fileupload form').prop('action'), function (files) {
                var fu = $('#fileupload').data('fileupload');
                fu._adjustMaxNumberOfFiles(-files.length);
                fu._renderDownload(files)
                        .appendTo($('#fileupload .files'))
                        .fadeIn(function () {
                            // Fix for IE7 and lower:
                            $(this).show();
                        });
            });

            // Open download dialogs via iframes,
            // to prevent aborting current uploads:
            $('#fileupload .files a:not([target^=_blank])').live('click', function (e) {
                e.preventDefault();
                $('<iframe style="display:none;"></iframe>')
                        .prop('src', this.href)
                        .appendTo('body');
            });

            $('#fileupload').fileupload().bind('drop', function (e) {
                var url = $(e.originalEvent.dataTransfer.getData('text/html')).filter('img').attr('src');
                alert(url);
                if (url) {
                    $.getImageData({
                        url: url,
                        success: function (img) {
                            var canvas = document.createElement('canvas'),
                                    file;
                            canvas.getContext('2d').drawImage(img, 0, 0);
                            if ($.type(canvas.mozGetAsFile) === 'function') {
                                file = canvas.mozGetAsFile('file.png');
                            }
                            if (file) {
                                $('#fileupload').fileupload('add', {files: [file]});
                            }
                        }
                    });
                }
            });

        });

        function formSubmit() {
            $('#problem-form').submit();
        }
    </script>
</head>

<body>
<g:if test="${problemInstance.id}">
    <div class="container">
        <div class="center">
            <ul class="menu-btn menu-btn-hor">
                <li><g:link controller="problem" action="create" id="${problemInstance.id}"><g:message code="problem.create.basic_info"/></g:link></li>
                <li class="menu-btn-active"><g:link controller="problem" action="create2" id="${problemInstance.id}"><g:message code="problem.create.description"/></g:link></li>
                <li><g:link controller="problem" action="create3" id="${problemInstance.id}"><g:message code="problem.create.testcases"/></g:link></li>
            </ul>
        </div>
    </div>
</g:if>
<g:form action="updateDescription">

    <div class="form-box">
        <h3>${problemInstance?.name}</h3>
        <div style="float: right;">
            <g:link action="create" id="${problemInstance.id}" class="button" ><g:message code="problem.prev.step"/></g:link>
            <input name="saveform" id="save-form" type="submit" value="${g.message(code:'verbosity.save')}" class="button" style="border: none;">
            <input id="submit-form" type="submit" value="${g.message(code:'problem.next.step')}" class="button" style="border: none;">
        </div>
        <div style="clear: left;"></div>
    </div>

    <hr class="form-line">

    <div id="accordion">
        <h3><a href="javascript:void(0);"><g:message code="problem.description" /></a></h3>
        <div style="overflow-y: hidden; padding: 10px 2px 20px 2px;">
            <richui:richTextEditor name="description" value="${problemInstance?.description}" width="704" height="500" />
        </div>
        <h3><a href="javascript:void(0);"><g:message code="problem.inputformat" /></a></h3>
        <div style="overflow-y: hidden; padding: 10px 2px 20px 2px;">
            <richui:richTextEditor name="inputFormat" value="${problemInstance?.inputFormat}" width="704" height="500"/>
        </div>
        <h3><a href="javascript:void(0);"><g:message code="problem.outputformat" /></a></h3>
        <div style="overflow-y: hidden; padding: 10px 2px 20px 2px;">
            <richui:richTextEditor name="outputFormat" value="${problemInstance?.outputFormat}" width="704" height="500" />
        </div>
    </div>

    <input id="problem-level" type="hidden" name="level" value="1" />
    <g:hiddenField name="id" value="${problemInstance?.id}" />
</g:form>
<div id="problem-resources" style="min-height: 100px; padding: 20px 0 0 0;">
    <div id="fileupload">
        <g:form action="uploadImage" method="POST" enctype="multipart/form-data">
            <div class="fileupload-buttonbar">
                <label class="fileinput-button">
                    <span><g:message code="problem.uploader.addfile" /></span>
                    <input type="file" name="files[]" multiple>
                </label>
                <button type="submit" class="start"><g:message code="problem.uploader.start" /></button>
                <button type="reset" class="cancel"><g:message code="problem.uploader.cancel" /></button>
                <button type="button" class="delete"><g:message code="problem.uploader.delete" /></button>
            </div>
        </g:form>
        <div class="fileupload-content">
            <table class="files"></table>
            <div class="fileupload-progressbar"></div>
        </div>
    </div>
</div>
<g:include view="teste.html"/>
<script src="${resource(dir:'js/fileuploader', file:'jquery.template.js')}"></script>
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js"></script>
<script src="//ajax.aspnetcdn.com/ajax/jquery.templates/beta1/jquery.tmpl.min.js"></script>
<script src="${resource(dir:'js/fileuploader', file:'jquery.iframe-transport.js')}"></script>
<script src="${resource(dir:'js/fileuploader', file:'jquery.fileupload.js')}"></script>
<script src="${resource(dir:'js/fileuploader', file:'jquery.fileupload-ui.js')}"></script>

</body>
</html>
