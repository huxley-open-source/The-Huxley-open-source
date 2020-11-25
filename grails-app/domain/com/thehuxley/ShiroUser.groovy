package com.thehuxley

//import org.jfree.chart.encoders.KeypointPNGEncoderAdapter;
//
//import com.thehuxley.charts.SpiderWebChart;
//import com.thehuxley.util.Constants;
//import com.thehuxley.vo.QuestionnaireStatus


import java.text.SimpleDateFormat

class ShiroUser implements Serializable{


    String username
    String name
    String passwordHash
    String email
    String status
    String cpf
    Date lastLogin

    int topCoderPosition
    double topCoderScore
    UserSetting settings


    static transients = ['firstName', 'lastName']
    static hasMany = [ roles: ShiroRole, permissions: String,  groups: Cluster, questionnaire : Questionnaire, questionnaireShiroUser: QuestionnaireShiroUser, contents: Content, lessons: Lesson, licenses: License]
    static mappedBy = [contents: 'owner', lessons: 'owner', licenses: "user"]
    static belongsTo = [Cluster]
    static constraints = {
        cpf(nullable: true, blank: true, unique: true)
        username(nullable: true, blank: false, unique: true)
        passwordHash(nullable: true)
        name(nullable: false, blank: false)
        email(nullable: false, blank:false, email: true)
        lastLogin(nullable: true, blank:true)
        topCoderPosition(nullable: true, blank:true)
        settings(nullable: true)
    }

    def afterInsert(){
        UserSetting setting = new UserSetting()
        setting.user = this
        setting.emailNotify = 0
    }

	List questionnaires() {
		def query = "from QuestionnaireShiroUser o where o.user.id='${this.id}'"
		def questionnaireList = QuestionnaireShiroUser.findAll(query)
		return questionnaireList
	}
	int countSubmissions(){
		String query = "SELECT count(*) FROM ShiroUser a, Submission s "+
				"where a.id = s.user.id "+
				"and a.id='${this.id}'"
		List list = ShiroUser.executeQuery(query)



		if(list.get(0)==null){

			return 0
		}else{

			return list.get(0)
		}
	}
	int countCorrectSubmissions(){
		String query = "SELECT count(*) FROM ShiroUser a, Submission s " +
				"where a.id = s.user.id "+
				"and s.evaluation = ? "+
				"and a.id=? "
		List list = ShiroUser.executeQuery(query,[EvaluationStatus.CORRECT, this.id])
		int count = list.get(0)
		return count
	}

