(function (hx, Backbone) {
    'use strict';

    hx.models.GroupCollection = Backbone.Collection.extend({
        model: hx.models.Group
    });

}(window.hx, window.Backbone));


