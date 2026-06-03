<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Integer totalComplaintCount = (Integer) request.getAttribute("totalComplaintCount");
    Integer totalUserCount = (Integer) request.getAttribute("totalUserCount");
    Integer staffCount = (Integer) request.getAttribute("staffCount");
    Integer adminCount = (Integer) request.getAttribute("adminCount");

    if (totalComplaintCount == null) totalComplaintCount = 0;
    if (totalUserCount == null) totalUserCount = 0;
    if (staffCount == null) staffCount = 0;
    if (adminCount == null) adminCount = 0;
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드 테스트</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }

        .dashboard {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .card {
            width: 220px;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        .card-title {
            font-size: 16px;
            color: #555;
            margin-bottom: 10px;
        }

        .card-value {
            font-size: 32px;
            font-weight: bold;
        }

        .menu {
            margin-top: 30px;
        }

        .menu a {
            display: inline-block;
            margin-right: 12px;
        }
    </style>
</head>
<body>

<h1>관리자 대시보드 테스트</h1>

<hr>

<div class="dashboard">
    <div class="card">
        <div class="card-title">전체 민원 수</div>
        <div class="card-value"><%= totalComplaintCount %></div>
    </div>

    <div class="card">
        <div class="card-title">전체 사용자 수</div>
        <div class="card-value"><%= totalUserCount %></div>
    </div>

    <div class="card">
        <div class="card-title">담당자 수</div>
        <div class="card-value"><%= staffCount %></div>
    </div>

    <div class="card">
        <div class="card-title">관리자 수</div>
        <div class="card-value"><%= adminCount %></div>
    </div>
</div>

<div class="menu">
    <h2>관리자 메뉴</h2>
    <a href="<%= request.getContextPath() %>/admin/users">사용자 관리</a>
    <a href="<%= request.getContextPath() %>/admin/departments">부서 관리</a>
    <a href="<%= request.getContextPath() %>/admin/complaints">민원 관리</a>
</div>

</body>
</html>