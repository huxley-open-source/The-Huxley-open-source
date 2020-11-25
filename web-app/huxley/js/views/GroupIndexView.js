(function (hx, Backbone, $, EJS) {

    'use strict';

    hx.views.GroupIndexView = Backbone.View.extend({

        initialize: function () {
            this.collection.on('reset', this.onCollectionReset, this);
            this.collection.on('add', this.onCollectionAdd, this);
        },

        template: new EJS({url: hx.util.url('huxley/templates/group/index.ejs')}),

        onCollectionReset: function (collection) {
            var instance = this;
            collection.each(function (model) {
                instance.onCollectionAdd(model);
            });
        },

        onCollectionAdd: function (model) {
            var view = new hx.views.GroupListItemView({model: model});
            $('table.group-list').append(view.render().el);
        },

        render: function () {
            this.$el.html(this.template.render());
        }

    });

}(window.hx, window.Backbone, window.jQuery, window.EJS));
