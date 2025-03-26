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
	
	int storeId = 0;
	if (request.getParameter("storeId") != null) {
		storeId = Integer.parseInt(request.getParameter("storeId"));
	}
	
	String searchWord = request.getParameter("searchWord");
	if (searchWord == null) {
		searchWord = "";
	}
	
	System.out.println("storeId: " + storeId);
	System.out.println("searchWord: " + searchWord);
%>

<!-- Model -->
<%
	Connection conn = null;
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	String sql1 = "SELECT count(*) cnt"
					+ " FROM"
					+ " (SELECT t1.rental_id, i.inventory_id, t1.name, t1.customer_id, t1.rental_date, t1.return_date, i.film_id, i.store_id"
					+ " FROM"
					+ " (SELECT CONCAT_WS(' ', c.first_name, c.last_name) AS name, c.customer_id, r.rental_id, r.rental_date, r.return_date, r.inventory_id"
					+ " FROM customer c INNER JOIN rental r"
					+ " ON c.customer_id = r.customer_id) t1 INNER JOIN inventory i"
					+ " ON t1.inventory_id = i.inventory_id) t2 INNER JOIN film f"
					+ " ON t2.film_id = f.film_id";
	
	if (searchWord.equals("")) { // searchWord가 공백일때
		if (storeId == 0) { // storeId가 0일때 --> 전체개수
			stmt1 = conn.prepareStatement(sql1);
		} else { // storeId가 0이 아님 --> 1, 2 조건에 맞는 개수
			sql1 += " WHERE t2.store_id = ?";
		
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setInt(1, storeId);
		}
	} else { // searchWord가 공백이 아닐때
		if (storeId == 0) { // 제목에 searchWord가 포함된 개수 검색
			sql1 += " WHERE f.title LIKE ?";
		
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setString(1, "%" + searchWord + "%");
		} else { // storeId 조건에 맞고, 제목에 searchWord가 포함된 개수 검색
			sql1 += " WHERE f.title LIKE ? AND t2.store_id = ?";
		
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setString(1, "%" + searchWord + "%");
			stmt1.setInt(2, storeId);
		}
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
	String sql2 = "SELECT t2.rental_id, f.title, t2.inventory_id, t2.name, t2.customer_id, t2.rental_date, t2.return_date, t2.store_id"
				+ " FROM"
				+ " (SELECT t1.rental_id, i.inventory_id, t1.name, t1.customer_id, t1.rental_date, t1.return_date, i.film_id, i.store_id"
				+ " FROM"
				+ " (SELECT CONCAT_WS(' ', c.first_name, c.last_name) AS name, c.customer_id, r.rental_id, r.rental_date, r.return_date, r.inventory_id"
				+ " FROM customer c INNER JOIN rental r"
				+ " ON c.customer_id = r.customer_id) t1 INNER JOIN inventory i"
				+ " ON t1.inventory_id = i.inventory_id) t2 INNER JOIN film f"
				+ " ON t2.film_id = f.film_id";
	
	if (searchWord.equals("")) { // searchWord가 공백일때
		if (storeId == 0) { // storeId가 0일때 --> 전체검색
			sql2 = sql2 + " ORDER BY t2.rental_id ASC"
						+ " LIMIT ?, ?";
		
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setInt(1, startRow);
			stmt2.setInt(2, rowPerPage);
		} else { // storeId가 0이 아님 --> 1, 2 조건에 맞게 검색
			sql2 = sql2 + " WHERE t2.store_id = ?"
						+ " ORDER BY t2.rental_id ASC"
						+ " LIMIT ?, ?"; 
		
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setInt(1, storeId);
			stmt2.setInt(2, startRow);
			stmt2.setInt(3, rowPerPage);
		}
	} else { // searchWord가 공백이 아닐때
		if (storeId == 0) { // 제목에 searchWord가 포함된 행 검색
			sql2 = sql2 + " WHERE f.title LIKE ?"
						+ " ORDER BY t2.rental_id ASC"
						+ " LIMIT ?, ?";
		
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, "%" + searchWord + "%");
			stmt2.setInt(2, startRow);
			stmt2.setInt(3, rowPerPage);
		} else { // storeId 조건에 맞고, 제목에 searchWord가 포함된 행 검색
			sql2 = sql2 + " WHERE f.title LIKE ? AND t2.store_id = ?"
						+ " ORDER BY t2.rental_id ASC"
						+ " LIMIT ?, ?";
		
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, "%" + searchWord + "%");
			stmt2.setInt(2, storeId);
			stmt2.setInt(3, startRow);
			stmt2.setInt(4, rowPerPage);
		}
	}
	
	rs2 = stmt2.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (rs2.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("rentalId", rs2.getInt("rental_id"));
		map.put("filmTitle", rs2.getString("title"));
		map.put("inventoryId", rs2.getInt("inventory_id"));
		map.put("name", rs2.getString("name") + "(" + rs2.getInt("customer_id") + ")");
		map.put("rentalDate", rs2.getString("rental_date"));
		map.put("returnDate", rs2.getString("return_date"));
		
		list.add(map);
	}
