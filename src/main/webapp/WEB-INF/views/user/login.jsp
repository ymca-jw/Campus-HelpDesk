<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Campus Helpdesk 로그인</title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, "Noto Sans KR", sans-serif;
            color: #101828;
            background: #f8fafc;
        }
        .login-shell {
            min-height: 100vh;
            display: grid;
            grid-template-columns: minmax(420px, 0.92fr) minmax(480px, 1.08fr);
        }
        .login-pane {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 56px;
            background: #fff;
        }
        .login-card {
            width: min(420px, 100%);
        }
        .brand {
            display: inline-flex;
            align-items: center;
            margin-bottom: 40px;
        }
        .brand img {
            height: 56px;
        }
        h1 {
            margin: 0 0 12px;
            font-size: 44px;
            letter-spacing: 0;
        }
        .lead {
            margin: 0 0 32px;
            color: #475467;
            font-size: 17px;
            line-height: 1.6;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 700;
        }
        input {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #d0d5dd;
            border-radius: 8px;
            font-size: 16px;
            background: #fff;
        }
        .field {
            margin-bottom: 18px;
        }
        .btn {
            width: 100%;
            padding: 15px 18px;
            border: 0;
            border-radius: 8px;
            background: #008060;
            color: #fff;
            font-weight: 800;
            font-size: 16px;
            cursor: pointer;
        }
        .links {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        a {
            color: #008060;
            text-decoration: none;
            font-weight: 700;
        }
        .message {
            margin-bottom: 16px;
            padding: 12px 14px;
            border-radius: 8px;
            background: #ecfdf3;
            color: #027a48;
            font-weight: 700;
        }
        .error {
            background: #fef3f2;
            color: #b42318;
        }
        .info-pane {
            display: flex;
            align-items: center;
            padding: 72px;
            background: #f3f7f5;
            border-left: 1px solid #e4e7ec;
        }
        .info-content {
            width: min(620px, 100%);
        }
        .eyebrow {
            margin: 0 0 16px;
            color: #008060;
            font-size: 15px;
            font-weight: 800;
        }
        .info-content h2 {
            margin: 0 0 18px;
            font-size: 46px;
            line-height: 1.18;
            letter-spacing: 0;
        }
        .info-content > p {
            margin: 0 0 34px;
            color: #475467;
            font-size: 18px;
            line-height: 1.7;
        }
        .feature-list {
            display: grid;
            gap: 14px;
        }
        .feature {
            display: grid;
            grid-template-columns: 38px 1fr;
            gap: 14px;
            align-items: start;
            padding: 18px;
            border: 1px solid #dce6df;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.72);
        }
        .icon {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #ecfdf3;
            color: #008060;
            font-weight: 900;
        }
        .feature strong {
            display: block;
            margin-bottom: 5px;
            font-size: 17px;
        }
        .feature span {
            color: #667085;
            line-height: 1.5;
        }
        @media (max-width: 980px) {
            .login-shell {
                grid-template-columns: 1fr;
            }
            .info-pane {
                padding: 42px 28px 56px;
            }
            .login-pane {
                padding: 42px 28px;
            }
            .info-content h2 {
                font-size: 34px;
            }
        }
    </style>
</head>
<body>
<main class="login-shell">
    <section class="login-pane">
        <div class="login-card">
            <a class="brand" href="<%= request.getContextPath() %>/user/login">
                <img src="<%= request.getContextPath() %>/assets/images/logo.svg" alt="서경대학교 로고">
            </a>

            <h1>로그인</h1>
            <p class="lead">학교 계정으로 접속해 민원 작성과 처리 현황을 확인합니다.</p>

            <% if (request.getParameter("registered") != null) { %>
                <div class="message">회원가입이 완료되었습니다. 로그인해 주세요.</div>
            <% } %>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="message error"><%= request.getAttribute("errorMessage") %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/user/login" method="post">
                <div class="field">
                    <label for="loginId">학교 이메일</label>
                    <input id="loginId" name="loginId" type="text" value="${loginId}" required autofocus placeholder="example@skuniv.ac.kr">
                </div>
                <div class="field">
                    <label for="password">비밀번호</label>
                    <input id="password" name="password" type="password" required>
                </div>
                <button class="btn" type="submit">로그인</button>
            </form>

            <div class="links">
                <a href="<%= request.getContextPath() %>/user/register">회원가입</a>
            </div>
        </div>
    </section>

    <section class="info-pane">
        <div class="info-content">
            <p class="eyebrow">Campus Helpdesk</p>
            <h2>학교 생활의 불편을 한 곳에서 접수하고 확인합니다.</h2>
            <p>민원 등록부터 담당 부서 답변, 상태 변경 이력까지 한 화면에서 이어지는 서경대학교 민원 처리 공간입니다.</p>

            <div class="feature-list">
                <div class="feature">
                    <div class="icon">1</div>
                    <div>
                        <strong>민원 작성과 유사 민원 확인</strong>
                        <span>작성 전 FAQ와 기존 민원을 먼저 확인해 빠르게 해결 방향을 찾습니다.</span>
                    </div>
                </div>
                <div class="feature">
                    <div class="icon">2</div>
                    <div>
                        <strong>추천과 처리 현황 확인</strong>
                        <span>공감되는 민원은 추천하고, 접수부터 완료까지 상태를 확인합니다.</span>
                    </div>
                </div>
                <div class="feature">
                    <div class="icon">3</div>
                    <div>
                        <strong>담당 부서 답변과 타임라인</strong>
                        <span>답변 내용과 상태 변경 이력을 타임라인으로 투명하게 확인합니다.</span>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>
</body>
</html>
