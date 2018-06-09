package controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
@RequestMapping("upload")
public class UploadController {
    @RequestMapping(value = "uploadimg",method=RequestMethod.POST)
    public String uploadimg(@RequestParam(value="file",required=false) MultipartFile file,HttpServletRequest request) throws Exception{

        String filename = file.getOriginalFilename();
        System.out.println(filename);
        String path="";

        Date date = new Date();
        String year = String.format("%tY", date);
        String month = String.format("%tB", date);
        String day = String.format("%te", date);
        Random random = new Random();
        String seed = String.valueOf((random.nextInt(9)+1));

        //生成uuid作为文件名称,保证不重名
        //String uuid = UUID.randomUUID().toString().replaceAll("-","");
        //获得文件类型（可以判断如果不是图片，禁止上传）
        String contentType=file.getContentType();
        //获得文件后缀名称
        String imageName=contentType.substring(contentType.indexOf("/")+1);
        System.out.println(imageName);
        //写入本地磁盘
        InputStream is = file.getInputStream();
        byte[] bs = new byte[1024];
        int len;
        path=year+"-"+month+"-"+day+"-"+seed+"."+"jpg";
        String imgUrl = "http://localhost:8080/uploadedFiles/" + path;
        OutputStream os = new FileOutputStream(new File("E:/WebChat/src/main/webapp/uploadfiles/" + path));
        while ((len = is.read(bs)) != -1) {
            os.write(bs, 0, len);
        }
        os.close();
        is.close();
        System.out.println(path);
        request.setAttribute("imagesPath", path);
        request.setAttribute("url", imgUrl);
        return "chatroom";

    }

}
