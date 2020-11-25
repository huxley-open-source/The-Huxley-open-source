package com.thehuxley

import java.security.MessageDigest

class PaymentCoupon {

    static final CANCELED = "CANCELED"
    static final VALID = "VALID"
    static final USED = "USERD"

    Double discount
    Date dateCreated
    Date lastUpdated
    String hash
    String status;

    static constraints = {
        hash nullable: false, unique: true
        status nullable: false, inList: [CANCELED, VALID, USED]
    }

    def beforeValidate() {
        MessageDigest md = MessageDigest.getInstance("MD5")
        BigInteger generatedHash = new BigInteger(1, md.digest((System.nanoTime().toString()).getBytes()))
        hash = generatedHash.toString(16).substring(0, 8)
    }

}
