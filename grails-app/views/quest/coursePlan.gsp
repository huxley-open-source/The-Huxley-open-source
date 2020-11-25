<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main-head"/>
    <style type="text/css">
    .ui-custom-select {
        position: relative;
        display: inline-block;
        margin-top: 5px;
    }

    .ui-custom-select select {
        display: inline-block;
        border: 1px solid #dedede;
        padding: 8px 10px;
        margin: 0;
        font: inherit;
        outline:none;
        line-height: 1.2;
        background: #f8f8f8 url('../images/select-bg.jpg') repeat-x;

        -webkit-appearance:none;

        -webkit-border-radius: 6px;
        -moz-border-radius: 6px;
        border-radius: 6px;
        cursor: pointer;
        color: #333333;
        font-family: Arial;
        font-size: 12px;
    }

    .ui-custom-select:after {
        content: "";
        position: absolute;
        top: 1px;
        right: 2px;
        padding: 0 10px;
        background: transparent url('../images/select-arrow.jpg') no-repeat;
        width: 10px;
        height: 30px;

        pointer-events:none;

        -webkit-border-radius: 0 6px 6px 0;
        -moz-border-radius: 0 6px 6px 0;
        border-radius: 0 6px 6px 0;
    }

    .button {
            display: block;
            text-align: center;
            width: 150px;
            background: none repeat scroll 0 0 #5BC3CE;
            color: white !important;
            padding: 0 8px !important;
            margin: 0 5px 0 0;
            height: 30px !important;
            line-height: 30px !important;
            cursor: pointer;
            border-radius: 5px 5px 5px 5px;
            font-size: 12px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            topcoder();
        });

        function topcoder() {
            var view, collection = new hx.models.TopCoder();
            collection.url = hx.util.url.rest('topcoders');
            view = new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')});
            view.render();
            collection.fetch({reset: true});
        }
        $(function () {

            var toAppend = '';
            $.ajax('/huxley/quest/getPlanList', {
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    $.each(data.plans, function (i, plan) {
                        var profile = '<div class="user-box">' +
                                '<div class="picture"><img src="http://img.thehuxley.com/data/images/app/profile/thumb/' + plan.owner.smallPhoto + '" alt="' + plan.owner.name + '"></div>' +
                                '<div class="info">' +
                                '<ul>' +
                                '<li class="name"><a href="/huxley/profile/show/' + plan.owner.hash + '">' + plan.owner.name + '</a></li>' +
                        '<li class="institution">' + plan.institution + '</li>' +
                                '</ul>' +
                                '</div>' +
                        '</div>';
                        toAppend += '<div class="box">' +
                                    '<h5>' + plan.title + '</h5><br>' +
                                    '<div class="right"> ' + profile + '</div>' +
                                    '<div><span>' + plan.description + '</span></div>' +
                                    '<div style="clear:both;"></div>' +
                                    '<div style="float: right;"><i class="icon icon-plus"></i><a href="/huxley/quest/showPlan?id=' + plan.id + '&groupId=${groupId}" class="course-link"><g:message code="quest.plan.visualize"/></a></div><div style="clear:both;"></div>'+
                                '</div>';
                    });
                    $('#course-list').append(toAppend);
                }
            });


        });
        function updateLinks() {
            var link
            $(".course-link").each(function(){
                link = $(this).attr('href');
                $(this).attr('href',link.substring(0,link.lastIndexOf('=') + 1) + $('#group-list').val());

            });

        }
    </script>
    <style>
    h3 {
        font-weight: bold;
        font-size: 20px;
    }
    h5 {
        font-weight: bold;
        font-size: 16px;
    }

    </style>
</head>

<body>
<div id="box-content" class="box">
    <div class="clearfix">
        <h3><g:message code="course.plan"/></h3>
        <span style="font-size: 12px;"><g:message code="course.plan.explanation"/></span>
        <g:if test="${groupList}">
            <hr><br>
            <h5><g:message code="quest.course.group"/>
            <span class="ui-custom-select" style="float:right;display:table;width:70%;margin-top:-5px;">
            <select name="inst" id="group-list" style="width:100%;" onchange="updateLinks()">
                <g:each in="${groupList}" var="group">
                    <option value="${group.id}">${group.name}</option>
                </g:each>
            </select>
                </span>
            </h5>
        </g:if>
    </div>
    <hr><br>
    <div id="course-list"></div>

</div>
</body>
</html>