<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<!-- Controller -->
<%
	int actorId = Integer.parseInt(request.getParameter("actorId"));
	System.out.println("actorId: " + actorId);
%>

<!-- Model -->
<%
	Connection conn = null;
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	String sql1 = "SELECT CONCAT_WS(' ', first_name, last_name) AS name FROM actor WHERE actor_id = ?";
	
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setInt(1, actorId);
	rs1 = stmt1.executeQuery();
	rs1.next();
	
	String actorName = rs1.getString("name");
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String sql2 = "SELECT f.film_id, f.title FROM film f INNER JOIN film_actor fa ON f.film_id = fa.film_id"
				+ " INNER JOIN actor a ON fa.actor_id = a.actor_id"
				+ " WHERE a.actor_id = ?";
	
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, actorId);
	rs2 = stmt2.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (rs2.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("filmId", rs2.getInt("f.film_id"));
		map.put("title", rs2.getString("f.title"));
		list.add(map);
	}
	
%>
<!-- View -->
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
		<style>
			body {
				padding: 5px;
				text-align: center;
				width: 100%;
			}
			#table {
				margin: 20px auto;
				border: 1px solid black;
				border-radius: 10px;
			}
			#table th, td {
				border: 1px solid black;
				padding: 10px;
				text-aglin: center;
			}
		</style>
	</head>
	<body>
		<h1>Actor One</h1>
		<table id="table">
			<tr>
				<th>name</th>
				<td><%=actorName%></td>
			</tr>
			<tr>
				<th>film</th>
				<td>
				<%
					for (HashMap<String, Object> map : list) {
				%>
						<a href='/sakila/d0326/filmOne.jsp?filmId=<%=map.get("filmId")%>'><%=map.get("title")%></a>
						<br>
				<%
					}
				%>
				</td>
			</tr>
		</table>
	</body>
</html>

