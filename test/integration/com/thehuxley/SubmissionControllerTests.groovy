package com.thehuxley

import grails.test.GrailsUnitTestCase
import grails.test.mixin.Mock
import grails.test.mixin.TestFor

import static org.junit.Assert.*
import org.junit.*

class SubmissionControllerTests extends GroovyTestCase{

    def sc

    @Override
    void setUp() {
        sc = new SubmissionController()
        def ms = new MemcachedService()
        def ss = new SubmissionService()

        ss.memcachedService = ms
        sc.submissionService = ss
    }

    void testGetSubmissionInfoById() {
        sc.params.id=20000
        sc.getSubmissionInfoById()
        assertEquals('Sistema horário',sc.response.json.name)
        assertEquals(45,sc.response.json.pid)
    }

    void testGetSubmissionInfoByIdNull(){
        sc.getSubmissionInfoById()
        assertTrue(sc.response.json.isEmpty())
    }

    void testEmptySearch(){
        sc.params.max = '10'
        sc.params.order = 'desc'
        sc.params.sort = 's.submissionDate'
        sc.params.group = '0'
        sc.params.listBy = 'group'
        sc.params.evaluation = '0'

        License.metaClass.isAdminInst = {->true}
        License.metaClass.isStudent = {->false}
        License.metaClass.isTeacher = {->false}

        def inst = new Institution()
        inst.setId(1)
        def license = new License(institution:inst)
        sc.session.license = license
        assertNotNull(sc.session.license.institution)
        assertEquals(1,sc.session.license.institution.id)

        sc.search()
        assertEquals(10, sc.response.json.submissions.size())

    }
}
