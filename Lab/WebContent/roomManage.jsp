<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <head>
   <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
	<link rel="stylesheet" href="css/bootstrap.min.css">
   <title>현재 예약 현황 확인</title>
   <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
   <link rel="stylesheet" href="//code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>

<style>
	td:hover ul{
		display:block; /* 마우스 커서 올리면 드랍메뉴 보이게 하기 */
	}
	td ul{
		background: rgb(255,255,255);
		display:none; /* 평상시에는 드랍메뉴가 안보이게 하기 */
		height:auto;
		padding:0px;
		margin:0px;
		border:0px;
		position:absolute;
		width:100px;
		z-index:200;
		
	}
	.won {
		background: rgb(255,255,255);
		display:block;
		float:none;
		margin:0px;
		padding:0px;
		width:200px;
	}
</style>

</head>
<body> <!-- 세개의 폼태그로 구성 -->
   <form class="form-inline" id="info_form" action="process.jsp" method="post" onsubmit="return false;"> <!-- 날짜 입력폼 -->
   
       <div class="form-group">
    <label for="datepicker1">조회 기간 : </label>
    <input type="text" class="form-control" name="start_date" id="datepicker1" placeholder="조회기간">
  </div>
  
  <div class="form-group">
    <label for="datepicker2"> ~ </label>
    <input type="text" class="form-control" id="datepicker2" name="end_date" placeholder="조회종료">
  </div>
  <input type="button" value='조회' class="btn btn-default" onclick="getInfo(1, true, false)"/>
   </form>
    <br/>
  <br/>
  <br/>
 
 <form id="table_form" action="permisson.jsp" method="post" onsubmit="return false;"> <!-- 테이블 출력 및 예약 승인 및 거절 폼 -->
         <table class="table table-bordered" border="1" id="table">
            <tr>
            <th>체크박스</th>
            <th>예약번호</th>
             <th>실습실</th>
             <th>학번</th>
             <th>날짜</th>
             <th>시작시간</th>
             <th>이용시간</th>
             <th>용도</th>
             <th>단체여부</th>
             <th>상태</th>
           </tr>
           <tbody id="result_body">
           </tbody>
      </table>
      <div id="count_body"></div>  <!-- 페이지번호, 삭제버튼 -->
   </form> <!-- 문자 전송 폼 -->
	<form id="sid_form" action="message.jsp" method="post">
	</form>
<script>
var obj;
var Object;

