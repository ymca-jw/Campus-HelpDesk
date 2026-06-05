package com.campus.dao;

import com.campus.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;

public class ComplaintLikeDAO {

    // 1: success, 2: duplicate, 0: fail
    public int insertLikeAndIncreaseCount(Long complaintId, Long userId) {
        String insertSql = """
            INSERT INTO complaint_likes (complaint_id, user_id)
            VALUES (?, ?)
            """;

        String updateSql = """
            UPDATE complaints
            SET like_count = like_count + 1
            WHERE complaint_id = ?
            """;

        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
                pstmt.setLong(1, complaintId);
                pstmt.setLong(2, userId);
                pstmt.executeUpdate();
            }

            int updatedRows;
            try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                pstmt.setLong(1, complaintId);
                updatedRows = pstmt.executeUpdate();
            }

            if (updatedRows != 1) {
                conn.rollback();
                return 0;
            }

            conn.commit();
            return 1;
        } catch (SQLIntegrityConstraintViolationException e) {
            rollback(conn);

            if (e.getErrorCode() == 1062) {
                return 2;
            }

            return 0;
        } catch (SQLException e) {
            rollback(conn);
            throw new RuntimeException("Complaint like insert failed.", e);
        } finally {
            close(conn);
        }
    }

    public boolean existsByComplaintIdAndUserId(Long complaintId, Long userId) {
        String sql = """
            SELECT 1
            FROM complaint_likes
            WHERE complaint_id = ?
              AND user_id = ?
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, complaintId);
            pstmt.setLong(2, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Complaint like check failed.", e);
        }
    }

    // 1: success, 0: fail
    public int deleteLikeAndDecreaseCount(Long complaintId, Long userId) {
        String deleteSql = """
            DELETE FROM complaint_likes
            WHERE complaint_id = ?
              AND user_id = ?
            """;

        String updateSql = """
            UPDATE complaints
            SET like_count = CASE WHEN like_count > 0 THEN like_count - 1 ELSE 0 END
            WHERE complaint_id = ?
            """;

        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            int deletedRows;
            try (PreparedStatement pstmt = conn.prepareStatement(deleteSql)) {
                pstmt.setLong(1, complaintId);
                pstmt.setLong(2, userId);
                deletedRows = pstmt.executeUpdate();
            }

            if (deletedRows != 1) {
                conn.rollback();
                return 0;
            }

            int updatedRows;
            try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                pstmt.setLong(1, complaintId);
                updatedRows = pstmt.executeUpdate();
            }

            if (updatedRows != 1) {
                conn.rollback();
                return 0;
            }

            conn.commit();
            return 1;
        } catch (SQLException e) {
            rollback(conn);
            throw new RuntimeException("Complaint like delete failed.", e);
        } finally {
            close(conn);
        }
    }

    private void rollback(Connection conn) {
        if (conn == null) {
            return;
        }

        try {
            conn.rollback();
        } catch (SQLException ignored) {
        }
    }

    private void close(Connection conn) {
        if (conn == null) {
            return;
        }

        try {
            conn.setAutoCommit(true);
            conn.close();
        } catch (SQLException ignored) {
        }
    }
}
