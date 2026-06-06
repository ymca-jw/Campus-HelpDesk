package com.campus.dao;

import com.campus.dto.AttachmentDTO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.FaqDTO;
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

    // 민원 목록 조회 필터, 검색, 페이징
    public List<ComplaintDTO> findByWriterId(Long writerId) {
        List<ComplaintDTO> complaints = new ArrayList<>();

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
            WHERE c.writer_id = ?
            ORDER BY c.created_at DESC
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, writerId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("내가 작성한 민원 조회 중 오류가 발생했습니다.", e);
        }

        return complaints;
    }

    public List<ComplaintDTO> findLikedByUserId(Long userId) {
        List<ComplaintDTO> complaints = new ArrayList<>();

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
            FROM complaint_likes cl
            JOIN complaints c ON cl.complaint_id = c.complaint_id
            JOIN departments d ON c.department_id = d.department_id
            JOIN users u ON c.writer_id = u.user_id
            WHERE cl.user_id = ?
            ORDER BY cl.created_at DESC
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("내가 추천한 민원 조회 중 오류가 발생했습니다.", e);
        }

        return complaints;
    }

    public List<ComplaintDTO> findComplaints(String departmentType, Long departmentId, String category, String status,
                                             String searchType, String keyword, String likeSort,
                                             String myFilter, Long userId, int page, int pageSize) {

        List<ComplaintDTO> complaints = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
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
            WHERE 1 = 1
            """);

        List<Object> params = new ArrayList<>();

        applyMyFilter(sql, params, myFilter, userId);

        if (departmentType != null && !departmentType.isBlank()) {
            sql.append(" AND d.type = ? ");
            params.add(departmentType);
        }

        if (departmentId != null && departmentId > 0) {
            sql.append(" AND c.department_id = ? ");
            params.add(departmentId);
        }

        if (category != null && !category.isBlank()) {
            sql.append(" AND c.category = ? ");
            params.add(category);
        }

        if ("PENDING".equals(status)) {
            sql.append(" AND c.status IN ('RECEIVED', 'REVIEWING', 'PROCESSING') ");
        }
        else if (status != null && !status.isBlank()) {
            sql.append(" AND c.status = ? ");
            params.add(status);
        }

        if (keyword != null && !keyword.isBlank()) {
            if ("title".equals(searchType)) {
                sql.append(" AND c.title LIKE ? ");
                params.add("%" + keyword.trim() + "%");
            } else if ("content".equals(searchType)) {
                sql.append(" AND c.content LIKE ? ");
                params.add("%" + keyword.trim() + "%");
            }
        }

        if ("asc".equals(likeSort)) {
            sql.append(" ORDER BY c.like_count ASC, c.created_at DESC ");
        } else if ("desc".equals(likeSort)) {
            sql.append(" ORDER BY c.like_count DESC, c.created_at DESC ");
        } else {
            sql.append(" ORDER BY c.created_at DESC ");
        }
        sql.append(" LIMIT ? OFFSET ? ");

        int offset = (page - 1) * pageSize;
        params.add(pageSize);
        params.add(offset);

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())
        ) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapRow(rs));
                }
            }
        }
        catch (SQLException e) {
            throw new RuntimeException("민원 목록 검색 중 오류가 발생했습니다.", e);
        }

        return complaints;
    }

    public List<ComplaintDTO> findTopLikedComplaints(String departmentType, Long departmentId, String category,
                                                     String status, String searchType, String keyword,
                                                     String myFilter, Long userId, int limit) {

        List<ComplaintDTO> complaints = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
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
            WHERE 1 = 1
            """);

        List<Object> params = new ArrayList<>();

        applyMyFilter(sql, params, myFilter, userId);

        if (departmentType != null && !departmentType.isBlank()) {
            sql.append(" AND d.type = ? ");
            params.add(departmentType);
        }

        if (departmentId != null && departmentId > 0) {
            sql.append(" AND c.department_id = ? ");
            params.add(departmentId);
        }

        if (category != null && !category.isBlank()) {
            sql.append(" AND c.category = ? ");
            params.add(category);
        }

        if ("PENDING".equals(status)) {
            sql.append(" AND c.status IN ('RECEIVED', 'REVIEWING', 'PROCESSING') ");
        } else if (status != null && !status.isBlank()) {
            sql.append(" AND c.status = ? ");
            params.add(status);
        }

        if (keyword != null && !keyword.isBlank()) {
            if ("title".equals(searchType)) {
                sql.append(" AND c.title LIKE ? ");
                params.add("%" + keyword.trim() + "%");
            } else if ("content".equals(searchType)) {
                sql.append(" AND c.content LIKE ? ");
                params.add("%" + keyword.trim() + "%");
            }
        }

        sql.append(" ORDER BY c.like_count DESC, c.created_at DESC ");
        sql.append(" LIMIT ? ");
        params.add(limit);

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())
        ) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Top liked complaints query failed.", e);
        }

        return complaints;
    }

    // 민원 목록 개수 조회 - 필터/검색
    public int countComplaints(String departmentType, Long departmentId, String category, String status,
                               String searchType, String keyword, String myFilter, Long userId) {

        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) AS total_count
            FROM complaints c
            JOIN departments d ON c.department_id = d.department_id
            JOIN users u ON c.writer_id = u.user_id
            WHERE 1 = 1
            """);

        List<Object> params = new ArrayList<>();

        applyMyFilter(sql, params, myFilter, userId);

        if (departmentType != null && !departmentType.isBlank()) {
            sql.append(" AND d.type = ? ");
            params.add(departmentType);
        }

        if (departmentId != null && departmentId > 0) {
            sql.append(" AND c.department_id = ? ");
            params.add(departmentId);
        }

        if (category != null && !category.isBlank()) {
            sql.append(" AND c.category = ? ");
            params.add(category);
        }

        if ("PENDING".equals(status)) {
            sql.append(" AND c.status IN ('RECEIVED', 'REVIEWING', 'PROCESSING') ");
        } else if (status != null && !status.isBlank()) {
            sql.append(" AND c.status = ? ");
            params.add(status);
        }

        if (keyword != null && !keyword.isBlank()) {
            if ("title".equals(searchType)) {
                sql.append(" AND c.title LIKE ? ");
                params.add("%" + keyword.trim() + "%");
            } else if ("content".equals(searchType)) {
                sql.append(" AND c.content LIKE ? ");
                params.add("%" + keyword.trim() + "%");
            }
        }

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())
        ) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_count");
                }
            }
        }
        catch (SQLException e) {
            throw new RuntimeException("민원 목록 개수 조회 중 오류가 발생했습니다.", e);
        }

        return 0;
    }



    // 민원 상세 조회
    private void applyMyFilter(StringBuilder sql, List<Object> params, String myFilter, Long userId) {
        if (myFilter == null || myFilter.isBlank() || userId == null || userId <= 0) {
            return;
        }

        if ("written".equals(myFilter)) {
            sql.append(" AND c.writer_id = ? ");
            params.add(userId);
        } else if ("liked".equals(myFilter)) {
            sql.append("""
                 AND EXISTS (
                     SELECT 1
                     FROM complaint_likes cl
                     WHERE cl.complaint_id = c.complaint_id
                       AND cl.user_id = ?
                 )
                """);
            params.add(userId);
        }
    }

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


    // 유사민원 조회
    public List<ComplaintDTO> findSimilarComplaints(String searchText, String category, Long departmentId) {
        List<ComplaintDTO> complaints = new ArrayList<>();

        String sql = """
                SELECT
                    c.complaint_id,
                    c.writer_id,
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
                    c.completed_at,
                
                    MATCH(c.title, c.content) AGAINST (?) AS text_score,
                
                    (
                        MATCH(c.title, c.content) AGAINST (?)
                        + CASE WHEN c.department_id = ? THEN 3 ELSE 0 END
                        + CASE WHEN c.category = ? THEN 3 ELSE 0 END
                        + CASE WHEN c.status = 'COMPLETED' THEN 1 ELSE 0 END
                        + CASE
                            WHEN c.like_count >= 10 THEN 2
                            WHEN c.like_count >= 5 THEN 1
                            ELSE 0
                          END
                    ) AS final_score
                
                FROM complaints c
                LEFT JOIN departments d ON c.department_id = d.department_id
                
                WHERE MATCH(c.title, c.content) AGAINST (?)
                  AND c.is_private = 0
                
                ORDER BY final_score DESC, c.created_at DESC
                LIMIT 3
                """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            // 위 쿼리에서 (?) 자리에 들어갈 값
            pstmt.setString(1, searchText);
            pstmt.setString(2, searchText);
            pstmt.setLong(3, departmentId);
            pstmt.setString(4, category);
            pstmt.setString(5, searchText);

            try(ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ComplaintDTO complaint = new ComplaintDTO();

                    complaint.setComplaintId(rs.getLong("complaint_id"));
                    complaint.setWriterId(rs.getLong("writer_id"));
                    complaint.setDepartmentName(rs.getString("department_name"));
                    complaint.setDepartmentId(rs.getLong("department_id"));
                    complaint.setCategory(rs.getString("category"));
                    complaint.setTitle(rs.getString("title"));
                    complaint.setContent(rs.getString("content"));
                    complaint.setStatus(rs.getString("status"));
                    complaint.setLikeCount(rs.getInt("like_count"));
                    complaint.setPrivateFlag(rs.getBoolean("is_private"));
                    complaint.setCreatedAt(rs.getTimestamp("created_at"));
                    complaint.setUpdatedAt(rs.getTimestamp("updated_at"));
                    complaint.setCompletedAt(rs.getTimestamp("completed_at"));
                    complaint.setFinalScore(rs.getDouble("final_score"));

                    complaints.add(complaint);
                }
            }
        }
        catch (SQLException e) {
            throw new RuntimeException("유사 민원 조회 중 DB 오류가 발생했습니다.", e);
        }
        return complaints;

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
    // 1. 민원 등록 (Insert)
    public void insertComplaint(ComplaintDTO complaint) {
        String sql = """
            INSERT INTO complaints
            (writer_id, department_id, category, title, content, status, is_private)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, complaint.getWriterId());
            pstmt.setLong(2, complaint.getDepartmentId());
            pstmt.setString(3, complaint.getCategory());
            pstmt.setString(4, complaint.getTitle());
            pstmt.setString(5, complaint.getContent());
            pstmt.setString(6, complaint.getStatus());
            pstmt.setBoolean(7, complaint.isPrivateFlag());
            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("민원 등록 중 오류 발생", e);
        }
    }

    // 민원 등록 및 ID 반환 (Insert and Return ID)
    public Long insertComplaintAndReturnId(ComplaintDTO complaint) {
        String sql = """
            INSERT INTO complaints
            (writer_id, department_id, category, title, content, status, is_private)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            pstmt.setLong(1, complaint.getWriterId());
            pstmt.setLong(2, complaint.getDepartmentId());
            pstmt.setString(3, complaint.getCategory());
            pstmt.setString(4, complaint.getTitle());
            pstmt.setString(5, complaint.getContent());
            pstmt.setString(6, complaint.getStatus());
            pstmt.setBoolean(7, complaint.isPrivateFlag());

            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
            throw new RuntimeException("민원 등록 실패: ID를 가져올 수 없습니다.");

        } catch (SQLException e) {
            throw new RuntimeException("민원 등록 중 오류 발생", e);
        }
    }

    // 첨부파일 등록
    public void insertAttachment(AttachmentDTO attachment) {
        String sql = """
            INSERT INTO complaint_attachments
            (complaint_id, original_name, stored_name, file_size, content_type)
            VALUES (?, ?, ?, ?, ?)
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, attachment.getComplaintId());
            pstmt.setString(2, attachment.getOriginalName());
            pstmt.setString(3, attachment.getStoredName());
            pstmt.setLong(4, attachment.getFileSize());
            pstmt.setString(5, attachment.getContentType());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("첨부파일 등록 중 오류 발생", e);
        }
    }

    // 첨부파일 목록 조회 (민원 ID)
    public List<AttachmentDTO> findAttachmentsByComplaintId(Long complaintId) {
        List<AttachmentDTO> attachments = new ArrayList<>();
        String sql = """
            SELECT attachment_id, complaint_id, original_name, stored_name, file_size, content_type, created_at
            FROM complaint_attachments
            WHERE complaint_id = ?
            ORDER BY attachment_id ASC
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, complaintId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    AttachmentDTO dto = new AttachmentDTO();
                    dto.setAttachmentId(rs.getLong("attachment_id"));
                    dto.setComplaintId(rs.getLong("complaint_id"));
                    dto.setOriginalName(rs.getString("original_name"));
                    dto.setStoredName(rs.getString("stored_name"));
                    dto.setFileSize(rs.getLong("file_size"));
                    dto.setContentType(rs.getString("content_type"));
                    dto.setCreatedAt(rs.getTimestamp("created_at"));
                    attachments.add(dto);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("첨부파일 목록 조회 중 오류 발생", e);
        }
        return attachments;
    }

    // 첨부파일 단건 조회
    public AttachmentDTO findAttachmentById(Long attachmentId) {
        String sql = """
            SELECT attachment_id, complaint_id, original_name, stored_name, file_size, content_type, created_at
            FROM complaint_attachments
            WHERE attachment_id = ?
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, attachmentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    AttachmentDTO dto = new AttachmentDTO();
                    dto.setAttachmentId(rs.getLong("attachment_id"));
                    dto.setComplaintId(rs.getLong("complaint_id"));
                    dto.setOriginalName(rs.getString("original_name"));
                    dto.setStoredName(rs.getString("stored_name"));
                    dto.setFileSize(rs.getLong("file_size"));
                    dto.setContentType(rs.getString("content_type"));
                    dto.setCreatedAt(rs.getTimestamp("created_at"));
                    return dto;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("첨부파일 단건 조회 중 오류 발생", e);
        }
        return null;
    }

    // 첨부파일 개별 삭제
    public void deleteAttachmentById(Long attachmentId) {
        String sql = "DELETE FROM complaint_attachments WHERE attachment_id = ?";
        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, attachmentId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("첨부파일 삭제 중 오류 발생", e);
        }
    }

    // 2. 민원 수정 (Update)
    public void updateComplaint(ComplaintDTO complaint) {
        String sql = """
            UPDATE complaints
            SET department_id = ?,
                category = ?,
                title = ?,
                content = ?,
                is_private = ?
            WHERE complaint_id = ?
                AND writer_id = ?
                AND status = 'RECEIVED'
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, complaint.getDepartmentId());
            pstmt.setString(2, complaint.getCategory());
            pstmt.setString(3, complaint.getTitle());
            pstmt.setString(4, complaint.getContent());
            pstmt.setBoolean(5, complaint.isPrivateFlag());
            pstmt.setLong(6, complaint.getComplaintId());
            pstmt.setLong(7, complaint.getWriterId());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("민원 수정 중 오류 발생", e);
        }
    }

    // 3. 민원 삭제 (Delete)
    public void deleteComplaint(Long complaintId, Long writerId) {
        String sql = """
            DELETE FROM complaints
            WHERE complaint_id = ?
                AND writer_id = ?
                AND status = 'RECEIVED'
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, complaintId);
            pstmt.setLong(2, writerId);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("민원 삭제 중 오류 발생", e);
        }
    }
    // 부서 조회 (담당자)
    public List<ComplaintDTO> findByDepartmentId(Long departmentId) {
        List<ComplaintDTO> complaints = new ArrayList<>();

        String sql = """
            SELECT
                c.complaint_id,
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
            WHERE c.department_id = ?
            ORDER BY c.created_at DESC
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, departmentId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapRow(rs));
                }
            }

        }
        catch (SQLException e) {
            throw new RuntimeException("담당 부서 민원 목록 조회 중 오류가 발생했습니다.", e);
        }

        return complaints;
    }



    // 상태 업데이트 (담당자)
    public void updateStatus(Long complaintId, String status) {
        String sql = """
            UPDATE complaints
            SET status = ?
            WHERE complaint_id = ?
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setString(1, status);
            pstmt.setLong(2, complaintId);

            pstmt.executeUpdate();

        }
        catch (SQLException e) {
            throw new RuntimeException("민원 상태 변경 중 오류가 발생했습니다.", e);
        }
    }

    public int countByDepartmentAndStatus(Long departmentId, String status) {
        String sql = """
            SELECT COUNT(*) AS total_count
            FROM complaints
            WHERE department_id = ?
              AND status = ?
            """;

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setLong(1, departmentId);
            pstmt.setString(2, status);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_count");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("담당 부서 상태별 민원 수 조회 중 오류가 발생했습니다.", e);
        }

        return 0;
    }
}
