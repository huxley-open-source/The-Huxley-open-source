package com.thehuxley

import com.thehuxley.util.NDCalculator

import java.io.FileWriter
import java.util.ArrayList;
import java.util.List
import com.thehuxley.util.HuxleyProperties;


//import com.thehuxley.util.HuxleyProperties;
//import com.thehuxley.util.UtilFacade;
//
//import com.thehuxley.pdfviewer.ImageGenerator;

class Problem implements Comparable<Problem> , Serializable {
	
	//Indica fim de uma entrada para problemas de entradas m�ltiplas
	public static final String END_ENTRY = "#problem";
	
	public static final byte STATUS_WAITING = 1;
	public static final byte STATUS_ACCEPTED = 2;
	public static final byte STATUS_REJECTED = 3;
	public static final int INPUT_FILE = 1;
	public static final int OUTPUT_FILE = 2;
	public static final int EXAMPLE_INPUT_FILE = 3;
	public static final int EXAMPLE_OUTPUT_FILE = 4;
	public static final String FILTER_PROBLEM_LIST = "PROBLEM_LIST"
	public static final String FILTER_SIZE = "SIZE"
	public static final int LIMIT_ND = 10 
	
	//uma questao tem v�rios temas
	static hasMany = [topics : Topic, questionnaireProblem: QuestionnaireProblem, lessons: Lesson]
	//Os temas cont�m questoes, assim apagando todos os temas
	//apaga-se todas as questoes                
	static belongsTo = [Topic, Questionnaire, Lesson]
	//cada questao tem um nome �nico
	
	static mapping = {
		description type:"text"
		inputFormat type: "text"
		outputFormat type:"text"
        topics(lazy: false, cascade: 'merge, save-update, refresh')
	}
	
	
	//cada questao tem um nome �nico
	String name
	//nivel de dificuldade da questao 1 - 5
	int level
	
	int timeLimit
	//Define se haver�o mais de um teste durante a verifica��o
	double nd
	
	int evaluationDetail
	
	byte status
	
	ShiroUser userSuggest
	
	ShiroUser userApproved
	
	Submission fastestSubmision; 
	
	String description
	
	String inputFormat
	
	String outputFormat
	
	int code

    Date dateCreated;

    Date lastUpdated;

    String source

	static constraints = {
		name              (blank : false, unique : true)
		level             (range : 1..10)
		timeLimit         (blank : false)
		evaluationDetail  (range : 1..2, blank : false, nullable : false)
		code			  (blank:false, unique : true)
		userApproved	  (nullable: true)
		fastestSubmision (nullable:true)
		description (type:"text")
		inputFormat (type:"text")
		outputFormat (type:"text")
        source (nullable:true)
	}

    def afterUpdate = {
        Submission.executeUpdate("update Submission s set s.cacheProblemName = :name where s.problem.id = :id", [name: this.name, id: this.id])
    }

    public String toString() {
		return name
	}
	
	public int compareTo(Problem problem) {
		return name.compareTo(problem.name)
	}
	
	public List <Questionnaire> questionnaires() {
		String query = "SELECT q from Questionnaire q, QuestionnaireProblem qp where q.id = qp.questionnaire.id and qp.problem.id ='${this.id}'";
		List<Questionnaire> questionnaireList = Questionnaire.executeQuery(query)
		return questionnaireList
	}
	
	public synchronized static int generateCode(){		
		def query = "SELECT MAX(code) FROM Problem"
		List list = Problem.executeQuery(query)
		
		if(list.get(0)==null){
			
			return 1
		}else{
			
			return list.get(0) + 1
		}
	}
	/**
	 * Formula Original
	 * nd = 10 - 10 * ((proporção de acerto da questão/ max proporção de acerto de uma questão) * (tentativas na questão / max de tentativas de uma questão))
	 * Idealmente max proporção de acerto de uma questão ~1, tomando como =1
	 * nd = 10 - 10 * ((proporção de acerto da questão) * (tentativas na questão / max de tentativas de uma questão))
	 * proporção de acerto da questão= Número de Acertos / tentativas na questão
	 * nd = 10 - 10 * ((Número de Acertos / tentativas na questão) * (tentativas na questão / max de tentativas de uma questão))
	 * logo
	 * nd = 10 - 10 * ((Número de Acertos / 1) * (1 / max de tentativas de uma questão))
	 * nd = 10 - 10 * ((Número de Acertos / max de tentativas de uma questão))
	 * @param maxTries
	 */
	
