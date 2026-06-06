package com.campus.service;

import com.campus.dao.ComplaintDAO;
import com.campus.dao.FaqDAO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.FaqDTO;

import java.util.List;

public class ComplaintCheckService {

    private final FaqDAO faqDAO = new FaqDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    // 유사 민원
    public List<ComplaintDTO> findSimilarComplaints(ComplaintDTO pendingComplaint) {
        if (pendingComplaint == null) {
            return List.of();   // 빈 리스트
        }

        String title = pendingComplaint.getTitle();
        String content = pendingComplaint.getContent();
        if  (title == null || content == null) {
            return List.of();
        }

        String searchText = title + " " + content;
        if (searchText.isBlank()) {
            return List.of();
        }

        String category = pendingComplaint.getCategory();
        Long departmentId = pendingComplaint.getDepartmentId();

        return complaintDAO.findSimilarComplaints(searchText, category, departmentId);
    }

    // FAQ
    public List<FaqDTO> findSimilarFaqs(ComplaintDTO pendingComplaint) {
        if (pendingComplaint == null) {
            return List.of();   // 빈 리스트
        }

        String title = pendingComplaint.getTitle();
        String content = pendingComplaint.getContent();
        if  (title == null || content == null) {
            return List.of();
        }

        String searchText = title + " " + content;
        if (searchText.isBlank()) {
            return List.of();
        }

        String category = pendingComplaint.getCategory();
        Long departmentId = pendingComplaint.getDepartmentId();
        return faqDAO.findSimilarFaqs(searchText, category, departmentId);
    }
}
