<%@page import="lab.reservation.service.LabReservationCount"%>
<%@page import="lab.reservation.service.ReservationCountService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat" %>
<%
	Date date = new Date();
	DateFormat todayFormat = DateFormat.getDateInstance(DateFormat.FULL);
	ReservationCountService reservationService = ReservationCountService.getInstance();
	LabReservationCount labReservationCoun;
	labReservationCoun = reservationService.getRsCount(new java.sql.Date(date.getTime()));

%>
<html>
<head>
<title>Insert title here</title>
<style>
#notion{
	margin: 0 0 0 20px;
}
</style>
</head>
<body>
<!-- index 첫 페이지  -->
<table >
	<tr>
		<td colspan="2">
			<%= todayFormat.format(date) %> 예약 인원
		</td>
	</tr>
	<tr>
		<td>1실습실</td>
		<td><%=labReservationCoun.getLab1() %></td>
	</tr>
	<tr>
		<td>2실습실</td>
		<td><%=labReservationCoun.getLab2() %></td>
	</tr>
	<tr>
		<td>3실습실</td>
		<td><%=labReservationCoun.getLab3() %></td>
	</tr>
	<tr>
		<td>4실습실</td>
		<td><%=labReservationCoun.getLab4() %></td>
	</tr>
	<tr>
		<td>5실습실</td>
		<td><%=labReservationCoun.getLab5() %></td>
	</tr>
</table>

<div id="notion">
	<ul>주의사항
		<li>캡스 해제 후 입실합니다. 해제 확인! 두 번 확인!</li>
		<li>해제 하지 않고 입실하면 경보가 울립니다. 경보가 울려 캡스 출동 시 과태료가 부가되오니, 꼭! 유의하세요.</li>
		<li>모든 컴퓨터 전원 끄고 정리하기</li>
		<li>무단속 철저히 (특히 주말)</li>
		<li>퇴실 시 캡스 세트 합니다. 꼭 합니다.</li>
		<li>캡스 키/열쇠 분실 주의</li>
		<li><strong>캡스 경보 울리지 않도록 주의 합니다.</strong></li>
		<li><strong>부주의로 일어난 모든 책임은 본인(빌리는 사람)에게 있습니다.</strong></li>
		<li>다른 사람에게 열쇠를 넘기더라도 빌려간 사람에게 책임을 묻습니다.</li>	
	</ul>
</div>
</body>
</html>