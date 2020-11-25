(function (hx, Backbone, $, EJS) {

    'use strict';

    hx.views.TopCoderUserBoxView = Backbone.View.extend({

        tagName: 'li',

        template: new EJS({url: hx.util.url('huxley/templates/user/user-box-position.ejs')}),

        render: function () {
            this.$el.html(this.template.render(this.model.toJSON()));
            return this;
        }

    });

}(window.hx, window.Backbone, window.jQuery, window.EJS));
