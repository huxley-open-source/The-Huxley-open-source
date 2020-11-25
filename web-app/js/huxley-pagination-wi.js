var huxleyPaginationWI = huxleyPaginationWI || {};
huxleyPaginationWI.paginationContainer = '';
huxleyPaginationWI.updateFunction = function(){

};
huxleyPaginationWI.max = 20;

huxleyPaginationWI.createPagination = function(container,updateFunction,max){
    huxleyPaginationWI.paginationContainer = container;
    huxleyPaginationWI.max = max;
    huxleyPaginationWI.updateFunction = updateFunction;
    $("#" + container).append('<a id="pagination-show-more" style="color: #ADADAD;font-size: 12px;text-decoration: none;"href="javascript:void(0)" >Exibir Mais</a><span id="pagination-image" style="width: 17px;"><img  style="position: absolute;margin-left: 4px;" src="/huxley/images/spinner.gif" /></span>')
    $("#" + container).addClass('paginationWI');
    $("#" + container).click(function() {
        huxleyPaginationWI.updateFunction(huxleyPaginationWI.max);
    });
}

huxleyPaginationWI.loading = function(){
    $("#pagination-image").show();
}

huxleyPaginationWI.loaded = function(){
    $("#pagination-image").hide();
}

huxleyPaginationWI.paginate = function(){
    $("#" + huxleyPaginationWI.paginationContainer).show();
}
huxleyPaginationWI.stopPaginate = function(){
    $("#" + huxleyPaginationWI.paginationContainer).hide();
}
huxleyPaginationWI.line = 0;
$(document).ready(function() {
    $(window).scroll(function() {
        if ($(this).scrollTop() + $(this).innerHeight() >= $('#content').height()) {
            huxleyPaginationWI.line++;
            var ticket = huxleyPaginationWI.line;
            setTimeout(function() {
                if(huxleyPaginationWI.line==ticket){
                    huxleyPaginationWI.updateFunction(huxleyPaginationWI.max);
                }
            }, 1000);


        }
    });
});