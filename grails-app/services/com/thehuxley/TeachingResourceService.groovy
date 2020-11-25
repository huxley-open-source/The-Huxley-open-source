package com.thehuxley

class TeachingResourceService {

    def contentService
    def problemService

    def changeStatusToComplete = {id, user  ->
        def teachingResource = TeachingResources.get(id)

        if (teachingResource.content) {
            contentService.changeStatus(teachingResource.content, user, ContentUser.COMPLETED)
        }
    }
}
