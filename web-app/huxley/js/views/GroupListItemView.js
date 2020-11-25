(function (hx, Backbone, $, EJS) {

    'use strict';

    hx.views.GroupListItemView = Backbone.View.extend({

        initialize: function () {

        },

        tagName: 'tr',

        className: 'group-list-item',

        template: new EJS({url: hx.util.url('huxley/templates/group/list-item.ejs')}),

        render: function () {
            this.$el.html(this.template.render(this.model.toJSON()));

            return this;
        }

    });

}(window.hx, window.Backbone, window.jQuery, window.EJS));
