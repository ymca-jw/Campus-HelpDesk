package com.campus.dao;

import com.campus.dto.DepartmentDTO;
import com.campus.dto.UserDTO;
import com.campus.util.DBUtil;
import java.sql.*;

public class UserDAO {

    public UserDTO findByLoginId(String loginId) {
        String sql = """
                SELECT u.user_id,
                       u.login_id,
                       u.password,
                       u.name,
                       u.role,
                       u.department_id,
                       d.name AS department_name,
                       u.created_at
                FROM users u
                LEFT JOIN departments d ON u.department_id = d.department_id
                WHERE u.login_id = ?""";

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setString(1, loginId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if(rs.next()) {
                    UserDTO user = new UserDTO();

                    user.setUserId(rs.getLong("user_id"));
                    user.setLoginId(rs.getString("login_id"));
                    user.setPassword(rs.getString("password"));
                    user.setName(rs.getString("name"));
                    user.setRole(rs.getString("role"));

                    Long departmentId = rs.getObject("department_id") == null ? null : rs.getLong("department_id");
                    user.setDepartmentId(departmentId);
                    user.setDepartmentName(rs.getString("department_name"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));

                    return user;
                }
            }
        }
        catch (SQLException e) {
            throw new RuntimeException("사용자 조회 중 오류가 발생했습니다.", e);
        }


        return null;
    }


    public boolean existsByLoginId(String loginId) {
        String sql = "SELECT COUNT(*) FROM users WHERE login_id = ?";

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setString(1, loginId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        catch (SQLException e) {
            throw new RuntimeException("아이디 중복 확인 중 오류가 발생했습니다.", e);
        }

        return false;
    }
}
