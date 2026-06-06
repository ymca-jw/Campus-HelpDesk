<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <title>홈 화면</title>
</head>
<body style="text-align: center; margin-top: 100px;">

    <h1>🏛️ 메인 홈 화면</h1>
    <br><br>
    
    <a href="${pageContext.request.contextPath}/user/login.do" style="padding: 10px; background-color: blue; color: white; text-decoration: none;">로그인하러 가기</a>
    &nbsp;&nbsp;
    <a href="${pageContext.request.contextPath}/user/register.do" style="padding: 10px; background-color: gray; color: white; text-decoration: none;">회원가입하러 가기</a>

</body>
</html>