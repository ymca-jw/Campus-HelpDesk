<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <title>마이페이지</title>
</head>
<body>
<div style="text-align: center; margin-top: 50px;">
    
    <div>
        <h1>마이페이지</h1>
        <p>My Page</p>
    </div>

    <div style="display: inline-block; text-align: left; width: 460px; border: 1px solid #ccc; padding: 20px; border-radius: 8px; background-color: #f9f9f9;">
        <h3 style="text-align: center; margin-bottom: 20px;">내 계정 정보</h3>
        
        <table style="width: 100%; text-align: left; border-collapse: collapse;">
            
            <tr style="border-bottom: 1px solid #eee;">
                <td style="width: 120px; font-weight: bold; padding: 12px 0;">이름</td>
                <td style="padding: 12px 0; color: #333;">${userInfo.name}</td>
            </tr>
            
            <tr style="border-bottom: 1px solid #eee;">
                <td style="font-weight: bold; padding: 12px 0;">학년</td>
                <td style="padding: 12px 0; color: #333;">${userInfo.grade}</td>
            </tr>
            
            <tr style="border-bottom: 1px solid #eee;">
                <td style="font-weight: bold; padding: 12px 0;">학과</td>
                <td style="padding: 12px 0; color: #333;">${userInfo.dept}</td>
            </tr>
            
            <tr style="border-bottom: 1px solid #eee;">
                <td style="font-weight: bold; padding: 12px 0;">이메일 주소</td>
                <td style="padding: 12px 0; color: #0d6efd; font-weight: bold;">${userInfo.email}</td>
            </tr>
            
        </table>
        
        <div style="margin-top: 30px; text-align: center; display: flex; gap: 10px;">
            <a href="${pageContext.request.contextPath}/complaints/list.do" style="flex: 1; text-align: center; padding: 10px; background-color: #6c757d; color: white; text-decoration: none; font-weight: bold; border-radius: 4px; font-size: 14px;">
                민원 목록으로
            </a>
            <a href="${pageContext.request.contextPath}/user/logout.do" style="flex: 1; text-align: center; padding: 10px; background-color: #dc3545; color: white; text-decoration: none; font-weight: bold; border-radius: 4px; font-size: 14px;">
                로그아웃
            </a>
        </div>
    </div>

</div>
</body>
</html>