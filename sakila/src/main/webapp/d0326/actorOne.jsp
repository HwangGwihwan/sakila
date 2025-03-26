<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<!-- Controller -->
<%
	String name = request.getParameter("name");
	System.out.println("name: " + name);
%>

<!-- Model -->
<%
	Connection conn = null;
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT f.title FROM film f INNER JOIN film_actor fa ON f.film_id = fa.film_id"
				+ " INNER JOIN actor a ON fa.actor_id = a.actor_id"
				+ " WHERE CONCAT_WS(' ', first_name, last_name) LIKE ?";
	
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, "%" + name + "%");
	rs = stmt.executeQuery();
	rs.next();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (rs.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("title", rs.getString("f.title"));
		list.add(map);
	}
	
%>
<!-- View -->
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
	</head>
	<body>
		<h1>Actor One</h1>
		<table border="1">
			<tr>
				<th>name</th>
				<td><%=name%></td>
			</tr>
			<tr>
				<th>film</th>
				<td>
				<%
					for (HashMap<String, Object> map : list) {
				%>
						<a href='/sakila/d0326/filmOne.jsp?title=<%=map.get("title")%>'><%=map.get("title")%></a>
						<br>
				<%
					}
				%>
				</td>
			</tr>
		</table>
	</body>
</html>

