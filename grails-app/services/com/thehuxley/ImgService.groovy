package com.thehuxley

import java.security.MessageDigest
import java.awt.image.BufferedImage
import java.awt.Graphics2D
import com.thehuxley.util.HuxleyProperties
import javax.imageio.ImageIO
import java.awt.Graphics
import java.awt.Color
import java.awt.Font

/**
 * Created with IntelliJ IDEA.
 * User: romero
 * Date: 15/08/12
 * Time: 22:59
 * To change this template use File | Settings | File Templates.
 */
class ImgService {

    public String uploadImage(params,request){
        String imageDir = HuxleyProperties.getInstance().get("image.profile.save.dir") + "temp/"
        InputStream inputStream = request.getInputStream()
        String originalFilename = params.qqfile
        String extension = originalFilename.substring(originalFilename.lastIndexOf("."), originalFilename.size())
        MessageDigest md
        md = MessageDigest.getInstance("MD5")
        Long time = System.currentTimeMillis()
        String filename = time.toString() + originalFilename
        BigInteger hash = new BigInteger(1,md.digest(filename.getBytes()))
        filename = hash.toString(16)
        filename += extension
        String filePath = imageDir + filename
        BufferedImage originalImage =  ImageIO.read(inputStream)
        //BufferedImage resizedImage = new BufferedImage(144, 192, originalImage.getType());
        //Graphics2D g = resizedImage.createGraphics();
        //g.drawImage(originalImage, 0, 0, 144, 192, null);
        //g.dispose();
        File outputfile = new File(filePath);
        ImageIO.write(originalImage, "png", outputfile);
        inputStream.close();
        return filename ;//resource(dir:'images/app/profile/temp', file:filename)

    }

    public resize(String filename){
        println 'oi'
        try {
            String filePath = HuxleyProperties.getInstance().get("image.profile.save.dir") + "temp/" + filename
            println filePath
            File inputFile = new File(filePath)
            if(inputFile.exists()) {
                BufferedImage originalImage =  ImageIO.read(inputFile)
                BufferedImage resizedImage = new BufferedImage(144, 192, originalImage.getType());
                Graphics2D g = resizedImage.createGraphics();
                g.drawImage(originalImage, 0, 0, 144, 192, null);
                g.dispose();
                File outputfile = new File(filePath);
                return ImageIO.write(resizedImage, "png", outputfile);
            } else {
                println 'n existe'
            }
        } catch (e) {
            println e
        }

        return false

    }

    public boolean crop(String filename, float x, float y, float width, float height) {
        println("qwer")
        println(HuxleyProperties.getInstance().get("image.profile.save.dir") + "temp/" + filename);
        String outPutFile = HuxleyProperties.getInstance().get("image.profile.save.dir") + "temp/c" + filename
        int xCrop = x;
        println(xCrop)
        int yCrop = y;
        int heightCrop = height;
        int widthCrop = width;
        try {
            File image = new File(HuxleyProperties.getInstance().get("image.profile.save.dir") + "temp/" + filename)
            if(image.exists()){
                BufferedImage bufferedImage = ImageIO.read(image)
                File outPutImage = new File(outPutFile)
                return ImageIO.write(bufferedImage.getSubimage(xCrop, yCrop, widthCrop, heightCrop), "png", outPutImage)
            } else {
                println("nao foi encontrado")
                return false
            }
        } catch (e) {
            println(e)
        }

        return false
    }

    public void chooseImg(tempImage){
        println tempImage
        String filename = tempImage
        BufferedImage resizedImage
        BufferedImage thumb
        Graphics2D g
        String imageDirDest = HuxleyProperties.getInstance().get("image.profile.save.dir")
        String filePath = imageDirDest + "temp/" + filename
        println "dest: " + imageDirDest
        println "temp: " + filePath
        File file = new File(filePath);
        File dir = new File(imageDirDest);
        boolean ok = file.renameTo(new File(dir, file.getName()));
        filePath = HuxleyProperties.getInstance().get("image.profile.save.dir") + filename
        String thumbPath = HuxleyProperties.getInstance().get("image.profile.save.dir") + "thumb/" +filename
        BufferedImage originalImage =  ImageIO.read(new File(filePath))
        File outputfile = new File(thumbPath);
        if(originalImage.width > 195 || originalImage.height >155) {
            resizedImage = new BufferedImage(195, 155, originalImage.getType());
            g = resizedImage.createGraphics();
            g.drawImage(originalImage, 0, 0, 195, 155, null);
            thumb = resizedImage.getSubimage (23, 0, 172, 155)
        } else {
            thumb = originalImage.getSubimage (23, 0, 172, 155)
        }
        resizedImage = new BufferedImage(64, 64, originalImage.getType());
        g = resizedImage.createGraphics();
        g.drawImage(thumb, 0, 0, 64, 64, null);
        g.dispose();
        ImageIO.write(resizedImage, "png", outputfile);

    }

    public String generateCaptcha(captcha){
        String hashCaptcha
        try {
            String imageDir = HuxleyProperties.getInstance().get("local.image.profile.save.dir") + "temp/"
            MessageDigest md
            md = MessageDigest.getInstance("MD5")
            BigInteger hash = new BigInteger(1,md.digest(captcha.getBytes()))
            hashCaptcha = hash.toString(16)
            String filename = hashCaptcha
            String filePath = imageDir + filename + ".png"
            File outputFile = new File(filePath)
            int width = 200, height = 200;
            BufferedImage buffer = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
            Graphics g = buffer.createGraphics();
            g.setColor(Color.WHITE);
            g.fillRect(0, 0, width, height);
            Font font = new Font("Verdana", Font.BOLD, 30);
            g.setColor(Color.BLUE);
            g.setFont(font);
            g.drawString(captcha, 0, 20);
            ImageIO.write(buffer, "png", outputFile);

        } catch (e) {
            println e
            println e.getStackTrace()
        }
        return hashCaptcha
    }

}
