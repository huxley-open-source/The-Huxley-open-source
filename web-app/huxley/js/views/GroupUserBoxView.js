(function (hx, Backbone, $, EJS) {

    'use strict';

    hx.views.GroupUserBoxView = Backbone.View.extend({

        tagName: 'div',

        className: 'group-show-user',

        template: new EJS({url: hx.util.url('huxley/templates/user/user-box.ejs')}),

        render: function () {
            this.$el.html(this.template.render(this.model.toJSON()));
            return this;
        }

    });

}(window.hx, window.Backbone, window.jQuery, window.EJS));