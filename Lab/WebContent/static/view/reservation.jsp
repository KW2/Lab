<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.sql.Time" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="lab.reservation.model.Reservation" %>
<%@ page import="lab.reservation.service.SelectReservationService" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% request.setCharacterEncoding("utf-8"); %>
<%
	Reservation reservationInfo = null;
	List<String> groupInfo = null;
	

	String groupInfoStr = "";
	

	String rid = request.getParameter("rid");
	String groupleader = request.getParameter("groupleader");
	SelectReservationService selectReservationService = SelectReservationService.getInstance();
	boolean updateCheck = false;
	

	if(rid != null){
		reservationInfo = selectReservationService.getReservation(Integer.parseInt(rid));
		updateCheck = true;
	}
	if(groupleader!=null){ 
		 groupInfo = selectReservationService.getGroupSid(groupleader, reservationInfo.getStartdate(), reservationInfo.getStarttime());
	}
	

	if(groupInfo != null){
		String sid = (String)session.getAttribute("UserId");
		

		for(int i = 0; i < groupInfo.size(); i++){
			if(!sid.equals(groupInfo.get(i))){
				if(i == 0){
					groupInfoStr = groupInfo.get(i) + ",";
				}else if(i == groupInfo.size() - 1){
					groupInfoStr = groupInfoStr + groupInfo.get(i);
				}else{
					groupInfoStr = groupInfoStr + groupInfo.get(i) + ",";	
				}	
			}
		}



	}
%>
<c:set var="reservationInfo" value="<%= reservationInfo %>"/>
<c:set var="groupInfoStr" value="<%= groupInfoStr %>"/>
<c:set var="updateCheck" value="<%= updateCheck %>"/>
<c:set var="updateRid" value="<%= rid %>"/>


<link href="./static/css/jquery-ui.min.css" rel="stylesheet">

<script src="./static/js/jquery.js"></script>
<script src="./static/js/jquery-ui.min.js"></script>
<script src="./static/js/jquery.form.js"></script>

