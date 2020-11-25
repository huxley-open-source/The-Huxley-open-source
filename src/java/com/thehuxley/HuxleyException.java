package com.thehuxley;

public class HuxleyException extends Exception {

	public HuxleyException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}

	public HuxleyException(String arg0) {
		super(arg0);
	}

	public HuxleyException(Throwable arg0) {
		super(arg0);
	}

}
