package com.thehuxley.cpd;

import com.thehuxley.util.HuxleyProperties;

import net.sourceforge.pmd.cpd.TokenEntry;
import net.sourceforge.pmd.cpd.Language;
import net.sourceforge.pmd.cpd.LanguageFactory;
import net.sourceforge.pmd.cpd.Match;

import com.thehuxley.CPDQueue;
import com.thehuxley.Fragment;
import com.thehuxley.Plagium;
import com.thehuxley.Submission;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.logging.Log;

import com.thehuxley.HuxleyException;
import com.thehuxley.cpd.CPDResult;
import com.thehuxley.cpd.MyCPD
import com.thehuxley.UserProblem;

/**
 *
 * @author rodrigo
 */
public class CPDAdapter {

	private final int MINIMUM_TOKENS = 25;
	private final double SIMILARITY_THRESHOLD;

	private final String SUBMISSION_DIR;

	private static final Log log = LogFactory.getLog(CPDAdapter.class);

	public CPDAdapter(String submissionDir){
		SUBMISSION_DIR = submissionDir;
		SIMILARITY_THRESHOLD =  Double.parseDouble(HuxleyProperties.getInstance().get("similarity.threshold"));
	}

	public void verify(){
        log.info("CPDQUEUE.size()="+CPDQueue.list().size())
		CPDQueue.list().each{ element ->
			log.info("Verificando plágios do problema: "+element.getProblemId());
			try{
				Map<String, List<CPDResult>> results = verifyPlagiarizedSubmissions (element.problemId, element.language)
				// guarda os resultados no banco e marca cada submissão como suspeita, para aumentar a velocidade da view
				savePlagiums (results)
			}catch(Exception e){
				log.error("Erro ao verificar o plagio do problema "+element.getProblemId()+", linguagem: "+element.getLanguage()+" .  "+e.getMessage())
			}finally{
				try{
					element.delete(flush:true);
				}catch(Exception e){
					log.error(e.getMessage());
				}
			}
            Thread.sleep(2000);
		}
		//CPDQueue.deleteAll();
		Submission.markAllAsNotMatched();
	}


	/**
	 * idDoProblem/idDoUsuario/Linguagem/tentativa
	 * @param problemDir
	 */
	public Map<String, List<CPDResult>>  verifyPlagiarizedSubmissions(int problemId, String language) throws FileNotFoundException {
		ArrayList<File> includedDirs = new ArrayList<File>();
		File problemDir = new File(SUBMISSION_DIR,Integer.toString(problemId));
		if (!problemDir.exists()) {
			throw new FileNotFoundException("A pasta de submissões não foi encontrada. A procura foi realizada em:"
			+ problemDir.getAbsolutePath());
		}

		String[] users = problemDir.list();
		for (int i = 0; i < users.length; i++) {
			String userDir = users[i];
			File fUserDir = new File(problemDir, userDir);
			if (fUserDir.isDirectory()){
				String[] userLanguages = fUserDir.list();
				for (int j = 0; j < userLanguages.length; j++) {
					String userLanguage = userLanguages[j];
					if (language.equals(userLanguage)) {
						File fUserLanguage = new File(fUserDir, userLanguage);
						includedDirs.add(fUserLanguage);
					}
				}
			}
		}
		return filter(verifyPlagiarizedSubmissions(includedDirs));
	}

	/**
	 * O CPD retorna todos os plágios, inclusive ele considera plágios de um mesmo usuário.
	 * Logo, é preciso eliminar os plágios que forem entre o mesmo usuário.
	 * 
	 * O Retorno é um map. Cada entrada do map contém uma lista de CPDresult. Essa lista já está agrupada por
	 * plágios entre arquivos de diferentes usuários. Note que 02 arquivos podem conter várias seções de plágio.
	 *
	 * @param verifyPlagiarizedSubmissions
	 * @return
	 */
	private Map<String, List<CPDResult>> filter(List<CPDResult> allResults) {
		int allResultsSize = allResults.size();
		Map<String, List<CPDResult>> plagMap = new HashedMap<String, List<CPDResult>>(1 > allResultsSize ? 1 : allResultsSize);

		for (CPDResult cpdResult : allResults) {
			//Ver a documentação do cpdResult. 2, significa mesmo usuário.
			if (!cpdResult.hasSameRoot(CPDResult.ROOT_LEVEL_USER)){
				String ordered = cpdResult.getFileName1()+"&"+cpdResult.getFileName2();
				String invOrdered = cpdResult.getFileName2()+"&"+cpdResult.getFileName1();
				String

				List <CPDResult> fragments = null;
				fragments = plagMap.get (ordered);

				if (fragments == null){
					fragments = plagMap.get (invOrdered);
				}

				if (fragments==null){
					// primeira vez
					ArrayList<CPDResult> arrayList = new ArrayList<CPDResult>();
					arrayList.add (cpdResult);
					plagMap.put(ordered,arrayList);
				}else{
					// já veio da hash, então não precisa adicionar de novo na hash (objetos são passados por referência)
					fragments.add(cpdResult);
				}
			}
		}

		return plagMap;
	}

