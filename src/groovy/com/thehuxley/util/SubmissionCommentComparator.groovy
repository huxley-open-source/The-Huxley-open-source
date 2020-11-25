package com.thehuxley.util

import java.util.Comparator;

import com.thehuxley.SubmissionComment;

class SubmissionCommentComparator implements Comparator {
    
    public int compare(Object o1, Object o2) {
        SubmissionComment ob1 = (SubmissionComment)o1;
        SubmissionComment ob2 = (SubmissionComment)o2;
        if( ob1.id == ob2.id ) {
            return 0;    
        } else if( ob1.id < ob2.id ) {
            return -1;
        } else if( ob1.id > ob2.id ) {
            return 1;
        }
        return 0;
    }    
}
