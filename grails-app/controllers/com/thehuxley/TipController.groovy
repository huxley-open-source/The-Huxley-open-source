package com.thehuxley

import grails.converters.JSON

class TipController {

    def memcachedService

    def index =  {

        List problemList = Problem.executeQuery("select distinct t.problem from TestCase t where t.tip is null order by t.problem.name")
        [problemList: problemList]
    }

    def searchTestCase = {
        List testC = Problem.executeQuery("select t from TestCase t where t.problem.id =:pId", [pId: Long.parseLong(params.pId)])
        def  WA, PE, CE, EA, RE, TLE

        render(contentType:"text/json") {
            testCaseList = array {
                testC.each {  tc ->
                    WA = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.WRONG_ANSWER, tId: tc.id])
                    PE = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.PRESENTATION_ERROR, tId: tc.id])
                    CE = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.COMPILATION_ERROR, tId: tc.id])
                    EA = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.EMPTY_ANSWER, tId: tc.id])
                    RE = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.RUNTIME_ERROR, tId: tc.id])
                    TLE = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.TIME_LIMIT_EXCEEDED, tId: tc.id])

                    testCase pName: tc.problem.name, rank: tc.rank, unrank: tc.unrank, tId: tc.id, tip: tc.tip, WA: WA, PE: PE, CE: CE, EA: EA, RE: RE, TLE: TLE
                }
            }
        }
    }

    def searchProblem = {

        String name = params.ss
        ArrayList<Problem> problems = Problem.findAllByNameLike("%"+name+"%",[max:"5"])
        render(contentType:"text/json") {
            problemList = array {
                problems.each {
                    problem id:it.id , name:it.name
                }
            }
        }
    }


    def searchProblemWithTip = {

        def cont = 0;
        def testCaseInfo =   memcachedService.get("test-case-id:$cont", 24 * 60 * 60) {
            ArrayList<TestCase> testCaseListWithTip
            def result = []

            if (params.sort == 'unrank') {
                testCaseListWithTip = TestCase.findAllByTipIsNotNull([sort:params.sort, order:'desc'])
            } else {
                testCaseListWithTip = TestCase.findAllByTipIsNotNull([sort:params.sort, order:'asc'])
            }
            testCaseListWithTip.each {   tc ->
                def wrongAnswer = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.WRONG_ANSWER, tId: tc.id])
                def presentationError = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.PRESENTATION_ERROR,tId: tc.id])
                def compilationError = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.COMPILATION_ERROR,tId: tc.id])
                def emptyAnswer = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.EMPTY_ANSWER,tId: tc.id])
                def runtimeError = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.RUNTIME_ERROR,tId: tc.id])
                def timeLimitExceeded = Submission.executeQuery("select count (s) from Submission s where s.evaluation =:evaluation and s.testCase.id =:tId", [evaluation: EvaluationStatus.TIME_LIMIT_EXCEEDED,tId: tc.id])

                result.add ([
                    pName: tc.problem.name,
                    pId: tc.problem.id,
                    rank: tc.rank,
                    unrank: tc.unrank,
                    tId: tc.id,
                    WA: wrongAnswer[0],
                    PE: presentationError[0],
                    CE: compilationError[0],
                    EA: emptyAnswer[0],
                    RE: runtimeError[0],
                    TLE: timeLimitExceeded[0]
                ])
            }
            (result as JSON) as String
        }

        cont = cont + 1
        render(contentType:"text/json") {
            JSON.parse(testCaseInfo)
        }

    }

    def getProblemList =  {
        ArrayList<Problem> pList = Problem.executeQuery("select distinct t.problem from TestCase t where t.tip is null order by t.problem.name")
        render(contentType:"text/json") {
            problemList = array {
                pList.each {
                    problem id:it.id , name:it.name
                }
            }
        }

    }

    def saveTip = {
        def testCase = TestCase.executeQuery("select t from TestCase t where t.problem.id =:problemId and t.id= :testCaseId", [problemId: Long.parseLong(params.pId), testCaseId: Long.parseLong(params.tId)])
        testCase[0].tip = params.tt

        if(testCase[0].save()) {
            render(contentType:"text/json") {
                status = 'ok'
            }
        }
        else {
            render(contentType:"text/json") {
                status = 'error'
            }
        }
    }

    def getAllTestCaseByProblem = {
        List tList = TestCase.executeQuery("select t from TestCase t where t.problem.id =:pId and t.tip is null", [pId: Long.parseLong(params.pId)]);
        render(contentType: "text/json") {
            testCaseList = array {
                tList.each {  tc ->
                   testCase tId: tc.id, input: tc.input, output: tc.output, pName: tc.problem.name
                }
            }
        }
    }

    def getTestCaseByProblem = {
        List tc = TestCase.executeQuery("select t from TestCase t where t.problem.id =:pId and t.id =:tId", [pId: Long.parseLong(params.pId), tId: Long.parseLong(params.tId)])
        render(contentType: "text/json") {
            testCase tip: tc[0].tip, input: tc[0].input, output: tc[0].output
        }
    }


}