	List submissionList(){
		String query = "SELECT p.code FROM Submission s, ShiroUser u, Problem p " +
				"where s.user.id = u.id "+
				"and u.id=? "+
				"and p.id=s.problem.id "+
				"group by p.id "


		List list = ShiroUser.executeQuery(query, [this.id])

		return list
	}
	String toString(){
		return name
	}

//	public static def listByInstitution(Hashtable<String, String> data){
//		String nameParam = data.get(Constants.KEY_NAME_PARAM)
//		def clusterList = Cluster.listByInstitution(data.get(Constants.KEY_INSTITUTION_ID))
//
//		ArrayList<Integer> userList = new ArrayList<Integer>()
//
//		clusterList.each{
//			it.users.each{
//				if(!userList.contains(it.id)){
//					userList.add(it.id)
//				}
//			}
//		}
//		if(userList.isEmpty()){
//			return userList
//		}
//		int max = Constants.DEFAULT_MAX
//		int offset = 0
//		String order = ""
//		String sortParam = ""
//		String listQuery = "("
//		userList.each{ listQuery+= it+", " }
//		if(listQuery.contains(',')){
//			listQuery = listQuery.substring(0,listQuery.lastIndexOf(','))
//		}
//		listQuery += ")"
//
//
//		String query = 	"from ShiroUser u where u.id in "+listQuery
//
//		if (nameParam!=null){
//			query += " AND u.name LIKE '%"+nameParam+"%'"
//		}
//
//		if(data.containsKey(Constants.KEY_ORDER)){
//			order = " "+data.get(Constants.KEY_ORDER)
//		}
//		if(data.containsKey(Constants.KEY_SORT)){
//			sortParam = " order by " + data.get(Constants.KEY_SORT)
//		}
//
//
//		if(data.containsKey(Constants.KEY_LIMIT)){
//			max = data.get(Constants.KEY_LIMIT)
//		}
//		if(data.containsKey(Constants.KEY_OFFSET)){
//			offset = Integer.parseInt(data.get(Constants.KEY_OFFSET))
//		}
//		query += sortParam + order
//		def users = ShiroUser.findAll(query)
//		int range = offset+max > users.size()? users.size() : offset+max
//		return users.subList (offset, range)
//	}
	public static def listByInstitutionAndStatus(long institution, String status){
		def clusterList = Cluster.listByInstitution(institution)
		ArrayList<ShiroUser> userList = new ArrayList<ShiroUser>()
		clusterList.each{
			it.users.each{
				if(it.status.equals(status) && !userList.contains(it)){
					userList.add(it)
				}
			}
		}
		return userList
	}
	public static def countByInstitution(long institution){
		def clusterList = Cluster.listByInstitution(institution)
		ArrayList<Integer> userList = new ArrayList<Integer>()
		clusterList.each{
			it.users.each{
				if(!userList.contains(it.id)){
					userList.add(it.id)
				}
			}
		}
		return userList.size()
	}
	public static def countByInstitutionAndStatus(long institution, String status){
		def clusterList = Cluster.listByInstitution(institution)
		ArrayList<ShiroUser> userList = new ArrayList<ShiroUser>()
		clusterList.each{
			it.users.each{
				if(it.status.equals(status) && !userList.contains(it)){
					userList.add(it)
				}
			}
		}
		return userList.size()
	}
	public static def containsUser(long institution , long userId){

		def clusterList = Cluster.listByInstitution(institution)
		ArrayList<Integer> userList = new ArrayList<Integer>()
		clusterList.each{
			it.users.each{
				if(!userList.contains(it.id)){
					userList.add(it.id)
				}
			}
		}
		return userList.contains(userId)
	}
//	public static def listByGroup(Hashtable<String, String> data){
//		ArrayList<Cluster> clusterList = new ArrayList<Cluster>()
//		clusterList.add(Cluster.get(data.get("Group")))
//		ArrayList<Integer> userList = new ArrayList<Integer>()
//		clusterList.each{
//			it.users.each{
//				if(!userList.contains(it.id)){
//					userList.add(it.id)
//				}
//			}
//		}
//		if(userList.isEmpty()){
//			return userList
//		}
//		int max = Constants.DEFAULT_MAX
//		int offset = 0
//		String order = ""
//		String sortParam = ""
//		String listQuery = "("
//		userList.each{ listQuery+= it+", " }
//		if(listQuery.contains(',')){
//			listQuery = listQuery.substring(0,listQuery.lastIndexOf(','))
//		}
//		listQuery += ")"
//
//		String query = 	"from ShiroUser u where u.id in "+listQuery
//
//		if(data.containsKey(Constants.KEY_ORDER)){
//			order = " "+data.get(Constants.KEY_ORDER)
//		}
//		if(data.containsKey(Constants.KEY_SORT)){
//			sortParam = " order by " + data.get(Constants.KEY_SORT)
//		}
//
//
//		if(data.containsKey(Constants.KEY_LIMIT)){
//			max = data.get(Constants.KEY_LIMIT)
//		}
//		if(data.containsKey(Constants.KEY_OFFSET)){
//			offset = Integer.parseInt(data.get(Constants.KEY_OFFSET))
//		}
//		query += sortParam + order
//		def users = ShiroUser.findAll(query)
//		int range = offset+max > users.size()? users.size() : offset+max
//		return users.subList (offset, range)
//	}

	public static def countByGroup(long group){

		return Cluster.get(group).users.size()
	}
	public String listInstitution(){
		String list ="("
		ArrayList<String> instList = new ArrayList<String>()
		ClusterPermissions.findAllByUser(this).each{
			if(!instList.contains(it.group.institution.name)){
				instList.add(it.group.institution.name)
				list += it.group.institution.name + ", "
			}
		}
		if(list.contains(","))
			list = list.substring(0,list.lastIndexOf(","))
		list +=")"

		return list
	}


