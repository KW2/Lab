<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.lang.String.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	request.setCharacterEncoding("utf-8");
    String content = request.getParameter("pageContent");   // 파라미터로 받은 값에 따라 본문내용 페이지를 변경한다.
	
    String pageContent = "indexHome.jsp";					// 처음 로그인 했을 때 뜨는 페이지 ( 수정 필요 )
	
    if(content != null){
		if(content.equals("reservation")){
			pageContent="reservation.jsp";					// 예약하기 페이지 (1조 페이지 명)
		}else if(content.equals("list")){
			pageContent="myList.jsp";						// 예약 현향 확인 하기 페이지
		}
	}
	
	boolean check = false;									// 현재 로그인 상태 확인, 비로그인시 로그인 폼 페이지 이동
	String id = (String)session.getAttribute("UserId");
	  if(id == null){
	    	 check = true;
	    }

%>
<c:set var="content" value="<%= pageContent %>" />
<html>
<head>
<title>실습실 예약 홈페이지</title>
<style>
* {
	margin: 0;
	padding: 0;
}

#header {
	border-bottom: 1px solid black;
	height: 100px;
}

#content {
	overflow: hidden;
}

#aside {
	float: left;
	width: 200px;
	height: 800px;
	border-right: 1px solid black;
}

#article {
	float: left;
	height: 800px;
}
</style>
</head>
<body>
	<!-- 현재 로그인 상태 확인 -->
	<c:if test="<%=check %>">
		<script> alert("로그인 오류 !"); </script>
		<script> location.href = "login.jsp" ;</script>
	</c:if>

	<header id="header"> <a href="index.jsp">실습실홈페이지</a>
	<br />
	<a href="logout.jsp">[로그아웃]</a> 
	</header>

	<nav> <!--  상단 탭 기능 없음 --> </nav>

	<div id="content">

		<!-- 본문 좌측 -->
		<aside id="aside"> <!--  좌측 탭 메뉴 -->
		<div class="Student_menu" id="menu_1">
			<a href="index.jsp?pageContent=reservation">예약 하기</a>
		</div>
		<div class="Student_menu" id="menu_2">
			<a href="index.jsp?pageContent=list">내 예약 현황 확인</a>
		</div>
		</aside>

		<!-- 본문 우측 -->
		<article id="article"> <jsp:include page="${content}" flush="true" /> 
		</article>

	</div>
	
	<footer> <!-- 푸터 기능 없음 --> </footer>
</body>
</html>