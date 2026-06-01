package com.campus.service;

import com.campus.dto.ComplaintDTO;
import com.campus.dto.FaqDTO;

import java.util.List;

public class ComplaintCheckService {
    // 유사 민원
    public List<ComplaintDTO> findSimilarComplaints(ComplaintDTO complaintDTO) {
        // TODO: 유사민원 조회
    }

    // FAQ
    public List<FaqDTO> findSimilarFaqs(ComplaintDTO complaintDTO) {
        // TODO: FAQ 조회 로직 구현
    }
}
