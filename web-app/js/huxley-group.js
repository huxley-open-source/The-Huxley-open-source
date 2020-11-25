var huxleyGroup = huxleyGroup || {};

huxleyGroup.limit = 0;
huxleyGroup.problemName = '';
huxleyGroup.name = '';

huxleyGroup.changeFunction = function(){};
huxleyGroup.setChangeFunction = function(newFunction,initArg){
    huxleyGroup.initArg = initArg;
    huxleyGroup.changeFunction = newFunction;
};

huxleyGroup.setValues = function(limit){
    huxleyGroup.limit = limit;
};

huxleyGroup.setName = function(value){
    huxleyGroup.name = value;
    huxleyGroup.changeFunction(huxleyGroup.initArg);
};

huxleyGroup.getGroup = function(index){
    var offset = index * huxleyGroup.limit;
    console.log('offset=' + offset + '&max='+huxleyGroup.limit + '&name=' + huxleyGroup.name);
    $.ajax({
        url: huxley.root + 'group/search',
        async: true,
        data: 'offset=' + offset + '&max='+huxleyGroup.limit + '&name=' + huxleyGroup.name,
        dataType: 'json',
        success: function(data) {
            console.log(data.groups);
            var toAppend = '';
            $('#group-list').empty();
            $.each(data.groups, function(i, group) {
                toAppend+='<tr><td style="text-align: left;width: 85%;"><a href="' + huxley.root + 'group/show/' + group.hash + '" class="grouplink">' + group.name + '</a></td>'+
                    '<td style="text-align: left;width: 15%;">'+
                    '<a href="' + huxley.root + 'group/create/' + group.hash + '"><img src="/huxley/images/icons/edit.png" style="width:16px; height:19px; border:0;" /></a>'+
                    '<a href="' + huxley.root + 'group/manage/' + group.hash + '" ><img src="/huxley/images/icons/add-user.png" style="width:17px; height:19px; border:0;margin-left: 10px;"/></a>'+
                    '<a href="' + huxley.root + 'group/remove/' + group.hash + '" onclick="return confirm(returnMsg)"><img src="/huxley/images/icons/error.png" style="width:17px; height:19px; border:0;margin-left: 10px;"/></a>'+
                    '</td></tr>';
            });

            if(offset == 0){
                huxley.generatePagination('group-pagination',huxleyGroup.getGroup,10,data.total);
            }
            console.log(data.total);
            $('#group-list').append(toAppend);
        }
    });
};