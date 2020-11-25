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