<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="lab.user.service.SelectUserService" %>
<%@ page import="lab.error.WaitingStatusException" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	request.setCharacterEncoding("utf-8");

	String[] sid = request.getParameterValues("sid");	//학번
	String[] status = request.getParameterValues("status");	//상태
	List<String> phoneList = new ArrayList<String>();
	SelectUserService service = SelectUserService.getInstance();
	
	for(int i = 0; i < sid.length; i++){
		String id = sid[i];
		String stat = status[i];
		if(stat.equals("승인대기") || stat.equals("승인거절")){
			throw new WaitingStatusException("승인대기 학생"); //(변)
		} 
		phoneList.add(service.selectPhoneNumber(id));	//학번을 이용해 DB에서 추출한 전화번호를 리스트에 저장
		System.out.println(service.selectPhoneNumber(id) + "," + stat);
		//학번에 해당하는 전화번호와 상태값 출력
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>