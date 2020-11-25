package com.thehuxley

import com.thehuxley.ClusterPermissions
import com.thehuxley.Cluster
import com.thehuxley.Profile

class TopCoderService {

    /**
     * Retorna uma lista de usuários de acordo com a posição no topcoder
     * @params:limit Número de usuários que a lista deve retornar
     * @return: ArrayList<Profile>
     */
    def getTopCoderGeneralList(limit){

        def list = Profile.list([sort:"user.topCoderScore",order:"desc", max:limit])
        return list

    }

    /**
     * Retorna uma lista de usuários de acordo com a posição no topcoder
     * @params:limit Número de usuários que a lista deve retornar
     * @params:groupId id do grupo
     * @return: ArrayList<Profile>
     */
    def getTopCoderGroupList(groupId, limit){
        def list = Profile.findAllByUserInList(ClusterPermissions.findAllByGroupAndPermission(Cluster.get(groupId),0).user,[sort:"user.topCoderScore", order:"desc", max:limit])
        return list
    }

}
