package com.thehuxley

/**
 * Created by rodrigo on 11/07/14.
 */
class ProblemServiceTests  extends GroovyTestCase{
    def problemId = 31
    def userId = 53

    void testGetStatusLanguage(){
        def ps = new ProblemService()
        def result = ps.getStatusLanguage(Problem.get(problemId),ShiroUser.get(userId))
        println(result)
        assertNotNull(result)
        assertTrue(result.size()>0)

    }

}
