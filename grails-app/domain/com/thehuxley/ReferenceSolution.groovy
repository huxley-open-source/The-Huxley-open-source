package com.thehuxley

import java.io.File;
import java.io.Serializable;
import java.util.Date
import com.thehuxley.util.HuxleyProperties;

//import com.thehuxley.util.HuxleyProperties;

class ReferenceSolution implements Serializable{
	public static final short STATUS_WAITING = 1;
	public static final short STATUS_ACCEPTED = 2;
	public static final short STATUS_REJECTED = 3;
	
	
	Problem problem
	Language language
	String referenceSolution
	short status
	ShiroUser userSuggest
	ShiroUser userApproved
	Date submissionDate
	String comment
	String reply
	static constraints = {		
		userApproved(nullable: true, blank: true)
		submissionDate(nullable: true, blank: true)
		comment (type:"text", nullable: true, blank: true)
		reply (type:"text", nullable: true, blank: true)
	}
	public File downloadFileCode(){
		File file = null;
		try{
			file = new File(HuxleyProperties.getInstance().get ("problemdb.dir")+this.referenceSolution)
		}catch (e){
			e.printStackTrace()
		}
		return file
	}
	public String downloadCode(){
		String code = ""
		Scanner sc;
			 String temp
			  try
			  {
				 BufferedReader br = new BufferedReader(new FileReader(downloadFileCode()));
	   
				 while ( br.ready() ) {
					code +=  br.readLine()+ '\n';
				 }
			  }
			  catch (FileNotFoundException e)
			  {
				 e.printStackTrace();
			  }
			  return code
	}
	
}