function getInfo(page, reset, init) {
   var form = $("#info_form"); 
   
   if(!init){
	   var startDate = $('#datepicker1').val();
	   var endDate = $('#datepicker2').val();
	   if(startDate == "" || endDate == ""){
		   alert("날짜 입력 오류");
		   return null;
	   }
   }
   
   //ajax를 이용하여 파라미터 전송 (날짜[post], 현재 페이지[get])
   $.ajax({
     type: "POST",
     url: "process.jsp?page=" + page,
     data: $("#info_form").serialize(),
     //성공시 호출
     success: function(response) {
    	 
    	 
        var body = $('#result_body');
        var pagebody = $('#count_body');
        body.empty();
        
        obj = JSON.parse(response).items;
        //JSON으로 읽어온 배열의 길이만큼 동작수행
        for (var i = 0; i < obj.length; i++) {
        	
           var lab = '#' + obj[i].labroom + i;	//데이터 베이스에 저장된 실습실 값 출력시 사용
           var newTr = $('<tr></tr>');	//행 태그 생성
           
           var newTd0 = $('<td><input type="checkbox" class="checkbox" id="checkbox' + i + '" onclick="check(' + i + ', this)"/></td>');
          /*  var newTd1 = $('<td></td>'); */
           var newTd2 = $('<td><select id="select' + i + '" onchange="lab(' + i + ')"><option id="실습1실' + i + '">실습1실</option><option id="실습2실' + i + '">실습2실</option><option id="실습3실' + i + '">실습3실</option><option id="실습4실' + i + '">실습4실</option><option id="실습5실' + i + '">실습5실</option></select></td>');
           var newTd3 = $('<td id="sid' + i + '"></td>');
           var newTd4 = $('<td class="date" id="date' + i + '" value="'+ obj[i].startdate + '"></td>');
           var newTd5 = $('<td></td>');
           var newTd6 = $('<td></td>');
           var newTd7 = $('<td id="team' + i + '"></td>');
           var td = $('<td></td>');
           var newTd8 = $('<td class="status" id="status' + i + '"></td>');
           var newTd9 = $('<td></td>');
           //해당 행태그 안에 위치할 열 태그 생성
                          
          /*  newTd1.text(obj[i].rid); */
           newTd3.text(obj[i].sid);
           newTd4.text(obj[i].startdate);
           newTd5.text(obj[i].starttime);
           newTd6.text(obj[i].usingtime);
           newTd8.text(obj[i].status);
           newTd9.text(obj[i].reason);
          //열태그안에 텍스트 삽입
           
        
           newTr.append(newTd0);
           /* newTr.append(newTd1); */
           newTr.append(newTd2);
           newTr.append(newTd3);
           newTr.append(newTd4);
           newTr.append(newTd5);
           newTr.append(newTd6);
           newTr.append(newTd9);
           newTr.append(newTd7);
           newTr.append(td);
           newTr.append(newTd8);
   		   //행태그에 열태그 삽입
        
           body.append(newTr);
   		   //tbody 태그에 행태그 삽입
           
           if(obj[i].team == 'true'){
        	   newTd7.text("O");
        	   td.text(obj[i].leader);
        	   td.append('<ul id="list' + i + '"></ul>');
        	   for(var x = 0; x < obj[i].group.length; x++){
        		   $('#list' + i).append("<li>" + obj[i].group[x] + "</li>");
        	   }
        	   $('#select' + i).attr('group', obj[i].rid);
        	   $('#status' + i).attr('group', obj[i].rid);
        	   $('#checkbox' + i).attr('teamcheck', obj[i].startdate + obj[i].starttime + obj[i].leader);
           } else {
	       	   newTd7.text("X");
           }
   		   //단체 여부에 따른 텍스트 및 풀다운 메뉴 출력
           
           $(lab).attr('selected', 'selected');
   		   //실습실 출력시 DB에 저장되어 있는 실습실 데이터가 출력 되도록 함 
   		   
           $(function(){
               $("ul.sub").hide();
             $("ul.menu li").hover(function(){
                $("ul",this).slideDown("fast");
               },
               function(){
                  $("ul",this).slideUp("fast");
               });
            });
   		   //풀다운 메뉴 구현
   		   
           compare(i);	//현재 날짜 이전 예약 내역은 데이터를 변경하지 못하도록 체크박스를 비황성화 시킴
   		   
        } //for문 종료
        
         if(reset){
     		$('.page').remove();
    		$('.btnn').remove(); 
     		$('#sendMsg').remove();
        	for(var j = 1; j <= obj[0].size; j++){
        		pagebody.append($('<a href="#" class="page" onclick="getInfo(' + j + ', false, true)">[' + j + ']</a>'));
        	}
        	$('#table_form').append($('<input type="button" class="btnn btn btn-default" value="예약승인" onclick="permisson()" disabled="true"/>'));
        	$('#table_form').append($('<input type="button" class="btnn btn btn-default" value="예약거절" onclick="refuse()" disabled="true"/>'));
        	$('#sid_form').append($('<input type="submit"  class="btnn btn btn-default" id="sendMsg" value="문자전송"disabled="false"/>'));
        }
        
        //페이지 이동 a태그 및 버튼 출력 구현
         $(".btnn").attr('disabled', true);
         $("input[type=hidden]").remove();
         message();
     },
     error : function(jqXHR, textStatus, errorThrown) { 	//실패시 대화상자 출력
       	alert('오류');
     }
   });
}
function lab(no){
	$('.hidden6' + no).attr('value', $('#select' + no).val());
}

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
    $("#datepicker1, #datepicker2").datepicker();
  });
  
  function check(i, checkbox){
	  var teamCheck = '.' + obj[i].startdate + obj[i].starttime + obj[i].leader;
	  if(checkbox.checked == true){
	 	 $("#status" + i).attr('class', 'change');	//상태 데이터를 바로 갱신 시키기 위해 사용
	 	 $("#sid_form").append($('<input type="hidden" class="hidden1' + i + '" name="sid" value="' + obj[i].sid + '"/>'));
	 	 $("#sid_form").append($('<input type="hidden" class="hidden2' + i + '" name="status" value="' + obj[i].status + '"/>'));
	 	 $("#table_form").append($('<input type="hidden" class="hidden3' + i + '" name="startdate" value="' + obj[i].startdate + '"/>'));
	 	 $("#table_form").append($('<input type="hidden" class="hidden4' + i + '" name="time" value="' + obj[i].starttime + '"/>'));
	 	 $("#table_form").append($('<input type="hidden" class="hidden5' + i + '" name="rid" value="' + obj[i].rid + '"/>'));
	 	 $("#table_form").append($('<input type="hidden" class="hidden6' + i + '" name="select" value="' + $('#select' + i).val() + '"/>'));
	 	 $("#sid_form").append($('<input type="hidden" class="hidden7' + i + '" name="rid" value="' + obj[i].rid + '"/>'));
	 	 $(".btnn").attr('disabled', false);
	 	$("#date" + i).attr('class', 'date');
	 	if($('#checkbox' + i).attr('teamcheck') == obj[i].startdate + obj[i].starttime + obj[i].leader){
	 		 $("input[teamcheck='" + obj[i].startdate + obj[i].starttime + obj[i].leader + "']").attr('disabled', true);
	 		$('#checkbox' + i).attr('disabled', false);
	 	 }
	  } else {
		  $("#select" + i).removeAttr('name');
		  $(".hidden1" + i).remove();
		  $(".hidden2" + i).remove();
		  $(".hidden3" + i).remove();
		  $(".hidden4" + i).remove();
		  $(".hidden5" + i).remove();
		  $(".hidden6" + i).remove();
		  $(".hidden7" + i).remove();
		  $("#status" + i).removeAttr('class');
		  $("#date" + i).removeAttr('class');
		  if($(".change").length == 0){
		  	$(".btnn").attr('disabled', true);
		  }
		  if($('#checkbox' + i).attr('teamcheck') == obj[i].startdate + obj[i].starttime + obj[i].leader){
			  $("input[teamcheck='" + obj[i].startdate + obj[i].starttime + obj[i].leader + "']").attr('disabled', false);
		  }
	  }
  }
  /*체크 박스 클릭시마다 호출
	체크박스를 클릭하여 체크박스가 선택 되어 있으면 버튼 활성화 및 파라미터 값 생성
	체크박스를 클릭하여 체크박스가 선택해제 되어 있으면 버튼 비황생화 및 파라미터 값을 가지고 있는 태그 삭제
  */
  
  
  function permisson(){
	  
	  //예약 번호와 실습실값을 파라미터로 전송
		 $.ajax({
		     type: "POST",
		     url: $("#table_form").attr("action"),
		     data: $("#table_form").serialize(),
		     success: function(response) {
		    	 Object = JSON.parse(response).items;
		    	 alert('승인완료!');
		    	 for(var i = 0; i < Object.length; i++){
		    		 for(var j = 0; j < Object[i].rid.length; j++){
		    		 	$("td[group='" + Object[i].rid[j] + "']").text("예약승인");
		    		 	 $("select[group='" + Object[i].rid[j] + "']").val(Object[i].labroom).attr("selected", "selected");
		    		 }
		    	 }
		    	 $(".change").text("예약승인");	//성공과 동시에 상태값 걍신
		    	 for(var i = 0; i < 10; i++){
			    	 $(".hidden2" + i).attr("value", "예약승인");
			     }
		    	 message();
		     },
		     error : function() {
		    	 alert('이미 승인되어 있는 학생입니다');	//이미 예약승인 되어진 학생을 또 승인 했을시 대화 상자 출력
		     }
		   });
	  
  }	//예약 승인 버튼을 눌렀을때 호출
		
	

	function refuse(){
	  //예약번호와 실습실 값을 파라미터로 전송
		$.ajax({
		     type: "POST",
		     url: "refuse.jsp",
		     data: $("#table_form").serialize(),
		     success: function(response) {
		    	 Object = JSON.parse(response).items;
		    	 for(var i = 0; i < Object.length; i++){
		    		 for(var j = 0; j < Object[i].rid.length; j++){
		    		 	$("td[group='" + Object[i].rid[j] + "']").text("승인거절");
		    		 }
		    	 }
		    	 alert('승인거절!');
		    	 $(".change").text("승인거절");	//성공과 동시에 상태값 걍신
		    	 for(var i = 0; i < 9; i++){
		    	 	$(".hidden2" + i).attr("value", "승인거절");
		    	 }
		    	 message();
		     },
		     error : function() {
		    	 alert('이미 거절되어 있는 학생입니다');	//이미 예약승인 되어진 학생을 또 승인 했을시 대화 상자 출력
		     }
		   });
		
	}	//예약 거절 버튼을 눌렀을때 호출
	
	function message(){
		var day = new Date();
		var dayOfWeek = day.getDay();
		
		var dd = day.getDate();
		var mm = day.getMonth()+1; //January is 0!
		var yyyy = day.getFullYear();
			if(dd<10) {
			    dd='0'+dd
			} 
			if(mm<10) {
			    mm='0'+mm
			} 
		today = yyyy + '-' + mm + '-' + dd;
		
		switch(dayOfWeek){
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
			
			
			$.ajax({
				url:'./returnApproval.jsp',
				type: 'POST',
				dataType:'JSON',
				data: {"res_date": today},
				success: function(data){
					var flag = false;
					var size = parseInt(data.resApprovalLength);
					for(var i = 0; i < size; i++){
						var compareValue = "resApproval" + i;
						if(data[compareValue] == "승인대기"){
							flag = true;
							break;
						}
						
					} 
					if(flag){
						$("#sendMsg").attr("disabled", "true");
						
					}else{
						$("#sendMsg").removeAttr("disabled");
						$(".checkbox").attr('checked', false);						
					}
				},
				error: function(){
					alert("데이터베이스 연동 실패");
				}
			});
			break;
		case 6:
		case 0:
			$("#sendMsg").attr("disabled", "true");
			break;
		
		}
		
	}	//문자 전송 버튼을 눌렀을때 호출
	
	function compare(check){
		var d = new Date();
		var dd = d.getDate();
		var mm = d.getMonth()+1; //January is 0!
		var yyyy = d.getFullYear();
		if(dd<10) {
		    dd='0'+dd
		} 
		if(mm<10) {
		    mm='0'+mm
		} 
		d = yyyy + '-' + mm + '-' + dd;
		//현재 날짜를 구하여 날짜형식을 지정
		if(d > $('#date' + check).attr("value")){
			$('#checkbox' + check).attr('disabled', true);
		}
		//현재 날짜 이전 예약 내역의 체크박스를 비황성화
	}
	
	window.onload = getInfo(1, true, true);
</script>

</body>
</html>