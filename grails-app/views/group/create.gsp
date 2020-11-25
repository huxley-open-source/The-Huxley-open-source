<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'moment.min.js')}"></script>

    <script type="text/javascript">
        var validUrl = false, validName = false, validDate = false, sameValue = true;
        <g:if test="${testForm}">
        $(function(){
            validateName($("#input-group").val());
            validateURL($("#input-url").val());
            validateDate();
        })
        </g:if>
        function sendForm(){
            validateName($("#input-group").val());
            validateURL($("#input-url").val());
            validDate = validateDate();
            if(validUrl && validName && validDate) {
                $("#save").submit();
            }
            return true;
        };
        function validateDate() {
            var endDate = $('#group-enddate').val();
            var startDate = $('#group-startdate').val();
            var errorDateContainer = $("#error-date");
            errorDateContainer.empty();
            if(startDate.length>0 && !moment(startDate, "DD/MM/YYYY").isValid()){
                errorDateContainer.append('<g:message code="help.invalid.date"/>');
                return false;
            }
            if(endDate.length>0 && !moment(endDate, "DD/MM/YYYY").isValid()){
                errorDateContainer.empty();
                errorDateContainer.append('<g:message code="help.invalid.date"/>');
                return false;
            }
            if(startDate.length>0 && endDate.length>0){
                errorDateContainer.empty();
                startDate = moment(startDate, "DD/MM/YYYY");
                endDate = moment(endDate, "DD/MM/YYYY");
                if(endDate.diff(startDate, 'minutes') < 0) {
                    errorDateContainer.append('<g:message code="help.invalid.date.interval"/>');
                    return false;
                }
            }

            return true
        }

        $(function() {
            var uri = window.location.protocol + "//" + window.location.host + "/group/show/ ";
            $("#uri").append(uri);
            $( "#group-startdate" ).datepicker({dateFormat: 'dd/mm/yy', onSelect: function() {
                clearTimeout(dateInputTimeOut);
                dateInputTimeOut = setTimeout(function() {
                    validateDate();
                }, 1000);
            }});
            $( "#group-enddate" ).datepicker({dateFormat: 'dd/mm/yy', onSelect: function() {
                clearTimeout(dateInputTimeOut);
                dateInputTimeOut = setTimeout(function() {
                    validateDate();
                }, 1000);
            }});
            $('#input-group').keyup(function(key) {
                clearTimeout(nameInputTimeOut);
                nameInputTimeOut = setTimeout(function() {
                    validateName($("#input-group").val());
                    if(sameValue){
                        $("#input-url").val($("#input-group").val().replaceAll(' ', '-').toLowerCase());
                        validateURL($("#input-url").val());
                    }
                }, 1000);
            });
        });
        var nameInputTimeOut;

        function validateName(name) {
            $("#error-name").empty();
            validName = false;
            if(!(name.length > 0)) {
                $('#error-name').html("<g:message code='auth.message.fill.field'/>");
                return false;
            }
            validName = true
        }

        $(function() {
            if($('#input-url').val().length > 0){
                sameValue = false;
            }
            $('#input-url').keyup(function() {
                clearTimeout(urlInputTimeOut);
                urlInputTimeOut = setTimeout(function() {
                    sameValue = false;
                    validateURL($("#input-url").val());
                }, 1000);
            });
        });
        var urlInputTimeOut;


        var dateInputTimeOut;

        <g:if test="${clusterInstance.institution}">
        $(function() {
         $("#inst").val("${clusterInstance.institution.id}");
        });
        </g:if>
        function validateURL(url){
            validUrl = false;
            if(!(url.length > 0)) {
                $('#error-url').html("<g:message code='auth.message.fill.field'/>");
                return false
            }
            $("#error-url").empty();
            var validateChar=/^[a-zA-Z0-9\-]+$/;


            if(!validateChar.test(url)) {
                $("#error-url").append("<g:message code='group.invalid.url'/>");
                return false
            } else {
                $.ajax({
                    url: huxley.root + 'group/validateURL',
                    async: false,
                    <g:if test="${clusterInstance}">
                    data:'url='+ url + "&id=${clusterInstance.id}",
                    </g:if>
                    <g:else>
                    data:'url='+ url,
                    </g:else>
                    dataType: 'json',
                    success: function(data) {
                        if(data.msg.status === 'fail'){
                            $("#error-url").append(data.msg.txt);
                        } else {
                            validUrl = true;
                        }
                    }
                });
            }
        }

    </script>
