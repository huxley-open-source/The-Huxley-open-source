package com.thehuxley


class ReportJob {
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
        cron name: 'huxleyReportJob', cronExpression: "0 0 7 ? * 6"
    }

    def reportService

    def execute() {
        log.info("Gerando Reports")
        reportService.sendReports()
    }
}
