package com.campus.controller;

import com.campus.dto.ComplaintDTO;
import com.campus.dto.DepartmentDTO;
import com.campus.dto.UserDTO;
import com.campus.service.AdminService;
import com.campus.service.DepartmentService;
import com.campus.util.CategoryConstants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet({"/admin/dashboard", "/admin/users", "/admin/users/update", "/admin/departments", "/admin/departments/create",
"/admin/departments/update", "/admin/complaints", "/admin/complaints/delete"})
public class AdminController extends HttpServlet {
    private final AdminService adminService = new AdminService();
    private final DepartmentService departmentService = new DepartmentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String uri = req.getRequestURI();   // uri = /Campus-HelpDesk/complaints/detail
        String contextPath = req.getContextPath();      // contextPath = /Campus-HelpDesk
        String path =  uri.substring(contextPath.length());     // path = /complaints/detail

        // 대시보드
        if ("/admin/dashboard".equals(path)) {
            adminDashboard(req, res);
            return;
        }
        // 유저 목록 조회
        else if ("/admin/users".equals(path)) {
            adminUserList(req, res);
            return;
        }
        // 부서 목록 조회
        else if ("/admin/departments".equals(path)) {
            adminDepartmentList(req, res);
            return;
        }
        // 민원 목록 조회
        else if("/admin/complaints".equals(path)) {
            adminComplaintList(req, res);
            return;
        }

        if ("/admin/users/update".equals(path)
                || "/admin/departments/create".equals(path)
                || "/admin/departments/update".equals(path)
                || "/admin/complaints/delete".equals(path)) {
            res.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String uri = req.getRequestURI();   // uri = /Campus-HelpDesk/complaints/detail
        String contextPath = req.getContextPath();      // contextPath = /Campus-HelpDesk
        String path =  uri.substring(contextPath.length());     // path = /complaints/detail

        // 사용자 정보 수정
        if ("/admin/users/update".equals(path)) {
            adminUserUpdate(req, res);
            return;
        }
        // 부서 추가
        else if("/admin/departments/create".equals(path)) {
            adminDepartmentCreate(req, res);
            return;
        }
        // 부서 수정
        else if("/admin/departments/update".equals(path)) {
            adminDepartmentUpdate(req, res);
            return;
        }
        // 민원 삭제
        else if("/admin/complaints/delete".equals(path)) {
            adminComplaintDelete(req, res);
            return;
        }

        if ("/admin/dashboard".equals(path)
                || "/admin/users".equals(path)
                || "/admin/departments".equals(path)
                || "/admin/complaints".equals(path)) {
            res.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    // 대시보드
    private void adminDashboard(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int totalComplaintCount = adminService.countAllComplaints();
        int totalUserCount = adminService.countAllUsers();
        int staffCount = adminService.countStaffUsers();
        int adminCount = adminService.countAdminUsers();

        req.setAttribute("totalComplaintCount", totalComplaintCount);
        req.setAttribute("totalUserCount", totalUserCount);
        req.setAttribute("staffCount", staffCount);
        req.setAttribute("adminCount", adminCount);

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, res);
    }

    // 유저 목록 조회
    private void adminUserList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        String role = req.getParameter("role");
        String searchType = req.getParameter("searchType");
        String keyword = req.getParameter("keyword");
        String departmentIdParam = req.getParameter("departmentId");
        Long departmentId = null;

        if (role == null) role = "";
        if (searchType == null || searchType.isBlank()) searchType = "loginId";
        if (keyword == null) keyword = "";

        if (departmentIdParam != null && !departmentIdParam.isBlank()) {
            try {
                departmentId = Long.parseLong(departmentIdParam);
            }
            catch (NumberFormatException e) {
                departmentId = null;
            }
        }

        if ("STUDENT".equals(role)) {
            departmentId = null;
        }

        int page = 1;       // 페이지
        int pageSize = 20;  // 페이지 안에 들어갈 개수

        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Integer.parseInt(pageParam);
            }
            catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (page < 1) {
            page = 1;
        }

        int totalCount = adminService.countUsers(role, departmentId, searchType, keyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages == 0) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<UserDTO> users = adminService.findUsers(role, departmentId, searchType, keyword, page, pageSize);
        List<DepartmentDTO> departments = departmentService.findAllDepartments();
        List<String> roles = List.of("STUDENT", "STAFF");   // 웹 상에서 ADMIN으로 역할 변경 불가

        req.setAttribute("users", users);
        req.setAttribute("departments", departments);
        req.setAttribute("roles", roles);

        req.setAttribute("selectedRole", role);
        req.setAttribute("selectedDepartmentId", departmentId);
        req.setAttribute("searchType", searchType);
        req.setAttribute("keyword", keyword);

        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCount", totalCount);

