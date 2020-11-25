huxleyAnalytics.analyticsInstitutionInfo = function(){
    var e = document.getElementById(huxleyAnalytics.selectedOptionKind+"-list");
    if(e.options[e.selectedIndex] != undefined){
        cityId = e.options[e.selectedIndex].value;
    }
    $.ajax({
        url: huxley.root + 'analytics/listInstitutionInfo',
        async: true,
        data:'id=' + cityId + '&kind=' + huxleyAnalytics.selectedOptionKind,
        dataType: 'json',
        success: function(data) {
            if(huxleyAnalytics.selectedOptionKind == 'institution'){
                $("#left-table").empty();
                $("#right-table").empty();

                var toAppendLeft = '';
                var toAppendRight = '';
                $.each(data.institutions, function(i, institution) {
                    toAppendLeft += '<tr><td>Nome</td></tr>'+
                                    '<tr><td>Submissões</td></tr>'+
                                    '<tr><td>Submissões Corretas</td></tr>'+
                                    '<tr><td>Submissões (15)</td></tr>'+
                                    '<tr><td>Submissões Corretas (15)</td></tr>'+
                                    '<tr><td>Problemas</td></tr>'+
                                    '<tr><td>Problemas Corretos</td></tr>'+
                                    '<tr><td>Problemas (15)</td></tr>'+
                                    '<tr><td>Problemas Corretos (15)</td></tr>';
                    toAppendRight +='<tr><td>' + institution.name + '</td></tr>' +
                                    '<tr><td>' + institution.submissionCount + '</td></tr>' +
                                    '<tr><td>' + institution.submissionCorrectCount + '</td></tr>' +
                                    '<tr><td>' + institution.problemsTried + '</td></tr>' +
                                    '<tr><td>' + institution.problemsCorrect + '</td></tr>' +
                                    '<tr><td>' + institution.topSubmissionCount + '</td></tr>' +
                                    '<tr><td>' + institution.topSubmissionCorrectCount + '</td></tr>' +
                                    '<tr><td>' + institution.topProblemsTried + '</td></tr>' +
                                    '<tr><td>' + institution.topProblemsCorrect + '</td></tr>'
                                    '</tr>';

                });
                $('#left-table-content').empty();
                $('#right-table-content').empty();
                $('#left-table-content').append(toAppendLeft);
                $('#right-table-content').append(toAppendRight);
            }else{
                $("#left-table").empty();
                $("#left-table").append('<th>Nome</th>');
                $("#right-table").empty();
                $("#right-table").append('<th>Submissões</th>'+
                    '<th>Submissões Corretas</th>'+
                    '<th>Submissões (15)</th>'+
                    '<th>Submissões Corretas (15)</th>'+
                    '<th>Problemas</th>'+
                    '<th>Problemas Corretos</th>'+
                    '<th>Problemas (15)</th>'+
                    '<th>Problemas Corretos (15)</th>');
                var toAppendLeft = '';
                var toAppendRight = '';
                $.each(data.institutions, function(i, institution) {

                    toAppendLeft += '<tr><td>' + institution.name + '</td></tr>';
                    toAppendRight +='<tr><td>' + institution.submissionCount + '</td>' +
                        '<td>' + institution.submissionCorrectCount + '</td>' +
                        '<td>' + institution.problemsTried + '</td>' +
                        '<td>' + institution.problemsCorrect + '</td>' +
                        '<td>' + institution.topSubmissionCount + '</td>' +
                        '<td>' + institution.topSubmissionCorrectCount + '</td>' +
                        '<td>' + institution.topProblemsTried + '</td>' +
                        '<td>' + institution.topProblemsCorrect + '</td>'
                    '</tr>';

                });
                $('#left-table-content').empty();
                $('#right-table-content').empty();
                $('#left-table-content').append(toAppendLeft);
                $('#right-table-content').append(toAppendRight);
            }

        }
    });
}

