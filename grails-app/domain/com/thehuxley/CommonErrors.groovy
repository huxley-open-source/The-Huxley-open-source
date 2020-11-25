package com.thehuxley

class CommonErrors {
    String errorMsg
    String comment

    static constraints = {
        errorMsg (nullable: false, blank: false)
        comment (nullable: false, blank: false)
    }
    static mapping = {
        errorMsg type: 'text'
        comment type: 'text'
    }
}
