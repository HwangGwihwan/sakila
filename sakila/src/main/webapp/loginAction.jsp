<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
	//staffId, password
	int staffId = Integer.parseInt(request.getParameter("staffId"));
	String password = request.getParameter("password");
	
	Connection conn = null;
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");

	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "select staff_id staffId, first_name firstName from staff where staff_id = ? and password = ?";
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, staffId);
	stmt.setString(2, password);
	rs = stmt.executeQuery();
	
	boolean isLogin = false;
	if (rs.next()) {
		// 로그인 성공
		System.out.println("로그인 성공");
		// 현재세션영역에 loginStaff변수를 생성(이 변수가 접속자의 세션에 있다면 로그인된 상태, 없으면 로그아웃 상태)
		session.setAttribute("loginStaff", rs.getInt("staffId"));
		response.sendRedirect("/sakila/index.jsp");
	} else {
		// 로그인 실패
		System.out.println("로그인 실패");
		response.sendRedirect("/sakila/loginForm.jsp");
	}
	
%>


