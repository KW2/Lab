<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="lab.reservation.service.UpdateReservationService" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	request.setCharacterEncoding("utf-8");
	List<String> labList = new ArrayList<String>();
	String[] sid = request.getParameterValues("checkbox");	//예약변호
	String[] lab = request.getParameterValues("select");	//실습실
	
	UpdateReservationService service = UpdateReservationService.getInstance();
	List<Integer> list = new ArrayList<Integer>();
	
	for(String id : sid){
		int rid = Integer.parseInt(id);
		list.add(rid);
	}	//파라미터 값으로 넘어온 예약 번호 값들을 하나의 리스트에 저장
	for(String labroom : lab){
		System.out.println(labroom);
		labList.add(labroom);	
	}	//파라미터 값으로 넘어온 실습실 값들을 하나의 리스트에 저장
	service.UpdateStatus(list, labList, true);	 
	//두개의 리스트와 boolean값을 매개변수로 전달 하여 데이터베이스 값 변경(true : 예약승인)
	
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>