package com.thehuxley

class ErrorsController {

    def final TO_MB = 1048576

    def emailService

    def notFound() {}

    def exception(){
        try{
            HuxleySystemFail fail  = new HuxleySystemFail()
            fail.loggedUser = session.profile.user
            fail.message = request.exception.message
            fail.stackTrace = request.exception.stackTraceText
            fail.timeOfError = new GregorianCalendar().getTime();
            fail.save()

            def lines = '<pre><ol>'
            def trace = '<pre><ol>' 
            def system = '<ul>'
            def fileSystem = ''

            request.exception.codeSnippet.each {
                lines = lines + '<li>' + it + '</li>'    
            }

            lines = lines + '</ol></pre>'

            request.exception.stackTraceLines.each {
                trace = trace + '<li>' +it + '</li>'     
            }

            trace = trace + '</ol></pre>'
            
            system = system + '<li>FREE MEMORY: ' + ((Runtime.getRuntime().freeMemory() /  TO_MB) as Integer) + ' MB</li>'
            system = system + '<li>MAX MEMORY: ' + ((Runtime.getRuntime().maxMemory() /  TO_MB) as Integer) +  ' MB</li>'
            system = system + '<li>TOTAL MEMORY: ' + ((Runtime.getRuntime().totalMemory()  /  TO_MB) as Integer) + ' MB</li>'

            File[] roots = File.listRoots()

            roots.each {
                fileSystem = fileSystem + '<br/><b>' + it.getAbsolutePath() + '</b><ul>'
                fileSystem = fileSystem + '<li>TOTAL SPACE: ' +  ((it.getTotalSpace() /  TO_MB) as Integer) + ' MB</li>'
                fileSystem = fileSystem + '<li>FREE SPACE: ' + ((it.getFreeSpace() /  TO_MB) as Integer) + ' MB</li>'
                fileSystem = fileSystem + '<li>USABLE SPACE: ' + ((it.getUsableSpace() /  TO_MB) as Integer) + ' MB</li>'

                fileSystem = fileSystem + '</ul>'
            }

            
            system = system + '</ul>' + fileSystem

            String msg = "<b>USER: </b> " + fail.loggedUser.name + 
            "<br/><b>USER ID: </b>" + session.profile.user.id +
			"<br/><b>LICENSE ID: </b>" + session.licence +
			"<br/><b>SESSION: </b>" + session +
            "<br/><b>DATE: </b>" + fail.timeOfError  + 
            "<br/><b>URL: </b>" + request.forwardURI +
            "<br/><b>USER-AGENT: </b>" + request.getHeader("User-Agent") +
            "<br/><b>PROTOCOL: </b>" + request.protocol +
            "<br/><b>REMOTE ADDRESS: </b>" + request.remoteAddr +
            "<br/><b>CHARACTER ENCODING: </b>" + request.characterEncoding+ 
            "<br/><b>METHOD: </b>" + request.method +
            "<br/><b>QUERY STRING: </b>" + request.queryString +
            "<br/><b>REQUEST URL: </b>" + request.requestURL +
            "<br/><b>IS REDIRECTED?: </b>" + request.isRedirected() +
            "<br/><b>JSON: </b>" + request.JSON +
            "<br/><b>LINE NUMBER: </b>" + request.exception.lineNumber +
            "<br/><b>LINES: </b>" + lines +
            "<br/><hr/><b>MESSAGE: </b>" + fail.message + 
            "<br/><b>STACKTRACE: </b>" + trace +
            "<br/><hr/><b>SYSTEM: </b>" + system


            if (EmailToSend.executeQuery("select count(e) from EmailToSend e where DATE(e.dateCreated) = DATE(:data) and (e.message like :bla and e.message like :blu)",[data: new GregorianCalendar().getTime(), bla: '%URL: </b>/huxley/problem/s%', blu: '%LINE NUMBER: </b>32%'])[0] == 0 ) {
                emailService.sendEmailWithText(msg, "support@thehuxley.com")
            }
        } catch (Throwable e){
            e.printStackTrace()
        }
    }
}
