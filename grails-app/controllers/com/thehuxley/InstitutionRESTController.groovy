package com.thehuxley

class InstitutionRESTController {

    def institutionService

    def show() {
        render (contentType: 'application/json') {
            if (params.id) {
                institutionService.publicFields(Institution.get(params.id as Long))
            } else if (params.name) {
                institutionService.publicFields(Institution.findAllByStatusAndNameLike(Institution.STATUS_ACCEPTED, "%${params.name as String}%"))
            } else {
				institutionService.publicFields(Institution.findAllByStatus(Institution.STATUS_ACCEPTED))
			}
        }
    }
}
