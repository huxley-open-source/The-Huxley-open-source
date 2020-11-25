import grails.test.GrailsUnitTestCase

/**
 * Created by romero on 16/07/14.
 */
class HuxleyLogTests extends GrailsUnitTestCase {
    /*
        Testa a existência do diretório de log e se é possível criar o arquivo de log
     */
    void testLogCreation() {
        File logDirectory = new File("/home/huxley/data/log/")
        assertTrue(logDirectory.exists())
        assertTrue(logDirectory.canWrite())
    }


}
