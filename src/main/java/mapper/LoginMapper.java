package mapper;

import po.Staff;

//接口
public interface LoginMapper {
	Staff getpwdbyname(String name);
	Staff getnamebyid(long id);
}
