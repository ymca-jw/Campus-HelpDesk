package com.campus.service;

import com.campus.dao.FaqDAO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.FaqDTO;

import java.util.List;

public class ComplaintCheckService {

    private final FaqDAO faqDAO = new FaqDAO();

    // 유사 민원
    public List<ComplaintDTO> findSimilarComplaints(ComplaintDTO complaintDTO) {
        // TODO: 유사민원 조회

        return List.of();
    }

    // FAQ
    public List<FaqDTO> findSimilarFaqs(ComplaintDTO pendingComplaint) {
        String title = pendingComplaint.getTitle();
        String content = pendingComplaint.getContent();
        if  (title == null || content == null) {
            return null;
        }
        String searchText = title + " " + content;

        String category = pendingComplaint.getCategory();
        Long departmentId = pendingComplaint.getDepartmentId();
        return faqDAO.findSimilarFaqs(searchText, category, departmentId);
    }
}
