/*global module */

module.exports = function (grunt) {
    'use strict';

    grunt.initConfig({

        less : {
            development: {
                options: {
                    compress: false
                },

                files: {
					'../../css/th-web-components.css': 'less/th-web-components.less'
                }
            }
        },

        watch: {
            css: {
                files: '**/*.less',
                tasks: ['less']
            }
        }

    });

    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.registerTask('default', ['watch']);

};