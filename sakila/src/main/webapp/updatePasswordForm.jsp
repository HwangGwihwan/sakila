<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");
	
	if (staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/index.jsp");
		return;
	}
	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
	</head>
	<body>
		<h1>비밀번호 수정</h1>
		<form action="/sakila/updatePasswordAction.jsp">
			<table border="1">
				<tr>
					<th>현재 비밀번호</th>
					<td>
						<input type="password" name="currentPw">
					</td>					
				</tr>
				<tr>
					<th>새 비밀번호</th>
					<td>
						<input type="password" name="updatePw">
					</td>					
				</tr>
			</table>
			<button type="submit">비밀번호 수정</button>
		</form>
	</body>
</html>