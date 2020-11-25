package com.thehuxley.stimulusPredictor

import com.thehuxley.Cluster
import com.thehuxley.ClusterPermissions
import com.thehuxley.EvaluationStatus
import com.thehuxley.Questionnaire
import com.thehuxley.util.HuxleyProperties
import grails.converters.JSON

/**
 * Created with IntelliJ IDEA.
 * User: MRomero
 * Date: 28/02/13
 * Time: 21:37
 * To change this template use File | Settings | File Templates.
 */
class StimulusPredictor {

    public static testPredict(){
        String path = HuxleyProperties.getInstance().get("stimulus.predictor.path")
        SvmPredict.runPredict(generateModelData(113,28,-1),path + "StimulusPredictor.model")
        SvmPredict.runPredict(generateModelData(113,28,1),path + "StimulusPredictor4.model")
        SvmPredict.runPredict(generateModelData(113,28,7),path + "StimulusPredictor10.model")

    }
    public static HashMap<String,Object> runPredict(groupId){
        String path = HuxleyProperties.getInstance().get("stimulus.predictor.path")
        ArrayList<Double> result
        def data = generateData(groupId,-1)
        ArrayList<String> instances = data.get("PREDICTION")
        ArrayList<String> userList = data.get("USER_LIST")
        if (data.get("N_QUEST") < 5){
            result = SvmPredict.runPredict(instances,path + "StimulusPredictor4.model")
        }else if (data.get("N_QUEST") < 11){
            result = SvmPredict.runPredict(instances,path + "StimulusPredictor10.model")
        }else{
            result = SvmPredict.runPredict(instances,path + "StimulusPredictor.model")
        }
        HashMap<String,Object> results = new HashMap<String,Object>()
        results.put("USER_LIST",userList)
        results.put("RESULT",result)
        results.put("N_QUEST",data.get("N_QUEST"))
        return results
    }
    //(119,38,-1) ou (113,28,-1)
    public static createModel(){
        SvmTrain predictor = new SvmTrain()
        String path = HuxleyProperties.getInstance().get("stimulus.predictor.path")
        predictor.run(generateModelData(113,28,-1),path + "StimulusPredictor.model")
        predictor.run(generateModelData(113,28,4),path + "StimulusPredictor4.model")
        predictor.run(generateModelData(113,28,10),path + "StimulusPredictor10.model")

    }


    private static ArrayList<String> generateModelData(int qIdMax, int groupId,int totalInstances){
        ArrayList<String> result = new ArrayList<String>()
        ClusterPermissions.findAllByGroupAndPermission(Cluster.get(groupId),0).each{
            HashMap<Long,Double> qTime = new HashMap<Long,Double>()
            ArrayList<Long> idList = new ArrayList<Long>()
            ArrayList<Long> scoreList = new ArrayList<Long>()
            double totalScore = 0
            Questionnaire.executeQuery("Select q.id, max(s.submissionDate), q.endDate, q.startDate from " +
                    "Questionnaire q left join q.questionnaireShiroUser qu left join q.questionnaireProblem qp left join q.groups cluster, Submission s " +
                    "where qu.user.id = ? and cluster.id = ? and qu.user.id = s.user.id and " +
                    "qp.problem.id = s.problem.id and s.evaluation = ?  and s.submissionDate < q.endDate " +
                    "and q.id < ? group by q.id",
                    [it.user.id, it.group.id, EvaluationStatus.CORRECT, qIdMax]).eachWithIndex{ instance,i->
                double percentTime = instance[1].getTime() - instance[3].getTime()
                if (percentTime > 0){
                    percentTime = percentTime/(instance[2].getTime() - instance[3].getTime())
                }else{
                    percentTime = 0
                }
                    qTime.put(instance[0],percentTime)


            }
            int total = 0
            Questionnaire.executeQuery("Select q.id, qu.score from Questionnaire q left join q.questionnaireShiroUser qu left join q.groups cluster where qu.user.id = " + it.user.id + " and cluster.id = " + it.group.id + " order by q.id asc").eachWithIndex{ quest , i ->
                total ++
                if (totalInstances == -1 ||(i < totalInstances)){
                    if(quest[0] < qIdMax){
                        idList.add(quest[0])
                        scoreList.add(quest[1])
                    }
                    totalScore += quest[1]
                }

            }
            String localResult = ""
            idList.eachWithIndex{index,i ->
                double value = 1
                if(qTime.containsKey(index)){
                    value = qTime.get(index)
                }
                localResult += (i + 1) + ":" + value + " "
            }
            totalScore = totalScore/total
            if (totalScore >= 5){
                localResult = "1 " + localResult
            }else{
                localResult = "0 " + localResult
            }
            result.add(localResult)
        }
        return result
    }

    private static Map<String,ArrayList<String>> generateData(groupId,totalInstances){
        ArrayList<String> result = new ArrayList<String>()
        ArrayList<String> userIdList = new ArrayList<String>()
        HashMap<String,ArrayList<String>> resultMap = new HashMap<String,ArrayList<String>>()
        int total = 0
        ClusterPermissions.findAllByGroupAndPermission(Cluster.get(groupId),0).each{
            HashMap<Long,Double> qTime = new HashMap<Long,Double>()
            ArrayList<Long> idList = new ArrayList<Long>()
            userIdList.add(it.user.id)
            ArrayList<Long> scoreList = new ArrayList<Long>()

            double totalScore = 0
            Questionnaire.executeQuery("Select q.id, max(s.submissionDate), q.endDate, q.startDate " +
                    "from Questionnaire q left join q.questionnaireShiroUser qu left join q.questionnaireProblem qp left join q.groups cluster, Submission s " +
                    "where qu.user.id = ? and cluster.id = ? and " +
                    "qu.user.id = s.user.id and qp.problem.id = s.problem.id and s.evaluation = ? " +
                    "and s.submissionDate < q.endDate group by q.id",
                    [it.user.id, it.group.id, EvaluationStatus.CORRECT]
            ).eachWithIndex{ instance,i->
                double percentTime = instance[1].getTime() - instance[3].getTime()
                if (percentTime > 0){
                    percentTime = percentTime/(instance[2].getTime() - instance[3].getTime())
                }else{
                    percentTime = 0
                }
                qTime.put(instance[0],percentTime)


            }
            total = 0
            Questionnaire.executeQuery("Select q.id, qu.score from Questionnaire q left join q.questionnaireShiroUser qu left join q.groups cluster where qu.user.id = " + it.user.id + " and cluster.id = " + it.group.id + " order by q.id asc").eachWithIndex{ quest , i ->
                total ++
                if (totalInstances == -1 ||(i < totalInstances)){
                    idList.add(quest[0])
                    scoreList.add(quest[1])
                    totalScore += quest[1]
                }

            }
            String localResult = ""
            idList.eachWithIndex{index,i ->
                double value = 1
                if(qTime.containsKey(index)){
                    value = qTime.get(index)
                }
                localResult += (i + 1) + ":" + value + " "
            }
            totalScore = totalScore/total
            if (totalScore >= 5){
                localResult = "1 " + localResult
            }else{
                localResult = "0 " + localResult
            }
            result.add(localResult)
        }
        try{
            resultMap.put("PREDICTION",result)
            resultMap.put("USER_LIST",userIdList)
            resultMap.put("N_QUEST",total)

        }catch (Exception e){
            return null
        }
        return resultMap

    }
}
