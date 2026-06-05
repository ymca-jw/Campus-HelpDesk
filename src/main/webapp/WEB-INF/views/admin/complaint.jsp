<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.dto.ComplaintDTO" %>
<%@ page import="com.campus.dto.DepartmentDTO" %>

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
    <title>관리자 - 민원 관리</title>

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

        .login-area { display: flex; align-items: center; gap: 16px; color: #475467; font-size: 14px; }

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
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;
            margin-top: 28px; padding: 18px;
            border: 1px solid #edf0f4; border-radius: 8px; background: #f8fafc;
        }

        .filter-panel select,
        .filter-panel input {
            width: 100%; height: 46px; border: 0; border-radius: 8px;
            background: #fff; padding: 0 14px; color: #344054; font-size: 14px; outline: none;
        }

        .search-row {
            display: grid; grid-column: span 3;
            grid-template-columns: 120px minmax(0,1fr) 76px 76px; gap: 12px;
        }

        .filter-panel button,
        .filter-panel .btn-reset {
            display: inline-flex; align-items: center; justify-content: center;
            height: 46px; border-radius: 8px; font-size: 14px; font-weight: 700;
        }

        .filter-panel button {
            border: 0; background: #007a5a; color: #fff; cursor: pointer;
        }

        .filter-panel .btn-reset {
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
        table { width: 100%; border-collapse: collapse; margin-top: 0; }

        th, td {
            border: 0; border-bottom: 1px solid #e4e7ec;
            padding: 14px 8px; text-align: center; vertical-align: middle;
            font-size: 13px;
        }

        th { color: #667085; background-color: #f8fafc; font-size: 13px; font-weight: 700; white-space: nowrap; }

        .nowrap { white-space: nowrap; }

        .title-cell { text-align: left; max-width: 260px; }
        .title-cell a {
            display: block; color: #111827; font-weight: 600;
            overflow: hidden; white-space: nowrap; text-overflow: ellipsis;
        }
        .title-cell a:hover { color: #007a5a; }

        .empty-message {
            padding: 42px 0; border-bottom: 1px solid #d9dee7;
            color: #667085; text-align: center;
        }


        /* ── Action buttons ── */

        .btn-delete {
            height: 34px; padding: 0 12px;
            border: 1px solid #fda29b; border-radius: 6px;
            background: #fff; color: #b42318; font-size: 13px;
            cursor: pointer; white-space: nowrap;
        }

        .btn-delete:hover { background: #fef3f2; }

        /* ── Status badge ── */
        .status-text { color: #0b7a55; font-weight: 700; }

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
            .search-row { grid-column: auto; grid-template-columns: 1fr; }
            .table-wrap { overflow-x: auto; }
        }
    </style>
</head>
<body>

<header class="admin-topbar">
    <div class="admin-header-inner">
        <a class="admin-logo" href="<%= request.getContextPath() %>/admin/dashboard">
            <img src="<%= request.getContextPath() %>/assets/images/logo.svg" alt="서경대학교">
        </a>
        <div class="login-area">
            <a href="#">로그인</a>
            <a href="#">마이페이지</a>
            <a href="#">로그아웃</a>
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
                <a href="<%= request.getContextPath() %>/admin/departments">부서 관리</a>
                <a class="active" href="<%= request.getContextPath() %>/admin/complaints">민원 관리</a>
            </div>
        </div>
    </aside>

    <section class="admin-content">
        <h1>민원 관리</h1>
        <p>전체 민원을 조회하고 관리할 수 있습니다.</p>

        <form class="filter-panel" action="<%= request.getContextPath() %>/admin/complaints" method="get">
            <select name="departmentId" aria-label="담당부서">
                <option value="" <%= selectedDepartmentId == null ? "selected" : "" %>>담당부서 전체</option>
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

            <select name="category" aria-label="카테고리">
                <option value="" <%= selectedCategory.isBlank() ? "selected" : "" %>>카테고리 전체</option>
                <% if (categories != null) { %>
                <% for (String category : categories) { %>
                <option value="<%= category %>"
                        <%= category.equals(selectedCategory) ? "selected" : "" %>>
                    <%= category %>
                </option>
                <% } %>
                <% } %>
            </select>

            <select name="status" aria-label="상태">
                <option value="" <%= selectedStatus.isBlank() ? "selected" : "" %>>상태 전체</option>
                <% if (statuses != null) { %>
                <% for (String status : statuses) { %>
                <option value="<%= status %>"
                        <%= status.equals(selectedStatus) ? "selected" : "" %>>
                    <%= statusText(status) %>
                </option>
                <% } %>
                <% } %>
            </select>

            <div class="search-row">
                <select name="searchType" aria-label="검색기준">
                    <option value="title" <%= "title".equals(searchType) ? "selected" : "" %>>제목</option>
                    <option value="content" <%= "content".equals(searchType) ? "selected" : "" %>>내용</option>
                </select>

                <input type="text" name="keyword" value="<%= keyword %>" placeholder="검색어를 입력하세요">

                <button type="submit">검색</button>
                <a class="btn-reset" href="<%= request.getContextPath() %>/admin/complaints">초기화</a>
            </div>
        </form>

        <div class="list-header">
            <div>
                <h2>전체 민원</h2>
                <p>총 <%= totalCount %>건 · 현재 <%= currentPage %>페이지 / 총 <%= totalPages %>페이지</p>
            </div>
        </div>

        <% if (complaints == null || complaints.isEmpty()) { %>
        <div class="empty-message">조회된 민원이 없습니다.</div>
        <% } else { %>

        <div class="table-wrap">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>제목</th>
                <th>작성자</th>
                <th>담당부서</th>
                <th>카테고리</th>
                <th>상태</th>
                <th>추천</th>
                <th>공개</th>
                <th>작성일</th>
                <th>관리</th>
            </tr>
            </thead>

            <tbody>
            <% for (ComplaintDTO complaint : complaints) { %>
            <tr>
                <td><%= complaint.getComplaintId() %></td>

                <td class="title-cell">
                    <a href="<%= request.getContextPath() %>/complaints/detail?id=<%= complaint.getComplaintId() %>">
                        <%= complaint.getTitle() %>
                    </a>
                </td>

                <td class="nowrap"><%= complaint.getWriterName() != null ? complaint.getWriterName() : "-" %></td>
                <td><%= complaint.getDepartmentName() != null ? complaint.getDepartmentName() : "-" %></td>
                <td class="nowrap"><%= complaint.getCategory() %></td>
                <td class="status-text nowrap"><%= statusText(complaint.getStatus()) %></td>
                <td class="nowrap"><%= complaint.getLikeCount() %></td>
                <td class="nowrap"><%= complaint.isPrivateFlag() ? "비공개" : "공개" %></td>
                <td class="nowrap"><%= dateText(complaint.getCreatedAt()) %></td>

                <td>
                    <form action="<%= request.getContextPath() %>/admin/complaints/delete"
                          method="post"
                          onsubmit="return confirmDeleteComplaint(this);">
                        <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
                        <input type="hidden" name="title" value="<%= complaint.getTitle() %>">
                        <button type="submit" class="btn-delete">삭제</button>
                    </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        </div>

        <div class="pagination">
            <% if (currentPage > 1) { %>
            <a href="<%= request.getContextPath() %>/admin/complaints?<%= queryString %>&page=<%= currentPage - 1 %>">
                이전
            </a>
            <% } %>

            <% for (int i = 1; i <= totalPages; i++) { %>
            <% if (i == currentPage) { %>
            <strong><%= i %></strong>
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
