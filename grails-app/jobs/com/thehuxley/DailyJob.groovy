package com.thehuxley

class DailyJob {
    //    def timeout = 24*60*60*1000l // execute job once in 24 hours
    /*
     * cronExpression:  "s m h D M W Y"
                         | | | | | | `- Year [optional]
                         | | | | | `- Day of Week, 1-7 or SUN-SAT, ?
                         | | | | `- Month, 1-12 or JAN-DEC
                         | | | `- Day of Month, 1-31, ?
                         | | `- Hour, 0-23
                         | `- Minute, 0-59
                         `- Second, 0-59
     */

    static triggers = {
        cron name: 'huxleyDailyJob', cronExpression: "0 0 3 ? * *"
    }
    def problemService
    def mongoService
    def execute() {
        log.info("Calculando ND")
        Problem.calculateNd()
        log.info("Gerando Topcoder")
        TopCoder.generateList()
        log.info("Salvando evolução de usuarios")
        UserEvolution.generateList()

        // TODO Colocar aqui a mensagem para o plagio iniciar

        EmailToSend emailToSend = new EmailToSend()
        emailToSend.email = "support@thehuxley.com"
        def date = new Date(System.currentTimeMillis());
        emailToSend.message = "ND Calculado, Topcoder gerado e plágio verificado. " + date
        emailToSend.status = "TOSEND"
        emailToSend.save()
        mongoService.generateQuestionnairePlagiumList()
        //mongoService.runStimulusPredicator()
        problemService.sendEmailtoUser()
    }
}
