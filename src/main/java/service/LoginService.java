package service;

//接口声明
public interface LoginService {
	String getpwdbyname(String name);
	Long getUidbyname(String name);
	String getnamebyid(long id);
}
