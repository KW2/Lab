<%@page import="lab.reservation.service.SelectReservationService"%>
<%@page import="lab.reservation.service.DeleteReservationService"%>
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
	DeleteReservationService deleteReservationService = DeleteReservationService.getInstance();
	SelectReservationService selectReservationService = SelectReservationService.getInstance();
	
	String strUpdateCheck = request.getParameter("updateCheck");
	String strupdateRid = request.getParameter("updateRid");
	Boolean updateCheck = false;
	int updateRid = 0;
	
	if(strUpdateCheck != ""){
		updateCheck = Boolean.valueOf(strUpdateCheck);
	}
	if(strupdateRid != ""){
		updateRid = Integer.parseInt(strupdateRid);
	}
	
	if(updateCheck){
		Reservation checkInfo = selectReservationService.getReservation(updateRid);
		if(!reservationInfo.getSid().equals(checkInfo.getGroupleader())){
			deleteReservationService.deleteReservation(updateRid);
			insertReservationService.insert(reservationInfo);
			if(checkGroupIds != null){
				for(String groupId : checkGroupIds){
					reservationInfo.setSid(groupId);
					insertReservationService.insert(reservationInfo);
				}
			}
		}else{
			List<String> updateGroupRids = selectReservationService.getGroupRid(checkInfo.getGroupleader(), checkInfo.getStartdate(), checkInfo.getStarttime());
			for(String groupRid : updateGroupRids){
				deleteReservationService.deleteReservation(Integer.parseInt(groupRid));
			}
			insertReservationService.insert(reservationInfo);
			if(checkGroupIds != null){
				for(String groupId : checkGroupIds){
					reservationInfo.setSid(groupId);
					insertReservationService.insert(reservationInfo);
				}
			}
		}
	}else{
		insertReservationService.insert(reservationInfo);
		if(checkGroupIds != null){
			for(String groupId : checkGroupIds){
				reservationInfo.setSid(groupId);
				insertReservationService.insert(reservationInfo);
			}
		}
	}
%>

