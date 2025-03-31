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
	Integer customerId = Integer.parseInt(request.getParameter("customerId"));
%>

<!-- Model -->
<%
	Connection conn = null;
	PreparedStatement stmt = null;
	String sql = "INSERT INTO rental(inventory_id, customer_id, staff_id) VALUES (?, ?, ?)";
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, inventoryId);
	stmt.setInt(2, customerId);
	stmt.setInt(3, staffId);
	System.out.println(stmt);
	stmt.executeUpdate();
	
	response.sendRedirect("/sakila/d0325/rentalList.jsp");

%>
