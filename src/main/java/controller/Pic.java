package controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

//验证码获取
@Controller
public class Pic {
@RequestMapping(value="/authImg")
public String getpic(){
	return "authImg";
}
}
