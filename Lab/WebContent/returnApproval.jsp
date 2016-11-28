<%@page import="lab.reservation.model.Reservation"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="lab.reservation.service.SelectReservationService"%>
<%@page import="java.sql.Date"%>
<%@ page contentType="application/json; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
	request.setCharacterEncoding("utf-8");
%>
<%
	Date date = Date.valueOf(request.getParameter("res_date"));
	List<Reservation> dateList = new ArrayList<>();

	SelectReservationService selectReservationService = SelectReservationService.getInstance();
	dateList = selectReservationService.getList(date);

	JSONObject jsonMain = new JSONObject();

	for(int i = 0; i < dateList.size(); i++){
		String resApproval = "resApproval";
		resApproval += i;
		jsonMain.put(resApproval, dateList.get(i).getApproval());
	}
	jsonMain.put("resApprovalLength", dateList.size());
	
	out.println(jsonMain.toJSONString());
%>
