<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.campus.dto.UserDTO" %>
<%
    UserDTO loginUser = (UserDTO) request.getAttribute("loginUser");
    if (loginUser == null) {
        loginUser = (UserDTO) session.getAttribute("loginUser");
    }

    String roleText = "";
    if (loginUser != null) {
        if ("STUDENT".equals(loginUser.getRole())) roleText = "학생";
        else if ("STAFF".equals(loginUser.getRole())) roleText = "담당자";
        else if ("ADMIN".equals(loginUser.getRole())) roleText = "관리자";
        else roleText = loginUser.getRole();
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, "Noto Sans KR", sans-serif;
            color: #101828;
            background: #fff;
        }
        .auth-page {
            width: min(560px, calc(100% - 40px));
            margin: 80px auto;
        }
        h1 {
            margin: 0 0 12px;
            font-size: 42px;
        }
        p {
            margin: 0 0 32px;
            color: #475467;
        }
        .info-box {
            border: 1px solid #e4e7ec;
            border-radius: 8px;
            padding: 28px;
            box-shadow: 0 14px 30px rgba(16, 24, 40, 0.06);
        }
        .row {
            display: grid;
            grid-template-columns: 140px 1fr;
            gap: 16px;
            padding: 14px 0;
            border-bottom: 1px solid #eef2f6;
        }
        .row:last-child {
            border-bottom: 0;
        }
        .label {
            font-weight: 700;
            color: #475467;
        }
        .links {
            display: flex;
            gap: 10px;
            margin-top: 26px;
        }
        a {
            flex: 1;
            text-align: center;
            padding: 12px 14px;
            border-radius: 8px;
            color: #fff;
            background: #008060;
            text-decoration: none;
            font-weight: 700;
        }
        a.secondary {
            background: #475467;
        }
    </style>
</head>
<body>
<main class="auth-page">
    <h1>마이페이지</h1>
    <p>로그인한 계정 정보를 확인합니다.</p>

    <section class="info-box">
        <div class="row">
            <div class="label">이름</div>
            <div><%= loginUser == null ? "-" : loginUser.getName() %></div>
        </div>
        <div class="row">
            <div class="label">아이디</div>
            <div><%= loginUser == null ? "-" : loginUser.getLoginId() %></div>
        </div>
        <div class="row">
            <div class="label">역할</div>
            <div><%= roleText %></div>
        </div>
        <div class="row">
            <div class="label">담당부서</div>
            <div><%= loginUser == null || loginUser.getDepartmentName() == null ? "-" : loginUser.getDepartmentName() %></div>
        </div>

        <div class="links">
            <a class="secondary" href="<%= request.getContextPath() %>/complaints">민원 목록</a>
            <a href="<%= request.getContextPath() %>/user/logout">로그아웃</a>
        </div>
    </section>
</main>
</body>
</html>
