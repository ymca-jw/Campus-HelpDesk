package com.campus.dao;

import com.campus.dto.ComplaintDTO;
import com.campus.dto.DepartmentDTO;
import com.campus.dto.FaqDTO;
import com.campus.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FaqDAO {
    public List<FaqDTO> findSimilarFaqs(String searchText, String category, Long departmentId) {

        List<FaqDTO> faqs = new ArrayList<>();

        String sql = """
                SELECT
                    f.faq_id,
                    f.department_id,
                    d.name AS department_name,
                    f.category,
                    f.question,
                    f.answer,
                    f.created_at,
                    -- (?)와 FAQ의 question, answer에서 관련도 점수 계산 후 text_score에 저장
                    MATCH(f.question, f.answer) AGAINST (?) AS text_score,
                
                    (
                        MATCH(f.question, f.answer) AGAINST (?)
                        + CASE WHEN f.department_id = ? THEN 2 ELSE 0 END   -- 같은 부서면 +2점
                        + CASE WHEN f.category = ? THEN 2 ELSE 0 END        -- 같은 카테고리면 +2점
                    ) AS final_score
                FROM faq f
                -- department와 join (이름 뽑아내기 위해서)
                LEFT JOIN departments d ON f.department_id = d.department_id
                -- FAQ 중에서 검색어와 관련 있는 것만 가져오기
                WHERE MATCH(f.question, f.answer) AGAINST (?)
                ORDER BY final_score DESC   -- 최종 점수 내림차순
                LIMIT 3;    -- 3개만
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
                    FaqDTO faq = new FaqDTO();

                    faq.setFaqId(rs.getLong("faq_id"));
                    faq.setDepartmentId(rs.getLong("department_id"));
                    faq.setDepartmentName(rs.getString("department_name"));
                    faq.setCategory(rs.getString("category"));
                    faq.setQuestion(rs.getString("question"));
                    faq.setAnswer(rs.getString("answer"));
                    faq.setCreatedAt(rs.getTimestamp("created_at"));
                    faq.setFinalScore(rs.getInt("final_score"));
                    faqs.add(faq);
                }
            }
        }
        catch (SQLException e) {
            throw new RuntimeException("유사 FAQ 조회 중 DB 오류가 발생했습니다.", e);
        }
        return faqs;
    }
}
