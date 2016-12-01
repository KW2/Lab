<%@page import="java.util.Calendar"%>
<%@page import="lab.reservation.service.SelectReservationService"%>
<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=euc-kr"
    pageEncoding="euc-kr"%>
<%@page import="java.util.List"%>
<%@page import="lab.reservation.model.Reservation"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
   String phoneNumber = request.getParameter("phoneNumber");
   SelectReservationService selectService = SelectReservationService.getInstance();
   java.util.Date current = new java.util.Date();
   SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
   String date = format.format(current);

   Date today = Date.valueOf(date);

   List<Reservation> items = selectService.getListMsg(today);
   

   String[] weekDay = { "일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일" };     
   Calendar cal = Calendar.getInstance(); 
   int num = cal.get(Calendar.DAY_OF_WEEK)-1; 
   String week = weekDay[num]; 
%>
<c:set var="week" value="<%= week %>"/>

<script src="../js/jquery.js"></script>

<script>
   $(document).ready(function(){
      if("${week}" == "금요일"){
         $("#contents").html("당일 및 주말예약이 완료되었습니다.");
      }

   });
</script>

<html>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1"> 

<link rel="stylesheet" href="../css/bootstrap.min.css">

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">


<body>

<!-- table 자리 -->
<table class="table table-bordered table-condensed table-hover" border="1" id="table">

   <tr>
        <th>실습실</th>
        <th>학번</th>
        <th>날짜</th>
        <th>시작시간</th>
        <th>이용시간</th>
        <th>용도</th>
        <th>단체여부</th>
        <th>단체장</th>
        <th>상태</th>
    </tr>
    <c:set var="items" value="<%=items%>"></c:set>
   <c:forEach items="${items}" var="item">
   <tr>
         <td>${item.labroom}</td>
         <td>${item.sid}</td>
         <td>${item.startdate}</td>
         <td>${item.starttime}</td>
         <td>${item.usingtime}</td>
         <td>${item.purpose}</td>
         <td>${item.team}</td>
         <td>${item.groupleader}</td>
         <td>${item.approval}</td>
   </tr>
   </c:forEach>      
</table>

<!-- table 자리 -->



<!-- =================================================================================================== -->
<!-- = 문자연동을 위한 샘플 소스 입니다.                                                               = -->
<!-- =================================================================================================== -->
<form id="form" name="form" method="post" action="http://biz.moashot.com/EXT/URLASP/mssend.asp">


<!-- =================================================================================================== -->
<!-- = 1. 사용자 정보 입력 START                                                                       = -->
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- =    모아샷에서 발급받은 사용자 정보를 입력합니다.                                                = -->
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- [필수] 사용자 인증 정보 -->
<input class="form-control" type="hidden" name="uid" value="icloser" />
<input class="form-control" type="hidden" name="pwd" value="smartsw2190" />

<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- =    * 비밀번호 보안설정 전송                                                                     = -->
<!-- =    비밀번호 노출방지를 위해 암호화된 비밀번호를 전송하실 수 있습니다.                           = -->
<!-- =    commType에 1을 넣고 commCode에 서비스아이디비밀번호를 MD5로 변환한 값을 넣거나,              = -->
<!-- =    commType에 2를 넣고 uid+toNumber+모아샷에서제공한KEY를 MD5로 변환한 값을 넣으실수 있습니다.  = -->
<!-- =    commType에 1또는 2를 넣은  경우 위의 pwd(서비스아이디비밀번호) 항목은 사용하지 않습니다.     = -->
<!-- =    비밀번호 보안설정 전송 사용시 아래 주석을 해제후 사용하시기 바랍니다.                        = -->
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!--<input type="hidden" name="commType" value="1" />-->
<!--<input type="hidden" name="commCode" value="wqUDFWE#fdsafdereFDSAEfd/oiJIsLtNg5bPE9NIR8=" />-->
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- = 1. 사용자 정보 입력 END                                                                         = -->
<!-- =================================================================================================== -->


<!-- =================================================================================================== -->
<!-- = 2. 전송구분 정보 입력 START                                                                     = -->
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- =    팩스전송:1 SMS단문전송:3 LMS장문전송:5, MMS이미지포함문자전송:6                              = -->
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- [필수] 전송구분정보 3:단문전송 -->
<input class="form-control" type="hidden" name="sendType" value="3" />
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- = 2. 전송구분 정보 입력 END                                                                       = -->
<!-- =================================================================================================== -->


