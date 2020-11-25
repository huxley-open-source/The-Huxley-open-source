package com.thehuxley


class HomeController {

    def problemService
    def index() {
        def licenses = License.findAllByUser(session.profile.user)

       if (session.license?.isTeacher() && !ClusterPermissions.findAllByUserAndPermission(session.profile.user, 30).isEmpty()) {
           redirect action: 'overview', controller: 'group'
       } else  if (session.license?.isTeacher()) {
           redirect action: 'welcome', controller: 'group'
       }

        [licenses: licenses, currentLicense: session.license, sMsg:params.sMsg,eMsg:params.eMsg]
    }

    def test = {}

    def search = {
        String name = params.ss
        params.userId = session.profile.user.id
        params.resolved = true
        params.max = 5
        try{
            params.levelMax = Integer.parseInt(params.levelMax)
        }catch (Exception e){
            params.levelMax = 10
        }
        try{
            params.levelMin = Integer.parseInt(params.levelMin)
        }catch(Exception e){
            params.levelMin = 0
        }
        try{
            params.ndMax = Integer.parseInt(params.ndMax)
        }catch (Exception e){
            params.ndMax = 10
        }
        try{
            params.ndMin = Integer.parseInt(params.ndMin)
        }catch(Exception e){
            params.ndMin = 0
        }
        params.nameParam = name;
        ArrayList<Problem> problems
        if(params.nameParam.equals("onDemand") && session.admin){
            problems = Problem.findAllByStatus(Problem.STATUS_WAITING)
        }else{
            Map<String,Object> problemMap = problemService.google(params)
            problems = problemMap.get(Problem.FILTER_PROBLEM_LIST)
        }

        ArrayList<Profile> profiles = Profile.findAllByNameLike("%"+name+"%",[max:"5"])
        ArrayList<Cluster> groups
        if(session.license.isStudent() || session.license.isAdmin()){
            groups = Cluster.findAllByNameLike("%" + name + "%", [max:"5"])
        } else {
            groups = Cluster.findAllByNameLikeAndInstitution("%" + name + "%", Institution.get(session.license.institution.id) , [max:"5"])
        }
        render(contentType:"text/json") {
            problemList = array {
                problems.each {
                    problem id:it.id , name:it.name
                }
            }
            groupList = array {
                groups.each {
                    group id:it.hash , name:it.name
                }
            }
            profileList = array {
                profiles.each {
                    profile id:it.hash , name:it.name
                }
            }
        }
    }

    def searchResults = {
        String name = params.ss
        params.userId = session.profile.user.id
        params.resolved = true
        if (!params.max){
            params.max = 10
        }
        try{
            params.levelMax = Integer.parseInt(params.levelMax)
        }catch (Exception e){
            params.levelMax = 10
        }
        try{
            params.levelMin = Integer.parseInt(params.levelMin)
        }catch(Exception e){
            params.levelMin = 0
        }
        try{
            params.ndMax = Integer.parseInt(params.ndMax)
        }catch (Exception e){
            params.ndMax = 10
        }
        try{
            params.ndMin = Integer.parseInt(params.ndMin)
        }catch(Exception e){
            params.ndMin = 0
        }
        params.nameParam = name;
        ArrayList<Problem> problems
        def problemCount = 0
        if(params.nameParam.equals("onDemand") && session.admin){
            problems = Problem.findAllByStatus(Problem.STATUS_WAITING)
        }else{
            Map<String,Object> problemMap = problemService.google(params)
            problems = problemMap.get(Problem.FILTER_PROBLEM_LIST)
            problemCount = problemMap.get(Problem.FILTER_SIZE)
        }

        ArrayList<Profile> profiles = Profile.findAllByNameLike("%"+name+"%",[max:params.max])
        def profileCount = Profile.countByNameLike("%"+name+"%")

        [problems:problems,profiles:profiles, problemCount:problemCount, profileCount:profileCount,name:name]

    }

    def searchProfileAjax = {
        if (!params.max){
            params.max = 10
        }
        ArrayList<Profile> profiles = Profile.findAllByNameLike("%"+params.ss+"%",[offset:params.offset,max:params.max])
        String profileList= ""
        profiles.each{
            profileList += huxley.user( class:"search-suggestion-user-box", profile:it, it.name)
        }
        println profileList
        render(contentType:"text/json") {
            content = profileList

        }

    }

    def searchProblemAjax = {
        String name = params.ss
        params.userId = session.profile.user.id
        params.resolved = true
        if (!params.max){
            params.max = 10
        }
        try{
            params.levelMax = Integer.parseInt(params.levelMax)
        }catch (Exception e){
            params.levelMax = 10
        }
        try{
            params.levelMin = Integer.parseInt(params.levelMin)
        }catch(Exception e){
            params.levelMin = 0
        }
        try{
            params.ndMax = Integer.parseInt(params.ndMax)
        }catch (Exception e){
            params.ndMax = 10
        }
        try{
            params.ndMin = Integer.parseInt(params.ndMin)
        }catch(Exception e){
            params.ndMin = 0
        }
        params.nameParam = name;
        ArrayList<Problem> problems
        def problemCount = 0
        if(params.nameParam.equals("onDemand") && session.admin){
            problems = Problem.findAllByStatus(Problem.STATUS_WAITING)
        }else{
            Map<String,Object> problemMap = problemService.google(params)
            problems = problemMap.get(Problem.FILTER_PROBLEM_LIST)
        }
        render(contentType:"text/json") {
            problemList = array {
                problems.each{
                    problem id:it.id, name:it.name
                }
            }
        }
    }

    def changeLicense = {
        License license = License.get(params.license)
        if(license.user.id == session.profile.user.id){
            session.license = license
            session.chosenLicense = true
        }

		if (!session.license?.isTeacher() && (params.targetUri.contains("/group/overview") || params.targetUri.contains("/group/welcome"))) {
			redirect controller: "home", action: "index"
		} else {
			redirect uri: params.targetUri
		}
    }

    def unauthorized = {}


}