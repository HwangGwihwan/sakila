<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<!-- Controller -->
<%
	Integer staffId = (Integer)session.getAttribute("loginStaff");
	
	if (staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/loginForm.jsp");
		return;
	}
%>

<!-- Model -->
<%
	Connection conn = null;
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT s.staff_id ID, CONCAT(s.first_name, ' ', s.last_name) NAME, a.address, a.postal_code zipcode, a.phone, ci.city, co.country, s.store_id SID"
			   + " FROM staff s INNER JOIN address a ON s.address_id = a.address_id"
			   + 	" INNER JOIN city ci ON a.city_id = ci.city_id"
			   +	" INNER JOIN country co ON ci.country_id = co.country_id";
	
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (rs.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("Id", rs.getInt("ID"));
		map.put("name", rs.getString("name"));
		map.put("zipCode", rs.getString("zipcode"));
		map.put("phone", rs.getString("a.phone"));
		map.put("city", rs.getString("ci.city"));
		map.put("country", rs.getString("co.country"));
		map.put("Sid", rs.getString("SID"));

		list.add(map);
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
	</head>
	<body>
		<h1>Staff List</h1>
		
		<table border="1">
			<tr>
				<th>Id</th>
				<th>name</th>
				<th>zipCode</th>
				<th>phone</th>
				<th>city</th>
				<th>country</th>
				<th>Sid</th>
			</tr>
			
			<%
				for (HashMap<String, Object> map : list) {
			%>
					<tr>
						<td><%=map.get("Id")%></td>
						<td><%=map.get("name")%></td>
						<td><%=map.get("zipCode")%></td>
						<td><%=map.get("phone")%></td>
						<td><%=map.get("city")%></td>
						<td><%=map.get("country")%></td>
						<td><%=map.get("Sid")%></td>
					</tr>
			<%
				}
			%>
		</table>
	</body>
</html>