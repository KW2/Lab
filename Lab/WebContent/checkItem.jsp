<%@page import="lab.reservation.service.SelectReservationService"%>
<%@page import="lab.reservation.model.Reservation"%>
<%@page import="lab.user.model.User"%>
<%@page import="lab.user.service.SelectUserService"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Calendar" %>

<%@ page import="java.sql.Time" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% request.setCharacterEncoding("utf-8"); %>
<%
	boolean lab_radio_check = false;
	boolean group_radio_check = true;
	boolean group_id_check = false;
	boolean res_date_check = false;
	boolean start_time_check = false;
	boolean using_time_check = false;
	boolean purpose_text_check = false;
	boolean all_check = false;
	
	String[] groupIds = request.getParameterValues("group_id");
	String labroom = request.getParameter("lab_radio");
	boolean team = Boolean.valueOf(request.getParameter("group_radio"));
	Date date = Date.valueOf(request.getParameter("res_date"));	
	Time time = Time.valueOf(request.getParameter("start_time") + ":00");
	int usingtime = Integer.parseInt(request.getParameter("using_time"));
	String purpose = request.getParameter("purpose_text");
	String sid = (String)session.getAttribute("UserId");
	String groupleader = null;
	
	Map<Integer, String> falseGroupId = new HashMap<Integer, String>();
	int correctGroupIds = 0;
	
	// Calendar 타입으로 Server 시간과 Client 시간을 구해 놓는다. 
	// 차후 시간 연산을 위해 사용, month 같은 경우는 내부적으로 0을 1월로 생각하기 때문인지 -1을 해주어야 제대로 값이 들어간다.
	int limitWeekDayTime = 18;
	int limitWeekendTime = 8;
	Calendar serverCalendar = Calendar.getInstance();
	Calendar clientCalendar = Calendar.getInstance();
	String[] splitDate = date.toString().split("-");
	String[] splitTime = time.toString().split(":");

	clientCalendar.set(Integer.parseInt(splitDate[0]), Integer.parseInt(splitDate[1]) - 1
			, Integer.parseInt(splitDate[2]), Integer.parseInt(splitTime[0]), Integer.parseInt(splitTime[1]), Integer.parseInt(splitTime[2]));
	
	// 현재 서버날짜부터 2주후의 날짜를 구해놓는다.
	Calendar afterTwoWeek = ((Calendar)serverCalendar.clone());
	afterTwoWeek.set(Calendar.DAY_OF_MONTH, serverCalendar.get(Calendar.DAY_OF_MONTH) + 14);
	afterTwoWeek.set(Calendar.HOUR_OF_DAY, 0);
	afterTwoWeek.set(Calendar.MINUTE, 0);
	afterTwoWeek.set(Calendar.SECOND, 0);	
	
	// 알림문장
	String problem = "";
	String idProblem = "";
	String dateProblem = "";
	
	// 실습실 체크
	if(labroom != null){
		lab_radio_check = true;
	}
	
	// team의 경우는 항상 초기값이 주어지므로 값이 존재하는지 따로 검사하는 경우가 없다
	// 입력한 그룹id가 테이블에 있는지 확인한다.
	if(team){
		SelectUserService selectUserService = SelectUserService.getInstance();
		User user = null;
		groupleader = sid;
		
		for(int i = 0; i < groupIds.length; i++){
			if(!groupIds[i].equals("")){
				user = selectUserService.getUserInfo(groupIds[i]);
				if(user == null || groupIds[i].equals(sid)){				
					falseGroupId.put(i + 1, groupIds[i]);
				}else{
					correctGroupIds++;
				}
			}
		}
		
		if(falseGroupId.isEmpty() && correctGroupIds > 0){
			group_id_check = true;
		}
	}else{
		group_id_check = true;
	}
	
	
	// 날짜 체크, 시간 체크
	// 날짜가 현재날짜보다 뒤에 있는지와 서버날짜부터 2주 안의 예약인지 확인
	// 평일과 주말에 따른 예약가능시간에 해당하는지에 따라 시간체크
	if((clientCalendar.after(serverCalendar)) && (clientCalendar.before(afterTwoWeek))){
//		System.out.println("서버시간 : " + serverCalendar.getTime() + "\n클라이언트 시간 : " + clientCalendar.getTime());
		switch(clientCalendar.get(Calendar.DAY_OF_WEEK)){	
		case 1:
			// 일요일은 금요일까지만 예약을 받는다.
			// (서버)현재일자가 예약전주의 토요일 전이면 예약가능
			Calendar lastWeekFriday = (Calendar)clientCalendar.clone();
			lastWeekFriday.set(Calendar.DAY_OF_WEEK, 7);			
			lastWeekFriday.set(Calendar.DAY_OF_MONTH, lastWeekFriday.get(Calendar.DAY_OF_MONTH) - 7);
			lastWeekFriday.set(Calendar.HOUR_OF_DAY, 0);
			lastWeekFriday.set(Calendar.MINUTE, 0);
			lastWeekFriday.set(Calendar.SECOND, 0);	
			
			if(serverCalendar.before(lastWeekFriday)){
				start_time_check = true;
			}
			
			break;
		case 7:
			// 토요일은 금요일까지만 예약을 받는다.
			// (서버)현재일자가 예약하는 주의 토요일 전이면 예약가능 
			Calendar thisWeekFriday = (Calendar)clientCalendar.clone();
			thisWeekFriday.set(Calendar.DAY_OF_WEEK, 7);
			thisWeekFriday.set(Calendar.HOUR_OF_DAY, 0);
			thisWeekFriday.set(Calendar.MINUTE, 0);
			thisWeekFriday.set(Calendar.SECOND, 0);	
						
			if((serverCalendar.before(thisWeekFriday))
					&& (clientCalendar.get(Calendar.HOUR_OF_DAY) >= limitWeekendTime)){
				start_time_check = true;
			}
						
			break;
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
			// 평일 예약날짜가 서버날짜와 동일한 경우
			if((clientCalendar.get(Calendar.YEAR) == serverCalendar.get(Calendar.YEAR))
					&&(clientCalendar.get(Calendar.MONTH) == serverCalendar.get(Calendar.MONTH))
					&&(clientCalendar.get(Calendar.DAY_OF_MONTH) == serverCalendar.get(Calendar.DAY_OF_MONTH))){
				
				// 평일에는 18시 이후에는 예약불가, 사용자도 18시 이후 시간으로만 예약가능
				if((serverCalendar.get(Calendar.HOUR_OF_DAY) < limitWeekDayTime)
						&& (clientCalendar.get(Calendar.HOUR_OF_DAY) >= limitWeekDayTime)){
					start_time_check = true;	
				}
			}else{
				if(clientCalendar.get(Calendar.HOUR_OF_DAY) >= limitWeekDayTime){
					start_time_check = true;
				}
			}	
			break;
		}
		
		res_date_check = true;
	}
	
	// 사용시간 체크
	if(usingtime != 0){
		using_time_check = true;
	}
	
	// 사용용도 체크
	if(purpose != ""){
		purpose_text_check = true;
	}

	// 잘못된 경우 알림사항 기입
	if(!lab_radio_check){
		problem += "실습실 체크여부\n";
	}
	if(!group_radio_check){
		problem += "그룹 체크여부\n";
	}
	if(!group_id_check){
		idProblem += "그룹 id 기입이 잘못되었습니다.\n";
		if(correctGroupIds > 0){
			idProblem += "잘못된 사항은 아래와 같습니다.\n\n";
		}
		
		Iterator<Integer> keys = falseGroupId.keySet().iterator();
		while(keys.hasNext()){
			Integer key = keys.next();
			idProblem += key + "번 : " + falseGroupId.get(key) + "\n";
		}
		idProblem += "\n";
	}
	if(!res_date_check){
		dateProblem += "예약날짜가 잘못되었습니다.\n";
		dateProblem += "다음의 사항을 다시 한번 확인하십시오.\n";
		dateProblem += "1. 예약은 현재 날짜부터 2주 안에만 가능합니다.\n";
		dateProblem += "2. 주말예약은 평일에만 가능합니다.\n";
		dateProblem += "3. 당일예약은 18시 이전에만 가능합니다.\n\n";
	}
	if(!start_time_check){
		problem += "시작시간 기입여부\n";
	}
	if(!using_time_check){
		problem += "사용시간 기입여부\n";
	}
	if(!purpose_text_check){
		problem += "사용목적 기입여부\n";
	}
	if(!problem.isEmpty()){
		problem += "를 확인하십시오.\n";
	}
	
	// 모든 사항 체크 완료시
	if(lab_radio_check && group_radio_check && group_id_check 
			&& res_date_check && start_time_check && using_time_check && purpose_text_check){
		all_check = true;
	}
	
	if(all_check){
		// 굳이 안써도 되는듯, 에러가 따로 발생 안하기 때문에 성공으로 생각이 되는것 같다.
		//response.setStatus(200);
		Reservation reservationInfo = new Reservation(0, labroom, sid, date, time, usingtime, team, "승인대기", purpose, groupleader);	
		SelectReservationService selectReservationService = SelectReservationService.getInstance();

		if(selectReservationService.isDuplicationReservation(reservationInfo) && !request.getParameter("updateCheck").equals("true")){
			response.setStatus(308);
			
			JSONObject jsonMain = new JSONObject();
			jsonMain.put("informProblem", "중복된 예약입니다.\n다시 확인해 주십시오");
			out.println(jsonMain.toJSONString());
		}
		else{
			request.setAttribute("reservationInfo", reservationInfo);
			
			if(team){
				List<String> checkGroupIds = new ArrayList<String>();
				for(int i = 0; i < groupIds.length; i++){
					if(groupIds[i] != ""){
						checkGroupIds.add(groupIds[i]);
					}
				}
				request.setAttribute("checkGroupIds", checkGroupIds);
			}
			pageContext.forward("./insertReservation.jsp");	
		}		
	}else{
		
		// 따로 에러가 발생안하는경우 성공이라고 판단을 하게되서, 일부러 해당경우를 에러라고 하기위해
		// status를 조작해서 사용한다.
		// 에러코드 302의 경우 익스플로러에서는 에러가 난다. 이유는 아직...
		response.setStatus(308);
		
		JSONObject jsonMain = new JSONObject();
		jsonMain.put("informProblem", idProblem + dateProblem + problem);
		out.println(jsonMain.toJSONString());
	}
%>