package com.thehuxley

import java.io.Serializable;


/**
 * Cada objeto dessa classe representa uma submissão que foi feita para um determinado
 * problema em uma determinada linguagem.
 * @author rodrigo
 *
 */
class CPDQueue implements Serializable{	
	
	long problemId;
    long institutionId;
	String language;
	
	public CPDQueue(long problemId, String language, long institutionId){
		this.problemId = problemId;
		this.language = language;
        this.institutionId = institutionId;
	}
	
	public CPDQueue(){
		super();
	}
	
	public static void deleteAll(){
		CPDQueue.executeUpdate("delete CPDQueue");
	}	
}
