package com.thehuxley

import java.io.Serializable;


//TODO, colocar as listas dessa classe no cache do hibernate
class Language implements Serializable{	
	//nome da linguagem
	String name
	//C�digo para compara��o por pl�gio
	/*
	 * supportedLanguages = ["java", "jsp", "cpp", "c", "php", "ruby", "fortran"]
	 * 
	 */
	
	String plagConfig
	//prefixo usado para iniciar o executavel
	String execParams
	//prefixo para compilar o c�digo fonte
	String compileParams
	//caminho do compilador
	String compiler
	String script
	String extension
	
    static constraints = {
		name              (blank:false, unique:true)
		plagConfig        (blank:false)
		compileParams     (blank:true)
		compiler          (blank:false)
		execParams        (blank:true)
	}
	
	String toString() {
		return name
	}
}


