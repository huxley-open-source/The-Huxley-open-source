<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <script src="${resource(dir:'js', file:'huxley-group.js')}"></script>
    <script src="${resource(dir:'js', file:'huxley-double-list-container.js')}"></script>
    <script type="text/javascript">
        $(function() {
            huxleyDLC.initialize('user-list','selected-list');
            $('#input-user').keyup(function() {
                clearTimeout(userSearchInputTimeOut);
                userSearchInputTimeOut = setTimeout(function() {
                    populateLeftList($("#input-user").val());
                }, 1000);
            });
            populateRightList();
            populateLeftList($("#input-user").val());
        });
        var userSearchInputTimeOut;

        function populateLeftList(name){
            $.ajax({
                url: huxley.root + 'group/getUserBoxLeftList',
                async: true,
                data: 'name=' + name + '&selectedIdList=' + huxleyDLC.selectedId,
                type: 'POST',
                beforeSend:huxley.showLoading(),
                dataType: 'json',
                success: function(data) {
                    huxleyDLC.populateLeftList(data.content);
                    huxley.hideLoading();
                }
            });
        }
        function populateRightList(){
            $.ajax({
                url: huxley.root + 'group/getUserBoxRightList',
                data: 'id=' + ${clusterInstance.id},
                async: true,
                beforeSend:huxley.showLoading(),
                dataType: 'json',
                success: function(data) {
                    huxleyDLC.populateRightList(data.content, data.selectedIdList, data.roleList);
                    huxley.hideLoading();
                    $("#save-user-list").show();
                }
            });
        }
        function addToGroupList(userId){
            $("#action-icon-" + userId).empty();
            $("#action-icon-" + userId).append('<a href="javascript:removeFromGroupList(' + userId + ')" class="ui-rbutton" style="float: right; padding: 6px 12px;">-</a>');
            var content = '';
            content += '<div id="s'+userId+'">'+
                    $("#info-"+userId).html()+
                    '<form class="ui-custom-select"><select name="select" id="r' + userId + '">'+
                    '<option value="0" selected>Aluno</option>'+
                    '<option value="1">Professor</option>'+
                    '</select></form></div>';
            huxleyDLC.addToGroupList(userId,content);
        }
        function removeFromGroupList(userId){
            huxleyDLC.removeFromGroupList(userId);
        }
        function save(){
            var mL = [];
            var sL = [];
            var groupId = ${clusterInstance.id};
            $.each(huxleyDLC.selectedId, function(i, idSelected) {
                if($('#r' + idSelected + ' option:selected').val() == "0"){
                    sL.push(idSelected);
                }else{
                    mL.push(idSelected);
                }
            });
            $("#tList").val(mL);
            $("#sList").val(sL);
            $("#save-form").submit();
        }


</script>
</head>
<body>
<div class="box"><!-- Search box -->
    <h3>Adicionando integrantes
        <g:form action="saveUsers" name="save-form">
            <a href="javascript:save()" class="ui-gbutton" id="save-user-list" style="display:none;">Salvar</a>
            <g:hiddenField name="tList" value="" id="tList"/>
            <g:hiddenField name="sList" value="" id="sList"/>
            <g:hiddenField name="id" value="${clusterInstance.id}" />
        </g:form>
    </h3>
        <g:form action="index">
            <input type="text" name="name" placeholder="<g:message code='group.search.user'/>" style="width: 62%;" class="ui-input2" id="input-user"  />
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