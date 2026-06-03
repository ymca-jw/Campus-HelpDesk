package com.campus.dao;

import com.campus.dto.DepartmentDTO;
import com.campus.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
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


    // 부서 필터, 검색 용 (관리자)
    public List<DepartmentDTO> findDepartments(String type, String keyword) {
        List<DepartmentDTO> departments = new ArrayList<>();

        boolean hasType = type != null && !type.isBlank();  // type
        boolean hasKeyword = keyword != null && !keyword.isBlank();     // keyword

        StringBuilder sql = new StringBuilder("""
            SELECT
                department_id,
                name,
                type,
                created_at
            FROM departments
            WHERE 1 = 1
            """);

        if (hasType) {
            sql.append(" AND type = ? ");
        }

        if (hasKeyword) {
            sql.append(" AND name LIKE ? ");
        }

        sql.append(" ORDER BY type ASC, department_id ASC ");

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())
        ) {
            int index = 1;
            if (hasType) {
                pstmt.setString(index++, type);
            }

            if (hasKeyword) {
                pstmt.setString(index++, "%" + keyword.trim() + "%");
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    DepartmentDTO department = new DepartmentDTO();

                    department.setDepartmentId(rs.getLong("department_id"));
                    department.setName(rs.getString("name"));
                    department.setType(rs.getString("type"));
                    department.setCreatedAt(rs.getTimestamp("created_at"));

                    departments.add(department);
                }
            }

        }
        catch (SQLException e) {
            throw new RuntimeException("부서 목록 조회 중 오류가 발생했습니다.", e);
        }

        return departments;
    }

    // 부서 추가 (관리자 용)
    public int createDepartment(String name, String type) {
        String sql = """
                INSERT INTO departments (name, type, created_at) VALUES (?, ?, NOW())
                """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())
        ) {
            pstmt.setString(1, name);
            pstmt.setString(2, type);

            return pstmt.executeUpdate();
        }
        catch (SQLException e) {
            throw new RuntimeException("부서 추가 중 DB 오류가 발생했습니다.", e);
        }
    }

    // 부서명 중복 확인 (관리자)
    public boolean existsByName(String name) {
        String sql = """
            SELECT COUNT(*) AS count
            FROM departments
            WHERE name = ?
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setString(1, name);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }

        }
        catch (SQLException e) {
            throw new RuntimeException("부서명 중복 확인 중 DB 오류가 발생했습니다.", e);
        }

        return false;
    }

    // 부서 단건 조회 (관리자)
    public DepartmentDTO findById(long departmentId) {
        String sql = """
            SELECT
                department_id,
                name,
                type,
                created_at
            FROM departments
            WHERE department_id = ?
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, departmentId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    DepartmentDTO department = new DepartmentDTO();

                    department.setDepartmentId(rs.getLong("department_id"));
                    department.setName(rs.getString("name"));
                    department.setType(rs.getString("type"));
                    department.setCreatedAt(rs.getTimestamp("created_at"));

                    return department;
                }
            }
        }
        catch (SQLException e) {
            throw new RuntimeException("부서 단건 조회 중 오류가 발생했습니다.", e);
        }

        return null;
    }

    // 자신을 제외한 부서명 중복 확인 (관리자)
    public boolean existsByNameExceptId(String name, Long departmentId) {
        String sql = """
            SELECT COUNT(*) AS count
            FROM departments
            WHERE name = ?
              AND department_id <> ?
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setString(1, name);
            pstmt.setLong(2, departmentId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        }
        catch (SQLException e) {
            throw new RuntimeException("부서명 중복 확인 중 오류가 발생했습니다.", e);
        }

        return false;
    }

    // 부서 업데이트 (관리자)
    public int updateDepartment(Long departmentId, String name, String type) {
        String sql = """
                UPDATE departments
                SET name = ?, type = ?
                WHERE department_id = ?
                """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setString(1, name);
            pstmt.setString(2, type);
            pstmt.setLong(3, departmentId);

            return pstmt.executeUpdate();

        }
        catch (SQLException e) {
            throw new RuntimeException("부서 수정 중 오류가 발생했습니다.", e);
        }
    }
}
