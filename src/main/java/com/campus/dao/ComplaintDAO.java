package com.campus.dao;
import com.campus.dto.ComplaintDTO;
import com.campus.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class ComplaintDAO {

    // 민원 전체 목록 조회
    public List<ComplaintDTO> findAll() {

        // 민원 목록 담을 리스트
        List<ComplaintDTO> complaints = new ArrayList<>();

        // 민원 목록 조회 sql
        String sql = """
                SELECT c.complaint_id,
                       c.writer_id,
                       c.department_id,
                       d.name AS department_name,
                       u.name AS writer_name,
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
                JOIN departments d ON c.department_id = d.department_id
                JOIN users u ON c.writer_id = u.user_id
                ORDER BY c.created_at DESC""";

        try (
                Connection conn = DBUtil.getConnection();   // DBUtil로 DB 연결 객체 생성
                PreparedStatement pstmt = conn.prepareStatement(sql);   // SQL 실행할 psmt 생성
                ResultSet rs = pstmt.executeQuery()     // SELECT 쿼리 실행 결과를 rs로 받음

        ) {
            while(rs.next()) {   // 한 줄씩
                complaints.add(mapRow(rs)); // 한 줄을 ComplaintDTO로 변환
            }
        }
        catch (SQLException e) {    // 예외 처리
            throw new RuntimeException("민원 목록 조회 중 오류가 발생했습니다.", e);
        }

        return complaints;
    }


    // 민원 상세 조회
    public ComplaintDTO findById(Long complaintsId) {

        String sql = """        
                SELECT c.complaint_id,
                       c.writer_id,
                       c.department_id,
                       d.name AS department_name,
                       u.name AS writer_name,
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
                JOIN departments d ON c.department_id = d.department_id
                JOIN users u ON c.writer_id = u.user_id
                WHERE c.complaint_id = ?
                """;

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            // sql ? 자리에 complaintId 값 들어감
            pstmt.setLong(1, complaintsId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        catch (SQLException e) {
            throw new RuntimeException("민원 상세 조회 중 오류가 발생했습니다.", e);
        }

        return null;
    }


    // rs 한 줄을 ComplaintDTO 하나로 변환
    private ComplaintDTO mapRow(ResultSet rs) throws SQLException {
        ComplaintDTO complaint = new ComplaintDTO();

        complaint.setComplaintId(rs.getLong("complaint_id"));
        complaint.setWriterId(rs.getLong("writer_id"));
        complaint.setDepartmentId(rs.getLong("department_id"));
        complaint.setDepartmentName(rs.getString("department_name"));
        complaint.setWriterName(rs.getString("writer_name"));
        complaint.setCategory(rs.getString("category"));
        complaint.setTitle(rs.getString("title"));
        complaint.setContent(rs.getString("content"));
        complaint.setStatus(rs.getString("status"));
        complaint.setLikeCount(rs.getInt("like_count"));
        complaint.setPrivateFlag(rs.getBoolean("is_private"));
        complaint.setCreatedAt(rs.getTimestamp("created_at"));
        complaint.setUpdatedAt(rs.getTimestamp("updated_at"));
        complaint.setCompletedAt(rs.getTimestamp("completed_at"));

        return complaint;
    }
}
