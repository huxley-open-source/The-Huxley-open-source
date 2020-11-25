package com.thehuxley

/**
 * Created by rodrigo on 15/07/14.
 */
class SubmissionTests extends GroovyTestCase{

    /**
     * Se der erro nesse teste e o erro for:
     * Null value was assigned to a property of primitive type setter of com.thehuxley.Submission.plagiumStatus
     *
     * Então você ainda não rodou o script de migraćão e o banco de dados possui algumas entradas com valores nulos
     * na coluna plagium_status
     *
     * Rode o migration.sql
     */
    void testSubmissionHibernateMapping(){
        String query = "SELECT Distinct s FROM Submission s order by s.submissionDate desc"
        def max = 10
        def offset = 0
        def submissionList = Submission.executeQuery(query, [max:max,offset:offset])
        assertEquals(max,submissionList.size())
    }
}
