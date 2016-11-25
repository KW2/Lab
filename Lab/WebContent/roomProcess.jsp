<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.Time" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.*" %>
<%@page import="lab.error.ReverseDateException"%>
<%@page import="lab.error.ColdException"%> 
<%@page import="lab.pauseroom.model.PauseRoom"%>
<%@page import="lab.pauseroom.service.SelectRoomService"%>

<%
	request.setCharacterEncoding("utf-8");
	System.out.println("1");
	String startDate = request.getParameter("start_date");	//시작 날짜
	String endDate = request.getParameter("end_date");		//끝 날짜
	System.out.println("2");
	Date start_date = Date.valueOf(startDate);
	Date end_date = Date.valueOf(endDate);
	System.out.println("3");
	if(start_date.after(end_date)){
		throw new ReverseDateException("날짜 오류");
	} 
	String pageNo = request.getParameter("page");	//현재 페이지
	int no = Integer.parseInt(pageNo);
	System.out.println("4");
	
	
	if(startDate.isEmpty()||endDate.isEmpty()){
		throw new ColdException("실습실 선택");
		
	}
	System.out.println("5");
	SelectRoomService service = SelectRoomService.getInstance();
	List<PauseRoom> list = service.getList(no, start_date, end_date);	//현재 페이지의 실습실 리스트 출력
	List<PauseRoom> testlist = service.SelectDate(start_date, end_date);	
	
	
	
%>
{
"items" : [
<%
	for (int i = 0; i < list.size(); i++) {
		PauseRoom item = list.get(i);
		//service.getPageSize(start_date, end_date) : 입력 날짜의 해당되는 데이터의 전체 페이지 수를 리턴
	
%>
{
<%= "\"cno\":" + "\"" + item.getPid() + "\"," %>
<%= "\"LabRoom\":" + "\"" + item.getLabroom() + "\"," %>
<%= "\"reason\":" + "\"" + item.getReason() + "\"," %>
<%= "\"size\":" + service.getPageSize(start_date, end_date) + "," %>
<%= "\"Startdate\":" + "\"" + item.getPausestart() + "\"," %>
<%= "\"Enddate\":" + "\"" + item.getPauseend() + "\"" %>

}
<%= (i == list.size() -1) ? "" : "," %>
<%
	}
%>
]
}


