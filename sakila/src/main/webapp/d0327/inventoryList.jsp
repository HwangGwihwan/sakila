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
	
	int rowPerPage = 10;
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
	String sql1 = "SELECT count(*) cnt"
				+ " FROM film f INNER JOIN ("
				+ " SELECT i.inventory_id, i.film_id, t.rental_date, t.return_date"
				+ " FROM inventory i LEFT OUTER JOIN ("
				+ " SELECT inventory_id, rental_date, return_date"
				+ " FROM rental"
				+ " WHERE (inventory_id, rental_date) IN (SELECT inventory_id, max(rental_date)"
				+ " FROM rental"
				+ " GROUP BY inventory_id)) t"
				+ " ON i.inventory_id = t.inventory_id) t2"
				+ " ON f.film_id = t2.film_id";
	stmt1 = conn.prepareStatement(sql1);
	
	if (!searchWord.equals("")) { // 공백 아닐때
		sql1 += " where f.title LIKE ?";
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
	
	String sql2 = "SELECT t2.inventory_id, f.title, t2.rental_date, t2.return_date"
			+ " FROM film f INNER JOIN ("
			+ " SELECT i.inventory_id, i.film_id, t.rental_date, t.return_date"
			+ " FROM inventory i LEFT OUTER JOIN ("
			+ " SELECT inventory_id, rental_date, return_date"
			+ " FROM rental"
			+ " WHERE (inventory_id, rental_date) IN (SELECT inventory_id, max(rental_date)"
			+ " FROM rental"
			+ " GROUP BY inventory_id)) t"
			+ " ON i.inventory_id = t.inventory_id) t2"
			+ " ON f.film_id = t2.film_id";
	
	if (searchWord.equals("")) {
		// searchWord 공백일때
		sql2 = sql2 + " ORDER BY t2.inventory_id"
					+ " LIMIT ?, ?";

		stmt2 = conn.prepareStatement(sql2);
		stmt2.setInt(1, startRow);
		stmt2.setInt(2, rowPerPage);
	} else { // 공백 아닐때
		sql2 = sql2 + " where f.title LIKE ?"
				+ " ORDER BY t2.inventory_id"
				+ " LIMIT ?, ?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, "%" + searchWord + "%");
		stmt2.setInt(2, startRow);
		stmt2.setInt(3, rowPerPage);
	}
	
	rs2 = stmt2.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (rs2.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("inventoryId", rs2.getInt("t2.inventory_id"));
		map.put("title", rs2.getString("f.title"));
		map.put("rentalDate", rs2.getString("t2.rental_date"));
		map.put("returnDate", rs2.getString("t2.return_date"));
		
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
		<h1>Inventory List</h1>
		
		<form action="/sakila/d0327/inventoryList.jsp">
			Search:
			<input type="text" name="searchWord" value=<%if(!searchWord.equals("")){%><%=searchWord%><%}%>>
			<button type="submit">검색</button>
		</form>
		
		<table border="1">
			<tr>
				<th>inventoryId</th>
				<th>title</th>
				<th>returnDate</th>
				<th>대여</th>
			</tr>
			
			<%
				for (HashMap<String, Object> map : list) {
			%>
					<tr>
						<td><%=map.get("inventoryId")%></td>
						<td><%=map.get("title")%></td>
						<td><%=map.get("returnDate")%></td>
						<td>
						<%
							if (map.get("rentalDate") != null && map.get("returnDate") == null) {
								// rentalDate는 null이 아님 -> 대여 했음 && retunDate가 null임 -> 반납 안했음
								// 대여 불가능
							} else { // 나머지 조건은 대여 가능
						%>
								<a href="">대여</a>
						<%
							}
						%>
						</td>
					</tr>
			<%
				}
			%>
		</table>
		<!-- 페이징 -->
		<a href='/sakila/d0327/inventoryList.jsp?currentPage=1&searchWord=<%=searchWord%>'>[처음]</a>
		
		<%
			if (currentPage > 10) {
		%>
				<a href='/sakila/d0327/inventoryList.jsp?currentPage=<%=currentPage - 10%>&searchWord=<%=searchWord%>'>[이전10]</a>
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
					<a href='/sakila/d0327/inventoryList.jsp?currentPage=<%=startPage + i%>&searchWord=<%=searchWord%>'><%=startPage + i%></a>
		<%
				}
			}
			
			if (endPage < lastPage) { // lastPage보다 보여줄 페이지 끝이 작아야 다음[10] 뜨게
				if (endPage + 10 > lastPage) { 
					// 다음 10페이지를 넘겼을 때 마지막페이지보다 크면 다음[10]을 눌렀을 때 마지막 페이지가 되도록 currentPage 조정
					currentPage = lastPage - 10;
				}
		%>
				<a href='/sakila/d0327/inventoryList.jsp?currentPage=<%=currentPage + 10%>&searchWord=<%=searchWord%>'>[다음10]</a>
		<%
			}
		%>
		<a href='/sakila/d0327/inventoryList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord%>'>[마지막]</a>
	</body>
</html>