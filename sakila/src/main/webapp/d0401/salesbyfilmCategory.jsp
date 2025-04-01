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
	String sql = "SELECT c.name category, sum(p.amount) total_sales"
			   + " FROM category c INNER JOIN film_category fc ON c.category_id = fc.category_id"
			   + 	" INNER JOIN film f ON fc.film_id = f.film_id"
			   + 	" INNER JOIN inventory i ON f.film_id = i.film_id"
			   +	" INNER JOIN rental r ON i.inventory_id = r.inventory_id"
			   +	" INNER JOIN payment p ON r.rental_id = p.rental_id"
			   + " GROUP BY c.name"
			   + " ORDER BY total_sales DESC";
	
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (rs.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("category", rs.getString("category"));
		map.put("totalSales", rs.getDouble("total_sales"));
		
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
		<h1>Salse By Film Category</h1>
		
		<table border="1">
			<tr>
				<th>category</th>
				<th>totalSales</th>
			</tr>
			
			<%
				for (HashMap<String, Object> map : list) {
			%>
					<tr>
						<td><%=map.get("category")%></td>
						<td><%=map.get("totalSales")%></td>
					</tr>
			<%
				}
			%>
		</table>
	</body>
</html>