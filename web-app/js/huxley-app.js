(function ($, Backbone, Mustache, huxley) {
    'use strict';

    $(function () {

        var AppRouter =  new (Backbone.Router.extend({
            routes: {
                'problem/management' : 'problemManagementIndex',
                'problem/management/show/:id' : 'problemManagementShow'
            },

            initialize: function () {
                this.problemList = new huxley.ProblemList();
            },

            problemManagementIndex: function () {

                var problemView = new huxley.ProblemListView({collection: this.problemList, tagName: 'tbody'});
                $('div#app-content').empty().append(Mustache.render($('script#problem-management-template').html()));
                this.problemList.url = '/huxley/method/problem/list';
                problemView.modelTagName = 'tr';
                problemView.modelTemplate = $('script#problem-template').html();
                problemView.afterRender = function () {
                    $('select').change(function () {
                        console.log('mudou' + $(this).find('option:selected').val());
                    });
                };
                problemView.render();
                $('table#app').html(problemView.el);
                this.problemList.fetch();
            },

            problemManagementShow: function (id) {
                $('div#app-content').empty();
                console.log(id);
                var problem = new huxley.Problem({id: id}),
                    problemView = new huxley.ProblemView({model: problem});
                problem.id = id;
                problemView.template = $('script#problem-show-template').html();
                problem.url = '/huxley/method/problem';
                problemView.render();
                $('div#app-content').html(problemView.el);
                problem.fetch();
            }
        }))();

        Backbone.history.start({pushState: true, root: "/huxley/"});

        $('div#app-content').delegate('a.ps', 'click', function (e) {
            e.preventDefault();
            Backbone.history.navigate($(this).attr('href'), true);
        });

    });


}(window.jQuery, window.Backbone, window.Mustache, window.huxley));

