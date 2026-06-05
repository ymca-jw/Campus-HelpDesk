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
            gap: 58px;
        }

        .brand img {
            display: block;
            width: 180px;
            max-height: 52px;
            object-fit: contain;
        }

        .main-nav {
            display: flex;
            align-items: center;
            gap: 36px;
            font-size: 18px;
            font-weight: 700;
        }

        .main-nav a {
            padding: 30px 0;
        }

        .main-nav a.active {
            color: #007a4d;
        }

        .auth-nav {
            display: flex;
            align-items: center;
            gap: 16px;
            color: #475467;
            font-size: 14px;
        }

        .page {
            max-width: 1120px;
            margin: 0 auto;
            padding: 54px 40px 80px;
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

        .detail-header p {
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

        .like-area {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            margin: 38px 0;
            padding: 24px 0;
        }

        .like-count {
            color: #344054;
            font-size: 18px;
            font-weight: 700;
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

            .main-nav {
                gap: 18px;
                font-size: 16px;
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

            <nav class="main-nav">
                <a class="active" href="${pageContext.request.contextPath}/complaints">민원 목록</a>
                <a href="${pageContext.request.contextPath}/complaints/new">민원 작성</a>
            </nav>
        </div>

        <div class="auth-nav">
            <a href="#">로그인</a>
            <a href="#">마이페이지</a>
            <a href="#">로그아웃</a>
        </div>
    </div>
</header>

<main class="page">
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
                    <span class="status-pill"><%= statusText(complaint.getStatus()) %></span>
                </p>
            </div>
            <div class="detail-action-area">
                <button type="button" class="button secondary" id="timelineButton">타임라인</button>
            </div>
        </section>

        <section class="content-section">
            <div class="content-box"><%= complaint.getContent() %></div>
        </section>

        <section class="like-area">
            <div class="like-count">추천 수 <span id="likeCount"><%= complaint.getLikeCount() %></span></div>
            <form id="likeForm" action="<%= request.getContextPath() %>/complaints/like" method="post">
                <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
                <button class="button primary" id="likeButton" type="submit" data-liked="<%= likedByMe %>">
                    <%= likedByMe ? "추천 완료" : "추천" %>
                </button>
            </form>
            <p id="likeMessage"></p>
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
</main>

<script>
    const likeForm = document.getElementById("likeForm");
    const likeButton = document.getElementById("likeButton");
    const likeCount = document.getElementById("likeCount");
    const likeMessage = document.getElementById("likeMessage");

    if (likeForm) {
        likeForm.addEventListener("submit", async function (event) {
            event.preventDefault();

            if (likeButton.dataset.liked === "true") {
                alert("이미 추천한 민원입니다.");
                return;
            }

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

                if (data.result === "success" || data.result === "duplicate") {
                    likeCount.textContent = data.likeCount;
                    likeButton.textContent = "이미 추천함";
                    likeButton.dataset.liked = "true";
                    likeButton.disabled = false;

                    if (data.result === "duplicate") {
                        alert("이미 추천한 민원입니다.");
                    }
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
