package com.thehuxley

import grails.converters.JSON
import mercadopago.MP
import mercadopago.RestClient
import org.codehaus.jettison.json.JSONObject

class PaymentService {

    private MP mp = new MP('465319087942619', 'rAZVUKfrWyo9jWBSergHrkp08EgO89YG')
    def licensePackService

    def createPreApprovalPayment (preferences) {
        String accessToken;
        try {
            accessToken = mp.getAccessToken ()
        } catch (Exception e) {
            JSONObject result = new JSONObject(e.getMessage())
            return result
        }

        JSONObject preferenceResult = RestClient.post ("/preapproval?access_token="+accessToken, new JSONObject(preferences))
        return preferenceResult
    }

    def getPreApprovalPayment (id) {
        String accessToken;
        try {
            accessToken = mp.getAccessToken ()
        } catch (Exception e) {
            JSONObject result = new JSONObject(e.getMessage())
            return result
        }

        JSONObject preferenceResult = RestClient.get("/preapproval/"+id+"?access_token="+accessToken)
        return preferenceResult
    }

    def cancelPreApprovalPayment (id) {
        String accessToken;
        try {
            accessToken = mp.getAccessToken ()
        } catch (Exception e) {
            JSONObject result = new JSONObject(e.getMessage())
            return result
        }

        JSONObject preferenceResult = RestClient.put("/preapproval/"+id+"?access_token="+accessToken, '{"status": "cancelled"}')
        return preferenceResult
    }

    def monthlyPayment (email, value, id) {
        def preferences = [
            "payer_email": "${email}",
            "back_url": "http://www.thehuxley.com/huxley/payment/success",
            "reason": "Plano Mensal de pagamento do The Huxley.",
            "external_reference": "${id}",
            "auto_recurring": [
                "frequency": 1,
                "frequency_type": "months",
                "transaction_amount": value,
                "currency_id": "BRL"
            ]
        ]

        def result = createPreApprovalPayment((preferences as JSON).toString())
        return JSON.parse(result.toString())
    }

    def semiannualPayment (email, value, id) {
        def preferences = [
                "payer_email": "${email}",
                "back_url": "http://www.thehuxley.com/huxley/payment/success",
                "reason": "Plano Semestral de pagamento do The Huxley.",
                "external_reference": "${id}",
                "auto_recurring": [
                        "frequency": 6,
                        "frequency_type": "months",
                        "transaction_amount": value,
                        "currency_id": "BRL"
                ]
        ]

        def result = createPreApprovalPayment((preferences as JSON).toString())
        return JSON.parse(result.toString())
    }

    def getLastPayment(Profile profile) {
        return Payment.findByProfile(profile, [sort:"dateCreated", order:"desc"]);
    }

    def annualPayment (email, value, id) {
        def preferences = [
                "payer_email": "${email}",
                "back_url": "http://www.thehuxley.com/huxley/payment/success",
                "reason": "Plano Anual de pagamento do The Huxley.",
                "external_reference": "${id}",
                "auto_recurring": [
                        "frequency": 12,
                        "frequency_type": "months",
                        "transaction_amount": value,
                        "currency_id": "BRL"
                ]
        ]

        def result = createPreApprovalPayment((preferences as JSON).toString())
        return JSON.parse(result.toString())
    }

    def checkout (profile, institution, frequency, amount, quantity, couponHash) {

        PaymentCoupon coupon = null

        if (couponHash) {
            coupon = PaymentCoupon.findByHash(couponHash)
        }

        Payment payment = new Payment()
        payment.profile = profile


        def discount = 0
        def response

        if (coupon) {
            payment.paymentCoupon = coupon
            if (coupon.status == PaymentCoupon.VALID) {
                discount = coupon.discount / 100
            }
        }

        Double total = ((quantity * amount * frequency) - ((quantity * amount * frequency) * discount))

        total = total.round(2)

        payment.quantity = quantity
        payment.amount = amount
        payment.total = total

        payment.save()

        if (frequency == Payment.FREQUENCY_MONTHLY) {
            payment.frequency = Payment.FREQUENCY_MONTHLY
            response = monthlyPayment(profile.user.email, total, payment.id)
        } else if (frequency == Payment.FREQUENCY_SEMIANNUAL) {
            payment.frequency = Payment.FREQUENCY_SEMIANNUAL
            response = semiannualPayment(profile.user.email, total, payment.id)
        } else if (frequency == Payment.FREQUENCY_ANNUAL) {
            payment.frequency = Payment.FREQUENCY_ANNUAL
            response = annualPayment(profile.user.email, total, payment.id)
        }

        def json = JSON.parse(response.toString())

        payment.url = json.response.init_point

        payment.status = json.response.status


        payment.response = json
        payment.save()

        licensePackService.create(quantity, institution, frequency);

        return payment
    }
}
