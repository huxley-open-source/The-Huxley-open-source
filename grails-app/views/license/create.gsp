<%@ page import="com.thehuxley.Institution; com.thehuxley.util.HuxleyProperties" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'huxley-double-list-container.js')}"></script>
    <script type="text/javascript">
        function submit(){
            $("#save").submit();
        }
        $(function() {
            huxleyDLC.initialize('user-list','selected-list');
            $('#input-user').keyup(function() {
                clearTimeout(userSearchInputTimeOut);
                userSearchInputTimeOut = setTimeout(function() {
                    populateLeftList($("#input-user").val());
                }, 1000);
            });
            populateRightList();


        });
        var userSearchInputTimeOut;

        function populateLeftList(name){
            $.ajax({
                url: huxley.root + 'group/getUserBoxLeftList',
                async: true,
                type: 'POST',
                beforeSend:huxley.showLoading(),
                data: 'name=' + name + '&selectedIdList=' + huxleyDLC.selectedId,
                dataType: 'json',
                success: function(data) {
                    huxleyDLC.populateLeftList(data.content);
                    huxley.hideLoading();
                }
            });
        }

        function populateRightList(){
            var data = 'kind=' + $("#evaluation-list").val();
            <g:if test="${session.license.isAdmin()}">
            data += '&institutionId=' + $("#institution").val();
            </g:if>
            $.ajax({
                url: huxley.root + 'license/getUserBoxRightList',
                data: data,
                beforeSend:huxley.showLoading(),
                async: true,
                dataType: 'json',
                success: function(data) {
                    huxleyDLC.rightList.getContentPane().empty();
                    huxleyDLC.selectedId = [];
                    huxleyDLC.populateRightInstList(data.content, data.selectedIdList);
                    update();
                    huxley.hideLoading();
                }
            });
        }

        function addToGroupList(userId){
            $("#action-icon-" + userId).empty();
            $("#action-icon-" + userId).append('<a href="javascript:removeFromGroupList(' + userId + ')" class="ui-rbutton" style="float: right; padding: 6px 12px;">-</a>');
            var content = '';
            content += '<div id="s'+userId+'">'+
                    $("#info-"+userId).html()+
                    '</div>';
            huxleyDLC.addToGroupList(userId,content);
            update();
        }
        function removeFromGroupList(userId){
            huxleyDLC.removeFromGroupList(userId);
            update();
        }
        function update(){
            var mL = [];
            $.each(huxleyDLC.selectedId, function(i, idSelected) {
                mL.push(idSelected);
            });
            $("#sList").val(mL);
        }


    </script>
</head>
<body>
<div class="box">
    <h3><g:message code="license.manage"/> <a href="javascript:submit();" class="ui-gbutton"><g:message code="institution.save"/></a></h3>
    <input type="text" name="name" placeholder="Procurar usuário..." autocomplete="off" style="width: 62%;" class="ui-input2" id="input-user"  />
    <g:form action="save" name="save">
        <g:hiddenField name="sList" value="" id="sList"/>
        <br>
        <h3><g:message code="verbosity.kind"/>
            <span class="ui-custom-select" style="float:right;display:table;width:73%;margin-top:-5px;">
                <select name="kind" id="evaluation-list" style="width:100%;" onchange="populateRightList();" >
                    <option value="STUDENT"><g:message code="license.kind.standard.student"/></option>
                    <option value="TEACHER"><g:message code="license.kind.standard.master"/></option>
                    <option value="ADMININST"><g:message code="license.kind.standard.admin.inst"/></option>
                </select>
            </span>
        </h3>
        <g:if test="${session.license.isAdmin()}">
            <h3>Instituição <g:select name="institutionId" id="institution" from="${Institution.list()}" onchange="populateRightList();" optionKey="id" optionValue="name"></g:select></h3>
        </g:if>
    </g:form>
</div>
<hr /><br />
<hr />
<div class="questleft">
    <h3 style="margin-bottom: 0px;">Usuários</h3>
    <div class="scroll-pane" style="height: 315px;" id = "user-list"></div>
</div>
<div class="questright">
    <h3 style="margin-bottom: 0px;">Integrantes</h3>
    <div class="scroll-pane" style="height: 315px;" id="selected-list"></div>
</div>
</div>
</div>
<div class="clear"></div><br />

</body>
</html>