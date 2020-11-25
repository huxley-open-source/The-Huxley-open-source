<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main" />
    <script type="text/javascript">
        var cont = 0;
        var testCaseRemovedList = new Array();
        $(function() {
            $('#testcase-add-new').click(function() {
                createTestCase(cont);
                cont++;
            });

            $('#submit-form').click(function() {
                createData();
                $('#testcase-form').submit();

            });
        });

        function createData() {
            var testcaseids, newTestCases, data = ""

            testcaseids = $.parseJSON($('#testcase-ids').val());

            data = {
                problem: ${problemInstance.id},
                update: [],
                create: []
            };


            $.each(testcaseids, function(i, testcase) {
                if(($(testcase).find('.test-case-input').val() != "") && ($(testcase).find('.test-case-output').val() != "") ) {
                    if (document.getElementById('saved-' + testcase) !== null) {
                        data.update.push({id: testcase, input: $('#testcase-input-' + testcase).val(), output: $('#testcase-output-' + testcase).val(), tip: $('#testcase-tip-' + testcase).val(), example: $('#testcase-example-' + testcase).is(':checked')});
                    }
                }
            });

            $.each($('.test-case-new'), function(i, testcase) {
                if(($(testcase).find('.test-case-input').val() != "") && ($(testcase).find('.test-case-output').val() != "") ) {
                    data.create.push({input: $(testcase).find('.test-case-input').val(), output: $(testcase).find('.test-case-output').val(), tip: $(testcase).find('.test-case-tip').val(), example: $(testcase).find('.test-case-example').is(':checked')});
                }
            });

            $('#testCases').val(JSON.stringify(data));
        };

        function createTestCase(cont) {

            $('#testcase-news').prepend('<div id="form-' + cont + '" class="form-box test-case-new">' +
                    '   <h3><g:message code="verbosity.newTestCase"/></h3>' +
                    '   <label style="float: right;">' +
                    '   <a href="javascript:void(0)" onclick="removeTestCase(' + cont + ');"><img src="/huxley/images/lixeira.png" style="width:17px; height:19px; border:0;margin-left: 10px;"/></a> '+
                    '       <input class="test-case-example" type="checkbox">' +
                    '       <g:message code="verbosity.useAsAnExample"/>' +
                    '   </label>' +
                    '   <br>' +
                    '   <hr>' +
                    '   <div class="form-element">' +
                    '       <label>' +
                    '           <br/><strong><g:message code="testCase.input" /></strong>' +
                    '           <textarea class="test-case-input" cols="" rows=""></textarea>' +
                    '       </label>' +
                    '   </div>' +
                    '   <div class="form-element">' +
                    '       <label>' +
                    '           <strong><g:message code="testCase.output" /></strong>' +
                    '           <textarea class="test-case-output" cols="" rows=""></textarea>' +
                    '       </label>' +
                    '   </div>' +
                    '   <div class="form-element">' +
                    '       <label>' +
                    '           <strong>*<g:message code="testCase.tip" /></strong>' +
                    '           <textarea class="test-case-tip" cols="" rows=""></textarea>' +
                    '       </label>' +
                    '   </div>' +
                    '</div>' +
                    '<hr id="form-line-'+ cont +'" class="form-line">');
        }

        function removeTestCase (cont){
            $('#form-' + cont).remove();
            $('#form-line-' + cont).remove();
        }

        function revomeSavedTestCase(id) {
            testCaseRemovedList.push(id);
            $('#saved-' + id).remove();
            $('#form-line-saved-' + id).remove();
        }
    </script>
</head>

<body>
<g:if test="${problemInstance.id}">
    <div class="container">
        <div class="center">
            <ul class="menu-btn menu-btn-hor">
                <li><g:link controller="problem" action="create" id="${problemInstance.id}"><g:message code="problem.create.basic_info"/></g:link></li>
                <li><g:link controller="problem" action="create2" id="${problemInstance.id}"><g:message code="problem.create.description"/></g:link></li>
                <li  class="menu-btn-active"><g:link controller="problem" action="create3" id="${problemInstance.id}"><g:message code="problem.create.testcases"/></g:link></li>
            </ul>
        </div>
    </div>
</g:if>
<div class="form-box">
    <h3>${problemInstance?.name}</h3>
    <div style="float: right;">
        <g:link action="create2" id="${problemInstance.id}" class="button" ><g:message code="problem.prev.step"/></g:link>
        <input id="submit-form" type="submit" value="${g.message(code:'verbosity.save')}" class="button" style="border: none;">
    </div>
    <div style="clear: left;"></div>
</div>

<hr class="form-line">

<div class="form-box">
    <a class="button" style="background-color: #05C629" href="javascript:void(0);" id="testcase-add-new"><g:message code="verbosity.addNewTestCase" /></a>
    <div style="clear: left;"></div>
</div>

<div id="testcase-news"></div>

<hr class="form-line">

<g:if test="${!testCases.isEmpty()}">
    <div class="form-box">
        <h3><g:message code="verbosity.oldTestCase" /></h3>
    </div>
</g:if>


<g:each var="testCase" in="${testCases}" status="i">

    <div id="saved-${testCase.id}" class="form-box">
        <h3><g:message code="testCase.entity"/> #${i + 1}</h3><label style="float: right;">
        <a href="javascript:void(0)" id="${testCase.id}" onclick="revomeSavedTestCase('${testCase.id}');"> <img src="/huxley/images/lixeira.png" style="width:17px; height:19px; border:0;margin-left: 10px;"/></a>
        <g:checkBox name="testcase-example-${testCase.id}" id="testcase-example-${testCase.id}" checked="${testCase.type == com.thehuxley.TestCase.TYPE_EXAMPLE}"/> <g:message code="verbosity.useAsAnExample"/></label><br/>
        <hr>
        <div class="form-element">
            <label>
                <br/><strong><g:message code="testCase.input" /></strong>
                <g:textArea class="test-case-input" name="testcase-input-${testCase.id}" rows="" cols="">${testCase.input}</g:textArea>
            </label>
        </div>
        <div class="form-element">
            <label>
                <strong><g:message code="testCase.output" /></strong>
                <g:textArea  class="test-case-output" name="testcase-output-${testCase.id}" rows="" cols="">${testCase.output}</g:textArea>

            </label>
        </div>
        <div class="form-element">
            <label>
                <strong>*<g:message code="testCase.tip" /> (<g:message code="message.optional" />)</strong>
                <g:textArea  class="test-case-tip" name="testcase-tip-${testCase.id}" rows="" cols="">${testCase.tip}</g:textArea>

            </label>
        </div>
    </div>

    <hr id="form-line-saved-${testCase.id}" class="form-line">
</g:each>

<g:form id="${problemInstance.id}" action="updateTestCase" name="testcase-form" >
    <g:hiddenField name="testCases" value="" />
    <g:hiddenField id="testcase-ids" name="testCasesIds" value="${testCasesIds}" />
</g:form>
</body>
</html>