<%@ page contentType="application/json; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="lab.reservation.service.LabReservationCount" %>
<%@ page import="lab.reservation.service.ReservationCountService" %>
<%@ page import="java.sql.Date" %>


<%
	request.setCharacterEncoding("utf-8");
%>
<%
	String res_date = request.getParameter("res_date");
	Date date = Date.valueOf(res_date);

	ReservationCountService reservationCountService = ReservationCountService.getInstance();
	LabReservationCount labRsCount = reservationCountService.getRsCount(date);

	JSONObject jsonMain = new JSONObject();

	// 넘겨줄때 labRsCount 객체를 넘겨주는게 아니라 안의 프로퍼티를 넘겨줘야 할듯
	jsonMain.put("lab1", labRsCount.getLab1());
	jsonMain.put("lab2", labRsCount.getLab2());
	jsonMain.put("lab3", labRsCount.getLab3());
	jsonMain.put("lab4", labRsCount.getLab4());
	jsonMain.put("lab5", labRsCount.getLab5());

	out.println(jsonMain.toJSONString());
%>
