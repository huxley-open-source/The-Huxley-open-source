package com.thehuxley

import java.io.Serializable;
import java.util.SortedSet;

class Plagium implements Serializable{

    class PlagiarismStatus {
        static byte WAITING = 0;
        static byte CONFIRMED = 1;
        static byte DISCARDED = 2;

    }

	List fragments
	Submission submission1
	Submission submission2
	double percentage
    byte status = PlagiarismStatus.WAITING

	
	static hasMany = [ fragments : Fragment ]

}
