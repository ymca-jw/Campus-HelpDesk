package com.campus.service;

import com.campus.dao.DepartmentDAO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.DepartmentDTO;

import java.util.List;

public class DepartmentService {
    private final DepartmentDAO departmentDAO =  new DepartmentDAO();
    private static final int NOCHG = 3; // 변경없음
    private static final int DUP = 2;   // 중복
    private static final int SUCC = 1;
    private static final int FAIL = 0;

    // 부서 목록 조회
    public List<DepartmentDTO> findAllDepartments() {
        return departmentDAO.findAll();
    }

    // ADMIN 부서 조회
    public List<DepartmentDTO> findAdminDepartments() {
        return departmentDAO.findAll().stream().filter(dept -> "ADMIN".equals(dept.getType())).toList();
    }

    // MAJOR 부서 조회
    public List<DepartmentDTO> findMajorDepartments(String name) {
        return departmentDAO.findAll().stream().filter(dept -> "MAJOR".equals(dept.getType())).toList();
    }

    // 부서 목록 조회 (필터, 검색용)
    public List<DepartmentDTO> findDepartments(String type, String keyword) {
        return departmentDAO.findDepartments(type, keyword);
    }

    // 부서 추가 (관리자)
    public int createDepartment(String name, String type) {
        if (name == null || name.isEmpty()) return FAIL;
        if (type == null || type.isEmpty()) return FAIL;
        name = name.trim();

        if (!type.equals("ADMIN") && !type.equals("MAJOR")) return FAIL;

        if (departmentDAO.existsByName(name)) return DUP;

        int result = departmentDAO.createDepartment(name, type);
        if (result == 1) return SUCC;

        return FAIL;
    }

    // 부서 추가 (관리자)
    public int updateDepartment(Long departmentId, String name, String type) {
        if (departmentId == null || departmentId <= 0) return FAIL;
        if (name == null || name.isBlank()) return FAIL;
        if (type == null || type.isBlank()) return FAIL;
        name = name.trim(); // 공백제거

        // ADMIN, MAJOR 2개 중 하나 아니면 x
        if (!type.equals("ADMIN") && !type.equals("MAJOR")) return FAIL;

        // department: 바꾸기 전 부서
        DepartmentDTO oldDepartment = departmentDAO.findById(departmentId);
        if (oldDepartment == null) return FAIL;

        boolean sameName = name.equals(oldDepartment.getName());    // 이름이 같은지
        boolean sameType = type.equals(oldDepartment.getType());    // type이 같은지
        if (sameName && sameType) return NOCHG; // 변경없음

        if (departmentDAO.existsByNameExceptId(name, departmentId)) return DUP;

        int updateRows = departmentDAO.updateDepartment(departmentId, name, type);
        if (updateRows == 1) return SUCC;

        return FAIL;
    }

}
