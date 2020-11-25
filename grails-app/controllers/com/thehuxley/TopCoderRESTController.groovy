package com.thehuxley

import grails.converters.JSON

class TopCoderRESTController {

    def topCoderService
    def profileService
    def memcachedService

    def show = {

        params.max = params.max as Integer
        def max = (params.max && params.max > 0 && params.max < 20) ? params.max : 10

        def result = memcachedService.get("topcoder-max-$max-group-$params.id", 3 * 60 * 60) {
            def topCoderList

            if (params.id) {
                def group = Cluster.findByHash(params.id)
                topCoderList = profileService.publicFields(topCoderService.getTopCoderGroupList(group.id, max))
            } else {
                topCoderList = profileService.publicFields(topCoderService.getTopCoderGeneralList(max))
            }

            (topCoderList as JSON) as String
        }


        render(contentType:"text/json") {
            JSON.parse(result)
        }
    }
}
