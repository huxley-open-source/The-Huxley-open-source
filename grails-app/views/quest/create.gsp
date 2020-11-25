<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta name="layout" content="main" />
<style type="text/css">
form .error {
    font-size: .9em;
    color: #ae3232;
}
.help-inline {
    display: inline-block;
    padding-left: 5px;
    vertical-align: middle;
}</style>
<script src="${resource(dir:'js', file:'moment.min.js')}"></script>
<script type="text/javascript">
    $(function() {
        $( "#questionnaire-form-startdate" ).datepicker({dateFormat: 'dd/mm/yy'});
        $( "#questionnaire-form-enddate" ).datepicker({dateFormat: 'dd/mm/yy'});
    });

    var groups = [];
    var addedGroups = [];
    var permissions = [];

    var createUserSearchInputTimeOut;
    $(function() {
        $('#create-user-group-search-input').keyup(function() {
            clearTimeout(createUserSearchInputTimeOut);
            createUserSearchInputTimeOut = setTimeout(function() {
                getResult();
            }, 1000);
        });
    });

    $(function() {
        $('#show-group-dialog').click(function() {
            huxley.openModal('dialog-add-group');
            $("#create-user-group-search-input").val('');
            getResult();
        });
    });

    var CreateUser = {
        TEMPLATE: {
            listGroups: function(id, name, cssClass, image) {
                return '<tr class="' + cssClass + '"><td style="padding-left: 8px;">' + name + '</td><td style="width: 16px; vertical-align:middle; height:16px; display:table-cell; padding-right: 8px;"><a id="create-user-group-' + id + '" href="#" onclick="toggleGroup(' + id + ')" style="display: block; width: 16px; height: 16px"><img src="${resource(dir: "/images")}/' + image + '" /></a></td></tr>';
            },
            mainListGroups: function(id, name, cssClass, image, selected) {
                return '<tr class="' + cssClass + '"><td style="padding-left: 8px;">' + name + '</td><td style="width: 30px; padding-right: 20px;">' +
                        '</td><td style="width: 16px; vertical-align:middle; height:32px; display:table-cell; padding-right: 8px;"><a id="main-create-user-group-' + id +
                        '" href="javascript:void(0);" onclick="toggleGroup(' + id + ')" style="display: block; width: 25px; height: 25px"><img src="${resource(dir: "/images")}/' + image + '" /></a></td></tr>';
            }
        }
    };

    $(function() {
        getResult();
    });



    function getResult() {
        $.ajax({
            url: '${resource(dir:"/")}group/ajxGetCurrentGroupListTeacher',
            data: 'q=' + $("#create-user-group-search-input").val(),
            dataType: 'json',
            timeout: 10000,
            async: false,
            error: function(){

            },
            success: function(data) {
                var table, div, fragment;

                fragment = document.createDocumentFragment();
                div = $('#result');
                $(div).empty();
                table =  document.createElement('table');
                table.className = "show-list";

                $.each(data.groups, function(i, group) {
                    var cssClass = (i % 2 == 0) ? 'even':'odd';
                    if ($.inArray(group.id, addedGroups) >= 0) {
                        $(table).append(CreateUser.TEMPLATE.listGroups(group.id, group.name, cssClass, 'remove.png'));
                    } else {
                        $(table).append(CreateUser.TEMPLATE.listGroups(group.id, group.name, cssClass, 'add.png'));
                    }
                    groups[group.id] = group.name;
                });

                fragment.appendChild(table);
                div.append($(fragment));
            }
        });

    }
    <g:if test="${questionnaire.id != null}">
    $(function() {
        $.ajax({
            url: '${resource(dir:"/")}group/ajxGetGroupsByQuestionnaire',
            data: 'qid=' + ${questionnaire.id},
            dataType: 'json',
            timeout: 5000,
            success: function(data) {
                $.each(data.groups, function(i, group) {
                    groups[group.id] = group.name;
                    toggleGroup(group.id);
                });
            }
        });

        updateGroupResult();
    });
    </g:if>
    function toggleGroup(id) {

        var image = $('#create-user-group-' + id).children(0);

        if ($.inArray(id, addedGroups) >= 0) {
            addedGroups = removeItem(id, addedGroups);
            image.attr('src', '${resource(dir: "/images")}/add.png');
        } else {
            addedGroups.push(id);
            image.attr('src', '${resource(dir: "/images")}/remove.png');
        }

        updateGroupResult();

    };

    function updateGroupResult() {
        var table, div, fragment, selected;

        fragment = document.createDocumentFragment();
        div = $('#group-result');
        $(div).empty();
        table =  document.createElement('table');
        table.className = "show-list";



        $.each(addedGroups, function(i, id) {
            var cssClass = (i % 2 == 0) ? 'even':'odd';

            if ($.inArray(id, addedGroups) >= 0) {
                $(table).append(CreateUser.TEMPLATE.mainListGroups(id, groups[id], cssClass, 'lixeira.png', selected));
            }
        });

        fragment.appendChild(table);
        div.append($(fragment));

    }

    function removeItem(removeItem, array) {
        return $.grep(array, function(value) {
            return value != removeItem;
        });
    }

    function deleteGroups() {
        addedGroups = [];
        updateGroupResult();
        getResult();
    }

    function includeGroups() {
        var json = '';
        $("#help-group").empty();
        if($(addedGroups).length !== 0 ){
            json = '{"groups": [';
            $.each($(addedGroups), function(i, group) {
                json += '{"id": ' + group  + '}, ';
            });
            json = json.substring(0, json.lastIndexOf(','));
            json += ']}';
            $('#questionnaire-create-groups').val(json);
            return true;
        }
        $("#help-group").append('<g:message code="help.group.empty"/>');
        return false;


    }

    function changePermission(id, obj) {
        permissions[id] = obj.value;
        updateGroupResult();
    }

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
        isValid = includeGroups()? isValid:false;
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


    function submitQuestionnaire() {
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
</head>
<body>

<g:if test="${questionnaire.id == null}">
    <div class="form-box">
        <h3>Inserindo um novo questionário</h3>
        <input type="button" value="${g.message(code:'problem.next.step')}" class="button" style="border: none; float: right;" onclick="submitQuestionnaire();">
        <div style="clear: left;"></div>
    </div>
</g:if>
<g:else>
    <div class="form-box">
        <h3>${questionnaire.title}</h3>
        <input type="submit" value="${g.message(code:'problem.next.step')}" class="button" style="border: none; float: right;" onclick="submitQuestionnaire();">
        <div style="clear: left;"></div>
    </div>
</g:else>
<hr>
<br>
<g:form name="questionnaire-create" action="save" onsubmit="return validateForm();">
    <g:if test="${questionnaire.id}">
        <g:hiddenField name="id" value="${questionnaire.id}"/>
    </g:if>
    <div class="controller-menu">
        <span id="questionnaire-error-message" class="message">
            ${flash.message}
        </span>
    </div>
        <div class="boxtitle">
            <h4>Título do questionário</h4>
        </div>
        <div class="box">
            <input  name="title" id="questionnaire-form-title"  style="background: #fff; border: #ccc 1px solid; width: 497px;" type="text" value="${questionnaire?.title}" class="ui-input2" style="width: 660px;" placeholder="Digite o título do questionário...">
            <span class="error help-inline" id="help-title"></span>
            <br/>
            <hr/>
            <input id="questionnaire-form-startdate" class="ui-ybutton" style="width: 80px; background: #fff; border: #ccc 1px solid;  color: #888 !important;" name="startDateString" placeholder="Início" value="${formatDate(format:"dd/MM/yyyy", date:questionnaire.startDate)}" type="text"  /> às <g:select id="startHour" name="startHour"  from="${['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23']}" /> : <g:select id="startMinute" name="startMinute" from="${['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59']}"/>
            <span class="error help-inline" id="help-start-date"></span>
            <br/>
            <br/>
            <input id="questionnaire-form-enddate" class="ui-ybutton" style="width: 80px; background: #fff; border: #ccc 1px solid; color: #888 !important;" name="endDateString" placeholder="Fim" value="${formatDate(format:"dd/MM/yyyy", date:questionnaire.endDate)}" type="text" />  às <g:select id="endHour" name="endHour" from="${['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23']}" /> : <g:select id="endMinute" name="endMinute"  from="${['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59']}"/>
            <span class="error help-inline" id="help-end-date"></span>
        </div>
        <hr />
        <div class="boxtitle">
            <h4>Descrição do questionário</h4>
        </div>
        <div class="box">
            <textarea name="description" id="questionnaire-form-description" class="ui-input2"  style="background: #fff; border: #ccc 1px solid;" rows="6" cols="69" style="width: 660px; max-width: 660px;">${questionnaire?.description}</textarea>
        </div>


    <hr />
        <div class="boxtitle">
            <h4 style="font-weight: bold; font-size: 14px;"><g:message code="profile.groups" /></h4>
            <a class="ui-bbutton" style="float: right; margin-left: 5px;" id="show-group-dialog" href= "Javascript:void(0);"> Incluir Grupo</a>
            <a class="ui-bbutton" style="float: right;" id="del-group" href= "Javascript:void(0);"> Excluir Todas</a>
            <div style="overflow: hidden; clear: left;"></div>
        </div>
        <span class="error help-inline" id="help-group"></span>
        <div class="box">
            <div id="group-result" style="margin-top: 20px;"></div>
        </div>
        <g:hiddenField name="groups" id="questionnaire-create-groups" />

</g:form>

<div id="dialog-add-group" class="modal" >
    <div style="width: 500px; margin-bottom: 7px;">
        <span>
            <input id="create-user-group-search-input" type="text" placeholder="${g.message(code:'profile.group')}" style="width: 477px;"/>
            <span id="loading" style="line-height: 20px; padding-left: 3px; vertical-align: middle; display: none;">
                <img src="${resource(dir:'images', file:'spinner.gif')}" />
            </span>
        </span>
    </div>

    <div id="result" style="margin: 10px 0 10px 0"></div>
    <div style="float: right;">
        <button class="button" style="border: none; background-color: #1BD482;" onclick="huxley.closeModal();"><g:message code="verbosity.close" /></button>
    </div>
</div>

</body>
</html>
