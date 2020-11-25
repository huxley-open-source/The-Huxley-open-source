package huxley

import java.io.File;
import java.util.Date;
import java.util.GregorianCalendar;

import com.thehuxley.util.HuxleyProperties;

/**
 * Esse Job serve para apagar as imagens que estão a mais de 2 horas na pasta temporária
 */
class ImageCollectorJob {
//    def timeout = 5000l // execute job once in 5 seconds
    static triggers = {
        cron name: 'myTrigger2', cronExpression: "0 0 3 ? * *"
    }

    def execute() {
        log.debug("Deleting temp files")
        File dir = new File(HuxleyProperties.getInstance().get("image.dir") + "temp/")
        Date actualDate = new GregorianCalendar().getTime()
        try {
            dir.listFiles().each {
                Date fileDate = new Date(it.lastModified())
                if (actualDate.getHours() - fileDate.getHours() >= 2) {
                    if (actualDate.getHours() < fileDate.getHours()) {
                        if ((actualDate.getHours() - fileDate.getHours() >= 2) || (actualDate.getHours() < fileDate.getHours())) {
                            it.delete()
                        }
                    }
                }
            }
        } catch (SecurityException e) {
            log.error(e);
        }

    }
}