package com.campus.controller;

import com.campus.dto.ComplaintDTO;
import com.campus.dto.DepartmentDTO;
import com.campus.dto.FaqDTO;
import com.campus.service.ComplaintCheckService;
import com.campus.service.ComplaintService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/complaints", "/complaints/detail", "/complaints/new", "/complaints/check", "/complaints/update",
"/complaints/create", "/complaints/edit", "/complaints/delete", "/complaints/like", "/complaints/faq-test"})
public class ComplaintController extends HttpServlet {
    private final ComplaintService complaintService = new ComplaintService();
    private final ComplaintCheckService complaintCheckService = new ComplaintCheckService();

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
        else if ("/complaints/detail".equals(path)) {
            complaintDetail(req, res);
            return;
        }
        else if ("/complaints/faq-test".equals(path)) {
            faqTest(req, res);
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);    // 400 error (추후 에러페이지 구현 지금은 sendError로 대체)
    }

    // POST 요청은 여기서 처리
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path =  uri.substring(contextPath.length());

        //
        if ("/complaints/check".equals(path)) {
            complaintSimilarFAQ(req, res);
            return;
        }
    }


    // 민원 목록
    private void complaintList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<ComplaintDTO> complaints = complaintService.findComplaintList();
        req.setAttribute("complaints", complaints);
        req.getRequestDispatcher("/WEB-INF/views/test/list.jsp").forward(req, res);
        // req.getRequestDispatcher("/WEB-INF/views/complaint/list.jsp").forward(req, res);
    }

    // 민원 상세
    private void complaintDetail(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String _id = req.getParameter("id");
        if (_id == null || _id.equals("")) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);  // 400 error (추후 에러페이지 구현 지금은 sendError로 대체)
            return;
        }

        // id = 문자열 방지
        Long complaintId;
        try {
            complaintId = Long.parseLong(_id);     // String -> Long
        }
        catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);  // 400 error (추후 에러페이지 구현 지금은 sendError로 대체)
            return;
        }

        ComplaintDTO complaint = complaintService.findComplaintDetail(complaintId);
        if (complaint == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        req.setAttribute("complaint", complaint);
        req.getRequestDispatcher("/WEB-INF/views/test/detail.jsp").forward(req, res);
    }

    // 여기에 민원 CRUD









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


        // form.jsp 다시 그리기 위해서 부서 목록이랑 카테고리 목록 다시 담기
        // TODO: form.jsp select box 출력을 위해 departments, categories를 다시 request에 담아야 함
        // 민원 작성 GET /complaints/new에서 쓰는 방식과 동일하게 맞출 예정
        // req.setAttribute("departments", departments);
        // req.setAttribute("categories", categories);


        req.getRequestDispatcher("/WEB-INF/views/test/faq-test.jsp").forward(req, res);
    }











    // faq 테스트용
    private void faqTest(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/test/faq-test.jsp").forward(req, res);
    }

}
