// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require turbolinks
//= require underscore
//= require_self
//= require_tree .

$(document).on('ready page:load', function(){
    $(document).foundation();

    // A very pragmatic sticky footer.
    (function(){
        var $main = $('.site-main');
        var $header = $('.site-header');
        var $footer = $('.site-footer');
        var stick_it = function(){
            var window_height = window.innerHeight;
            $main.css('min-height', window_height - $header.outerHeight() - $footer.outerHeight());
        };
        stick_it();
        $(window).on('resize', _.throttle(stick_it, 50));
        $(document).on('page:change', stick_it);
    }());
});

(function($doc){
    /**
     * Fire custom events when Turbolinks loads and unloads pages
     * These events are "namespaced" to the controller and action and can be used to add controller specific functionality.
     *
     * So if the request is for Users#Show this will fire:
     *
     *   portfolio.users.show:change
     *   portfolio.users:change
     *   portfolio.users:after-remove
     *   portfolio.users.show:after-remove
     *
     * Note that the controller name is the last part of the controller’s name, underscored, without the ending Controller
     * @see http://apidock.com/rails/ActionController/Metal/controller_name/class
     * @see https://github.com/rails/turbolinks
     */
    (function(){
        var add_triggers = function(event){
            var $b = $('body');
            var namespaces = ['portfolio', $b.data('controller')];
            $doc.trigger(namespaces.join('.') + event);
            namespaces.push($b.data('action'));
            $doc.trigger(namespaces.join('.') + event);
        };
        $doc.on('page:change', function(){
            add_triggers(':change');
        });
        $doc.on('page:after-remove', function(){
            add_triggers(':after-remove');
        });
    }());
    /**
     * Create "flash" messages by triggering $(document).trigger('flash', [key, msg])
     */
    $doc.on('flash', function(e, key, message){
        var $flash = $('<li class="alert-box flash"></li>')
            .addClass(key)
            .html(message);

        $(this).find('.flashes').append($flash);
    });
}($(document)));


