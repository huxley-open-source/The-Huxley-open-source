(function (hx, Backbone, $) {
    'use strict';

    $(function () {
        var groupApp = new (Backbone.Router.extend({
                routes: {
                    "": "index",
                    "show/:id": "show"
                },

                initialize: function () {

                },

                changeView: function (view) {
                    if (this.currentView !== undefined) {
                        this.currentView.undelegateEvents();
                    }
                    this.currentView = view;
                    this.currentView.render();
                },

                index: function () {
                    var collection = new hx.models.GroupCollection();
                    collection.url = hx.util.url.rest('users/groups');
                    this.changeView(new hx.views.GroupIndexView({collection: collection, el: $('div#box-content')}));
                    collection.fetch({reset: true});
                    this.topcoder();
                },

                show: function (id) {
                    var model = new hx.models.Group({id: id});
                    new hx.views.GroupShowView({model: model, el: $('div#box-content')});

                    model.fetch();
                    this.topcoderGroup(id);
                },

                start: function () {
                    Backbone.history.start();
                },

                topcoder: function() {
                    var collection = new hx.models.TopCoder();
                    collection.url = hx.util.url.rest('topcoders');
                    this.changeView(new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')}));
                    collection.fetch({reset: true});
                },

                topcoderGroup: function(id) {
                    var collection = new hx.models.TopCoder();
                    collection.url = hx.util.url.rest('topcoders');
                    this.changeView(new hx.views.TopCoderView({collection: collection, el: $('div#topcoder')}));
                    collection.fetch({reset: true, data: {id: id}});
                }


            }))();

        groupApp.start();
    });

}(window.hx, window.Backbone, window.jQuery));
