<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>새 민원 작성</title>
</head>
<body>

    <h2>새 민원 작성</h2>

    <form action="/complaint/insert.do" method="post">
        
        <table border="1">
            <tr>
                <th>담당 부서</th>
                <td>
                    <select name="deptCode" required>
                        <option value="">부서를 선택해주세요</option>
                        
                        <c:forEach var="dept" items="${departmentList}">
                            <option value="${dept.departmentCode}">${dept.name}</option>
                        </c:forEach>
                        </select>
                </td>
            </tr>
            <tr>
                <th>제목</th>
                <td>
                    <input type="text" name="title" required style="width: 100%;" placeholder="민원 제목을 입력하세요">
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                    <textarea name="content" rows="10" style="width: 100%;" required placeholder="민원 상세 내용을 입력하세요"></textarea>
                </td>
            </tr>
        </table>

        <div style="margin-top: 10px;">
            <button type="submit">등록하기</button>
            <button type="button" onclick="history.back()">취소</button>
        </div>
    </form>

</body>
</html>