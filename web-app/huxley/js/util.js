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
