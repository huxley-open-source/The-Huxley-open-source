package com.thehuxley

import com.thehuxley.util.HuxleyProperties

class SimilarityTagLib {

    static namespace = "huxley"
    private final static double SIMILARITY_THRESHOLD = Double.parseDouble(HuxleyProperties.getInstance().get("similarity.threshold"))
    def listBySubmission = { attrs ->
        Submission submission = Submission.get(attrs.id)
        Profile profile = Profile.findByUser(submission.user)
        ArrayList<Plagium> plagList = Plagium.executeQuery("Select Distinct p.submission2.user, p from Plagium p where p.submission1.id = " + submission.id +" and p.percentage > " + SIMILARITY_THRESHOLD)
        ArrayList<Plagium> plagList2 = Plagium.executeQuery("Select Distinct p.submission1.user, p from Plagium p where p.submission2.id = " + submission.id +" and p.percentage > " + SIMILARITY_THRESHOLD)
        ArrayList<String> emailList = new ArrayList<String>()
        ArrayList<ShiroUser> suspectList = new ArrayList<ShiroUser>()
        ArrayList<Long> countList = new ArrayList<Long>()
        ArrayList<Plagium> suspectSubList = new ArrayList<Plagium>()
        Map<String, Plagium> plagMap = new HashMap<String, Plagium>()
        int count = 0
        plagList.each{
            if(!emailList.contains(it[0].email)){
                suspectSubList = new ArrayList<Plagium>()
                suspectList.add(it[0])
                emailList.add(it[0].email)
                suspectSubList.add(it[1])
                plagMap.put(it[0].email,suspectSubList)
                countList.add(suspectSubList.size())
            }
        }
        plagList2.each{
            if(!emailList.contains(it[0].email)){
                suspectSubList = new ArrayList<Plagium>()
                suspectList.add(it[0])
                emailList.add(it[0].email)
                suspectSubList.add(it[1])
                plagMap.put(it[0].email,suspectSubList)
                countList.add(suspectSubList.size())
            }
        }

        suspectList.each{ suspect ->
            out<< """
    <div class="box">
        ${huxley.userBox profile:Profile.findByUser(suspect)}
        <table class="standard-table" >
            """
            plagMap.get(suspect.email).eachWithIndex{ plag,i ->
                if (plag.percentage && i < 3){
                    out << """<tr><td></td><td><h3>${g.link action:"show", params:[id:plag.id,sId:submission.id], class:"ui-gbutton", g.message(code:"similarity.more.details")}</h3></td></tr>"""
                }
            }

        out << """</table>
    </br>
    <hr />
    </div>

 """
        }


}
}