(function (hx, Backbone) {
    'use strict';

    hx.models.Group = Backbone.Model.extend({
        urlRoot: hx.util.url.rest('groups/'),
        defaults: {
            name: ""
        }
    });

}(window.hx, window.Backbone));