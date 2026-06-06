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
    <title>관리자 대시보드</title>
    <link rel="icon" type="image/svg+xml" href="<%= request.getContextPath() %>/assets/images/leaf_logo.svg">

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            color: #111827;
            background-color: #ffffff;
            font-family: Arial, "Noto Sans KR", sans-serif;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .admin-topbar {
            border-bottom: 1px solid #e5e7eb;
            background: #fff;
        }

        .admin-header-inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            max-width: 1280px;
            height: 82px;
            margin: 0 auto;
            padding: 0 40px;
        }

        .admin-logo img {
            display: block;
            width: 180px;
            max-height: 52px;
            object-fit: contain;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 32px;
        }

        .header-nav {
            display: flex;
            align-items: center;
            gap: 24px;
            font-size: 14px;
            color: #475467;
        }

        .header-nav a:hover { color: #007a5a; }

        .login-area {
            display: flex;
            align-items: center;
            gap: 16px;
            color: #475467;
            font-size: 14px;
        }

        .admin-layout {
            display: flex;
            gap: 36px;
            max-width: 1280px;
            margin: 54px auto 80px;
            padding: 0 40px;
        }

        .admin-sidebar {
            flex: 0 0 240px;
        }

        .side-section {
            margin-bottom: 18px;
        }

        .side-toggle {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            border: 0;
            border-bottom: 1px solid #e5e7eb;
            background: transparent;
            cursor: pointer;
            color: #111827;
            font-size: 18px;
            font-weight: 700;
            padding: 14px 10px;
            text-align: left;
        }

        .side-toggle::after {
            content: "⌄";
            color: #6b7280;
            font-size: 18px;
            transition: transform 0.2s ease;
        }

        .side-section.collapsed .side-toggle::after {
            transform: rotate(-90deg);
        }

        .side-links {
            overflow: hidden;
            max-height: 260px;
            padding: 12px 0 8px 16px;
            border-left: 1px solid #d1d5db;
            margin-left: 10px;
            transition: max-height 0.28s ease, padding-top 0.28s ease, padding-bottom 0.28s ease;
        }

        .side-section.collapsed .side-links {
            max-height: 0;
            padding-top: 0;
            padding-bottom: 0;
        }

        .side-links a {
            display: block;
            padding: 10px 12px;
            color: #111827;
        }

        .side-links a.active {
            color: #007a5a;
            font-weight: 700;
            border-left: 2px solid #007a5a;
            margin-left: -17px;
            padding-left: 27px;
        }

        .admin-content {
            flex: 1;
            min-width: 0;
        }

        .admin-content h1 {
            margin: 0;
            font-size: 42px;
            line-height: 1.2;
            letter-spacing: 0;
        }

        .admin-content > p {
            margin: 14px 0 0;
            color: #667085;
            font-size: 18px;
        }

        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
            margin-top: 34px;
        }

        .dashboard-card {
            min-height: 160px;
            border: 1px solid #e4e7ec;
            border-radius: 8px;
            padding: 24px;
            background-color: #fff;
            box-shadow: 0 12px 28px rgba(16, 24, 40, 0.06);
        }

        .card-title {
            color: #475467;
            font-size: 16px;
            font-weight: 700;
        }

        .card-value {
            margin-top: 22px;
            color: #007a5a;
            font-size: 40px;
            font-weight: 800;
        }

        @media (max-width: 900px) {
            .admin-header-inner,
            .admin-layout {
                padding-left: 20px;
                padding-right: 20px;
            }

            .admin-layout {
                flex-direction: column;
            }

            .admin-sidebar {
                width: 100%;
                flex-basis: auto;
            }

            .dashboard-cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<header class="admin-topbar">
    <div class="admin-header-inner">
        <div class="header-left">
            <a class="admin-logo" href="<%= request.getContextPath() %>/admin/dashboard">
                <img src="<%= request.getContextPath() %>/assets/images/logo.svg" alt="서경대학교">
            </a>
            <nav class="header-nav">
                <a href="<%= request.getContextPath() %>/complaints">민원 목록</a>
                <a href="<%= request.getContextPath() %>/staff/complaints">부서별 민원 목록</a>
                <a href="<%= request.getContextPath() %>/admin/dashboard">관리자 대시보드</a>
            </nav>
        </div>
        <div class="login-area">
            <% if (session.getAttribute("loginUser") == null) { %>
                <a href="${pageContext.request.contextPath}/user/login">로그인</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/user/mypage">마이페이지</a>
                <a href="${pageContext.request.contextPath}/user/logout">로그아웃</a>
            <% } %>
        </div>
    </div>
</header>

<main class="admin-layout">
    <aside class="admin-sidebar">
        <div class="side-section">
            <button type="button" class="side-toggle">관리자 메뉴</button>
            <div class="side-links">
                <a class="active" href="<%= request.getContextPath() %>/admin/dashboard">메인</a>
                <a href="<%= request.getContextPath() %>/admin/users">사용자 관리</a>
                <a href="<%= request.getContextPath() %>/admin/departments">부서 관리</a>
                <a href="<%= request.getContextPath() %>/admin/complaints">민원 관리</a>
            </div>
        </div>
    </aside>

    <section class="admin-content">
        <h1>관리자 대시보드</h1>
        <p>시스템 전체 사용자, 부서, 민원 현황을 확인할 수 있습니다.</p>

        <div class="dashboard-cards">
            <div class="dashboard-card">
                <div class="card-title">전체 민원 수</div>
                <div class="card-value"><%= totalComplaintCount %></div>
            </div>

            <div class="dashboard-card">
                <div class="card-title">전체 사용자 수</div>
                <div class="card-value"><%= totalUserCount %></div>
            </div>

            <div class="dashboard-card">
                <div class="card-title">담당자 수</div>
                <div class="card-value"><%= staffCount %></div>
            </div>

            <div class="dashboard-card">
                <div class="card-title">관리자 수</div>
                <div class="card-value"><%= adminCount %></div>
            </div>
        </div>
    </section>
</main>

<script>
    document.querySelectorAll(".side-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            button.closest(".side-section").classList.toggle("collapsed");
        });
    });
</script>

</body>
</html>
