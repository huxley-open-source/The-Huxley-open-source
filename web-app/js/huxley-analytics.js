var huxleyAnalytics = huxleyAnalytics || {};

huxleyAnalytics.context = 'submission';
huxleyAnalytics.selectedOptionKind = 'country';

huxleyAnalytics.populateCountry = function(){
    $.ajax({
        url: huxley.root + 'analytics/listCountry',
        async: false,
        dataType: 'json',
        success: function(data) {
            var toAppend = '<option value="0">País</option>';
            $('#country-list').empty();
            $.each(data.countries, function(i, country) {
                toAppend+='<option value="'+country.id+'">'+country.name+'</option>';
            });
            $('#country-list').append(toAppend);
        }
    });
}

huxleyAnalytics.populateRegion = function(){
    var e = document.getElementById("country-list");
    var countryId = 0;
    if(e.options[e.selectedIndex] != undefined){
        countryId = e.options[e.selectedIndex].value;
    }

    $.ajax({
        url: huxley.root + 'analytics/listRegion',
        async: false,
        data:'id=' + countryId,
        dataType: 'json',
        success: function(data) {
            var toAppend = '<option value="0">Região</option>';
            $('#region-list').empty();
            $.each(data.regions, function(i, region) {
                toAppend+='<option value="'+region.id+'">'+region.name+'</option>';
            });
            $('#region-list').append(toAppend);
        }
    });
}

huxleyAnalytics.populateState = function(){
    var e = document.getElementById("region-list");
    var regionId = 0;
    if(e.options[e.selectedIndex] != undefined){
        regionId = e.options[e.selectedIndex].value;
    }
    $.ajax({
        url: huxley.root + 'analytics/listState',
        async: false,
        data:'id=' + regionId,
        dataType: 'json',
        success: function(data) {
            var toAppend = '<option value="0">Estado</option>';
            $('#state-list').empty();
            $.each(data.states, function(i, state) {
                toAppend+='<option value="'+state.id+'">'+state.name+'</option>';
            });
            $('#state-list').append(toAppend);
        }
    });
}

huxleyAnalytics.populateCity = function(){
    var e = document.getElementById("state-list");
    var stateId = 0;
    if(e.options[e.selectedIndex] != undefined){
        stateId = e.options[e.selectedIndex].value;
    }
    $.ajax({
        url: huxley.root + 'analytics/listCity',
        async: false,
        data:'id=' + stateId,
        dataType: 'json',
        success: function(data) {
            var toAppend = '<option value="0">Cidade</option>';
            $('#city-list').empty();
            $.each(data.cities, function(i, city) {
                toAppend+='<option value="'+city.id+'">'+city.name+'</option>';
            });
            $('#city-list').append(toAppend);
        }
    });
}

huxleyAnalytics.populateInstitution = function(){
    var e = document.getElementById("city-list");
    var cityId = 0;
    if(e.options[e.selectedIndex] != undefined){
        cityId = e.options[e.selectedIndex].value;
    }
    $.ajax({
        url: huxley.root + 'analytics/listInstitution',
        async: false,
        data:'id=' + cityId,
        dataType: 'json',
        success: function(data) {
            var toAppend = '<option value="0">Instituição</option>';
            $('#institution-list').empty();
            $.each(data.institutions, function(i, institution) {
                toAppend+='<option value="'+institution.id+'">'+institution.name+'</option>';
            });
            $('#institution-list').append(toAppend);
        }
    });
}

huxleyAnalytics.updateData = function(option){
    huxleyAnalytics.selectedOptionKind = option;
    if(huxleyAnalytics.context == 'submission'){
        huxleyAnalytics.initializeAnalytics(huxleyAnalytics.selectedOptionKind,'submission');
    }else if(huxleyAnalytics.context == 'language'){
        huxleyAnalytics.initializeLanguageAnalytics(huxleyAnalytics.selectedOptionKind);
    }else if(huxleyAnalytics.context == 'topic'){
        huxleyAnalytics.initializeTopicAnalytics(huxleyAnalytics.selectedOptionKind);
    }
    if(huxleyAnalytics.selectedOptionKind=='country'){
        huxleyAnalytics.populateRegion();
    }else if(huxleyAnalytics.selectedOptionKind == 'region'){
        huxleyAnalytics.populateState();
    }else if(huxleyAnalytics.selectedOptionKind == 'state'){
        huxleyAnalytics.populateCity();
    }else if(huxleyAnalytics.selectedOptionKind == 'city'){
        huxleyAnalytics.populateInstitution();
    }
}



huxleyAnalytics.createChart = function(divId,type,series,categories,title,yAxisTitle,yAxis,xAxis) {
    chart1 = new Highcharts.Chart({
        chart: {

            renderTo: divId,

            type: type

        },

        title: {

            text: title

        },

        xAxis: {

            categories: categories

        },

        yAxis: {

            title: {

                text: yAxisTitle

            }

        },

        tooltip: {
            formatter: function() {
                if(type == "pie"){
                    return '<b>'+ this.point.name + '</b>: ' + this.percentage.toFixed(2) +' %';
                }else if(type == "column"){
                    return '<b>'+ this.series.name + '</b><br/>' + this.x + ':' + this.y + '<br/>';
                }else{
                    var date = new Date(this.x);
                    return '<b>'+ this.series.name + '</b><br/>' + xAxis + ':' + date.getDay() + '/' + date.getMonth() + '/' + date.getYear() + '<br/>' + yAxis + ': ' + this.y;

                }
            }

        },

        series: series

    });

}

huxleyAnalytics.changeContext = function(context){
    huxleyAnalytics.context = context;
    huxleyAnalytics.updateData('country');
}



