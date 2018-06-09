<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>login</title>
  <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.12.3.min.js"></script>
  <link rel="stylesheet" href="//cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css">
  <link rel="stylesheet"  href="${pageContext.request.contextPath}/css/style.css">
  <script type="text/javascript" src="//cdn.bootcss.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

</head>
<body>
<div class="container vertical-center">
  <div class="row">
    <div class="col-md-offset-3 col-md-6">
      <form class="form-horizontal" action="loginvalidate" method="post">
        <span class="heading">WebChat</span>
        <div class="form-group">
          <input type="text" name="username" class="form-control" id="inputname" placeholder="用户名" required autofocus>
          <i class="fa fa-user"></i>
        </div>
        <div class="form-group help">
          <input type="password" name="password" class="form-control" id="inputpwd" placeholder=" 密 码 " required autocomplete="new-password">
          <i class="fa fa-lock"></i>
          <a href="#" class="fa fa-question-circle"></a>
        </div>
        <!--
        <div class="form-group help">
          <input type="text"  name="pic" class="form-control" id="inputverify" placeholder="验证码" required>
          <i class="fa fa-lock"></i>
          <a href="#" class="fa fa-question-circle"></a>
        </div>
        <img src="authImg" width="120" height="40" onClick="change()" id="picture">
        -->
        <div class="form-group">
          <div class="main-checkbox">
            <input type="checkbox" value="None" id="checkbox1" name="check"/>
            <label for="checkbox1"></label>
          </div>
          <span class="text">记住我</span>
          <button type="submit" class="btn btn-default">登录</button>
        </div>
      </form>
    </div>
  </div>
</div>
</body>
</html>
