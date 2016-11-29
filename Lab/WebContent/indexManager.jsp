<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.lang.String.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	request.setCharacterEncoding("utf-8");
    String content = request.getParameter("pageContent");   // 파라미터로 받은 값에 따라 본문내용 페이지를 변경한다.
	
    String pageContent = "indexHome.jsp";					// 처음 로그인 했을 때 뜨는 페이지 ( 수정 필요 )
	
    if(content != null){
		if(content.equals("roomManage")){
			pageContent="roomManage.jsp";					// 예약하기 페이지 (1조 페이지 명)
		}else if(content.equals("roomPause")){
			pageContent="roomPause.jsp";						// 예약 현향 확인 하기 페이지
		}else if(content.equals("phoneMessage")){
			pageContent="ms_send.jsp";
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
<img src="img/logo_ov.png"  height="70px">
<style>
body{
background-size:auto;
background-image:url('img/top.jpg');
background-repeat:no-repeat;
}
</style>
<title>실습실 예약 홈페이지</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1"> 
<style>
* {
   margin: 0;
   padding: 0;
}

#header {
   border-bottom: 1px solid white;
   height: 180px;
}

#content {
   overflow: hidden;
}

#aside {
   float: left;
   width: 400px;
   height: 800px;
   border-right: 1px solid #c5bebe;
}

#article {
   float: left;
   height: 1800px;
   padding: 30px;
   padding-left: 100px;   
}


div.container{
   overflow:hidden;
}

div.item{
   float: right;
   margin: 0 3px;
   padding: 10px;
}

.Student_menu {
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
/*    font-family: 'Delius Unicase', 'Abril Fatface', 'PT Serif', serif; */
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

   
   <!-- <header id="header">
       <a href="indexManager.jsp">실습실홈페이지</a>
   <br />
      <a href="logout.jsp">[로그아웃]</a> 
   </header>
 -->
<div id="wrap">
	<div class="header" id="header">
		<div class="container">
  			<div class="item" ><h4><a href="indexManager.jsp" class="btn btn-success">홈페이지</a></h4></div>
  			<div class="item" ><h4><a href="logout.jsp" class="btn btn-warning">로그아웃</a></h4></div>
		</div>
	</div>
 
   <nav> <!--  상단 탭 기능 없음 --> </nav>

   <section>
   <div id="content">

   <aside id="aside"> 
      <div class="list-group">
         <ul class="menu-list">
            <li class="menu-item">
              <a href="indexManager.jsp?pageContent=roomManage" class="list-group-item ">실습실 예약 현황</a>
               </li>
         </ul>
         <ul class="menu-list">
            <li class="menu-item">
              <a href="indexManager.jsp?pageContent=roomPause" class="list-group-item">실습실 사용 제한</a>
              </li>
         </ul>



      <!-- 본문 좌측 -->
      
      <!-- <aside id="aside">  좌측 탭 메뉴
      <div class="Student_menu" id="menu_1">
         <a href="indexManager.jsp?pageContent=roomManage">실습실 예약 현황</a>
      </div>
      <div class="Student_menu" id="menu_2">
         <a href="indexManager.jsp?pageContent=roomPause">실습실 사용 제한</a>
       -->
      
      
      
      </div>
      </aside>





      <!-- 본문 우측 -->
      <article id="article"> <jsp:include page="${content}" flush="true" /> 
      </article>

      </div>
      </section>
   <footer> <!-- 푸터 기능 없음 --> </footer>
   </div>
</body>
</html>