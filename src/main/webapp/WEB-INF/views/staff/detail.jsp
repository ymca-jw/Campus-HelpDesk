<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.campus.dto.AnswerDTO" %>
<%@ page import="com.campus.dto.ComplaintDTO" %>
<%@ page import="com.campus.dto.StatusHistoryDTO" %>
<%@ page import="com.campus.dto.UserDTO" %>
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
    ComplaintDTO complaint = (ComplaintDTO) request.getAttribute("complaint");
    AnswerDTO answer = (AnswerDTO) request.getAttribute("answer");
    Boolean canManageComplaintAttr = (Boolean) request.getAttribute("canManageComplaint");
    boolean canManageComplaint = canManageComplaintAttr != null && canManageComplaintAttr;
    Boolean canManageAnswerAttr = (Boolean) request.getAttribute("canManageAnswer");
    boolean canManageAnswer = canManageAnswerAttr != null && canManageAnswerAttr;
    List<StatusHistoryDTO> statusHistories =
            (List<StatusHistoryDTO>) request.getAttribute("statusHistories");
    UserDTO navUser = (UserDTO) session.getAttribute("loginUser");
    String userRole = navUser != null ? navUser.getRole() : "";
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>담당자 - 민원 상세</title>

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

        .header-left {
            display: flex;
            align-items: center;
            gap: 32px;
        }

        .login-area {
            display: flex;
            align-items: center;
            gap: 16px;
            color: #475467;
            font-size: 14px;
        }

        .header-nav {
            display: flex;
            align-items: center;
            gap: 24px;
            font-size: 14px;
            color: #475467;
        }

        .header-nav a:hover { color: #007a5a; }

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
            max-height: 260px;
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

        .detail-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 24px;
            padding-bottom: 24px;
            border-bottom: 2px solid #667085;
        }

        .detail-header h1 {
            margin: 0;
            font-size: 40px;
            line-height: 1.28;
            letter-spacing: 0;
        }

        .detail-title-area {
            min-width: 0;
            max-width: calc(100% - 140px);
        }

        .detail-action-area {
            flex: 0 0 auto;
        }

        .post-meta {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px;
            margin: 14px 0 0;
            color: #667085;
            font-size: 14px;
        }

        .post-meta strong {
            color: #344054;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            height: 26px;
            border: 1px solid #e4e7ec;
            border-radius: 999px;
            padding: 0 10px;
            background: #f8fafc;
            color: #344054;
            font-weight: 700;
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 44px;
            border-radius: 8px;
            padding: 0 18px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            white-space: nowrap;
        }

        .button.primary {
            border: 0;
            background: #0b7a55;
            color: #fff;
        }

        .button.secondary {
            border: 1px solid #d0d5dd;
            background: #fff;
            color: #475467;
        }

        .button.danger {
            border: 0;
            background: #b42318;
            color: #fff;
        }

        .content-section {
            margin-top: 34px;
        }

        .section-title {
            margin: 0 0 14px;
            font-size: 24px;
            letter-spacing: 0;
        }

        .content-box,
        .staff-panel {
            border: 1px solid #e4e7ec;
            border-radius: 8px;
            background: #fff;
            padding: 24px;
            box-shadow: 0 12px 28px rgba(16, 24, 40, 0.04);
        }

        .content-box {
            line-height: 1.75;
            white-space: pre-wrap;
        }

        .staff-panel {
            margin-top: 28px;
        }

        .panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
            width: 100%;
        }

        .panel-header h2 {
            margin: 0;
            font-size: 24px;
        }

        .status-form {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-shrink: 0;
            margin-top: 14px;
        }

        .status-reason {
            flex: 1;
            min-width: 0;
        }

        .status-control {
            display: flex;
            flex-direction: column;
            align-items: stretch;
            gap: 6px;
            width: 104px;
            position: relative;
        }

        .status-message {
            min-width: 0;
            color: #0b7a55;
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
            text-align: center;
            position: absolute;
            top: calc(100% + 6px);
            left: 0;
            right: 0;
        }

        .status-message.error {
            color: #b42318;
        }

        select,
        textarea,
        input[type="text"] {
            border: 1px solid #d0d5dd;
            border-radius: 8px;
            background: #fff;
            color: #344054;
            font: inherit;
        }

        select {
            height: 44px;
            padding: 0 12px;
        }

        textarea {
            width: 100%;
            min-height: 180px;
            padding: 16px;
            line-height: 1.7;
            resize: vertical;
        }

        input[type="text"] {
            width: 100%;
            height: 54px;
            padding: 0 16px;
        }

        .answer-meta {
            margin: 0 0 14px;
            color: #667085;
            font-size: 14px;
        }

        .answer-actions {
            display: flex;
            gap: 10px;
            margin-top: 14px;
        }

        .empty-answer {
            border: 1px dashed #d0d5dd;
            border-radius: 8px;
            padding: 24px;
            color: #667085;
            text-align: center;
        }

        .bottom-link {
            display: inline-flex;
            margin-top: 28px;
            color: #0b7a55;
            font-weight: 700;
        }

        .timeline-box {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: min(620px, calc(100vw - 40px));
            max-height: 76vh;
            overflow-y: auto;
            border: 1px solid #e4e7ec;
            border-radius: 8px;
            background: #fff;
            padding: 24px;
            box-shadow: 0 24px 60px rgba(16, 24, 40, 0.24);
            z-index: 1000;
        }

        .timeline-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding-bottom: 16px;
            border-bottom: 1px solid #e4e7ec;
        }

        .timeline-header h2 {
            margin: 0;
            font-size: 22px;
        }

        .timeline-item {
            border-left: 3px solid #0b7a55;
            padding-left: 14px;
            margin-top: 18px;
        }

        .timeline-item strong {
            font-size: 17px;
        }

        .timeline-item p {
            margin: 8px 0 0;
            color: #475467;
        }

        @media (max-width: 900px) {
            .staff-header-inner,
            .staff-layout {
                padding-left: 20px;
                padding-right: 20px;
            }

            .staff-layout {
                flex-direction: column;
            }

            .staff-sidebar {
                width: 100%;
                flex-basis: auto;
            }

            .detail-header,
            .panel-header {
                flex-direction: column;
            }

            .status-form {
                width: 100%;
                flex-wrap: wrap;
            }

            .status-reason {
                flex-basis: 100%;
            }
        }
    </style>
