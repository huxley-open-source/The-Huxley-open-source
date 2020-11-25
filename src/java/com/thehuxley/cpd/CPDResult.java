/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.thehuxley.cpd;

import java.util.StringTokenizer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 
 * @author rodrigo
 */
public class CPDResult {

	private final String fileName1;
	private final int numberOfTokens1;
	private final int file1BeginLine; // linha que demarca o inicio do plágio no arquivo 1
	
	
	private final String fileName2;
	private final int numberOfTokens2;
	private final int file2BeginLine; // linha que demarca o início do plágio no arquivo 2
	
	private final int plagiarizedTokenCount;
	private final int lineCount; //total de linhas duplicadas
	
	/** Percentual de tokens plagiados */
	private final double percentage;
	private final static String FS = System.getProperty("file.separator");
	private final static String LS = System.getProperty("line.separator");
	public static final int ROOT_LEVEL_ATTEMPT = -1;
	public static final int ROOT_LEVEL_LANGUAGE = -2;
	public static final int ROOT_LEVEL_USER = -3;
	public static final int ROOT_LEVEL_PROBLEM = -4;
	
	private static final Log log = LogFactory.getLog(CPDResult.class);


	public CPDResult(String fileName1, int numberOfTokens1, String fileName2,
			int numberOfTokens2, int plagiarizedTokenCount,
			int file1BeginLine, int file2BeginLine, int lineCount) {
		
		this.fileName1 = fileName1;
		this.numberOfTokens1 = numberOfTokens1;
		this.fileName2 = fileName2;
		this.numberOfTokens2 = numberOfTokens2;
		this.plagiarizedTokenCount = plagiarizedTokenCount;
		this.file1BeginLine = file1BeginLine;
		this.file2BeginLine = file2BeginLine;
		this.lineCount = lineCount;

		if (numberOfTokens1 < numberOfTokens2) {
			percentage = (double) plagiarizedTokenCount
					/ (double) numberOfTokens1;
		} else {
			percentage = (double) plagiarizedTokenCount
					/ (double) numberOfTokens2;
		}

	}

	/**
	 * Retorna o maior percentual de plágio encontrado. Ou seja, verifica qual é
	 * o menor arquivo e retorna o percentual de tokens plagiados desse arquivo
	 * menor.
	 * 
	 * @return
	 */
	public double getPercentage() {
		return percentage;
	}
	
	public String getUserFromFile1(){
		return getLevel(fileName1,ROOT_LEVEL_USER);
	}
	
	public String getAttemptFromFile1(){
		return getLevel(fileName1,ROOT_LEVEL_ATTEMPT);
	}
	
	public String getUserFromFile2(){
		return getLevel(fileName2,ROOT_LEVEL_USER);
	}
	
	public String getAttemptFromFile2(){
		return getLevel(fileName2,ROOT_LEVEL_ATTEMPT);
	}
	
	public String getProblem(){
		return getLevel(fileName1,ROOT_LEVEL_PROBLEM);
	}
	
	public int getFile1BeginLine() {
		return file1BeginLine;
	}

	public int getFile2BeginLine() {
		return file2BeginLine;
	}

	public int getLineCount() {
		return lineCount;
	}

	private String getLevel(String fileName, int level){
		if (fileName==null){
			log.warn("Recebendo o parâmetro filename=null");
			return null;
		}
		StringTokenizer tokenizer = new StringTokenizer(fileName, FS);
        int total = tokenizer.countTokens();

		// anda até level -1
        for (int i = 1; i < (total + level); i++) {
            if (tokenizer.hasMoreElements()) {
            	tokenizer.nextElement();
            }
        }
        //pega level
        if (tokenizer.hasMoreElements()){ //o if é necessário quando o arquivo é vazio
        	return tokenizer.nextElement().toString();
        }else{
        	return null;
        }
	}

	/**
	 * level ==1 , problema (-4) level ==2 , usuario (-3) level ==3 , linguagem
	 * (-2) level ==4 , tentativa (-1)
	 * 
	 * @param level
	 * @return
	 */
	public boolean hasSameRoot(int level) {
        StringTokenizer tokenizer1 = new StringTokenizer(fileName1, FS);
        StringTokenizer tokenizer2 = new StringTokenizer(fileName2, FS);

        int total1 = tokenizer1.countTokens();
        int total2 = tokenizer2.countTokens();
        if (total1 != total2) {
            log.warn("Houve uma tentativa de comparar arquivos com diretórios raízes diferentes. [" + fileName1 +"] ["+fileName2+"]");
            return false;
        }

        // anda até level -1
        for (int i = 1; i < (total1 + level); i++) {
            if (tokenizer1.hasMoreElements() && tokenizer2.hasMoreElements()) {
                if (!tokenizer1.nextElement().toString().equals(tokenizer2.nextElement().toString())) {
                    return false;
                }
            } else {
                return false;
            }
        }
        //pega level
        if (tokenizer1.hasMoreElements() && tokenizer2.hasMoreElements()) {
            String root1 = tokenizer1.nextElement().toString();
            String root2 = tokenizer2.nextElement().toString();
            return root1.equals(root2);
        } else {
            return false;
        }
    }

	public String getFileName1() {
		return fileName1;
	}

	public String getFileName2() {
		return fileName2;
	}

	public String toString() {

		return fileName1 + LS + fileName2 + LS
				+ "Percentual: " + getPercentage() + LS ;
	}
}
