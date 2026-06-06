<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <title>회원가입</title>
    <script>
    function sendEmailAuth() {
        // 사용자가 입력한 이메일 ID 값을 가져옵니다.
        var emailId = document.getElementsByName("id")[0].value;
        
        if(!emailId || emailId.trim() === "") {
            alert("이메일 아이디를 입력해주세요.");
            return;
        }
        
        alert("인증번호를 발송 중입니다. 잠시만 기다려주세요...");
        
        // 비동기(Ajax) 방식으로 새로 만든 자바 파일(/user/sendEmail.do)에 데이터를 보냅니다.
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "${pageContext.request.contextPath}/user/sendEmail.do", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var result = xhr.responseText.trim();
                if(result === "success") {
                    alert("이메일로 인증번호가 성공적으로 발송되었습니다. 인증번호를 입력해주세요.");
                } else {
                    alert("메일 발송에 실패했습니다. 이메일을 다시 확인해주세요.");
                }
            }
        };
        
        xhr.send("id=" + encodeURIComponent(emailId));
    }
    </script>
</head>
<body>
<div style="text-align: center; margin-top: 50px;">
    
    <div>
        <h1>회원가입</h1>
        <p>Register</p>
    </div>

    <div style="display: inline-block; text-align: left; width: 440px; border: 1px solid #ccc; padding: 20px; border-radius: 8px; background-color: #f9f9f9;">
        <h3 style="text-align: center;">Create an account</h3>
        
        <form action="registerAction.do" method="post">
            <table style="width: 100%; text-align: left;">
                
                <tr>
                    <td style="width: 80px; font-weight: bold; padding: 5px 0;"><label>이름</label></td>
                    <td><input type="text" name="userId" required autofocus style="width: 100%; padding: 5px;"></td>
                </tr>
				
                <tr>
                    <td style="font-weight: bold; padding: 5px 0;"><label>이메일</label></td>
                    <td>
                        <input type="text" name="id" style="width: 110px; padding: 5px;"> @skuniv.ac.kr 
                        <input type="button" value="인증번호발송" onclick="sendEmailAuth()" style="padding: 5px 10px; margin-left: 5px; cursor: pointer;">
                    </td>
                </tr>
                
                <tr>
                    <td style="font-weight: bold; padding: 5px 0;"><label>비밀번호</label></td>
                    <td><input type="password" name="passwd" required style="width: 100%; padding: 5px;"></td>
                </tr>
				
				<tr>
				    <td style="font-weight: bold; padding: 5px 0;"><label>학년</label></td>
				    <td>
				        <select name="userGrade" style="width: 100%; padding: 5px;">
				            <option value="1">1학년</option>
				            <option value="2">2학년</option>
				            <option value="3">3학년</option>
				            <option value="4">4학년</option>
				        </select>
				    </td>
				</tr>
				
				<tr>
				    <td style="font-weight: bold; padding: 5px 0;"><label>학과</label></td>
				    <td><input type="text" name="userDept" required style="width: 100%; padding: 5px;" placeholder="예: 컴퓨터공학과"></td>
				</tr>
				
                <tr>
                    <td style="font-weight: bold; padding: 5px 0;"><label>인증번호</label></td>
                    <td>
                        <input type="text" name="verifynumber" style="width: 100%; padding: 5px;">
                    </td>
                </tr>
                
                <tr>
                    <td colspan="2" style="text-align: center; padding-top: 20px;">
                        <button type="submit" style="width: 100%; padding: 10px; background-color: #198754; color: white; border: none; cursor: pointer; font-weight: bold; border-radius: 4px;">
                            가입하기
                        </button>
                    </td>
                </tr>
                
            </table>
        </form>
    </div>

    <br><br>
    <a href="${pageContext.request.contextPath}/user/login.do" style="color: #0d6efd; text-decoration: none;">이미 계정이 있으신가요? 로그인</a>

</div>
</body>
</html>