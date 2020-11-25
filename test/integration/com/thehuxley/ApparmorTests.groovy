package com.thehuxley

import org.apache.commons.fileupload.FileItem
import org.apache.commons.io.IOUtils
import org.codehaus.groovy.grails.plugins.testing.GrailsMockHttpServletRequest
import org.codehaus.groovy.grails.plugins.testing.GrailsMockMultipartFile
import org.springframework.core.io.ClassPathResource
import org.springframework.core.io.Resource
import org.springframework.mock.web.MockMultipartFile
import org.springframework.mock.web.MockMultipartHttpServletRequest
import org.springframework.transaction.annotation.Propagation
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.multipart.commons.CommonsMultipartFile

import javax.servlet.ServletInputStream

import static org.junit.Assert.assertNotNull

/**
 * Para rodar esses testes você precisa:
 * - Fila rodando (rabbitmq)
 * - Avaliador rodando
 * - Apparmor configurado
 */
class ApparmorTests extends GroovyTestCase{

    static transactional = false

    def sessionFactory

    SubmissionController sc
    def userId = 53
    def problemId = 2


    @Override
    void setUp() {
        sc = new SubmissionController()
        def ms = new MemcachedService()
        def ss = new SubmissionService()
        def ps = new ProblemService()

        ss.memcachedService = ms
        ss.problemService = ps

        sc.submissionService = ss

        def user = ShiroUser.get(userId)

        sc.session.license = new License(user:user)
        sc.session.profile = new Profile(user:user)

        assertNotNull(sessionFactory)
    }

    /**
     * Método auxiliar
     *
     * @param fileName
     * @return
     */
    private byte[] getFileContent(String fileName){
        Resource resource = new ClassPathResource("resources/"+fileName)
        FileInputStream fis = new FileInputStream(resource.getFile())
        assertNotNull(fis)
        return IOUtils.toByteArray(fis)
    }

    /**
     * Método Auxiliar
     * @return
     */
    private Submission doSubmission(String fileName) {
        sc.params.pid = problemId
        byte[] fileBytes = getFileContent(fileName)

        sc.params.qqfile = fileName
        sc.request.setContent(fileBytes)


        assertNotNull(sc.request.getInputStream())

        sc.save()

        def submissionId = new Long(sc.response.json.submission.id)
        assertNotNull(submissionId)

        int tries = 0

        Submission submission = Submission.get(submissionId)
        while (tries < 20 && submission.evaluation==EvaluationStatus.WAITING){
            // Esperando o avaliador
            println 'Waiting for submission: '+submissionId
            Thread.sleep(1000)
            submission = Submission.get(submissionId)
            /* É preciso chamar esse refresh, pois o avaliador muda a submissão e o hibernate não sabe disso.
            Se esse método não for chamado, o hibernate irá recuperar uma versão do cache da sessão e, portanto,
            o status da avaliaćão será o antigo.
             */
            sessionFactory.getCurrentSession().refresh(submission)
            tries ++
        }
        submission
    }

    void testCorrectC(){

        // Criar uma submissão em C com resposta correta
        // Colocar na fila
        // Colocar o avaliador pra rodar
        // Verificar se a resposta foi correta

        Submission submission = doSubmission('3numeros_correct.c')
        assertEquals(EvaluationStatus.CORRECT, submission.evaluation)
    }

    void testWrongAnswerC(){
        Submission submission = doSubmission('3numeros_wrong_answer.c')
        assertEquals(EvaluationStatus.WRONG_ANSWER, submission.evaluation)
    }

    void testCorrectPython(){
        Submission submission = doSubmission('3numeros_correct.c')
        assertEquals(EvaluationStatus.CORRECT, submission.evaluation)
    }

    void testWrongPython(){
        Submission submission = doSubmission('3numeros_wrong_answer.py')
        assertEquals(EvaluationStatus.WRONG_ANSWER, submission.evaluation)
    }


    void testCorrectJava(){
        Submission submission = doSubmission('tres_numeros_correct.java')
        println ("submission_id="+submission.id)
        assertEquals(EvaluationStatus.CORRECT, submission.evaluation)
    }

    void testWrongJava(){
        Submission submission = doSubmission('tres_numeros_wrong_answer.java')
        assertEquals(EvaluationStatus.WRONG_ANSWER, submission.evaluation)
    }

    void testCorrectOctave(){
        Submission submission = doSubmission('3numeros_correct.m')
        assertEquals(EvaluationStatus.CORRECT, submission.evaluation)
    }

    void testWrongOctave(){
        Submission submission = doSubmission('3numeros_wrong_answer.m')
        assertEquals(EvaluationStatus.WRONG_ANSWER, submission.evaluation)
    }

    void testCorrectCpp(){
        problemId = 15
        Submission submission = doSubmission('sejabemvindo_correct.cpp')
        assertEquals(EvaluationStatus.CORRECT, submission.evaluation)
    }

    void testWrongCpp(){
        problemId = 15
        Submission submission = doSubmission('sejabemvindo_wrong_answer.cpp')
        assertEquals(EvaluationStatus.WRONG_ANSWER, submission.evaluation)
    }

    void testCorrectPascal(){
        problemId = 15
        Submission submission = doSubmission('sejabemvindo_correct.pas')
        assertEquals(EvaluationStatus.CORRECT, submission.evaluation)
    }

    void testWrongPascal(){
        problemId = 15
        Submission submission = doSubmission('sejabemvindo_wrong_answer.pas')
        assertEquals(EvaluationStatus.WRONG_ANSWER, submission.evaluation)
    }

    /**
     Ele vai tentar acessar o diretório '/'
     Se conseguir, então ele vai imprimir uma resposta errada. Se ele não conseguir,15
     vai resolver o problema e imprimir a resposta correta.
     Espera-se que o apparmor esteja configurado e que ele não consiga acessar esse diretório.
     */
    void testPasswdAccess(){
        problemId = 15
        Submission submission = doSubmission('test_passwd.c')
        assertEquals(EvaluationStatus.CORRECT, submission.evaluation)
    }


    void testWriteAccess(){
        problemId = 15
        Submission submission = doSubmission('test_write_access.c')
        assertEquals(EvaluationStatus.CORRECT, submission.evaluation)
    }

    void testForkBombC(){
        problemId = 15
        Submission submission = doSubmission('fork_bomb.c')
        assertEquals(EvaluationStatus.TIME_LIMIT_EXCEEDED, submission.evaluation)
        // espera 45 segundos para que o kill_forks tenha matado o ataque
        sleep(5000)
    }

    void testForkBombPy(){
        problemId = 15
        Submission submission = doSubmission('fork_bomb.py')
        assertEquals(EvaluationStatus.RUNTIME_ERROR, submission.evaluation)
        sleep(5000)
    }

    void testForkBombJava(){
        problemId = 15
        Submission submission = doSubmission('ForkBomb.java')
        assertEquals(EvaluationStatus.EMPTY_ANSWER, submission.evaluation)
        sleep(5000)
    }

    void testOpenSocket(){
        Submission submission = doSubmission('open_socket.py')
        assertEquals(EvaluationStatus.RUNTIME_ERROR, submission.evaluation)
    }




}
