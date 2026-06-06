<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <title>Login</title>
</head>
<body>
<div style="text-align: center; margin-top: 50px;">
    
    <div>
        <h1>로그인</h1>
        <p>Login</p>
    </div>

    <div style="display: inline-block; text-align: left; width: 300px;">
        <h3>Please sign in</h3>
        
		<form action="login" method="post">
            <div style="margin-bottom: 10px;">
                <label>이메일</label><br>
                <input type="text" name="user_email" required autofocus style="width: 100%;">
            </div>
            
            <div style="margin-bottom: 15px;">
                <label>Password</label><br>
                <input type="password" name="password" required style="width: 100%;">
            </div>
            
            <button type="submit" style="width: 100%; padding: 10px; background-color: #198754; color: white; border: none; cursor: pointer;">
                로그인
            </button>
        </form>
    </div>

</div>
</body>
</html>