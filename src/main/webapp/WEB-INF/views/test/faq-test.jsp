<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.dto.FaqDTO" %>
<%@ page import="com.campus.dto.ComplaintDTO" %>

<%
    List<FaqDTO> similarFaqs =
            (List<FaqDTO>) request.getAttribute("similarFaqs");

    List<ComplaintDTO> similarComplaints =
            (List<ComplaintDTO>) request.getAttribute("similarComplaints");

    Boolean showResult =
            (Boolean) request.getAttribute("showSimilarBox");

    String title = request.getParameter("title") != null ? request.getParameter("title") : "";
    String content = request.getParameter("content") != null ? request.getParameter("content") : "";
    String category = request.getParameter("category") != null ? request.getParameter("category") : "";
    String departmentId = request.getParameter("departmentId") != null ? request.getParameter("departmentId") : "";
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>FAQ / 유사민원 추천 테스트</title>
</head>
<body>

<h1>FAQ / 유사민원 추천 테스트</h1>

<hr>

<form action="<%= request.getContextPath() %>/complaints/check" method="post">
    <p>
        제목<br>
        <input type="text" name="title" value="<%= title %>" style="width:500px;">
    </p>

    <p>
        내용<br>
        <textarea name="content" style="width:500px; height:100px;"><%= content %></textarea>
    </p>

    <p>
        카테고리<br>
        <select name="category">
            <option value="전산" <%= "전산".equals(category) ? "selected" : "" %>>전산</option>
            <option value="시설" <%= "시설".equals(category) ? "selected" : "" %>>시설</option>
            <option value="교무학적" <%= "교무학적".equals(category) ? "selected" : "" %>>교무학적</option>
            <option value="장학" <%= "장학".equals(category) ? "selected" : "" %>>장학</option>
            <option value="학생지원" <%= "학생지원".equals(category) ? "selected" : "" %>>학생지원</option>
            <option value="수업" <%= "수업".equals(category) ? "selected" : "" %>>수업</option>
            <option value="상담" <%= "상담".equals(category) ? "selected" : "" %>>상담</option>
            <option value="취업" <%= "취업".equals(category) ? "selected" : "" %>>취업</option>
            <option value="인권" <%= "인권".equals(category) ? "selected" : "" %>>인권</option>
            <option value="기타" <%= "기타".equals(category) ? "selected" : "" %>>기타</option>
        </select>
    </p>

    <p>
        부서 ID<br>
        <input type="number" name="departmentId" value="<%= departmentId %>" placeholder="예: 전산지원팀 5">
    </p>

    <input type="hidden" name="isPrivate" value="false">

    <button type="submit">FAQ / 유사민원 추천 테스트</button>
</form>

<hr>

<% if (Boolean.TRUE.equals(showResult)) { %>

<h2>추천 FAQ 결과</h2>

<% if (similarFaqs == null || similarFaqs.isEmpty()) { %>

<p>추천된 FAQ가 없습니다.</p>

<% } else { %>

<% for (FaqDTO faq : similarFaqs) { %>
<div style="border:1px solid #ccc; padding:15px; margin-bottom:10px;">
    <p><strong>FAQ ID:</strong> <%= faq.getFaqId() %></p>
    <p><strong>부서:</strong> <%= faq.getDepartmentName() %></p>
    <p><strong>카테고리:</strong> <%= faq.getCategory() %></p>
    <p><strong>질문:</strong> <%= faq.getQuestion() %></p>
    <p><strong>답변:</strong> <%= faq.getAnswer() %></p>
    <p><strong>점수:</strong> <%= faq.getFinalScore() %></p>
</div>
<% } %>

<% } %>

<hr>

<h2>유사 민원 결과</h2>

<% if (similarComplaints == null || similarComplaints.isEmpty()) { %>

<p>추천된 유사 민원이 없습니다.</p>

<% } else { %>

<% for (ComplaintDTO complaint : similarComplaints) { %>
<div style="border:1px solid #999; padding:15px; margin-bottom:10px; background-color:#f9f9f9;">
    <p><strong>민원 ID:</strong> <%= complaint.getComplaintId() %></p>
    <p><strong>부서:</strong> <%= complaint.getDepartmentName() %></p>
    <p><strong>카테고리:</strong> <%= complaint.getCategory() %></p>
    <p><strong>제목:</strong> <%= complaint.getTitle() %></p>
    <p><strong>내용:</strong> <%= complaint.getContent() %></p>
    <p><strong>상태:</strong> <%= complaint.getStatus() %></p>
    <p><strong>추천수:</strong> <%= complaint.getLikeCount() %></p>
    <p><strong>점수:</strong> <%= complaint.getFinalScore() %></p>

    <a href="<%= request.getContextPath() %>/complaints/detail?id=<%= complaint.getComplaintId() %>">
        상세 보기
    </a>
</div>
<% } %>

<% } %>

<% } %>

</body>
</html>