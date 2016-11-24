<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Time" %>
<%@ page import="java.sql.Date" %>
<%@ page import="lab.reservation.model.Reservation" %>
<%@ page import="lab.reservation.service.InsertReservationService" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>


<% request.setCharacterEncoding("UTF-8"); %>
<%
	Reservation reservationInfo = (Reservation)request.getAttribute("reservationInfo");
	List<String> checkGroupIds = (ArrayList<String>)request.getAttribute("checkGroupIds");
	InsertReservationService insertReservationService = InsertReservationService.getInstance();	

	insertReservationService.insert(reservationInfo);
	if(checkGroupIds != null){
		for(String groupId : checkGroupIds){
			reservationInfo.setSid(groupId);
			insertReservationService.insert(reservationInfo);
		}
	}
%>

