(function (hx, Backbone) {
    'use strict';

    hx.models.UserCollection = Backbone.Collection.extend({
        model: hx.models.User
    });

}(window.hx, window.Backbone));

