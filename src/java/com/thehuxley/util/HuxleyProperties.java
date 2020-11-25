/**
 * 
 */
package com.thehuxley.util;

import java.util.ResourceBundle;

/**
 * PatternBox: "Singleton" implementation.
 * <ul>
 * <li>defines an Instance operation that lets clients access its unique
 * instance. Instance is a class operation</li>
 * <li>may be responsible for creating its own unique instance.</li>
 * </ul>
 * 
 * @author <a href="mailto:dirk.ehms@patternbox.com">Dirk Ehms</a>
 * @author rodrigo
 */
public class HuxleyProperties {

	/** unique instance */
	private static HuxleyProperties sInstance = null;

	private ResourceBundle resource;

	/**
	 * Private constuctor
	 */
	private HuxleyProperties() {
		resource = ResourceBundle.getBundle("huxley");
	}

	/**
	 * Get the unique instance of this class.
	 */
	public static synchronized HuxleyProperties getInstance() {

		if (sInstance == null) {
			sInstance = new HuxleyProperties();
		}

		return sInstance;

	}

	/**
	 * This is just a dummy method that can be called by the client. Replace
	 * this method by another one which you really need.
	 */
	public String get(String key) {
		return resource.getString(key);
	}

}
