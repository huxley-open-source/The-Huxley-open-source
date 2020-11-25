var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-31438174-1']);
_gaq.push(['_trackPageview']);

(function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
var th = (function ($, _, Mustache) {
    $.fn.spin = function(opts) {
        this.each(function() {
            var $this = $(this),
                data = $this.data();

            if (data.spinner) {
                data.spinner.stop();
                delete data.spinner;
            }
            if (opts !== false) {
                data.spinner = new Spinner($.extend({color: $this.css('color')}, opts)).spin(this);
            }
        });
        return this;
    };
    return {};
}) (jQuery, _, Mustache);

(function (th, $) {
    $(function () {
        $('div.alert').find('button.close').click(function (e) {
            e.preventDefault();
            $(this).parent().fadeOut('fast');
        });
    });
})(th, jQuery);

(function (th, $, Mustache) {

    th.modal = {};

    var template = '<div id="mask" class="mask-lift"><div class="mask-outer"><div class="mask-inner"><div id="mask-container" class="mask-container"></div></div></div></div>';

    th.modal.open = function(el) {
        $('body').addClass('theater');
        $('body').append($(Mustache.render(template)).fadeIn('fast'));
        $('div#mask-container').append($('#' + el).fadeIn('fast'));
        $('div#mask-container div.modal-header > button.close').click(function(e) {
            th.modal.close();
        });
        $('div.modal').click(function(e) {
            e.stopPropagation();
        });
        $('div#mask').click(function(e) {
            e.stopPropagation();
            th.modal.close();
        });
    };

    th.modal.close = function() {
        $('body').removeClass('theater');
        $('body').append($('div#mask-container').children().hide());
        $('div#mask').fadeOut('fast').remove();
    };

})(th, jQuery, Mustache);

(function (th, $, Mustache) {

    th.topcoder = {};

    var template = '<li><div class="user-box"><div class="position">{{position}}º</div><div class="info"><ul>' +
                   '<li class="name">{{name}}</li><li class="institution">{{institution}}</li>' +
                   '<li class="score">{{score}}</li></ul></div><div class="picture">' +
                   '<img src="http://img.thehuxley.com/data/images/app/profile/thumb/{{smallPhoto}}" alt="{{name}}"/>' +
                   '</div></div></li>';

    th.topcoder.create = function (el, limit) {
        $.ajax('/huxley/topCoder/getTopCoders', {
            data: {limit: limit},
            dataType: 'json',
            beforeSend: function () {
                $('#' + el).spin();
            },
            success: function (data) {
                $('#' + el).empty();
                $('#' + el).append('<div id="topcoder" class="topcoder"><h3>TOP<span>CODER</span></h3><ul id="topcoders-list"></ul></div>');
                $.each(data, function (i, topcoder) {
                    $('ul#topcoders-list').append(Mustache.render(template, topcoder));
                });

            }
        });
    };

})(th, jQuery, Mustache);
