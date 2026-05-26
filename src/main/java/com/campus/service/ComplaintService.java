package com.campus.service;

import com.campus.dao.ComplaintDAO;
import com.campus.dto.ComplaintDTO;

import java.util.ArrayList;
import java.util.List;

public class ComplaintService {

    private final ComplaintDAO complaintDAO =  new ComplaintDAO();

    // 민원 목록
    public List<ComplaintDTO> findComplaintList() {
        return complaintDAO.findAll();
    }

    // 민원 상세
    public ComplaintDTO findComplaintDetail(Long complaintId) {
        if (complaintId == null || complaintId <= 0) {
            return null;
        }
        return complaintDAO.findById(complaintId);
    }
}
