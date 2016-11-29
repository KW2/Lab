<%@page import="java.util.Calendar"%>
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
	Calendar calendar = Calendar.getInstance();	
	calendar.set(date.getYear(), date.getMonth() + 1, date.getDate());
	
	List<Reservation> dateList = new ArrayList<>();
	List<Reservation> tempList = new ArrayList<>();
	
	SelectReservationService selectReservationService = SelectReservationService.getInstance();
	
	switch(calendar.get(Calendar.DAY_OF_WEEK)){
	case 2:
	case 3:
	case 4:
	case 5:
		dateList = selectReservationService.getList(date);
		break;
	case 6:
		for(int i = 0; i < 3; i++){
			tempList = selectReservationService.getList(Date.valueOf(calendar.toString()));
			if(tempList != null){
				for(Reservation r : tempList){
					dateList.add(r);	
				}	
			}
			calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) + 1);
		}
		break;
	case 1:
	case 7:
		break;
	}

	
	JSONObject jsonMain = new JSONObject();
	
	for(int i = 0; i < dateList.size(); i++){
		String resApproval = "resApproval";
		resApproval += i;
		jsonMain.put(resApproval, dateList.get(i).getApproval());
	}
	jsonMain.put("resApprovalLength", dateList.size());
	
	out.println(jsonMain.toJSONString());
%>
