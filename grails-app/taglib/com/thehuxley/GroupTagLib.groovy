package com.thehuxley

import com.thehuxley.util.HuxleyProperties

class GroupTagLib {

    static namespace = "huxley"

    def groupDLC = {attrs ->
        out << """
        ${r.external dir: 'js', file: 'huxley-double-list-container.js', disposition: 'head'}
        """
        out << """<script type="text/javascript">"""
        if(attrs.addGroup){
            out << """
            \$(function() {
                \$( "#add" ).button({
                    text: false,
                    disabled:true,
                    icons: {
                        primary: "ui-icon-plusthick"
                    }
                })
                        .click(function(e) {
                    e.preventDefault();
                   \$.ajax({
                        url: '/huxley/group/save',
                        async: false,
                        data: 'name=' + \$("#input-user").val() + '&quickCreate=true',
                        beforeSend:huxley.showLoading(),
                        success: function(data) {
                            if(data.msg.status == 'ok'){
                            huxley.notify(data.msg.txt);
                            populateLeftList(\$('#input-user').val());
                            }else{
                            huxley.error(data.msg.txt);
                            }
                         huxley.hideLoading();
                        }
                    });
                });
            });"""
        }
        out << """
        \$(function() {
            huxleyDLC.initialize('user-list','selected-list');
            \$('#input-user').keyup(function() {
                clearTimeout(userSearchInputTimeOut);
                userSearchInputTimeOut = setTimeout(function() {
                    populateLeftList(\$("#input-user").val());
                }, 1000);
            });
        });
        var userSearchInputTimeOut;

        function populateLeftList(name){
            \$.ajax({
                url: huxley.root + 'group/getGroupBoxLeftList',
                async: true,
                data: 'name=' + name + '&selectedIdList=' + huxleyDLC.selectedId,
                beforeSend:huxley.showLoading(),
                dataType: 'json',
                success: function(data) {
                    huxleyDLC.populateLeftList(data.content);"""
        if(attrs.addGroup){
            out << """if((\$(".jspPane .useritem").size()==0 )&& (\$("#input-user").val().length > 0)){
                \$('#add').button( "option", "disabled", false );
            }else{
                \$('#add').button( "option", "disabled", true );
            }"""
        }
        out <<  """ huxley.hideLoading();}
            });
        }
        function addToGroupList(userId){
            \$("#action-icon-" + userId).empty();
            \$("#action-icon-" + userId).append('<a href="javascript:removeFromGroupList(' + userId + ')" class="ui-rbutton" style="float: right; padding: 6px 12px;">-</a>');
            var content = '';
            content += '<div id="s'+userId+'">'+
                    \$("#info-"+userId).html()+
                    '<form class="ui-custom-select"><select name="select" id="r' + userId + '">'+
                    '<option value="0" selected>Aluno</option>'+
                    '<option value="1">Professor</option>'+
                    '</select></form></div>';
            huxleyDLC.addToGroupList(userId,content);
        }
        function removeFromGroupList(userId){
            huxleyDLC.removeFromGroupList(userId);
        }
    </script>
                """
    out << """
<div class="box"><!-- Search box -->
    <h3>Adicionando grupos</h3>
    <g:form action="index" id="group-search-form">
        <input type="text" name="name" placeholder="Procurar grupo..." style="width: 62%;" class="ui-input2" id="input-user" autocomplete="off" />"""
        if(attrs.addGroup){
            out << """<button id="add" class="ui-button-topics-search">${g.message code:"problem.select.single"}</button>"""
        }
    out << """</g:form>
</div>
<hr /><br />
<div class="questleft">
    <h3 style="margin-bottom: 0px;">Grupos</h3>
    <div class="scroll-pane" style="height: 315px;" id = "user-list"></div>
</div>
<div class="questright">
    <h3 style="margin-bottom: 0px;">Selecionados</h3>
    <div class="scroll-pane" style="height: 315px;" id="selected-list"></div>
</div>
</div>
            """

    }

    def groupDLCLeftBox = {attrs ->


        def groupList = Cluster.executeQuery("Select c from Cluster c where name like '%" + attrs.name + "%' and c.institution.id in (" + attrs.instList + ") " + attrs.selectedIdList + " order by name")

        groupList.each{ group ->
            def width = "width: ${attrs.width}; "
            def height = "height: ${attrs.height}; "
            def maxWidth = "max-width: ${attrs.maxWidth}; "
            def maxHeight = "max-height: ${attrs.maxHeight}; "
            def style = '';

            if (attrs.width != '' || attrs.height != '' || attrs.maxWidth != '' || attrs.maxHeight != '') {
                style = 'style="';
                if (attrs.width && attrs.width != '') {
                    style += width;
                }
                if (attrs.height && attrs.height != '') {
                    style += height;
                }
                if (attrs.maxWidth && attrs.maxWidth != '') {
                    style += maxWidth;
                }
                if (attrs.maxHeight && attrs.maxHeight != '') {
                    style += maxHeight;
                }
                style += '"'
            }

            out << """
        <div class="useritem" $style id="${group.id}">
            <span id="info-${group.id}">
                <div class="userbox">
                    <div class="imagebox">
                    </div>
                    <div class="info">
                        <span id="action-icon-${group.id}"><a href=\"javascript:addToGroupList('${group.id}')\" class=\"ui-bbutton\" style=\"float: right; padding: 6px 10px;\">+</a></span>
                        ${(attrs.name != "false") ? """<span class="name">${group.name}</span>""" : ''}
                        ${(attrs.institution != "false") ? """<span class="institution">${group.institution.name}</span>""" : ''}
                    </div>
                    <span class="icon"></span>
                </div>
            </span>
        </div>
    """


        }
    }

}
