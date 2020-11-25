var hx = {};

(function () {
    'use strict';

    hx.config = {
        url: {
            root: '/huxley',
            rest: '/huxley/1.0'
        }
    };

    hx.util = {};
    hx.models = {};
    hx.views = {};
    hx.routers = {};

    hx.util.url = function (path) {
        return hx.config.url.root + '/' + path;
    };

    hx.util.url.rest = function (path) {
        return hx.config.url.rest + '/' + path;
    };

}());

(function (hx, Backbone) {
    'use strict';

    hx.models.Group = Backbone.Model.extend({
        urlRoot: hx.util.url.rest('groups/'),
        defaults: {
            name: ""
        }
    });

}(window.hx, window.Backbone));
(function (hx, Backbone) {
    'use strict';

    hx.models.User = Backbone.Model.extend({
        defaults: {
            name: "Usuário sem Profile",
            smallPhoto: "thumb.jpg",
            topCoderPosition: 0,
            topCoderScore: 0,
            institution: {id: "", name: "Nenhuma instituição vinculada"}
        }
    });

}(window.hx, window.Backbone));
(function (hx, Backbone) {
    'use strict';

    hx.models.GroupCollection = Backbone.Collection.extend({
        model: hx.models.Group
    });

}(window.hx, window.Backbone));



(function (hx, Backbone) {
    'use strict';

    hx.models.TopCoder = Backbone.Collection.extend({
        model: hx.models.User
    });

}(window.hx, window.Backbone));

(function (hx, Backbone) {
    'use strict';

    hx.models.UserCollection = Backbone.Collection.extend({
        model: hx.models.User
    });

}(window.hx, window.Backbone));


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

