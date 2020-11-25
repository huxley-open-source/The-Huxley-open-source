var huxleyDLC = huxleyDLC || {};

huxleyDLC.leftList = '';
huxleyDLC.rightList = '';
huxleyDLC.selectedId = []
huxleyDLC.leftId = '';
huxleyDLC.rightId = '';



huxleyDLC.initialize = function(leftList,rightList){
    huxleyDLC.leftList = $('#' + leftList).jScrollPane().data('jsp');
    huxleyDLC.rightList = $('#' + rightList).jScrollPane().data('jsp');
    huxleyDLC.leftId = leftList;
    huxleyDLC.rightId = rightList;

};

huxleyDLC.populateLeftList = function(content){

    huxleyDLC.leftList.getContentPane().empty();
    huxleyDLC.leftList.getContentPane().append(content);
    huxleyDLC.leftList = $('#' + huxleyDLC.leftId).jScrollPane().data('jsp');
};

huxleyDLC.populateRightList = function(content,selectedIdList, roleList){
    huxleyDLC.rightList.getContentPane().append(content);
    huxleyDLC.rightList = $('#' + huxleyDLC.rightId).jScrollPane().data('jsp');
    $.each(selectedIdList, function(i, idSelected) {
        huxleyDLC.selectedId.push(idSelected + "");
        if(roleList[i] == 0 ){
            $("#r" + idSelected).val(0);
        }else{
            $("#r" + idSelected).val(1);
        }

    });
    huxleyDLC.populateLeftList();
};

huxleyDLC.populateRightInstList = function(content,selectedIdList, roleList){
    huxleyDLC.rightList.getContentPane().append(content);
    huxleyDLC.rightList = $('#' + huxleyDLC.rightId).jScrollPane().data('jsp');
    $.each(selectedIdList, function(i, idSelected) {
        huxleyDLC.selectedId.push(idSelected + "");

    });
    huxleyDLC.populateLeftList();
};


huxleyDLC.addToGroupList = function(userId,content){
    $("#" + userId).fadeOut("slow");
    huxleyDLC.selectedId.push(userId);
    huxleyDLC.rightList.getContentPane().append(content);
    huxleyDLC.rightList = $('#' + huxleyDLC.rightId).jScrollPane().data('jsp');
};

huxleyDLC.removeFromGroupList = function(userId){
    $("#s" + userId).fadeOut("slow");
    huxleyDLC.selectedId.splice(huxleyDLC.selectedId.indexOf(userId),1);
};