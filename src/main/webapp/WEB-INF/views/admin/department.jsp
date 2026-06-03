<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.dto.DepartmentDTO" %>

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
        <title>관리자 - 부서 관리 테스트</title>

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 40px;
            }

            table {
                width: 1000px;
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

            select, input, button {
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
                width: 760px;
            }

            .search-box select,
            .search-box input,
            .search-box button {
                margin-right: 8px;
            }

            .create-box {
                margin: 20px 0;
                padding: 15px;
                border: 1px solid #ccc;
                background-color: #f9f9f9;
                width: 760px;
            }

            .create-box input,
            .create-box select,
            .create-box button {
                margin-right: 8px;
                padding: 6px;
            }

            .update-form input {
                width: 140px;
            }

            .update-form select {
                width: 100px;
            }
        </style>
    </head>

    <body>

    <h1>관리자 - 부서 관리 테스트</h1>

    <div class="top-menu">
        <a href="<%= request.getContextPath() %>/admin/dashboard">대시보드</a>
        <a href="<%= request.getContextPath() %>/admin/users">사용자 관리</a>
        <a href="<%= request.getContextPath() %>/admin/complaints">민원 관리</a>
    </div>

    <hr>

    <div class="search-box">
        <form action="<%= request.getContextPath() %>/admin/departments" method="get">
            <label>부서유형</label>
            <select name="type">
                <option value="" <%= selectedType.isBlank() ? "selected" : "" %>>전체</option>
                <option value="ADMIN" <%= "ADMIN".equals(selectedType) ? "selected" : "" %>>행정부서</option>
                <option value="MAJOR" <%= "MAJOR".equals(selectedType) ? "selected" : "" %>>학과</option>
            </select>

            <label>부서명</label>
            <input type="text" name="keyword" value="<%= keyword %>" placeholder="부서명 검색">

            <button type="submit">검색</button>

            <a href="<%= request.getContextPath() %>/admin/departments">초기화</a>
        </form>
    </div>

    <%-- 부서 추가 --%>
    <div class="create-box">
        <form action="<%= request.getContextPath() %>/admin/departments/create"
              method="post"
              onsubmit="return confirmCreateDepartment(this);">

            <label>부서명</label>
            <input type="text" name="name" placeholder="예: 학생처" required>

            <label>부서유형</label>
            <select name="type">
                <option value="ADMIN">행정부서</option>
                <option value="MAJOR">학과</option>
            </select>

            <button type="submit">추가</button>
        </form>
    </div>

    <% if (departments == null || departments.isEmpty()) { %>

    <p>조회된 부서가 없습니다.</p>

    <% } else { %>

    <table>
        <thead>
        <tr>
            <th>부서 ID</th>
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
            <td><%= dept.getType() %></td>
            <td><%= dept.getCreatedAt() %></td>
            <td>
                <form class="update-form"
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

                <button type="submit">수정</button>
                </form>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <% } %>

    <script>
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