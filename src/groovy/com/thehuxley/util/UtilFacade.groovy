package com.thehuxley.util

import java.util.ArrayList;

import com.thehuxley.Cluster;

public class UtilFacade {
	private static UtilFacade instance;
	
	private UtilFacade(){
		
	}
	
	public static UtilFacade getInstance(){
		if(instance == null){
			instance = new UtilFacade()
		}
		return instance
	}
	
	public ArrayList<String> formarter(String param){
		ArrayList<String> paramFormated = new ArrayList<String>()
		paramFormated.add(param)
		
		return paramFormated
	}
	public ArrayList<String> formarter(String[] param){
		ArrayList<String> paramFormated = new ArrayList<String>()
		param.each{ paramFormated.add(it) }
		
		return paramFormated
	}
	public ArrayList<String> stringtoArray(String param){
		if(param.contains("[")){
			param= param.substring(1,param.size()-1)
		}
		ArrayList<String> array = new ArrayList<String>()
		StringTokenizer paramToData = new StringTokenizer(param, ",")
		while(paramToData.hasMoreElements()){
			array.add(paramToData.nextToken())
		}

		return array
	}
/**
 * Essa função usa uma lista como parametro e retorna essa lista no formato String (list[0],list[1],...,list[n])	
 * @param param
 * @return String
 */
    public String arrayToString(List param){
        String stringByArray
        stringByArray = "("
        param.each {
            stringByArray+= it + ","
        }
        stringByArray = stringByArray.substring(1,stringByArray.size()-1)
        stringByArray += ")"
        return stringByArray
    }

    public void deleteFile(String fileToDelete){
        if(fileToDelete != null) {
            try{
                File f = new File(fileToDelete)
                f.delete()
            } catch (e) {

            }
        }
    }
    /**
     * Essa função recebe uma String e filtra arquivos de imagem, tirando-os da pasta temporária e colocando na pasta de persistência
     * Ela é chamada para a criação de problemas com imagens no rich ui
     * @param text
     * @return Uma String formatada contendo os paths de imagens atualizados
     */
    public String formatProblemImage(String text){
        int index = 0;
        int finalIndex = text.lastIndexOf("<img src=\"")
        if(text.contains("temp/")){
            while(index <= finalIndex && text.substring(index).contains("temp/")){

                index = text.indexOf("<img src=\"",index)
                int firstIndex = text.indexOf("temp/",index)
                int secondIndex = text.indexOf("\"",firstIndex)
                String file = text.substring(firstIndex + 5 , secondIndex)
                index = secondIndex
                updateProblemImage(file)
            }
        }
        return text.replaceAll("temp/" , "")
    }
    /**
     * Função para retirar um arquivo da pasta temp e colocar na pasta de persistência
     * @param filename
     * @return Uma string contendo o novo path para o arquivo
     */
    public String updateProblemImage(String filename){
        try{
            String imageDirDest = HuxleyProperties.getInstance().get("image.problem.save.dir")
            String filePath =imageDirDest + "temp/" + filename
            File file = new File(filePath);
            File dir = new File(imageDirDest);
            boolean ok = file.renameTo(new File(dir, file.getName()));
            if(!ok){
                log.error("Nao foi possivel mover o arquivo " + filePath);
            }
        }catch(Exception e){

        }
    }
    public String updateProfileImage(String filename){
        try{
            String imageDirDest = HuxleyProperties.getInstance().get("image.profile.save.dir")
            String filePath =imageDirDest + "temp/" + filename
            File file = new File(filePath);
            File dir = new File(imageDirDest);

            boolean ok = file.renameTo(new File(dir, file.getName()));
            if(!ok){
                log.error("Nao foi possivel mover o arquivo " + filePath);
            }
        }catch(Exception e){

        }
    }

    public byte[] mountTopicRadarChart(long clusterId, int width, int height){
        return Cluster.get(clusterId).mountTopicRadarChart(width, height)

    }

//	public void updateQuestionnaire(long id){
//		Map<Object, Object> eventParams = new Hashtable<Object, Object>()
//		eventParams.put("QUESTIONNAIRE_ID",id)
//		Event questCreateEvent = new Event(Event.TYPE_QUESTIONNAIRE_SAVED,eventParams)
//		EventManager.getInstance().update(questCreateEvent)
//	}
}
