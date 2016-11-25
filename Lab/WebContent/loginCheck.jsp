<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="lab.user.model.User" %>
<%@ page import="lab.user.service.SelectUserService" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	  // 로그인 폼에서 받은 값으로 User 정보 확인 
	  
      request.setCharacterEncoding("utf-8");
      String id = request.getParameter("userId");
      String pw = request.getParameter("password");
      boolean check = false;
      
      SelectUserService selectUserService = SelectUserService.getInstance();
      User user = selectUserService.getUserInfo(id);
      String loginUser = "student";
      if(user != null){
      	check = user.matchPassword(pw);
      	if(check){
      		session.setAttribute("UserId", id);		// 로그인이 성공하면 session 속성에 해당 로그인 id를 넣는다.
      		
      		if(user.getName().equals("Manager")){	// 로그인한 사용자가 조교일 경우 
      			loginUser = "manager";
      		}else if(user.getName().equals("Admin")){
      			loginUser = "admin";				// 로그인한 사용자가 관리자일 경우
      		}
      		
      	}
      } 
      
%>
<c:set var="loginUser" value="<%=loginUser%>"/>
<html>
<head>
<title>Insert title here</title>
</head>
<body>
	<c:if test="<%= !check %>">
		<script> alert("로그인 오류 아이디,비밀번호를 다시 확인하세요!"); window.history.back();</script>

	</c:if>
	<c:if test="<%= check %>">
		<c:choose>
			<c:when test="${loginUser == 'student'}">
				<script> location.href = "index.jsp" ;</script>
			</c:when>
			<c:when test="${loginUser == 'manager'}">
				<script> location.href = "indexManager.jsp" ;</script>
			</c:when>
			<c:when test="${loginUser == 'admin'}">
				<script> location.href = "indexAdmin.jsp" ;</script>
			</c:when>
		</c:choose>		
	</c:if>
</body>
</html>