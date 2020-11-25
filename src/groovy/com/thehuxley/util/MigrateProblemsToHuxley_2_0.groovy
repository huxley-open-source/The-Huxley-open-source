package com.thehuxley.util

import groovy.sql.Sql

import java.sql.SQLException


class MigrateProblemsToHuxley_2_0 {
	
	static String fileSeparator = System.getProperty("file.separator");
	static String lineSeparator = System.getProperty("line.separator");
	
	static int contador = 0;

	static void main(def args){
		
//		ArrayList<String> inList = new ArrayList<String>()
//		ArrayList<String> outList = new ArrayList<String>()
//
//		String strRootDir = "/home/rodrigo/Área de Trabalho/tomcat6/webapps/huxley/banco";
//		
//
//		def sql = Sql.newInstance("jdbc:mysql://localhost:3306/huxley-prod", "huxley","huxley", "com.mysql.jdbc.Driver")
//
//		boolean error;
//
//
//		File rootDir = new File(strRootDir);
//
//		File[] files = rootDir.listFiles();
//
//		for (int i = 0; i < files.length; i++) {
//			String strProblemId = files[i].getName()
//			try{
//				if (files[i].isDirectory()){
//					error = false;
//					
//
//					String strInput = files[i].getPath() + fileSeparator + "input.in";
//					String strOutput = files[i].getPath() + fileSeparator + "output.out";
//					String strDesc = files[i].getPath() + fileSeparator + "desc.txt";
//
//					BufferedReader inputFile = new BufferedReader(new FileReader(strInput));
//					BufferedReader outputFile = new BufferedReader(new FileReader(strOutput));
//					BufferedReader descFile = new BufferedReader(new FileReader(strDesc));
//
//					// Povoar o array de entrada
//					fillArrayList(inList, inputFile);
//
//					// Povoar o array de saída
//					fillArrayList(outList, outputFile);
//
//					if (inList.size() == 1 || outList.size() == 1){
//						println "[AVISO ("+strProblemId+")] Caso de teste unico";
//					}else if (inList.size() == 0 || outList.size() == 0){
//						println "[ERRO ("+strProblemId+")] Caso de teste vazio";
//						error = true;
//					}else if (inList.size() != outList.size() ){
//						println "[AVISO ("+strProblemId+")] Caso de teste com tamanhos diferentes";
//					}
//
//					if (!error){
//						
//						// Colocar entrada e saída no banco de dados
//						int min = Math.min(inList.size(), outList.size());
//						for (int j = 0; j < min; j++) {
//
//							try{
//								def type = (j==0)? 1 : 0;
//								sql.execute("insert into test_case ( version, input, output,problem_id, type) values (1, ?, ?,?,?)",[
//									inList.get(j),
//									outList.get(j),
//									strProblemId,
//									type
//								]);
//							}catch(SQLException e){
//								error = true;
//								print "[ERRO ("+strProblemId+")] "
//								e.printStackTrace();
//							}
//						}
//						
//						if (!error){
//							// Ler o arquivo de texto com a descricao
//							String strLine = null
//							boolean boolDescription = false;
//							boolean boolInputFormat = false;
//							boolean boolOutputFormat = false;
//							
//							String strDescription = "";
//							String strInputFormat = "";
//							String strOutputFormat = "";
//							
//							while( ((strLine = descFile.readLine()) != null)){
//								if (strLine.toLowerCase().startsWith("descri")){
//									boolDescription = true;
//									continue;
//								}else if (strLine.toLowerCase().startsWith("formato da entrada")){
//									boolDescription = false;
//									boolInputFormat = true;
//									continue;
//								}else if (strLine.toLowerCase().startsWith("formato da sa")){
//									boolInputFormat = false;
//									boolOutputFormat = true;
//									continue;
//								}else if (strLine.toLowerCase().startsWith("exemplo de entrada")){
//									break;
//								}
//								
//								if (boolDescription){
//									strDescription+=strLine+"<br />";
//								}else if (boolInputFormat){
//									strInputFormat+=strLine+"<br />";
//								}else if (boolOutputFormat){
//									strOutputFormat +=strLine+"<br />";
//								}							
//							}
//							
//							if (strDescription.equals("") || strInputFormat.equals("") || strOutputFormat.equals("")){
//								println "[ERRO ("+strProblemId+")] Descricao, Formato de Entrada ou Formato de Saida Vazio. Problema: "+strProblemId
//							}else{
//								sql.execute("update problem SET  description=?, input_format=?, output_format=? WHERE id=?", [strDescription,strInputFormat,strOutputFormat,strProblemId]);
//							}
//						}
//					}
//					inputFile.close();
//					outputFile.close();
//					descFile.close();
//				}
//
//			}catch(Exception e){
//				print "[ERRO ("+strProblemId+")] "
//				println e.printStackTrace()
//			}
//		}// end FOR

	}

	private static fillArrayList(ArrayList myList, BufferedReader myFile) {
		
		myList.clear();
		String strLine = null
		while( ((strLine = myFile.readLine()) != null)){
			String entry= strLine + lineSeparator;
			while(((strLine = myFile.readLine()) != null)&&!strLine.equals("#problem")){
				entry+= strLine + lineSeparator
			}
			myList.add(entry);
		}
	}
}
