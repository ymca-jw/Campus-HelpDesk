<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.dto.ComplaintDTO" %>
<%@ page import="com.campus.dto.DepartmentDTO" %>

<%
    List<ComplaintDTO> complaints =
            (List<ComplaintDTO>) request.getAttribute("complaints");

    List<DepartmentDTO> departments =
            (List<DepartmentDTO>) request.getAttribute("departments");

    List<String> categories =
            (List<String>) request.getAttribute("categories");

    List<String> statuses =
            (List<String>) request.getAttribute("statuses");

    Long selectedDepartmentId =
            (Long) request.getAttribute("selectedDepartmentId");

    String selectedCategory =
            (String) request.getAttribute("selectedCategory");

    String selectedStatus =
            (String) request.getAttribute("selectedStatus");

    String searchType =
            (String) request.getAttribute("searchType");

    String keyword =
            (String) request.getAttribute("keyword");

    Integer currentPage =
            (Integer) request.getAttribute("currentPage");

    Integer totalPages =
            (Integer) request.getAttribute("totalPages");

    Integer totalCount =
            (Integer) request.getAttribute("totalCount");

    if (selectedCategory == null) selectedCategory = "";
    if (selectedStatus == null) selectedStatus = "";
    if (searchType == null || searchType.isBlank()) searchType = "title";
    if (keyword == null) keyword = "";
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
    if (totalCount == null) totalCount = 0;

    String selectedDepartmentParam =
            selectedDepartmentId == null ? "" : String.valueOf(selectedDepartmentId);

    String queryString = "departmentId=" + selectedDepartmentParam
            + "&category=" + selectedCategory
            + "&status=" + selectedStatus
            + "&searchType=" + searchType
            + "&keyword=" + keyword;
