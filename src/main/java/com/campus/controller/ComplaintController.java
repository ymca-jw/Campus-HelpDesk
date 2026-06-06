package com.campus.controller;

import com.campus.dao.DepartmentDAO;
import com.campus.dto.AnswerDTO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.DepartmentDTO;
import com.campus.dto.FaqDTO;
import com.campus.dto.StatusHistoryDTO;
import com.campus.service.AnswerService;
import com.campus.service.ComplaintCheckService;
import com.campus.service.ComplaintService;
import com.campus.service.DepartmentService;
import com.campus.util.CategoryConstants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet({"/complaints", "/complaints/detail", "/complaints/new", "/complaints/check", "/complaints/update",
"/complaints/create", "/complaints/edit", "/complaints/delete", "/complaints/like", "/complaints/faq-test"})
public class ComplaintController extends HttpServlet {
    private final ComplaintService complaintService = new ComplaintService();
    private final ComplaintCheckService complaintCheckService = new ComplaintCheckService();
    private final DepartmentService departmentService = new DepartmentService();
    private final AnswerService answerService = new AnswerService();

    // GET 요청은 여기서 처리
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String uri = req.getRequestURI();   // uri = /Campus-HelpDesk/complaints/detail
        String contextPath = req.getContextPath();      // contextPath = /Campus-HelpDesk
        String path =  uri.substring(contextPath.length());     // path = /complaints/detail

        // 1. 민원 목록
        if ("/complaints".equals(path)) {
            complaintList(req, res);
            return;
        }
        // 2. 민원 상세
        if ("/complaints/detail".equals(path)) {
            complaintDetail(req, res);
            return;
        }
        if ("/complaints/faq-test".equals(path)) {
            faqTest(req, res);
            return;
        }
        //[작성 화면] 빈 폼 보여주기
        if ("/complaints/new".equals(path)) {
        	complaintNewForm(req, res);
            return;
        }
        //[수정 화면] 기존 데이터 채워서 폼 보여주기
        if ("/complaints/edit".equals(path)) {
        	complaintEditForm(req, res);
            return;
        }


