package com.thehuxley

import java.text.Normalizer
import grails.converters.JSON

class SubmissionService {
    public final String FILE_SEPARATOR = System.getProperty("file.separator")

    def problemService
    def memcachedService

    def getSubmissionInfo (user, problem) {
        def problemRecordInfo = memcachedService.get("submission-info-user:${user.id}-problem:${problem.id}", 7 * 24 * 60 * 60) {
            def result = [:]

            def userRecordSub = Submission.findByUserAndProblemAndEvaluationAndTimeGreaterThan(user, problem, EvaluationStatus.CORRECT, 0, [max: 1, sort: 'submissionDate', order: 'desc'])
            def submissionLast = Submission.findByUserAndProblem(user, problem,[order:"desc",sort:"submissionDate"])

            if (userRecordSub) {
                result.put('userRecord', [id: userRecordSub.id, submission: userRecordSub.submission, time: userRecordSub.time])
            }

            if (submissionLast) {
                result.put('submissionLast', [id: submissionLast.id, submission: submissionLast.submission, time: submissionLast.time])
            }

            (result as JSON) as String
        }
        problemRecordInfo
    }

    def getSubmissionInfoById (id) {
        def submissionInfo = memcachedService.get("submission-info-id:${id}", 7 * 24 * 60 * 60) {
            def result = [:]
            def submissionInstance = Submission.get(id)
            def referenceSolution = ReferenceSolution.findByProblemAndLanguage(submissionInstance.problem, submissionInstance.language)
            result.put('id', submissionInstance.id)
            result.put('pid', submissionInstance.problem.id)
            result.put('name', submissionInstance.problem.name)
            result.put('language', [id: submissionInstance.language.id, name: submissionInstance.language.name])
            if(referenceSolution){
                result.put('rid', referenceSolution.id)
            }else{
                result.put('rid', -1)
            }

            (result as JSON) as String
        }
        submissionInfo
    }

    def invalidateCache (user, problem) {
        memcachedService.delete("submission-info-user:${user.id}-problem:${problem.id}");
    }

    public Submission getLastSubmissionByUserAndProblem(userId,problemId){
        return Submission.findByUserAndProblem(ShiroUser.get(userId),Problem.get(problemId),[order:"desc",sort:"submissionDate"])
    }

    public Submission getFastestSubmissionByUserAndProblem(userId,problemId){
        return  Submission.executeQuery("Select s from Submission s, Problem p where " +
                "s.user.id=? and p.id=? and s.evaluation = ? and " +
                "p.id = s.problem.id and s.time > 0 order by s.submissionDate desc",[userId, problemId, EvaluationStatus.CORRECT],[max:1])[0]
    }

    public String generatePath(submission){
        String path = problemService.mountProblemRoot(submission.problem.id) +
                submission.user.id + FILE_SEPARATOR +
                submission.language.name + FILE_SEPARATOR +
                submission.tries + FILE_SEPARATOR
        return path
    }

    public void createUserDirectory(submission) {
        String root = generatePath(submission)
        try{
            File rootDir = new File(root)
            rootDir.mkdirs()
        }catch (e){
            e.printStackTrace()
        }
    }

    public void createFiles(def request, def params,submission) {

        try {
            InputStream inputStream = request.getInputStream()
            String name = formatFileName(params.qqfile.substring(0,params.qqfile.lastIndexOf('.')));
            String fileName = generatePath(submission)+ name + submission.language.extension
            File file = new File(fileName);
            OutputStream outputStream = new FileOutputStream(file);
            byte[] buffer = new byte[1024];
            int length;

            while((length = inputStream.read(buffer)) > 0) {
                outputStream.write(buffer, 0, length);
            }

            outputStream.close();
            inputStream.close();

            submission.submission = name + submission.language.extension
            submission.diffFile = name + ".diff"
            submission.output = name + ".out"

        } catch (IOException e) {
            log.error('Error while trying to save the file of a submission',e)
        }
    }

    public String formatFileName(String fileName){
        String extension = ""
        if(fileName.contains('.')){
            extension = fileName.substring(fileName.indexOf('.'))
        }
        fileName = fileName.replace(extension, "").replace(" ", "_")
        fileName = Normalizer.normalize(fileName, Normalizer.Form.NFD)
        fileName = fileName.replaceAll("[^\\p{ASCII}]", "")
        if(fileName.size() ==0){
            fileName = 'A'
        }
        return fileName
    }

