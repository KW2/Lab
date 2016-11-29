<%@page import="lab.reservation.service.UpdateReservationService"%>
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
	UpdateReservationService updateReservationService = UpdateReservationService.getInstance();
	
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
	
	
	// 수정일 경우
	if(updateCheck){
		Reservation checkInfo = selectReservationService.getReservation(updateRid);
		if(!checkInfo.isTeam()){
			
		}else{
			
		}
		// 수정하는 인원이 그룹리더가 아닌경우
		if(!reservationInfo.getSid().equals(checkInfo.getGroupleader())){
			deleteReservationService.deleteReservation(updateRid);
			insertReservationService.insert(reservationInfo);
			if(checkGroupIds != null){
				for(String groupId : checkGroupIds){
					reservationInfo.setSid(groupId);
					insertReservationService.insert(reservationInfo);
				}
			}
			System.out.println("1");
			// 단체원들이 단체장을 제외하고 모두 수정을 통해 단체에서 빠져나가는 경우, 단체장을 개인으로 바꿔준다.
			List<String> beforeGroupRid = selectReservationService.getGroupRid(checkInfo.getGroupleader()
					, checkInfo.getStartdate(), checkInfo.getStarttime());
			System.out.println(beforeGroupRid.size());
			if(beforeGroupRid.size() == 1){
				Reservation groupLeaderResInfo = selectReservationService.getReservation(Integer.parseInt(beforeGroupRid.get(0)));
				groupLeaderResInfo.setTeam(false);
				groupLeaderResInfo.setGroupleader("");
				updateReservationService.update(groupLeaderResInfo);
			}
		}else{
			// 수정하는 인원이 그룹리더인 경우
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
		// 일반 예약인경우
		insertReservationService.insert(reservationInfo);
		if(checkGroupIds != null){
			for(String groupId : checkGroupIds){
				reservationInfo.setSid(groupId);
				insertReservationService.insert(reservationInfo);
			}
		}
	}
%>

