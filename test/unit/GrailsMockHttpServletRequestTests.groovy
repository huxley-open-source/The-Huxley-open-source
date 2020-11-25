import grails.test.GrailsUnitTestCase
import org.apache.commons.io.IOUtils
import org.codehaus.groovy.grails.plugins.testing.GrailsMockHttpServletRequest
import org.springframework.core.io.ClassPathResource
import org.springframework.core.io.Resource

/**
 * Created by rodrigo on 18/07/14.
 */
class GrailsMockHttpServletRequestTests extends GrailsUnitTestCase {

    void testMockInputStream(){
        def fileName = "3numeros_correct.c"
        Resource r = new ClassPathResource("resources/"+fileName)

        def fis =  new FileInputStream(r.getFile())
        byte[] fileBytes = IOUtils.toByteArray(fis)

        def request = new GrailsMockHttpServletRequest()
        request.setContent(fileBytes)
        assertNotNull(request.getInputStream())

    }
}
