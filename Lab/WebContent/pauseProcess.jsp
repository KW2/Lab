<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="lab.pauseroom.service.PauseService" %>
<%@ page import="lab.error.ReverseDateException" %>

    
<% 
    request.setCharacterEncoding("utf-8");
    String startDate = request.getParameter("start_date");	//시작날짜
	Date start_date = Date.valueOf(startDate);
	String endDate = request.getParameter("end_date");	//끝 날짜
	Date end_date = Date.valueOf(endDate);
	
	if(start_date.after(end_date)){
		throw new ReverseDateException("날짜 오류");
	}
	
	String pageNo = request.getParameter("page");	//현재 페이지
	int no = Integer.parseInt(pageNo);
	String reason = request.getParameter("reason");	//실습실 제한 이유

   
    String[] checkbox = request.getParameterValues("checkbox");	//실습실 값
    
    PauseService pauseService = PauseService.getInstance();
    pauseService.InsertColdRoom(checkbox,start_date,end_date, reason);	//얼린 실습실 DB에 데이터 삽입
   	
%>
