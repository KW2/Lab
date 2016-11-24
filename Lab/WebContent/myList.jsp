<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="lab.reservation.service.*" %>
<%@ page import="java.util.Collections" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	
	boolean check = false;									// 로그인 여부 check
    String id = (String)session.getAttribute("UserId");
   	if(id == null){
    	 check = true;
    }
   	
%>
<c:set var="UserId" value="<%= id %>" />

<html>
<head>
<title></title>

<link href="./static/css/jquery-ui.min.css" rel="stylesheet">

<!-- <script src="./static/js/jquery.js"></script>
<script src="./static/js/jquery-ui.min.js"></script>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script> -->

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>


</head>

<body>
	<!-- 비로그인시, 로그인 폼 이동 -->
	<c:if test="<%=check %>">
		<script> alert("로그인 오류 !"); </script>
		<script> location.href = "login.jsp" ;</script>
	</c:if>


	<form id="info_form" action="searchReservation.jsp" method="post" onsubmit="return false;">
		<p>
			조회기간: <input type="text" id="start_date" name="start_date"> ~
					<input type="text" id="end_date" name="end_date"> 
		</p>
		<input type='button' value='검색' onclick="getInfo(1)" />
	</form>

	<table border="1" id="table">
		<tr>
			<td>선택</td>
			<td>날짜</td>
			<td>실습실</td>
			<td>시작시간</td>
			<td>사용시간</td>
			<td>용도</td>
			<td>단체유무</td>
			<td>단체장</td>
			<td>승인여부</td>
		</tr>
		<tbody id="result_body">
		</tbody>
	</table>

<div id="count_body"></div>			<!-- 페이지 번호 자리 -->

<script type="text/javascript">

function reservation_cancel(){				// 취소 버튼 클릭 이벤트 (다중 취소를 위해 배열을 파라미터로 넘긴다.)
	if(confirm("정말 취소하시겠습니까??")==true){
		var array = new Array();		// 일반 예약 취소를 위한 rid 배열
		var arrayG = new Array();		// 단체 예약 이지만 단체장은 아닌 rid 배열
		var arrayGG = new Array();		// 단체 예약 취소(단체장이 본인만 빠짐)를 위한 rid 배열
		var a = 0;
		var b = 0;
		var c = 0;
		 
		$('.caution_check:checked').each(function() { 
			var groupleader = $(this).parent().siblings("#groupleader").html();		// 체크된 예약 정보에 그룹리더 값을 가져옴
			
			if(groupleader == '${UserId}'){											// 그룹 리더와 로그인 아이디 일치 시 단체장 개인 취소
				arrayGG[a] = $(this).siblings("#hidden").val();
				a++;
			}else if(groupleader != " "){																	// 그룹 리더와 로그인 아이디 붕일치 시 일반 예약 취소
				arrayG[b] = $(this).siblings("#hidden").val();
				b++;
			}else{
				array[c] = $(this).siblings("#hidden").val();
				c++;
			}
		});
	    
		location.href = "resDelete.jsp?array="+array+"&arrayG="+arrayG+"&arrayGG="+arrayGG; 			
		// 파라미터로 array(일반 취소할 rid 값들), arrayG(단체예약이지만 단체장이 아닌 rid 값들), arrayGG(단체장 개인 취소할 rid 값들)를 보내준다.
		
	}
	else
		return;
}

function reservation_cancelAll(){													// 단체 취소 버튼 클릭 이벤트
	
	if(confirm("단체 취소하시겠습니까??")==true){
		var rid = $('.caution_check:checked').siblings("#hidden").val();			 
	    location.href = "resDelete.jsp?rid="+rid; 									// 단체장의 예약 rid 값을 보내준다.
	}
	else
		return;
}

function reservation_modify(){														// 수정 하기 버튼 클릭 이벤트
	
	if(confirm("정말 수정하시겠습니까??")==true){
		var rid = $('.caution_check:checked').siblings("#hidden").val();
		var groupleader = $('.caution_check:checked').parent().siblings("#groupleader").html(); 
	
		if(groupleader == '${UserId}'){												// 수정 하는 예약이 단체장의 단체예약인지 확인
			location.href = "index.jsp?pageContent=reservation&rid="+rid+"&groupleader="+groupleader;	// 단체장의 단체예약 수정 시, rid와 groupleader를 보내준다.
		//	location.href = "reservation.jsp?rid="+rid+"&groupleader="+groupleader;
		}else{
			location.href = "index.jsp?pageContent=reservation&rid="+rid;								// 단체 예약 수정이 아니면 rid 값만 보내준다.
		//	location.href = "reservation.jsp?rid="+rid;
		}
		
	}
	else
		return;
}

