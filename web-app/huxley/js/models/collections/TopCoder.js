(function (hx, Backbone) {
    'use strict';

    hx.models.TopCoder = Backbone.Collection.extend({
        model: hx.models.User
    });

}(window.hx, window.Backbone));