<script>

	// 현재시간 획득
	var current_date = new Date();
	var current_date_str = current_date.getFullYear().toString() + "-" 
				+ (current_date.getMonth() + 1).toString() + "-" + current_date.getDate().toString();
	

	// 예약날짜 달력
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
	$(function(){
		$( "#res_date" ).datepicker();
		});
	

	// 예약시간 리스트
    $( "#start_time" ).selectmenu();
    
	// 사용시간 리스트
    $( "#using_time" ).selectmenu();
	

	// 핸들러 메서드 초기화 영역
	$(document).ready(function(){		
		// 수정을 위해 페이지 접속을 한경우, 이전 값들로 초기화 시킨다.
		if("${reservationInfo}"){
			

			// 실습실 초기화
			for(var i = 0; i < $("input[name='lab_radio']").size(); i++){
				var convertLabroom = "${reservationInfo.labroom}".replace("실습실", "lab");
				if($("input[name='lab_radio']")[i].value == convertLabroom){
					$("input[name='lab_radio']")[i].checked = true;
					break;
				}
			}
			



			// 단체여부 초기화
			for(var i = 0; i < $("input[name='group_radio']").size(); i++){
 				if($("input[name='group_radio']")[i].value == "${reservationInfo.team}"){
					$("input[name='group_radio']")[i].checked = true;
					if($("input[name='group_radio']")[i].id == "group"){
						groupTableShow();
						var groupInfo = convertGroupInfo("${groupInfoStr}");
						for(var k = 0; k < groupInfo.length; k++){
							$("input[name='group_id']")[k].value = groupInfo[k];
						}
					}


					break;
				} 
			}



			// 예약날짜 초기화
			// 문자열을 yyyy-mm-dd 형태로 주면 val()의 매개값으로 주면 된다.
			$("#res_date").val("${reservationInfo.startdate}");
			updateInformation();
			

			// 예약시간 초기화
			$("#start_time").val(convertTimeForm("${reservationInfo.starttime}"));
			$("#using_time").val("${reservationInfo.usingtime}");
			

			// 사용용도 초기화
			$("#purpose_text").val("${reservationInfo.purpose}");
		}else{
			// 수정으로 인한 페이지 접속이 아닌경우
			// 초기값으로 현재 날짜를 주고 해당예약인원 표시
			// 초기값으로 단체여부 개인으로 표시
			
			


			for(var i = 0; i < $("input[name='group_radio']").size(); i++){
 				if($("input[name='group_radio']")[i].value == "false"){
					$("input[name='group_radio']")[i].checked = true;
					break;
				} 
			}


			$("#res_date").val(current_date_str);
			updateInformation();
			
		}
		



		// 해당 날짜의 예약인원 표시 및 실습실 상태 확인 이벤트핸들러 등록
		$("#res_date").change(updateInformation);
		$("#start_time").change(searchPossibleLabroom);
		$("#using_time").change(searchPossibleLabroom);
		

		// 단체 기입리스트 추가 이벤트핸들러 등록
		$("input[name='group_radio']").change(groupTableShow);
		

		// 주의사항 모든 체크확인시 submit 버튼 활성화 이벤트핸들러 등록
		for(var i = 0; i < $("input[name='caution_check']").size(); i++){
			$($("input[name='caution_check']")[i]).click(submitAble);
		}
		
		



	});
	

	// 단체 id 문자열 배열로 변환 메서드
	var convertGroupInfo = function(groupInfoStr){
		return groupInfoStr.split(",");
	};
	

	// hh:mm:ss -> hh:mm 변환 메서드
	var convertTimeForm = function(time){
		return time.split(":")[0] + ":" +  time.split(":")[1];
	};
	

	// 예약 인원 카운팅 및 현재 실습실 상태 확인 이벤트핸들러
	// 악의적으로 값을 지우는 경우 현재 날짜로 초기화
	var updateInformation = function(){
		var res_date = $("#res_date").val();
		

		if(res_date == ""){
			$("#res_date").val(current_date_str);
			res_date = current_date_str;
		}


		$.ajax({
			url:'./static/ajax/returnPerson.jsp',
			type: 'POST',
			dataType:'JSON',
			data: {"res_date": res_date},
			success: function(data){
				$('#lab1_person').html(data.lab1);
				$('#lab2_person').html(data.lab2);
				$('#lab3_person').html(data.lab3);
				$('#lab4_person').html(data.lab4);
				$('#lab5_person').html(data.lab5);
			},
			error: function(){
				alert("데이터베이스 연동 실패");
			}

		});
		

		searchPossibleLabroom();
	};
	

	// 현재 실습실 상태 확인
	var searchPossibleLabroom = function(){
		var res_date = $("#res_date").val();
		var start_time = $("#start_time").val(); 
		var using_time = $("#using_time").val();
		

		$.ajax({
			url:'./static/ajax/returnLabroomStatus.jsp',
			type: 'POST',
			dataType:'JSON',
			data: {"res_date": res_date, "start_time": start_time, "using_time": using_time},
			success: function(data){
				if(data.lab1 == null){
					$("#lab1").removeAttr("disabled", true);
					$("#lab2").removeAttr("disabled", true);
					$("#lab3").removeAttr("disabled", true);
					$("#lab4").removeAttr("disabled", true);
					$("#lab5").removeAttr("disabled", true);
					

					$("#lab1_using").html("없음");
					$("#lab2_using").html("없음");
					$("#lab3_using").html("없음");
					$("#lab4_using").html("없음");
					$("#lab5_using").html("없음");
				}else{
					if(data.lab1 != ""){
						$("#lab1").attr("disabled", true);	
						$("#lab1").removeAttr("checked");
						$("#lab1_using").html(data.lab1);
					}else{
						$("#lab1").removeAttr("disabled");
						$("#lab1_using").html("없음");
					}	
					


					if(data.lab2 != ""){
						$("#lab2").attr("disabled", true);
						$("#lab2").removeAttr("checked");
						$("#lab2_using").html(data.lab2);
					}else{
						$("#lab2").removeAttr("disabled");
						$("#lab2_using").html("없음");
					}
					


					if(data.lab3 != ""){
						$("#lab3").attr("disabled", true);
						$("#lab3").removeAttr("checked");
						$("#lab3_using").html(data.lab3);
					}else{
						$("#lab3").removeAttr("disabled");
						$("#lab3_using").html("없음");
					}
					


					if(data.lab4 != ""){
						$("#lab4").attr("disabled", true);
						$("#lab4").removeAttr("checked");
						$("#lab4_using").html(data.lab4);
					}else{
						$("#lab4").removeAttr("disabled");
						$("#lab4_using").html("없음");
					}
					


					if(data.lab5 != ""){
						$("#lab5").attr("disabled", true);
						$("#lab5").removeAttr("checked");
						$("#lab5_using").html(data.lab5);
					}else{
						$("#lab5").removeAttr("disabled");
						$("#lab5_using").html("없음");
					}
				}


			},
			error: function(data){
				console.log(data);
				alert("데이터베이스 연동 실패");
			}

		});
	}
	

	// 단체인 경우 그룹테이블 동적생성 이벤트핸들러
	// str로 모아서 안하고 각각 append로 넣어줄때는 왜 안되는지는 잘 모르겠음
	// groupCheck를 비교할때 groupCheck가 그룹라디오 버튼에서 값을 가져오면 문자열로 감싸져서 true, false 가 리턴되므로 "true", "false" 와 같이 비교한다.
	var groupTableShow = function(){
		var textNumber = 20;
		var str = "";
		var groupCheck = $('input[name="group_radio"]:checked').val();
		if(groupCheck == "true"){
			str += "<table>" + "<tbody>";
			for(var i = 1; i <= textNumber; i++){
				str += "<tr>";
				str += "<td>" + i +  "</td>";
				str += "<td style='width: 10px'/>"
				str += "<td>" + "<input type='text' name='group_id' id=\'field" + i + "\'>" + "</td>";
				str += "</tr>";
			}

			str += "</tbody>" + "</table>";
			$("#group_field").append(str);
			

			// $("input[name='group_id']") 을 하면 각각의 텍스트 필드를 가지고 있는 객체를 리턴한다.
			// console.log($("input[name='group_id']")); 을 확인해보면 0:input#field ... 20:input#field 의 형태로 구성되어 있고
			// $("input[name='group_id']")[0] 은 DOM 객체로 변환되기전 태그이다. 실제로 다음과 같은 값이 리턴된다. <input type="text" name="group_id" id="field1">
			// 이말은 즉슨, 태그를 다시 jquery로 감싸야지 jquery 라이브러리의 메서드를 사용가능하
			// $($("input[name='group_id']")[0]).val(); 의 형태로 텍스트 필드의 값을 가져올수 있다.
			// console.log() 로 객체를 넣어 필요시 객체정보 확인
		}else{
			$("#group_field").html("");
		}

	};
	

	// 주의사항 체크여부 조사
	var cautionChecking = function(){
		for(var i = 0; i < $("input[name='caution_check']").size(); i++){
			if(!$("input[name='caution_check']")[i].checked){
				return false;
			}
		}		


		return true;
	};
	

	// submit 버튼 활성화 이벤트핸들러
	var submitAble = function(){
		var cautionCheck = cautionChecking();
		if(cautionCheck){
			$("#ok_submit").removeAttr("disabled", true);
		}else{
			$("#ok_submit").attr("disabled", true);
		}

	}
	

	// ajaxForm 사용
	// action 페이지를 ajax로 처리하여 그 결과를 받는다. 
	$("#resForm").ajaxForm({
		success: function(data) {
			alert("예약이 완료되었습니다.");
			location.href = "./index.jsp";
		},
		error: function(data) {
			// checkItem의 에서 JSON 으로 보내주는 객체가 responseText로 보내지는데 String 타입으로 온다.
			// 때문에 이를 JSON 객체로 파싱시키고 사용한다.
			// 카운팅 할때 JSON 과는 왜 다른지는 잘 모르겠음
			var obj = $.parseJSON(data.responseText);
			alert(obj.informProblem);
		}

	});
