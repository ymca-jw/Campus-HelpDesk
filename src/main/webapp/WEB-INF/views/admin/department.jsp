<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.dto.DepartmentDTO" %>

<%!
    private String typeText(String type) {
        if ("ADMIN".equals(type)) return "행정부서";
        if ("MAJOR".equals(type)) return "학과";
        return type;
    }

    private String dateText(java.util.Date date) {
        if (date == null) return "";
        return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    }
%>

<%
    List<DepartmentDTO> departments =
            (List<DepartmentDTO>) request.getAttribute("departments");

    String selectedType = (String) request.getAttribute("selectedType");
    String keyword = (String) request.getAttribute("keyword");

    if (selectedType == null) selectedType = "";
    if (keyword == null) keyword = "";

    String result = request.getParameter("result");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 - 부서 관리</title>
    <link rel="icon" type="image/svg+xml" href="<%= request.getContextPath() %>/assets/images/leaf_logo.svg">

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            color: #111827;
            background-color: #ffffff;
            font-family: Arial, "Noto Sans KR", sans-serif;
        }

        a { color: inherit; text-decoration: none; }

        /* ── Header ── */
        .admin-topbar { border-bottom: 1px solid #e5e7eb; background: #fff; }

        .admin-header-inner {
            display: flex; align-items: center; justify-content: space-between;
            max-width: 1280px; height: 82px; margin: 0 auto; padding: 0 40px;
        }

        .admin-logo img { display: block; width: 180px; max-height: 52px; object-fit: contain; }

        .header-left { display: flex; align-items: center; gap: 32px; }

        .login-area { display: flex; align-items: center; gap: 16px; color: #475467; font-size: 14px; }

        .header-nav { display: flex; align-items: center; gap: 24px; font-size: 14px; color: #475467; }
        .header-nav a:hover { color: #007a5a; }

        /* ── Layout ── */
        .admin-layout {
            display: flex; gap: 36px;
            max-width: 1280px; margin: 54px auto 80px; padding: 0 40px;
        }

        .admin-sidebar { flex: 0 0 240px; }
        .admin-content  { flex: 1; min-width: 0; }

        /* ── Sidebar ── */
        .side-section { margin-bottom: 18px; }

        .side-toggle {
            display: flex; align-items: center; justify-content: space-between;
            width: 100%; border: 0; border-bottom: 1px solid #e5e7eb;
            background: transparent; cursor: pointer;
            color: #111827; font-size: 18px; font-weight: 700;
            padding: 14px 10px; text-align: left;
        }

        .side-toggle::after {
            content: "⌄"; color: #6b7280; font-size: 18px;
            transition: transform 0.2s ease;
        }

        .side-section.collapsed .side-toggle::after { transform: rotate(-90deg); }

        .side-links {
            overflow: hidden; max-height: 260px;
            padding: 12px 0 8px 16px; border-left: 1px solid #d1d5db; margin-left: 10px;
            transition: max-height 0.28s ease, padding-top 0.28s ease, padding-bottom 0.28s ease;
        }

        .side-section.collapsed .side-links { max-height: 0; padding-top: 0; padding-bottom: 0; }

        .side-links a { display: block; padding: 10px 12px; color: #111827; }

        .side-links a.active {
            color: #007a5a; font-weight: 700;
            border-left: 2px solid #007a5a; margin-left: -17px; padding-left: 27px;
        }

        /* ── Title ── */
        .admin-content h1 { margin: 0; font-size: 42px; line-height: 1.2; }
        .admin-content > p  { margin: 14px 0 0; color: #667085; font-size: 18px; }

        /* ── Filter panel ── */
        .filter-panel {
            display: grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap: 12px;
            margin-top: 28px; padding: 18px;
            border: 1px solid #edf0f4; border-radius: 8px; background: #f8fafc;
        }

        .filter-panel select,
        .filter-panel input[type="text"] {
            width: 100%; height: 46px; border: 0; border-radius: 8px;
            background: #fff; padding: 0 14px; color: #344054; font-size: 14px; outline: none;
        }

        .filter-actions { display: flex; gap: 8px; }

        .filter-actions button,
        .filter-actions a {
            display: inline-flex; align-items: center; justify-content: center;
            height: 46px; padding: 0 18px; border-radius: 8px;
            font-size: 14px; font-weight: 700; white-space: nowrap;
        }

        .filter-actions button {
            border: 0; background: #007a5a; color: #fff; cursor: pointer;
        }

        .filter-actions a {
            border: 1px solid #d0d5dd; background: #fff; color: #475467;
        }

        /* ── List header ── */
        .list-header {
            display: flex; align-items: flex-end; justify-content: space-between;
            margin-top: 40px; padding-bottom: 22px; border-bottom: 2px solid #667085;
        }

        .list-header h2 { margin: 0 0 6px; font-size: 28px; }
        .list-header p  { margin: 0; color: #667085; font-size: 14px; }

        .btn-add {
            display: inline-flex; align-items: center; justify-content: center;
            height: 44px; padding: 0 18px; border: 0; border-radius: 8px;
            background: #007a5a; color: #fff; font-size: 14px; font-weight: 700;
            cursor: pointer;
        }

        .modal-overlay {
            display: none; position: fixed; inset: 0; z-index: 1000;
            align-items: center; justify-content: center;
            padding: 24px; background: rgba(15, 23, 42, 0.34);
        }

        .modal-overlay.open { display: flex; }

        .modal-box {
            width: min(560px, 100%); border: 1px solid #e4e7ec; border-radius: 8px;
            background: #fff; padding: 24px; box-shadow: 0 24px 60px rgba(16, 24, 40, 0.24);
        }

        .modal-header {
            display: flex; align-items: center; justify-content: space-between;
            gap: 16px; padding-bottom: 16px; border-bottom: 1px solid #e4e7ec;
        }

        .modal-header h2 { margin: 0; font-size: 24px; }

        .btn-close {
            height: 38px; padding: 0 14px; border: 1px solid #d0d5dd; border-radius: 8px;
            background: #fff; color: #475467; font-size: 14px; font-weight: 700; cursor: pointer;
        }

        .create-form {
            display: grid; grid-template-columns: 1fr; gap: 12px; margin-top: 20px;
        }

        .create-form input[type="text"],
        .create-form select {
            width: 100%; height: 46px; border: 1px solid #d0d5dd; border-radius: 8px;
            background: #fff; padding: 0 14px; color: #344054; font-size: 14px; outline: none;
        }

        .create-actions {
            display: flex; justify-content: flex-end; gap: 8px; margin-top: 6px;
        }

        .create-actions button,
        .create-actions .btn-cancel {
            display: inline-flex; align-items: center; justify-content: center;
            height: 44px; padding: 0 18px; border-radius: 8px;
            font-size: 14px; font-weight: 700; cursor: pointer;
        }

        .create-actions button {
            border: 0; background: #007a5a; color: #fff;
        }

        .create-actions .btn-cancel {
            border: 1px solid #d0d5dd; background: #fff; color: #475467;
        }

        /* ── Table ── */
        table { width: 100%; border-collapse: collapse; }

        th, td {
            border: 0; border-bottom: 1px solid #e4e7ec;
            padding: 14px 10px; text-align: center; vertical-align: middle;
        }

        th { color: #667085; background-color: #f8fafc; font-size: 14px; font-weight: 700; }

        .empty-message {
            padding: 42px 0; border-bottom: 1px solid #d9dee7;
            color: #667085; text-align: center;
        }

        /* ── Inline form ── */
        .inline-form {
            display: flex; align-items: center; gap: 8px; justify-content: center;
        }

        .inline-form input[type="text"] {
            height: 36px; width: 140px; padding: 0 10px;
            border: 1px solid #d0d5dd; border-radius: 6px;
            background: #fff; color: #344054; font-size: 13px; outline: none;
        }

        .inline-form input[type="text"]:focus { border-color: #007a5a; }

        .inline-form select {
            height: 36px; padding: 0 10px;
            border: 1px solid #d0d5dd; border-radius: 6px;
            background: #fff; color: #344054; font-size: 13px; outline: none;
        }

        .btn-edit {
            height: 36px; padding: 0 14px;
            border: 1px solid #d0d5dd; border-radius: 6px;
            background: #fff; color: #344054; font-size: 13px;
            cursor: pointer; white-space: nowrap;
        }

        .btn-edit:hover { background: #f9fafb; border-color: #007a5a; color: #007a5a; }

        /* ── Responsive ── */
        @media (max-width: 900px) {
            .admin-header-inner, .admin-layout { padding-left: 20px; padding-right: 20px; }
            .admin-layout { flex-direction: column; }
            .admin-sidebar { width: 100%; flex-basis: auto; }
            .filter-panel { grid-template-columns: 1fr; }
            .table-wrap { overflow-x: auto; }
            .inline-form { flex-wrap: wrap; }
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
                <a href="<%= request.getContextPath() %>/admin/dashboard">메인</a>
                <a href="<%= request.getContextPath() %>/admin/users">사용자 관리</a>
                <a class="active" href="<%= request.getContextPath() %>/admin/departments">부서 관리</a>
                <a href="<%= request.getContextPath() %>/admin/complaints">민원 관리</a>
            </div>
        </div>
    </aside>

    <section class="admin-content">
        <h1>부서 관리</h1>
        <p>부서를 조회하고 추가·수정할 수 있습니다.</p>

        <%-- 검색 필터 --%>
        <form class="filter-panel" action="<%= request.getContextPath() %>/admin/departments" method="get">
            <select name="type" aria-label="부서유형">
                <option value="" <%= selectedType.isBlank() ? "selected" : "" %>>부서유형 전체</option>
                <option value="ADMIN" <%= "ADMIN".equals(selectedType) ? "selected" : "" %>>행정부서</option>
                <option value="MAJOR" <%= "MAJOR".equals(selectedType) ? "selected" : "" %>>학과</option>
            </select>

            <input type="text" name="keyword" value="<%= keyword %>" placeholder="부서명을 입력하세요">

            <div class="filter-actions">
                <button type="submit">검색</button>
                <a href="<%= request.getContextPath() %>/admin/departments">초기화</a>
            </div>
        </form>

        <div class="list-header">
            <div>
                <h2>부서 목록</h2>
                <p>총 <%= departments != null ? departments.size() : 0 %>개 부서</p>
            </div>
            <button type="button" class="btn-add" id="openCreateModalButton">추가</button>
        </div>

        <% if (departments == null || departments.isEmpty()) { %>
        <div class="empty-message">조회된 부서가 없습니다.</div>
        <% } else { %>

        <div class="table-wrap">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>부서명</th>
                <th>부서 유형</th>
                <th>생성일</th>
                <th>부서명 / 유형 수정</th>
            </tr>
            </thead>

            <tbody>
            <% for (DepartmentDTO dept : departments) { %>
            <tr>
                <td><%= dept.getDepartmentId() %></td>
                <td><%= dept.getName() %></td>
                <td><%= typeText(dept.getType()) %></td>
                <td><%= dateText(dept.getCreatedAt()) %></td>
                <td>
                    <form class="inline-form"
                          action="<%= request.getContextPath() %>/admin/departments/update"
                          method="post"
                          onsubmit="return confirmUpdateDepartment(this);">

                        <input type="hidden" name="departmentId" value="<%= dept.getDepartmentId() %>">

                        <input type="text" name="name" value="<%= dept.getName() %>" required>

                        <select name="type">
                            <option value="ADMIN" <%= "ADMIN".equals(dept.getType()) ? "selected" : "" %>>
                                행정부서
                            </option>
                            <option value="MAJOR" <%= "MAJOR".equals(dept.getType()) ? "selected" : "" %>>
                                학과
                            </option>
                        </select>

                        <button type="submit" class="btn-edit">수정</button>
                    </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        </div>

        <% } %>

    </section>
</main>

<div class="modal-overlay" id="createDepartmentModal" aria-hidden="true">
    <div class="modal-box" role="dialog" aria-modal="true" aria-labelledby="createDepartmentTitle">
        <div class="modal-header">
            <h2 id="createDepartmentTitle">부서 추가</h2>
            <button type="button" class="btn-close" id="closeCreateModalButton">닫기</button>
        </div>

        <form class="create-form"
              action="<%= request.getContextPath() %>/admin/departments/create"
              method="post"
              onsubmit="return confirmCreateDepartment(this);">
            <select name="type" aria-label="부서 유형">
                <option value="ADMIN">행정부서</option>
                <option value="MAJOR">학과</option>
            </select>

            <input type="text" name="name" placeholder="부서명 (예: 학생처)" required>

            <div class="create-actions">
                <button type="button" class="btn-cancel" id="cancelCreateModalButton">취소</button>
                <button type="submit">추가</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.querySelectorAll(".side-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            button.closest(".side-section").classList.toggle("collapsed");
        });
    });

    const createDepartmentModal = document.getElementById("createDepartmentModal");
    const openCreateModalButton = document.getElementById("openCreateModalButton");
    const closeCreateModalButton = document.getElementById("closeCreateModalButton");
    const cancelCreateModalButton = document.getElementById("cancelCreateModalButton");

    function openCreateDepartmentModal() {
        createDepartmentModal.classList.add("open");
        createDepartmentModal.setAttribute("aria-hidden", "false");
        const nameInput = createDepartmentModal.querySelector("input[name='name']");
        if (nameInput) {
            nameInput.focus();
        }
    }

    function closeCreateDepartmentModal() {
        const createForm = createDepartmentModal.querySelector(".create-form");
        if (createForm) {
            createForm.reset();
        }

        createDepartmentModal.classList.remove("open");
        createDepartmentModal.setAttribute("aria-hidden", "true");
    }

    if (openCreateModalButton) {
        openCreateModalButton.addEventListener("click", openCreateDepartmentModal);
    }

    [closeCreateModalButton, cancelCreateModalButton].forEach(function (button) {
        if (button) {
            button.addEventListener("click", closeCreateDepartmentModal);
        }
    });

    if (createDepartmentModal) {
        createDepartmentModal.addEventListener("click", function (event) {
            if (event.target === createDepartmentModal) {
                closeCreateDepartmentModal();
            }
        });
    }

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape" && createDepartmentModal.classList.contains("open")) {
            closeCreateDepartmentModal();
        }
    });

    <% if ("createSucc".equals(result)) { %>
        alert("부서가 추가되었습니다.");
    removeResultParam();
    <% } else if ("createFail".equals(result)) { %>
        alert("부서 추가에 실패했습니다.");
    removeResultParam();
    <% } else if ("createDup".equals(result)) { %>
        alert("이미 존재하는 부서명입니다.");
    removeResultParam();
    <% } else if ("updateSucc".equals(result)) { %>
        alert("부서 정보가 수정되었습니다.");
    removeResultParam();
    <% } else if ("updateFail".equals(result)) { %>
        alert("부서 정보 수정에 실패했습니다.");
    removeResultParam();
    <% } else if ("updateNA".equals(result)) { %>
        alert("이미 동일한 부서명과 부서유형입니다.");
    removeResultParam();
    <% } else if ("updateDup".equals(result)) { %>
        alert("이미 존재하는 부서명입니다.");
    removeResultParam();
    <% } %>

    function removeResultParam() {
        const url = new URL(window.location.href);
        url.searchParams.delete("result");
        window.history.replaceState({}, "", url);
    }

    function confirmCreateDepartment(form) {
        const name = form.name.value.trim();
        const type = form.type.value;

        if (!name) {
            alert("부서명을 입력하세요.");
            return false;
        }

        const typeText = type === "ADMIN" ? "행정부서" : "학과";

        return confirm(name + " (" + typeText + ") 부서를 추가하시겠습니까?");
    }

    function confirmUpdateDepartment(form) {
        const name = form.name.value.trim();
        const type = form.type.value;

        if (!name) {
            alert("부서명을 입력하세요.");
            return false;
        }

        const typeText = type === "ADMIN" ? "행정부서" : "학과";

        return confirm(name + " (" + typeText + ") 부서로 수정하시겠습니까?");
    }
</script>

</body>
</html>
