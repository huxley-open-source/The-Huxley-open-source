huxleyAnalytics.languageInfo = function(){
    var e = document.getElementById(huxleyAnalytics.selectedOptionKind+"-list");
    if(e.options[e.selectedIndex] != undefined){
        cityId = e.options[e.selectedIndex].value;
    }
    $.ajax({
        url: huxley.root + 'analytics/getAnalyticsLanguage',
        async: true,
        data:'id=' + cityId + '&kind=' + huxleyAnalytics.selectedOptionKind ,
        dataType: 'json',
        success: function(data) {
            $("#left-table").empty();
            $("#left-table").append('<th>Instituição</th>');
            $("#right-table").empty();
            $("#right-table").append('<th>Linguagem</th><th>Submissões</th>');

            var toAppendLeft = '';
            var toAppendRight = '';
            $.each(data.results, function(i, result) {

                toAppendLeft += '<tr><td>' + result.inst + '</td></tr>';
                toAppendRight +='<tr><td>' + result.language + '</td>' +
                                '<td>' + result.total + '</td>' +
                '</tr>';

            });
            $('#left-table-content').empty();
            $('#right-table-content').empty();
            $('#left-table-content').append(toAppendLeft);
            $('#right-table-content').append(toAppendRight);
        }
    });
}

huxleyAnalytics.analyticsLanguageChart = function(kind){
    var e = document.getElementById(kind + "-list");
    if(e.options[e.selectedIndex] != undefined){
        cityId = e.options[e.selectedIndex].value;
    }
    $.ajax({
        url: huxley.root + 'analytics/getAnalyticsLanguageChart',
        async: true,
        data:'id=' + cityId + '&kind=' + kind,
        dataType: 'json',
        success: function(data) {
                huxleyAnalytics.createChart('chart','pie',[data],'','Gráfico de Linguagens','','','');


        }
    });

}


huxleyAnalytics.initializeLanguageAnalytics = function(kind){
    $("#subtitle").empty();
    $("#subtitle").append("Linguagens");
    $("#description").empty();
    $("#description").append("Esses dados representam o valores absolutos de submissões para cada linguagem.");
    huxleyAnalytics.languageInfo();
        huxleyAnalytics.analyticsLanguageChart(kind);

}