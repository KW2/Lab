<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="lab.reservation.model.Reservation" %>
<%@ page import="lab.reservation.service.UpdateReservationService" %>
<%@ page import="lab.reservation.service.SelectReservationService" %>
<%@ page import="lab.reservation.service.DeleteReservationService" %>
<%@ page import="java.util.List" %>
 
<%
     String array = request.getParameter("array");
	 String arrayG = request.getParameter("arrayG");
	 String arrayGG = request.getParameter("arrayGG");
	 String rid = request.getParameter("rid");
	 String groupleader = (String) session.getAttribute("UserId");
	 DeleteReservationService rsdeleteService = DeleteReservationService.getInstance();
	 SelectReservationService rsselectService = SelectReservationService.getInstance();
	 UpdateReservationService rsupdateService = UpdateReservationService.getInstance();
	 List<String> groupInfo;
	 List<String> groupRid;
	 Reservation reservation;
	 String sid;
	 if(array != null || arrayG != null || arrayGG != null){
	     String[] rids = array.split(",");
	     String[] ridG = arrayG.split(",");
	     String[] ridGG = arrayGG.split(",");
	     if(array != ""){
		     for(int x=0; x<rids.length; x++){
		         rsdeleteService.deleteReservation(Integer.parseInt(rids[x]));
		     }
	     }
	     if(arrayG != ""){
		     for(int y=0; y<ridG.length; y++){
		    	 reservation = rsselectService.getReservation(Integer.parseInt(ridG[y]));
		    	 groupInfo = rsselectService.getGroupSid(reservation.getGroupleader(), reservation.getStartdate());
		    	 groupRid = rsselectService.getGroupRid(reservation.getGroupleader(), reservation.getStartdate());
		    	 
		    	 
		    	 if(groupInfo.size()==2){
			    	 sid = " ";
			    	 for(String updateId : groupRid){
			    		reservation = rsselectService.getReservation(Integer.parseInt(updateId)); 
			    	 	rsupdateService.updateGroupleader(reservation, sid);
			    	 }
		    	 }
		    	 rsdeleteService.deleteReservation(Integer.parseInt(ridG[y]));
		     }
	     }
	     if(arrayGG != ""){
		     for(int z=0; z<ridG.length; z++){
		    	 reservation = rsselectService.getReservation(Integer.parseInt(ridGG[z]));
		    	 groupInfo = rsselectService.getGroupSid(groupleader, reservation.getStartdate());
		    	 groupRid = rsselectService.getGroupRid(groupleader, reservation.getStartdate());
		    	 
		    	 
		    	 if(groupInfo.size()==2){
			    	 sid = " ";
		    	 }else{
		    		 if(reservation.getSid().equals(groupInfo.get(0))){
			    	  	 sid = groupInfo.get(1); 
			    	 }else{
			    		 sid = groupInfo.get(0); 
			    	 }
		    	 }
		    	 
		    	 for(String updateId : groupRid){
		    		reservation = rsselectService.getReservation(Integer.parseInt(updateId)); 
		    	 	rsupdateService.updateGroupleader(reservation, sid);
		    	 }
		    	 rsdeleteService.deleteReservation(Integer.parseInt(ridG[z]));
		     }
	     }
	 }else{
		reservation = rsselectService.getReservation(Integer.parseInt(rid));
		groupInfo = rsselectService.getGroupRid(groupleader, reservation.getStartdate());
		for(String deleteId : groupInfo){
			rsdeleteService.deleteReservation(Integer.parseInt(deleteId));
		}
		 
	 }
     
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<script>alert("취소가 완료되었습니다!"); window.history.back();</script>
</body>
</html>