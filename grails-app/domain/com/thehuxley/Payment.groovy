package com.thehuxley

class Payment implements Serializable {

    static final FREQUENCY_MONTHLY = 1
    static final FREQUENCY_SEMIANNUAL = 6
    static final FREQUENCY_ANNUAL = 12

    static final STATUS_APPROVED = "approved" //O pagamento foi aprovado e creditado.
    static final STATUS_PENDING = "pending" //O usuário não concluiu o processo de pagamento.
    static final STATUS_IN_PROCESS = "in_process" //O pagamento está sendo analisado.
    static final STATUS_REJECTED = "rejected" //O pagamento foi recusado. O usuário pode tentar novamente.
    static final STATUS_REFUNDED = "refunded" //O pagamento foi devolvido ao usuário.
    static final STATUS_CANCELLED = "cancelled" //O pagamento foi cancelado por superar o tempo necessário para ser efetuado ou por alguma das partes.
    static final STATUS_IN_MEDIATION = "in_mediation" //Foi iniciada uma disputa para o pagamento.

    Profile profile
    Integer frequency
    Double amount
    Integer quantity
    PaymentCoupon paymentCoupon
    Double total
    String status
    String response
    Date dateCreated
    Date lastUpdated
    String url

    static constraints = {
        profile nullable: false
        paymentCoupon nullable: true
        response nullable: true
        frequency nullable: true
        amount nullable: true
        quantity nullable: true
        total nullable: true
        status nullable: true
        response nullable: true
    }

    static mapping = {
        response type: 'text'
    }
}
