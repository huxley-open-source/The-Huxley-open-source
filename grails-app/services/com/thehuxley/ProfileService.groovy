package com.thehuxley


class ProfileService {

    def institutionService

    /**
     * Este método retorna o número de problemas que faltam ser resolvidos pelo usuário.
     * @param profile corresponde ao profile do usuário.
     *
     * @return retorna o número de problemas.
     */
    def problemsToBeSolved(Profile profile) {
		def totalProblems = Problem.countByStatus(Problem.STATUS_ACCEPTED)

		if (profile) {
			 totalProblems -= profile.problemsCorrect
		}

		totalProblems
    }

    /**
     * Essa função só tem visibilidade pública para que possamos fazer os testes
     * automátizados.
     */
    public Map<String, Double> mountDataForChart(id){
        id = new Long(id)

        // Quantidade total de cada tópico associado aos questionários do usuário
        String allTopicsQuery = "SELECT t.name, count(t.id) from Topic t " +
                "join t.problems tp "+
                "where tp.id in " +
                "(SELECT qp.problem.id from QuestionnaireShiroUser qu, QuestionnaireProblem qp " +
                "where qu.user.id=? and qu.questionnaire.id = qp.questionnaire.id) "+
                "group by t.id"

        // Quantidade de tópicos respondidos corretamente associado aos questionários do usuário
        String correctTopicQuery = "SELECT t.name, count(t.id) from Topic t " +
                "join t.problems tp "+
                "where tp.id in " +
                "(SELECT qp.problem.id from QuestionnaireShiroUser qu, QuestionnaireProblem qp " +
                "where qu.user.id=? and qu.questionnaire.id = qp.questionnaire.id and qp.problem.id in " +
                " (SELECT s.problem.id from Submission s where s.user.id = ? and s.evaluation = ?)) "+
                "group by t.id"


        List totalOfTopics = ShiroUser.executeQuery(allTopicsQuery, [id]);
        List correctTopics = ShiroUser.executeQuery(correctTopicQuery, [id, id, EvaluationStatus.CORRECT]);

        HashMap<String, Double> result = new HashMap<String, Double>();

        /* Monta um map com os tópicos corretos. O valor da hash será,
           * temporariamente, a quantidade de tópicos corretos encontrada.
           */

        for (List element : correctTopics) {
            String topicName = element[0];
            Long topicCount = element[1];

            result.put(topicName,topicCount);
        }

        /*
           * Agora, percorre a lista de todos os tópicos para fazer o percentual
           * de acerto.
           */
        for (List element : totalOfTopics) {
            String topicName = element[0];
            Long topicCount = element[1];

            Double value = result.get (topicName);
            if (value==null){
                result.put (topicName, 0);
            }else{
                result.put (topicName, (value/topicCount.toDouble())*100 );
            }
        }
        return result;
    }



    def publicFields(Profile instance, lazy = false) {

        def result = [
            id: instance.hash,
            name: instance.name,
            photo: instance.photo,
            smallPhoto: instance.smallPhoto ,
            dateCreated: instance.dateCreated,
            lastUpdated: instance.lastUpdated,
            institution: institutionService.publicFields(instance.institution, true),
            problemsCorrect: instance.problemsCorrect,
            problemsTryed: instance.problemsTryed,
            submissionCorrectCount: instance.submissionCorrectCount,
            submissionCount: instance.submissionCount,
            lastLogin: instance.user.lastLogin,
            topCoderPosition: instance.user.topCoderPosition,
            topCoderScore: instance.user.topCoderScore,
        ]

        if (!lazy) {
            result.putAll([

            ])
        }

        result
    }

    def publicFields(List<Profile> list, lazy = false) {

        def result = []

        list.each {
            result.add(publicFields(it, lazy))
        }

        result
    }


}
