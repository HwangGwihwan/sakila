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
	
	Integer customerId = Integer.parseInt(request.getParameter("customerId"));
	Integer active = Integer.parseInt(request.getParameter("active"));
%>

<!-- Model -->
<%
	Connection conn = null;
	PreparedStatement stmt = null;
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	// active가 0이면 1로
	String sql = "UPDATE customer SET ACTIVE = 1 WHERE customer_id = ?";
	
	// active가 1이면 0으로
	if (active == 1) {
		sql = "UPDATE customer SET ACTIVE = 0 WHERE customer_id = ?";
	}
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, customerId);
	System.out.println(stmt);
	stmt.executeUpdate();
	
	response.sendRedirect("/sakila/d0327/inventoryList.jsp");
%>