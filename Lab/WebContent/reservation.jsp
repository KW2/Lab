<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>


	<form>
	<div>
		<div id="lab">
			<p>�ǽ���</p>
			<input id="lab1" type="radio" name="lab_radio" value="lab1">
			<label for="lab1">�ǽ�1��</label><br/>
				
			<input id="lab2" type="radio" name="lab_radio" value="lab2">
			<label for="lab2">�ǽ�2��</label><br/>
				
			<input id="lab3" type="radio" name="lab_radio" value="lab3">
			<label for="lab3">�ǽ�3��</label><br/>
				
			<input id="lab4" type="radio" name="lab_radio" value="lab4">
			<label for="lab4">�ǽ�4��</label><br/>
			
			<input id="lab5" type="radio" name="lab_radio" value="lab5">
			<label for="lab5">�ǽ�5��</label><br/>
		</div>
		<div id="i_or_g">
			<p>���δ�ü����</p>
			<input id="individual" type="radio" name="i_or_g_radio" value="individual">
			<label for="individual">����</label><br/>
			
			<input id="group" type="radio" name="i_or_g_radio" value="group">
			<label for="group">��ü</label><br/>
		</div>
	</div>
	<div>
		<div id="date">
			<p>��¥�Է�</p>
			<input id="res_date" type="date" name="res_date" >
		</div>
		<div id="time">
			<p>�ð��Է�</p>
			<label for="start_time">���۽ð�</label>
			<input id="start_time" type="time" name="start_time">
			
			<label for="end_time">����ð�</label>
			<input id="end_time" type="time" name="end_time">
		</div>
	</div> 

	<div id="purpose">
		<p>���뵵</p>
		<input type="text" id="purpose_text" name="purpose_text">
	</div>
	
	<div id="caution">
		<p>���ǻ���</p>
		<table id="caution_table">
			<tbody>
				<tr>
					<td>11111111111111</td>
					<td><input type="checkbox" name="caution_check" id="caution_check1"></td>
				</tr>
				<tr>
					<td>222222222222222</td>
					<td><input type="checkbox" name="caution_check" id="caution_check2"></td>
				</tr>
				<tr>
					<td>33333333333333333</td>
					<td><input type="checkbox" name="caution_check" id="caution_check3"></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div id="ok">
		<input type="submit" id="ok_submit" name="ok_submit" value="����">
	</div>
	</form>
</body>
</html>