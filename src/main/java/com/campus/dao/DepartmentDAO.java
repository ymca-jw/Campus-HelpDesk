package com.campus.dao;

import com.campus.dto.DepartmentDTO;
import com.campus.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO {

    // 전체 부서 목록 조회
    public List<DepartmentDTO> findAll() {
        List<DepartmentDTO> departments = new ArrayList<>();

        String sql = """
                SELECT department_id,
                       name,
                       type,
                       created_at
                FROM departments
                ORDER BY department_id ASC
                """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()

        ) {
            while(rs.next()) {
                DepartmentDTO department = new DepartmentDTO();

                department.setDepartmentId(rs.getLong("department_id"));
                department.setName(rs.getString("name"));
                department.setType(rs.getString("type"));
                department.setCreatedAt(rs.getTimestamp("created_at"));
                departments.add(department);
            }
        }
        catch (SQLException e) {
            throw new RuntimeException("부서 목록 조회 중 오류가 발생했습니다.", e);
        }

        return departments;
    }
}
