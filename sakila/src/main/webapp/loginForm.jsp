<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");

	if (staffId != null) { // 로그인 상태라면
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
		<h1>Staff Login</h1>
		<form action="/sakila/loginAction.jsp" method="post">
			<table border="1">
				<tr>
					<th>staffId</th>
					<td><input type="number" name="staffId"></td>
				</tr>
				<tr>
					<th>password</th>
					<td><input type="password" name="password"></td>
				</tr>
			</table>
			<button type="submit">로그인</button>
		</form>
	</body>
</html>