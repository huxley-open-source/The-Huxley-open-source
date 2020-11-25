package com.thehuxley

import com.thehuxley.util.HuxleyProperties
import org.springframework.web.multipart.MultipartFile

import javax.imageio.ImageIO
import java.awt.image.BufferedImage
import java.security.MessageDigest

class ManagerService {


    def hashString (element) {
        MessageDigest md
        md = MessageDigest.getInstance("MD5")
        Long time = System.currentTimeMillis()
        String toHash = time.toString() + element
        BigInteger hash = new BigInteger(1,md.digest(toHash.getBytes()))
        return hash.toString(16)
    }
    def saveDocument(params,request) {

        def imageDir = HuxleyProperties.getInstance().get("image.doc.save.dir")
        def result = []

        request.getFileNames().each {
            byte[] buffer = new byte[8 * 1024];

            MultipartFile file = request.getFile(it);
            def inputStream = file.getInputStream();
            String originalName = file.getOriginalFilename();
            def outputName = hashString(originalName) + originalName.substring(originalName.lastIndexOf("."), originalName.size())

            def outputStream = new FileOutputStream(imageDir + outputName)
            try {
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            } finally {
                inputStream.close();
                outputStream.close();
            }

            result.add([name: file.getOriginalFilename(), size: file.getSize() / 1024 + " Kb", hash: outputName])

        }

        return result //resource(dir:'images/app/profile/temp', file:filename)
    }
}