huxleyAnalytics.analyticsInfo = function(kind){
    var e = document.getElementById(kind+"-list");
    var searchId = 0
    if(e.options[e.selectedIndex] != undefined){
        searchId = e.options[e.selectedIndex].value;
    }

    $.ajax({
        url: huxley.root + 'analytics/listAnalytics',
        async: true,
        data:'id=' + searchId + '&kind='+kind,
        dataType: 'json',
        success: function(data) {
            $("#left-table").empty();
            $("#left-table").append('<th>Nome</th>');
            $("#right-table").empty();
            $("#right-table").append('<th>Submissões</th>'+
                '<th>Submissões Corretas</th>'+
                '<th>Problemas</th>'+
                '<th>Problemas Corretos</th>');
            var toAppendLeft = '';
            var toAppendRight = '';
            $.each(data.results, function(i, result) {

                toAppendLeft += '<tr><td>' + result.name + '</td></tr>';
                toAppendRight +='<tr><td>' + result.submissionCount + '</td>' +
                    '<td>' + result.submissionCorrectCount + '</td>' +
                    '<td>' + result.problemsTried + '</td>' +
                    '<td>' + result.problemsCorrect + '</td>' +
                    '</tr>';

            });
            $('#left-table-content').empty();
            $('#right-table-content').empty();
            $('#left-table-content').append(toAppendLeft);
            $('#right-table-content').append(toAppendRight);
        }
    });

}


huxleyAnalytics.analyticsGeneralInstitutionChart = function(kind){
    var url =huxley.root + 'analytics/getInstitutionProblems'
    if(kind == 'submission'){
        url = huxley.root + 'analytics/getInstitutionSubmissions'
    }
    var e = document.getElementById("city-list");
    if(e.options[e.selectedIndex] != undefined){
        cityId = e.options[e.selectedIndex].value;
    }
    $.ajax({
        url: url,
        async: true,
        data:'id=' + cityId+ '&kind=' + huxleyAnalytics.selectedOptionKind,
        dataType: 'json',
        success: function(data) {
            if(kind == 'submission'){
                huxleyAnalytics.createChart('chart','line',data.data,'','Gráfico de Tempo x Submissões','total','Submissões','Data');
            }else{
                huxleyAnalytics.createChart('chart','line',data.data,'','Gráfico de Tempo x Problemas','total','Problemas','Data');
            }

        }
    });

}

huxleyAnalytics.analyticsGeneralChart = function(kind,type){
    var url =huxley.root + 'analytics/listProblemAnalytics'
    if(type == 'submission'){
        url = huxley.root + 'analytics/listSubmissionAnalytics'
    }
    var e = document.getElementById(kind + "-list");
    if(e.options[e.selectedIndex] != undefined){
        cityId = e.options[e.selectedIndex].value;
    }
    $.ajax({
        url: url,
        async: true,
        data:'id=' + cityId + '&kind=' + kind,
        dataType: 'json',
        success: function(data) {
            if(kind == 'submission'){
                huxleyAnalytics.createChart('chart','line',data.data,'','Gráfico de Tempo x Submissões','total','Submissões','Data');
            }else{
                huxleyAnalytics.createChart('chart','line',data.data,'','Gráfico de Tempo x Problemas','total','Problemas','Data');
            }

        }
    });

}

huxleyAnalytics.initializeAnalytics = function(kind){
    $("#subtitle").empty();
    $("#subtitle").append("Submissões");
    $("#description").empty();
    $("#description").append("Esses dados representam o valores absolutos de submissões.");
    if((kind == 'institution')||(kind == 'city')){
        huxleyAnalytics.analyticsInstitutionInfo();
        huxleyAnalytics.analyticsGeneralInstitutionChart('submission');
    }else{
        huxleyAnalytics.analyticsInfo(kind);
        huxleyAnalytics.analyticsGeneralChart(kind,'submission');
    }
}