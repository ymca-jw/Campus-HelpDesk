<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>민원 작성/수정</title>
</head>
<body>
    <h2>민원 ${empty basket.complaintId ? '접수' : '수정'}</h2>

    <form id="complaintForm" action="${pageContext.request.contextPath}/complaints/${empty basket.complaintId ? 'check' : 'update'}" method="post">
        
        <input type="hidden" name="complaintId" value="${basket.complaintId}">
        <input type="hidden" name="savedFileName" value="${basket.attachedFile}">

        <table border="1">
            <tr>
                <th>문의 구분</th>
                <td>
                    <label><input type="radio" name="category" value="ADMIN" onclick="changeDeptList('ADMIN')" ${empty basket.category or basket.category == 'ADMIN' ? 'checked' : ''}> 행정부서</label>
                    <label><input type="radio" name="category" value="MAJOR" onclick="changeDeptList('MAJOR')" ${basket.category == 'MAJOR' ? 'checked' : ''}> 학과</label>
                </td>
            </tr>
            <tr>
                <th>담당 부서/학과</th>
                <td>
                    <select name="departmentId" id="deptSelect" required>
                        <option value="">부서/학과를 선택해주세요</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>상세 카테고리</th>
                <td>
                    <select name="category" required style="width: 100%;">
                        <option value="">-- 카테고리를 선택하세요 --</option>
                        <option value="전산" ${basket.category == '전산' ? 'selected' : ''}>전산</option>
                        <option value="시설" ${basket.category == '시설' ? 'selected' : ''}>시설</option>
                        <option value="교무학적" ${basket.category == '교무학적' ? 'selected' : ''}>교무학적</option>
                        <option value="장학" ${basket.category == '장학' ? 'selected' : ''}>장학</option>
                        <option value="학생지원" ${basket.category == '학생지원' ? 'selected' : ''}>학생지원</option>
                        <option value="수업" ${basket.category == '수업' ? 'selected' : ''}>수업</option>
                        <option value="상담" ${basket.category == '상담' ? 'selected' : ''}>상담</option>
                        <option value="취업" ${basket.category == '취업' ? 'selected' : ''}>취업</option>
                        <option value="인권" ${basket.category == '인권' ? 'selected' : ''}>인권</option>
                        <option value="기타" ${basket.category == '기타' ? 'selected' : ''}>기타</option>
                    </select>
                </td>
            </tr>
             <tr>
                <th>제목</th>
                <td><input type="text" name="title" value="${basket.title}" required style="width: 100%;"></td>
            </tr>
            <tr>
                <th>공개 여부</th>
                <td>
                    <label><input type="radio" name="isPrivate" value="false" ${!basket.privateFlag ? 'checked' : ''}> 공개</label>
                    <label><input type="radio" name="isPrivate" value="true" ${basket.privateFlag ? 'checked' : ''}> 비공개</label>
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td><textarea name="content" rows="10" required style="width: 100%;">${basket.content}</textarea></td>
            </tr>
            
            <!--<tr>
                <th>첨부파일</th>
                <td>
                    <c:if test="${not empty basket.attachedFile}">
                        <span style="color: blue;">[현재 파일: ${basket.attachedFile}]</span><br>
                    </c:if>
                    <c:if test="${not showSimbox}">
                        <input type="file" name="attachedFile">
                    </c:if>
                </td>
            </tr>-->
        </table>

        <c:if test="${showSimbox}">
            <div style="border: 2px solid red; padding: 15px; margin-top: 20px;">
                <h3 style="color: red;">유사한 민원이 있습니다</h3>
                <ul>
                    <c:forEach var="faq" items="${similarFaqs}">
                        <li><strong>Q. ${faq.question}</strong><br>A. ${faq.answer}</li>
                    </c:forEach>
                </ul>
                <hr>
                <button type="button" onclick="submitFinal()">그래도 제출하기</button>
            </div>
        </c:if>

        <div style="margin-top: 15px;">
            <button type="button" onclick="history.back()">취소</button>
            <c:if test="${not showSimbox}">
                <button type="submit">${empty basket.complaintId ? '등록 (유사민원 확인)' : '수정 완료'}</button>
            </c:if>
        </div>
    </form>

    <script>
        const allDepts = [
            <c:forEach var="d" items="${departments}">
                { id: '${d.departmentId}', name: '${d.name}', type: '${d.type}' },
            </c:forEach>
        ];

        function changeDeptList(categoryType) {
            const select = document.getElementById('deptSelect');
            select.innerHTML = '<option value="">부서/학과를 선택해주세요</option>';
            const selectedValue = '${basket.departmentId}';

            allDepts.forEach(function(dept) {
                if (dept.type === categoryType) {
                    const option = document.createElement('option');
                    option.value = dept.id;
                    option.textContent = dept.name;
                    if (dept.id === selectedValue) option.selected = true;
                    select.appendChild(option);
                }
            });
        }

        function submitFinal() {
            const form = document.getElementById('complaintForm');
            form.action = '${pageContext.request.contextPath}/complaints/create';
            form.submit();
        }

        window.onload = function() {
            const checkedRadio = document.querySelector('input[name="category"]:checked');
            if(checkedRadio) changeDeptList(checkedRadio.value);
        };
    </script>
</body>
</html>