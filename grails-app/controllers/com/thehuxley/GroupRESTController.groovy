package com.thehuxley

class GroupRESTController {

    def groupService
    def clusterPermissionService

    def show = {

        render (contentType: 'application/json') {
            if (params.id) {
                groupService.publicFields(Cluster.findByHash(params.id))
            } else {
                def q = (params.q && ((params.q as String).size() > 0 && (params.q as String).size() < 20)) ? (params.q as String) : ""
                def max = ((params.max) && ((params.max as int) > 0 || (params.max as int) < 20)) ? (params.max as int) : 20
                def offset = (params.offset) ? params.offset as int : 0
                groupService.publicFields(Cluster.findAllByNameLike("%$q%", [max: max, offset: offset]))
            }
        }
    }

    def update = {}

    def save = {}

    def delete = {}

    def getUsers = {
        def group = Cluster.findByHash(params.id)
        if(group){
            def clusterPermissions = ClusterPermissions.findAllByGroup(group)
            if(clusterPermissions){
                render (contentType: 'application/json') {
                    clusterPermissionService.publicFields(clusterPermissions)
                }
                return
            }
        }
        render (contentType: 'application/json') {
            msg = "empty"
        }


    }
}
