package com.thehuxley

import grails.converters.JSON

class ProfileRESTController {

    def profileService
    def groupService
    def userService

    def show() {
        render (contentType: 'application/json') {
            if (params.id) {
                profileService.publicFields(Profile.findByHash(params.id))
            } else if (params.current && session.profile) {
                profileService.publicFields(session.profile)
            } else {
                def q = (params.q && ((params.q as String).size() > 0 && (params.q as String).size() < 20)) ? (params.q as String) : ""
                def max = ((params.max) && ((params.max as int) > 0 || (params.max as int) < 20)) ? (params.max as int) : 20
                def offset = (params.offset) ? params.offset as int : 0
                userService.publicFields(ShiroUser.findAllByNameLikeOrEmailLike("%$q%", "%$q%",[max: max, offset: offset]))
            }
        }
    }

    def showCurrentUserGroups() {
        def clusterPermissions = ClusterPermissions.findAllByUser(session.profile.user)
        def groups = [];
        clusterPermissions.each {
            def group = groupService.publicFields(it.group)
            group.put('permissions', it.permission)
            groups.add(group)
        }

        render groups as JSON
    }

    def showGroups() {

        def profile = Profile.findByHash(params.id)
        def clusterPermissions
        def groups = []
        render (contentType: 'application/json') {
            if (params.gid) {
                def group = Cluster.findByHash(params.gid)
                def response = [:], permissions = []
                clusterPermissions = ClusterPermissions.findAllByGroupAndUser(group, profile.user);
                if (!clusterPermissions.empty) {
                    response = groupService.publicFields(group)
                }
                clusterPermissions.each {
                    permissions.add(it.permission)
                }

                response.put('permissions', permissions)

                response
            } else {
                clusterPermissions = ClusterPermissions.findAllByUser(profile.user)
                clusterPermissions.each {
                    def group = groupService.publicFields(it.group)
                    group.put('permissions', it.permission)
                    groups.add(group)
                }

                groups
            }
        }
    }
}
