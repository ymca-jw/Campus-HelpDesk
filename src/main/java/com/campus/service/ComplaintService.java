package com.campus.service;

import com.campus.dao.ComplaintDAO;
import com.campus.dto.ComplaintDTO;

import java.util.ArrayList;
import java.util.List;

public class ComplaintService {

    private final ComplaintDAO complaintDAO =  new ComplaintDAO();

    public List<ComplaintDTO> findComplaintList() {
        return complaintDAO.findAll();
    }
}
