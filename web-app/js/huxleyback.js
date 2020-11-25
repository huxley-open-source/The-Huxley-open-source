var huxley = huxley || {};

(function ($, Backbone, Mustache) {
    'use strict';

    huxley.Problem = Backbone.Model.extend({
        defaults: {
            id: 0
        }
    });

}(window.jQuery, window.Backbone));


(function ($, Backbone) {
    'use strict';

    huxley.ProblemList = Backbone.Collection.extend({model: huxley.Problem});

}(window.jQuery, window.Backbone, window.Mustache));



(function ($, Backbone, Mustache) {
    'use strict';

    huxley.ProblemView = Backbone.View.extend({
        initialize: function () {
            this.model.on('change', this.render, this);
        },

        template: '',

        render: function () {
            this.$el.html(Mustache.render(this.template, this.model.toJSON()));
        }
    });

}(window.jQuery, window.Backbone, window.Mustache));


(function ($, Backbone, Mustache) {
    'use strict';

    huxley.ProblemListView = Backbone.View.extend({

        initialize: function () {
            this.collection.on('add', this.addOne, this);
            this.collection.on('reset', this.render, this);
        },

        modelTemplate: '',

        modelTagName: '',

        afterRender: function () {},

        render: function () {
            this.collection.forEach(this.addOne, this);
            this.afterRender();
        },

        addOne: function (problem) {
            var problemView = new huxley.ProblemView({model: problem, tagName: this.modelTagName});
            problemView.template = this.modelTemplate;
            problemView.render();
            this.$el.append(problemView.el);
        }

    });

}(window.jQuery, window.Backbone, window.Mustache));
