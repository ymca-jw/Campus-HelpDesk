package com.campus.service;

import com.campus.dao.AdminDAO;
import com.campus.dao.DepartmentDAO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.DepartmentDTO;
import com.campus.dto.UserDTO;

import java.util.List;

public class AdminService {

    private final AdminDAO adminDAO = new AdminDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private static final int NOCHG = 2;
    private static final int SUCC = 1;
    private static final int FAIL = 0;

    // 전체 민원 수
    public int countAllComplaints() {
        return adminDAO.countAllComplaints();
    }

    // 전체 사용자 수
    public int countAllUsers() {
        return adminDAO.countAllUsers();
    }

    // 담당자 수
    public int countStaffUsers() {
        return adminDAO.countStaffUsers();
    }

    // 관리자 수
    public int countAdminUsers() {
        return adminDAO.countAdminUsers();
    }

    // 전체 사용자 목록 조회
    public List<UserDTO> findAllUsers() {
        return adminDAO.findAllUsers();
    }

    // 사용자 목록 조회 + 검색 + 페이징
    public List<UserDTO> findUsers(String role, Long departmentId, String searchType, String keyword, int page, int pageSize) {
        if (page < 1) page = 1;

        if ("STUDENT".equals(role)) {
            departmentId = null;
        }

        return adminDAO.adminFindUsers(role, departmentId, searchType, keyword, page, pageSize);
    }

    // 사용자 검색 결과 전체 개수
    public int countUsers(String role, Long departmentId, String searchType, String keyword) {
        if ("STUDENT".equals(role)) {
            departmentId = null;
        }

        return adminDAO.adminCountUsers(role, departmentId, searchType, keyword);
    }

    // 사용자 정보 업데이트
    public int updateUsers(Long userId, String role, Long departmentId) {
        if (userId == null || userId <= 0) return FAIL;

        if (role == null || role.isBlank()) return FAIL;

        // 관리자 화면에서는 STUDENT <-> STAFF 변경만 허용
        // ADMIN으로 변경하는 요청은 거부
        if (!role.equals("STUDENT") && !role.equals("STAFF")) return FAIL;

        // STUDENT는 담당부서 없음
        if (role.equals("STUDENT")) departmentId = null;

        // STAFF는 담당부서 필수
        if (role.equals("STAFF") && departmentId == null) return FAIL;

        // 기존 사용자 정보 조회
        UserDTO user = adminDAO.adminFindUserById(userId);
        if (user == null) return 0;
        boolean sameRole = role.equals(user.getRole());     // 역할이 같은지
        boolean sameDepartment = (departmentId == null && user.getDepartmentId() == null)   // 같은 부서인지
                || (departmentId != null && departmentId.equals(user.getDepartmentId()));

        // 기존 role, departmentId와 같으면 변경 없음
        if (sameRole && sameDepartment) return NOCHG;

        int updatedRows = adminDAO.updateUserInfo(userId, role, departmentId);
        if (updatedRows == SUCC)  return SUCC;

        return FAIL;
    }

    // 민원 목록 조회
    public List<ComplaintDTO> findComplaints(Long departmentId, String category, String status, String searchType,
                                             String keyword, int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize <= 0) pageSize = 20;

        return adminDAO.adminFindComplaints(departmentId, category, status, searchType, keyword, page, pageSize);
    }

    // 민원 전체 개수
    public int countComplaints(Long departmentId, String category, String status, String searchType, String keyword) {
        return adminDAO.adminCountComplaints(departmentId, category, status, searchType, keyword);
    }

    // 민원 삭제
    public int deleteComplaint(Long complaintId) {
        if (complaintId == null || complaintId <= 0) return 0;  // 실패
        return adminDAO.adminDeleteComplaint(complaintId);
    }

}
