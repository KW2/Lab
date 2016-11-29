<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
   
<html>
<head>
<title>실습실 예약 페이지 로그인</title>
</head>
<body>
<form action="loginCheck.jsp" method="post">
ID: <input type="text" name="userId"><br>
PW: <input type="password" name="password"><br>
<input type="submit" value="로그인"/>
</form>
</body>
</html> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<img src="img/logo_ov.png"  height="70px">
<style>
body{
background:url('img/background.jpg') no-repeat center center fixed;
-webkit-background-size:cover;
-moz-background-size:cover;
-o-background-size:cover;
background-size:cover;
}
</style>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1"> 
<!--  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> -->
<title>실습실 예약 페이지 로그인</title>
<link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<body>
 <div class="col-xs-8 col-xs-offset-2" style="margin-top: 250px;">
<form class="form-horizontal" action="loginCheck.jsp" method="post">
  <div class="form-group">
    <label for="id" class="col-sm-2 control-label">ID : </label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="id" placeholder="id입력" name="userId">
    </div>
  </div>
  <div class="form-group">
    <label for="inputPassword" class="col-sm-2 control-label">Password :</label>
    <div class="col-sm-10">
      <input type="password" class="form-control" id="inputPassword" placeholder="Password입력" name="password">
    </div>
  </div>
<!--   <div class="form-group">
    <div class="col-sm-offset-2 col-sm-10">
      <div class="checkbox">
        <label>
          <input type="checkbox"> Remember me
        </label>
      </div>
    </div>
  </div> -->
  <div class="form-group">
    <div class="col-sm-offset-2 col-sm-10">
      <button type="submit" class="btn btn-default">Sign in</button>
    </div>
  </div>
</form>
</div>
</body>
</html>