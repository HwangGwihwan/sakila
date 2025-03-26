<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<!-- Controller -->
<%
	String title = request.getParameter("title");
	System.out.println("title: " + title);
%>

<!-- Model -->
<%
	Connection conn = null;
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	String sql1 = "select f.title, f.description, f.release_year, f.length, f.rating, f.special_features, c.name"
				+ " from film f INNER JOIN film_category fc on f.film_id = fc.film_id"
				+ " INNER JOIN category c ON fc.category_id = c.category_id"
				+ " where title like ?";
			
	
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, "%" + title + "%");
	rs1 = stmt1.executeQuery();
	rs1.next();
	
	HashMap<String, Object> map = new HashMap<String, Object>();
	
	map.put("title", rs1.getString("f.title"));
	map.put("description", rs1.getString("f.description"));
	map.put("releaseYear", rs1.getInt("f.release_year"));
	map.put("length", rs1.getInt("f.length"));
	map.put("rating", rs1.getString("f.rating"));
	map.put("specialFeatures", rs1.getString("f.special_features"));
	map.put("category", rs1.getString("c.name"));
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String sql2 = "SELECT CONCAT_WS(' ', a.first_name, a.last_name) AS name"
				+ " FROM film f INNER JOIN film_actor fa ON f.film_id = fa.film_id"
				+ " INNER JOIN actor a ON fa.actor_id = a.actor_id"
				+ " WHERE f.title LIKE ?";
	
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, "%" + title + "%");
	rs2 = stmt2.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (rs2.next()) {
		HashMap<String, Object> map2 = new HashMap<String, Object>();
		map2.put("name", rs2.getString("name"));
		list.add(map2);
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
		<h1>Film One</h1>
		<table border="1">
			<tr>
				<th>title</th>
				<td><%=map.get("title")%></td>
			</tr>
			<tr>
				<th>description</th>
				<td><%=map.get("description")%></td>
			</tr>
			<tr>
				<th>releaseYear</th>
				<td><%=map.get("releaseYear")%></td>
			</tr>
			<tr>
				<th>length</th>
				<td><%=map.get("length")%></td>
			</tr>
			<tr>
				<th>rating</th>
				<td><%=map.get("rating")%></td>
			</tr>
			<tr>
				<th>specialFeatures</th>
				<td><%=map.get("specialFeatures")%></td>
			</tr>
			<tr>
				<th>category</th>
				<td><%=map.get("category")%></td>
			</tr>
			<tr>
				<th>actor</th>
				<td>
				<%
					for (HashMap<String, Object> map2 : list) {
				%>
						<a href='/sakila/d0326/actorOne.jsp?name=<%=map2.get("name")%>'><%=map2.get("name")%></a>
						<br>
				<%
					}
				%>
				</td>
			</tr>
		</table>
		
	</body>
</html>