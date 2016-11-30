
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <head>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
   <title>실습실 사용제한</title>
   <meta charset="utf-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1"> 

   <link rel="stylesheet" href="./static/css/bootstrap.min.css">
   <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
   <link rel="stylesheet" href="//code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
<style type="text/css">

@import url(http://fonts.googleapis.com/earlyaccess/nanumpenscript.css);
@import url(http://fonts.googleapis.com/earlyaccess/jejugothic.css);
ul.jeju{font-family: 'Nanum Pen Script', serif; font-size: 25px;}
 .container{
width:700px;
max-width : none !important;

}

</style>

</head>

<body>

<div class="container"  style="overflow: auto; position: absolute;">
   <form id="info_form" action="roomProcess.jsp" method="post" onsubmit="return false;"
   class="form-inline"> <!-- 하나의 폼태그로 구성 -->
         <p>조회기간:
          <input type="text" id="datepicker1" class="form-control" name="start_date1" onchange="JavaScript:reversetime()"> ~
          <input type="text" id="datepicker2" class="form-control" name="end_date1" onchange="JavaScript:reversetime()">
         
         <input type='button' class="form-control" value='조회' onclick="getInfo(1, true)"/>
         <!-- 조회날짜 입력 폼 -->
         </p>
         <h3>얼린 실습실 현황</h3>
       <table class="table table-bordered table-condensed"  border="1" id="checktable">
         <tr>
                <th>삭제</th>
            <th>실습실</th>
            <th>StartDate</th>
            <th>EndDate</th>
            <th>용도</th>         
         </tr>
         <tbody id="result_body">
         </tbody>
      </table>
      <!-- 조회한 날짜에 따른 얼린 실습실 데이터 출력 테이블 -->
      <div id="count_body"></div>  <!-- 페이지번호, 삭제버튼 -->
         
         <h3>실습실 얼리기 녹이기</h3>
         <p>사용제한 기간
          <input type="text" class="form-control" id="datepicker3" name="start_date2" onchange="JavaScript:reversetime()"> ~
          <input type="text" class="form-control"id="datepicker4" name="end_date2" onchange="JavaScript:reversetime()">
          </p>
          
      <p>용도를 기입해주세요
         <input type='text' class="form-control"name='reason'/>
         <input type='button' class="form-control"id='coldbutton' value='얼리기' disabled="true" onclick="cold(1, true)"/>
      </p>
      <!-- 실습실 사용금지 사유 작성 폼과 얼리기 버튼 -->
         <table class="table table-bordered table-condensed" border="1" id="rservationtable">
            <tr>
               <th>체크박스</th>
              <th>실습실</th>
             </tr>
            <tr>
               <td><input type="checkbox" name="checkbox" class="check" value="실습1실" id="LabRoom1" disabled="true" onclick="btnactive(1, this)"/></td>
               <td>실습1실</td>
           </tr>
             <tr>
            <td><input type="checkbox" name="checkbox" class="check" value="실습2실" id="LabRoom2" disabled="true" onclick="btnactive(2, this)"/></td>
            <td>실습2실</td>
           </tr>
           <tr>
            <td><input type="checkbox" name="checkbox" class="check" value="실습3실" id="LabRoom3" disabled="true" onclick="btnactive(3, this)"/></td>
            <td>실습3실</td>
           </tr>
           <tr>
            <td><input type="checkbox" name="checkbox" class="check" value="실습4실" id="LabRoom4" disabled="true" onclick="btnactive(4, this)"/></td>
            <td>실습4실</td>
           </tr>
           <tr>
            <td><input type="checkbox" name="checkbox" class="check" value="실습5실" id="LabRoom5" disabled="true" onclick="btnactive(5, this)"/></td>
            <td>실습5실</td>
           </tr>
      </table>
  
      <!-- 얼릴 실습실을 설정할 테이블 -->
   </form>
	</div>
</body>
<script>

$.datepicker.setDefaults({
    dateFormat: 'yy-mm-dd',
    prevText: '이전 달',
    nextText: '다음 달',
    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
    showMonthAfterYear: true,
    yearSuffix: '년'
  });

  $(function() {
    $("#datepicker1, #datepicker2, #datepicker3, #datepicker4").datepicker();
  });
  
  var obj;
  var activeflag = false;
  var str ='<input type="button" value="삭제" class="1" disabled="true" onclick="melt(1, true)"/>';
  //삭제 버튼 구현시 사용
  
  function getInfo(page, reset) {
     var form = $("#info_form");
     
     //ajax를 이용하여 파라미터 전송(시작 날짜 끝 날짜[post], 현재 페이지[get])
     $.ajax({
       type: "POST",
       url: "./static/ajax/roomProcess.jsp?page=" + page,
       data: form.serialize(),
       success: function(response) {
          var body = $('#result_body');
          var pagebody = $('#count_body');
          body.empty();
          
          /* console.log(response); */
          obj = JSON.parse(response).items;
         
         //JSON을 읽어 배열의 길이 만큼 동작 수행
          for (var i = 0; i < obj.length; i++) {
             var newTr = $('<tr></tr>');
             var newTd0 = $('<td><input type="checkbox" id="checkbox' + i + '" name="ncheckbox" value="' + obj[i].cno +'" onclick="check(' + i + ', this)"/></td>');
             var newTd1 = $('<td></td>');
             var newTd2 = $('<td></td>');
             var newTd3 = $('<td></td>');
             var newTd4 = $('<td></td>')
              //해당 행태그 안에 위치할 열 태그 생성
                                                   
             newTd1.text(obj[i].LabRoom);
             newTd2.text(obj[i].Startdate);
             newTd3.text(obj[i].Enddate);
             newTd4.text(obj[i].reason);
           //열태그안에 텍스트 삽입
                                            
             newTr.append(newTd0);
             newTr.append(newTd1);
             newTr.append(newTd2);
             newTr.append(newTd3);
             newTr.append(newTd4);
           //행태그에 열태그 삽입
          
             body.append(newTr);
           //두번쨰 테이블 tbody 태그에 행태그 삽입
              console.log(obj[0].size);
           
             if(reset){                  
                 $('.1').remove();
                 for(var j = 1; j <= obj[0].size; j++){
                    pagebody.append($('<a href="#" class="1" onclick="getInfo(' + j + ', false)">[' + j + ']</a>'));
                }
                 pagebody.append(str);
             }
           //데이터 삭제 버튼 a태그 구현
          }
          $(".check").attr('disabled', true); 
          //체크박스 활성화
          $('#datepicker1').attr('class', 'date');
          $('#datepicker2').attr('class', 'date');
       },
       error : function() {      //실패시 대화상자 출력
          alert('날짜 입력 오류');
          
       }
     });
  }
    
  function check(i, check){
     if(check.checked == true){
           $("#checkbox" + i).attr('class', 'change');
           $(".1").attr('disabled', false);
        } else {
          /*  $(".hidden" + i).remove(); ??*/
           $("#checkbox" + i).removeAttr('class');
           if($(".change").length == 0){
              $(".1").attr('disabled', true);
           }
        }
  }
  //얼린 실습실 삭제 테이블 checkbox 클릭시 수행되는 함수
  //삭제 버튼 비활성화
  
  function btnactive(no, check){
     if(check.checked == true && activeflag == true){
        
       $("#coldbutton").attr("disabled", false);
       $("#LabRoom" + no).attr("che", "che");
       for(var i = 1; i < 6; i++){
    	   $("#LabRoom" + i).attr('disabled', true);
       }
       $("#LabRoom" + no).attr('disabled', false);
     } else {
        $("#LabRoom" + no).removeAttr("che");
           if($("input[che]").length == 0){
              $("#coldbutton").attr('disabled', true);
        }
           for(var i = 1; i < 6; i++){
        	   $("#LabRoom" + i).attr('disabled', false);
           }
     }
  }
  //얼릴 실습실 설정 테이블에 있는 체크박스를 누를 떄 호출 (얼리기 버튼 활성화/비활성화)

  function cold(page, reset){
      var form = $("#info_form");
      //ajax를 이용하여 파라미터 전송(시작 날짜, 끝 날짜, 제한 목적[post], 현재 페이지[get])
      $.ajax({
          type: "POST",
          url: "./static/ajax/pauseProcess.jsp?page=" + page,
          data: form.serialize(),
          success: function(response) {
        	  $(".check").attr('checked', false);
        	  $(".check").attr('disabled', false);
        	  $("#coldbutton").attr('disabled', true);
             alert('얼리기 완료');
             if($("#datepicker1").val() != "" && $("#datepicker2").val() != ""){
  	           getInfo(1, true);
             }
           //성공시 대화상자 출력후 페이지 갱신 
          },            
          error : function(){               
                alert('중복된 실습실 얼리기 방지');
          }
          //실패시 대화상자 출력
         });      
   }
  //얼리기 버튼 클릭시 호풀
function melt(page, reset){
   var form = $("#info_form");
    //ajax를 이용하여 파라미터 전송(시작 날짜, 끝 날짜, 제한 목적[post], 현재 페이지[get])
    $.ajax({
          type: "POST",
          url: "./static/ajax/resumeProcess.jsp?page=" + page,
          data: form.serialize(),
          success: function(response) {
             alert('녹이기 완료');
             getInfo(1, true);      
          },
          //성공시 대화상자 출력후 페이지 갱신
         error : function(){
         }
         
   });
   
}//삭제 버튼 클릭시 호출

function reversetime(){
   if($(".date").length >= 0){
      var startDate = $("#datepicker3").val();
      var endDate = $("#datepicker4").val();
      var startDateArr = startDate.split('-');
      var endDateArr = endDate.split('-');
      
      var startDateCompare = new Date(startDateArr[0], startDateArr[1], startDateArr[2]);
        var endDateCompare = new Date(endDateArr[0], endDateArr[1], endDateArr[2]);
        if(startDateCompare != "Invalid Date" && endDateCompare != "Invalid Date"){
           if(startDateCompare.getTime() > endDateCompare.getTime()) {
              $("#coldbutton").attr('disabled', true);
              activeflag = false;
           } else {
              $(".check").attr('disabled', false);
              for(var i = 0; i < $('.check').length; i++){
                 if($("input[che]").length > 0){
                    $("#coldbutton").attr('disabled', false);
                 }
              }
              activeflag = true;
           }
        }
   }
}
</script>