package com.campus.service;

import com.campus.dao.DepartmentDAO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.DepartmentDTO;

import java.util.List;

public class DepartmentService {
    private final DepartmentDAO departmentDAO =  new DepartmentDAO();

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
}
