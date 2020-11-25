package com.thehuxley

import groovy.time.TimeCategory

class LicensePackService {

    def memcachedService

    def create(total, institution, frequency) {

        def startDate = new Date(System.currentTimeMillis())
        def endDate

        use(TimeCategory) {
            endDate = startDate + frequency.month + 10.day
        }

        LicensePack licensePack = new LicensePack(total: total, institution: institution, startDate: startDate, endDate: endDate)
        licensePack.save();


        memcachedService.delete("packinfo-params:${institution.id}")

        licensePack
    }

}
