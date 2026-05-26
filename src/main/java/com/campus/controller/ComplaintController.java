package com.campus.controller;

import com.campus.dto.ComplaintDTO;
import com.campus.service.ComplaintService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/complaints", "/complaints/detail", "/complaints/new", "/complaints/check", "/complaints/update",
"/complaints/create", "/complaints/edit", "/complaints/delete", "/complaints/like"})
public class ComplaintController extends HttpServlet {
    private final ComplaintService complaintService = new ComplaintService();

    // GET 요청
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String uri = req.getRequestURI();   // uri = /Campus-HelpDesk/complaints/detail
        String contextPath = req.getContextPath();      // contextPath = /Campus-HelpDesk
        String path =  uri.substring(contextPath.length());     // path = /complaints/detail

        // 1. 민원 목록
        if ("/complaints".equals(path)) {
            ComplaintList(req, res);
            return;
        }
        else if ("/complaints/detail".equals(path)) {
            ComplaintDetail(req, res);
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);    // 400 error (추후 에러페이지 구현 지금은 sendError로 대체)
    }

    // 민원 목록
    private void ComplaintList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<ComplaintDTO> complaints = complaintService.findComplaintList();
        req.setAttribute("complaints", complaints);
        req.getRequestDispatcher("/WEB-INF/views/test/list.jsp").forward(req, res);
        // req.getRequestDispatcher("/WEB-INF/views/complaint/list.jsp").forward(req, res);
    }

    // 민원 상세
    private void ComplaintDetail(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
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
}