	public void createDependences(String groupId, int permission, String path){

		UserLink link = UserLink.generate(this)
		path = path.substring(0,path.indexOf("/",(path.indexOf("/",8)+1)))
		path+="/auth/createUser?l=" + link.link
		path = path.replaceFirst (":8080", "")
		String message = "Olá "+ this.name +" \nVocê foi convidado a partipar do The Huxley \nPara efetuar seu cadastro acesse o link: " + path +"\nObrigado!\n\nHuxley Team."
		EmailToSend emailToSend = new EmailToSend()
		emailToSend.email = this.email
		emailToSend.message = message
		emailToSend.status = "TOSEND"
		emailToSend.save()
		ClusterPermissions clusterPermission = new ClusterPermissions()
		clusterPermission.user = this
		clusterPermission.permission = permission
		clusterPermission.group = Cluster.get(groupId)
		clusterPermission.save()
		Questionnaire.updateUserQuestionnaireList(clusterPermission)
	}
	/**
	 *
	 * @return [[Id do questionario, titulo, data final, id do questionnaire user, pontuação, questionario pontuação]]
	 */
	public def mountOutOfDateQuestionnaires(){
		java.sql.Date actualDate =  new  java.sql.Date(System.currentTimeMillis())
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
		String formatedDate = dateFormat.format(actualDate)
		def list = ShiroUser.executeQuery("Select q.id, q.title, q.endDate, qu.id, qu.score, q.score From QuestionnaireShiroUser qu left join qu.questionnaire q where qu.user.id = "+this.id+" and q.endDate <= '" + formatedDate+"' order by q.endDate desc")
		return list
	}

	/**
	 *
	 * @return [[Id do questionario, titulo, data final, id do questionnaire user, pontuação, questionario pontuação]]
	 */
	public def mountInDateQuestionnaires(){
		java.sql.Date actualDate = new  java.sql.Date(System.currentTimeMillis())

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
		String formatedDate = dateFormat.format(actualDate)
		String query = "Select q.id, q.title, q.endDate, qu.id, qu.score, q.score From QuestionnaireShiroUser qu left join qu.questionnaire q where qu.user.id = "+this.id+" and q.endDate > '" + formatedDate+"' and q.startDate <'" + formatedDate+"' order by q.endDate asc"
		def list = ShiroUser.executeQuery(query)
		return list
	}

//	public QuestionnaireStatus questionnaireStatusByMountFunction(def list){
//		QuestionnaireStatus status
//		if(list[4] == list[5]){
//			status = QuestionnaireStatus.ANSWERED
//		}else{
//			int count = Submission.executeQuery("SELECT count(*) FROM Submission s, Questionnaire q where s.user.id = "+ this.id + " and q.id = "+list[0]+" and s.problem.id in (SELECT qp.problem.id FROM QuestionnaireProblem qp where qp.questionnaire.id = q.id)")[0]
//			if(count == 0){
//				status = QuestionnaireStatus.NOT_TRIED
//			}else if(list[5] >0){
//				status = QuestionnaireStatus.WORKING_ON
//			}else{
//				status = QuestionnaireStatus.TRIED
//			}
//			return status
//		}
//	}

	public String getFirstName(){
		name = name.trim()
		int endFirst = name.indexOf(' ');
		if (endFirst!=-1){
			return name.substring(0, endFirst);
		}else{
			return name;
		}
	}

	public String getLastName(){
		name = name.trim();
		int beginLast = name.lastIndexOf(' ');
		if (beginLast!=-1){
			return name.substring(beginLast+1, name.length());
		}else{
			return name ;
		}
	}
	public Submission lastSubmission(){
		return Submission.findByUser(this,[order:"desc",max:"1",sort:"submissionDate"])

	}
	public boolean validUser(){
		def actualDate = new GregorianCalendar().getTime()
		if(!currentLicense){
			return false
		}else{
			if(currentLicense.endDate < actualDate){
				return false
			}
			if(currentLicense.startDate > actualDate){
				return false
			}
		}
		return true
	}
}
