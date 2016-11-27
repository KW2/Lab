<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%>
<%@ page import="lab.reservation.service.UpdateReservationService" %>
<%@ page import="lab.reservation.service.SelectReservationService" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.Time" %>
<%@ page import="net.sf.json.JSONArray" %>
<%
	request.setCharacterEncoding("utf-8");
	List<String> labList = new ArrayList<String>();
	String[] sid = request.getParameterValues("rid");	//예약변호
	String[] lab = request.getParameterValues("select");	//실습실
	String[] startDate = request.getParameterValues("startdate");
	String[] startTime = request.getParameterValues("time");
	String labRoom = null;
	JSONArray jRidrArray = null;
	int teamNum = 0;
	int commaNum = 0;
	int counter = 0;
	
	SelectReservationService selectService = SelectReservationService.getInstance();
	UpdateReservationService service = UpdateReservationService.getInstance();
	
	List<Integer> list = new ArrayList<Integer>();
	List<Date> dateList = new ArrayList<Date>();
	List<Time> timeList = new ArrayList<Time>();
	List<Integer> RidList = new ArrayList<Integer>();	//단체 대표 리스트 저장
	List<String> labRoomList = new ArrayList<String>();		//실습실 리스트 저장
		
	for(int i = 0; i < sid.length; i++){
		dateList.add(Date.valueOf(startDate[i]));
		timeList.add(Time.valueOf(startTime[i]));
	} 
	
	for(int i = 0; i < sid.length; i++){
		int rid = Integer.parseInt(sid[i]);
		list.add(rid);
		if(selectService.getGroupLeader(rid) != null){ 
			RidList.addAll(selectService.getRid(selectService.getGroupLeader(rid), Date.valueOf(startDate[i]), Time.valueOf(startTime[i])));
			labRoomList.add(selectService.getLabroom(rid));
			teamNum++;
		}
	}	//파라미터 값으로 넘어온 예약 번호 값들을 하나의 리스트에 저장
	
	for(String labroom : lab){
		labList.add(labroom);	
	}	//파라미터 값으로 넘어온 실습실 값들을 하나의 리스트에 저장
	service.UpdateStatus(list, labList, true);	
	commaNum = teamNum - 1;
	//두개의 리스트와 boolean값을 매개변수로 전달 하여 데이터베이스 값 변경(true : 예약승인)	
	
%>

{
"items" : [
<%
for(int i = 0; i < sid.length; i++){
	int rid = Integer.parseInt(sid[i]);
	if(selectService.getGroupLeader(rid) != null){
		RidList = selectService.getRid(selectService.getGroupLeader(rid), Date.valueOf(startDate[i]), Time.valueOf(startTime[i]));
		labRoom = selectService.getLabroom(rid);
		jRidrArray = JSONArray.fromObject(RidList);
		counter++;
	
%>
{
<%= "\"labroom\":" + "\"" + labRoom + "\"," %>
<%= "\"rid\" : " + jRidrArray %>
}
<%= (counter > commaNum) ? "" : "," %>
<%
	}
}
%>
]
}

