(function (hx, Backbone, $) {
    'use strict';

    $(function () {
        var groupSearchInputTimeOut;
        var usingKey = false;
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
                useKey: function(key, collection) {
                    if (!usingKey) {
                        $.ajax({
                            url: '/huxley/group/addByAccessKey',
                            data: {accessKey:key},
                            dataType: 'json',
                            beforeSend: function () {
                                usingKey = true;
                            },
                            success: function(data) {
                                $('#access-key-box').removeClass('error');
                                if (data.status === 'fail') {
                                    $('#access-key-box').addClass('error');
                                    $('#access-box-message').empty().append(data.txt);
                                } else {
                                    $('#access-box-message').empty().append('Adicionado a <a href="#show/' + data.group.hash + '">'  + data.group.name + '</a>');
                                    $('.group-list-item').empty();
                                    collection.fetch({reset: true});
                                }
                                usingKey = false;
                            }
                        });
                    }

                },

                index: function () {
                    var collection = new hx.models.GroupCollection();
                    collection.url = hx.util.url.rest('users/groups');
                    this.changeView(new hx.views.GroupIndexView({collection: collection, el: $('div#box-content')}));
                    collection.fetch({reset: true});
                    this.topcoder();
                    var that = this;
                    $('#group-access-key').click(function (e) {
                        e.stopPropagation();
                        if (!$('#access-key-container').is(':visible')) {
                            $("#access-key").val('');
                            $('#access-key-box').removeClass('error');
                            $('#access-box-message').empty().append('Digite sua chave de acesso');
                            $('#access-key-container').slideDown(50, function () {
                                $(document).one('click', function (e) {
                                    e.stopPropagation();
                                    $('#access-key-container').slideUp(50, function() {
                                        huxley.changeConfigMenuStyle(true);
                                    });
                                });
                            });
                        }

                    });
                    $('#access-key').keyup(function() {
                        clearTimeout(groupSearchInputTimeOut);
                        groupSearchInputTimeOut = setTimeout(function() {
                            that.useKey($("#access-key").val(), collection);
                        }, 1000);
                    });
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

(function (hx, $) {
    'use strict';


}(window.hx, window.jQuery));
