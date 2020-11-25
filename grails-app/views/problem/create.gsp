<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta name="layout" content="main" />
<link rel="stylesheet" href="${resource(dir:'js/fileuploader', file:'jquery.fileupload-ui.css')}" />
<script src="application.js"></script>

<script type="text/javascript">
    var selectedId;
    function formSubmit() {
        $('#topic-list-id').attr('value', huxleyTopic.selectedId);
        $('#problem-form').submit();
    }

    $(function() {
        $('#difficulty-level').append(${problemInstance?.level});
        $( "#slider-range1" ).slider({
            min: 1,
            max: 10,
            value: ${problemInstance?.level},
            change: function() {
                $('#problem-level').val($( "#slider-range1" ).slider( "values", 0 ));
            },
            slide: function(event, ui) {
                $('#difficulty-level').empty();
                $('#difficulty-level').append(ui.value);
                $('#difficult-level-value').attr('value', ui.value);
            }

        });
    });
    $(function() {
        $('#time-limit').append(${problemInstance?.timeLimit} + "s");
        $( "#slider-range2" ).slider({
            min: 1,
            max: 10,
            value: ${problemInstance?.timeLimit},
            change: function() {
                $('#time-limit').val($( "#slider-range2" ).slider( "values", 0 ));
            },
            slide: function(event, ui) {
                $('#time-limit').empty();
                $('#time-limit').append(ui.value + "s");
                $('#time-limit-value').attr('value', ui.value);
            }

        });
    });

</script>
</head>

<body>
    <g:if test="${problemInstance.id}">
    <div class="container">
        <div class="center">
            <ul class="menu-btn menu-btn-hor">
                <li class="menu-btn-active"><g:link controller="problem" action="create" id="${problemInstance.id}"><g:message code="problem.create.basic_info"/></g:link></li>
                <li><g:link controller="problem" action="create2" id="${problemInstance.id}"><g:message code="problem.create.description"/></g:link></li>
                <li><g:link controller="problem" action="create3" id="${problemInstance.id}"><g:message code="problem.create.testcases"/></g:link></li>
            </ul>
        </div>
    </div>
    </g:if>
    <g:form action="save" id="${problemInstance?.id}">
    <div class="form-box">
        <h3><g:message code="problem.create.title"/></h3>
        <div style="float: right;">
            <input name="saveform" id="save-form" type="submit" value="${g.message(code:'verbosity.save')}" class="button" style="border: none;">
            <input type="submit" value="${g.message(code:'problem.next.step')}" class="button" style="border: none;">
        </div>
        <div style="clear: left;"></div>
    </div>

    <hr class="form-line">

    <div class="form-box">
        <div class="form-element">
            <label class="form-element-label">
                <strong class="problem-form-slide"><g:message code="verbosity.problem.name" /></strong>
                <input class="form-element-input" name="name" type="text" value="${problemInstance?.name}" />
            </label>
        </div>
        <div class="form-element">
            <label class="form-element-label">
                <strong class="problem-form-slide"><g:message code="verbosity.source" /></strong>
                <input class="form-element-input" name="source" type="text" value="${problemInstance?.source}" />
            </label>
        </div>

        <div class="form-element">
            <label class="form-element-label">
                <strong class="problem-form-slide-label"><g:message code="problem.initial.dinamic.level"/>: <span id="difficulty-level"></span></strong>
                <div id="slider-range1"></div>
            </label>
        </div>

        <div class="form-element">
            <label class="form-element-label">
                <strong class="problem-form-slide-label"><g:message code="problem.time.limit"/>: <span id="time-limit"></span></strong>
                <div id="slider-range2"></div>
            </label>
        </div>

        <g:hiddenField name="timeLimit" id="time-limit-value" value="${problemInstance?.timeLimit }" />
        <g:hiddenField name="difficultLevel" id="difficult-level-value" value="${problemInstance?.level }" />
        <g:hiddenField name="topicList" id="topic-list-id" value="${problemInstance?.topics }" />

        </g:form>

        <div class="form-element">
            <label class="form-element-label">
                <strong class="problem-form-slide-label"><g:message code="entity.topics"/></strong>
            </label>
            <huxley:topicFilter/>
            <g:select from="${problemInstance?.topics }" optionKey="id" id="temp-topic" name="temp-topic" style="display:none;"></g:select>
        </div>
    </div>
</body>
</html>
