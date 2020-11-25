huxleyAnalytics.analyticsTopicData = function(){
    var e = document.getElementById(huxleyAnalytics.selectedOptionKind+"-list");
    if(e.options[e.selectedIndex] != undefined){
        cityId = e.options[e.selectedIndex].value;
    }
    $.ajax({
        url: huxley.root + 'analytics/getTopicsData',
        async: true,
        data:'id=' + cityId + '&kind=' + huxleyAnalytics.selectedOptionKind,
        dataType: 'json',
        success: function(data) {
            var toAppendLeft = '';
            var toAppendRight = '';
            var toAppendLeftHead = '<th>Instituição</th>';
            var toAppendRightHead = '';

            $.each(data.categories, function(i, categorie) {
                toAppendRightHead+='<th>'+categorie+'</th>';
            });

            $.each(data.data, function(i, result) {
                toAppendLeft += '<tr><td>' + result.name + '</td></tr>';
                toAppendRight +='<tr>';
                $.each(result.data, function(i, dataContent) {
                    toAppendRight +='<td>' + dataContent + '</td>';
                });
                toAppendRight += '<tr>';
            });
            $("#left-table").empty();
            $("#left-table").append(toAppendLeftHead);
            $("#right-table").empty();
            $("#right-table").append(toAppendRightHead);
            $('#left-table-content').empty();
            $('#right-table-content').empty();
            $('#left-table-content').append(toAppendLeft);
            $('#right-table-content').append(toAppendRight);
        }
    });
}
huxleyAnalytics.analyticsTopicChart = function(){
    var e = document.getElementById(huxleyAnalytics.selectedOptionKind+"-list");
    if(e.options[e.selectedIndex] != undefined){
        cityId = e.options[e.selectedIndex].value;
    }
    $.ajax({
        url: huxley.root + 'analytics/getTopicsChart',
        async: true,
        data:'id=' + cityId + '&kind=' + huxleyAnalytics.selectedOptionKind,
        dataType: 'json',
        success: function(data) {
            huxleyAnalytics.createChart('chart','column',data.data,data.categories,'Gráfico de Linguagens','','','');
        }
    });
}

huxleyAnalytics.initializeTopicAnalytics = function(kind){
    $("#subtitle").empty();
    $("#subtitle").append("Tópicos");
    $("#description").empty();
    $("#description").append("Esses dados representam o valores absolutos de submissões para cada tópico.");
    huxleyAnalytics.analyticsTopicData();
    huxleyAnalytics.analyticsTopicChart();

}