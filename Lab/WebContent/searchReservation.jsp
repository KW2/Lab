<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.Date"%>
<%@ page import="java.sql.Time"%>
<%@ page import="lab.reservation.service.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String startDate = request.getParameter("start_date");
    String endDate = request.getParameter("end_date");
    String pageNumberStr = request.getParameter("page");
    
    int pageNumber = 1;
    if(pageNumberStr != null){							// 페이지 번호 기능 (추후 수정 필요)
    	pageNumber = Integer.parseInt(pageNumberStr);
    }
    if(startDate == null || startDate.equals("")){
    	startDate = "2016-11-09";
    }
    if(endDate == null || endDate.equals("")){
    	endDate = "2030-12-31";
    }
    
    boolean check = false;
    String id = (String)session.getAttribute("UserId");
	if(id == null){
   	 check = true;
   	}

    SelectReservationService selector = SelectReservationService.getInstance();

    ReservationListView viewData = selector.getReservationList(pageNumber, startDate, endDate, id);

  	
%>
<c:set var="viewData" value="<%= viewData %>" />
<c:if test="<%=check %>">
	<script> alert("로그인 오류 !"); </script>
	<script> location.href = "login.jsp" ;</script>
</c:if>
{ "items" : [
<c:forEach var="reservation" items="${viewData.reservationList }"
	varStatus="index">
{
"rid": "${reservation.rid }",
"startdate": "${reservation.startdate }",
"labroom": "${reservation.labroom }",
"starttime": "${reservation.starttime }",
"usingtime": "${reservation.usingtime }",
"purpose": "${reservation.purpose }",
"team": "${reservation.team }",
"groupleader": "${reservation.groupleader }",
"status": "${reservation.status }"

}

<c:if test="${!index.last }">,</c:if>
</c:forEach>
] }
<%-- ,
{
"item" : [
{
	"pageTotalCount": "${viewData.pageTotalCount }"
}
]
} --%>