package com.thehuxley

class ClusterService {

    /**
     * Retorna o último grupo que o usuário se inscreveu.
     * @param user representa o usuário
     *
     * @return O último grupo que o usuário pertence.
     */
    def getLastGroup(ShiroUser user) {
        def clusterPermission = ClusterPermissions.findByUser(user, [sort:"id", order: 'desc'])

        if (!clusterPermission) {
            return null
        }

        return clusterPermission.group
    }
}
