package com.thehuxley

import javax.servlet.http.HttpSession

import static org.junit.Assert.*
import org.junit.*

class ProblemControllerTests extends GroovyTestCase{

    ProblemController pc
    def userId = 53L

    void setUp() {
        pc = new ProblemController()
        pc.problemService = new ProblemService()
        pc.submissionService = new SubmissionService()
        def ms = new MemcachedService()
        pc.problemService.memcachedService = ms


        def user = new ShiroUser()
        user.setId(userId)
        assertNotNull(pc.session)

        pc.session.license = new License(user:user)
        pc.session.profile = new Profile(user:user)
    }

    void testS() {
        pc.s()
        assertEquals(20, pc.response.json.size())
    }

    void testGetTip() {

        assertNotNull(pc.session.license)
        assertEquals(userId, pc.session.license.user.id)
        assertEquals(userId, pc.session.license.user.getId())
        pc.params.sId = 3940 //submissão do usuário paes. Problema: matrizes

        pc.getTip()
        assertEquals(3940,pc.response.json.id)
        assertEquals(1436,pc.response.json.tip)
        assertNotNull(pc.response.json.evaluation)
    }

    void testGetProblemContent(){
        // id do problema
        pc.params.id = 31L;

        assertNotNull(pc.session.profile.user.id)

        pc.getProblemContent()

        assertNotNull(pc.response.json.p)
        def problem = pc.response.json.p
        assertEquals(31,problem.id)
        assertTrue( problem.topics.size()>0)

    }
}
