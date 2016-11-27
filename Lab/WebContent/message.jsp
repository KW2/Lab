<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="lab.user.service.SelectUserService" %>
<%@ page import="lab.error.WaitingStatusException" %> 
<%@ page import="lab.reservation.service.SelectReservationService" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	request.setCharacterEncoding("utf-8");

	String[] rids = request.getParameterValues("rid");
	String[] sids = request.getParameterValues("sid");	//학번
	String[] status = request.getParameterValues("status");	//상태
	List<String> phoneList = new ArrayList<String>();
	SelectUserService service = SelectUserService.getInstance();
	SelectReservationService selectService = SelectReservationService.getInstance();
	String phoneNumber = "";
	String phoneNum = "";
	
	for(int i = 0; i < sids.length; i++){
		int rid = Integer.parseInt(rids[i]);
		String sid = sids[i];
		String stat = status[i];
		if(stat.equals("승인대기") || stat.equals("승인거절")){
			throw new WaitingStatusException("승인대기 학생"); //(변)
		}
		if(selectService.getGroupLeader(rid) != null){	//단체 대표가 있으면 해당 단체원들의 학번을 뽑아와서 list에 저장
			List<String> id = selectService.getSid(selectService.getGroupLeader(rid), selectService.getReservation(rid).getStartdate(), selectService.getReservation(rid).getStarttime());
			for(String memberId : id){
				phoneList.add(service.selectPhoneNumber(memberId));
			}
		} else {
			phoneList.add(service.selectPhoneNumber(sid));	//학번을 이용해 DB에서 추출한 전화번호를 리스트에 저장
		}
	}
	List<String> phones = new ArrayList<String>(new HashSet<String>(phoneList));
	for(int j = 0; j < phones.size(); j++){
		phoneNum = phones.get(j);
		phoneNumber = phoneNumber + phoneNum;
		if(j != phones.size()-1){
			phoneNumber = phoneNumber + ",";
		}
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form name="phone" action="ms_send.jsp" method="post">
		<input type="hidden" name="phoneNumber" value="<%=phoneNumber%>">
		<input type="submit" > 
	</form>

	 <script>document.phone.submit();</script>
</body>
</html>