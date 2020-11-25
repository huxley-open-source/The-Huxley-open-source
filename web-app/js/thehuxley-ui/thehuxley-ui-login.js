(function ($) {
    $(function () {
        $('div#incompatibility-message').hide();
        $('input#username').focus();
        $('a#tour-open-modal').click(function () {
            th.modal.open('tour-modal');
        });
        $('button#tour-close-modal').click(function () {
            th.modal.close();
        });
        th.topcoder.create('topcoder-content', 5);
    });
})(window.jQuery);