	public void nd(double maxTries){
		int[] countProblem = Submission.scoreAllByProblemGroupByUser(this.id)
		double userSubmission = countProblem[0]
		double correctSubmission = countProblem[1]
		if(userSubmission <= LIMIT_ND){
			nd= level
		}else{
			nd= (10-((correctSubmission/maxTries)*10))
		}
	}
	public static double maxTries(){
		String query = "SELECT count(Distinct s.user.id) FROM Submission s group by s.problem.id"
		double max = 0;
		Problem.executeQuery(query).each{
			if(it>max){
				max = it
			}
		}
		return max
	}
	
	public ReferenceSolution getSolution(long language){
		ReferenceSolution solution = ReferenceSolution.findWhere(status: ReferenceSolution.STATUS_ACCEPTED, problem:this,language:Language.get(language))
			return solution
	}
	

	/*
	 public void generateScreenshot(){
	 try{
	 ImageGenerator ig = ImageGenerator.getInstance();
	 screenshot = ig.generate (mountProblemRoot());
	 save();
	 }catch (Exception e) {
	 log.error ("Problem " + this.name + " não gerou imagem",e);	
	 }
	 }
	 */
	public void accept(){
		status = Problem.STATUS_ACCEPTED
		save()
	}
	
	
	public void reject(){
		status = Problem.STATUS_REJECTED
		save()
	}
	/*
	 public static void generateAllImages(Map params){
	 int index = 0
	 if(params.id){
	 index = params.id
	 }
	 List<Problem> problemList = Problem.list()
	 problemList.each{
	 if(it.id >= index){
	 it.generateScreenshot()
	 }
	 }
	 }
	 public byte[] printDescription() {
	 if(!screenshot){
	 generateScreenshot()
	 }
	 return screenshot
	 }
	 */
	 public static void calculateNd(){
         def problemList = Problem.executeQuery("Select up.problem, count(Distinct up.user.id) from UserProblem up where up.problem.status = '" + Problem.STATUS_ACCEPTED + "' and up.status = '" + UserProblem.CORRECT + "' group by up.problem.id order by count(Distinct up.user.id)")
         def problemTries = Problem.executeQuery("Select up.problem, count(Distinct up.user.id) from UserProblem up where up.problem.status = '" + Problem.STATUS_ACCEPTED + "' group by up.problem.id order by count(Distinct up.user.id)")
         int[] userHits = new int[problemList.size()]
         problemList.eachWithIndex{ value,i ->
             userHits[i] = value[1]
         }
         NDCalculator calculateNd = new NDCalculator(userHits)
         calculateNd.calcular()
         def faixa = calculateNd.getFaixaAcertos()
         problemList.eachWithIndex{ problem,i ->
             int index = 0
             int nd = 10
             while( (index <10) && (faixa[index] < problem[1]) ){
                 index += 1
                 nd -= 1

             }
             if((index == 9) && !(faixa[index] < problem[1])){
                 log.info(problem[0].name + " ->" + problem[1] + " >= " + faixa[index] + " faixa")
             }
             if (problemTries[i][1] > 5){
                 problem[0].nd = nd
                 problem[0].save()
             }
         }
	 }
	
	/**
	* Esse método retorna o número máximo de submissões corretas para um problema qualquer
	* @return submissionCountList[0] Submissões, submissionCountList[1] Submissões Corretas
	*/
   
   public static int[] scoreAllByProblemGroupByUser(long problem){
	   String query = ""
	   return null
   }
	public void updateFiles(def request){
		String oldInput = mountInput()
		String oldOutput = mountOutput()
		def inputFile = request.getFile('input')
		if(!inputFile.getOriginalFilename().isEmpty()) {
			UtilFacade.getInstance().deleteFile(oldInput)
		}
		def outputFile = request.getFile('output')
		if(!outputFile.getOriginalFilename().isEmpty()) {
			UtilFacade.getInstance().deleteFile(oldOutput)
		}
	}
	public void deleteFiles() {
		UtilFacade.getInstance().deleteFile(mountInput())
		UtilFacade.getInstance().deleteFile(mountOutput())
		try{
			f = new File(mountProblemRoot())
			f.deleteDir()
		} catch (e) {
		}
	}
	
	public void uploadFiles(def request) {
		try{
			File f = new File(mountProblemRoot())
			f.mkdirs()			
			def inputFile = request.getFile('input')
			inputFile.transferTo(new File(mountInput()))
			def outputFile = request.getFile('output')
			outputFile.transferTo(new File(mountOutput()))
		}catch (e) {
		}
	}
	
	public void createFile(ArrayList<String> testCase, int type ) {
		try{
			File f = new File(mountProblemRoot())
			f.mkdirs()
			String pathToFile
			switch(type){
				case INPUT_FILE:
					pathToFile =  mountInput()
				
					break;
				case OUTPUT_FILE:
					pathToFile =  mountOutput()
					break;
			}
			int size = testCase.size()
			String text = ""
			text = testCase.get(0)
			
			for(int i = 1 ; i < size ; i++){
				text += "\n#problem\n"
				text += testCase.get(i)
			}
			BufferedWriter writer = new BufferedWriter(new FileWriter(pathToFile))
			writer.write(text)
			writer.flush()
			writer.close()
		}catch (e) {
		}
	}
	
