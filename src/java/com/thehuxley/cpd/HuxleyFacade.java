package com.thehuxley.cpd;

import com.thehuxley.util.HuxleyProperties;

public class HuxleyFacade {

	private static HuxleyFacade singleton;

	private HuxleyFacade() {

	}

	public static HuxleyFacade getInstance() {
		if (singleton == null) {
			singleton = new HuxleyFacade();
		}
		return singleton;
	}

	public void verifyPlagiarizedSubmissions() {
		CPDAdapter cpdAdapter = new CPDAdapter(HuxleyProperties
				.getInstance().get("submission.dir"));
		cpdAdapter.verify();
	}

}
