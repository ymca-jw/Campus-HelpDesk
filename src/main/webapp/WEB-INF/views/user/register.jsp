<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="icon" type="image/svg+xml" href="<%= request.getContextPath() %>/assets/images/leaf_logo.svg">
    <style>
        body {
            margin: 0;
            font-family: Arial, "Noto Sans KR", sans-serif;
            color: #101828;
            background: #fff;
        }
        .auth-page {
            width: min(560px, calc(100% - 40px));
            margin: 64px auto;
        }
        h1 {
            margin: 0 0 12px;
            font-size: 42px;
        }
        p {
            margin: 0 0 30px;
            color: #475467;
        }
        .auth-box {
            border: 1px solid #e4e7ec;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 14px 30px rgba(16, 24, 40, 0.06);
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 700;
        }
        input {
            width: 100%;
            box-sizing: border-box;
            padding: 14px 16px;
            border: 1px solid #d0d5dd;
            border-radius: 8px;
            font-size: 16px;
        }
        .field {
            margin-bottom: 18px;
        }
        .hint {
            margin-top: 8px;
            color: #667085;
            font-size: 14px;
        }
        .rules {
            display: grid;
            gap: 7px;
            margin-top: 10px;
            color: #98a2b3;
            font-size: 14px;
        }
        .rule {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .rule .mark {
            width: 18px;
            height: 18px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #d0d5dd;
            color: transparent;
            font-size: 12px;
            font-weight: 800;
        }
        .rule.valid {
            color: #027a48;
        }
        .rule.valid .mark {
            border-color: #12b76a;
            background: #ecfdf3;
            color: #027a48;
        }
        .btn {
            width: 100%;
            padding: 14px 18px;
            border: 0;
            border-radius: 8px;
            background: #008060;
            color: #fff;
            font-weight: 700;
            font-size: 16px;
            cursor: pointer;
        }
        .links {
            display: flex;
            justify-content: space-between;
            margin-top: 18px;
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
            background: #fef3f2;
            color: #b42318;
            font-weight: 700;
        }
    </style>
</head>
<body>
<% if (request.getAttribute("alertMessage") != null) { %>
<script>
    alert("<%= request.getAttribute("alertMessage") %>");
</script>
<% } %>

<main class="auth-page">
    <h1>회원가입</h1>
    <p>서경대학교 이메일 계정으로 학생 계정을 생성합니다.</p>

    <section class="auth-box">
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <form id="registerForm" action="<%= request.getContextPath() %>/user/register" method="post">
            <div class="field">
                <label for="loginId">학교 이메일</label>
                <input id="loginId" name="loginId" type="email" value="${loginId}" required autofocus placeholder="example@skuniv.ac.kr">
                <div class="hint">서경대학교 이메일(@skuniv.ac.kr)만 가입할 수 있습니다.</div>
            </div>
            <div class="field">
                <label for="name">이름</label>
                <input id="name" name="name" type="text" value="${name}" required>
            </div>
            <div class="field">
                <label for="password">비밀번호</label>
                <input id="password" name="password" type="password" required autocomplete="new-password">
                <div class="rules" aria-live="polite">
                    <div class="rule" id="ruleLength"><span class="mark">✓</span>8자 이상</div>
                    <div class="rule" id="ruleLetter"><span class="mark">✓</span>영문 1개 이상</div>
                    <div class="rule" id="ruleDigit"><span class="mark">✓</span>숫자 1개 이상</div>
                    <div class="rule" id="ruleSpecial"><span class="mark">✓</span>특수문자 1개 이상</div>
                </div>
            </div>
            <button class="btn" type="submit">회원가입</button>
        </form>

        <div class="links">
            <a href="<%= request.getContextPath() %>/user/login">로그인</a>
        </div>
    </section>
</main>

<script>
    const registerForm = document.getElementById("registerForm");
    const loginId = document.getElementById("loginId");
    const password = document.getElementById("password");
    const rules = {
        length: document.getElementById("ruleLength"),
        letter: document.getElementById("ruleLetter"),
        digit: document.getElementById("ruleDigit"),
        special: document.getElementById("ruleSpecial")
    };

    function setRule(element, valid) {
        element.classList.toggle("valid", valid);
    }

    function validatePassword() {
        const value = password.value;
        const result = {
            length: value.length >= 8,
            letter: /[A-Za-z]/.test(value),
            digit: /\d/.test(value),
            special: /[^A-Za-z0-9]/.test(value)
        };

        setRule(rules.length, result.length);
        setRule(rules.letter, result.letter);
        setRule(rules.digit, result.digit);
        setRule(rules.special, result.special);

        return result.length && result.letter && result.digit && result.special;
    }

    password.addEventListener("input", validatePassword);

    registerForm.addEventListener("submit", function (event) {
        const email = loginId.value.trim().toLowerCase();
        if (!email.endsWith("@skuniv.ac.kr")) {
            event.preventDefault();
            alert("인증된 학교 계정만 가입 가능합니다.");
            loginId.focus();
            return;
        }

        if (!validatePassword()) {
            event.preventDefault();
            alert("비밀번호 규칙을 모두 만족해야 합니다.");
            password.focus();
        }
    });

    validatePassword();
</script>
</body>
</html>
