<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.Time" %>
<%@ page import="lab.reservation.service.SelectReservationService" %>
<%@ page import="lab.error.ReverseDateException" %>
<%@ page import="lab.reservation.model.Reservation" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String startDate = request.getParameter("start_date");	//시작날짜
	String endDate = request.getParameter("end_date");	//끝날짜
	
	if (startDate == null || startDate.equals("")) {
		startDate = "2016-11-01";
	}
	if (endDate == null || endDate.equals("")) {
		endDate = "2030-12-31";
	}
	
	Date start_date = Date.valueOf(startDate);
	Date end_date = Date.valueOf(endDate);
	//파라미터로 전달된 문자열 형식의 날짜 데이터를 Date타입으로 변환
	
	if(start_date.after(end_date)){
		throw new ReverseDateException("날짜 오류");
	}//시작 날짜가 끝 날짜 보다 클 경우 에러 발생
	
	String pageParameter = request.getParameter("page");	//현재 페이지
	int pageNumber = 1;
	
	if(pageParameter != null){
		pageNumber = Integer.parseInt(pageParameter);
	}	//파라미터로 전달된 현재 페이지 값을 int값으로 변환 시킴
	
	SelectReservationService service = SelectReservationService.getInstance();
	List<Reservation> pageList = service.getList(pageNumber, start_date, end_date); 
	//시작 날짜, 끝 날짜, 현제 페이지 값을 매개변수로 사용하여 예약 리스트 리턴
		
%>
{
"items" : [
<%
	for (int i = 0; i < pageList.size(); i++) {
		List<String> studentList = null;
		Reservation item = pageList.get(i);
		if(item.getGroupleader() != null){
			studentList = service.getGroupSid(item.getGroupleader(), item.getStartdate(), item.getStarttime());
		}	
		JSONArray jArray = JSONArray.fromObject(studentList);	//학번 리스트를 JSONArray로 변환 [jar파일이 추가로 필요]
		//service.getPageSize(start_date, end_date) : 입력한 날짜 사이의 포함되는 전체 페이지의 수를 이전 페이지로 전달 
%>
{
<%= "\"rid\":" + "\"" + item.getRid() + "\"," %>
<%= "\"leader\":" + "\"" + item.getGroupleader() + "\"," %>
<%= "\"labroom\":" + "\"" + item.getLabroom() + "\"," %>
<%= "\"reason\":" + "\"" + item.getPurpose() + "\"," %>
<%= "\"sid\":" + "\"" + item.getSid() + "\"," %>
<%= "\"size\":" + service.getPageSize(start_date, end_date) + "," %> 
<%= "\"group\":" + jArray + "," %>
<%= "\"startdate\":" + "\"" + item.getStartdate() + "\"," %>
<%= "\"starttime\":" + "\"" + item.getStarttime() + "\"," %>
<%= "\"usingtime\":" + "\"" + item.getUsingtime() + "\"," %>
<%= "\"team\":" + "\"" + item.isTeam() + "\"," %>
<%= "\"status\":" + "\"" + item.getApproval() + "\"" %>

}
<%= (i == pageList.size() -1) ? "" : "," %>
<%
	}
%>
]
}