        if ("/complaints/check".equals(path)
                || "/complaints/create".equals(path)
                || "/complaints/update".equals(path)
                || "/complaints/delete".equals(path)
                || "/complaints/like".equals(path)) {
            res.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    // POST 요청은 여기서 처리
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path =  uri.substring(contextPath.length());


        if ("/complaints/check".equals(path)) {
            complaintSimilarFAQ(req, res);
            return;
        }

        if ("/complaints/create".equals(path)) {
            complaintCreate(req, res);
            return;
        }

        if ("/complaints/update".equals(path)) {
            complaintUpdate(req, res);
            return;
        }

        if ("/complaints/delete".equals(path)) {
            complaintDelete(req, res);
            return;
        }

        if ("/complaints/like".equals(path)) {
            complaintLike(req, res);
            return;
        }

        if ("/complaints".equals(path)
                || "/complaints/detail".equals(path)
                || "/complaints/faq-test".equals(path)
                || "/complaints/new".equals(path)
                || "/complaints/edit".equals(path)) {
            res.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    // 민원 목록
    private void complaintList(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String departmentType = req.getParameter("departmentType");
        String category = req.getParameter("category");
        String status = req.getParameter("status");
        String searchType = req.getParameter("searchType");
        String keyword = req.getParameter("keyword");
        String likeSort = req.getParameter("likeSort");

        if (!"asc".equals(likeSort) && !"desc".equals(likeSort)) {
            likeSort = "";
        }

        String nextLikeSort = "asc".equals(likeSort) ? "desc" : "asc";

        Long departmentId = null;
        String departmentIdParam = req.getParameter("departmentId");

        if (departmentIdParam != null && !departmentIdParam.isBlank()) {
            try {
                departmentId = Long.parseLong(departmentIdParam);
            } catch (NumberFormatException e) {
                res.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
        }

        int page = 1;
        String pageParam = req.getParameter("page");

        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (page <= 0) {
            page = 1;
        }

        int pageSize = 15;

        int totalCount = complaintService.countComplaintList(
                departmentType,
                departmentId,
                category,
                status,
                searchType,
                keyword
        );

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        if (totalPages == 0) {
            totalPages = 1;
        }

        if (page > totalPages) {
            page = totalPages;
        }

        List<ComplaintDTO> complaints = complaintService.findComplaintList(
                departmentType,
                departmentId,
                category,
                status,
                searchType,
                keyword,
                likeSort,
                page,
                pageSize
        );

        List<ComplaintDTO> topLikedComplaints = complaintService.findTopLikedComplaintList(
                departmentType,
                departmentId,
                category,
                status,
                searchType,
                keyword
        );

        List<DepartmentDTO> departments = departmentService.findAllDepartments();

        req.setAttribute("complaints", complaints);
        req.setAttribute("topLikedComplaints", topLikedComplaints);
        req.setAttribute("departments", departments);
        req.setAttribute("categories", CategoryConstants.CATEGORIES);

        req.setAttribute("departmentType", departmentType);
        req.setAttribute("departmentId", departmentId);
        req.setAttribute("category", category);
        req.setAttribute("status", status);
        req.setAttribute("searchType", searchType);
        req.setAttribute("keyword", keyword);
        req.setAttribute("likeSort", likeSort);
        req.setAttribute("nextLikeSort", nextLikeSort);

        req.setAttribute("page", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("/WEB-INF/views/complaint/list.jsp").forward(req, res);
    }

 // 민원 상세
    private void complaintDetail(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String _id = req.getParameter("id");
        if (_id == null || _id.equals("")) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // id = 문자열 방지
        Long complaintId;
        try {
            complaintId = Long.parseLong(_id);     // String -> Long
        }
        catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        ComplaintDTO complaint = complaintService.findComplaintDetail(complaintId);
        
        if (complaint == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // [팀원 최신 로직 반영] AnswerService를 통해 답변을 가져오고, 추천 여부 및 이력을 조회합니다.
        AnswerDTO answer = answerService.findAnswer(complaintId);
        Long userId = 1L; // TODO: 로그인 기능 완성 후 session의 loginUser.getUserId()로 변경
        boolean likedByMe = complaintService.isLikedByUser(complaintId, userId);
        List<StatusHistoryDTO> statusHistories = complaintService.findStatusHistories(complaintId);

        req.setAttribute("complaint", complaint);
        req.setAttribute("answer", answer);
        req.setAttribute("likedByMe", likedByMe);
        req.setAttribute("statusHistories", statusHistories);
        
        req.getRequestDispatcher("/WEB-INF/views/complaint/detail.jsp").forward(req, res);
    }

    // 민원 작성 화면
    private void complaintNewForm(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        List<DepartmentDTO> departments = departmentService.findAllDepartments();

        req.setAttribute("departments", departments);
        req.setAttribute("categories", CategoryConstants.CATEGORIES);
        req.setAttribute("basket", new ComplaintDTO());

        req.getRequestDispatcher("/WEB-INF/views/complaint/form.jsp").forward(req, res);
    }

    // 민원 수정 화면
    private void complaintEditForm(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        Long complaintId = parseLongParam(req, res, "id");
        if (complaintId == null) {
            return;
        }

        ComplaintDTO complaint = complaintService.findComplaintDetail(complaintId);

        if (complaint == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        List<DepartmentDTO> departments = departmentService.findAllDepartments();

        req.setAttribute("basket", complaint);
        req.setAttribute("departments", departments);
        req.setAttribute("categories", CategoryConstants.CATEGORIES);

        req.getRequestDispatcher("/WEB-INF/views/complaint/form.jsp").forward(req, res);
    }


    // 민원 작성 2단계: 최종 등록
    private void complaintCreate(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        ComplaintDTO pendingComplaint = (ComplaintDTO) session.getAttribute("pendingComplaint");

        if (pendingComplaint == null) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        complaintService.createComplaint(pendingComplaint);

        session.removeAttribute("pendingComplaint");

        res.sendRedirect(req.getContextPath() + "/complaints");
    }


    // 민원 수정 처리
    private void complaintUpdate(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Long complaintId = parseLongParam(req, res, "complaintId");
        if (complaintId == null) {
            return;
        }

        Long departmentId = parseLongParam(req, res, "departmentId");
        if (departmentId == null) {
            return;
        }

        String title = req.getParameter("title");
        if (title == null || title.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String content = req.getParameter("content");
        if (content == null || content.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String category = req.getParameter("category");
        if (category == null || category.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        boolean isPrivate = Boolean.parseBoolean(req.getParameter("isPrivate"));

        ComplaintDTO complaint = new ComplaintDTO();
        complaint.setComplaintId(complaintId);
        complaint.setDepartmentId(departmentId);
        complaint.setCategory(category);
        complaint.setTitle(title);
        complaint.setContent(content);
        complaint.setPrivateFlag(isPrivate);

        complaintService.updateComplaint(complaint);

        res.sendRedirect(req.getContextPath() + "/complaints/detail?id=" + complaintId);
    }


    // 민원 삭제 처리
    private void complaintDelete(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Long complaintId = parseLongParam(req, res, "complaintId");

        // 기존 코드나 JSP에서 id로 넘기는 경우까지 임시 호환
        if (complaintId == null) {
            complaintId = parseLongParam(req, res, "id");
        }

        if (complaintId == null) {
            return;
        }

        Long writerId = 1L; // TODO: 로그인 기능 완성 후 session의 loginUser.getUserId()로 변경

        complaintService.deleteComplaint(complaintId, writerId);

        res.sendRedirect(req.getContextPath() + "/complaints");
    }

    // 민원 추천 처리
    private void complaintLike(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Long complaintId = parseLongParam(req, res, "complaintId");
        if (complaintId == null) {
            return;
        }

        Long userId = 1L; // TODO: 로그인 기능 완성 후 session의 loginUser.getUserId()로 변경

        int result;
        try {
            result = complaintService.toggleLikeComplaint(complaintId, userId);
        } catch (RuntimeException e) {
            result = 0;
        }

        String likeResult;
        boolean liked;
        if (result == 1) {
            likeResult = "success";
            liked = true;
        } else if (result == 2) {
            likeResult = "cancel";
            liked = false;
        } else {
            likeResult = "fail";
            liked = complaintService.isLikedByUser(complaintId, userId);
        }

        ComplaintDTO complaint = complaintService.findComplaintDetail(complaintId);
        int likeCount = complaint == null ? 0 : complaint.getLikeCount();

        if (isAjaxRequest(req)) {
            res.setContentType("application/json; charset=UTF-8");
            res.getWriter().write("{\"result\":\"" + likeResult + "\",\"liked\":" + liked
                    + ",\"likeCount\":" + likeCount + "}");
            return;
        }

        res.sendRedirect(req.getContextPath() + "/complaints/detail?id=" + complaintId);
    }

    private boolean isAjaxRequest(HttpServletRequest req) {
        return "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));
    }

    // Long 파라미터 공통 파싱
    private Long parseLongParam(HttpServletRequest req, HttpServletResponse res, String name)
            throws IOException {

        String value = req.getParameter(name);

        if (value == null || value.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }
    }



    // 유사민원 / FAQ
    private void complaintSimilarFAQ(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // 제목
        String title = req.getParameter("title");
        if (title == null || title.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 내용
        String content = req.getParameter("content");
        if (content == null || content.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 카테고리
        String category  = req.getParameter("category");
        if (category == null || category.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 부서ID
        String departmentIdParam = req.getParameter("departmentId");
        if (departmentIdParam == null || departmentIdParam.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        Long departmentId;
        try {
            departmentId = Long.parseLong(departmentIdParam);
        }
        catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 비공개 여부
        boolean isPrivate = Boolean.parseBoolean(req.getParameter("isPrivate"));

        // 작성 중인 민원 DTO 저장
        ComplaintDTO pendingComplaint = new ComplaintDTO();
        pendingComplaint.setTitle(title);
        pendingComplaint.setContent(content);
        pendingComplaint.setCategory(category);
        pendingComplaint.setDepartmentId(departmentId);
        pendingComplaint.setPrivateFlag(isPrivate);

        req.setAttribute("pendingComplaint", pendingComplaint);
        req.getSession().setAttribute("pendingComplaint", pendingComplaint);
        // 등록 성공 후 session.removeAttribute("pendingComplaint") 해야함

        // 유사 민원
        List<ComplaintDTO> similarComplaints = complaintCheckService.findSimilarComplaints(pendingComplaint);

        // FAQ
        List<FaqDTO> similarFaqs = complaintCheckService.findSimilarFaqs(pendingComplaint);

        req.setAttribute("similarComplaints", similarComplaints);
        req.setAttribute("similarFaqs", similarFaqs);
        req.setAttribute("showSimilarBox", true);


        List<DepartmentDTO> departments = departmentService.findAllDepartments();

        req.setAttribute("departments", departments);
        req.setAttribute("categories", CategoryConstants.CATEGORIES);
        req.setAttribute("basket", pendingComplaint);

        req.getRequestDispatcher("/WEB-INF/views/complaint/form.jsp").forward(req, res);
        // req.getRequestDispatcher("/WEB-INF/views/test/faq-test.jsp").forward(req, res);
    }


    // faq 테스트용
    private void faqTest(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/test/faq-test.jsp").forward(req, res);
    }

}
