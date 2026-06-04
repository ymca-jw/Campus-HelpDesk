package com.campus.dao;

import com.campus.dto.AnswerDTO;
import com.campus.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AnswerDAO {

    // 답변 등록
    public void insertAnswer(AnswerDTO answer) {
        String sql = """
                INSERT INTO answers
                (complaint_id, staff_id, content)
                VALUES (?, ?, ?)
                """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, answer.getComplaintId());
            pstmt.setLong(2, answer.getStaffId());
            pstmt.setString(3, answer.getContent());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("답변 등록 중 오류가 발생했습니다.", e);
        }
    }

    // 특정 민원의 답변 조회
    public AnswerDTO findByComplaintId(Long complaintId) {
        String sql = """
                SELECT
                    a.answer_id,
                    a.complaint_id,
                    a.staff_id,
                    u.name AS staff_name,
                    a.content,
                    a.created_at
                FROM answers a
                JOIN users u ON a.staff_id = u.user_id
                WHERE a.complaint_id = ?
                """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, complaintId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    AnswerDTO dto = new AnswerDTO();

                    dto.setAnswerId(rs.getLong("answer_id"));
                    dto.setComplaintId(rs.getLong("complaint_id"));
                    dto.setStaffId(rs.getLong("staff_id"));
                    dto.setStaffName(rs.getString("staff_name"));
                    dto.setContent(rs.getString("content"));
                    dto.setCreatedAt(rs.getTimestamp("created_at"));

                    return dto;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("답변 조회 중 오류가 발생했습니다.", e);
        }

        return null;
    }

    // 답변 수정
    public void updateAnswer(AnswerDTO answer) {
        String sql = """
                UPDATE answers
                SET content = ?
                WHERE answer_id = ?
                """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setString(1, answer.getContent());
            pstmt.setLong(2, answer.getAnswerId());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("답변 수정 중 오류가 발생했습니다.", e);
        }
    }

    // 답변 삭제
    public void deleteAnswer(Long answerId) {
        String sql = """
                DELETE FROM answers
                WHERE answer_id = ?
                """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, answerId);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("답변 삭제 중 오류가 발생했습니다.", e);
        }
    }
}