package com.thehuxley

/**
 * Created with IntelliJ IDEA.
 * User: romero
 * Date: 13/02/14
 * Time: 16:16
 * To change this template use File | Settings | File Templates.
 */
class UserEvolution {
    Profile user
    int topCoderPosition = 0
    double topCoderScore = 0
    int problemsTried = 0
    int problemCorrect = 0
    Date dateCreated
    Date lastUpdated

    static constraints = {
        user(nullable: false, blank: false)
        topCoderPosition(nullable: false, blank: false)
        topCoderScore(nullable: false, blank: false)
        problemsTried(nullable: false, blank: false)
        problemCorrect(nullable: false, blank: false)
    }

    public static void generateList(){
        ShiroUser.list().each{
            Profile p = Profile.findByUser(it)
            if(p) {
                try{
                    UserEvolution userEvolution = new UserEvolution()
                    userEvolution.user = p
                    userEvolution.topCoderPosition = it.topCoderPosition
                    userEvolution.topCoderScore = it.topCoderScore
                    userEvolution.problemCorrect = p.problemsCorrect
                    userEvolution.problemsTried = p.problemsTryed
                    userEvolution.save()
                } catch (e) {
                    e.printStackTrace()
                }
            }



        }
    }
}