</head>

<body>

<header class="staff-topbar">
    <div class="staff-header-inner">
        <div class="header-left">
            <a class="staff-logo" href="<%= request.getContextPath() %>/staff/dashboard">
                <img src="<%= request.getContextPath() %>/assets/images/logo.svg" alt="서경대학교">
            </a>
            <nav class="header-nav">
                <a href="<%= request.getContextPath() %>/complaints">민원 목록</a>
                <% if ("ADMIN".equals(userRole)) { %>
                    <a href="<%= request.getContextPath() %>/staff/complaints">부서별 민원 목록</a>
                    <a href="<%= request.getContextPath() %>/admin/dashboard">관리자 대시보드</a>
                <% } else if ("STAFF".equals(userRole)) { %>
                    <a href="<%= request.getContextPath() %>/staff/dashboard">담당자 대시보드</a>
                <% } %>
            </nav>
        </div>
        <div class="login-area">
            <% if (session.getAttribute("loginUser") == null) { %>
                <a href="<%= request.getContextPath() %>/user/login">로그인</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/user/mypage">마이페이지</a>
                <a href="<%= request.getContextPath() %>/user/logout">로그아웃</a>
            <% } %>
        </div>
    </div>
</header>

<main class="staff-layout">
    <aside class="staff-sidebar">
        <div class="side-section">
            <button type="button" class="side-toggle">담당자 메뉴</button>
            <div class="side-links">
                <a href="<%= request.getContextPath() %>/staff/dashboard">메인</a>
                <a href="<%= request.getContextPath() %>/staff/complaints?quickFilter=pending">처리 대기 민원</a>
                <a href="<%= request.getContextPath() %>/staff/complaints?quickFilter=recent">최근 접수된 민원</a>
            </div>
        </div>
    </aside>

    <section class="staff-content">
        <% if (complaint == null) { %>
            <div class="empty-answer">민원 정보를 불러올 수 없습니다.</div>
        <% } else { %>
            <section class="detail-header">
                <div class="detail-title-area">
                    <h1><%= complaint.getTitle() %></h1>
                    <p class="post-meta">
                        <strong><%= complaint.getWriterName() %></strong>
                        <span>·</span>
                        <span><%= complaint.getDepartmentName() %></span>
                        <span>·</span>
                        <span><%= complaint.getCategory() %></span>
                        <span>·</span>
                        <span><%= dateText(complaint.getCreatedAt()) %></span>
                        <span class="status-pill" id="currentStatusText"><%= statusText(complaint.getStatus()) %></span>
                    </p>
                </div>
                <div class="detail-action-area">
                    <button type="button" class="button secondary" id="timelineButton">타임라인</button>
                </div>
            </section>

            <section class="content-section">
                <div class="content-box"><%= complaint.getContent() %></div>
            </section>

            <section class="staff-panel">
                <div class="panel-header">
                    <h2>담당자 답변</h2>
                </div>

                <% if (answer == null && canManageComplaint) { %>
                    <form id="answerCreateForm" action="<%= request.getContextPath() %>/staff/answer" method="post">
                        <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
                        <textarea name="content" required placeholder="답변 내용을 입력하세요."></textarea>
                    </form>
                <% } else if (answer != null) { %>
                    <p class="answer-meta">
                        답변 담당자 <strong><%= answer.getStaffName() %></strong> · 작성일 <%= dateText(answer.getCreatedAt()) %>
                    </p>

                    <% if (canManageAnswer) { %>
                        <form id="answerUpdateForm" action="<%= request.getContextPath() %>/staff/answer/update" method="post">
                            <input type="hidden" name="answerId" value="<%= answer.getAnswerId() %>">
                            <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
                            <textarea name="content" required><%= answer.getContent() %></textarea>
                        </form>

                        <form id="answerDeleteForm"
                              action="<%= request.getContextPath() %>/staff/answer/delete"
                              method="post"
                              onsubmit="return confirm('정말 답변을 삭제하시겠습니까?');">
                            <input type="hidden" name="answerId" value="<%= answer.getAnswerId() %>">
                            <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
                        </form>
                    <% } else { %>
                        <div class="content-box"><%= answer.getContent() %></div>
                    <% } %>
                <% } %>

                <% if (canManageComplaint) { %>
                <form class="status-form" id="statusForm" action="<%= request.getContextPath() %>/staff/status" method="post">
                    <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
                    <input class="status-reason"
                           type="text"
                           name="reason"
                           id="statusReason"
                           placeholder="상태 변경 사유를 입력하세요.">
                    <select name="status" id="statusSelect" aria-label="민원 상태">
                        <option value="RECEIVED" <%= "RECEIVED".equals(complaint.getStatus()) ? "selected" : "" %>>접수</option>
                        <option value="REVIEWING" <%= "REVIEWING".equals(complaint.getStatus()) ? "selected" : "" %>>검토중</option>
                        <option value="PROCESSING" <%= "PROCESSING".equals(complaint.getStatus()) ? "selected" : "" %>>처리중</option>
                        <option value="COMPLETED" <%= "COMPLETED".equals(complaint.getStatus()) ? "selected" : "" %>>완료</option>
                        <option value="REJECTED" <%= "REJECTED".equals(complaint.getStatus()) ? "selected" : "" %>>반려</option>
                    </select>
                    <div class="status-control">
                        <button type="submit" class="button primary" id="statusButton">상태 변경</button>
                        <span class="status-message" id="statusMessage"></span>
                    </div>
                </form>
                <% } %>

                <div class="answer-actions">
                    <% if (answer == null && canManageComplaint) { %>
                        <button type="submit" class="button primary" form="answerCreateForm">답변 등록</button>
                    <% } else if (answer != null && canManageAnswer) { %>
                        <button type="submit" class="button primary" form="answerUpdateForm">답변 수정</button>
                        <button type="submit" class="button danger" form="answerDeleteForm">답변 삭제</button>
                    <% } %>
                </div>
            </section>

            <div id="timelineBox" class="timeline-box">
                <div class="timeline-header">
                    <h2>상태이력 타임라인</h2>
                    <button type="button" class="button secondary" id="timelineCloseButton">닫기</button>
                </div>

                <% if (statusHistories == null || statusHistories.isEmpty()) { %>
                    <p style="color: #667085;">상태 변경 이력이 없습니다.</p>
                <% } else { %>
                    <% for (StatusHistoryDTO history : statusHistories) { %>
                        <%
                            String prevStatusText = statusText(history.getPrevStatus());
                            String newStatusText = statusText(history.getNewStatus());
                        %>
                        <div class="timeline-item">
                            <strong><%= prevStatusText %> → <%= newStatusText %></strong>
                            <p>변경자: <%= history.getChangedByName() %></p>
                            <p>변경일: <%= dateText(history.getCreatedAt()) %></p>
                            <% if (history.getReason() != null && !history.getReason().isBlank()) { %>
                                <p>사유: <%= history.getReason() %></p>
                            <% } %>
                        </div>
                    <% } %>
                <% } %>
            </div>
        <% } %>

        <a class="bottom-link" href="<%= request.getContextPath() %>/staff/complaints">목록으로</a>
    </section>
