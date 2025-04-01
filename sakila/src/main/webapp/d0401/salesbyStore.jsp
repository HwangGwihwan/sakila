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
	String sql = "SELECT GROUP_CONCAT(distinct ci.city, ',', co.country) store, GROUP_CONCAT(distinct sa.first_name, ' ', sa.last_name) manager, sum(p.amount) total_sales"
			   + " FROM store sr INNER JOIN inventory i ON sr.store_id = i.store_id"
			   + 	" INNER JOIN rental r ON i.inventory_id = r.inventory_id"
			   +	" INNER JOIN payment p ON r.rental_id = p.rental_id"
			   +	" INNER JOIN staff sa ON sr.store_id = sa.store_id"
			   +	" INNER JOIN address a ON sr.address_id = a.address_id"
			   +	" INNER JOIN city ci ON a.city_id = ci.city_id"
			   +	" INNER JOIN country co ON ci.country_id = co.country_id"
			   + " GROUP BY sr.store_id"
			   + " ORDER BY total_sales DESC";
	
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (rs.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("store", rs.getString("store"));
		map.put("manager", rs.getString("manager"));
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
		<h1>Sales By Store</h1>
		
		<table border="1">
			<tr>
				<th>store</th>
				<th>manager</th>
				<th>totalSales</th>
			</tr>
			
			<%
				for (HashMap<String, Object> map : list) {
			%>
					<tr>
						<td><%=map.get("store")%></td>
						<td><%=map.get("manager")%></td>
						<td><%=map.get("totalSales")%></td>
					</tr>
			<%
				}
			%>
		</table>
	</body>
</html>