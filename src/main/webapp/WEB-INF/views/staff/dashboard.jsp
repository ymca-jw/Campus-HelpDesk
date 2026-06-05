<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>담당자 대시보드</title>

  <style>
    html {
      scroll-behavior: smooth;
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

    .card-wrap {
      display: grid;
      grid-template-columns: repeat(5, minmax(0, 1fr));
      gap: 16px;
      margin-top: 34px;
      margin-bottom: 54px;
    }

    .card {
      min-height: 150px;
      border: 1px solid #e4e7ec;
      border-radius: 8px;
      padding: 22px;
      text-align: center;
      background-color: #fff;
      box-shadow: 0 12px 28px rgba(16, 24, 40, 0.06);
      transition: transform 0.18s ease, border-color 0.18s ease;
    }

    .card:hover {
      transform: translateY(-3px);
      border-color: #007a5a;
    }

    .card a {
      display: block;
      color: inherit;
      text-decoration: none;
    }

    .count {
      color: #007a5a;
      font-size: 38px;
      font-weight: bold;
      margin-top: 18px;
    }

    .dashboard-section {
      display: flex;
      flex-direction: column;
      gap: 28px;
      align-items: stretch;
    }

    .section-box {
      flex: 1;
      min-width: 0;
      border: 1px solid #e4e7ec;
      border-radius: 8px;
      background: #fff;
      padding: 24px;
      box-shadow: 0 12px 28px rgba(16, 24, 40, 0.04);
    }

    .section-box h2 {
      margin: 0 0 18px;
      font-size: 24px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
    }

    th, td {
      border: 0;
      border-bottom: 1px solid #e4e7ec;
      padding: 14px 10px;
      text-align: center;
    }

    th {
      color: #667085;
      background-color: #f8fafc;
      font-size: 14px;
    }

    .title-cell {
      text-align: left;
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
        <a class="active" href="${pageContext.request.contextPath}/staff/dashboard">메인</a>
        <a href="${pageContext.request.contextPath}/staff/complaints">담당부서 민원목록</a>
        <a href="${pageContext.request.contextPath}/complaints">일반 민원 목록</a>
      </div>
    </div>

    <div class="side-section">
      <button type="button" class="side-toggle">대시보드 바로가기</button>
      <div class="side-links">
        <a href="${pageContext.request.contextPath}/staff/complaints?quickFilter=pending">처리 대기 민원</a>
        <a href="${pageContext.request.contextPath}/staff/complaints?quickFilter=recent">최근 접수된 민원</a>
      </div>
    </div>
  </aside>

  <section class="staff-content">
    <h1>담당자 대시보드</h1>

    <c:choose>
      <c:when test="${not empty staffDepartment}">
        <p>${staffDepartment.name} 담당 부서의 민원 처리 현황입니다.</p>
      </c:when>
      <c:otherwise>
        <p>담당 부서의 민원 처리 현황입니다.</p>
      </c:otherwise>
    </c:choose>

    <div class="card-wrap">
  <div class="card">
    <a href="${pageContext.request.contextPath}/staff/complaints?status=RECEIVED">
      <h3>접수</h3>
      <div class="count">${statusCounts.RECEIVED}</div>
    </a>
  </div>

  <div class="card">
    <a href="${pageContext.request.contextPath}/staff/complaints?status=REVIEWING">
      <h3>검토중</h3>
      <div class="count">${statusCounts.REVIEWING}</div>
    </a>
  </div>

  <div class="card">
    <a href="${pageContext.request.contextPath}/staff/complaints?status=PROCESSING">
      <h3>처리중</h3>
      <div class="count">${statusCounts.PROCESSING}</div>
    </a>
  </div>

  <div class="card">
    <a href="${pageContext.request.contextPath}/staff/complaints?status=COMPLETED">
      <h3>완료</h3>
      <div class="count">${statusCounts.COMPLETED}</div>
    </a>
  </div>

  <div class="card">
    <a href="${pageContext.request.contextPath}/staff/complaints?status=REJECTED">
      <h3>반려</h3>
      <div class="count">${statusCounts.REJECTED}</div>
    </a>
  </div>
    </div>

    <div class="dashboard-section">
  <div class="section-box" id="pendingComplaints">
    <h2>처리 대기 민원</h2>

    <c:choose>
      <c:when test="${empty pendingComplaints}">
        <p>처리 대기 중인 민원이 없습니다.</p>
      </c:when>
      <c:otherwise>
        <table>
          <thead>
          <tr>
            <th>제목</th>
            <th>상태</th>
            <th>작성일</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="complaint" items="${pendingComplaints}">
            <tr>
              <td class="title-cell">
                <a href="${pageContext.request.contextPath}/staff/complaints/detail?id=${complaint.complaintId}">
                  ${complaint.title}
                </a>
              </td>
              <td>
                <c:choose>
                  <c:when test="${complaint.status == 'RECEIVED'}">접수</c:when>
                  <c:when test="${complaint.status == 'REVIEWING'}">검토중</c:when>
                  <c:when test="${complaint.status == 'PROCESSING'}">처리중</c:when>
                  <c:when test="${complaint.status == 'COMPLETED'}">완료</c:when>
                  <c:when test="${complaint.status == 'REJECTED'}">반려</c:when>
                  <c:otherwise>${complaint.status}</c:otherwise>
                </c:choose>
              </td>
              <td>${complaint.createdAt}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </div>

  <div class="section-box" id="recentComplaints">
    <h2>최근 접수된 민원</h2>

    <c:choose>
      <c:when test="${empty recentComplaints}">
        <p>최근 접수된 민원이 없습니다.</p>
      </c:when>
      <c:otherwise>
        <table>
          <thead>
          <tr>
            <th>제목</th>
            <th>상태</th>
            <th>추천 수</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="complaint" items="${recentComplaints}">
            <tr>
              <td class="title-cell">
                <a href="${pageContext.request.contextPath}/staff/complaints/detail?id=${complaint.complaintId}">
                  ${complaint.title}
                </a>
              </td>
              <td>
                <c:choose>
                  <c:when test="${complaint.status == 'RECEIVED'}">접수</c:when>
                  <c:when test="${complaint.status == 'REVIEWING'}">검토중</c:when>
                  <c:when test="${complaint.status == 'PROCESSING'}">처리중</c:when>
                  <c:when test="${complaint.status == 'COMPLETED'}">완료</c:when>
                  <c:when test="${complaint.status == 'REJECTED'}">반려</c:when>
                  <c:otherwise>${complaint.status}</c:otherwise>
                </c:choose>
              </td>
              <td>${complaint.likeCount}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
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
