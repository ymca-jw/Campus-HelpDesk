<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.campus.dto.ComplaintDTO" %>
<%@ page import="com.campus.dto.AnswerDTO" %>
<%@ page import="com.campus.dto.StatusHistoryDTO" %>
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
    List<StatusHistoryDTO> statusHistories =
            (List<StatusHistoryDTO>) request.getAttribute("statusHistories");
    Boolean likedByMeAttr = (Boolean) request.getAttribute("likedByMe");
    boolean likedByMe = likedByMeAttr != null && likedByMeAttr;
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>민원 상세</title>
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

        .header-left {
            display: flex;
            align-items: center;
        }

        .brand img {
            display: block;
            width: 180px;
            max-height: 52px;
            object-fit: contain;
        }

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
            max-height: 220px;
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

        .detail-header {
            display: flex;
            position: relative;
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
            flex: 1 1 auto;
            min-width: 0;
            max-width: calc(100% - 140px);
        }

        .detail-action-area {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 14px;
            flex: 0 0 auto;
        }

        .detail-header .post-meta {
            margin: 14px 0 0;
            color: #667085;
            font-size: 16px;
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

        .button.secondary {
            border: 1px solid #d0d5dd;
            background: #fff;
            color: #475467;
        }

        .button.primary {
            border: 0;
            background: #0b7a55;
            color: #fff;
        }

        .post-meta {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px;
            color: #667085;
            font-size: 14px;
        }

        .meta-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            margin-top: 14px;
            width: 100%;
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

        .like-form {
            display: inline-flex;
            align-items: center;
            flex: 0 0 auto;
        }

        .like-stack {
            display: flex;
            position: absolute;
            right: 0;
            bottom: 24px;
            flex-direction: column;
            align-items: flex-end;
            gap: 4px;
        }

        .heart-button {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            border: 0;
            background: transparent;
            color: #475467;
            font: inherit;
            font-weight: 700;
            cursor: pointer;
            padding: 2px;
        }

        .heart-button svg {
            width: 20px;
            height: 20px;
            stroke: #98a2b3;
            stroke-width: 1.8;
            fill: transparent;
        }

        .heart-button.liked svg {
            stroke: #e11d48;
            fill: #e11d48;
        }

        .heart-button:disabled {
            cursor: default;
            opacity: 0.7;
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
        .answer-box {
            border: 1px solid #e4e7ec;
            border-radius: 8px;
            background: #fff;
            padding: 24px;
            line-height: 1.75;
            white-space: pre-wrap;
        }

        #likeMessage {
            min-height: 20px;
            margin: 0;
            color: #b42318;
            font-size: 14px;
        }

        .answer-meta {
            margin-bottom: 16px;
            color: #667085;
            font-size: 14px;
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

            .header-left {
                flex-wrap: wrap;
                gap: 20px;
            }

            .page-layout {
                flex-direction: column;
            }

            .complaint-sidebar {
                width: 100%;
                flex-basis: auto;
            }

            .detail-header {
                flex-direction: column;
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

        </div>

        <div class="auth-nav">
            <a href="#">로그인</a>
            <a href="#">마이페이지</a>
            <a href="#">로그아웃</a>
        </div>
    </div>
</header>

<main class="page page-layout">
    <aside class="complaint-sidebar">
        <div class="side-section">
            <button type="button" class="side-toggle">민원 메뉴</button>
            <div class="side-links">
                <a class="active" href="<%= request.getContextPath() %>/complaints">민원 목록</a>
                <a href="<%= request.getContextPath() %>/complaints/new">민원 작성</a>
            </div>
        </div>

        <div class="side-section">
            <button type="button" class="side-toggle">내 민원</button>
            <div class="side-links">
                <a href="#">내가 작성한 민원</a>
                <a href="#">내가 추천한 민원</a>
            </div>
        </div>

        <div class="side-section">
            <button type="button" class="side-toggle">민원 상태</button>
            <div class="side-links">
                <a href="<%= request.getContextPath() %>/complaints?status=RECEIVED">접수</a>
                <a href="<%= request.getContextPath() %>/complaints?status=REVIEWING">검토중</a>
                <a href="<%= request.getContextPath() %>/complaints?status=PROCESSING">처리중</a>
                <a href="<%= request.getContextPath() %>/complaints?status=COMPLETED">완료</a>
                <a href="<%= request.getContextPath() %>/complaints?status=REJECTED">반려</a>
            </div>
        </div>
    </aside>

    <section class="page-content">
    <% if (complaint == null) { %>
        <div class="empty-answer">민원 정보를 불러올 수 없습니다.</div>
    <% } else { %>
        <section class="detail-header">
            <div class="detail-title-area">
                <h1><%= complaint.getTitle() %></h1>
                <div class="meta-row">
                    <div class="post-meta">
                        <strong><%= complaint.getWriterName() %></strong>
                        <span>·</span>
                        <span><%= complaint.getDepartmentName() %></span>
                        <span>·</span>
                        <span><%= complaint.getCategory() %></span>
                        <span>·</span>
                        <span><%= dateText(complaint.getCreatedAt()) %></span>
                        <span class="status-pill"><%= statusText(complaint.getStatus()) %></span>
                    </div>
                </div>
            </div>
            <div class="detail-action-area">
                <button type="button" class="button secondary" id="timelineButton">타임라인</button>
                <div class="like-stack">
                    <form class="like-form" id="likeForm" action="<%= request.getContextPath() %>/complaints/like" method="post">
                        <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
                        <button class="heart-button <%= likedByMe ? "liked" : "" %>"
                                id="likeButton"
                                type="submit"
                                data-liked="<%= likedByMe %>"
                                aria-label="민원 추천">
                            <svg id="heartIcon" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M20.8 4.6c-1.9-1.8-5-1.7-6.8.1L12 6.7 10 4.7C8.2 2.9 5.1 2.8 3.2 4.6c-2 1.9-2.1 5.1-.1 7.1L12 20.3l8.9-8.6c2-2 1.9-5.2-.1-7.1z"/>
                            </svg>
                            <span id="likeCount"><%= complaint.getLikeCount() %></span>
                        </button>
                    </form>
                    <span id="likeMessage"></span>
                </div>
            </div>
        </section>

        <section class="content-section">
            <div class="content-box"><%= complaint.getContent() %></div>
        </section>

        <section class="content-section">
            <h2 class="section-title">담당자 답변</h2>

            <% if (answer == null) { %>
                <div class="empty-answer">아직 등록된 답변이 없습니다.</div>
            <% } else { %>
                <div class="answer-meta">
                    답변 담당자 <strong><%= answer.getStaffName() %></strong> · 작성일 <%= dateText(answer.getCreatedAt()) %>
                </div>
                <div class="answer-box"><%= answer.getContent() %></div>
            <% } %>
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

    <a class="bottom-link" href="<%= request.getContextPath() %>/complaints">목록으로</a>
    </section>
</main>

<script>
    document.querySelectorAll(".side-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            button.closest(".side-section").classList.toggle("collapsed");
        });
    });

    const likeForm = document.getElementById("likeForm");
    const likeButton = document.getElementById("likeButton");
    const likeCount = document.getElementById("likeCount");
    const likeMessage = document.getElementById("likeMessage");

    if (likeForm) {
        likeForm.addEventListener("submit", async function (event) {
            event.preventDefault();

            likeButton.disabled = true;
            likeMessage.textContent = "";

            try {
                const body = new URLSearchParams(new FormData(likeForm));
                const response = await fetch(likeForm.action, {
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

                if (data.result === "success" || data.result === "cancel") {
                    likeCount.textContent = data.likeCount;
                    likeButton.dataset.liked = String(data.liked);
                    likeButton.classList.toggle("liked", data.liked);
                    likeButton.disabled = false;
                    return;
                }

                likeButton.disabled = false;
                likeMessage.textContent = "추천 처리 중 오류가 발생했습니다.";
            } catch (error) {
                likeButton.disabled = false;
                likeMessage.textContent = "추천 처리 중 오류가 발생했습니다.";
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