	public void savePlagiums(Map<String, List<CPDResult>> plagMap){
		plagMap.keySet().each { key->
			List<CPDResult> cpdResults = plagMap.get (key);
			Plagium plagium = new Plagium();
			CPDResult first = cpdResults.get(0);
			try{
				Submission submission1 = Submission.getSubmissionFromUserIdProblemIdAttempts(first.getUserFromFile1(),first.getProblem(),first.getAttemptFromFile1());
				Submission submission2 = Submission.getSubmissionFromUserIdProblemIdAttempts(first.getUserFromFile2(),first.getProblem(),first.getAttemptFromFile2());

				// Só salva se forem ids diferentes.
				if (!submission1.id.equals(submission2.id)){

					plagium.setSubmission1 (submission1);
					plagium.setSubmission2 (submission2);
					plagium.setPercentage (0);

					double plagiumPercentage = 0;
					double cpdResultPercentage;
					for (CPDResult cpdResult : cpdResults) {
						Fragment frag = new Fragment();
						frag.setNumberOfLines (cpdResult.getLineCount() )
						cpdResultPercentage = cpdResult.getPercentage();
						frag.setPercentage( cpdResultPercentage );
						frag.setStartLine1( cpdResult.getFile1BeginLine() );
						frag.setStartLine2( cpdResult.getFile2BeginLine() );

						plagium.addToFragments(frag);
						plagiumPercentage+=cpdResultPercentage;
					}
					// Só salva se ultrapassar o threshould de similaridade
					if (plagiumPercentage >= SIMILARITY_THRESHOLD){
						// alterar o status da submissão para indicar que elas estão sob suspeita de plágio.
						submission1.plagiumMatched();
						submission2.plagiumMatched();

						plagium.setPercentage (plagiumPercentage);
						plagium.save(flush:true);
					}
				}
			}catch(HuxleyException e){
				log.error( e);
			}catch(Exception e){
				log.error(e);
			}
		}
	}


	/**
	 * Retorna uma lista de plágios encontrados. Caso ocorra algum erro ou nenhum plágio seja encontrado, a lista é retornada vazia
	 * @param fileDir
	 * @return
	 */
	private List<CPDResult> verifyPlagiarizedSubmissions(List<File> directories) {
		List<CPDResult> resultList = new ArrayList<CPDResult>(1000);

		try {
			LanguageFactory f = new LanguageFactory();
			Language language = f.createLanguage("cpp");

			MyCPD cpd = new MyCPD(MINIMUM_TOKENS, language);
			String encodingString = System.getProperty("file.encoding");

			cpd.setEncoding(encodingString);

			for (File directory : directories) {
				try{
					cpd.addRecursively(directory.getAbsolutePath());
				}catch(Exception e){
					log.error("Não foi possível verificar os plágios do diretório: "+directory.getName()+". Motivo:"+e.getMessage())
				}
			}

			cpd.go();
			Iterator<Match> matches = cpd.getMatches();
			String arquivo1 = null;
			String arquivo2 = null;
			int file1BeginLine;
			int file2BeginLine;
			int lineCount;
			while (matches.hasNext()) {
				Match m = matches.next();


				// Sempre um mach é entre dois arquivos (mark)
				arquivo1 = m.getFirstMark().getTokenSrcID();
				file1BeginLine = m.getFirstMark().getBeginLine();


				arquivo2 = m.getSecondMark().getTokenSrcID();
				file2BeginLine = m.getSecondMark().getBeginLine();

				lineCount = m.getLineCount();

				if (!arquivo1.equals(arquivo2)) {

					int numberOfTokens = cpd.getNumberOfTokens(arquivo1);
					CPDResult result = new CPDResult(arquivo1, cpd.getNumberOfTokens(arquivo1), arquivo2, cpd.getNumberOfTokens(arquivo2), m.getTokenCount(), file1BeginLine, file2BeginLine,lineCount )
					resultList.add(result);
				}
			}
		} catch (IOException ex) {
			log.error (ex);
		} catch (NoSuchElementException e) {
			log.error(e);
		} catch (OutOfMemoryError ofMemoryError){
			log.error (ofMemoryError);
		}
		return resultList;
	}
}