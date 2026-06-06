package com.campus.dao;

import com.campus.dto.ComplaintDTO;
import com.campus.dto.UserDTO;
import com.campus.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class AdminDAO {
    // 전체 민원수
    public int countAllComplaints() {
        String sql = """
                SELECT COUNT(*) AS total_count FROM complaints
                """;
        return executeCountQuery(sql);
    }

    // 전체 사용자 수
    public int countAllUsers() {
        String sql = """
                SELECT COUNT(*) AS total_count FROM users
        """;
        return executeCountQuery(sql);
    }

    // 전체 담당자 수
    public int countStaffUsers() {
        String sql = """
                SELECT COUNT(*) AS total_count FROM users WHERE role = 'STAFF'
        """;
        return executeCountQuery(sql);
    }

    // 전체 관리자 수
    public int countAdminUsers() {
        String sql = """
                SELECT COUNT(*) AS total_count FROM users WHERE role = 'ADMIN'
        """;
        return executeCountQuery(sql);
    }

    // 쿼리 실행
    private int executeCountQuery(String sql) {
        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getInt("total_count");
            }

            return 0;
        } catch (SQLException e) {
            throw new RuntimeException("관리자 대시보드 통계 조회 중 DB 오류가 발생했습니다.", e);
        }
    }

    // 전체 사용자 목록 조회
    public List<UserDTO> findAllUsers() {
        List<UserDTO> users = new ArrayList<>();

        String sql = """
                SELECT
                    u.user_id,
                    u.login_id,
                    u.name,
                    u.role,
                    u.department_id,
                    d.name AS department_name,
                    u.created_at
                FROM users u
                LEFT JOIN departments d ON u.department_id = d.department_id
                ORDER BY u.created_at DESC
                """;
        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()
        ) {
            while (rs.next()) {
                UserDTO user = new UserDTO();

                user.setUserId(rs.getLong("user_id"));
                user.setLoginId(rs.getString("login_id"));
                user.setName(rs.getString("name"));
                user.setRole(rs.getString("role"));

                Long departmentId = rs.getLong("department_id");
                if (rs.wasNull()) user.setDepartmentId(null);
                else user.setDepartmentId(departmentId);

                user.setDepartmentName(rs.getString("department_name"));
                user.setCreatedAt(rs.getTimestamp("created_at"));

                users.add(user);
            }
        }
        catch (SQLException e) {
            throw new RuntimeException("전체 사용자 목록 조회 중 DB 오류가 발생했습니다.", e);
        }

        return users;

    }









    // 사용자 목록 조회 + 역할 필터 + 검색 + 페이징 (관리자)
    public List<UserDTO> adminFindUsers(String role, Long departmentId, String searchType, String keyword, int page, int pageSize) {
        List<UserDTO> users = new ArrayList<>();

        boolean hasRole = role != null && !role.isBlank();
        boolean hasDepartment = departmentId != null && departmentId > 0;
        boolean hasKeyword = keyword != null && !keyword.isBlank();

        int offset = (page - 1) * pageSize;

        StringBuilder sql = new StringBuilder("""
            SELECT
                u.user_id,
                u.login_id,
                u.name,
                u.role,
                u.department_id,
                d.name AS department_name,
                u.created_at
            FROM users u
            LEFT JOIN departments d ON u.department_id = d.department_id
            WHERE u.role <> 'ADMIN'
            """);

        if (hasRole) {
            sql.append(" AND u.role = ? ");
        }

        if (hasDepartment) {
            sql.append(" AND u.department_id = ? ");
        }

        if (hasKeyword) {
            if ("name".equals(searchType)) {
                sql.append(" AND u.name LIKE ? ");
            }
            else {
                sql.append(" AND u.login_id LIKE ? ");
            }
        }

        sql.append(" ORDER BY u.created_at DESC LIMIT ? OFFSET ? ");

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())
        ) {
            int index = 1;

            if (hasRole) pstmt.setString(index++, role);
            if (hasDepartment) pstmt.setLong(index++, departmentId);
            if (hasKeyword) pstmt.setString(index++, "%" + keyword.trim() + "%");

            pstmt.setInt(index++, pageSize);
            pstmt.setInt(index, offset);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    UserDTO user = new UserDTO();

                    user.setUserId(rs.getLong("user_id"));
                    user.setLoginId(rs.getString("login_id"));
                    user.setName(rs.getString("name"));
                    user.setRole(rs.getString("role"));

                    long userDepartmentId = rs.getLong("department_id");
                    if (rs.wasNull()) {
                        user.setDepartmentId(null);
                    }
                    else {
                        user.setDepartmentId(userDepartmentId);
                    }

                    user.setDepartmentName(rs.getString("department_name"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));

                    users.add(user);
                }
            }

        }
        catch (SQLException e) {
            throw new RuntimeException("사용자 목록 조회 중 DB 오류가 발생했습니다.", e);
        }

        return users;
    }

    // 사용자 검색 결과 전체 개수 조회
    public int adminCountUsers(String role, Long departmentId, String searchType, String keyword) {
        boolean hasRole = role != null && !role.isBlank();
        boolean hasDepartment = departmentId != null && departmentId > 0;
        boolean hasKeyword = keyword != null && !keyword.isBlank();

        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) AS total_count
            FROM users u
            LEFT JOIN departments d ON u.department_id = d.department_id
            WHERE 1 = 1
            """);

        if (hasRole) {
            sql.append(" AND u.role = ? ");
        }

        if (hasDepartment) {
            sql.append(" AND u.department_id = ? ");
        }

        if (hasKeyword) {
            if ("name".equals(searchType)) {
                sql.append(" AND u.name LIKE ? ");
            }
            else {
                sql.append(" AND u.login_id LIKE ? ");
            }
        }

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())
        ) {
            int index = 1;

            if (hasRole) {
                pstmt.setString(index++, role);
            }

            if (hasDepartment) {
                pstmt.setLong(index++, departmentId);
            }

            if (hasKeyword) {
                pstmt.setString(index++, "%" + keyword.trim() + "%");
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_count");
                }
            }

        }
        catch (SQLException e) {
            throw new RuntimeException("사용자 수 조회 중 DB 오류가 발생했습니다.", e);
        }

        return 0;
    }


    // 사용자 정보 수정 (관리자)
    public int updateUserInfo(Long userId, String role, Long departmentId) {
        String sql = """
                UPDATE users
                SET role = ?, department_id = ?
                WHERE user_id = ?
                """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setString(1, role);

            if (departmentId == null) {
                pstmt.setNull(2, java.sql.Types.BIGINT);
            }
            else {
                pstmt.setLong(2, departmentId);
            }
            pstmt.setLong(3, userId);

            return pstmt.executeUpdate();
        }
        catch (SQLException e) {
            throw new RuntimeException("사용자 정보 수정 중 DB 오류가 발생했습니다.", e);
        }
    }


    // 기존 사용자 조회 (관리자)
    public UserDTO adminFindUserById(Long userId) {
        String sql = """
            SELECT
                u.user_id,
                u.login_id,
                u.name,
                u.role,
                u.department_id,
                d.name AS department_name,
                u.created_at
            FROM users u
            LEFT JOIN departments d ON u.department_id = d.department_id
            WHERE u.user_id = ?
              AND u.role <> 'ADMIN'
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    UserDTO user = new UserDTO();

                    user.setUserId(rs.getLong("user_id"));
                    user.setLoginId(rs.getString("login_id"));
                    user.setName(rs.getString("name"));
                    user.setRole(rs.getString("role"));

                    long departmentId = rs.getLong("department_id");
                    if (rs.wasNull()) {
                        user.setDepartmentId(null);
                    } else {
                        user.setDepartmentId(departmentId);
                    }

                    user.setDepartmentName(rs.getString("department_name"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));

                    return user;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("사용자 단건 조회 중 DB 오류가 발생했습니다.", e);
        }

        return null;
    }

    // 민원 목록 조회, 필터, 검색, 페이징 (관리자)
    public List<ComplaintDTO> adminFindComplaints(Long departmentId, String category, String status, String searchType,
                                                  String keyword, int page, int pageSize) {
        List<ComplaintDTO> complaints = new ArrayList<>();
        boolean hasDepartment = departmentId != null && departmentId > 0;
        boolean hasCategory = category != null && !category.isBlank();
        boolean hasStatus = status != null && !status.isBlank();
        boolean hasKeyword = keyword != null && !keyword.isBlank();

        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder("""
            SELECT
                c.complaint_id,
                c.writer_id,
                u.name AS writer_name,
                c.department_id,
                d.name AS department_name,
                c.category,
                c.title,
                c.content,
                c.status,
                c.like_count,
                c.is_private,
                c.created_at,
                c.updated_at,
                c.completed_at
            FROM complaints c
            LEFT JOIN users u ON c.writer_id = u.user_id
            LEFT JOIN departments d ON c.department_id = d.department_id
            WHERE 1 = 1
            """);

        if (hasDepartment) sql.append(" AND c.department_id = ? ");
        if (hasCategory) sql.append(" AND c.category = ? ");
        if (hasStatus) sql.append(" AND c.status = ? ");
        if (hasKeyword) {
            if ("content".equals(searchType)) {
                sql.append(" AND c.content LIKE ? ");
            }
            else {
                // 기본값은 제목 검색
                sql.append(" AND c.title LIKE ? ");
            }
        }

        sql.append(" ORDER BY c.created_at DESC LIMIT ? OFFSET ? ");

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())
        ) {
            int index = 1;

            if (hasDepartment) {
                pstmt.setLong(index++, departmentId);
            }

            if (hasCategory) {
                pstmt.setString(index++, category);
            }

            if (hasStatus) {
                pstmt.setString(index++, status);
            }

            if (hasKeyword) {
                pstmt.setString(index++, "%" + keyword.trim() + "%");
            }

            pstmt.setInt(index++, pageSize);
            pstmt.setInt(index, offset);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ComplaintDTO complaint = new ComplaintDTO();

                    complaint.setComplaintId(rs.getLong("complaint_id"));
                    complaint.setWriterId(rs.getLong("writer_id"));
                    complaint.setWriterName(rs.getString("writer_name"));
                    complaint.setDepartmentId(rs.getLong("department_id"));
                    complaint.setDepartmentName(rs.getString("department_name"));
                    complaint.setCategory(rs.getString("category"));
                    complaint.setTitle(rs.getString("title"));
                    complaint.setContent(rs.getString("content"));
                    complaint.setStatus(rs.getString("status"));
                    complaint.setLikeCount(rs.getInt("like_count"));
                    complaint.setPrivateFlag(rs.getBoolean("is_private"));
                    complaint.setCreatedAt(rs.getTimestamp("created_at"));
                    complaint.setUpdatedAt(rs.getTimestamp("updated_at"));
                    complaint.setCompletedAt(rs.getTimestamp("completed_at"));

                    complaints.add(complaint);
                }
            }

        }
        catch (SQLException e) {
            throw new RuntimeException("관리자 민원 목록 조회 중 DB 오류가 발생했습니다.", e);
        }

        return complaints;
    }

    // 관리자 민원 목록 개수 조회
    public int adminCountComplaints(
            Long departmentId,
            String category,
            String status,
            String searchType,
            String keyword
    ) {
        boolean hasDepartment = departmentId != null && departmentId > 0;
        boolean hasCategory = category != null && !category.isBlank();
        boolean hasStatus = status != null && !status.isBlank();
        boolean hasKeyword = keyword != null && !keyword.isBlank();

        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) AS total_count
            FROM complaints c
            LEFT JOIN users u ON c.writer_id = u.user_id
            LEFT JOIN departments d ON c.department_id = d.department_id
            WHERE 1 = 1
            """);

        if (hasDepartment) sql.append(" AND c.department_id = ? ");
        if (hasCategory) sql.append(" AND c.category = ? ");
        if (hasStatus) sql.append(" AND c.status = ? ");


        if (hasKeyword) {
            if ("content".equals(searchType)) {
                sql.append(" AND c.content LIKE ? ");
            } else {
                sql.append(" AND c.title LIKE ? ");
            }
        }

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())
        ) {
            int index = 1;

            if (hasDepartment) pstmt.setLong(index++, departmentId);
            if (hasCategory) pstmt.setString(index++, category);
            if (hasStatus) pstmt.setString(index++, status);
            if (hasKeyword) pstmt.setString(index++, "%" + keyword.trim() + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_count");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("관리자 민원 개수 조회 중 DB 오류가 발생했습니다.", e);
        }

        return 0;
    }

    // 민원 삭제
    public int adminDeleteComplaint(Long complaintId) {
        String sql = """
                DELETE FROM complaints
                WHERE complaint_id = ?
                """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, complaintId);

            return pstmt.executeUpdate();   // 1: 삭제 성공, 0: 해당 complaint_id 없음

        }
        catch (SQLException e) {
            throw new RuntimeException("관리자 민원 삭제 중 DB 오류가 발생했습니다.", e);
        }
    }
}