<!-- =================================================================================================== -->
<!-- = 3. 전송할 정보 입력 START                                                                       = -->
<!-- = ----------------------------------------------------------------------------------------------- = -->
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="100">전송제목</td>
    <td width="400">
      <!-- [선택] 문자 전송제목 -->
      <input class="form-control" name="title" type="text" value="학과사무실에서 알립니다" />
    </td>
  </tr>
  <tr>
    <td>휴대폰번호</td>
    <td>
      <!-- [필수] 문자 수신처 번호(동보 전송일 경우 ,로 구분하여 입력) -->
      <input class="form-control" name="toNumber" type="text" value="<%=phoneNumber %>" />
    </td>
  </tr>
  <tr>
    <td>전송내용</td>
    <td>
      <!-- [필수] 전송할 문자 내용 -->
      <textarea class="form-control" id="contents" name="contents" cols="45" rows="5">당일 예약이 완료되었습니다.</textarea>
      <!-- = ----------------------------------------------------------------------------------------- = -->
      <!-- =    * MMS(이미지 포함 문자 발송)기능도 사용하실 수 있습니다.                               = -->
      <!-- =    전송할 이미지를 먼저 모아샷 FTP 서버에 전송한 후 전송한 화일명을 전달하시면 됩니다.    = -->
      <!-- =    전송할 이미지의 포맷은 JPG만 지원을 합니다.(다른이미지 지원불가)                       = -->
      <!-- =    이미지 전송시 반드시 파일은 먼저 모아샷 서버로 전송한 후에 호출을 해야 발송이 됩니다.  = -->
      <!-- =    모아샷 FTP 서버 정보는 모아샷으로 문의 주시기 바랍니다.                                = -->
      <!-- =    이미지 전송 사용시 아래 주석을 해제후 사용하시기 바랍니다.                             = -->
      <!-- = ----------------------------------------------------------------------------------------- = -->
      <!--<input name="fileName" type="text" value="모아샷에 미리 전송한 파일명 입력" />-->
   </td>
  </tr>
  <tr>
    <td>발신자정보</td>
    <td>
      <!-- [필수] 발신자정보, 비즈모아샷에서 사전 등록한 발신번호만 입력                                 -->
      <!--        공란이거나 사전 등록하지 않은 발신번호 입력시 발송되지 않습니다.                       -->
      <input class="form-control" name="fromNumber" type="text" value="0115574027" />
    </td>
  </tr>
  <tr>
    <td>전송시간</td>
    <td>
      <!-- [선택] 전송예약시간,  yyyymmddhhmiss(20160101093000) 14자리 예약시간을 입력                   -->
      <!--        예약이 필요한 경우만 입력하며, 입력하지 않으면 접수 즉시 발송됩니다.                   -->
      <input class="form-control" name="startTime" type="text" value="" /> 
    </td>
  </tr>
</table>
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- = 3. 전송할 정보 입력 END                                                                         = -->
<!-- =================================================================================================== -->

<!-- =================================================================================================== -->
<!-- = 4. 전송결과 처리 방식 입력 START                                                                = -->
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- =    전송결과에 대한 처리 정보를 설정합니다.                                                      = -->
<!-- =    nType에 1을 넣는 경우 전송건에대한 모아샷에서의 접수여부를 전달,                             = -->
<!-- =            2를 넣는 경우 성공 실패여부를 전달,                                                  = -->
<!-- =            3를 넣는 경우 위 두가지 모두 전달합니다.                                             = -->
<!-- =    전송결과에서 전송해드리는 파라메터는 매뉴얼을 참고하시기 바랍니다.                           = -->
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!--<input name="nType에" type="hidden" value="3" />-->
<!--<input name="indexCode" type="hidden" value="고객사에서 사용하는 고유값" />-->
<input class="form-control" name="returnUrl" type="hidden" value="http://220.66.111.79:8080/Lab/indexManager.jsp" />
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- = 4. 전송결과 처리 방식 입력 END                                                                  = -->
<!-- =================================================================================================== -->

<!-- =================================================================================================== -->
<!-- = 5. 전송후 처리 방식 입력 START                                                                  = -->
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- =    전송요청 접수 후 처리 방식을 설정합니다.                                                     = -->
<!-- =    returnType에 0을 넣는 경우 호출한 모아샷 연동페이지를 닫습니다.(스크립트 self.close처리됨)   = -->
<!-- =                 1를 넣는 경우 호출한 모아샷 연동페이지를 그대로 유지합니다.                     = -->
<!-- =                 2를 넣는 경우 redirectUrl에 입력한 경로로 이동합니다.                           = -->
<!-- = ----------------------------------------------------------------------------------------------- = -->
<input class="form-control" name="returnType" type="hidden" value="2" />
<input class="form-control" name="redirectUrl" type="hidden" value="http://220.66.111.79:8080/Lab/indexManager.jsp" />
<!-- = ----------------------------------------------------------------------------------------------- = -->
<!-- = 5. 전송후 처리 방식 입력 END                                                                    = -->
<!-- =================================================================================================== -->

<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center">
      <!-- 모야삿 문자 전송 URL 에 form의 내용을 전송합니다. -->
      <input class="form-control" type="submit" name="button" value="문자발송" />
    </td>
  </tr>
</table>
</form>    
</body>
</html>