</head>
<body>
<div class="box">
    <h3>
<g:if test="${clusterInstance?.id}">
    <g:message code="group.edit"/>
</g:if>
<g:else>
    <g:message code="group.create"/>
</g:else>

    <a style = "float: right;" href="javascript:void(0);" onclick="sendForm();" class="ui-gbutton"><g:message code="group.save"/></a></h3>


</div>
<hr /><br />
<div class="box">
    <g:form action="save" name="save" class="form-horizontal">
            <g:hiddenField name="groupId" value="${clusterInstance?.id}"></g:hiddenField>
        <h3><g:message code="group.name"/>*<input type="text" autocomplete="off" name="name" placeholder="<g:message code='group.tip.name'/>" value="${clusterInstance?.name}" style="float:right;display:table;width: 70%;" class="ui-input2" id="input-group"  /></h3>
        <div id="error-name" style="font-size: 0.8em; color: red"></div>
            <br />
        <h3><g:message code="group.url.choose"/><span><input type="text" name="url" autocomplete="off"  placeholder="<g:message code='group.tip.url'/>" value="${clusterInstance?.url}" style="float:right;display:table;width: 39.7%; padding-left: 0px; border-top-left-radius: 0px; border-bottom-left-radius: 0px; border-left: none; color: #8B8B8C;" class="ui-input2" id="input-url"  /><label for="input-url" id="uri" class="ui-input2" style="float:right; padding-right: 0px; border-top-right-radius: 0px; border-bottom-right-radius: 0px; border-right: none;"></label></span></h3>
        <div id="error-url" style="font-size: 0.8em; color: red"></div><span id="result-url" style="font-size: 0.8em;"></span>
        <br />
            <h3 style="height: 21px;">
                <span style="float:left; width: 42%;">
                    <span>
                        <g:message code="group.start.date"/>
                    </span>
                    <input id="group-startdate" class="ui-input2"  style="width: 28.4%; float:right;" name="startDateString" placeholder="Início" value="${formatDate(format:"dd/MM/yyyy", date:clusterInstance?.startDate)}" type="text"  />
                </span>
                <span style="float:right; width: 45.5%;">
                    <span>
                        <g:message code="group.end.date"/>
                    </span>
                    <input id="group-enddate" class="ui-input2"  style="width: 26.2%; float:right;" name="endDateString" placeholder="Fim" value="${formatDate(format:"dd/MM/yyyy", date:clusterInstance?.endDate)}" type="text" />
                </span>
            </h3>
            <div id="error-date" style="font-size: 0.8em; color: red; clear: left;"></div>
            <br />

            <h3 style="margin-bottom: 27px; height: 34px;"><g:message code="group.description"/><textarea name="description" style="float: right; width: 476px; height: 38px; resize: none;" class="ui-input2">${clusterInstance?.description}</textarea></h3>
        <br />
        <h3><g:message code="group.institution"/>
            <span class="ui-custom-select" style="float:right;display:table;width:73%;margin-top:-5px;">
                <select name="inst" id="inst" style="width:100%;">
                    <g:each in="${instList}">
                        <option value="${it.id}">${it.name}</option>
                    </g:each>

                </select>
            </span>
        </h3>
    </g:form>
</div>
</div>
<hr /><br />
</body>
</html>
