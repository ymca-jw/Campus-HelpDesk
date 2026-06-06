<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.dto.UserDTO" %>
<%@ page import="com.campus.dto.DepartmentDTO" %>

<%!
    private String roleText(String role) {
        if ("STUDENT".equals(role)) return "학생";
        if ("STAFF".equals(role)) return "담당자";
        if ("ADMIN".equals(role)) return "관리자";
        return role;
    }

    private String dateText(java.util.Date date) {
        if (date == null) return "";
        return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    }

    private String loginIdText(String loginId) {
        if (loginId == null) return "";
        String suffix = "@skuniv.ac.kr";
        if (loginId.toLowerCase().endsWith(suffix)) {
            return loginId.substring(0, loginId.length() - suffix.length());
        }
        return loginId;
    }
%>

<%
  List<UserDTO> users = (List<UserDTO>) request.getAttribute("users");
  List<DepartmentDTO> departments = (List<DepartmentDTO>) request.getAttribute("departments");
  List<String> roles = (List<String>) request.getAttribute("roles");

  String selectedRole = (String) request.getAttribute("selectedRole");
  Long selectedDepartmentId = (Long) request.getAttribute("selectedDepartmentId");
  String searchType = (String) request.getAttribute("searchType");
  String keyword = (String) request.getAttribute("keyword");

  Integer currentPage = (Integer) request.getAttribute("currentPage");
  Integer totalPages = (Integer) request.getAttribute("totalPages");
  Integer totalCount = (Integer) request.getAttribute("totalCount");

  if (selectedRole == null) selectedRole = "";
  if (searchType == null || searchType.isBlank()) searchType = "loginId";
  if (keyword == null) keyword = "";
  if (currentPage == null) currentPage = 1;
  if (totalPages == null) totalPages = 1;
  if (totalCount == null) totalCount = 0;

  String selectedDepartmentParam =
          selectedDepartmentId == null ? "" : String.valueOf(selectedDepartmentId);

  String queryString = "role=" + selectedRole
          + "&departmentId=" + selectedDepartmentParam
          + "&searchType=" + searchType
          + "&keyword=" + keyword;
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 - 사용자 관리</title>

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

        /* ── Filter ── */
        .filter-panel {
            display: grid; grid-template-columns: 1fr 1fr 1fr minmax(0, 1.2fr) auto; gap: 12px;
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

        /* ── Table ── */
        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
            font-size: 14px;
        }

        th, td {
            border: 0; border-bottom: 1px solid #e4e7ec;
            padding: 14px 8px; text-align: center; vertical-align: middle;
            word-break: keep-all;
        }

        th { color: #667085; background-color: #f8fafc; font-size: 14px; font-weight: 700; }

        th:nth-child(1), td:nth-child(1) { width: 48px; }
        th:nth-child(2), td:nth-child(2) { width: 140px; }
        th:nth-child(3), td:nth-child(3) { width: 74px; white-space: nowrap; }
        th:nth-child(4), td:nth-child(4) { width: 70px; white-space: nowrap; }
        th:nth-child(5), td:nth-child(5) { width: 120px; }
        th:nth-child(6), td:nth-child(6) { width: 132px; }
        th:nth-child(7), td:nth-child(7) { width: 310px; }

        td:nth-child(2) {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .empty-message {
            padding: 42px 0; border-bottom: 1px solid #d9dee7;
            color: #667085; text-align: center;
        }

        /* ── Inline form ── */
        .inline-form {
            display: flex; align-items: center; gap: 8px; justify-content: center;
        }

        .inline-form select {
            height: 36px; padding: 0 10px;
            border: 1px solid #d0d5dd; border-radius: 6px;
            background: #fff; color: #344054; font-size: 13px; outline: none;
        }

        .inline-form select:disabled {
            background: #f2f4f7; color: #98a2b3; cursor: not-allowed;
        }

        .btn-edit {
            height: 36px; padding: 0 14px;
            border: 1px solid #d0d5dd; border-radius: 6px;
            background: #fff; color: #344054; font-size: 13px;
            cursor: pointer; white-space: nowrap;
        }

        .btn-edit:hover { background: #f9fafb; border-color: #007a5a; color: #007a5a; }

        /* ── Pagination ── */
        .pagination { display: flex; justify-content: center; gap: 6px; margin-top: 28px; }

        .pagination a,
        .pagination strong {
            display: inline-flex; align-items: center; justify-content: center;
            min-width: 36px; height: 36px;
            border: 1px solid #d0d5dd; border-radius: 8px;
            padding: 0 10px; color: #475467; background: #fff; font-size: 14px;
        }

        .pagination strong { border-color: #0b7a55; background: #0b7a55; color: #fff; }

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
                <a class="active" href="<%= request.getContextPath() %>/admin/users">사용자 관리</a>
                <a href="<%= request.getContextPath() %>/admin/departments">부서 관리</a>
                <a href="<%= request.getContextPath() %>/admin/complaints">민원 관리</a>
            </div>
        </div>
    </aside>

    <section class="admin-content">
        <h1>사용자 관리</h1>
        <p>전체 사용자를 조회하고 역할 및 담당부서를 관리할 수 있습니다.</p>

        <form class="filter-panel" action="<%= request.getContextPath() %>/admin/users" method="get">
            <select name="role" aria-label="역할">
                <option value="" <%= selectedRole.isBlank() ? "selected" : "" %>>역할 전체</option>
                <% if (roles != null) { %>
                <% for (String role : roles) { %>
                <option value="<%= role %>"
                        <%= role.equals(selectedRole) ? "selected" : "" %>>
                    <%= roleText(role) %>
                </option>
                <% } %>
                <% } %>
            </select>

            <select name="departmentId" id="departmentFilter" aria-label="담당부서">
                <option value="" <%= selectedDepartmentParam.isBlank() ? "selected" : "" %>>담당부서 전체</option>
                <% if (departments != null) { %>
                <% for (DepartmentDTO dept : departments) { %>
                <option value="<%= dept.getDepartmentId() %>"
                        <%= selectedDepartmentId != null
                                && selectedDepartmentId.equals(dept.getDepartmentId())
                                ? "selected" : "" %>>
                    <%= dept.getName() %>
                </option>
                <% } %>
                <% } %>
            </select>

            <select name="searchType" aria-label="검색기준">
                <option value="loginId" <%= "loginId".equals(searchType) ? "selected" : "" %>>ID</option>
                <option value="name" <%= "name".equals(searchType) ? "selected" : "" %>>이름</option>
            </select>

            <input type="text" name="keyword" value="<%= keyword %>" placeholder="검색어를 입력하세요">

            <div class="filter-actions">
                <button type="submit">검색</button>
                <a href="<%= request.getContextPath() %>/admin/users">초기화</a>
            </div>
        </form>

        <div class="list-header">
            <div>
                <h2>사용자 목록</h2>
                <p>총 <%= totalCount %>명 · 현재 <%= currentPage %>페이지 / 총 <%= totalPages %>페이지</p>
            </div>
        </div>

        <% if (users == null || users.isEmpty()) { %>
        <div class="empty-message">조회된 사용자가 없습니다.</div>
        <% } else { %>

        <div class="table-wrap">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>로그인 ID</th>
                <th>이름</th>
                <th>역할</th>
                <th>담당부서</th>
                <th>가입일</th>
                <th>역할 / 담당부서 수정</th>
            </tr>
            </thead>

            <tbody>
            <% for (UserDTO user : users) { %>
            <tr>
                <td><%= user.getUserId() %></td>
                <td title="<%= user.getLoginId() %>"><%= loginIdText(user.getLoginId()) %></td>
                <td><%= user.getName() %></td>
                <td><%= roleText(user.getRole()) %></td>
                <td><%= user.getDepartmentName() != null ? user.getDepartmentName() : "-" %></td>
                <td><%= dateText(user.getCreatedAt()) %></td>

                <td>
                    <form class="inline-form"
                          action="<%= request.getContextPath() %>/admin/users/update"
                          method="post"
                          onsubmit="return confirmUpdateUser(this);">

                        <input type="hidden" name="userId" value="<%= user.getUserId() %>">

                        <select name="role" class="role-select">
                            <% if (roles != null) { %>
                            <% for (String role : roles) { %>
                            <option value="<%= role %>"
                                    <%= role.equals(user.getRole()) ? "selected" : "" %>>
                                <%= roleText(role) %>
                            </option>
                            <% } %>
                            <% } %>
                        </select>

                        <select name="departmentId" class="department-select">
                            <option value="">담당부서 없음</option>
                            <% if (departments != null) { %>
                            <% for (DepartmentDTO dept : departments) { %>
                            <option value="<%= dept.getDepartmentId() %>"
                                    <%= user.getDepartmentId() != null
                                            && user.getDepartmentId().equals(dept.getDepartmentId())
                                            ? "selected" : "" %>>
                                <%= dept.getName() %>
                            </option>
                            <% } %>
                            <% } %>
                        </select>

                        <button type="submit" class="btn-edit">수정</button>
                    </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        </div>

        <div class="pagination">
            <% if (currentPage > 1) { %>
            <a href="<%= request.getContextPath() %>/admin/users?<%= queryString %>&page=<%= currentPage - 1 %>">
                이전
            </a>
            <% } %>

            <% for (int i = 1; i <= totalPages; i++) { %>
            <% if (i == currentPage) { %>
            <strong><%= i %></strong>
            <% } else { %>
            <a href="<%= request.getContextPath() %>/admin/users?<%= queryString %>&page=<%= i %>">
                <%= i %>
            </a>
            <% } %>
            <% } %>

            <% if (currentPage < totalPages) { %>
            <a href="<%= request.getContextPath() %>/admin/users?<%= queryString %>&page=<%= currentPage + 1 %>">
                다음
            </a>
            <% } %>
        </div>

        <% } %>

    </section>
</main>

<%
    String result = request.getParameter("result");
%>

<script>
    document.querySelectorAll(".side-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            button.closest(".side-section").classList.toggle("collapsed");
        });
    });

    <% if ("success".equals(result)) { %>
      alert("사용자 정보가 수정되었습니다.");
      history.replaceState(null, "", "<%= request.getContextPath() %>/admin/users");
    <% } else if ("fail".equals(result)) { %>
      alert("사용자 정보 수정에 실패했습니다.");
      history.replaceState(null, "", "<%= request.getContextPath() %>/admin/users");
    <% } else if ("na".equals(result)) { %>
      alert("이미 동일한 역할과 담당부서입니다.");
      history.replaceState(null, "", "<%= request.getContextPath() %>/admin/users");
    <% } %>

    function updateDepartmentFilter() {
      const roleFilter = document.querySelector("select[name='role']");
      const departmentFilter = document.getElementById("departmentFilter");

      if (!roleFilter || !departmentFilter) return;

      if (roleFilter.value === "STUDENT" || roleFilter.value === "ADMIN") {
        departmentFilter.value = "";
        departmentFilter.disabled = true;
      } else {
        departmentFilter.disabled = false;
      }
    }

    function confirmUpdateUser(form) {
      const userId = form.userId.value;
      const role = form.role.value;
      const departmentSelect = form.departmentId;

      let departmentText = "담당부서 없음";

      if (departmentSelect && departmentSelect.selectedIndex >= 0) {
        departmentText = departmentSelect.options[departmentSelect.selectedIndex].text;
      }

      if (role === "STUDENT" || role === "ADMIN") {
        departmentText = "담당부서 없음";
      }

      return confirm(
              "사용자 ID " + userId + "의 정보를 수정하시겠습니까?\n\n" +
              "역할: " + role + "\n" +
              "담당부서: " + departmentText
      );
    }

    function updateDepartmentSelect(row) {
      const roleSelect = row.querySelector(".role-select");
      const departmentSelect = row.querySelector(".department-select");

      if (!roleSelect || !departmentSelect) return;

      if (roleSelect.value === "STUDENT" || roleSelect.value === "ADMIN") {
        departmentSelect.value = "";
        departmentSelect.disabled = true;
      } else if (roleSelect.value === "STAFF") {
        departmentSelect.disabled = false;
      }
    }

    document.addEventListener("DOMContentLoaded", function () {
      const roleFilter = document.querySelector("select[name='role']");
      const rows = document.querySelectorAll("tbody tr");

      updateDepartmentFilter();

      if (roleFilter) {
        roleFilter.addEventListener("change", updateDepartmentFilter);
      }

      rows.forEach(function (row) {
        const roleSelect = row.querySelector(".role-select");

        updateDepartmentSelect(row);

        if (roleSelect) {
          roleSelect.addEventListener("change", function () {
            updateDepartmentSelect(row);
          });
        }
      });
    });
</script>

</body>
</html>
