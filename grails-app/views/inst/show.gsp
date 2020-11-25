<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>

    <script type="text/javascript">

        $(function() {
            changeContext('profile');

        });
         function changeContext(id){
            $("#tabs  span").removeClass("active");
            $(".standard-table").hide();
            $("#" + id).addClass("active");
            $("#" + id + "-tab").show();
        };



    </script>
</head>
<body>
<huxley:institutionProfile institution="${institutionInstance}"></huxley:institutionProfile>
<div class="profile-tabs">
    <div class="title">Informações complementares</div>
    <div class="tabs" id="tabs">
        <span id="profile" onclick="changeContext('profile')" class="active"><g:message code="institution.general"/></span>
        <span id="admin" onclick="changeContext('admin')"><g:message code="institution.admin.institutional"/></span>
        <span id="teacher" onclick="changeContext('teacher')"><g:message code= "institution.teacher.list"/></span>

    </div>
    <table class="standard-table" id="profile-tab">
        <tbody>
        <tr><td><span class="profile-complementary-info" ><g:message code="institution.name"/>: </span>${institutionInstance.name}</td><td><span class="profile-complementary-info"><g:message code="institution.phone"/>: </span> ${institutionInstance.phone}</td></tr>
        </tbody>
    </table>
    <table class="standard-table" id="admin-tab" style="display:none">
        <thead>
        <th class="profile-complementary-info" style="padding: 10px; text-align: center;"><g:message code="profile.name"/></th>
        </thead>
        <tbody>
        <g:each in="${institutionInstance.users}" var="user">
            <tr><td style="text-align: center;">${user.name}</td></tr>
        </g:each>

        </tbody>
    </table>
    <table class="standard-table" id="teacher-tab" style="display:none">
        <thead>
        <th class="profile-complementary-info" style="padding: 10px; text-align: center;"><g:message code="profile.name"/></th>
        </thead>
        <tbody>
        <g:each in="${teacherList}" var="user">
            <tr><td style="text-align: center;">${user.name}</td></tr>
        </g:each>

        </tbody>
    </table>
</div>
</body>
</html>