%>

<!-- View -->
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
		<style>
			body {
				margin: 0;
				padding: 5px;
				width: 80%;
				text-align: center;
			}
			#table {
				width: 80%;
				margin: 20px auto;
				border: 1px solid black;
				border-radius: 10px;
			}
			#table th, #table td {
				border: 1px solid black;
				padding: 10px;
				text-align: center;
			}
			#table tr:nth-child(even) {
				background-color: #f2f2f2;
			}
			#page {
				margin-top: 20px;
				text-align: center;
			}
			#page a {
				display: inline-block;
				padding: 4px 8px;
				margin: 0 5px;
				text-decoration: none;
				color: black;
				border: 1px solid black;
				border-radius: 15px;
			}
		</style>
	</head>
	<body>
		<h1>Rental List</h1>
		<form action="/sakila/d0325/rentalList.jsp">
			<input type="hidden" name="searchWord" value=<%=searchWord%>>
			Store :
			<select name="storeId">
				<option value="0" <%if (storeId == 0) {%> selected="selected" <%}%>>전체</option>
				<option value="1" <%if (storeId == 1) {%> selected="selected" <%}%>>1지점</option>
				<option value="2" <%if (storeId == 2) {%> selected="selected" <%}%>>2지점</option>
			</select>
			<button type="submit">검색</button>
		</form>
		
		<table id="table">
			<tr>
				<th>rentalId</th>
				<th>filmTitle</th>
				<th>inventoryId</th>
				<th>name(customerId)</th> <!-- name = first_name + last_name -->
				<th>rentalDate</th>
				<th>returnDate</th>
			</tr>
			<%
				for (HashMap<String, Object> map : list) {
			%>
					<tr>
						<td><%=map.get("rentalId")%></td>
						<td><%=map.get("filmTitle")%></td>
						<td><%=map.get("inventoryId")%></td>
						<td><%=map.get("name")%></td>
						<td><%=map.get("rentalDate")%></td>
						<td><%=map.get("returnDate")%></td>
					</tr>
			<%
				}
			%>
		</table>
		
		<!-- 페이징 -->
		<div id="page">
			<a href='/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=1'>[처음]</a>
			
			<%
				if (currentPage > 10) {
			%>
					<a href='/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=<%=currentPage - 10%>'>[이전10]</a>
			<%
				}
			
				int startPage = currentPage / 10; // 보여줄 페이지 시작
				if (currentPage % 10 != 0) { // 0~10페이지 -> 1, 11~20페이지 -> 2
					startPage++;
				}
				startPage = (startPage - 1) * 10; // 시작 페이지 결정 0, 10, 20 ...
			
				int endPage = lastPage / 10; // 다음[10] 페이지를 보여줄 수 있는 마지막 페이지 구하기
				if (lastPage % 10 == 0) {
					endPage--;
				}
				endPage = endPage * 10;
				
				for (int i = 1; i <= 10; i++) {
					if (startPage + i <= lastPage) { // 마지막 페이지까지만 보이게
			%>
						<a href='/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=<%=startPage + i%>'><%=startPage + i%></a>
			<%
					}
				}
				
				
				if (currentPage <= endPage) { // 10페이지를 뒤로 넘길 수 있는 페이지가 맞으면
					if (currentPage + 10 <= lastPage) {
			%>
						<a href='/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=<%=currentPage + 10%>'>[다음10]</a>
			<%
					} else { // 10페이지를 더했을때 마지막페이지보다 크면 마지막페이지로 강제로 이동
			%>
						<a href='/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=<%=lastPage%>'>[다음10]</a>
			<%
					}
				}
				
			%>
	
			<a href='/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=<%=lastPage%>'>[마지막]</a>
		</div>
		
		<form action="/sakila/d0325/rentalList.jsp">
			<input type="hidden" name="storeId" value=<%=storeId%>>
			filmTitle Search Word :
			<input type="text" name="searchWord" value=<%if(!searchWord.equals("")){%><%=searchWord%><%}%>>
			<button type="submit">검색</button>
		</form>
	</body>
</html>