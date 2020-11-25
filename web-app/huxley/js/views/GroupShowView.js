(function (hx, Backbone, $, EJS) {

    'use strict';

    hx.views.GroupShowView = Backbone.View.extend({

        initialize: function () {
            this.model.on('change', this.render, this);

            this.users = new hx.models.UserCollection();
            this.users.url = hx.util.url.rest('groups/' + this.model.id + '/users');
            this.users.on('reset', this.filters, this);
        },

        filters: function(collection) {

            var teachers = collection.filter(function (model) {
                return model.get('permission') === 30;
            });

            var members = collection.filter(function (model) {
                return model.get('permission') === 0;
            });

            var teacherCollection = new hx.models.UserCollection();
            var memberCollection = new hx.models.UserCollection();

            teacherCollection.reset(teachers);
            memberCollection.reset(members);


            memberCollection.each(function (model) {
                var view = new hx.views.GroupUserBoxView({model: model});
                $('div.group-show-members').append(view.render().el)
            });

            teacherCollection.each(function (model) {
                var view = new hx.views.GroupUserBoxView({model: model});
                $('div.group-show-teachers').append(view.render().el)
            });

        },

        template: new EJS({url: hx.util.url('huxley/templates/group/show.ejs')}),

        render: function () {
            this.$el.html(this.template.render(this.model.toJSON()));
            this.users.fetch({reset: true});
        }

    });

}(window.hx, window.Backbone, window.jQuery, window.EJS));
