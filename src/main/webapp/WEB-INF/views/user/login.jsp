<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Campus Helpdesk 로그인</title>
    <link rel="icon" type="image/svg+xml" href="<%= request.getContextPath() %>/assets/images/leaf_logo.svg">
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }
        .login-card {
            width: 100%;
            max-width: 420px;
            background: #fff;
            padding: 48px 40px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }
        .brand {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 32px;
        }
        .brand img {
            height: 56px;
        }
        h1 {
            margin: 0 0 12px;
            font-size: 32px;
            text-align: center;
            letter-spacing: -0.5px;
        }
        .lead {
            margin: 0 0 32px;
            color: #475467;
            font-size: 15px;
            text-align: center;
            line-height: 1.5;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 700;
        }
        input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #d0d5dd;
            border-radius: 8px;
            font-size: 15px;
            background: #fff;
            transition: border-color 0.2s;
        }
        input:focus {
            outline: none;
            border-color: #008060;
        }
        .field {
            margin-bottom: 20px;
        }
        .btn {
            width: 100%;
            padding: 14px;
            border: 0;
            border-radius: 8px;
            background: #008060;
            color: #fff;
            font-weight: 700;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .btn:hover {
            background: #006b50;
        }
        .links {
            display: flex;
            justify-content: center;
            margin-top: 24px;
            font-size: 14px;
        }
        a {
            color: #008060;
            text-decoration: none;
            font-weight: 600;
        }
        a:hover {
            text-decoration: underline;
        }
        .message {
            margin-bottom: 20px;
            padding: 12px 14px;
            border-radius: 8px;
            background: #ecfdf3;
            color: #027a48;
            font-size: 14px;
            font-weight: 600;
            text-align: center;
        }
        .error {
            background: #fef3f2;
            color: #b42318;
        }
    </style>
</head>
<body>

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

</body>
</html>
