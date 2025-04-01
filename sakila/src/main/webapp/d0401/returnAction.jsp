<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!-- Controller -->
<%
	Integer staffId = (Integer)session.getAttribute("loginStaff");
	
	if (staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/loginForm.jsp");
		return;
	}
	
	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
%>

<!-- Model -->
<%
	Connection conn = null;
	PreparedStatement stmt = null;
	String sql = "update rental set return_date = now() where inventory_id = ?";
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, inventoryId);
	stmt.executeUpdate();
	
	response.sendRedirect("/sakila/d0327/inventoryList.jsp");
%>