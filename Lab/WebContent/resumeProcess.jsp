<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.*" %>
<%@ page import="lab.pauseroom.service.ResumeService" %>

    
<% 
    request.setCharacterEncoding("utf-8");

    String[] arr = request.getParameterValues("ncheckbox");	//각 투플의 id
   
    	for( String i : arr){
    		int check = Integer.parseInt(i);
   			ResumeService resumeService = ResumeService.getInstance();
   			resumeService.DeleteMeltRoom(check);	//투플의 id를 이용하여 데이터 삭제
    	}
%>