        req.getRequestDispatcher("/WEB-INF/views/admin/user.jsp").forward(req, res);
    }

    // 사용자 정보 수정
    private void adminUserUpdate(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // 사용자 Id
        String uid = req.getParameter("userId");
        if (uid == null || uid.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        Long userId;
        try {
            userId = Long.parseLong(uid);
        }
        catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 역할
        String role = req.getParameter("role");
        if (role == null || role.isBlank()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 부서 Id
        String did = req.getParameter("departmentId");
        Long departmentId = null;
        if (did != null && !did.isBlank()) {
            try {
                departmentId = Long.parseLong(did);
            }
            catch (NumberFormatException e) {
                res.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
        }

        int result = adminService.updateUsers(userId, role, departmentId);
        if (result == 1) {
            res.sendRedirect(req.getContextPath() + "/admin/users?result=success");
            return;
        }
        else if (result == 2) {
            res.sendRedirect(req.getContextPath() + "/admin/users?result=na");
            return;
        }

        res.sendRedirect(req.getContextPath() + "/admin/users?result=fail");
    }

    // 부서 목록 조회
    private void adminDepartmentList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String type = req.getParameter("type");
        String keyword = req.getParameter("keyword");

        List<DepartmentDTO> departmentDTOS = departmentService.findDepartments(type, keyword);
        req.setAttribute("departments", departmentDTOS);
        req.setAttribute("selectedType", type);
        req.setAttribute("keyword", keyword);

        req.getRequestDispatcher("/WEB-INF/views/admin/department.jsp").forward(req, res);
    }

    // 부서 추가
    private void adminDepartmentCreate(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String name = req.getParameter("name");
        String type =  req.getParameter("type");

        int result = departmentService.createDepartment(name, type);
        if (result == 1) {
            res.sendRedirect(req.getContextPath() + "/admin/departments?result=createSucc");
            return;
        }
        if (result == 2) {
            res.sendRedirect(req.getContextPath() + "/admin/departments?result=createDup");
            return;
        }

        res.sendRedirect(req.getContextPath() + "/admin/departments?result=createFail");
    }

    // 부서 수정
    private void adminDepartmentUpdate(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // 부서 Id
        String did = req.getParameter("departmentId");
        if (did == null || did.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/admin/departments?result=updateFail");
            return;
        }
        Long departmentId;
        try {
            departmentId = Long.parseLong(did);
        }
        catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/admin/departments?result=updateFail");
            return;
        }

        // 이름
        String name = req.getParameter("name");

        // type
        String type = req.getParameter("type");

        int result = departmentService.updateDepartment(departmentId, name, type);

        if (result == 1) {
            res.sendRedirect(req.getContextPath() + "/admin/departments?result=updateSucc");
            return;
        }

        if (result == 2) {
            res.sendRedirect(req.getContextPath() + "/admin/departments?result=updateNA");
            return;
        }

        if (result == 3) {
            res.sendRedirect(req.getContextPath() + "/admin/departments?result=updateDup");
            return;
        }

        res.sendRedirect(req.getContextPath() + "/admin/departments?result=updateFail");
    }

    // 민원 목록 조회 (관리자)
    private void adminComplaintList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String did = req.getParameter("departmentId");
        Long departmentId = null;
        if (did != null && !did.isBlank()) {
            try {
                departmentId = Long.parseLong(did);
            }
            catch (NumberFormatException e) {
                departmentId = null;
            }
        }

        // 카테고리 필터
        String category = req.getParameter("category");
        // 상태 필터
        String status = req.getParameter("status");
        // 검색 기준 (제목/내용)
        String searchType = req.getParameter("searchType");
        // 검색어
        String keyword = req.getParameter("keyword");
        // 페이징
        int page = 1;
        int pageSize = 20;

        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Integer.parseInt(pageParam);
            }
            catch (NumberFormatException e) {
                page = 1;
            }
        }
        if (page < 1) page = 1;

        int totalCount = adminService.countComplaints(departmentId, category, status, searchType, keyword);
        int totalPages = (int)Math.ceil((double)totalCount / pageSize);
        if (totalPages == 0) totalPages = 1;

        if (page > totalPages) page = totalPages;

        List<ComplaintDTO> complaints = adminService.findComplaints(departmentId, category, status, searchType, keyword, page, pageSize);
        List<DepartmentDTO> departments = departmentService.findAllDepartments();
        List<String> categories = CategoryConstants.CATEGORIES;
        List<String> statuses = List.of("RECEIVED", "REVIEWING", "PROCESSING", "COMPLETED", "REJECTED");

        req.setAttribute("complaints", complaints);
        req.setAttribute("departments", departments);
        req.setAttribute("categories", categories);
        req.setAttribute("statuses", statuses);

        req.setAttribute("selectedDepartmentId", departmentId);
        req.setAttribute("selectedCategory", category);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("searchType", searchType);
        req.setAttribute("keyword", keyword);

        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCount", totalCount);
        req.getRequestDispatcher("/WEB-INF/views/admin/complaint.jsp").forward(req, res);
    }

    // 관리자 민원 삭제
    public void adminComplaintDelete(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // 민원 Id
        String cid = req.getParameter("complaintId");
        if (cid == null || cid.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/admin/complaints?result=deleteFail");
            return;
        }
        Long complaintId;
        try {
            complaintId = Long.parseLong(cid);
        }
        catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/admin/complaints?result=deleteFail");
            return;
        }

        int result = adminService.deleteComplaint(complaintId);
        if (result == 1) {
            res.sendRedirect(req.getContextPath() + "/admin/complaints?result=deleteSucc");
            return;
        }

        res.sendRedirect(req.getContextPath() + "/admin/complaints?result=deleteFail");
    }
}