</main>

<script>
    document.querySelectorAll(".side-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            button.closest(".side-section").classList.toggle("collapsed");
        });
    });

    const statusForm = document.getElementById("statusForm");
    const statusButton = document.getElementById("statusButton");
    const statusSelect = document.getElementById("statusSelect");
    const statusReason = document.getElementById("statusReason");
    const statusMessage = document.getElementById("statusMessage");
    const currentStatusText = document.getElementById("currentStatusText");
    let statusMessageTimer = null;

    function clearStatusMessageLater() {
        if (statusMessageTimer) {
            clearTimeout(statusMessageTimer);
        }

        statusMessageTimer = setTimeout(function () {
            statusMessage.textContent = "";
            statusMessage.classList.remove("error");
        }, 3000);
    }

    if (statusForm) {
        statusForm.addEventListener("submit", async function (event) {
            event.preventDefault();

            if (statusMessageTimer) {
                clearTimeout(statusMessageTimer);
            }

            statusButton.disabled = true;
            statusMessage.classList.remove("error");
            statusMessage.textContent = "변경 중...";

            try {
                const body = new URLSearchParams(new FormData(statusForm));
                const response = await fetch(statusForm.action, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body
                });

                if (!response.ok) {
                    throw new Error("request failed");
                }

                const data = await response.json();

                if (data.result === "success") {
                    currentStatusText.textContent = data.statusText;
                    statusSelect.value = data.status;
                    statusReason.value = "";
                    statusMessage.textContent = "변경 완료";
                    clearStatusMessageLater();
                    return;
                }

                throw new Error("invalid result");
            } catch (error) {
                statusMessage.classList.add("error");
                statusMessage.textContent = "변경 실패";
                clearStatusMessageLater();
            } finally {
                statusButton.disabled = false;
            }
        });
    }

    const timelineButton = document.getElementById("timelineButton");
    const timelineCloseButton = document.getElementById("timelineCloseButton");
    const timelineBox = document.getElementById("timelineBox");

    if (timelineButton && timelineBox) {
        timelineButton.addEventListener("click", function () {
            timelineBox.style.display = "block";
        });
    }

    if (timelineCloseButton && timelineBox) {
        timelineCloseButton.addEventListener("click", function () {
            timelineBox.style.display = "none";
        });
    }
</script>

</body>
</html>