%>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>관리자 - 민원 관리 테스트</title>

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 40px;
            }

            table {
                width: 1200px;
                border-collapse: collapse;
                margin-top: 20px;
            }

            th, td {
                border: 1px solid #ccc;
                padding: 10px;
                text-align: center;
                vertical-align: middle;
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
                width: 1160px;
            }

            .search-box select,
            .search-box input,
            .search-box button {
                margin-right: 8px;
            }

            .count-info {
                margin-top: 15px;
                color: #555;
            }

            .pagination {
                margin-top: 25px;
                text-align: center;
                width: 1200px;
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

            .title-cell {
                text-align: left;
                max-width: 260px;
            }

            .delete-button {
                color: white;
                background-color: #d9534f;
                border: none;
                cursor: pointer;
            }

            .detail-link {
                display: inline-block;
                margin-bottom: 6px;
            }
        </style>
    </head>

    <body>

    <h1>관리자 - 민원 관리 테스트</h1>

    <div class="top-menu">
        <a href="<%= request.getContextPath() %>/admin/dashboard">대시보드</a>
        <a href="<%= request.getContextPath() %>/admin/users">사용자 관리</a>
        <a href="<%= request.getContextPath() %>/admin/departments">부서 관리</a>
    </div>

    <hr>

    <div class="search-box">
        <form action="<%= request.getContextPath() %>/admin/complaints" method="get">

            <label>담당부서</label>
            <select name="departmentId">
                <option value="" <%= selectedDepartmentId == null ? "selected" : "" %>>전체</option>

                <% if (departments != null) { %>
                <% for (DepartmentDTO dept : departments) { %>
                <option value="<%= dept.getDepartmentId() %>"
                        <%= selectedDepartmentId != null
                                && selectedDepartmentId.equals(dept.getDepartmentId())
                                ? "selected" : "" %>>
                    <%= dept.getName() %> (<%= dept.getType() %>)
                </option>
                <% } %>
                <% } %>
            </select>

            <label>카테고리</label>
            <select name="category">
                <option value="" <%= selectedCategory.isBlank() ? "selected" : "" %>>전체</option>

                <% if (categories != null) { %>
                <% for (String category : categories) { %>
                <option value="<%= category %>"
                        <%= category.equals(selectedCategory) ? "selected" : "" %>>
                    <%= category %>
                </option>
                <% } %>
                <% } %>
            </select>

            <label>상태</label>
            <select name="status">
                <option value="" <%= selectedStatus.isBlank() ? "selected" : "" %>>전체</option>

                <% if (statuses != null) { %>
                <% for (String status : statuses) { %>
                <option value="<%= status %>"
                        <%= status.equals(selectedStatus) ? "selected" : "" %>>
                    <%= status %>
                </option>
                <% } %>
                <% } %>
            </select>

            <label>검색 기준</label>
            <select name="searchType">
                <option value="title" <%= "title".equals(searchType) ? "selected" : "" %>>제목</option>
                <option value="content" <%= "content".equals(searchType) ? "selected" : "" %>>내용</option>
            </select>

            <input type="text" name="keyword" value="<%= keyword %>" placeholder="검색어 입력">

            <button type="submit">검색</button>

            <a href="<%= request.getContextPath() %>/admin/complaints">초기화</a>
        </form>
    </div>

    <div class="count-info">
        총 민원 수: <%= totalCount %>건 /
        현재 페이지: <%= currentPage %> / <%= totalPages %>
    </div>

    <% if (complaints == null || complaints.isEmpty()) { %>

    <p>조회된 민원이 없습니다.</p>

    <% } else { %>

    <table>
        <thead>
        <tr>
            <th>민원 ID</th>
            <th>제목</th>
            <th>작성자</th>
            <th>담당부서</th>
            <th>카테고리</th>
            <th>상태</th>
            <th>추천수</th>
            <th>공개 여부</th>
            <th>작성일</th>
            <th>관리</th>
        </tr>
        </thead>

        <tbody>
        <% for (ComplaintDTO complaint : complaints) { %>
        <tr>
            <td><%= complaint.getComplaintId() %></td>

            <td class="title-cell">
                <%= complaint.getTitle() %>
            </td>

            <td>
                <%= complaint.getWriterName() != null ? complaint.getWriterName() : "-" %>
            </td>

            <td>
                <%= complaint.getDepartmentName() != null ? complaint.getDepartmentName() : "-" %>
            </td>

            <td><%= complaint.getCategory() %></td>

            <td><%= complaint.getStatus() %></td>

            <td><%= complaint.getLikeCount() %></td>

            <td>
                <%= complaint.isPrivateFlag() ? "비공개" : "공개" %>
            </td>

            <td><%= complaint.getCreatedAt() %></td>

            <td>
                <a class="detail-link"
                   href="<%= request.getContextPath() %>/complaints/detail?id=<%= complaint.getComplaintId() %>">
                    상세 보기
                </a>

                <form action="<%= request.getContextPath() %>/admin/complaints/delete"
                      method="post"
                      onsubmit="return confirmDeleteComplaint(this);">

                    <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
                    <input type="hidden" name="title" value="<%= complaint.getTitle() %>">

                    <button type="submit" class="delete-button">삭제</button>
                </form>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <div class="pagination">
        <% if (currentPage > 1) { %>
        <a href="<%= request.getContextPath() %>/admin/complaints?<%= queryString %>&page=<%= currentPage - 1 %>">
            이전
        </a>
        <% } %>

        <% for (int i = 1; i <= totalPages; i++) { %>
        <% if (i == currentPage) { %>
        <span class="current"><%= i %></span>
        <% } else { %>
        <a href="<%= request.getContextPath() %>/admin/complaints?<%= queryString %>&page=<%= i %>">
            <%= i %>
        </a>
        <% } %>
        <% } %>

        <% if (currentPage < totalPages) { %>
        <a href="<%= request.getContextPath() %>/admin/complaints?<%= queryString %>&page=<%= currentPage + 1 %>">
            다음
        </a>
        <% } %>
    </div>

    <% } %>


    <%
        String result = request.getParameter("result");
    %>
    <script>
        <% if ("deleteSucc".equals(result)) { %>
            alert("민원이 삭제되었습니다.");
            history.replaceState(null, "", "<%= request.getContextPath() %>/admin/complaints");
        <% } else if ("deleteFail".equals(result)) { %>
            alert("민원 삭제에 실패했습니다.");
            history.replaceState(null, "", "<%= request.getContextPath() %>/admin/complaints");
        <% } %>

        function confirmDeleteComplaint(form) {
            const complaintId = form.complaintId.value;
            const title = form.title.value;

            return confirm(
                "민원 ID " + complaintId + "번을 삭제하시겠습니까?\n\n" +
                "제목: " + title + "\n\n" +
                "삭제 시 관련 데이터들도 함께 삭제되고, 삭제 시 복구가 어려울 수 있습니다."
            );
        }
    </script>

    </body>
</html>