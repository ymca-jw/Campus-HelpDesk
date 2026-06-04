package com.campus.controller;

import com.campus.dto.AnswerDTO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.StatusHistoryDTO;
import com.campus.service.AnswerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet({"/staff/dashboard", "/staff/complaints", "/staff/complaints/detail", "/staff/answer",
        "/staff/answer/update", "/staff/answer/delete", "/staff/status"})
public class AnswerController extends HttpServlet {

    private final AnswerService answerService = new AnswerService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // 담당자 대시보드
        if ("/staff/dashboard".equals(path)) {
            staffDashboard(req, res);
            return;
        }
        // 민원 목록 조회
        if ("/staff/complaints".equals(path)) {
            staffComplaintList(req, res);
            return;
        }
        if ("/staff/complaints/detail".equals(path)) {
            staffComplaintDetail(req, res);
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        if ("/staff/answer".equals(path)) {
            createAnswer(req, res);
            return;
        }

        if ("/staff/answer/update".equals(path)) {
            updateAnswer(req, res);
            return;
        }

        if ("/staff/answer/delete".equals(path)) {
            deleteAnswer(req, res);
            return;
        }

        if ("/staff/status".equals(path)) {
            updateStatus(req, res);
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    // 담당자 대시보드
    private void staffDashboard(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        // TODO: 로그인 기능 완성 후 session의 loginUser.getDepartmentId()로 변경
        Long staffDepartmentId = 5L;

        int receivedCount = answerService.countComplaintsByDepartmentAndStatus(staffDepartmentId, "RECEIVED");
        int processingCount = answerService.countComplaintsByDepartmentAndStatus(staffDepartmentId, "PROCESSING");
        int completedCount = answerService.countComplaintsByDepartmentAndStatus(staffDepartmentId, "COMPLETED");

        req.setAttribute("receivedCount", receivedCount);
        req.setAttribute("processingCount", processingCount);
        req.setAttribute("completedCount", completedCount);

        req.getRequestDispatcher("/WEB-INF/views/staff/dashboard.jsp").forward(req, res);
    }

    // 담당 부서 민원 목록
    private void staffComplaintList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        // TODO: 로그인 완성 후 session의 loginUser.getDepartmentId()로 변경
        Long staffDepartmentId = 5L;

        List<ComplaintDTO> complaints = answerService.findComplaintsByDepartment(staffDepartmentId);

        Map<Long, AnswerDTO> answersByComplaintId = new HashMap<>();

        for (ComplaintDTO complaint : complaints) {
            AnswerDTO answer = answerService.findAnswer(complaint.getComplaintId());

            if (answer != null) {
                answersByComplaintId.put(complaint.getComplaintId(), answer);
            }
        }

        req.setAttribute("complaints", complaints);
        req.setAttribute("answersByComplaintId", answersByComplaintId);

        req.getRequestDispatcher("/WEB-INF/views/staff/complaints.jsp").forward(req, res);
    }

    // 민원 상세 (담당자용)
    private void staffComplaintDetail(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Long complaintId = parseLongParam(req, res, "id");
        if (complaintId == null) return;

        ComplaintDTO complaint = answerService.findComplaintDetail(complaintId);
        if (complaint == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        AnswerDTO answer = answerService.findAnswer(complaintId);
        List<StatusHistoryDTO> statusHistories = answerService.findStatusHistories(complaintId);

        req.setAttribute("complaint", complaint);
        req.setAttribute("answer", answer);
        req.setAttribute("statusHistories", statusHistories);

        req.getRequestDispatcher("/WEB-INF/views/staff/detail.jsp")
                .forward(req, res);
    }

    // 답변 등록
    private void createAnswer(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        Long complaintId = parseLongParam(req, res, "complaintId");
        if (complaintId == null) return;

        String content = req.getParameter("content");
        if (content == null || content.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        AnswerDTO answer = new AnswerDTO();
        answer.setComplaintId(complaintId);

        // TODO: 로그인 기능 완성 후 session의 loginUser.getUserId()로 변경
        answer.setStaffId(3L);
        answer.setContent(content);
        answerService.registerAnswer(answer);
        res.sendRedirect(req.getContextPath() + "/staff/complaints/detail?id=" + complaintId);
    }

    // 답변 수정
    private void updateAnswer(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Long complaintId = parseLongParam(req, res, "complaintId");
        if (complaintId == null) return;

        Long answerId = parseLongParam(req, res, "answerId");
        if (answerId == null) return;

        String content = req.getParameter("content");
        if (content == null || content.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        AnswerDTO answer = new AnswerDTO();
        answer.setAnswerId(answerId);
        answer.setContent(content);

        answerService.modifyAnswer(answer);

        res.sendRedirect(req.getContextPath() + "/staff/complaints/detail?id=" + complaintId);
    }

    // 답변 삭제
    private void deleteAnswer(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        Long answerId = parseLongParam(req, res, "answerId");
        if (answerId == null) return;

        Long complaintId = parseLongParam(req, res, "complaintId");
        if (complaintId == null) return;

        answerService.removeAnswer(answerId, complaintId);

        res.sendRedirect(req.getContextPath() + "/staff/complaints/detail?id=" + complaintId);
    }

    // 상태 변경
    private void updateStatus(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        Long complaintId = parseLongParam(req, res, "complaintId");
        if (complaintId == null) return;

        String status = req.getParameter("status");
        if (status == null || status.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Long staffId = 3L; // TODO: 로그인 기능 완성 후 session의 loginUser.getUserId()로 변경
        answerService.updateComplaintStatus(complaintId, status, staffId);

        res.sendRedirect(req.getContextPath() + "/staff/complaints/detail?id=" + complaintId);
    }

    private Long parseLongParam(HttpServletRequest req, HttpServletResponse res, String name) throws IOException {

        String value = req.getParameter(name);

        if (value == null || value.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        try {
            return Long.parseLong(value);
        }
        catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }
    }
}
