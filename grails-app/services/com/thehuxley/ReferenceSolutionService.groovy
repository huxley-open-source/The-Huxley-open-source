package com.thehuxley

class ReferenceSolutionService {
    public static final String REFERENCE_LIST = "REFERENCE_LIST"
    public static final String REFERENCE_LIST_COUNT = "REFERENCE_LIST_COUNT"

    public  getReferenceSolutionByUserAndProblem(userId,problemId){
        ArrayList<Language> allowedList = Submission.executeQuery("Select s.language from Submission s where s.problem.id = ? and s.evaluation = ? and s.user.id = ? group by s.language",[problemId, EvaluationStatus.CORRECT, userId ])
        ArrayList<ReferenceSolution> referenceList = ReferenceSolution.findAllByProblem(Problem.get(2))
        Map<String,String> solutionMap = new HashMap<String,String>()
        Language.list().each{
            solutionMap.put(it.name,'s1')
        }
        allowedList.each{
            solutionMap.put(it.name,'s2')
        }
        referenceList.each {
            if(solutionMap.containsKey(it.language.name)){
                solutionMap.put(it.language.name,it.id)
            }else{
                solutionMap.put(it.language.name,'s4')
            }
        }
        return solutionMap
    }

    public Map listReferenceSolution(params,user,admin){
        Map<String,Object> resultMap = new HashMap<String, Object>()
        String searchParam = ""
        if(params.get("searchParam")){
            searchParam = params.get("searchParam")
        }
        String selectQuery = "Select s "
        String countQuery = "Select count(s)"
        String query = "from ReferenceSolution s where s.userSuggest.id = " + user.id + " and s.problem.name like '%" + searchParam + "%' order by "+ params.get("sort") +" " + params.get("order")
        if(params.get("accepted").equals("false")){
            query = "from ReferenceSolution s where s.userSuggest.id = " + user.id + " and s.problem.name like '%" + searchParam + "%' and s.status <> "+ ReferenceSolution.STATUS_ACCEPTED+" order by "+ params.get("sort") +" " + params.get("order")
        }
        if(admin){
            query = "from ReferenceSolution s order by "+ params.get("sort") +" " + params.get("order")
            if(params.get("searchParam")&&!params.get("searchParam").equals("undefined")){
                if(params.get("accepted").equals("true")){
                    query = "from ReferenceSolution s where s.userSuggest.name like '%"+params.get("searchParam")+"%' or s.problem.name like '%"+params.get("searchParam")+"%' order by s."+ params.get("sort") +" " + params.get("order")
                }else{
                    query = "from ReferenceSolution s where s.status <> "+ ReferenceSolution.STATUS_ACCEPTED+" and (s.userSuggest.name like '%"+params.get("searchParam")+"%' or s.problem.name like '%"+params.get("searchParam")+"%') order by s."+ params.get("sort") +" " + params.get("order")
                }
            }
        }
        println query
        println selectQuery + query
        println ReferenceSolution.executeQuery(selectQuery + query,[max:params.get("max"),offset:params.get("offset")])
        resultMap.put(REFERENCE_LIST,ReferenceSolution.executeQuery(selectQuery + query,[max:params.get("max"),offset:params.get("offset")]))
        resultMap.put(REFERENCE_LIST_COUNT,ReferenceSolution.executeQuery(countQuery + query)[0])
        return resultMap
    }
}
