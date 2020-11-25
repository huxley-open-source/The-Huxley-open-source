/*global module, grunt*/

module.exports = function (grunt) {
    'use strict';

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        source: grunt.file.readJSON('source.json'),

        concat: {
            options: {
                separator: '\n'
            },
            dist: {
                src: '<%= source.files %>',
                dest: '../../js/<%= pkg.name %>-<%= pkg.version %>.js'
            },
            group: {
                src: '<%= source.group.files %>',
                dest: '../../js/<%= pkg.name %>-group-<%= pkg.version %>.js'
            },
            vendor: {
                src: '<%= source.vendors.files %>',
                dest: '../../js/<%= pkg.name %>-vendors-<%= pkg.version %>.js'
            }
        },

        uglify: {
            options: {
                banner: '/*! <%= pkg.name %>-<%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
            },
            prod: {
                build: {
                    src: '<%= pkg.name %>-<%= pkg.version %>.js',
                    dest: '<%= pkg.name %>-<%= pkg.version %>.min.js'
                }
            }
        },

        watch: {
            scripts: {
                files: '**/*',
                tasks: ['concat'],
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

    grunt.registerTask('default', ['concat']);

};