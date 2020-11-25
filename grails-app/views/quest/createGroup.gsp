
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main-head"/>
    <g:javascript library="jquery" plugin="jquery"/>
    <r:require module="jquery-ui"/>
    <r:layoutResources />
    <style type="text/css">
        h3.page-title {
            background: transparent url('<g:resource dir="images/icons" file="icons.png"/>') no-repeat  -195px -46px;
            padding-left: 30px;
            color: #858484;
            font-family: Arial;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            margin: 25px 0px 10px 0px;
            line-height: 19px;
        }

        span.message, span.error {
            font-size: .9em;
            color: #ae3232;
        }

        .help-inline {
            display: inline-block;
            padding-left: 5px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <div class="box">
        <g:if test="${questionnaire.id == null}">
            <h3 class="page-title">Novo Questionário</h3>
        </g:if>
        <g:else>
            <h3 class="page-title">${questionnaire.title}</h3>
        </g:else>
        <br/>
        <br/>
        <g:form name="questionnaire-create" action="save" onsubmit="return validateForm();">
            <g:if test="${questionnaire.id}">
                <g:hiddenField name="id" value="${questionnaire.id}" />
            </g:if>

            <div class="controller-menu">
                <span id="questionnaire-error-message" class="message">${flash.nessage}</span>
            </div>

            <div class="control-group">
                <label class="control-label" for="questionnaire-form-title">Título: </label>
                <div class="controls">
                    <input name="title" class="input-xxlarge"  id="questionnaire-form-title" type="text" value="${questionnaire?.title}" placeholder="Digite o título do questionário..."/>
                </div>
                <span class="error help-inline" id="help-title"></span>
            </div>

            <div class="control-group">
                <label class="control-label" for="questionnaire-form-startdate">Início do questionário: </label>
                <div class="controls">
                    <input style="margin-bottom: 0 !important;" class="input-small" id="questionnaire-form-startdate" name="startDateString" placeholder="Início" value="${formatDate(format:"dd/MM/yyyy", date:questionnaire.startDate)}" type="text"  />
                    <span> &nbsp;às&nbsp;
                        <g:select id="startHour" class="input-mini inline" name="startHour"  from="${['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23']}" />
                        &nbsp;:&nbsp;
                        <g:select id="startMinute" class="input-mini inline" name="startMinute" from="${['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59']}"/>
                    </span>
                </div>
                <span class="error help-inline" id="help-start-date"></span>
            </div>

            <div class="control-group">
                <label class="control-label" for="questionnaire-form-enddate">Encerramento do questionário: </label>
                <div class="controls">
                    <input style="margin-bottom: 0 !important;" class="input-small" id="questionnaire-form-enddate" name="endDateString" placeholder="Fim" value="${formatDate(format:"dd/MM/yyyy", date:questionnaire.endDate)}" type="text" />
                    <span> &nbsp;às&nbsp;
                        <g:select id="endHour" class="input-mini inline" name="endHour" from="${['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23']}" />
                        &nbsp;:&nbsp;
                        <g:select id="endMinute" class="input-mini" name="endMinute"  from="${['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59']}"/>
                    </span>
                </div>
                <span class="error help-inline" id="help-end-date"></span>
            </div>

            <div class="control-group">
                <label class="control-label" for="questionnaire-form-description">Descrição: </label>
                <div class="controls">
                    <textarea name="description" id="questionnaire-form-description"  row="7" cols="68" style="width: 542px; resize: none; height: 147px;">${questionnaire?.description}</textarea>
                </div>
            </div>
            <g:hiddenField name="groups" id="questionnaire-create-groups" value="${groups}" />

            <div class="form-actions">
                <input type="submit" class="btn btn-primary right" value="${g.message(code:'problem.next.step')}" onclick="submitQuestionnaire();"/>
            </div>

        </g:form>
    </div>

    <script type="text/javascript">
        $(function () {
            topcoder();
            $( "#questionnaire-form-startdate" ).datepicker({dateFormat: 'dd/mm/yy'});
            $( "#questionnaire-form-enddate" ).datepicker({dateFormat: 'dd/mm/yy'});
        });

        function topcoder() {
            var view, collection = new hx.models.TopCoder();
            collection.url = hx.util.url.rest('topcoders');
            view = new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')});
            view.render();
            collection.fetch({reset: true});
        };

        function testTitle() {
            var titleDiv = $("#questionnaire-form-title");
            $("#help-title").empty();
            if(titleDiv.val().length === 0 ){
                $("#help-title").append('${message(code: "auth.message.fill.field")}!');
                return false
            }
            return true
        }

        function validateDate() {
            var endDate = $('#questionnaire-form-enddate').val() + ' ' + $('#endHour').val() + ':' + $('#endMinute').val();
            var startDate = $('#questionnaire-form-startdate').val() + ' ' + $('#startHour').val() + ':' + $('#startMinute').val();
            $("#help-start-date").empty();
            if(!moment(startDate, "DD/MM/YYYY HH:mm").isValid()){
                $("#help-start-date").append('<g:message code="help.invalid.date"/>');
                return false;
            }
            $("#help-end-date").empty();
            if(!moment(endDate, "DD/MM/YYYY HH:mm").isValid()){
                $("#help-end-date").append('<g:message code="help.invalid.date"/>');
                return false;
            }
            startDate = moment(startDate, "DD/MM/YYYY HH:mm");
            endDate = moment(endDate, "DD/MM/YYYY HH:mm");
            if(endDate.diff(startDate, 'minutes') < 0) {
                $("#help-end-date").append('<g:message code="help.invalid.date.interval"/>');
                return false;
            }

            return true
        }

        function validateForm() {
            var isValid = true;
            isValid = testTitle()? isValid:false;
            isValid = validateDate()? isValid:false;
            return isValid;

        }
        <g:if test="${questionnaire.id != null}">
        $(function() {
            $('#startHour').attr('value', '${formatDate(format:"HH", date:questionnaire.startDate)}');
            $('#startMinute').attr('value', '${formatDate(format:"mm", date:questionnaire.startDate)}');
            $('#endHour').attr('value', '${formatDate(format:"HH", date:questionnaire.endDate)}');
            $('#endMinute').attr('value', '${formatDate(format:"mm", date:questionnaire.endDate)}');
        });
        </g:if>
        <g:else>
        $(function() {
            $('#endHour').attr('value', '23');
            $('#endMinute').attr('value', '59');
        });
        </g:else>
        $(function() {
            $('#del-group').click(function() {
                addedGroups = [];
                updateGroupResult();
                getResult();
            });
        });


        function submitQuestionnaire(e) {
            e.preventDefault();
            if(validateForm()){
                $('#questionnaire-create').submit();
            }

        };

        <g:if test="${testForm == true}">
        $(function () {
            validateForm();
        })
        </g:if>
    </script>
</body>
</html>