<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.dto.ComplaintDTO" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>민원 목록</title>
</head>
<body>

<%--테스트 용 민원 목록 페이지--%>

<h1>민원 목록</h1>

<hr>
<%
    List<ComplaintDTO> complaints =
            (List<ComplaintDTO>) request.getAttribute("complaints");
%>

<%
    if (complaints == null || complaints.isEmpty()) {
%>

<p>등록된 민원이 없습니다.</p>

<% } else { %>

<table border="1" cellpadding="8" cellspacing="0">
    <thead>
    <tr>
        <th>ID</th>
        <th>제목</th>
        <th>작성자</th>
        <th>담당 부서</th>
        <th>카테고리</th>
        <th>상태</th>
        <th>추천 수</th>
        <th>작성일</th>
    </tr>
    </thead>

    <tbody>
    <% for (ComplaintDTO complaint : complaints) { %>
    <tr>
        <td><%= complaint.getComplaintId() %></td>

        <td>
            <a href="<%= request.getContextPath() %>/complaints/detail?id=<%= complaint.getComplaintId() %>">
                <%= complaint.getTitle() %>
            </a>
        </td>

        <td><%= complaint.getWriterName() %></td>
        <td><%= complaint.getDepartmentName() %></td>
        <td><%= complaint.getCategory() %></td>
        <td><%= complaint.getStatus() %></td>
        <td><%= complaint.getLikeCount() %></td>
        <td><%= complaint.getCreatedAt() %></td>
    </tr>
    <% } %>
    </tbody>
</table>

<% } %>

<hr>

<a href="<%= request.getContextPath() %>/complaints/new">민원 작성</a>

</body>
</html>