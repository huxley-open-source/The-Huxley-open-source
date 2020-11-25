package com.thehuxley

import java.io.Serializable;


class UserProblem implements Serializable{
	
	ShiroUser user;
	Problem problem;
	int status;
    int similarity;
	
	public static final int CORRECT = 1;
	public static final int TRIED = 2;
	public static final int NEVER_TRIED = 3;
    public static final int SIMILARITY_STATUS_NOT_MATCHED = 1;
	public static final int SIMILARITY_STATUS_MATCHED = 2;
	public static final int SIMILARITY_STATUS_TEACHER_PLAGIUM = 3;

    static constraints = {
		 user(nullable: false, blank: false)
		 problem(nullable: false, blank: false)
		 status(nullable: false, blank: false)
         similarity(nullable: true, blank: true)
    }
	
	public static generateUserProblem(){
		ArrayList<Problem> problemList = Problem.list()
		ArrayList<ShiroUser> userList = ShiroUser.list()
		userList.each{ user->
			problemList.each{ problem->
				if(!UserProblem.findByUserAndProblem(user,problem)){
				if(Submission.findByProblemAndUser(problem,user)){
					UserProblem userProblem = new UserProblem()
					userProblem.user = user
					userProblem.problem = problem
					userProblem.status = 2
					if(Submission.findWhere(user:user,problem:problem,evaluation:EvaluationStatus.CORRECT)){
						userProblem.status = 1
					}
					userProblem.save()
				}
				
				}
			}
			
			
		}
	}

    public void updateSimilarityStatusBySystem(int similarityStatus){
        if(similarityStatus != SIMILARITY_STATUS_NOT_MATCHED){
            if(similarity != SIMILARITY_STATUS_TEACHER_PLAGIUM ){
                similarity = similarityStatus
            }
        }else{

            if(Submission.findWhere(user:user,problem:problem,plagiumStatus:Submission.PLAGIUM_STATUS_TEACHER_PLAGIUM)){
                similarity = UserProblem.SIMILARITY_STATUS_TEACHER_PLAGIUM
            }else if (Submission.findWhere(user:user,problem:problem,plagiumStatus:Submission.PLAGIUM_STATUS_MATCHED)){
                similarity = UserProblem.SIMILARITY_STATUS_MATCHED
            }else{
                similarity = UserProblem.SIMILARITY_STATUS_NOT_MATCHED
            }
        }

    }

}
