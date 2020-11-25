var searchTextInputTimeOut;
var selectedIndexMainSearch = -1;
var totalIndexMainSearch = -1;
$(function() {
    $('#search-text-input').keyup(function(event) {
        clearTimeout(searchTextInputTimeOut);
        searchTextInputTimeOut = setTimeout(function() {

            if(!(totalIndexMainSearch != -1 && (event.keyCode==40||event.keyCode==38||event.keyCode==13))){
                if ($('#search-text-input').val() != '') {

                    $.ajax({
                        url: '/huxley/home/search',
                        data: 'ss=' + $('#search-text-input').val(),
                        dataType: 'json',
                        type: 'POST',
                        success: function(data) {
                            selectedIndexMainSearch = -1;
                            $('#search-suggestion-user').empty();
                            $('#search-suggestion-group').empty();
                            $('#search-suggestion-problem').empty();
                            if (data.profileList.length > 0) {
                                $('#search-suggestion-user-title').show();
                            } else {
                                $('#search-suggestion-user-title').hide();
                            }
                            if (data.groupList.length > 0) {
                                $('#search-suggestion-group-title').show();
                            } else {
                                $('#search-suggestion-group-title').hide();
                            }

                            if (data.problemList.length > 0) {
                                $('#search-suggestion-problem-title').show();
                            } else {
                                $('#search-suggestion-problem-title').hide();
                            }
                            totalIndexMainSearch = 0;
                            $.each(data.profileList, function(i, profile) {
                                $('#search-suggestion-user').append(
                                    '<a class="search-suggestion-user-box" onmouseover="selectSearchOption('+totalIndexMainSearch+')" id="main-search-'+totalIndexMainSearch+'" href="' + '/huxley/profile/show?id=' + profile.id + '">' + profile.name + '</a>'
                                );
                                totalIndexMainSearch++;
                            });

                            $.each(data.groupList, function(i, group) {
                                $('#search-suggestion-group').append(
                                    '<a class="search-suggestion-problem-box" onmouseover="selectSearchOption('+totalIndexMainSearch+')" id="main-search-'+totalIndexMainSearch+'" href="' + '/huxley/group/show/'+ group.id + '">' + group.name + '</a>'
                                );
                                totalIndexMainSearch++;
                            })

                            $.each(data.problemList, function(i, problem) {
                                $('#search-suggestion-problem').append(
                                    '<a class="search-suggestion-problem-box" onmouseover="selectSearchOption('+totalIndexMainSearch+')" id="main-search-'+totalIndexMainSearch+'" href="' + '/huxley/problem/show?id='+ problem.id + '">' + problem.name + '</a>'
                                );
                                totalIndexMainSearch++;
                            });


                            totalIndexMainSearch--;
                            if(totalIndexMainSearch>-1){
                                selectSearchOption(0);
                            }

                            $('#search-suggestion').show().fadeIn('fast');
                        }
                    });

                    $(document).one("click", function() {
                        $('#search-suggestion').hide().fadeOut('fast')
                        $('#search-suggestion-user-title').hide();
                        $('#search-suggestion-problem-title').hide();
                        selectedIndexMainSearch = -1;
                        totalIndexMainSearch = -1;
                    });
                } else {
                    $('#search-suggestion').hide().fadeOut('fast')

                }

            }
        }, 300);
    });
});
$(function() {
    $('#search-text-input').keydown(function(event) {
        if(totalIndexMainSearch != -1 && (event.keyCode==40||event.keyCode==38||event.keyCode==13)){
            switch (event.keyCode){
                case 13:
                    var beforeDiv = document.getElementById('main-search-'+selectedIndexMainSearch);
                    window.location = beforeDiv.href;
                    break;
                case 38 :
                    travelSearchOption(-1);
                    break;
                case 40 :
                    travelSearchOption(1);
                    break;
            }

        }
    });
});

function selectSearchOption(indexMainSearch){
    if(selectedIndexMainSearch != -1){
        var beforeDiv = document.getElementById('main-search-'+selectedIndexMainSearch);
        beforeDiv.style.background = '';
    }
    selectedIndexMainSearch = indexMainSearch;
    var afterDiv = document.getElementById('main-search-'+selectedIndexMainSearch);
    afterDiv.style.background = '#f28f00';
    afterDiv.style.color = '#454445';
}

function travelSearchOption(direction){
    if((selectedIndexMainSearch == -1 || selectedIndexMainSearch == 0)&& direction == -1 ){
        selectSearchOption(totalIndexMainSearch);
    }else if(selectedIndexMainSearch == totalIndexMainSearch && direction == 1){
        selectSearchOption(0);
    }else{
        selectSearchOption(selectedIndexMainSearch + direction);
    }

}

function submitSearch(){
    window.location.replace('/huxley/home/searchResults?ss=' + $('#search-text-input').val());
}

