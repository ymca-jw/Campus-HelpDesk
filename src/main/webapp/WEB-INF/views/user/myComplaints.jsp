<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.campus.dto.ComplaintDTO" %>
<%@ page import="java.util.List" %>

<%!
    private String statusText(String status) {
        if ("RECEIVED".equals(status)) return "접수";
        if ("REVIEWING".equals(status)) return "검토중";
        if ("PROCESSING".equals(status)) return "처리중";
        if ("COMPLETED".equals(status)) return "완료";
        if ("REJECTED".equals(status)) return "반려";
        return status;
    }

    private String dateText(java.util.Date date) {
        if (date == null) return "";
        return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    }
%>

<%
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "내 민원";

    String activeMyMenu = (String) request.getAttribute("activeMyMenu");
    List<ComplaintDTO> complaints = (List<ComplaintDTO>) request.getAttribute("complaints");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= pageTitle %></title>
    <style>
        body {
            margin: 0;
            color: #101828;
            background: #fff;
            font-family: Arial, "Noto Sans KR", sans-serif;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .site-header {
            border-bottom: 1px solid #e4e7ec;
        }

        .header-inner {
            width: min(1320px, calc(100% - 48px));
            height: 86px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand img {
            height: 54px;
        }

        .auth-nav {
            display: flex;
            align-items: center;
            gap: 16px;
            color: #475467;
            font-size: 14px;
        }

        .page-layout {
            width: min(1320px, calc(100% - 48px));
            margin: 64px auto 80px;
            display: grid;
            grid-template-columns: 260px 1fr;
            gap: 58px;
        }

        .complaint-sidebar {
            padding-top: 8px;
        }

        .side-section {
            margin-bottom: 30px;
        }

        .side-title {
            width: 100%;
            padding: 0 10px 14px;
            border-bottom: 1px solid #d8dee8;
            font-size: 20px;
            font-weight: 800;
        }

        .side-links {
            display: flex;
            flex-direction: column;
            gap: 4px;
            padding: 14px 0 0 10px;
            border-left: 1px solid #d8dee8;
        }

        .side-links a {
            padding: 10px 14px;
            color: #101828;
            font-weight: 600;
        }

        .side-links a.active {
            color: #008060;
            font-weight: 800;
        }

        .content h1 {
            margin: 0 0 18px;
            font-size: 44px;
        }

        .summary {
            margin: 0 0 28px;
            color: #475467;
            font-size: 16px;
        }

        .list {
            border-top: 2px solid #667085;
        }

        .item {
            display: grid;
            grid-template-columns: 1fr 120px 120px;
            gap: 24px;
            align-items: center;
            padding: 24px 8px;
            border-bottom: 1px solid #d8dee8;
        }

        .title {
            display: block;
            margin-bottom: 8px;
            font-size: 20px;
            font-weight: 800;
        }

        .meta {
            display: flex;
            gap: 10px;
            color: #667085;
            font-size: 14px;
        }

        .badge {
            color: #008060;
            font-weight: 800;
            text-align: center;
        }

        .likes {
            color: #344054;
            font-weight: 700;
            text-align: right;
        }

        .empty {
            padding: 34px 8px;
            color: #667085;
        }
    </style>
</head>
<body>
<header class="site-header">
    <div class="header-inner">
        <a class="brand" href="<%= request.getContextPath() %>/complaints">
            <img src="<%= request.getContextPath() %>/assets/images/logo.svg" alt="서경대학교 로고">
        </a>

        <div class="auth-nav">
            <a href="<%= request.getContextPath() %>/user/mypage">마이페이지</a>
            <a href="<%= request.getContextPath() %>/user/logout">로그아웃</a>
        </div>
    </div>
</header>

<main class="page-layout">
    <aside class="complaint-sidebar">
        <div class="side-section">
            <div class="side-title">민원 메뉴</div>
            <div class="side-links">
                <a href="<%= request.getContextPath() %>/complaints">민원 목록</a>
                <a href="<%= request.getContextPath() %>/complaints/new">민원 작성</a>
            </div>
        </div>

        <div class="side-section">
            <div class="side-title">내 민원</div>
            <div class="side-links">
                <a class="<%= "written".equals(activeMyMenu) ? "active" : "" %>" href="<%= request.getContextPath() %>/user/my-complaints">내가 작성한 민원</a>
                <a class="<%= "liked".equals(activeMyMenu) ? "active" : "" %>" href="<%= request.getContextPath() %>/user/liked-complaints">내가 추천한 민원</a>
            </div>
        </div>
    </aside>

    <section class="content">
        <h1><%= pageTitle %></h1>
        <p class="summary">총 <%= complaints == null ? 0 : complaints.size() %>건</p>

        <div class="list">
            <% if (complaints == null || complaints.isEmpty()) { %>
                <div class="empty">표시할 민원이 없습니다.</div>
            <% } else { %>
                <% for (ComplaintDTO complaint : complaints) { %>
                    <article class="item">
                        <div>
                            <a class="title" href="<%= request.getContextPath() %>/complaints/detail?id=<%= complaint.getComplaintId() %>">
                                <%= complaint.getTitle() %>
                            </a>
                            <div class="meta">
                                <span><%= complaint.getCategory() %></span>
                                <span>·</span>
                                <span><%= complaint.getDepartmentName() %></span>
                                <span>·</span>
                                <span><%= dateText(complaint.getCreatedAt()) %></span>
                            </div>
                        </div>
                        <div class="badge"><%= statusText(complaint.getStatus()) %></div>
                        <div class="likes">추천 <%= complaint.getLikeCount() %></div>
                    </article>
                <% } %>
            <% } %>
        </div>
    </section>
</main>
</body>
</html>
