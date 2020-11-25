module.exports = function (grunt) {
    'use strict';

    grunt.initConfig({
         less: {
            development: {
                options: {
                    compress: true
                },
                files: {
                    '../../css/style.css': 'huxley.less'
                }
            }
        },

        watch: {
            scripts: {
                files: '**/*',
                tasks: ['less'],
                options: {

                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-qunit');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-less');

    grunt.registerTask('default', ['less']);
};