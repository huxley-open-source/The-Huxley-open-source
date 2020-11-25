import com.thehuxley.License
import com.thehuxley.LicenseType
import com.thehuxley.ShiroUser
import grails.test.GrailsUnitTestCase
import grails.test.mixin.TestFor
import groovy.mock.interceptor.MockFor
import org.apache.catalina.User

class LicenseTests extends GrailsUnitTestCase{
    void testMock(){
        def mockCtrl = mockFor(License)
        mockCtrl.demand.isAdminInst(1..1) {->true}

        def licenseMock = mockCtrl.createMock()

        assertTrue(licenseMock.isAdminInst())
    }

    void testMetaClass(){

        //License.metaClass.user.id = 53
//        License.metaClass.getUser.getId = {->53}
        ShiroUser.metaClass.id = 53
        ShiroUser.metaClass.getId = {->53}
//        def user =
        def license = new License(user:new ShiroUser())
//        license.user = user

        assertEquals(53,license.user.id)
        assertEquals(53,license.user.getId())
    }
}