// 위 3개 메소드에서 resDelete.jsp, resModify.jsp를 1조 페이지로 보내고 1조 페이지에 로직()을 추가한다.

$(document).ready(function() {									// 동적으로 변하는 리스트에 체크박스 체크 여부에 따른 버튼 활성/비활성

	$('.caution_check').live('click', function() {
		if($(".caution_check:checked").length >=1){				// 한개 이상 체그 시 (예약취소),(수정하기) 버튼 활성화
			$('#cancel_btn').attr('disabled',false);
			$('#modify_btn').attr('disabled',false);
			var groupleader = $('.caution_check:checked').parent().siblings("#groupleader").html();
			if(groupleader == "${UserId}"){						// 하나 체크된 예약이 단체장의 단체예약일 경우 (단체취소) 버튼 활성화
				$('#cancelAll_btn').attr('disabled',false).show();
			}
			if($(".caution_check:checked").length >= 2){		// 체크된 값이 두개 이상일 경우, (수정하기) 비활성화, (단체취소) 숨김
				$('#modify_btn').attr('disabled',true);
				$('#cancelAll_btn').attr('disabled',true).hide();
			}
		}else if($(".caution_check:checked").length == 0){		// 체크된 값이 하나도 없을 경우 모든 버튼 비활성화
			$('#cancel_btn').attr('disabled',true);
			$('#modify_btn').attr('disabled',true);
			$('#cancelAll_btn').attr('disabled',true).hide();
		}
	 });

	
});

</script>
	<!-- (예약취소), (수정하기), (단체취소) 버튼  -->												
	<input type="button" id="modify_btn" value="예약수정" disabled="true" onclick="reservation_modify();">
	<input type="button" id="cancel_btn" value="예약취소" disabled="true" onclick="reservation_cancel();">
	<input type="button" id="cancelAll_btn" value="단체취소" disabled="true" style='display: none' onclick="reservation_cancelAll();">

<script>
// ajax를 위한 함수
function getInfo(page) {
	   var form = $("#info_form");
	
	   $.ajax({
	     type: "POST",
	     url: "searchReservation.jsp?page=" + page,
	     data: form.serialize(),
	     success: function(response) {
	        var body = $('#result_body');
	        var cntBody = $('#count_body');
	        body.empty();
	       
	        obj = JSON.parse(response).items;
	        for (var i = 0; i < obj.length; i++) {
	           var newTr = $('<tr id="a'+i+'"></tr>');
	           var newTd0 = $('<td></td>');
	           var newTd1 = $('<td></td>');
	           var newTd2 = $('<td></td>');
	           var newTd3 = $('<td></td>');
	           var newTd4 = $('<td></td>');
	           var newTd5 = $('<td></td>');
	           var newTd6 = $('<td></td>');
	           var newTd7 = $('<td id="groupleader"></td>');
	           var newTd8 = $('<td></td>');
	          
	           newTd0.html('<input type="checkbox" class="caution_check"></input>'
	        		   	  +'<input type="hidden" id="hidden" value="'+obj[i].rid+'"></input>');
	           newTd1.text(obj[i].startdate);
	           newTd2.text(obj[i].labroom);
	           newTd3.text(obj[i].starttime);
	           newTd4.text(obj[i].usingtime);
	           newTd5.text(obj[i].purpose);
	           if(obj[i].team == 'true'){
	        	   newTd6.text('O');   
	           }else if(obj[i].team == 'false'){
	        	   newTd6.text('X');
	           }
	           
	           if(obj[i].groupleader == 'NULL'){     // 그룹 리더 값이 NULL일때 공백으로 표기
	        	   newTd7.text(' ');   
	           }else{
	        	   newTd7.text(obj[i].groupleader);
	           }
	           newTd8.text(obj[i].approval);
	        
	           newTr.append(newTd0);
	           newTr.append(newTd1);
	           newTr.append(newTd2);
	           newTr.append(newTd3);
	           newTr.append(newTd4);
	           newTr.append(newTd5);
	           newTr.append(newTd6);
	           newTr.append(newTd7);
	           newTr.append(newTd8);
	           
	           body.append(newTr);
	        
	        
		       if(i+1 == obj.length){				// 페이지 번호 
		        	$('.page').remove();
			        for(var j = 1; j <= obj[0].pageTotalCount; j++){
			       		cntBody.append($('<a href="javascript:void(0);" class="page" onclick="getInfo(' + j + ');">[' + j + ']</a>'));
			        }
		       }
		   }              
	     },
	     error : function() {
	    	
	     }
	   });
	   
	}
	
// 달력  값 설정
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
    $("#start_date, #end_date").datepicker();
  });
  
  // 처음 페이지 출력시에도 default 값으로 검색.
  window.onload = getInfo(1);
</script>   
</body>
</html>