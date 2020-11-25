package com.thehuxley

import java.io.Serializable;
import java.util.Date
import java.security.MessageDigest;

class License implements Serializable{

	Date startDate
	Date endDate
	LicenseType type
    boolean active
    boolean indefiniteValidity
    Date dateCreated
    Date lastUpdated
	Institution institution
	ShiroUser user
    String hash

    static mapping = {
        type lazy: false
        institution lazy: false
    }

    static constraints = {
        institution nullable: true, blank: false
        user nullable: true, blank: false
        hash nullable: false, blank: false, unique: true
    }

    static hasMany = [historyLicenses: HistoryLicense]
    static mappedBy = [historyLicenses: 'license']

    def beforeValidate() {
        MessageDigest md = MessageDigest.getInstance("MD5")
        BigInteger generatedHash = new BigInteger(1, md.digest((System.nanoTime().toString()).getBytes()))
        hash = generatedHash.toString(16)
    }

    def afterInsert = {
        def historyLicense = new HistoryLicense()
        historyLicense.license = this
        if (user) {
            historyLicense.user = user
            if (institution) {
                historyLicense.institution = institution
            }

            historyLicense.startDate = new Date()
        }

        historyLicense.save()
    }

    def afterUpdate = {
        if (it && it.id) {
            def historyLicense = HistoryLicense.findByLicenseAndEndDateIsNull(it)
            if (historyLicense) { 
                if ((!historyLicense.user && user)
                        || (historyLicense.user.id != user.id)
                        || (historyLicense.user && !user)
                        || (!historyLicense.institution && institution)
                        || (historyLicense.institution && !institution)
                        || (historyLicense.institution.id != institution.id)) {
                    historyLicense.endDate = new Date()
                    historyLicense.save()

                    historyLicense = new HistoryLicense()
                    historyLicense.license = this
                    if (user) {
                        historyLicense.user = user
                        if (institution) {
                            historyLicense.institution = institution
                        }

                        historyLicense.startDate = new Date()
                    }

                    historyLicense.save()
                }
            }
        }
    }

    public boolean isAdmin(){
        return this.type.kind.equals(LicenseType.ADMIN)
    }
    public boolean isSystem(){
        return this.type.kind.equals(LicenseType.SYSTEM)
    }
    public boolean isAdminInst(){
        return this.type.kind.equals(LicenseType.ADMIN_INST)
    }
    public boolean isTeacher(){
        return this.type.kind.equals(LicenseType.TEACHER)
    }
    public boolean isTeacherAssistant(){
        return this.type.kind.equals(LicenseType.TEACHER_ASSISTANT)
    }
    public boolean isStudent(){
        return this.type.kind.equals(LicenseType.STUDENT)
    }

}
