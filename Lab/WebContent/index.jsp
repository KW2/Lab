<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.lang.String.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	request.setCharacterEncoding("utf-8");
    String content = request.getParameter("pageContent");   // 파라미터로 받은 값에 따라 본문내용 페이지를 변경한다.
	
    String pageContent = "./static/view/home.jsp";					// 처음 로그인 했을 때 뜨는 페이지 ( 수정 필요 )
	
    if(content != null){
		if(content.equals("reservation")){
			pageContent="./static/view/reservation.jsp";					// 예약하기 페이지 (1조 페이지 명)
		}else if(content.equals("list")){
			pageContent="./static/view/myList.jsp";						// 예약 현향 확인 하기 페이지
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
<img src="./static/images/logo_ov.png"  height="70px">
<style>
body{
background-size:auto;
background-image:url('./static/images/top.jpg');
background-repeat:no-repeat;
}
</style>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title>실습실 예약 홈페이지</title>
<link rel="stylesheet" href="./static/css/bootstrap.min.css">
<style>
 .ncontainer{
width:700px;
height:600px;
max-width : none !important;

}

* {
	margin: 0;
	padding: 0;
}
#content {
	overflow: hidden;
	
}

#aside {
	float: left;
	width: 400px;
/* 	padding-left: 50px; */

 	height: 1100px;
	 border-right: 1px solid #c5bebe; 
}

#header {
   border-bottom: 1px solid white;
   height: 180px;
}

#article {
	float: left;
	height: auto;
	padding: 30px;
	padding-left: 100px;
}/*중앙*/


div.container{
	overflow:hidden;
}

div.item{
	float: right;
	margin: 0 3px;
	padding: 10px;
}

.menu-list {
	margin : 0px;
	padding : 0px;
}

.menu-item {
	list-style: none;
	margin: 0px;
	padding-left: 180px;
	text-align: center;
	margin-top : 10px;
	padding-right: 50px;
}/*메뉴*/

.menu-item a {
	color: default;
	font-size: 18px;
/* 	font-family: 'Delius Unicase', 'Abril Fatface', 'PT Serif', serif; */
}

.menu-item a:hover {
	color: gray;
	font-style: none;
	text-decoration : none;
}

</style>
</head>
<body>
	<!-- 현재 로그인 상태 확인 -->
	<c:if test="<%=check %>">
		<script> alert("로그인 오류 !"); </script>
		<script> location.href = "login.jsp" ;</script>
	</c:if>

<div id="wrap">
	<div class="header" id="header">
		<div class="container">
  			<div class="item" ><h4><a href="./static/util/logout.jsp" class="btn btn-success">로그아웃</a></h4></div>
  			<div class="item" ><h4><a href="index.jsp" class="btn btn-warning">홈페이지</a></h4></div>
		</div>
	</div>

	<nav> <!--  상단 탭 기능 없음 --> </nav>
	<section>
	<div class="sub_main">
	</div>
	<div id="content">
		<!-- 본문 좌측 -->
		<aside id="aside" > 
			<div class="list-group">
			<ul class="menu-list">
				<li class="menu-item">
  				<a href="index.jsp?pageContent=reservation" class="list-group-item ">예약하기</a>
   				</li>
			</ul>
			<ul class="menu-list" class="affix">
				<li class="menu-item">
 				 <a href="index.jsp?pageContent=list" class="list-group-item">내 예약현황 확인</a>
 				 </li>
			</ul>
			</div>
		</aside>

		<!-- 본문 우측 -->

</style>





		<article id="article" > <jsp:include page="${content}" flush="true" /> 


		</article>



	</div>
	</section>
	
	<footer> <!-- 푸터 기능 없음 --> </footer>
</div>

</body>
</html>