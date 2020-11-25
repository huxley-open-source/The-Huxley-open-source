package com.thehuxley

import org.apache.commons.logging.LogFactory

import java.text.Normalizer;
import java.util.Map;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger
import com.thehuxley.util.HuxleyProperties;



class Submission implements Serializable {


	public static final String PARAMS_USER_NAME = "USER_NAME"
	public static final String PARAMS_PROBLEM_NAME = "PROBLEM_NAME"
	public static final String PARAMS_BEGIN_DATE = "BEGIN_DATE"
	public static final String PARAMS_END_DATE = "END_DATE"
	public static final String PARAMS_USER_ID = "USER_ID"
	public static final String PARAMS_GROUP_ID = "GROUP_ID"
	public static final String PARAMS_INSTITUTION_ID = "INST_ID"
    public static final String PARAMS_PROBLEM_ID = "PROBLEM_ID"
    public static final String PARAMS_EVALUATION = "EVALUATION"
	public static final String FILTER_SUBMISSION_LIST = "PROBLEM_LIST"
	public static final String FILTER_SIZE = "SIZE"

	/**
	 * O plágio ainda não foi verificado para a submissão
	 */
	public static final int PLAGIUM_STATUS_WAITING = 1;
	/**
	 * O plágio já rodou e foi encontrado
	 */
	public static final int PLAGIUM_STATUS_MATCHED = 2;
	/**
	 * O plágio já rodou e não foi encontrado
	 */
	public static final int PLAGIUM_STATUS_NOT_MATCHED = 3;
	/**
	 * O plágio já rodou, indicou o plágio e o professor deliberadamente alterou o status da submissão indicando que NÃO é plágio
	 */
	public static final int PLAGIUM_STATUS_TEACHER_CLEAN = 4;
	/**
	 * O plágio já rodou, indicou o plágio e o professor deliberadamente alterou o status da submissão indicando que é um plágio. 
	 */
	public static final int PLAGIUM_STATUS_TEACHER_PLAGIUM = 5;

	ShiroUser user
	Problem problem
	Language language
	double time

	// true caso essa submissão esteja errada no caso de exemplo
	boolean detailedLog

	int tries = 0
	//Arquivo com resultado da diferenca entre os arquivos
	String diffFile
	
	/**
	 * Em casos onde a resposta é wrong_answer ou presentation_error,
	 * esse atributo armazenará o caso de teste que originou a saída errada.
	 */
	String inputTestCase
	
	//Arquivo de Submissao
	String submission
	//Arquivo de avaliacao
	String output
    //Mensagem de erro
    String errorMsg
	//Data de submissao
	Date submissionDate

	byte evaluation = EvaluationStatus.WAITING

    TestCase testCase

	/**
	 * Os valores podem ser:
	 * 1- Waiting
	 */
	int plagiumStatus

    //Cache
    String cacheUserUsername
    String cacheUserName
    String cacheUserEmail
    String cacheProblemName
    String comment

	static constraints = {  
		submission(blank:false)
		inputTestCase(nullable:true)
        testCase(nullable: true)
        errorMsg(nullable:true)
        comment(nullable:true)
	}
	static mapping = {
		inputTestCase (type:"text")
        errorMsg (type:"text")
        comment (type:"text")
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((submission == null) ? 0 : submission.hashCode());
		return result;
	}

	public String getSubmission(){
		return this.submission
	}
	public Problem getProblem(){
		return this.problem
	}
	public String getDiffFile(){
		return diffFile
	}
	public String getOutput(){
		return this.output
	}

    boolean isWrongAnswer(){
        evaluation == EvaluationStatus.WRONG_ANSWER
    }

    boolean isCorrect(){
        evaluation == EvaluationStatus.CORRECT
    }

    boolean isPresentationError(){
        evaluation == EvaluationStatus.PRESENTATION_ERROR
    }

    boolean isCompilationError() {
        evaluation == EvaluationStatus.COMPILATION_ERROR
    }

    boolean isEmptyAnswer() {
        evaluation == EvaluationStatus.EMPTY_ANSWER
    }

    boolean isRuntimeError() {
        evaluation == EvaluationStatus.RUNTIME_ERROR
    }

    boolean isTimeLimitExceeded() {
        evaluation == EvaluationStatus.TIME_LIMIT_EXCEEDED
    }

    boolean isHuxleyError() {
        (evaluation == EvaluationStatus.HUXLEY_ERROR ) || (evaluation == EvaluationStatus.WRONG_FILE_NAME)
    }

    /*
    TODO retornar nulo e colocar essa mensagem de retorno como responsabilidade do controle ou da view

    * */
	public def getDiff(){
		String lineSeparator = System.getProperty("line.separator")
		def submissionDiff = ""
		if(this.isWrongAnswer() ||this.isPresentationError()) {
            try{
                File diffFile = new File(mountSubmissionRoot()+this.diffFile)
                BufferedReader reader = new BufferedReader(new FileReader(diffFile))
                String line = ""
                while((line = reader.readLine()) != null) {
                    submissionDiff += line + lineSeparator
                }
            }catch (e){
                submissionDiff = 'Arquivo de diferenças não encontrado, por favor reavalie a submissão'
                log.warn('Se aconteceu esse erro, então provavelmente o diffcomparator do avaliador não ' +
                        'está gerando o arquivo .diff. Uma possibilidade é o comando diff2html não estar ' +
                        'corretamente configurado',e)
            }

		}
		if(this.isCorrect() ) {
			submissionDiff = "A submissão está correta"
		}

		return submissionDiff
	}


