import com.thehuxley.EvaluationStatus
import grails.test.mixin.TestFor

class EvaluationStatusTests {
    void testCreation(){
        assertNotNull(EvaluationStatus.CORRECT)
        assertEquals(EvaluationStatus.WRONG_ANSWER,1)
    }
}