</script>

<html>
<head>
<title>실습실 예약 페이지</title>
<style>
#none{
margin: 0px 0px 0px 0px ;
}
 .container{
width:1100px;
max-width : none !important;

}


</style>
</head>
<body>
<div class="container"  style="overflow: auto; position: absolute;">
	<form id="resForm" action="./static/util/checkItem.jsp" method="post">
	<table class="table table-bordered table-condensed table-hover" border="1" id="table"
				white-space="nonwrap">
			<tr>
				<td>
					01. 실습실 선택하기
				</td>







				<td>





	<table class="table table-bordered" id="none">
				<tr>
				<td >
					실습실 선택
					</td>
					

					<td >
					현재 예약인원
					</td>
					

					<td >
					실습실 특이사항
					</td>
					</tr>
	

					<tr>
					<td>						


					<input id="lab1" type="radio" name="lab_radio" value="실습1실">
					<label for="lab1">실습실1</label>
					</td>
					<td>
					<label id="lab1_person"></label>
					</td>


					<td>
					<label id="lab1_using">없음</label>
					</td>
					


					</tr>
					

					<tr>
					<td>
					<input id="lab2" type="radio" name="lab_radio" value="실습2실">
					<label for="lab2">실습실2</label>
					</td>
					

						<td>
						<label id="lab2_person"></label>
					</td>
		

					<td>
					<label id="lab2_using">없음</label>
					</td>
					</tr>
					

					<tr>
					<td>
					<input id="lab3" type="radio" name="lab_radio" value="실습3실">
					<label for="lab3">실습실3</label>
				
						</td>
						<td>
					<label id="lab3_person"></label>
					</td>
		

					<td>
					<label id="lab3_using">없음</label>
					</td>
					</tr>
					

					<tr>
					<td>
					<input id="lab4" type="radio" name="lab_radio" value="실습4실">
					<label for="lab4">실습실4</label>
					</td>
						<td>
					<label id="lab4_person"></label>
					</td>
		

					<td>
					<label id="lab4_using">없음</label>
					</td>
					</tr>
				

					<tr>
					<td>
					<input id="lab5" type="radio" name="lab_radio" value="실습5실">
					<label for="lab5">실습실5</label>
				</td>
						<td>
					
					<label id="lab5_person"></label><br/>
				</td>
		

					<td>
					<label id="lab5_using">없음</label>
					</td>
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td> 02. 개인/단체 선택</td>
				<td>
					<input id="individual" type="radio" name="group_radio" value="false">
					<label for="individual">개인</label><br/>
				

					<input id="group" type="radio" name="group_radio" value="true">
					<label for="group">단체</label><br/>
				<div id="group_field" style="overflow-y:scroll; width:270px; height:115px; padding:4px;"></div>
				</td>
			</tr>
			<tr>
				<td>
					03. 날짜입력
				</td>
				<td>
				<input type="text" name="res_date" id="res_date" class="form-control" style="width: 200px">
				</td>
			</tr>
			<tr>
			<td>
			 04. 시간입력
			 </td>
			 <td>
			<label for="start_time">시작시간</label>
			<select name="start_time" id="start_time" class="form-control" style="width: 200px">
      			<option>00:00</option>
      			<option>01:00</option>
      			<option>02:00</option>
      			<option>03:00</option>
      			<option>04:00</option>
      			<option>05:00</option>
      			<option>06:00</option>
      			<option>07:00</option>
      			<option>08:00</option>
      			<option>09:00</option>
      			<option>10:00</option>
      			<option>11:00</option>
      			<option>12:00</option>
      			<option>13:00</option>
      			<option>14:00</option>
      			<option>15:00</option>
      			<option>16:00</option>
      			<option>17:00</option>
      			<option>18:00</option>
      			<option>19:00</option>
      			<option>20:00</option>
      			<option>21:00</option>
      			<option>22:00</option>
      			<option>23:00</option>
    		</select>
    		<label for="using_time">사용시간</label>
			<select name="using_time" id="using_time" class="form-control" style="width: 200px">
      			<option>1</option>
      			<option>2</option>
      			<option>3</option>
      			<option>4</option>
      			<option>5</option>
      			<option>6</option>
      			<option>7</option>
      			<option>8</option>
      			<option>9</option>
      			<option>10</option>
      			<option>11</option>
      			<option>12</option>
      			<option>13</option>
      			<option>14</option>
      			<option>15</option>
      			<option>16</option>
      			<option>17</option>
      			<option>18</option>
      			<option>19</option>
      			<option>20</option>
      			<option>21</option>
      			<option>22</option>
      			<option>23</option>
      			<option>24</option>
    		</select>
			</td>
    		</tr>
			<tr>
			<td>
			 	05. 사용용도 입력
			</td>
			<td>
				<input type="text" id="purpose_text" name="purpose_text" class="form-control" maxlength="40" style="width: 500px">
			</td>
			</tr>
	</table>
	<br>
	<br>
	<div id="caution">
		<h3><p>주의사항</p></h3>
		<table id="caution_table">
			<tbody>
				<tr>
					<td>캡스 해제 후 입실합니다. 해제 확인! 두 번 확인!</td>
					

				</tr>
				<tr>
					<td>해제 하지 않고 입실하면 경보가 울립니다.</td>
				</tr>
				<tr>
					<td>경보가 울려 캡스 출동 시 과태료가 부가되오니, 꼭! 유의하세요.</td>
				</tr>
				<tr>
					<td style="margin-right:100pt;">모든 컴퓨터 전원 끄고 정리하기</td>
					<td style="color:white">클릭-></td>
					
					


					<td><input type="checkbox" name="caution_check" id="caution_check1"></td>
				</tr>
				<tr>
					<td>무단속 철저히 (특히 주말)</td>
				</tr>
				<tr> 
					<td>퇴실 시 캡스 세트 합니다. 꼭 합니다.</td>
				</tr>
				<tr >
					<td>캡스 키/열쇠 분실 주의</td>
					<td style="color:white">클릭-></td>
					<td><input type="checkbox" name="caution_check" id="caution_check2"></td>
				</tr>
				<tr>
					<td><strong>캡스 경보 울리지 않도록 주의 합니다.</strong></td>

				</tr>
				<tr>
					<td><strong>부주의로 일어난 모든 책임은 본인(빌리는 사람)에게 있습니다.</strong></td>
				</tr>
				<tr>
					<td>다른 사람에게 열쇠를 넘기더라도 빌려간 사람에게 책임을 묻습니다.</td>
					<td style="color:white">클릭-></td>
					<td><input type="checkbox" name="caution_check" id="caution_check3"></td>
				</tr>
			</tbody>
		</table>
	</div>
	<br>
	<div id="ok">
		<input type="submit" id="ok_submit" class="btn btn-success btn-sm"
			 name="ok_submit" value="제출" disabled="true">
	</div>
	 
	<input type="hidden" name="updateCheck" value="${updateCheck}">
	<input type="hidden" name="updateRid" value="${updateRid}">
	</form>
</div>
</body>
</html>