	public void createFile(String testCase, int type ) {
		try{
			File f = new File(mountProblemRoot())
			f.mkdirs()
			String pathToFile
			switch(type){
				case INPUT_FILE:
					pathToFile =  mountInput()
				
					break;
				case OUTPUT_FILE:
					pathToFile =  mountOutput()
					break;
					case EXAMPLE_INPUT_FILE:
					pathToFile =  mountInputExample()
					break;
					case EXAMPLE_OUTPUT_FILE:
					pathToFile =  mountOutputExample()
					break;
			}
		
			BufferedWriter writer = new BufferedWriter(new FileWriter(pathToFile))
			writer.write(testCase)
			writer.flush()
			writer.close()
		}catch (e) {
		}
	}

    private String mountProblemRoot(){
        return HuxleyProperties.getInstance().get ("problemdb.dir")+ this.id+System.getProperty("file.separator");
    }


    public File downloadInput(){
		File file = null
		try{
			file = new File(mountInput())
		}catch(e){
		}
		return file
	}
	
	public File downloadOutput(){
		File file = null
		try{
			file = new File(mountOutput())
		}catch(e){
		}
		return file
	}

    public String mountInput(){
        return HuxleyProperties.getInstance().get ("problemdb.dir")+ this.id+System.getProperty("file.separator") + HuxleyProperties.getInstance().get ("problemdb.inputfile.name");
    }
    public String mountOutput(){
        return HuxleyProperties.getInstance().get ("problemdb.dir")+ this.id+System.getProperty("file.separator") + HuxleyProperties.getInstance().get ("problemdb.outputfile.name");
    }

    public String mountInputExample(){
        return HuxleyProperties.getInstance().get ("problemdb.dir")+ this.id+System.getProperty("file.separator") + HuxleyProperties.getInstance().get ("problemdb.example.inputfile.name");
    }
    public String mountOutputExample(){
        return HuxleyProperties.getInstance().get ("problemdb.dir")+ this.id+System.getProperty("file.separator") + HuxleyProperties.getInstance().get ("problemdb.example.outputfile.name");
    }



    public static Map<String,Object> filter(Map params){
		ArrayList<Problem> problemList
		int size
		if(params.get("name") !=null){
			problemList = Problem.findAllByNameLikeAndStatus("%" + params.get("name") + "%",Problem.STATUS_ACCEPTED,params)
			size = Problem.countByNameLikeAndStatus("%" + params.get("name") + "%",Problem.STATUS_ACCEPTED)
		}else if (params.get("code") !=null){
			if(params.get("code").matches("[0-9]+")){
				problemList = new ArrayList<Problem>()
				problemList.add(Problem.findByCodeAndStatus(params.get("code"),Problem.STATUS_ACCEPTED))
				size = 1
			}else{
				problemList = Problem.findAllByStatus(Problem.STATUS_ACCEPTED,params)
				size = Problem.countByStatus(Problem.STATUS_ACCEPTED)
			}
		}else if(params.get("level") != null && !params.get("level").isEmpty()){
			
			if(params.get("topics") != null){
				String query = "SELECT DISTINCT p FROM Problem p join p.topics tp where tp.id in "+ params.get("topics") + " and p.status = 2 and p.level = " + params.get("level")
				if(params.get("exclusive")){
					query = "SELECT Distinct p FROM Problem p join p.topics tp where tp.id in "+ params.get("topics") + " and p.status = 2 and p.level = "+ params.get("level") +" group by p.id having count(tp.id) = " + params.get("topicsCount")
				}
				problemList = Problem.executeQuery(query)
				size = Problem.executeQuery(query).size()
			}else{
				problemList = Problem.findAllByLevelAndStatus(params.get("level"),STATUS_ACCEPTED,params)
				size = Problem.countByLevelAndStatus(params.get("level"),STATUS_ACCEPTED)
			}
		}
		Map<String,Object> table = new Hashtable<String,Object>()
		table.put(FILTER_PROBLEM_LIST,problemList)
		table.put(FILTER_SIZE,size)
		return table
	}
	
	public Submission fastestSubmissionByUser(long userId){
		return Submission.executeQuery("Select s from Submission s, Problem p where s.user.id=? and p.id=? and s.evaluation = ?  and p.id = s.problem.id and s.time > -1 order by s.submissionDate desc",[userId,this.id,EvaluationStatus.CORRECT],[max:1])[0]
	}
	
}
