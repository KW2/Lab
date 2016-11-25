<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="lab.pauseroom.model.PauseRoom"%>
<%@page import="java.util.ArrayList"%>
<%@page import="lab.pauseroom.service.SelectRoomService"%>
<%@ page contentType="application/json; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
	request.setCharacterEncoding("utf-8");
%>
<%
	String lab1_status = "";
	String lab2_status = "";
	String lab3_status = "";
	String lab4_status = "";
	String lab5_status = "";

	String res_date = request.getParameter("res_date");
	String start_time = request.getParameter("start_time");
	String using_time = request.getParameter("using_time");
	List<PauseRoom> notUsingLabroom = new ArrayList<PauseRoom>();
	
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	String[] splitResDate = res_date.split("-");
	String[] splitStartTime = start_time.split(":");
	
	Calendar calculationDay = Calendar.getInstance();
	calculationDay.set(Integer.parseInt(splitResDate[0]), Integer.parseInt(splitResDate[1]) - 1
			, Integer.parseInt(splitResDate[2]), Integer.parseInt(splitStartTime[0]), Integer.parseInt(splitStartTime[1]), 0);
	
	calculationDay.set(Calendar.HOUR_OF_DAY, calculationDay.get(Calendar.HOUR_OF_DAY) + Integer.parseInt(using_time));
	
	SelectRoomService selectRoomService = SelectRoomService.getInstance();
	notUsingLabroom = selectRoomService.SelectDate(Date.valueOf(res_date), 
			Date.valueOf(dateFormat.format(calculationDay.getTime())));

 	if(notUsingLabroom != null){
		for(int i = 0; i < notUsingLabroom.size(); i++){
			switch(notUsingLabroom.get(i).getLabroom()){
			case "실습1실":
				if(notUsingLabroom.get(i).getPausestart().equals(notUsingLabroom.get(i).getPauseend())){
					lab1_status += "사용불가 기간 : " + notUsingLabroom.get(i).getPausestart().toString() 
							+ "\n사유 : " + notUsingLabroom.get(i).getReason().toString() + "\n";
				}else{
					lab1_status += "사용불가 기간 : " + notUsingLabroom.get(i).getPausestart().toString() 
							+ " ~ " + notUsingLabroom.get(i).getPauseend().toString()  + "\n사유 : " 
							+ notUsingLabroom.get(i).getReason().toString() + "\n";
				}
				break;
			case "실습2실":
				if(notUsingLabroom.get(i).getPausestart().equals(notUsingLabroom.get(i).getPauseend())){
					lab2_status += "사용불가 기간 : " + notUsingLabroom.get(i).getPausestart().toString() 
							+ "\n사유 : " + notUsingLabroom.get(i).getReason().toString() + "\n";
				}else{
					lab2_status += "사용불가 기간 : " + notUsingLabroom.get(i).getPausestart().toString() 
							+ " ~ " + notUsingLabroom.get(i).getPauseend().toString()  + "\n사유 : " 
							+ notUsingLabroom.get(i).getReason().toString() + "\n";
				}
				break;
			case "실습3실":
				if(notUsingLabroom.get(i).getPausestart().equals(notUsingLabroom.get(i).getPauseend())){
					lab3_status += "사용불가 기간 : " + notUsingLabroom.get(i).getPausestart().toString() 
							+ "\n사유 : " + notUsingLabroom.get(i).getReason().toString() + "\n";
				}else{
					lab3_status += "사용불가 기간 : " + notUsingLabroom.get(i).getPausestart().toString() 
							+ " ~ " + notUsingLabroom.get(i).getPauseend().toString()  + "\n사유 : " 
							+ notUsingLabroom.get(i).getReason().toString() + "\n";
				}
				break;
			case "실습4실":
				if(notUsingLabroom.get(i).getPausestart().equals(notUsingLabroom.get(i).getPauseend())){
					lab4_status += "사용불가 기간 : " + notUsingLabroom.get(i).getPausestart().toString() 
							+ "\n사유 : " + notUsingLabroom.get(i).getReason().toString() + "\n";
				}else{
					lab4_status += "사용불가 기간 : " + notUsingLabroom.get(i).getPausestart().toString() 
							+ " ~ " + notUsingLabroom.get(i).getPauseend().toString()  + "\n사유 : " 
							+ notUsingLabroom.get(i).getReason().toString() + "\n";
				}
				break;
			case "실습5실":
				if(notUsingLabroom.get(i).getPausestart().equals(notUsingLabroom.get(i).getPauseend())){
					lab5_status += "사용불가 기간 : " + notUsingLabroom.get(i).getPausestart().toString() 
							+ "\n사유 : " + notUsingLabroom.get(i).getReason().toString() + "\n";
				}else{
					lab5_status += "사용불가 기간 : " + notUsingLabroom.get(i).getPausestart().toString() 
							+ " ~ " + notUsingLabroom.get(i).getPauseend().toString()  + "\n사유 : " 
							+ notUsingLabroom.get(i).getReason().toString() + "\n";
				}
				break;
			}
		}
		
		JSONObject jsonMain = new JSONObject();

		jsonMain.put("lab1", lab1_status);
		jsonMain.put("lab2", lab2_status);
		jsonMain.put("lab3", lab3_status);
		jsonMain.put("lab4", lab4_status);
		jsonMain.put("lab5", lab5_status);

		out.println(jsonMain.toJSONString());
	}else{
		JSONObject jsonMain = new JSONObject();
		
		out.println(jsonMain.toJSONString());
	} 
%>