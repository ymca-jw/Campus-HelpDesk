package com.campus.dao;

import com.campus.dto.StatusHistoryDTO;
import com.campus.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StatusHistoryDAO {

    public void insertStatusHistory(StatusHistoryDTO statusHistory) {
        String sql = """
            INSERT INTO status_history
            (complaint_id, changed_by, prev_status, new_status, reason)
            VALUES (?, ?, ?, ?, ?)
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, statusHistory.getComplaintId());
            pstmt.setLong(2, statusHistory.getChangedBy());
            pstmt.setString(3, statusHistory.getPrevStatus());
            pstmt.setString(4, statusHistory.getNewStatus());
            pstmt.setString(5, statusHistory.getReason());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("상태 이력 등록 중 오류가 발생했습니다.", e);
        }
    }

    public List<StatusHistoryDTO> findByComplaintId(Long complaintId) {
        List<StatusHistoryDTO> histories = new ArrayList<>();

        String sql = """
            SELECT
                sh.history_id,
                sh.complaint_id,
                sh.changed_by,
                u.name AS changed_by_name,
                sh.prev_status,
                sh.new_status,
                sh.reason,
                sh.created_at
            FROM status_history sh
            JOIN users u ON sh.changed_by = u.user_id
            WHERE sh.complaint_id = ?
            ORDER BY sh.created_at DESC, sh.history_id DESC
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, complaintId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    StatusHistoryDTO dto = new StatusHistoryDTO();

                    dto.setHistoryId(rs.getLong("history_id"));
                    dto.setComplaintId(rs.getLong("complaint_id"));
                    dto.setChangedBy(rs.getLong("changed_by"));
                    dto.setChangedByName(rs.getString("changed_by_name"));
                    dto.setPrevStatus(rs.getString("prev_status"));
                    dto.setNewStatus(rs.getString("new_status"));
                    dto.setReason(rs.getString("reason"));
                    dto.setCreatedAt(rs.getTimestamp("created_at"));

                    histories.add(dto);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("상태 이력 조회 중 오류가 발생했습니다.", e);
        }

        return histories;
    }
}
