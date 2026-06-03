<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.dto.UserDTO" %>
<%@ page import="com.campus.dto.DepartmentDTO" %>

<%
  List<UserDTO> users = (List<UserDTO>) request.getAttribute("users");
  List<DepartmentDTO> departments = (List<DepartmentDTO>) request.getAttribute("departments");
  List<String> roles = (List<String>) request.getAttribute("roles");

  String selectedRole = (String) request.getAttribute("selectedRole");
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

  String queryString = "role=" + selectedRole
          + "&searchType=" + searchType
          + "&keyword=" + keyword;
%>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8">
    <title>관리자 - 사용자 관리 테스트</title>

    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 40px;
      }

      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
      }

      th, td {
        border: 1px solid #ccc;
        padding: 10px;
        text-align: center;
      }

      th {
        background-color: #f2f2f2;
      }

      select, button, input {
        padding: 6px;
      }

      .top-menu {
        margin-bottom: 20px;
      }

      .top-menu a {
        margin-right: 12px;
      }

      .search-box {
        margin: 20px 0;
        padding: 15px;
        border: 1px solid #ccc;
        background-color: #f9f9f9;
      }

      .search-box select,
      .search-box input,
      .search-box button {
        margin-right: 8px;
      }

      .pagination {
        margin-top: 25px;
        text-align: center;
      }

      .pagination a,
      .pagination span {
        display: inline-block;
        margin: 0 3px;
        padding: 6px 10px;
        border: 1px solid #ccc;
        text-decoration: none;
        color: #333;
      }

      .pagination .current {
        font-weight: bold;
        background-color: #eee;
      }

      .count-info {
        margin-top: 15px;
        color: #555;
      }
    </style>
  </head>

  <body>

  <h1>관리자 - 사용자 관리 테스트</h1>

  <div class="top-menu">
    <a href="<%= request.getContextPath() %>/admin/dashboard">대시보드</a>
    <a href="<%= request.getContextPath() %>/admin/departments">부서 관리</a>
    <a href="<%= request.getContextPath() %>/admin/complaints">민원 관리</a>
  </div>

  <hr>

  <%-- 검색, 필터 part --%>
  <div class="search-box">
    <form action="<%= request.getContextPath() %>/admin/users" method="get">

      <label>역할</label>
      <select name="role">
        <option value="" <%= selectedRole.isBlank() ? "selected" : "" %>>전체</option>

        <% if (roles != null) { %>
        <% for (String role : roles) { %>
        <option value="<%= role %>"
                <%= role.equals(selectedRole) ? "selected" : "" %>>
          <%= role %>
        </option>
        <% } %>
        <% } %>
      </select>

      <label>검색 기준</label>
      <select name="searchType">
        <option value="loginId" <%= "loginId".equals(searchType) ? "selected" : "" %>>로그인 ID</option>
        <option value="name" <%= "name".equals(searchType) ? "selected" : "" %>>이름</option>
      </select>

      <input type="text" name="keyword" value="<%= keyword %>" placeholder="검색어 입력">

      <button type="submit">검색</button>

      <a href="<%= request.getContextPath() %>/admin/users">초기화</a>
    </form>
  </div>

  <div class="count-info">
    총 사용자 수: <%= totalCount %>명 /
    현재 페이지: <%= currentPage %> / <%= totalPages %>
  </div>

  <% if (users == null || users.isEmpty()) { %>

  <p>조회된 사용자가 없습니다.</p>

  <% } else { %>

  <table>
    <thead>
    <tr>
      <th>사용자 ID</th>
      <th>로그인 ID</th>
      <th>이름</th>
      <th>현재 역할</th>
      <th>현재 담당부서</th>
      <th>가입일</th>
      <th>역할 / 담당부서 수정</th>
    </tr>
    </thead>

    <tbody>
    <% for (UserDTO user : users) { %>
    <tr>
      <td><%= user.getUserId() %></td>
      <td><%= user.getLoginId() %></td>
      <td><%= user.getName() %></td>
      <td><%= user.getRole() %></td>
      <td>
        <%= user.getDepartmentName() != null ? user.getDepartmentName() : "-" %>
      </td>
      <td><%= user.getCreatedAt() %></td>

      <%-- 사용자 정보 업데이트 part --%>
      <td>
        <form action="<%= request.getContextPath() %>/admin/users/update" method="post" onsubmit="return confirmUpdateUser(this);">
          <input type="hidden" name="userId" value="<%= user.getUserId() %>">

          <select name="role" class="role-select">
            <% if (roles != null) { %>
            <% for (String role : roles) { %>
            <option value="<%= role %>"
                    <%= role.equals(user.getRole()) ? "selected" : "" %>>
              <%= role %>
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
              <%= dept.getName() %> (<%= dept.getType() %>)
            </option>
            <% } %>
            <% } %>
          </select>

          <button type="submit">수정</button>
        </form>
      </td>
    </tr>
    <% } %>
    </tbody>
  </table>

  <%-- 페이지 part --%>
  <div class="pagination">
    <% if (currentPage > 1) { %>
    <a href="<%= request.getContextPath() %>/admin/users?<%= queryString %>&page=<%= currentPage - 1 %>">
      이전
    </a>
    <% } %>

    <% for (int i = 1; i <= totalPages; i++) { %>
    <% if (i == currentPage) { %>
    <span class="current"><%= i %></span>
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


  <%
    String result = request.getParameter("result");
  %>

  <script>
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

    function confirmUpdateUser(form) {
      const userId = form.userId.value;
      const role = form.role.value;
      const departmentSelect = form.departmentId;

      let departmentText = "담당부서 없음";

      if (departmentSelect && departmentSelect.selectedIndex >= 0) {
        departmentText = departmentSelect.options[departmentSelect.selectedIndex].text;
      }

      if (role === "STUDENT") {
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

      if (roleSelect.value === "STUDENT") {
        departmentSelect.value = "";
        departmentSelect.disabled = true;
      } else if (roleSelect.value === "STAFF") {
        departmentSelect.disabled = false;
      }
    }

    document.addEventListener("DOMContentLoaded", function () {
      const rows = document.querySelectorAll("tbody tr");

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