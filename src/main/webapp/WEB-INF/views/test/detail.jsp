<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.campus.dto.ComplaintDTO" %>

<%!
    private String dateText(java.util.Date date) {
        if (date == null) return "";
        return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    }
%>

<%
    ComplaintDTO complaint = (ComplaintDTO) request.getAttribute("complaint");
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>민원 상세</title>
    <link rel="icon" type="image/svg+xml" href="<%= request.getContextPath() %>/assets/images/leaf_logo.svg">
</head>
<body>

<h1>민원 상세</h1>

<hr>

<% if (complaint == null) { %>

<p>민원 정보를 불러올 수 없습니다.</p>

<% } else { %>

<p><strong>민원 ID:</strong> <%= complaint.getComplaintId() %></p>
<p><strong>제목:</strong> <%= complaint.getTitle() %></p>
<p><strong>작성자:</strong> <%= complaint.getWriterName() %></p>
<p><strong>담당 부서:</strong> <%= complaint.getDepartmentName() %></p>
<p><strong>카테고리:</strong> <%= complaint.getCategory() %></p>
<p><strong>상태:</strong> <%= complaint.getStatus() %></p>
<p><strong>추천 수:</strong> <%= complaint.getLikeCount() %></p>
<p><strong>비공개 여부:</strong> <%= complaint.isPrivateFlag() %></p>
<p><strong>작성일:</strong> <%= dateText(complaint.getCreatedAt()) %></p>
<p><strong>수정일:</strong> <%= dateText(complaint.getUpdatedAt()) %></p>
<p><strong>완료일:</strong> <%= dateText(complaint.getCompletedAt()) %></p>

<hr>

<h3>민원 내용</h3>
<p><%= complaint.getContent() %></p>

<% } %>

<hr>

<a href="<%= request.getContextPath() %>/complaints">목록으로</a>

</body>
</html>
