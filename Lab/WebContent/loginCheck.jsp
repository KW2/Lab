<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="lab.user.service.SelectStudentService"%>
<%@ page import="lab.user.model.Student"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	  // 로그인 폼에서 받은 값으로 User 정보 확인 
	  
      request.setCharacterEncoding("utf-8");
      String id = request.getParameter("userId");
      String pw = request.getParameter("password");
      
      boolean check = false;
      
      SelectStudentService selectStudentService = SelectStudentService.getInstance();
      Student student = selectStudentService.getStudentInfo(id);
      
      if(student != null){
      	check = student.matchPassword(pw);
      	if(check){
      		session.setAttribute("UserId", id);		// 로그인이 성공하면 session 속성에 해당 로그인 id를 넣는다.
      	}
      } 
      
	  

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<c:if test="<%=!check %>">
		<script> alert("로그인 오류 아이디,비밀번호를 다시 확인하세요!"); window.history.back();</script>

	</c:if>
	<c:if test="<%=check %>">
		<script> location.href = "index.jsp" ;</script>
	</c:if>
</body>
</html>