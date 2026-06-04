<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>서버 오류</title>
    <style>
        body { margin: 0; color: #101828; font-family: Arial, "Noto Sans KR", sans-serif; }
        a { color: inherit; text-decoration: none; }
        .site-header { border-bottom: 1px solid #e5e7eb; background: #fff; }
        .header-inner { display: flex; align-items: center; justify-content: space-between; max-width: 1280px; height: 82px; margin: 0 auto; padding: 0 40px; }
        .brand img { display: block; width: 180px; max-height: 52px; object-fit: contain; }
        .page { max-width: 920px; margin: 0 auto; padding: 80px 40px; }
        .error-box { border-top: 2px solid #667085; padding-top: 34px; }
        .status { color: #0b7a55; font-size: 18px; font-weight: 700; }
        h1 { margin: 14px 0 0; font-size: 42px; letter-spacing: 0; }
        p { margin: 18px 0 0; color: #667085; font-size: 17px; line-height: 1.7; }
        .actions { display: flex; gap: 10px; margin-top: 30px; }
        .button { display: inline-flex; align-items: center; justify-content: center; height: 44px; border-radius: 8px; padding: 0 18px; font-weight: 700; }
        .primary { background: #0b7a55; color: #fff; }
        .secondary { border: 1px solid #d0d5dd; color: #475467; }
    </style>
</head>
<body>
<header class="site-header"><div class="header-inner"><a class="brand" href="${pageContext.request.contextPath}/complaints"><img src="${pageContext.request.contextPath}/assets/images/logo.svg" alt="학교 로고"></a></div></header>
<main class="page"><section class="error-box">
    <div class="status">500 INTERNAL_SERVER_ERROR</div>
    <h1>서버 처리 중 오류가 발생했습니다.</h1>
    <p>요청을 처리하는 중 문제가 발생했습니다. 잠시 후 다시 시도해 주세요.</p>
    <div class="actions"><a class="button primary" href="${pageContext.request.contextPath}/complaints">민원 목록</a><a class="button secondary" href="javascript:history.back()">이전 페이지</a></div>
</section></main>
</body>
</html>
