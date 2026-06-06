package com.campus.controller;

import com.campus.dao.DepartmentDAO;
import com.campus.dto.AnswerDTO;
import com.campus.dto.AttachmentDTO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.DepartmentDTO;
import com.campus.dto.FaqDTO;
import com.campus.dto.StatusHistoryDTO;
import com.campus.dto.UserDTO;
import com.campus.service.AnswerService;
import com.campus.service.ComplaintCheckService;
import com.campus.service.ComplaintService;
import com.campus.service.DepartmentService;
import com.campus.util.CategoryConstants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

@WebServlet({"/complaints", "/complaints/detail", "/complaints/new", "/complaints/check", "/complaints/update",
"/complaints/create", "/complaints/edit", "/complaints/delete", "/complaints/like", "/complaints/faq-test",
"/complaints/download", "/complaints/attachment/delete"})
@MultipartConfig(
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 50 * 1024 * 1024,
        fileSizeThreshold = 1024 * 1024
)
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


        if ("/complaints/download".equals(path)) {
            complaintDownload(req, res);
            return;
        }

        if ("/complaints/check".equals(path)
                || "/complaints/create".equals(path)
                || "/complaints/update".equals(path)
                || "/complaints/delete".equals(path)
                || "/complaints/like".equals(path)
                || "/complaints/attachment/delete".equals(path)) {
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

        if ("/complaints/attachment/delete".equals(path)) {
            attachmentDelete(req, res);
            return;
        }

        if ("/complaints".equals(path)
                || "/complaints/detail".equals(path)
                || "/complaints/faq-test".equals(path)
                || "/complaints/new".equals(path)
                || "/complaints/edit".equals(path)
                || "/complaints/download".equals(path)) {
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
        String myFilter = req.getParameter("my");

        if (!"written".equals(myFilter) && !"liked".equals(myFilter)) {
            myFilter = "";
        }

        UserDTO loginUser = getLoginUser(req);
        Long myFilterUserId = null;
        if (!myFilter.isBlank()) {
            if (loginUser == null) {
                res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
            myFilterUserId = loginUser.getUserId();
        }

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
                keyword,
                myFilter,
                myFilterUserId
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
                myFilter,
                myFilterUserId,
                page,
                pageSize
        );

        List<ComplaintDTO> topLikedComplaints = complaintService.findTopLikedComplaintList(
                departmentType,
                departmentId,
                category,
                status,
                searchType,
                keyword,
                myFilter,
                myFilterUserId
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
        req.setAttribute("myFilter", myFilter);
        req.setAttribute("listTitle", getListTitle(myFilter));

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

        Long complaintId;
        try {
            complaintId = Long.parseLong(_id);
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

        AnswerDTO answer = answerService.findAnswer(complaintId);
        UserDTO loginUser = getLoginUser(req);
        boolean likedByMe = loginUser != null
                && complaintService.isLikedByUser(complaintId, loginUser.getUserId());
        boolean canManageComplaint = canManageComplaint(loginUser, complaint);
        List<StatusHistoryDTO> statusHistories = complaintService.findStatusHistories(complaintId);

        req.setAttribute("complaint", complaint);
        req.setAttribute("answer", answer);
        req.setAttribute("likedByMe", likedByMe);
        req.setAttribute("canManageComplaint", canManageComplaint);
        req.setAttribute("statusHistories", statusHistories);

        List<AttachmentDTO> attachments = complaintService.findAttachments(complaintId);
        req.setAttribute("attachments", attachments);

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

        UserDTO loginUser = requireLoginUser(req, res);
        if (loginUser == null) {
            return;
        }

        if (!canManageComplaint(loginUser, complaint)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<DepartmentDTO> departments = departmentService.findAllDepartments();

        req.setAttribute("basket", complaint);
        req.setAttribute("departments", departments);
        req.setAttribute("categories", CategoryConstants.CATEGORIES);

        List<AttachmentDTO> attachments = complaintService.findAttachments(complaintId);
        req.setAttribute("attachments", attachments);

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

        UserDTO loginUser = requireLoginUser(req, res);
        if (loginUser == null) {
            return;
        }

        pendingComplaint.setWriterId(loginUser.getUserId());
        
        // 민원 생성 및 ID 반환
        Long complaintId = complaintService.createComplaintAndReturnId(pendingComplaint);

        // 첨부파일 처리
        String tempDir = req.getServletContext().getRealPath("/uploads/temp");
        String finalDir = req.getServletContext().getRealPath("/uploads/complaints");
        
        String tempSessionId = (String) session.getAttribute("tempAttachmentSessionId");
        if (tempSessionId != null) {
            List<AttachmentDTO> tempAttachments = (List<AttachmentDTO>) session.getAttribute("tempAttachments");
            if (tempAttachments != null) {
                File finalFolder = new File(finalDir + File.separator + complaintId);
                if (!finalFolder.exists()) finalFolder.mkdirs();

                for (AttachmentDTO att : tempAttachments) {
                    File tempFile = new File(tempDir + File.separator + tempSessionId, att.getStoredName());
                    if (tempFile.exists()) {
                        File destFile = new File(finalFolder, att.getStoredName());
                        tempFile.renameTo(destFile);
                        att.setComplaintId(complaintId);
                    }
                }
                complaintService.insertAttachments(tempAttachments);
            }
        }

        session.removeAttribute("pendingComplaint");
        session.removeAttribute("tempAttachments");
        session.removeAttribute("tempAttachmentSessionId");

        res.sendRedirect(req.getContextPath() + "/complaints");
    }

    // 민원 수정 처리
    private void complaintUpdate(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Long complaintId = parseLongParam(req, res, "complaintId");
        if (complaintId == null) {
            return;
        }

        ComplaintDTO oldComplaint = complaintService.findComplaintDetail(complaintId);
        if (oldComplaint == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
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
        UserDTO loginUser = requireLoginUser(req, res);
        if (loginUser == null) {
            return;
        }

        if (!canManageComplaint(loginUser, oldComplaint)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        ComplaintDTO complaint = new ComplaintDTO();
        complaint.setComplaintId(complaintId);
        complaint.setWriterId(loginUser.getUserId());
        complaint.setDepartmentId(departmentId);
        complaint.setCategory(category);
        complaint.setTitle(title);
        complaint.setContent(content);
        complaint.setPrivateFlag(isPrivate);

        complaintService.updateComplaint(complaint);
        
        // 첨부파일 추가 처리
        List<Part> parts = (List<Part>) req.getParts();
        String uploadDir = req.getServletContext().getRealPath("/uploads/complaints");
        complaintService.saveAttachments(complaintId, parts, uploadDir);

        res.sendRedirect(req.getContextPath() + "/complaints/detail?id=" + complaintId);
    }

    // 민원 삭제 처리
    private void complaintDelete(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Long complaintId = parseLongParam(req, res, "complaintId");

        if (complaintId == null) {
            complaintId = parseLongParam(req, res, "id");
        }

        if (complaintId == null) {
            return;
        }

        UserDTO loginUser = requireLoginUser(req, res);
        if (loginUser == null) {
            return;
        }

        ComplaintDTO complaint = complaintService.findComplaintDetail(complaintId);
        if (complaint == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (!canManageComplaint(loginUser, complaint)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // 물리적 파일 삭제
        String uploadDir = req.getServletContext().getRealPath("/uploads/complaints");
        complaintService.deleteAttachmentFiles(complaintId, uploadDir);

        complaintService.deleteComplaint(complaintId, loginUser.getUserId());

        res.sendRedirect(req.getContextPath() + "/complaints");
    }

    // 민원 추천 처리
    private void complaintLike(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Long complaintId = parseLongParam(req, res, "complaintId");
        if (complaintId == null) {
            return;
        }

        UserDTO loginUser = requireLoginUser(req, res);
        if (loginUser == null) {
            return;
        }

        Long userId = loginUser.getUserId();

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

        String category  = req.getParameter("category");
        if (category == null || category.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

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

        boolean isPrivate = Boolean.parseBoolean(req.getParameter("isPrivate"));

        ComplaintDTO pendingComplaint = new ComplaintDTO();
        pendingComplaint.setTitle(title);
        pendingComplaint.setContent(content);
        pendingComplaint.setCategory(category);
        pendingComplaint.setDepartmentId(departmentId);
        pendingComplaint.setPrivateFlag(isPrivate);

        req.setAttribute("pendingComplaint", pendingComplaint);
        
        HttpSession session = req.getSession();
        session.setAttribute("pendingComplaint", pendingComplaint);

        // 첨부파일 임시 저장 (check 단계)
        String tempSessionId = UUID.randomUUID().toString();
        String tempDir = req.getServletContext().getRealPath("/uploads/temp") + File.separator + tempSessionId;
        File dir = new File(tempDir);
        if (!dir.exists()) dir.mkdirs();

        List<AttachmentDTO> tempAttachments = new ArrayList<>();
        List<Part> parts = (List<Part>) req.getParts();
        for (Part part : parts) {
            if (part == null || part.getSize() == 0 || part.getSubmittedFileName() == null || part.getSubmittedFileName().isBlank()) {
                continue;
            }
            String originalName = part.getSubmittedFileName();
            String ext = "";
            int dotIdx = originalName.lastIndexOf('.');
            if (dotIdx > 0) ext = originalName.substring(dotIdx);
            String storedName = UUID.randomUUID().toString() + ext;

            File saveFile = new File(dir, storedName);
            part.write(saveFile.getAbsolutePath());

            AttachmentDTO attachment = new AttachmentDTO();
            attachment.setOriginalName(originalName);
            attachment.setStoredName(storedName);
            attachment.setFileSize(part.getSize());
            attachment.setContentType(part.getContentType());
            
            tempAttachments.add(attachment);
        }
        
        session.setAttribute("tempAttachments", tempAttachments);
        session.setAttribute("tempAttachmentSessionId", tempSessionId);

        List<ComplaintDTO> similarComplaints = complaintCheckService.findSimilarComplaints(pendingComplaint);
        List<FaqDTO> similarFaqs = complaintCheckService.findSimilarFaqs(pendingComplaint);

        req.setAttribute("similarComplaints", similarComplaints);
        req.setAttribute("similarFaqs", similarFaqs);
        req.setAttribute("showSimilarBox", true);

        List<DepartmentDTO> departments = departmentService.findAllDepartments();
        req.setAttribute("departments", departments);
        req.setAttribute("categories", CategoryConstants.CATEGORIES);
        req.setAttribute("basket", pendingComplaint);

        req.getRequestDispatcher("/WEB-INF/views/complaint/form.jsp").forward(req, res);
    }

    // 첨부파일 다운로드
    private void complaintDownload(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long attachmentId = parseLongParam(req, res, "id");
        if (attachmentId == null) return;

        AttachmentDTO attachment = complaintService.findAttachment(attachmentId);
        if (attachment == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String uploadDir = req.getServletContext().getRealPath("/uploads/complaints");
        File file = new File(uploadDir + File.separator + attachment.getComplaintId(), attachment.getStoredName());

        if (!file.exists()) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String originalName = new String(attachment.getOriginalName().getBytes("UTF-8"), "ISO-8859-1");
        res.setContentType("application/octet-stream");
        res.setHeader("Content-Disposition", "attachment; filename=\"" + originalName + "\"");
        res.setContentLength((int) file.length());

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = res.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }

    // 첨부파일 삭제 (수정 화면 등에서)
    private void attachmentDelete(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long attachmentId = parseLongParam(req, res, "id");
        if (attachmentId == null) return;

        UserDTO loginUser = requireLoginUser(req, res);
        if (loginUser == null) return;

        AttachmentDTO attachment = complaintService.findAttachment(attachmentId);
        if (attachment != null) {
            ComplaintDTO complaint = complaintService.findComplaintDetail(attachment.getComplaintId());
            if (canManageComplaint(loginUser, complaint)) {
                String uploadDir = req.getServletContext().getRealPath("/uploads/complaints");
                complaintService.deleteAttachment(attachmentId, uploadDir);
                res.setContentType("application/json");
                res.getWriter().write("{\"success\":true}");
                return;
            }
        }
        res.sendError(HttpServletResponse.SC_FORBIDDEN);
    }

    private UserDTO getLoginUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return null;
        }

        Object loginUser = session.getAttribute("loginUser");
        return loginUser instanceof UserDTO ? (UserDTO) loginUser : null;
    }

    private UserDTO requireLoginUser(HttpServletRequest req, HttpServletResponse res) throws IOException {
        UserDTO loginUser = getLoginUser(req);
        if (loginUser == null) {
            res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return null;
        }

        return loginUser;
    }

    private boolean canManageComplaint(UserDTO loginUser, ComplaintDTO complaint) {
        if (loginUser == null || complaint == null) {
            return false;
        }

        return loginUser.getUserId() != null
                && loginUser.getUserId().equals(complaint.getWriterId())
                && "RECEIVED".equals(complaint.getStatus());
    }

    private String getListTitle(String myFilter) {
        if ("written".equals(myFilter)) {
            return "내가 작성한 민원";
        }

        if ("liked".equals(myFilter)) {
            return "내가 추천한 민원";
        }

        return "전체 민원";
    }

    // faq 테스트용
    private void faqTest(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/test/faq-test.jsp").forward(req, res);
    }
}
