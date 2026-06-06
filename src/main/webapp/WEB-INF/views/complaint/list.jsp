<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.dto.ComplaintDTO" %>

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
    List<ComplaintDTO> complaints =
            (List<ComplaintDTO>) request.getAttribute("complaints");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>민원 목록</title>
    <link rel="icon" type="image/svg+xml" href="<%= request.getContextPath() %>/assets/images/leaf_logo.svg">
    <style>
        * {
            box-sizing: border-box;
        }

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
            border-bottom: 1px solid #e5e7eb;
            background: #fff;
        }

        .header-inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            max-width: 1280px;
            height: 82px;
            margin: 0 auto;
            padding: 0 40px;
        }

        .brand img {
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

        .auth-nav {
            display: flex;
            align-items: center;
            gap: 16px;
            color: #475467;
            font-size: 14px;
        }

        .page {
            max-width: 1280px;
            margin: 0 auto;
            padding: 54px 40px 80px;
        }

        .page-layout {
            display: flex;
            align-items: flex-start;
            gap: 36px;
        }

        .complaint-sidebar {
            flex: 0 0 240px;
        }

        .page-content {
            flex: 1;
            min-width: 0;
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
            max-height: 180px;
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
            text-decoration: none;
        }

        .side-links a.active {
            color: #007a5a;
            font-weight: 700;
            border-left: 2px solid #007a5a;
            margin-left: -17px;
            padding-left: 27px;
        }

        .page-title {
            margin-bottom: 34px;
        }

        .page-title h1 {
            margin: 0;
            font-size: 44px;
            line-height: 1.2;
            letter-spacing: 0;
        }

        .page-title p {
            margin: 14px 0 0;
            color: #667085;
            font-size: 18px;
        }

        .filter-panel {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr;
            gap: 12px;
            padding: 18px;
            border: 1px solid #edf0f4;
            border-radius: 8px;
            background: #f8fafc;
        }

        .filter-panel select,
        .filter-panel input {
            width: 100%;
            height: 46px;
            border: 0;
            border-radius: 8px;
            background: #fff;
            padding: 0 14px;
            color: #344054;
            font-size: 14px;
            outline: none;
        }

        .search-field {
            grid-column: span 2;
            display: flex;
            overflow: hidden;
            border-radius: 8px;
            background: #fff;
        }

        .search-field select {
            width: 130px;
            border-right: 1px solid #eef2f6;
            border-radius: 0;
        }

        .search-field input {
            border-radius: 0;
        }

        .filter-actions {
            display: flex;
            gap: 8px;
        }

        .filter-actions button,
        .filter-actions a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 46px;
            border-radius: 8px;
            padding: 0 18px;
            font-size: 14px;
            white-space: nowrap;
        }

        .filter-actions button {
            border: 0;
            background: #0b7a55;
            color: #fff;
            cursor: pointer;
        }

        .filter-actions a {
            border: 1px solid #d0d5dd;
            background: #fff;
            color: #475467;
        }

        .section-heading {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            margin: 46px 0 18px;
        }

        .section-heading h2 {
            margin: 0;
            font-size: 28px;
            letter-spacing: 0;
        }

        .section-heading p {
            margin: 0;
            color: #667085;
        }

        .top-card-grid {
            display: grid;
            grid-template-columns: 1fr 1.12fr 1fr;
            align-items: end;
            gap: 22px;
        }

        .top-card {
            min-height: 172px;
            border: 1px solid #e4e7ec;
            border-radius: 8px;
            padding: 22px;
            background: #fff;
            box-shadow: 0 10px 24px rgba(16, 24, 40, 0.06);
        }

        .top-card.rank-1 {
            grid-column: 2;
            min-height: 196px;
            border-top: 4px solid #0b7a55;
        }

        .top-card.rank-2 {
            grid-column: 1;
        }

        .top-card.rank-3 {
            grid-column: 3;
        }

        .rank-label {
            display: inline-flex;
            align-items: center;
            height: 26px;
            border-radius: 999px;
            padding: 0 10px;
            background: #ecfdf3;
            color: #047857;
            font-size: 13px;
            font-weight: 700;
        }

        .top-card h3 {
            margin: 18px 0 20px;
            font-size: 19px;
            line-height: 1.35;
        }

        .top-meta {
            display: flex;
            justify-content: space-between;
            color: #475467;
            font-size: 14px;
        }

        .top-empty {
            padding: 28px;
            border: 1px solid #e4e7ec;
            border-radius: 8px;
            color: #667085;
            background: #fafafa;
        }

        .list-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            border-bottom: 2px solid #667085;
            padding-bottom: 22px;
        }

        .list-toolbar p {
            margin-top: 18px;
        }

        .sort-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #475467;
            font-weight: 700;
        }

        .complaint-list {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .complaint-item {
            display: grid;
            grid-template-columns: 48px minmax(0, 1fr) 120px 120px;
            align-items: center;
            gap: 18px;
            min-height: 104px;
            border-bottom: 1px solid #d9dee7;
        }

        .q-mark {
            color: #0b7a55;
            font-size: 24px;
            font-weight: 700;
            text-align: center;
        }

        .complaint-main {
            min-width: 0;
            max-width: 560px;
        }

        .complaint-title {
            display: block;
            max-width: 100%;
            margin-bottom: 8px;
            color: #111827;
            font-size: 18px;
            font-weight: 700;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .complaint-title:hover {
            color: #007a4d;
        }

        .complaint-meta {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px;
            color: #667085;
            font-size: 14px;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            height: 24px;
            border: 1px solid #d0d5dd;
            border-radius: 999px;
            padding: 0 10px;
            color: #475467;
            background: #fff;
            font-size: 12px;
            font-weight: 700;
        }

        .status-badge {
            justify-self: start;
            color: #0b7a55;
            font-weight: 700;
        }

        .like-count {
            color: #344054;
            font-weight: 700;
            text-align: right;
        }

        .empty-list {
            padding: 42px 0;
            border-bottom: 1px solid #d9dee7;
            color: #667085;
            text-align: center;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 6px;
            margin-top: 28px;
        }

        .pagination a,
        .pagination strong {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 36px;
            height: 36px;
            border: 1px solid #d0d5dd;
            border-radius: 8px;
            padding: 0 10px;
            color: #475467;
            background: #fff;
        }

        .pagination strong {
            border-color: #0b7a55;
            background: #0b7a55;
            color: #fff;
        }

        @media (max-width: 900px) {
            .header-inner,
            .page {
                padding-left: 20px;
                padding-right: 20px;
            }

            .header-inner {
                height: auto;
                flex-wrap: wrap;
                gap: 16px;
                padding-top: 16px;
                padding-bottom: 16px;
            }

            .page-layout {
                flex-direction: column;
            }

            .complaint-sidebar {
                width: 100%;
                flex-basis: auto;
            }

            .filter-panel,
            .top-card-grid {
                grid-template-columns: 1fr;
            }

            .top-card.rank-1,
            .top-card.rank-2,
            .top-card.rank-3 {
                grid-column: auto;
            }

            .search-field {
                grid-column: auto;
            }

            .complaint-item {
                grid-template-columns: 36px 1fr;
            }

            .status-badge,
            .like-count {
                grid-column: 2;
                text-align: left;
            }
        }
    </style>
</head>
<body>

<header class="site-header">
    <div class="header-inner">
        <div class="header-left">
            <a class="brand" href="${pageContext.request.contextPath}/complaints">
                <img src="${pageContext.request.contextPath}/assets/images/logo.svg" alt="학교 로고">
            </a>
            <nav class="header-nav">
                <a href="${pageContext.request.contextPath}/complaints">민원 목록</a>
                <c:if test="${sessionScope.loginUser.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/staff/complaints">부서별 민원 목록</a>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">관리자 대시보드</a>
                </c:if>
                <c:if test="${sessionScope.loginUser.role == 'STAFF'}">
                    <a href="${pageContext.request.contextPath}/staff/dashboard">담당자 대시보드</a>
                </c:if>
            </nav>
        </div>
        <div class="auth-nav">
            <% if (session.getAttribute("loginUser") == null) { %>
                <a href="${pageContext.request.contextPath}/user/login">로그인</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/user/mypage">마이페이지</a>
                <a href="${pageContext.request.contextPath}/user/logout">로그아웃</a>
            <% } %>
        </div>
    </div>
</header>

<main class="page page-layout">
    <aside class="complaint-sidebar">
        <div class="side-section">
            <button type="button" class="side-toggle">민원 메뉴</button>
            <div class="side-links">
                <a class="${empty status and empty myFilter ? 'active' : ''}" href="${pageContext.request.contextPath}/complaints">민원 목록</a>
                <a href="${pageContext.request.contextPath}/complaints/new">민원 작성</a>
            </div>
        </div>

        <div class="side-section">
            <button type="button" class="side-toggle">내 민원</button>
            <div class="side-links">
                <a class="${myFilter == 'written' ? 'active' : ''}" href="${pageContext.request.contextPath}/complaints?my=written">내가 작성한 민원</a>
                <a class="${myFilter == 'liked' ? 'active' : ''}" href="${pageContext.request.contextPath}/complaints?my=liked">내가 추천한 민원</a>
            </div>
        </div>

        <div class="side-section">
            <button type="button" class="side-toggle">민원 상태</button>
            <div class="side-links">
                <a class="${status == 'RECEIVED' ? 'active' : ''}" href="${pageContext.request.contextPath}/complaints?status=RECEIVED">접수</a>
                <a class="${status == 'REVIEWING' ? 'active' : ''}" href="${pageContext.request.contextPath}/complaints?status=REVIEWING">검토중</a>
                <a class="${status == 'PROCESSING' ? 'active' : ''}" href="${pageContext.request.contextPath}/complaints?status=PROCESSING">처리중</a>
                <a class="${status == 'COMPLETED' ? 'active' : ''}" href="${pageContext.request.contextPath}/complaints?status=COMPLETED">완료</a>
                <a class="${status == 'REJECTED' ? 'active' : ''}" href="${pageContext.request.contextPath}/complaints?status=REJECTED">반려</a>
            </div>
        </div>
    </aside>

    <div class="page-content">
    <section class="page-title">
        <h1>민원 목록</h1>
        <p>학교 생활 중 발생한 민원을 확인하고 처리 현황을 살펴볼 수 있습니다.</p>
    </section>

    <form class="filter-panel" action="${pageContext.request.contextPath}/complaints" method="get">
        <input type="hidden" name="likeSort" value="${likeSort}">
        <input type="hidden" name="my" value="${myFilter}">

        <select name="departmentType" aria-label="문의구분">
            <option value="">문의구분 전체</option>
            <option value="ADMIN" ${departmentType == 'ADMIN' ? 'selected' : ''}>행정부서</option>
            <option value="MAJOR" ${departmentType == 'MAJOR' ? 'selected' : ''}>학과</option>
        </select>

        <select name="departmentId" aria-label="담당부서">
            <option value="">담당부서 전체</option>
            <c:forEach var="dept" items="${departments}">
                <option value="${dept.departmentId}"
                    ${departmentId == dept.departmentId ? 'selected' : ''}>
                        ${dept.name}
                </option>
            </c:forEach>
        </select>

        <select name="category" aria-label="카테고리">
            <option value="">카테고리 전체</option>
            <c:forEach var="cat" items="${categories}">
                <option value="${cat}" ${category == cat ? 'selected' : ''}>
                        ${cat}
                </option>
            </c:forEach>
        </select>

        <select name="status" aria-label="상태">
            <option value="">상태 전체</option>
            <option value="RECEIVED" ${status == 'RECEIVED' ? 'selected' : ''}>접수</option>
            <option value="REVIEWING" ${status == 'REVIEWING' ? 'selected' : ''}>검토중</option>
            <option value="PROCESSING" ${status == 'PROCESSING' ? 'selected' : ''}>처리중</option>
            <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>완료</option>
            <option value="REJECTED" ${status == 'REJECTED' ? 'selected' : ''}>반려</option>
        </select>

        <div class="search-field">
            <select name="searchType" aria-label="검색기준">
                <option value="title" ${empty searchType or searchType == 'title' ? 'selected' : ''}>제목</option>
                <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
            </select>
            <input type="text" name="keyword" value="${keyword}" placeholder="검색어를 입력하세요">
        </div>

        <div class="filter-actions">
            <button type="submit">검색</button>
            <a href="${pageContext.request.contextPath}/complaints">초기화</a>
        </div>
    </form>

    <section>
        <div class="section-heading">
            <h2>추천 수 Top 3</h2>
        </div>

        <c:choose>
            <c:when test="${empty topLikedComplaints}">
                <div class="top-empty">표시할 민원이 없습니다.</div>
            </c:when>
            <c:otherwise>
                <div class="top-card-grid">
                    <c:forEach var="topComplaint" items="${topLikedComplaints}" varStatus="rank">
                        <c:if test="${rank.count == 2}">
                            <a class="top-card rank-2" href="${pageContext.request.contextPath}/complaints/detail?id=${topComplaint.complaintId}">
                                <span class="rank-label">2위</span>
                                <h3>${topComplaint.title}</h3>
                                <div class="top-meta">
                                    <span>추천 ${topComplaint.likeCount}</span>
                                    <span>
                                        <c:choose>
                                            <c:when test="${topComplaint.status == 'RECEIVED'}">접수</c:when>
                                            <c:when test="${topComplaint.status == 'REVIEWING'}">검토중</c:when>
                                            <c:when test="${topComplaint.status == 'PROCESSING'}">처리중</c:when>
                                            <c:when test="${topComplaint.status == 'COMPLETED'}">완료</c:when>
                                            <c:when test="${topComplaint.status == 'REJECTED'}">반려</c:when>
                                            <c:otherwise>${topComplaint.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>

                    <c:forEach var="topComplaint" items="${topLikedComplaints}" varStatus="rank">
                        <c:if test="${rank.count == 1}">
                            <a class="top-card rank-1" href="${pageContext.request.contextPath}/complaints/detail?id=${topComplaint.complaintId}">
                                <span class="rank-label">1위</span>
                                <h3>${topComplaint.title}</h3>
                                <div class="top-meta">
                                    <span>추천 ${topComplaint.likeCount}</span>
                                    <span>
                                        <c:choose>
                                            <c:when test="${topComplaint.status == 'RECEIVED'}">접수</c:when>
                                            <c:when test="${topComplaint.status == 'REVIEWING'}">검토중</c:when>
                                            <c:when test="${topComplaint.status == 'PROCESSING'}">처리중</c:when>
                                            <c:when test="${topComplaint.status == 'COMPLETED'}">완료</c:when>
                                            <c:when test="${topComplaint.status == 'REJECTED'}">반려</c:when>
                                            <c:otherwise>${topComplaint.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>

                    <c:forEach var="topComplaint" items="${topLikedComplaints}" varStatus="rank">
                        <c:if test="${rank.count == 3}">
                            <a class="top-card rank-3" href="${pageContext.request.contextPath}/complaints/detail?id=${topComplaint.complaintId}">
                                <span class="rank-label">3위</span>
                                <h3>${topComplaint.title}</h3>
                                <div class="top-meta">
                                    <span>추천 ${topComplaint.likeCount}</span>
                                    <span>
                                        <c:choose>
                                            <c:when test="${topComplaint.status == 'RECEIVED'}">접수</c:when>
                                            <c:when test="${topComplaint.status == 'REVIEWING'}">검토중</c:when>
                                            <c:when test="${topComplaint.status == 'PROCESSING'}">처리중</c:when>
                                            <c:when test="${topComplaint.status == 'COMPLETED'}">완료</c:when>
                                            <c:when test="${topComplaint.status == 'REJECTED'}">반려</c:when>
                                            <c:otherwise>${topComplaint.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section>
        <div class="section-heading list-toolbar">
            <div>
                <h2>${listTitle}</h2>
                <p id="complaintSummary">총 ${totalCount}건 · 현재 ${page}페이지 / 총 ${totalPages}페이지</p>
            </div>

            <c:url var="likeSortUrl" value="/complaints">
                <c:param name="page" value="1" />
                <c:param name="departmentType" value="${departmentType}" />
                <c:param name="departmentId" value="${departmentId}" />
                <c:param name="category" value="${category}" />
                <c:param name="status" value="${status}" />
                <c:param name="searchType" value="${searchType}" />
                <c:param name="keyword" value="${keyword}" />
                <c:param name="likeSort" value="${nextLikeSort}" />
                <c:param name="my" value="${myFilter}" />
            </c:url>
            <a class="sort-link" href="${likeSortUrl}" data-ajax-list="true">
                <c:choose>
                    <c:when test="${likeSort == 'asc'}">▲ 추천 수 오름차순</c:when>
                    <c:when test="${likeSort == 'desc'}">▼ 추천 수 내림차순</c:when>
                    <c:otherwise>↕ 추천 수 정렬</c:otherwise>
                </c:choose>
            </a>
        </div>

        <div id="complaintListArea">
            <% if (complaints == null || complaints.isEmpty()) { %>
                <div class="empty-list">등록된 민원이 없습니다.</div>
            <% } else { %>
                <ul class="complaint-list">
                    <% for (ComplaintDTO complaint : complaints) { %>
                    <li class="complaint-item">
                        <div class="q-mark">Q</div>
                        <div class="complaint-main">
                            <a class="complaint-title" href="<%= request.getContextPath() %>/complaints/detail?id=<%= complaint.getComplaintId() %>">
                                <%= complaint.getTitle() %>
                            </a>
                            <div class="complaint-meta">
                                <span class="badge"><%= complaint.getCategory() %></span>
                                <span><%= complaint.getDepartmentName() %></span>
                                <span>·</span>
                                <span><%= dateText(complaint.getCreatedAt()) %></span>
                            </div>
                        </div>
                        <div class="status-badge"><%= statusText(complaint.getStatus()) %></div>
                        <div class="like-count">추천 <%= complaint.getLikeCount() %></div>
                    </li>
                    <% } %>
                </ul>
            <% } %>

            <div class="pagination">
                <c:if test="${page > 1}">
                    <a href="${pageContext.request.contextPath}/complaints?page=${page - 1}&departmentType=${departmentType}&departmentId=${departmentId}&category=${category}&status=${status}&searchType=${searchType}&keyword=${keyword}&likeSort=${likeSort}&my=${myFilter}" data-ajax-list="true">
                        이전
                    </a>
                </c:if>

                <c:forEach var="p" begin="1" end="${totalPages}">
                    <c:choose>
                        <c:when test="${p == page}">
                            <strong>${p}</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/complaints?page=${p}&departmentType=${departmentType}&departmentId=${departmentId}&category=${category}&status=${status}&searchType=${searchType}&keyword=${keyword}&likeSort=${likeSort}&my=${myFilter}" data-ajax-list="true">
                                ${p}
                            </a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:if test="${page < totalPages}">
                    <a href="${pageContext.request.contextPath}/complaints?page=${page + 1}&departmentType=${departmentType}&departmentId=${departmentId}&category=${category}&status=${status}&searchType=${searchType}&keyword=${keyword}&likeSort=${likeSort}&my=${myFilter}" data-ajax-list="true">
                        다음
                    </a>
                </c:if>
            </div>
        </div>
    </section>
    </div>
</main>

<script>
    document.querySelectorAll(".side-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            button.closest(".side-section").classList.toggle("collapsed");
        });
    });

    document.addEventListener("click", async function (event) {
        const link = event.target.closest("[data-ajax-list='true']");
        if (!link) {
            return;
        }

        event.preventDefault();

        const listArea = document.getElementById("complaintListArea");
        if (!listArea) {
            return;
        }

        try {
            const response = await fetch(link.href, {
                headers: {
                    "X-Requested-With": "XMLHttpRequest"
                }
            });

            if (!response.ok) {
                window.location.href = link.href;
                return;
            }

            const html = await response.text();
            const doc = new DOMParser().parseFromString(html, "text/html");
            const nextListArea = doc.getElementById("complaintListArea");
            const nextSummary = doc.getElementById("complaintSummary");
            const currentSummary = document.getElementById("complaintSummary");
            const nextLikeSortInput = doc.querySelector("input[name='likeSort']");
            const currentLikeSortInput = document.querySelector("input[name='likeSort']");
            const nextSortLink = doc.querySelector(".sort-link");
            const currentSortLink = document.querySelector(".sort-link");

            if (!nextListArea) {
                window.location.href = link.href;
                return;
            }

            listArea.replaceWith(nextListArea);

            if (nextSummary && currentSummary) {
                currentSummary.replaceWith(nextSummary);
            }

            if (nextLikeSortInput && currentLikeSortInput) {
                currentLikeSortInput.value = nextLikeSortInput.value;
            }

            if (nextSortLink && currentSortLink) {
                currentSortLink.replaceWith(nextSortLink);
            }
        } catch (error) {
            window.location.href = link.href;
        }
    });
</script>

</body>
</html>
