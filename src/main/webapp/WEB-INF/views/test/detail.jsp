<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.campus.dto.ComplaintDTO" %>
<%@ page import="com.campus.dto.AnswerDTO" %> <%
    ComplaintDTO complaint = (ComplaintDTO) request.getAttribute("complaint");
    AnswerDTO answer = (AnswerDTO) request.getAttribute("answer"); // 가져온 답변 받기
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>민원 상세</title>
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
    <p><strong>작성일:</strong> <%= complaint.getCreatedAt() %></p>
    <p><strong>수정일:</strong> <%= complaint.getUpdatedAt() %></p>
    <p><strong>완료일:</strong> <%= complaint.getCompletedAt() %></p>

    <hr>

    <h3>민원 내용</h3>
    <p><%= complaint.getContent() %></p>

    <hr>

    <% if (answer != null) { %>
        <h3>담당자 답변</h3>
        <p><strong>담당자:</strong> <%= answer.getStaffName() %></p>
        <p><strong>답변일:</strong> <%= answer.getCreatedAt() %></p>
        
        <p style="color: blue;"><%= answer.getContent() %></p>
        
        <div style="margin-top: 10px; border-top: 1px dashed #ccc; padding-top: 10px;">
            <form action="<%= request.getContextPath() %>/complaints/answer/update" method="post" style="display:inline;">
                <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
                <input type="hidden" name="answerId" value="<%= answer.getAnswerId() %>">
                <textarea name="content" rows="2" cols="40" required><%= answer.getContent() %></textarea>
                <button type="submit">답변 수정</button>
            </form>

            <form action="<%= request.getContextPath() %>/complaints/answer/delete" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
                <input type="hidden" name="answerId" value="<%= answer.getAnswerId() %>">
                <button type="submit" style="color: red;">답변 삭제</button>
            </form>
        </div>
    <% } else { %>
        <h3>[담당자 전용] 답변 달기</h3>
        <form action="<%= request.getContextPath() %>/complaints/answer" method="post">
            <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
            <textarea name="content" rows="4" cols="50" placeholder="민원에 대한 답변을 작성해주세요." required></textarea>
            <br><br>
            <button type="submit">답변 등록 및 완료 처리</button>
        </form>
    <% } %>

<% } %>

<hr>

<a href="<%= request.getContextPath() %>/complaints">목록으로</a>

</body>
</html>