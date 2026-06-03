package com.campus.controller;


import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.campus.dao.ComplaintDAO;
import com.campus.dao.DepartmentDAO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.FaqDTO;
import com.campus.service.ComplaintService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet({"/complaints", "/complaints/detail", "/complaints/new", "/complaints/check", "/complaints/update",
"/complaints/create", "/complaints/edit", "/complaints/delete", "/complaints/like"})
@MultipartConfig(
	    maxFileSize = 1024 * 1024 * 10,
	    maxRequestSize = 1024 * 1024 * 10
)
public class ComplaintController extends HttpServlet {
	private final ComplaintService complaintService = new ComplaintService();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

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
     //[작성 화면] 빈 폼 보여주기
        else if ("/complaints/new".equals(path)) {
            req.setAttribute("departments", departmentDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/complaint/form.jsp").forward(req, res);
            return;
        }
        //[수정 화면] 기존 데이터 채워서 폼 보여주기
        else if ("/complaints/edit".equals(path)) {
            Long id = Long.parseLong(req.getParameter("id"));
            ComplaintDTO existingData = complaintDAO.findById(id);
            
            req.setAttribute("basket", existingData); // 기존 데이터를 바구니에 담음
            req.setAttribute("departments", departmentDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/complaint/form.jsp").forward(req, res);
            return;
        }
        // [삭제 처리] 화면 없이 삭제 후 목록으로 튕겨냄
        else if ("/complaints/delete".equals(path)) {
            Long id = Long.parseLong(req.getParameter("id"));
            complaintDAO.deleteComplaint(id);
            res.sendRedirect(contextPath + "/complaints");
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);    // 400 error (추후 에러페이지 구현 지금은 sendError로 대체)
    }
    //doPost
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // 파일 저장 경로 (프로젝트 내 uploads 폴더)
        String savePath = req.getServletContext().getRealPath("/uploads");
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        // 1. [작성 1단계 - 검사] (cos.jar 걷어내고 최신 코드로 변경)
        if ("/complaints/check".equals(path)) {
            try {
                ComplaintDTO basket = new ComplaintDTO();
                basket.setCategory(req.getParameter("category"));
                basket.setDepartmentId(Long.parseLong(req.getParameter("departmentId")));
                basket.setTitle(req.getParameter("title"));
                basket.setContent(req.getParameter("content"));
                
                // 파일 파트 가져오기
                Part filePart = req.getPart("attachedFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = filePart.getSubmittedFileName();
                    filePart.write(savePath + File.separator + fileName); // 실제 서버에 저장!
                    basket.setAttachedFile(fileName);
                }

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
            } catch (Exception e) { e.printStackTrace(); }
            return;
        }

        // 2. [작성 2단계 - 최종 등록]
        else if ("/complaints/create".equals(path)) {
            try {
                ComplaintDTO dto = new ComplaintDTO();
                dto.setWriterId(1L); // TODO: 로그인 세션
                dto.setDepartmentId(Long.parseLong(req.getParameter("departmentId")));
                dto.setCategory(req.getParameter("category"));
                dto.setTitle(req.getParameter("title"));
                dto.setContent(req.getParameter("content"));
                dto.setPrivateFlag("true".equals(req.getParameter("isPrivate")));
                dto.setStatus("RECEIVED");
                
                // 1단계에서 저장해둔 파일명 숨긴 태그에서 꺼내오기
                dto.setAttachedFile(req.getParameter("savedFileName")); 

                complaintDAO.insertComplaint(dto);
                res.sendRedirect(contextPath + "/complaints");
            } catch (Exception e) { e.printStackTrace(); }
            return;
        }

        // 3. [수정 적용]
        else if ("/complaints/update".equals(path)) {
            try {
                ComplaintDTO dto = new ComplaintDTO();
                dto.setComplaintId(Long.parseLong(req.getParameter("complaintId")));
                dto.setDepartmentId(Long.parseLong(req.getParameter("departmentId")));
                dto.setCategory(req.getParameter("category"));
                dto.setTitle(req.getParameter("title"));
                dto.setContent(req.getParameter("content"));
                dto.setPrivateFlag("true".equals(req.getParameter("isPrivate")));

                Part filePart = req.getPart("attachedFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String newFile = filePart.getSubmittedFileName();
                    filePart.write(savePath + File.separator + newFile);
                    dto.setAttachedFile(newFile);
                } else {
                    dto.setAttachedFile(req.getParameter("savedFileName"));
                }

                complaintDAO.updateComplaint(dto);
                res.sendRedirect(contextPath + "/complaints/detail?id=" + dto.getComplaintId());
            } catch (Exception e) { e.printStackTrace(); }
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
        if (complaint == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        req.setAttribute("complaint", complaint);
        req.getRequestDispatcher("/WEB-INF/views/test/detail.jsp").forward(req, res);
    }
}
