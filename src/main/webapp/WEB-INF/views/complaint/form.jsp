<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>민원 작성</title>
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
        }

        .brand img {
            display: block;
            width: 180px;
            max-height: 52px;
            object-fit: contain;
        }

        .auth-nav {
            display: flex;
            align-items: center;
            gap: 16px;
            color: #475467;
            font-size: 14px;
        }

        .page {
            max-width: 1280px;
            margin: 0 auto;
            padding: 54px 40px 80px;
        }

        .page-layout {
            display: flex;
            align-items: flex-start;
            gap: 36px;
        }

        .complaint-sidebar {
            flex: 0 0 240px;
        }

        .page-content {
            flex: 1;
            min-width: 0;
        }

        .side-section {
            margin-bottom: 18px;
        }

        .side-toggle {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            border: 0;
            border-bottom: 1px solid #e5e7eb;
            background: transparent;
            cursor: pointer;
            color: #111827;
            font-size: 18px;
            font-weight: 700;
            padding: 14px 10px;
            text-align: left;
        }

        .side-toggle::after {
            content: "⌄";
            color: #6b7280;
            font-size: 18px;
            transition: transform 0.2s ease;
        }

        .side-section.collapsed .side-toggle::after {
            transform: rotate(-90deg);
        }

        .side-links {
            overflow: hidden;
            max-height: 220px;
            padding: 12px 0 8px 16px;
            border-left: 1px solid #d1d5db;
            margin-left: 10px;
            transition: max-height 0.28s ease, padding-top 0.28s ease, padding-bottom 0.28s ease;
        }

        .side-section.collapsed .side-links {
            max-height: 0;
            padding-top: 0;
            padding-bottom: 0;
        }

        .side-links a {
            display: block;
            padding: 10px 12px;
            color: #111827;
            text-decoration: none;
        }

        .side-links a.active {
            color: #007a5a;
            font-weight: 700;
            border-left: 2px solid #007a5a;
            margin-left: -17px;
            padding-left: 27px;
        }

        .page-title {
            margin-bottom: 34px;
            padding-bottom: 24px;
            border-bottom: 2px solid #667085;
        }

        .page-title h1 {
            margin: 0;
            font-size: 44px;
            line-height: 1.2;
            letter-spacing: 0;
        }

        .page-title p {
            margin: 14px 0 0;
            color: #667085;
            font-size: 18px;
        }

        .form-panel {
            border: 1px solid #edf0f4;
            border-radius: 8px;
            background: #f8fafc;
            padding: 26px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
        }

        .field {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        .field label,
        .field-label {
            color: #344054;
            font-size: 14px;
            font-weight: 700;
        }

        .radio-group {
            display: flex;
            gap: 10px;
            min-height: 48px;
            align-items: center;
        }

        .radio-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            height: 42px;
            border: 1px solid #d0d5dd;
            border-radius: 8px;
            padding: 0 14px;
            background: #fff;
            color: #344054;
            cursor: pointer;
        }

        input[type="text"],
        select,
        textarea {
            width: 100%;
            border: 0;
            border-radius: 8px;
            background: #fff;
            color: #344054;
            font-family: inherit;
            font-size: 15px;
            outline: none;
        }

        input[type="text"],
        select {
            height: 48px;
            padding: 0 14px;
        }

        textarea {
            min-height: 220px;
            resize: vertical;
            padding: 14px;
            line-height: 1.6;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 24px;
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 46px;
            border-radius: 8px;
            padding: 0 20px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
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

        .modal-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(16, 24, 40, 0.45);
            z-index: 999;
        }

        .similar-modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: min(760px, calc(100vw - 40px));
            max-height: 82vh;
            overflow-y: auto;
            border: 1px solid #e4e7ec;
            border-radius: 8px;
            background: #fff;
            padding: 26px;
            z-index: 1000;
            box-shadow: 0 24px 60px rgba(16, 24, 40, 0.24);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            padding-bottom: 18px;
            border-bottom: 1px solid #e4e7ec;
        }

        .modal-header h2 {
            margin: 0;
            font-size: 24px;
        }

        .modal-header p {
            margin: 8px 0 0;
            color: #667085;
            line-height: 1.5;
        }

        .similar-section {
            margin-top: 22px;
        }

        .similar-section h3 {
            margin: 0 0 12px;
            font-size: 18px;
        }

        .similar-list {
            display: grid;
            gap: 10px;
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .similar-item {
            border: 1px solid #e4e7ec;
            border-radius: 8px;
            background: #fcfcfd;
            padding: 16px;
        }

        .similar-item strong {
            display: block;
            margin-bottom: 8px;
            color: #101828;
        }

        .similar-item p {
            margin: 6px 0 0;
            color: #475467;
            line-height: 1.55;
        }

        .similar-meta {
            color: #667085;
            font-size: 13px;
        }

        .empty-message {
            margin: 0;
            color: #667085;
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 24px;
            padding-top: 18px;
            border-top: 1px solid #e4e7ec;
        }

        @media (max-width: 800px) {
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

            .page-layout {
                flex-direction: column;
            }

            .complaint-sidebar {
                width: 100%;
                flex-basis: auto;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-panel {
                padding: 18px;
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

        </div>

        <div class="auth-nav">
            <a href="#">로그인</a>
            <a href="#">마이페이지</a>
            <a href="#">로그아웃</a>
        </div>
    </div>
</header>

<main class="page page-layout">
    <aside class="complaint-sidebar">
        <div class="side-section">
            <button type="button" class="side-toggle">민원 메뉴</button>
            <div class="side-links">
                <a href="${pageContext.request.contextPath}/complaints">민원 목록</a>
                <a class="active" href="${pageContext.request.contextPath}/complaints/new">민원 작성</a>
            </div>
        </div>

        <div class="side-section">
            <button type="button" class="side-toggle">내 민원</button>
            <div class="side-links">
                <a href="#">내가 작성한 민원</a>
                <a href="#">내가 추천한 민원</a>
            </div>
        </div>

        <div class="side-section">
            <button type="button" class="side-toggle">민원 상태</button>
            <div class="side-links">
                <a href="${pageContext.request.contextPath}/complaints?status=RECEIVED">접수</a>
                <a href="${pageContext.request.contextPath}/complaints?status=REVIEWING">검토중</a>
                <a href="${pageContext.request.contextPath}/complaints?status=PROCESSING">처리중</a>
                <a href="${pageContext.request.contextPath}/complaints?status=COMPLETED">완료</a>
                <a href="${pageContext.request.contextPath}/complaints?status=REJECTED">반려</a>
            </div>
        </div>
    </aside>

    <section class="page-content">
        <section class="page-title">
            <h1>${empty basket.complaintId ? '민원 작성' : '민원 수정'}</h1>
            <p>민원 내용을 작성하면 제출 전 유사한 FAQ와 기존 민원을 먼저 확인할 수 있습니다.</p>
        </section>

    <form id="complaintForm"
          class="form-panel"
          action="${pageContext.request.contextPath}/complaints/${empty basket.complaintId ? 'check' : 'update'}"
          method="post">

        <input type="hidden" name="complaintId" value="${basket.complaintId}">

        <div class="form-grid">
            <div class="field">
                <div class="field-label">문의구분</div>
                <div class="radio-group">
                    <label class="radio-pill">
                        <input type="radio"
                               name="departmentType"
                               value="ADMIN"
                               onclick="changeDeptList('ADMIN')"
                               checked>
                        행정부서
                    </label>

                    <label class="radio-pill">
                        <input type="radio"
                               name="departmentType"
                               value="MAJOR"
                               onclick="changeDeptList('MAJOR')">
                        학과
                    </label>
                </div>
            </div>

            <div class="field">
                <label for="deptSelect">담당부서</label>
                <select name="departmentId" id="deptSelect" required>
                    <option value="">담당부서를 선택하세요</option>
                </select>
            </div>

            <div class="field">
                <label for="category">카테고리</label>
                <select name="category" id="category" required>
                    <option value="">카테고리를 선택하세요</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat}" ${basket.category == cat ? 'selected' : ''}>
                            ${cat}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="field full">
                <label for="title">제목</label>
                <input type="text" id="title" name="title" value="${basket.title}" required placeholder="민원 제목을 입력하세요">
            </div>

            <div class="field full">
                <label for="content">내용</label>
                <textarea id="content" name="content" required placeholder="민원 내용을 자세히 입력하세요">${basket.content}</textarea>
            </div>

            <div class="field full">
                <div class="field-label">공개 여부</div>
                <div class="radio-group">
                    <label class="radio-pill">
                        <input type="radio" name="isPrivate" value="false" ${!basket.privateFlag ? 'checked' : ''}>
                        공개
                    </label>
                    <label class="radio-pill">
                        <input type="radio" name="isPrivate" value="true" ${basket.privateFlag ? 'checked' : ''}>
                        비공개
                    </label>
                </div>
            </div>
        </div>

        <div class="form-actions">
            <button class="button secondary" type="button" onclick="history.back()">취소</button>

            <c:if test="${not showSimilarBox}">
                <button class="button primary" type="submit" id="nextButton">
                    ${empty basket.complaintId ? '다음' : '수정 완료'}
                </button>
            </c:if>

            <c:if test="${showSimilarBox}">
                <button class="button primary" type="submit" id="nextButton" style="display: none;">다음</button>
            </c:if>
        </div>

        <c:if test="${showSimilarBox}">
            <div class="modal-backdrop"></div>
            <div class="similar-modal">
                <div class="modal-header">
                    <div>
                        <h2>유사한 FAQ와 민원을 확인해 주세요</h2>
                        <p>이미 해결된 내용이 있다면 아래 정보를 참고할 수 있습니다. 그래도 필요하면 민원을 제출하세요.</p>
                    </div>
                </div>

                <div class="similar-section">
                    <h3>추천 FAQ</h3>
                    <c:choose>
                        <c:when test="${empty similarFaqs}">
                            <p class="empty-message">추천 FAQ가 없습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <ul class="similar-list">
                                <c:forEach var="faq" items="${similarFaqs}">
                                    <li class="similar-item">
                                        <strong>Q. ${faq.question}</strong>
                                        <p>A. ${faq.answer}</p>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="similar-section">
                    <h3>유사 민원</h3>
                    <c:choose>
                        <c:when test="${empty similarComplaints}">
                            <p class="empty-message">유사한 민원이 없습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <ul class="similar-list">
                                <c:forEach var="complaint" items="${similarComplaints}">
                                    <li class="similar-item">
                                        <strong>${complaint.title}</strong>
                                        <div class="similar-meta">
                                            ${complaint.departmentName} · ${complaint.category} ·
                                            <c:choose>
                                                <c:when test="${complaint.status == 'RECEIVED'}">접수</c:when>
                                                <c:when test="${complaint.status == 'REVIEWING'}">검토중</c:when>
                                                <c:when test="${complaint.status == 'PROCESSING'}">처리중</c:when>
                                                <c:when test="${complaint.status == 'COMPLETED'}">완료</c:when>
                                                <c:when test="${complaint.status == 'REJECTED'}">반려</c:when>
                                                <c:otherwise>${complaint.status}</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <p>${complaint.content}</p>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="modal-actions">
                    <button class="button secondary" type="button" onclick="hideSimilarBox()">이전</button>
                    <button class="button primary" type="button" onclick="submitFinal()">제출</button>
                </div>
            </div>
        </c:if>
    </form>
    </section>
</main>

<script>
    document.querySelectorAll(".side-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            button.closest(".side-section").classList.toggle("collapsed");
        });
    });

    const allDepts = [
        <c:forEach var="d" items="${departments}">
        { id: '${d.departmentId}', name: '${d.name}', type: '${d.type}' },
        </c:forEach>
    ];

    const selectedDepartmentId = '${basket.departmentId}';

    function changeDeptList(departmentType) {
        const select = document.getElementById('deptSelect');

        select.innerHTML = '<option value="">담당부서를 선택하세요</option>';

        allDepts.forEach(function(dept) {
            if (dept.type === departmentType) {
                const option = document.createElement('option');

                option.value = dept.id;
                option.textContent = dept.name;

                if (dept.id === selectedDepartmentId) {
                    option.selected = true;
                }

                select.appendChild(option);
            }
        });
    }

    function submitFinal() {
        const form = document.getElementById('complaintForm');
        form.action = '${pageContext.request.contextPath}/complaints/create';
        form.submit();
    }

    function hideSimilarBox() {
        const modal = document.querySelector('.similar-modal');
        const backdrop = document.querySelector('.modal-backdrop');
        const nextButton = document.getElementById('nextButton');

        if (modal) {
            modal.style.display = 'none';
        }

        if (backdrop) {
            backdrop.style.display = 'none';
        }

        if (nextButton) {
            nextButton.style.display = 'inline-flex';
        }
    }

    window.onload = function() {
        let initialType = 'ADMIN';

        if (selectedDepartmentId) {
            const selectedDept = allDepts.find(function(dept) {
                return dept.id === selectedDepartmentId;
            });

            if (selectedDept) {
                initialType = selectedDept.type;
            }
        }

        const radio = document.querySelector('input[name="departmentType"][value="' + initialType + '"]');

        if (radio) {
            radio.checked = true;
        }

        changeDeptList(initialType);
    };
</script>

</body>
</html>
