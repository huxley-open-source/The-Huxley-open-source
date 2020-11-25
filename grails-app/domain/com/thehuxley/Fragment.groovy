package com.thehuxley

import java.io.Serializable;

class Fragment implements Serializable{
	
	int numberOfLines	
	int startLine1
	int startLine2		
	double percentage 
	
	static belongsTo = [ plagium : Plagium ]
	
	
}
