package com.campus.controller;


import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.campus.dao.DepartmentDAO;
import com.campus.dto.AnswerDTO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.FaqDTO;
import com.campus.service.ComplaintService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({"/complaints", "/complaints/detail", "/complaints/new", "/complaints/check", "/complaints/update",
"/complaints/create", "/complaints/edit", "/complaints/delete", "/complaints/like", 
"/complaints/staff/list", "/complaints/answer","/complaints/answer/update", "/complaints/answer/delete"})
/* 임시 주석 처리 (첨부파일)
@MultipartConfig(
	    maxFileSize = 1024 * 1024 * 10,
	    maxRequestSize = 1024 * 1024 * 10
)
*/
public class ComplaintController extends HttpServlet {
	private final ComplaintService complaintService = new ComplaintService();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();

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
        //상세 페이지
        else if ("/complaints/detail".equals(path)) {
            ComplaintDetail(req, res);
            return;
        }
        //[작성 화면] 빈 폼 보여주기
        else if ("/complaints/new".equals(path)) {
            showNewForm(req, res);
            return;
        }
        //[수정 화면] 기존 데이터 채워서 폼 보여주기
        else if ("/complaints/edit".equals(path)) {
            showEditForm(req, res);
            return;
        }
        // [삭제 처리] 화면 없이 삭제 후 목록으로 튕겨냄
        else if ("/complaints/delete".equals(path)) {
            deleteComplaint(req, res);
            return;
        }
        // 담당자 부서별 민원 목록 대시보드
        else if ("/complaints/staff/list".equals(path)) {
            showStaffDashboard(req, res);
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);    // 400 error (추후 에러페이지 구현 지금은 sendError로 대체)
    }

    // doPost
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // 1. [작성 1단계 - 검사]
        if ("/complaints/check".equals(path)) {
            checkComplaint(req, res);
            return;
        }
        // 2. [작성 2단계 - 최종 등록]
        else if ("/complaints/create".equals(path)) {
            createComplaint(req, res);
            return;
        }
        // 3. [수정 적용]
        else if ("/complaints/update".equals(path)) {
            updateComplaint(req, res);
            return;
        }
        // 담당자 답변 등록
        else if ("/complaints/answer".equals(path)) {
            createAnswer(req, res);
            return;
        }
        // 답변 수정
        else if ("/complaints/answer/update".equals(path)) {
            updateAnswer(req, res);
            return;
        } 
        // 답변 제거
        else if ("/complaints/answer/delete".equals(path)) {
            deleteAnswer(req, res);
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);
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
        // 답변 내용 가져오기
        AnswerDTO answer = complaintService.findAnswer(complaintId);
        
        if (complaint == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        req.setAttribute("complaint", complaint);
        req.setAttribute("answer", answer); // 답변을 화면 바구니에 담기
        req.getRequestDispatcher("/WEB-INF/views/test/detail.jsp").forward(req, res);
    }

    //[작성 화면] 빈 폼 보여주기
    private void showNewForm(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("departments", departmentDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/complaint/form.jsp").forward(req, res);
    }

    //[수정 화면] 기존 데이터 채워서 폼 보여주기
    private void showEditForm(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        ComplaintDTO existingData = complaintService.findComplaintDetail(id);

        req.setAttribute("basket", existingData); // 기존 데이터를 바구니에 담음
        req.setAttribute("departments", departmentDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/complaint/form.jsp").forward(req, res);
    }

    // [삭제 처리] 화면 없이 삭제 후 목록으로 튕겨냄
    private void deleteComplaint(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        complaintService.deleteComplaint(id);
        res.sendRedirect(req.getContextPath() + "/complaints");
    }

    // 1. [작성 1단계 - 검사]
    private void checkComplaint(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        try {
            ComplaintDTO basket = new ComplaintDTO();
            basket.setCategory(req.getParameter("category"));
            basket.setDepartmentId(Long.parseLong(req.getParameter("departmentId")));
            basket.setTitle(req.getParameter("title"));
            basket.setContent(req.getParameter("content"));
            
            // 가짜 FAQ 세팅
            List<FaqDTO> similarFaqs = new ArrayList<>();
            FaqDTO dummy = new FaqDTO();
            dummy.setQuestion("수강신청 문의"); dummy.setAnswer("포털을 확인하세요.");
            similarFaqs.add(dummy);

            req.setAttribute("departments", departmentDAO.findAll());
            req.setAttribute("basket", basket);
            req.setAttribute("similarFaqs", similarFaqs);
            req.setAttribute("showSimbox", true);

            req.getRequestDispatcher("/WEB-INF/views/complaint/form.jsp").forward(req, res);
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

    // 2. [작성 2단계 - 최종 등록]
    private void createComplaint(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        try {
            ComplaintDTO dto = new ComplaintDTO();
            dto.setDepartmentId(Long.parseLong(req.getParameter("departmentId")));
            dto.setCategory(req.getParameter("category"));
            dto.setTitle(req.getParameter("title"));
            dto.setContent(req.getParameter("content"));
            dto.setPrivateFlag("true".equals(req.getParameter("isPrivate")));
            
            // 1단계에서 저장해둔 파일명 숨긴 태그에서 꺼내오기 (현재 첨부파일 보류로 주석 처리)
            // dto.setAttachedFile(req.getParameter("savedFileName")); 

            complaintService.createComplaint(dto);
            res.sendRedirect(req.getContextPath() + "/complaints");
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

    // 3. [수정 적용]
    private void updateComplaint(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        try {
            ComplaintDTO dto = new ComplaintDTO();
            dto.setComplaintId(Long.parseLong(req.getParameter("complaintId")));
            dto.setDepartmentId(Long.parseLong(req.getParameter("departmentId")));
            dto.setCategory(req.getParameter("category"));
            dto.setTitle(req.getParameter("title"));
            dto.setContent(req.getParameter("content"));
            dto.setPrivateFlag("true".equals(req.getParameter("isPrivate")));

            complaintService.updateComplaint(dto);
            res.sendRedirect(req.getContextPath() + "/complaints/detail?id=" + dto.getComplaintId());
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }
    // 담당자용 대시보드 (자신의 부서 민원만 보기)
    private void showStaffDashboard(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // TODO: 나중에 로그인 기능 완성되면 세션에서 부서ID 가져와야 함. 일단 전산지원팀(4)으로 강제 고정
        Long staffDeptId = 4L; 
        
        List<ComplaintDTO> complaints = complaintService.findComplaintsByDepartment(staffDeptId);
        req.setAttribute("complaints", complaints);
        // 재사용: 기존 목록 페이지를 담당자용으로 띄워줍니다.
        req.getRequestDispatcher("/WEB-INF/views/test/list.jsp").forward(req, res);
    }

    // 담당자 답변 등록 및 상태 변경
    private void createAnswer(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        try {
            AnswerDTO answer = new AnswerDTO();
            answer.setComplaintId(Long.parseLong(req.getParameter("complaintId")));
            // TODO: 나중에 로그인 기능 완성되면 세션에서 직원ID 가져와야 함. 일단 '전산담당자'(3)로 고정
            answer.setStaffId(3L); 
            answer.setContent(req.getParameter("content"));
            
            complaintService.registerAnswer(answer);
            
            // 답변 달면 해당 민원 상세페이지로 다시 돌아가기
            res.sendRedirect(req.getContextPath() + "/complaints/detail?id=" + answer.getComplaintId());
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }
    // 담당자 답변 수정
    private void updateAnswer(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        try {
            AnswerDTO answer = new AnswerDTO();
            answer.setAnswerId(Long.parseLong(req.getParameter("answerId")));
            answer.setContent(req.getParameter("content"));
            Long complaintId = Long.parseLong(req.getParameter("complaintId"));
            
            complaintService.modifyAnswer(answer);
            res.sendRedirect(req.getContextPath() + "/complaints/detail?id=" + complaintId);
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 담당자 답변 삭제
    private void deleteAnswer(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        try {
            Long answerId = Long.parseLong(req.getParameter("answerId"));
            Long complaintId = Long.parseLong(req.getParameter("complaintId"));
            
            complaintService.removeAnswer(answerId, complaintId);
            res.sendRedirect(req.getContextPath() + "/complaints/detail?id=" + complaintId);
        } catch (Exception e) { e.printStackTrace(); }
    }
}