package com.thehuxley

class PaymentController {

    def paymentService
    def licensePackService

    def confirm =  {}

    def success = {
        def lastPayment = paymentService.getLastPayment(session.profile)
        [payment: lastPayment]
    }

    def checkout = {

        def valid = true
        def frequency = request.JSON.getAt('frequency') as Integer
        def amount = 0.0
        def quantity = request.JSON.getAt('quantity') as Integer
        def couponHash = request.JSON.getAt('hash') as String

        if (frequency == Payment.FREQUENCY_MONTHLY) {
            amount = 11.60
        } else if (frequency == Payment.FREQUENCY_SEMIANNUAL) {
            amount = 10.80
        } else if (frequency == Payment.FREQUENCY_ANNUAL) {
            amount = 9.90
        } else {
            valid = false
        }

        if (valid) {
            render (contentType: "application/json") {paymentService.checkout(session.profile, session.license.institution, frequency, amount , quantity, couponHash)}
        } else {
            render (contentType: "application/json", status: 400) {[code: 400, message: "Bad request"]}
        }
    }

    def couponList = {
        def list = PaymentCoupon.findAll()
        render (contentType: "application/json") {list}
    }

    def coupon = {
        def coupon = new PaymentCoupon()
        coupon.status = PaymentCoupon.VALID
        coupon.discount = request.JSON.getAt('discount') as Double
        render (contentType: "application/json") {
            coupon.save()
        }
    }

    def cancelCoupon = {
        def coupon = PaymentCoupon.findByHash(request.JSON.getAt('hash'))
        coupon.status = PaymentCoupon.CANCELED;
        render (contentType: "application/json") {
            coupon.save()
        }
    }

    def createLicensePack () {
        def total = request.JSON.getAt('total');
        def frequency = request.JSON.getAt('frequency');

        render (contentType: 'application/json') {
            licensePackService.create(total, session.license.institution, frequency)
        }
    }

    def listLicensePack() {
        render (contentType: 'application/json') {
            LicensePack.findAll()
        }
    }

    def checkCoupon = {
        def coupon = PaymentCoupon.findByHash(request.JSON.getAt('coupon'))

        if (coupon) {
            render (contentType: "application/json") {
                [status: coupon.status, discount: coupon.discount]
            }
        } else {
            render (contentType: "application/json", status: 404) {
                [code: 404, status: 'NOT_FOUND']
            }
        }

    }
}
