<%@page import="java.util.Calendar"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="lab.reservation.model.Reservation"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="lab.user.service.SelectUserService" %>
<%@ page import="lab.error.WaitingStatusException" %> 
<%@ page import="lab.reservation.service.SelectReservationService" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	request.setCharacterEncoding("utf-8");

	java.util.Date current = new java.util.Date();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String date = format.format(current);

	Date today = Date.valueOf(date);
	
	List<Reservation> msgList = new ArrayList<>();
	List<String> phoneList = new ArrayList<String>();
	SelectUserService service = SelectUserService.getInstance();
	SelectReservationService selectService = SelectReservationService.getInstance();
	String phoneNumber = "";
	String phoneNum = ""; 
	
 	msgList = selectService.getListMsg(today); 
	if(msgList != null){
		for(int i=0; i<msgList.size(); i++){
			Reservation r = msgList.get(i);
			phoneList.add(service.selectPhoneNumber(r.getSid()));
			
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
 	<form name="phone" method="post">
 		<input type="hidden" name="webmail_id" value="dyhan">
 		<input type="hidden" name="domain" value="yc.ac.kr">
		<input type="hidden" name="receiveHpValue" value="<%=phoneNumber%>">
		<input type="submit" > 
	</form>
<script>


function requestSmsHttp() {

	var frm = document.phone;

	//frm.webmail_id.value = '아이디';
	//frm.domain.value = 'yc.ac.kr';

	//var vReceiveHpValue = ["01012345679", "01012345678","01012345670"]; 


	//frm.receiveHpValue.value = vReceiveHpValue;

    window.open('', 'smsFormForPost', 'width=500, height=600, resizable= yes');

    frm.target = 'smsFormForPost';
    //frm.action = domain;
    frm.action = 'http://mail.yc.ac.kr/mail/sso.public.do?method=sso_sms';
	frm.submit();
}
requestSmsHttp();
location.href = "../../indexManager.jsp?pageContent=roomManage";
</script>
	 
</body>
</html>