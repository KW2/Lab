<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="lab.pauseroom.service.PauseService"%>
<%@ page import="lab.error.ReverseDateException"%>
<%@ page import="lab.pauseroom.service.SelectRoomService"%>
<%@ page import="lab.pauseroom.model.PauseRoom" %>
<%@ page import="lab.pauseroom.service.DeleteRoomService" %>

<%
	request.setCharacterEncoding("utf-8");
	String startDate = request.getParameter("start_date2"); //시작날짜
	Date start_date = Date.valueOf(startDate);
	String endDate = request.getParameter("end_date2");	//끝 날짜
	Date end_date = Date.valueOf(endDate);
	
	if(start_date.after(end_date)){
		throw new ReverseDateException("날짜 오류");
	}

	String pageNo = request.getParameter("page");	//현재 페이지
	int no = Integer.parseInt(pageNo);
	String reason = request.getParameter("reason"); //실습실 제한 이유
	String[] checkbox = request.getParameterValues("checkbox"); //실습실 값

	List<PauseRoom> checkList = null;
	// 현재 입력값으로 기존 제한 값 검색
	SelectRoomService selectRoomService = SelectRoomService.getInstance();
	PauseService pauseService = PauseService.getInstance();
	DeleteRoomService deleteRoomService = DeleteRoomService.getInstance();

	for (int i = 0; i < checkbox.length; i++) {
		checkList = selectRoomService.SelectDuplicationDate(checkbox[i], start_date, end_date);

		if (checkList != null) {
			for (PauseRoom pauseRoom : checkList) {             // 기존 값 ES, EE (pauseRoom.--)  새로운 값 NS, NE (start_date, end_date)
	
				if (start_date.before(pauseRoom.getPausestart())
						&& end_date.before(pauseRoom.getPausestart())) {   //    NS  <  NE   <  ES   < EE   중복 내용 없음 
					pauseService.InsertColdRoom(checkbox, start_date, end_date, reason);
					
				} else if (start_date.after(pauseRoom.getPauseend())) {    //    ES <  EE < NS < NE    중복 내용 없음
					pauseService.InsertColdRoom(checkbox, start_date, end_date, reason);
					
				} else if (start_date.before(pauseRoom.getPausestart())
						&& end_date.equals(pauseRoom.getPausestart())) {   //    NS < ES = NE <  EE    ns 부터 ee 까지 
					deleteRoomService.deleteRoom(pauseRoom.getPid());
					pauseService.InsertColdRoom(checkbox, start_date, pauseRoom.getPausestart(), reason);
					
				} else if ((start_date.before(pauseRoom.getPausestart())
						|| start_date.equals(pauseRoom.getPausestart()))
						&& (end_date.before(pauseRoom.getPauseend())
								|| end_date.equals(pauseRoom.getPauseend()))
						&& end_date.after(pauseRoom.getPausestart())) {    //  NS <= ES  < NE <= EE    ns 부터 ee 까지       
					deleteRoomService.deleteRoom(pauseRoom.getPid());
					pauseService.InsertColdRoom(checkbox, start_date, pauseRoom.getPauseend(), reason);
					
				} else if ((start_date.after(pauseRoom.getPausestart())
						|| start_date.equals(pauseRoom.getPausestart()))
						&& start_date.before(pauseRoom.getPauseend())
						&& (end_date.after(pauseRoom.getPauseend())				
								|| end_date.equals(pauseRoom.getPauseend()))) {    // ES < NS < EE <= NE   es 부터 ne 까지
					deleteRoomService.deleteRoom(pauseRoom.getPid());
					pauseService.InsertColdRoom(checkbox, pauseRoom.getPausestart(), end_date, reason);
					
				} else if (start_date.after(pauseRoom.getPausestart())			
						&& end_date.before(pauseRoom.getPauseend())) {	    // ES < NS < NE < EE   es 부터 ee 까지
					deleteRoomService.deleteRoom(pauseRoom.getPid());
					pauseService.InsertColdRoom(checkbox, pauseRoom.getPausestart(), pauseRoom.getPauseend(), reason);
					
				} else if (start_date.before(pauseRoom.getPausestart()) 
						&& end_date.after(pauseRoom.getPauseend())){                   // NS < ES < EE < NE
					deleteRoomService.deleteRoom(pauseRoom.getPid());
					pauseService.InsertColdRoom(checkbox, start_date, end_date, reason);
					
				}else {
					pauseService.InsertColdRoom(checkbox, start_date, end_date, reason); //얼린 실습실 DB에 데이터 삽입 */
				}
			}
		}else{
			pauseService.InsertColdRoom(checkbox,start_date,end_date, reason);	//얼린 실습실 DB에 데이터 삽입 */
			
		}

	}
%>
