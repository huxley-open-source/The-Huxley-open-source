(function (hx, Backbone, $, EJS) {

    'use strict';

    hx.views.TopCoderView = Backbone.View.extend({

        initialize: function () {
            this.collection.on('reset', this.onCollectionReset, this);
            this.collection.on('add', this.onCollectionAdd, this);
        },

        template: new EJS({url: hx.util.url('huxley/templates/topcoder/topcoder.ejs')}),

        onCollectionReset: function (collection) {
            var instance = this;
            collection.each(function (model, i) {
                model.set({topCoderPosition: (i + 1)});
                instance.onCollectionAdd(model);
            });
        },

        onCollectionAdd: function (model) {
            var view = new hx.views.TopCoderUserBoxView({model: model});
            $('ul.topcoders-list').append(view.render().el);
        },

        render: function () {
            this.$el.html(this.template.render());
        }

    });

}(window.hx, window.Backbone, window.jQuery, window.EJS));