    public ArrayList<Submission> getPendingSubmissions(userId){
        def cal = new GregorianCalendar();
        cal.add(Calendar.HOUR_OF_DAY, -3);
        return Submission.executeQuery("Select s from Submission s where s.user.id= :userId and s.evaluation= :evaluation " +
                "and s.submissionDate > :date", [userId: userId, evaluation:EvaluationStatus.WAITING, date:cal.getTime()])

    }

    /**
     * Função para busca de submissões a partir de um nome de usuario, email, username e/ou codigo de problema ou nome de problema e/ou intervalo de tempo de submissão
     * @param params
     * @return
     */
	public static Map<String,Object> google(Map params){
		String where = " where"
		boolean addWhere = false
		boolean and = false

		String userName
        String problemName
        String beginDate
        String endDate
        String userId
        String groupId
        String instId
        String problemId
        String evaluation
        if(params.containsKey(Submission.PARAMS_USER_NAME)){
            userName = params.get(Submission.PARAMS_USER_NAME)
        }
        if(params.containsKey(Submission.PARAMS_EVALUATION)){
            evaluation = params.get(Submission.PARAMS_EVALUATION)
        }
        if(params.get(Submission.PARAMS_PROBLEM_NAME)){
            problemName = params.get(Submission.PARAMS_PROBLEM_NAME)
        }
        if(params.get(Submission.PARAMS_PROBLEM_ID)){
            problemId = params.get(Submission.PARAMS_PROBLEM_ID)
        }
        if(params.get(Submission.PARAMS_BEGIN_DATE)){
            beginDate = params.get(Submission.PARAMS_BEGIN_DATE)
        }
        if(params.get(Submission.PARAMS_END_DATE)){
            endDate = params.get(Submission.PARAMS_END_DATE)
        }
        if(params.get(Submission.PARAMS_USER_ID)){
            userId = params.get(Submission.PARAMS_USER_ID)
        }
        if(params.get(Submission.PARAMS_GROUP_ID)){
            groupId = params.get(Submission.PARAMS_GROUP_ID)
        }
        if(params.get(Submission.PARAMS_INSTITUTION_ID)){
            instId = params.get(Submission.PARAMS_INSTITUTION_ID)
        }
		String sort =  params.get("sort")
		String order =  params.get("order")
		int max = 10
		int offset = 0
        max = params.get("max")
		offset = params.get("offset")
        String query = "SELECT Distinct s FROM Submission s "
		if(userId || userName ){
            if(userId){
                addWhere = true
                where += " s.user.id = "+userId+" "
                and = true
            }else if(userName){
                addWhere = true
                where += " (s.cacheUserName like '%"+userName+"%' or s.cacheUserEmail like '%"+userName+"%' or s.cacheUserUsername like '%"+userName+"%')"
                and = true
            }
		}
        if(groupId){
            addWhere = true
            if(and){
                where += " and "
            }
            and = true
            String idList = ClusterPermissions.executeQuery("Select Distinct cp.user.id from ClusterPermissions cp where cp.group.id in ("+ groupId + ")").toString().replace("[","")
            idList = idList.replace("]","")
            where += " s.user.id in ("+ idList + ")"
        }

        if(evaluation){
            addWhere = true
            if(and){
                where += " and "
            }
            and = true
            where += " s.evaluation = " + evaluation + ""
        }

        if(problemName || problemId || sort.equals("p.name")){
            if(problemId){
                addWhere = true
                if(and){
                    where += " and "
                }
                if(problemId.matches("[0-9]*\\.?[0-9]*")){
                    where += " (s.problem.id = "+problemId+")"
                }
                and = true
            }else if(problemName){
                addWhere = true
                if(and){
                    where += " and "
                }
                    where += " s.cacheProblemName like '%"+problemName+"%'"
                and = true
            }
		}

		if(instId){
			addWhere = true
			if(and){
				where += " and "
			}
			and = true
            String idList = ClusterPermissions.executeQuery("Select l.user.id from License l where l.institution.id =  "+ instId).toString().replace("[","")
            idList = idList.replace("]","")
            where += " s.user.id in ("+ idList + ")"
		}
		if(beginDate){
			addWhere = true
			if(and){
				where += " and "
			}
			where += " s.submissionDate >= '" + beginDate + "'"
			and = true
		}
		if(endDate){
			addWhere = true
			if(and){
				where += " and "
			}
			where += " s.submissionDate <= '" + endDate + "'"
		}
		if(addWhere){
			query += where
		}
		if(sort){
			query += " ORDER BY "+sort
			if(order){
				query += " "+order
			}
		}
      	ArrayList<Submission> submissionList = new ArrayList<Submission>()
		submissionList = Submission.executeQuery(query,[max:max,offset:offset])
      	Map<String,Object> table = new Hashtable<String,Object>()
		table.put(Submission.FILTER_SUBMISSION_LIST, submissionList)
		table.put (Submission.FILTER_SIZE, Submission.executeQuery(query.replace("Distinct s","count(Distinct s)"))[0])
		return table
	}
    public static Map<String,Object> googleWOCount(Map params){
        String where = " where"
        boolean addWhere = false
        boolean and = false

        String userName
        String problemName
        String beginDate
        String endDate
        String userId
        String groupId
        String instId
        String problemId
        String evaluation
        if(params.containsKey(Submission.PARAMS_USER_NAME)){
            userName = params.get(Submission.PARAMS_USER_NAME)
        }
        if(params.containsKey(Submission.PARAMS_EVALUATION)){
            evaluation = params.get(Submission.PARAMS_EVALUATION)
        }
        if(params.get(Submission.PARAMS_PROBLEM_NAME)){
            problemName = params.get(Submission.PARAMS_PROBLEM_NAME)
        }
        if(params.get(Submission.PARAMS_PROBLEM_ID)){
            problemId = params.get(Submission.PARAMS_PROBLEM_ID)
        }
        if(params.get(Submission.PARAMS_BEGIN_DATE)){
            beginDate = params.get(Submission.PARAMS_BEGIN_DATE)
        }
        if(params.get(Submission.PARAMS_END_DATE)){
            endDate = params.get(Submission.PARAMS_END_DATE)
        }
        if(params.get(Submission.PARAMS_USER_ID)){
            userId = params.get(Submission.PARAMS_USER_ID)
        }
        if(params.get(Submission.PARAMS_GROUP_ID)){
            groupId = params.get(Submission.PARAMS_GROUP_ID)
        }
        if(params.get(Submission.PARAMS_INSTITUTION_ID)){
            instId = params.get(Submission.PARAMS_INSTITUTION_ID)
        }
        String sort =  params.get("sort")
        String order =  params.get("order")
        int max = 10
        int offset = 0
        max = params.get("max")
        offset = params.get("offset")
        String query = "SELECT Distinct s FROM Submission s "
        if(userId || userName ){
            if(userId){
                addWhere = true
                where += " s.user.id = "+userId+" "
                and = true
            }else if(userName){
                addWhere = true
                where += " (s.cacheUserName like '%"+userName+"%' or s.cacheUserEmail like '%"+userName+"%' or s.cacheUserUsername like '%"+userName+"%')"
                and = true
            }
        }
        if(groupId){
            addWhere = true
            if(and){
                where += " and "
            }
            and = true
            String idList = ClusterPermissions.executeQuery("Select Distinct cp.user.id from ClusterPermissions cp where cp.group.id in ("+ groupId + ")").toString().replace("[","")
            idList = idList.replace("]","")
            where += " s.user.id in ("+ idList + ")"
        }

        if(evaluation){
            addWhere = true
            if(and){
                where += " and "
            }
            and = true
            where += " s.evaluation = " + evaluation + ""
        }

        if(problemName || problemId || sort.equals("p.name")){
            if(problemId){
                addWhere = true
                if(and){
                    where += " and "
                }
                if(problemId.matches("[0-9]*\\.?[0-9]*")){
                    where += " (s.problem.id = "+problemId+")"
                }
                and = true
            }else if(problemName){
                addWhere = true
                if(and){
                    where += " and "
                }
                where += " s.cacheProblemName like '%"+problemName+"%'"
                and = true
            }
        }

        if(instId){
            addWhere = true
            if(and){
                where += " and "
            }
            and = true
            String idList = ClusterPermissions.executeQuery("Select l.user.id from License l where l.institution.id =  "+ instId).toString().replace("[","")
            idList = idList.replace("]","")
            where += " s.user.id in ("+ idList + ")"
        }
        if(beginDate){
            addWhere = true
            if(and){
                where += " and "
            }
            where += " s.submissionDate >= '" + beginDate + "'"
            and = true
        }
        if(endDate){
            addWhere = true
            if(and){
                where += " and "
            }
            where += " s.submissionDate <= '" + endDate + "'"
        }
        if(addWhere){
            query += where
        }
        if(sort){
            query += " ORDER BY "+sort
            if(order){
                query += " "+order
            }
        }
        ArrayList<Submission> submissionList = new ArrayList<Submission>()
        submissionList = Submission.executeQuery(query,[max:max,offset:offset])
        Map<String,Object> table = new Hashtable<String,Object>()
        table.put(Submission.FILTER_SUBMISSION_LIST, submissionList)
        return table
    }
}
