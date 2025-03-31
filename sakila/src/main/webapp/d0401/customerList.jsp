<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<!-- Controller -->
<%
	//로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");
	
	if (staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/loginForm.jsp");
		return;
	}
	
	int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	System.out.println("CurrentPage: " + currentPage);
	
	int rowPerPage = 7;
	int startRow = (currentPage - 1) * rowPerPage;
%>

<!-- Model -->
<%
	Connection conn = null;
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	
	// searchWord 공백일때
	String sql1 = "select count(*) cnt"
				+ " FROM customer cs INNER JOIN address a"
				+ " ON cs.address_id = a.address_id"
				+ " INNER JOIN city ct"
				+ " ON a.city_id = ct.city_id"
				+ " INNER JOIN country cn"
				+ " ON ct.country_id = cn.country_id";
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	rs1.next();
	
	String sql2 = "SELECT cs.customer_id customerId, CONCAT(cs.first_name, ' ', cs.last_name) name, a.address address, a.district district, ct.city city, cn.country country"
				+ " FROM customer cs INNER JOIN address a"
				+ " ON cs.address_id = a.address_id"
				+ " INNER JOIN city ct"
				+ " ON a.city_id = ct.city_id"
				+ " INNER JOIN country cn"
				+ " ON ct.country_id = cn.country_id";
%>

<!-- View -->
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
	</head>
	<body>
		
	</body>
</html>