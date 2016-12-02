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
	String[] splitDate = request.getParameter("res_date").split("-");

	Calendar calendar = Calendar.getInstance();	
	calendar.set(Integer.parseInt(splitDate[0]), Integer.parseInt(splitDate[1]) - 1, Integer.parseInt(splitDate[2]));
	
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
			String formedDate = "";
			formedDate = String.valueOf(calendar.get(Calendar.YEAR)) + "-" + String.valueOf(calendar.get(Calendar.MONTH) + 1)+
					"-" + String.valueOf(calendar.get(Calendar.DATE));
			tempList = selectReservationService.getList(Date.valueOf(formedDate));
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
	
	if(dateList != null){
		for(int i = 0; i < dateList.size(); i++){
			String resApproval = "resApproval";
			resApproval += i;
			jsonMain.put(resApproval, dateList.get(i).getApproval());
		}
		jsonMain.put("resApprovalLength", dateList.size());

		out.println(jsonMain.toJSONString());
	}else{
		jsonMain.put("reservationCheck", "예약없음");
		
		out.println(jsonMain.toJSONString());
	}
	
%>
