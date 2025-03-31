<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!-- Controller -->
<% 
	//로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");
	
	if (staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/loginForm.jsp");
		return;
	}

	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	Integer customerId = null;
	if (request.getParameter("customerId") != null) {
		// 이름검색 후 이 페이지가 다시 요청되면 customerId값을 받아 온다
		customerId = Integer.parseInt(request.getParameter("customerId"));
	}
%>

<!-- Model -->
<%
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "select i.inventory_id inventroyId, i.film_id filmId, f.title, i.store_id storeId from inventory i inner join film f on i.film_id = f.film_id where inventory_id=?";
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, inventoryId);
	System.out.println(stmt);
	rs = stmt.executeQuery();
%>

<!-- View -->
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
	</head>
	<body>
		<h1>Insert Rental Inventory</h1>
		<%
			if (rs.next()) {
		%>
			<form action="/sakila/d0331/searchCustomIdList.jsp" method="post">
				<input type="hidden" name="inventoryId" value='<%=inventoryId%>'>
				<input type="text" name="searchName">
				<button type="submit">이름으로 customerId검색</button>
			</form>
			<!--
				insertRentalForm.jsp -> 이름검색 -> SearchCustomerList.jsp -> insertRentalForm.jsp 
			 -->
			<form action="/sakila/d0331/insertRentalAction.jsp" method="post">
				<table border="1">
					<tr>
						<td>customerId</td>
						<td>
							<input type="text" name="customerId" value='<%=customerId%>' readonly>
						</td>
					</tr>
					<tr>
						<td>inventroyId</td>
						<td><input type="text" name="inventoryId" value='<%=inventoryId%>' readonly></td>
					</tr>
					<tr>
						<td>filmId</td>
						<td>
							<input type="text" name="filmId" value='<%=rs.getInt("filmId")%>' readonly> /
							<%=rs.getString("title")%>
						</td>
					</tr>
					<tr>
						<td>storeId</td>
						<td><input type="text" name="storeId" value='<%=rs.getInt("storeId")%>' readonly></td>
					</tr>
					<tr>
						<td>staffId</td>
						<td><input type="text" name="staffId" value='<%=staffId%>' readonly></td>
					</tr>
				</table>
				<button type="submit">대여하기</button>
			</form>
		
		<%
			}
		%>
		
	</body>
</html>