	public File downloadLastSubmission(){
		File file = null;
		try{
			file = new File(mountSubmissionRoot()+this.submission)
		}catch (e){
			log.error(e.getMessage(),e)
		}
		return file
	}
	public String generateName(){
		String name = this.problem.name
		String extension = this.language.extension
		return name+extension
	}

	/**
	 * Esse método só deve ser chamado pelo algoritmo de plágio.
	 * Ele indica que foi encontrada uma suspeita de plágio.
	 */
	public void plagiumMatched(){
		if (!(  (plagiumStatus==PLAGIUM_STATUS_TEACHER_CLEAN) || (plagiumStatus==PLAGIUM_STATUS_TEACHER_PLAGIUM) || (plagiumStatus==PLAGIUM_STATUS_MATCHED))){
			plagiumStatus = PLAGIUM_STATUS_MATCHED;
            UserProblem.findByUserAndProblem(user,problem).updateSimilarityStatusBySystem(UserProblem.SIMILARITY_STATUS_MATCHED)
		}
	}

	/**
	 * Esse método é chamado pelo CPDAdapter ao terminar de avaliar os plágios.
	 * As submissões que permanecerem como WAITING são as que não foram alvo de plágio.
	 * Portanto, como o plágio já rodou, precisamos atualizar o status de todas essas
	 * submissões.
	 */
	public static void markAllAsNotMatched(){
		try{
			Submission.executeUpdate("update Submission s set s.plagiumStatus=? where s.plagiumStatus=?",[PLAGIUM_STATUS_NOT_MATCHED,PLAGIUM_STATUS_WAITING])
		}catch(Exception e){
            LogFactory.getLog(this).error(e.getMessage(),e)
		}
	}

	/**
	 * Esse método é chamado pelo controlador do problema e retorna a contagem total de submissões e a contagem de submissões corretas
	 * @param problemId - id do problema
	 * @return submissionCountList[0] Submissões, submissionCountList[1] Submissões Corretas
	 */

	public static int[] scoreAllByProblemGroupByUser(long problemId){
		String query = "SELECT (SELECT count(DISTINCT user.id) FROM Submission where problem.id = ? ), (SELECT count(DISTINCT user.id) FROM Submission where" +
				" evaluation = ? and problem.id = ? ) from Submission"
		def countList = Submission.executeQuery(query,[problemId, EvaluationStatus.CORRECT, problemId],[max:1])
		int[] submissionCountList = [
			countList[0][0],
			countList[0][1]
		]
		return submissionCountList
	}

	private String mountSubmissionRoot(){
		return HuxleyProperties.getInstance().get ("problemdb.dir")+ this.problem.id+System.getProperty("file.separator")+this.user.id+System.getProperty("file.separator")+this.language.name+System.getProperty("file.separator")+this.tries+System.getProperty("file.separator");
	}
	public String mountSubmissionPath(){
		return this.problem.id+System.getProperty("file.separator")+this.user.id+System.getProperty("file.separator")+this.language.name+System.getProperty("file.separator")+this.tries+System.getProperty("file.separator");
	}
	public String downloadCode(){
		String code = ""
        try
        {
            File file = downloadLastSubmission()
            if(file.exists()) {
                BufferedReader br = new BufferedReader(new FileReader(file));

                while ( br.ready() ) {
                    code +=  br.readLine()+ '\n';
                }
            }

        }
        catch (FileNotFoundException e)
        {
            log.error(e.getMessage(),e)
        }
        return code
	}

    public void markAsPlag(){
        plagiumStatus = Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM
        UserProblem.findByUserAndProblem(user,problem).updateSimilarityStatusBySystem(UserProblem.SIMILARITY_STATUS_TEACHER_PLAGIUM)
    }

    public void markAsNotPlag(){
        plagiumStatus = Submission.PLAGIUM_STATUS_TEACHER_CLEAN
        save(flush:true)
        UserProblem.findByUserAndProblem(user,problem).updateSimilarityStatusBySystem(UserProblem.SIMILARITY_STATUS_NOT_MATCHED)
    }

    public void markAllAsNotPlag(){
        Submission.findAllByProblemAndUser(this.problem, this.user).each{ submission ->
            submission.plagiumStatus = Submission.PLAGIUM_STATUS_TEACHER_CLEAN
            submission.save(flush:true)
        }

        UserProblem.findByUserAndProblem(user,problem).updateSimilarityStatusBySystem(UserProblem.SIMILARITY_STATUS_NOT_MATCHED)
    }


    @Override
    public String toString() {
        return "Submission{" +
                "id=" + id +
                '}';
    }
}