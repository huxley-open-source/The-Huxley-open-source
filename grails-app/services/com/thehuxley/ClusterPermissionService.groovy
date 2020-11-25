package com.thehuxley

class ClusterPermissionService {

    def publicFields(ClusterPermissions clusterPermissions) {

        def profile = Profile.findByUser(clusterPermissions.user)
        def profileList = []

        def clusterPermissionList = [
                permission: clusterPermissions.permission
        ]

        if (profile) {

            if (profile.institution){
                profileList = [
                        name: profile.name,
                        id: profile.hash,
                        smallPhoto: profile.smallPhoto,
                        topCoderPosition: profile.user.topCoderPosition,
                        topCoderScore: profile.user.topCoderScore,
                        institution: [id: profile.institution.id, name: profile.institution.name]]
            } else {
                profileList = [
                        name: profile.name,
                        id: profile.hash,
                        smallPhoto: profile.smallPhoto,
                        topCoderPosition: profile.user.topCoderPosition,
                        topCoderScore: profile.user.topCoderScore,
                        institution: [id: 0, name: "Sem instituição"]]
            }


        }


        clusterPermissionList + profileList

    }

    def publicFields(List<ClusterPermissions> clusterPermissionsList) {

        def result = []

        clusterPermissionsList.each {
             result.add(publicFields(it))
        }

        result
    }
}
