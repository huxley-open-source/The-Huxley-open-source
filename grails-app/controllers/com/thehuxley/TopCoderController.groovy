package com.thehuxley

class TopCoderController {

    def topCoderService

    def getTopCoders() {
        def list = topCoderService.getTopCoderGeneralList(params.limit)

        render(contentType: "text/json") {
            array {
                list.each {
                    topcoders name: it.name, photo: it.photo, smallPhoto: it.smallPhoto, institution: it.institution.name, hid: it.hash, score: it.user.topCoderScore, position: it.user.topCoderPosition
                }
            }
        }

    }

    def generateTopCoder = {
        TopCoder.generateList()
        redirect(controller: 'home',action:'index',params: [sMsg:'Generated'])
    }

}
