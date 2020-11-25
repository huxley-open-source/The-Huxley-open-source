<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script type="text/javascript">
        var limit = 5;
        var name="";
        $(function() {

            huxley.generatePagination('license-pagination',getLicense,limit,${total});

            $('#input-license').keyup(function() {
                clearTimeout(licenseSearchInputTimeOut);
                licenseSearchInputTimeOut = setTimeout(function() {
                    name = $("#input-license").val();
                    getLicense(0);
                }, 1000);
            });
        });
        var licenseSearchInputTimeOut;

        function getLicense(index){
            var offset = index * limit;
            $.ajax({
                url: huxley.root + 'license/search  ',
                async: true,
                data: 'offset=' + offset + '&max='+limit + '&name=' + name + '&t=${t}',
                beforeSend: huxley.showLoading(),
                dataType: 'json',
                success: function(data) {
                    var toAppend = '';
                    $('#license-list').empty();
                    $.each(data.licenses, function(i, license) {
                        toAppend += '<tr id="' + license.hash + '"><td>' + license.content + '</td><td><a href="javascript:void(0)" onclick="removeLicense(\'' + license.hash +'\')"><img src="/huxley/images/icons/error.png" style="width:16px; height:19px; border:0;" /></a></td></tr>';
                    });
                    if(offset == 0){
                        huxley.generatePagination('license-pagination',getLicense,limit,data.total);
                    }
                    $('#license-list').append(toAppend);
                    huxley.hideLoading();

                }
            });
        };
        function removeLicense(hash){
            $.ajax({
                url: huxley.root + 'license/remove',
                async: true,
                data: 'hash=' + hash,
                beforeSend: huxley.showLoading(),
                dataType: 'json',
                success: function(data) {
                    if(data.msg.status=="ok"){
                        $("#" + hash).empty();
                        huxley.notify(data.msg.txt);
                    }else{
                        huxley.error(data.msg.txt);
                    }
                    huxley.hideLoading();

                }
            });
        };


    </script>
</head>
<body>
<div class="box"><!-- Search box -->
    <h3><g:message code="license.search"/><g:link action="create" class="ui-gbutton"><g:message code="license.manage"/></g:link></h3>
    <g:form action="index">
        <input type="text" name="name" placeholder="${message(code: 'verbosity.search.user')}" style="width: 62%;" class="ui-input2" id="input-license"  />
    </g:form>
</div>
<hr /><br />
    <table class="standard-table">
        <tbody id="license-list">
        <g:each status="i" in="${licenseList}" var="license">
            <tr id="${license.hash}">
                <td><huxley:userBox user="${license.user}" position="false" score="false" email="true"/></td>
                <td><a href="javascript:void(0)" onclick="removeLicense('${license.hash}')"><img src="/huxley/images/icons/error.png" style="width:16px; height:19px; border:0;" /></a></td>
            </tr>
        </g:each>
        </tbody>
    </table>
    <span id="license-pagination" class="ui-pagination"></span>
</body>
</html>