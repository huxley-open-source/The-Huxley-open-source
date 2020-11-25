<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="<g:resource dir="js" file="underscore-min.js"/>" type="text/javascript"></script>
    <script src="<g:resource dir="js" file="mustache.min.js"/>" type="text/javascript"></script>

    <style>
        .linenum a {color: #909090;}

        TD.linenum {
            text-align: right;
            vertical-align: top;
            font-weight: bold;
            border-right: 1px solid black;}
        .diff-table {overflow:auto; max-height:270px; max-width: 950px; margin-top: 10px;}
        .diff-table table {
            min-width: 500px;
        }
        .diff-table tr{
            height: 19px;
        }
        TD.removed,TD.added,TD.modified { background-color: #f9ad81; padding: 0px 0px 0px 15px;white-space: pre-wrap; font-family: "Lucida Console", Monaco, monospace; font-size:14px}
        TD.normal {background-color: #FFFFE1;padding: 0px 0px 0px 15px;white-space: pre-wrap; font-family: "Lucida Console", Monaco, monospace; font-size:14px}
        TD.break-line {padding: 0px 0px 0px 15px;}
        u {
            border-bottom: 2px red solid;
            text-decoration: none;
        }
        .legend { background-color: #fff799; padding: 0px 0px 0px 15px;}
        .diff-legend-header {
            border-top-left-radius: 20px;
            border-top-right-radius: 20px;
            padding: 10px 0px 0px 15px;
        }
        .legend-box {
            position:absolute;
            top:2px;
            right: 0px;
            font-size:14px;
            border-left: 1px solid #928E8E;
            border-bottom: 1px solid #928E8E;
        }
        .title {
            font-weight: bold;
            background: white;
            margin-top: -10px;
            margin-left: 5px;
            padding: 0px 5px 0px 5px;
            color: #424242;
        }
        .subtitle {
            color: #424242;
            font-weight: bold;
            font-style: italic;
            margin: 5px 0px 0px 5px;
        }

        .tip-container {
            border: 1px #928E8E solid;
            border-radius: 5px;
        }
        .tip-container span {
            padding-left: 5px;
            display: inline-block;
        }
        .session {
            margin-top: 10px;
            border-top: 1px #928E8E solid;
            position: relative;

        }
        .session span {
            padding: 5px;
        }
        .input-example {
            white-space:pre;
            font-weight: bold;
            padding-left: 25px;
        }
    </style>
    <script type="text/javascript">
        $(function(){
            var template =
                    '{{#diff}}' +
                    '       <hr><br>'+
                    '           <h3 class="title"><g:message code="submission.show.diff"/></h3>' +
                    '           <span style="font-size:12px"><g:message code="problem.tip.diff.explain3"/></span><br>' +
                    '{{/diff}}' +
                    '{{#input}}'+
                    '<hr>'+
                    '                   <h3 class="subtitle"><g:message code="submission.input.case" /></h3>' +
                    '           <span style="font-size:12px"><g:message code="submission.input.case.explain2"/></span><br><br>' +
                    '                   <div style="padding: 5px;overflow: auto; max-height: 150px;">' +
                    '                       <div class="input-example">' +
                    '<span>{{input}}</span>' +
                    '                       </div>' +
                    '                   </div>' +
                    '{{/input}}' +
                    '{{#diff}}' +
                            '<hr>' +
                            '       <div style="position:relative">' +
                            '               <h3 class="subtitle"><g:message code = "problem.show.diff" /></h3>' +
                            '           <span style="font-size:12px"><g:message code="submission.show.diff.explain"/></span><br><br><br>' +
                            '                       {{{diff}}}' +
                            '       </div>' +
                            '       </div>' +
                            '</div>' +
                            '<hr>' +
                    '           <h3 style="font-weight: bold; font-size:12px; text-align:right;">*<g:message code="problem.tip.diff.explain2"/></h3>' +
                    '{{/diff}}';
            $.ajax('/huxley/submission/getDiff', {
                data: {id: ${submissionInstance.id}},
                dataType: 'json',
                success: function (data) {
                    $('#diff-box').append(Mustache.render(template, data.submission));
                }
            });
        });


    </script>
</head>
<body>

<huxley:profile profile="${profile}" license="${session.license}"/>
<div class="box">
    <table class="standard-table" >
        <tbody>
            <tr><td><span class="similarity-complementary-info" ><g:message code="entity.problem"/>: </span>${submissionInstance.problem}</td></tr>
            <tr><td><span class="similarity-complementary-info"><g:message code="submission.try"/>: </span> #${submissionInstance.tries}</td></tr>
            <tr><td><span class="similarity-complementary-info"><g:message code="submission.evaluation"/>: </span> ${submissionInstance.evaluation}</td></tr>
        </tbody>
    </table>
</div>

    <div id="diff-box" class="box"></div>
</body>
</html>