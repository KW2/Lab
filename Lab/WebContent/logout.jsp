<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	session.invalidate();
%>
<html>
<head>
<title>Insert title here</title>
</head>
<body>
<script>alert("로그아웃하였습니다."); location.href = "login.jsp";</script>
</body>
</html>