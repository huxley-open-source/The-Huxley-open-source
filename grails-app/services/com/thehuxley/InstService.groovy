package com.thehuxley

class InstService {
    public static final DATA_NUMBER_STUDENTS = "Students"
    public static final DATA_NUMBER_MASTERS = "Masters"
    public static final DATA_NUMBER_PROBLEMS_TRIED = "Tried"
    public static final DATA_NUMBER_PROBLEMS_HIT = "Hit"

    public Map getDataForProfile(institution){
        long studentCount = ShiroUser.executeQuery("Select count(Distinct cp.user) from ClusterPermissions cp where permission = 0 and cp.group.institution.id = " +institution.id)[0]
        long masterCount = ShiroUser.executeQuery("Select count(Distinct cp.user) from ClusterPermissions cp where permission > 0 and cp.group.institution.id = " +institution.id)[0]
        ArrayList<ShiroUser> userList = ShiroUser.executeQuery("Select Distinct cp.user from ClusterPermissions cp where cp.group.institution.id = " +institution.id)
        long numberOfProblems = 0
        long numberOfProblemsHit = 0
        if(!userList.isEmpty()){
            numberOfProblems = UserProblem.countByUserInList(userList)
            numberOfProblemsHit = UserProblem.countByUserInListAndStatus(userList,UserProblem.CORRECT)
        }
        Map results = new HashMap<String,Object>()
        results.put(DATA_NUMBER_MASTERS,masterCount)
        results.put(DATA_NUMBER_STUDENTS,studentCount)
        results.put(DATA_NUMBER_PROBLEMS_HIT,numberOfProblemsHit)
        results.put(DATA_NUMBER_PROBLEMS_TRIED,numberOfProblems)
        return results

    }


}
