package com.thehuxley

class HistoryLicense {

    ShiroUser user
    License license
    Institution institution
    Date startDate
    Date endDate
    Date dateCreated
    Date lastUpdated

    static constraints = {
        user nullable: true, lazy: false
        license nullable: true, lazy: false
        institution nullable: true, lazy: false
        startDate nullable: true
        endDate nullable: true
    }
}
