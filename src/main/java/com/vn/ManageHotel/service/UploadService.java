package com.vn.ManageHotel.service;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;

@Service
public class UploadService {
    private final ServletContext servletContext;

    public UploadService(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    public String handleSaveUploadFile(MultipartFile file, String targetFile) {
        String finalName = "";
        String rootPath = this.servletContext.getRealPath("/resources/images");
        try {
            byte[] bytes = file.getBytes();
            File dir = new File(rootPath + File.separator + targetFile);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            // Tao file server
            finalName = System.currentTimeMillis() + "-" + file.getOriginalFilename();
            File serverFile = new File(dir.getAbsolutePath() + File.separator + finalName);
            BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream((serverFile)));
            stream.write(bytes);
            stream.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
        return finalName;
    }

    public String getPath(String targetFile) {

        return File.separator + "images" + File.separator + targetFile + File.separator;
    }

    public void handleDeleteFile(String nameFile, String targetFile) {
        String rootPath = this.servletContext.getRealPath("/resources/images");
        File dir = new File(rootPath + File.separator + targetFile);
        File serverFile = new File(dir.getAbsolutePath() + File.separator + nameFile);
        // System.out.println(">>>>>>>CCCCheck " + dir.getAbsolutePath() +
        // File.separator + nameFile);
        serverFile.delete();
    }
}
