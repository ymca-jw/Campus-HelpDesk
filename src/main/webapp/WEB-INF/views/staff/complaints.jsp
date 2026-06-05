<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8">
    <title>담당 부서 민원 목록</title>

    <style>
      * {
        box-sizing: border-box;
      }

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

      .staff-topbar {
        border-bottom: 1px solid #e5e7eb;
        background: #fff;
      }

      .staff-header-inner {
        display: flex;
        align-items: center;
        justify-content: space-between;
        max-width: 1280px;
        height: 82px;
        margin: 0 auto;
        padding: 0 40px;
      }

      .staff-logo img {
        display: block;
        width: 180px;
        max-height: 52px;
        object-fit: contain;
      }

      .login-area {
        display: flex;
        align-items: center;
        gap: 16px;
        color: #475467;
        font-size: 14px;
      }

      .staff-layout {
        display: flex;
        gap: 36px;
        max-width: 1280px;
        margin: 54px auto 80px;
        padding: 0 40px;
      }

      .staff-sidebar {
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
        background: transparent;
        cursor: pointer;
        color: #111827;
        font-size: 18px;
        font-weight: 700;
        padding: 14px 10px;
        border-bottom: 1px solid #e5e7eb;
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
        max-height: 320px;
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

      .staff-content {
        flex: 1;
        min-width: 0;
      }

      .staff-content h1 {
        margin: 0;
        font-size: 42px;
        line-height: 1.2;
        letter-spacing: 0;
      }

      .staff-content > p {
        margin: 14px 0 0;
        color: #667085;
        font-size: 18px;
      }

      .filter-form {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 12px;
        margin: 28px 0 26px;
        padding: 18px;
        border: 1px solid #edf0f4;
        border-radius: 8px;
        background: #f8fafc;
      }

      .filter-form select,
      .filter-form input {
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

      .search-row {
        display: grid;
        grid-column: span 3;
        grid-template-columns: 120px minmax(0, 1fr) 76px 76px;
        gap: 12px;
      }

      .filter-form button,
      .filter-form a {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        height: 46px;
        border-radius: 8px;
        font-weight: 700;
      }

      .filter-form button {
        border: 0;
        background: #007a5a;
        color: #fff;
        cursor: pointer;
      }

      .filter-form a {
        border: 1px solid #d0d5dd;
        background: #fff;
        color: #475467;
      }

      .list-head {
        display: flex;
        align-items: flex-end;
        justify-content: space-between;
        margin-top: 40px;
        padding-bottom: 24px;
        border-bottom: 2px solid #667085;
      }

      .list-head h2 {
        margin: 0 0 12px;
        font-size: 32px;
      }

      .list-head p {
        margin: 0;
        color: #475467;
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

      .complaint-title {
        display: inline-block;
        margin-bottom: 8px;
        color: #111827;
        font-size: 18px;
        font-weight: 700;
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
    </style>
  </head>

  <body>

  <header class="staff-topbar">
    <div class="staff-header-inner">
      <a class="staff-logo" href="${pageContext.request.contextPath}/staff/dashboard">
        <img src="${pageContext.request.contextPath}/assets/images/logo.svg" alt="서경대학교">
      </a>
      <div class="login-area">
        <a href="#">로그인</a>
        <a href="#">마이페이지</a>
        <a href="#">로그아웃</a>
      </div>
    </div>
  </header>

  <main class="staff-layout">
    <aside class="staff-sidebar">
      <div class="side-section">
        <button type="button" class="side-toggle">담당자 메뉴</button>
        <div class="side-links">
          <a href="${pageContext.request.contextPath}/staff/dashboard">메인</a>
          <a class="active" href="${pageContext.request.contextPath}/staff/complaints">담당부서 민원목록</a>
          <a href="${pageContext.request.contextPath}/complaints">일반 민원 목록</a>
        </div>
      </div>

      <div class="side-section">
        <button type="button" class="side-toggle">대시보드 바로가기</button>
        <div class="side-links">
          <a class="${quickFilter == 'pending' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/complaints?quickFilter=pending">처리 대기 민원</a>
          <a class="${quickFilter == 'recent' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/complaints?quickFilter=recent">최근 접수된 민원</a>
        </div>
      </div>
    </aside>

    <section class="staff-content">
      <h1>담당자 - 담당 부서 민원 목록</h1>

      <c:if test="${not empty staffDepartment}">
        <p>담당 부서: ${staffDepartment.name}</p>
      </c:if>

      <form class="filter-form" action="${pageContext.request.contextPath}/staff/complaints" method="get">
        <input type="hidden" name="likeSort" value="${likeSort}">
        <input type="hidden" name="quickFilter" value="${quickFilter}">

        <select name="departmentType">
          <option value="" ${empty departmentType ? 'selected' : ''}>문의구분 전체</option>
          <option value="ADMIN" ${departmentType == 'ADMIN' ? 'selected' : ''}>행정부서</option>
          <option value="MAJOR" ${departmentType == 'MAJOR' ? 'selected' : ''}>학과</option>
        </select>

        <select name="category">
          <option value="" ${empty category ? 'selected' : ''}>카테고리 전체</option>
          <c:forEach var="item" items="${categories}">
            <option value="${item}" ${category == item ? 'selected' : ''}>${item}</option>
          </c:forEach>
        </select>

        <select name="status">
          <option value="" ${empty status or status == 'PENDING' ? 'selected' : ''}>상태 전체</option>
          <option value="RECEIVED" ${status == 'RECEIVED' ? 'selected' : ''}>접수</option>
          <option value="REVIEWING" ${status == 'REVIEWING' ? 'selected' : ''}>검토중</option>
          <option value="PROCESSING" ${status == 'PROCESSING' ? 'selected' : ''}>처리중</option>
          <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>완료</option>
          <option value="REJECTED" ${status == 'REJECTED' ? 'selected' : ''}>반려</option>
        </select>

        <div class="search-row">
          <select name="searchType">
            <option value="title" ${empty searchType or searchType == 'title' ? 'selected' : ''}>제목</option>
            <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
          </select>

          <input type="text" name="keyword" value="${keyword}" placeholder="검색어를 입력하세요">

          <button type="submit">검색</button>
          <a href="${pageContext.request.contextPath}/staff/complaints">초기화</a>
        </div>
      </form>

      <div class="list-head">
        <div>
          <h2>
            <c:choose>
              <c:when test="${quickFilter == 'pending'}">처리 대기 민원</c:when>
              <c:when test="${quickFilter == 'recent'}">최근 접수된 민원</c:when>
              <c:otherwise>전체 민원</c:otherwise>
            </c:choose>
          </h2>
          <p id="staffComplaintSummary">총 ${totalCount}건 · 현재 ${page}페이지 / 총 ${totalPages}페이지</p>
        </div>

  <c:url var="likeSortUrl" value="/staff/complaints">
    <c:param name="page" value="1" />
    <c:param name="departmentType" value="${departmentType}" />
    <c:param name="category" value="${category}" />
    <c:param name="status" value="${status}" />
    <c:param name="searchType" value="${searchType}" />
    <c:param name="keyword" value="${keyword}" />
    <c:param name="likeSort" value="${nextLikeSort}" />
    <c:param name="quickFilter" value="${quickFilter}" />
  </c:url>

  <a class="sort-link" href="${likeSortUrl}" data-ajax-list="true">
    <c:choose>
      <c:when test="${likeSort == 'asc'}">▲ 추천 수 오름차순</c:when>
      <c:when test="${likeSort == 'desc'}">▼ 추천 수 내림차순</c:when>
      <c:otherwise>↕ 추천 수 정렬</c:otherwise>
    </c:choose>
  </a>
      </div>

  <div id="staffComplaintListArea">
    <c:if test="${empty complaints}">
      <p>조건에 맞는 담당 부서 민원이 없습니다.</p>
    </c:if>

    <c:if test="${not empty complaints}">
      <ul class="complaint-list">
        <c:forEach var="complaint" items="${complaints}">
          <li class="complaint-item">
            <div class="q-mark">Q</div>
            <div>
              <a class="complaint-title" href="${pageContext.request.contextPath}/staff/complaints/detail?id=${complaint.complaintId}">
                  ${complaint.title}
              </a>
              <div class="complaint-meta">
                <span class="badge">${complaint.category}</span>
                <span>${complaint.departmentName}</span>
                <span>·</span>
                <span>${complaint.createdAt}</span>
              </div>
            </div>
            <div class="status-badge">
              <c:choose>
                <c:when test="${complaint.status == 'RECEIVED'}">접수</c:when>
                <c:when test="${complaint.status == 'REVIEWING'}">검토중</c:when>
                <c:when test="${complaint.status == 'PROCESSING'}">처리중</c:when>
                <c:when test="${complaint.status == 'COMPLETED'}">완료</c:when>
                <c:when test="${complaint.status == 'REJECTED'}">반려</c:when>
                <c:otherwise>${complaint.status}</c:otherwise>
              </c:choose>
            </div>
            <div class="like-count">추천 ${complaint.likeCount}</div>
          </li>
        </c:forEach>
      </ul>
    </c:if>

    <div class="pagination">
    <c:if test="${page > 1}">
      <c:url var="prevPageUrl" value="/staff/complaints">
        <c:param name="page" value="${page - 1}" />
        <c:param name="departmentType" value="${departmentType}" />
        <c:param name="category" value="${category}" />
        <c:param name="status" value="${status}" />
        <c:param name="searchType" value="${searchType}" />
        <c:param name="keyword" value="${keyword}" />
        <c:param name="likeSort" value="${likeSort}" />
        <c:param name="quickFilter" value="${quickFilter}" />
      </c:url>
      <a href="${prevPageUrl}" data-ajax-list="true">이전</a>
    </c:if>

    <c:forEach var="p" begin="1" end="${totalPages}">
      <c:choose>
        <c:when test="${p == page}">
          <strong>${p}</strong>
        </c:when>
        <c:otherwise>
          <c:url var="pageUrl" value="/staff/complaints">
            <c:param name="page" value="${p}" />
            <c:param name="departmentType" value="${departmentType}" />
            <c:param name="category" value="${category}" />
            <c:param name="status" value="${status}" />
            <c:param name="searchType" value="${searchType}" />
            <c:param name="keyword" value="${keyword}" />
            <c:param name="likeSort" value="${likeSort}" />
            <c:param name="quickFilter" value="${quickFilter}" />
          </c:url>
          <a href="${pageUrl}" data-ajax-list="true">${p}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>

    <c:if test="${page < totalPages}">
      <c:url var="nextPageUrl" value="/staff/complaints">
        <c:param name="page" value="${page + 1}" />
        <c:param name="departmentType" value="${departmentType}" />
        <c:param name="category" value="${category}" />
        <c:param name="status" value="${status}" />
        <c:param name="searchType" value="${searchType}" />
        <c:param name="keyword" value="${keyword}" />
        <c:param name="likeSort" value="${likeSort}" />
        <c:param name="quickFilter" value="${quickFilter}" />
      </c:url>
      <a href="${nextPageUrl}" data-ajax-list="true">다음</a>
    </c:if>
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

    document.addEventListener("click", async function (event) {
      const link = event.target.closest("[data-ajax-list='true']");
      if (!link) {
        return;
      }

      event.preventDefault();

      const listArea = document.getElementById("staffComplaintListArea");
      if (!listArea) {
        window.location.href = link.href;
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
        const nextListArea = doc.getElementById("staffComplaintListArea");
        const nextSummary = doc.getElementById("staffComplaintSummary");
        const currentSummary = document.getElementById("staffComplaintSummary");
        const nextSortLink = doc.querySelector(".sort-link");
        const currentSortLink = document.querySelector(".sort-link");
        const nextLikeSortInput = doc.querySelector("input[name='likeSort']");
        const currentLikeSortInput = document.querySelector("input[name='likeSort']");

        if (!nextListArea) {
          window.location.href = link.href;
          return;
        }

        listArea.replaceWith(nextListArea);

        if (nextSummary && currentSummary) {
          currentSummary.replaceWith(nextSummary);
        }

        if (nextSortLink && currentSortLink) {
          currentSortLink.replaceWith(nextSortLink);
        }

        if (nextLikeSortInput && currentLikeSortInput) {
          currentLikeSortInput.value = nextLikeSortInput.value;
        }
      } catch (error) {
        window.location.href = link.href;
      }
    });
  </script>

  </body>
</html>
