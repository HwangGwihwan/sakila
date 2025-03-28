<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!-- Controller -->
<%

	//로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");

	if (staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/index.jsp");
		return;
	}
	
	String currentPw = request.getParameter("currentPw");
	String updatePw = request.getParameter("updatePw");
	
	System.out.println("currentPw: " + currentPw);
	System.out.println("updatePw: " + updatePw);
%>

<!-- Model -->
<%
	Connection conn = null;
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	PreparedStatement stmt = null;
	int row = 0;
	String sql = "update staff set password = ? where staff_id = ? and password = ?";
	
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, updatePw);
	stmt.setInt(2, staffId);
	stmt.setString(3, currentPw);
	row = stmt.executeUpdate();

	if (row == 0) {
		response.sendRedirect("/sakila/updatePasswordForm.jsp");		
	} else {
		response.sendRedirect("/sakila/logout.jsp");
	}

%>