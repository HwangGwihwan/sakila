<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<!-- Controller -->
<%
	int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	System.out.println("CurrentPage: " + currentPage);
	
	int rowPerPage = 7;
	int startRow = (currentPage - 1) * rowPerPage;
	
	String searchWord = request.getParameter("searchWord");
	if (searchWord == null) {
		searchWord = "";
	}
	
	System.out.println("searchWord: " + searchWord);
%>

<!-- Model -->
<%
	Connection conn = null;
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");

	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	
	// searchWord 공백일때
	String sql1 = "select count(*) cnt from film";
	stmt1 = conn.prepareStatement(sql1);
	
	if (!searchWord.equals("")) { // 공백 아닐때
		sql1 += " where title like ?";
		stmt1 = conn.prepareStatement(sql1);
		stmt1.setString(1, "%" + searchWord + "%");
	}
	
	rs1 = stmt1.executeQuery();
	rs1.next();
	
	int totalCnt = rs1.getInt("cnt");
	int lastPage = totalCnt / rowPerPage;
	if (totalCnt % rowPerPage != 0) {
		lastPage++;
	}
	
	System.out.println("totalCnt: " + totalCnt);
	System.out.println("lastPage: " + lastPage);
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	// searchWord 공백일때
	String sql2 = "select film_id, title, release_year from film order by film_id limit ?, ?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, startRow);
	stmt2.setInt(2, rowPerPage);
	
	if (!searchWord.equals("")) {
		sql2 = "select film_id, title, release_year from film where title like ? order by film_id limit ?, ?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, "%" + searchWord + "%");
		stmt2.setInt(2, startRow);
		stmt2.setInt(3, rowPerPage);
	}
	
	rs2 = stmt2.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (rs2.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("filmId", rs2.getInt("film_id"));
		map.put("title", rs2.getString("title"));
		map.put("releaseYear", rs2.getInt("release_year"));
		
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
		<h1>Film List</h1>
		
		<form action="/sakila/d0326/filmList.jsp">
			Search:
			<input type="text" name="searchWord" value=<%if(!searchWord.equals("")){%><%=searchWord%><%}%>>
			<button type="submit">검색</button>
		</form>
		
		<table border="1">
			<tr>
				<th>filmId</th>
				<th>title</th>
				<th>releaseYear</th>
			</tr>
			
			<%
				for (HashMap<String, Object> map : list) {
			%>
					<tr>
						<td><%=map.get("filmId")%></td>
						<td>
							<a href='/sakila/d0326/filmOne.jsp?title=<%=map.get("title")%>'><%=map.get("title")%></a>
						</td>
						<td><%=map.get("releaseYear")%></td>
					</tr>
			<%
				}
			%>
		</table>
		
		<!-- 페이징 -->
		<a href='/sakila/d0326/filmList.jsp?currentPage=1&searchWord=<%=searchWord%>'>[처음]</a>
		
		<%
			if (currentPage > 10) {
		%>
				<a href='/sakila/d0326/filmList.jsp?currentPage=<%=currentPage - 10%>&searchWord=<%=searchWord%>'>[이전10]</a>
		<%
			}
		
			int startPage = currentPage / 10; // 보여줄 페이지 시작
			if (currentPage % 10 != 0) { // 0~10페이지 -> 1, 11~20페이지 -> 2
				startPage++;
			}
			startPage = (startPage - 1) * 10; // 시작 페이지 결정 0, 10, 20 ...
			
			int endPage = startPage  + 10; // 보여줄 페이지 끝 10, 20, 30 ...
			
			for (int i = 1; i <= 10; i++) {
				if (startPage + i <= lastPage) { // 마지막 페이지까지만 보이게
		%>
					<a href='/sakila/d0326/filmList.jsp?currentPage=<%=startPage + i%>&searchWord=<%=searchWord%>'><%=startPage + i%></a>
		<%
				}
			}
			
			if (endPage < lastPage) { // lastPage보다 보여줄 페이지 끝이 작아야 다음[10] 뜨게
				if (endPage + 10 > lastPage) { 
					// 다음 10페이지를 넘겼을 때 마지막페이지보다 크면 다음[10]을 눌렀을 때 마지막 페이지가 되도록 currentPage 조정
					currentPage = lastPage - 10;
				}
		%>
				<a href='/sakila/d0326/filmList.jsp?currentPage=<%=currentPage + 10%>&searchWord=<%=searchWord%>'>[다음10]</a>
		<%
			}
		%>
		<a href='/sakila/d0326/filmList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord%>'>[마지막]</a>
	</body>
</html>