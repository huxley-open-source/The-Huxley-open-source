package com.thehuxley

import java.io.Serializable;

class QuestionnaireStatistics implements Serializable{
	
	Questionnaire questionnaire
	Cluster group
	double averageNote
	double standartDeviaton
	double greaterThenEqualsSeven
	double lessSeven
	double tryPercentage

}
