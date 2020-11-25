package com.thehuxley

import java.io.Serializable;

class TestCase implements Serializable{
	
	public static final int TYPE_NORMAL = 0
	public static final int TYPE_EXAMPLE = 1
    public static final float OUTPUT_PERCENTAGE = 1.3

	Problem problem
	String input
	String output
	int type
    double maxOutputSize = 0
    String tip
    int rank = 0
    int unrank = 0

	static mapping = {
		input (type:"text")
		output (type:"text")
        tip (type:"text")
	}

    static constraints = {
        tip (nullable:true)
    }

    public def calculateMaxOutputSize(){
        byte[] outputBytes = this.output.getBytes()
        if(OUTPUT_PERCENTAGE * outputBytes.length < 785){
            this.maxOutputSize = 785
        } else {
            this.maxOutputSize = OUTPUT_PERCENTAGE * outputBytes.length
        }

    }

    def beforeValidate() {
        if(maxOutputSize == 0){
            calculateMaxOutputSize()
        }

    }
}
