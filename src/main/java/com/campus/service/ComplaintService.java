package com.campus.service;

import com.campus.dao.ComplaintDAO;
import com.campus.dao.ComplaintLikeDAO;
import com.campus.dao.StatusHistoryDAO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.StatusHistoryDTO;
import java.util.List;

public class ComplaintService {

    private final ComplaintDAO complaintDAO =  new ComplaintDAO();
    private final ComplaintLikeDAO complaintLikeDAO = new ComplaintLikeDAO();
    private final StatusHistoryDAO statusHistoryDAO = new StatusHistoryDAO();

    // 민원 목록
    public List<ComplaintDTO> findComplaintList() {
        return complaintDAO.findAll();
    }

    // 민원 목록 조회 - 필터/검색/페이징
    public List<ComplaintDTO> findComplaintList(String departmentType, Long departmentId, String category,
                                                String status, String searchType, String keyword, String likeSort,
                                                int page, int pageSize) {

        return complaintDAO.findComplaints(departmentType, departmentId, category, status, searchType, keyword,
                likeSort, page, pageSize);
    }

    // 민원 목록 개수 조회 - 필터/검색
    public int countComplaintList(String departmentType, Long departmentId, String category, String status,
                                  String searchType, String keyword) {

        return complaintDAO.countComplaints(departmentType, departmentId, category, status, searchType, keyword);
    }

    public List<ComplaintDTO> findTopLikedComplaintList(String departmentType, Long departmentId, String category,
                                                        String status, String searchType, String keyword) {

        return complaintDAO.findTopLikedComplaints(departmentType, departmentId, category, status, searchType, keyword, 3);
    }


    // 민원 상세
    public ComplaintDTO findComplaintDetail(Long complaintId) {
        if (complaintId == null || complaintId <= 0) {
            return null;
        }
        return complaintDAO.findById(complaintId);
    }

    // 1. 민원 등록
    public void createComplaint(ComplaintDTO dto) {
        if (dto == null) {
            return;
        }

        // TODO: 로그인 기능 완성 후 session의 loginUser.getUserId()로 변경
        dto.setWriterId(1L);

        // 신규 민원 기본 상태
        dto.setStatus("RECEIVED");
        complaintDAO.insertComplaint(dto);
    }

    // 2. 민원 수정
    public void updateComplaint(ComplaintDTO dto) {
        if (dto == null) {
            return;
        }

        if (dto.getComplaintId() == null || dto.getComplaintId() <= 0) {
            return;
        }

        // TODO: 로그인 기능 완성 후 작성자 본인인지 확인
        dto.setWriterId(1L);

        // TODO: 가능하면 RECEIVED 상태에서만 수정 가능하게 제한

        complaintDAO.updateComplaint(dto);
    }

    // 3. 민원 삭제
    public void deleteComplaint(Long complaintId, Long writerId) {
        if (complaintId == null || complaintId <= 0) {
            return;
        }

        // TODO: 로그인 기능 완성 후 작성자 본인인지 확인
        // TODO: 가능하면 RECEIVED 상태에서만 삭제 가능하게 제한

        complaintDAO.deleteComplaint(complaintId,  writerId);
    }

    // 1: success, 2: duplicate, 0: fail
    public int likeComplaint(Long complaintId, Long userId) {
        if (complaintId == null || complaintId <= 0) {
            return 0;
        }

        if (userId == null || userId <= 0) {
            return 0;
        }

        return complaintLikeDAO.insertLikeAndIncreaseCount(complaintId, userId);
    }

    public boolean isLikedByUser(Long complaintId, Long userId) {
        if (complaintId == null || complaintId <= 0) {
            return false;
        }

        if (userId == null || userId <= 0) {
            return false;
        }

        return complaintLikeDAO.existsByComplaintIdAndUserId(complaintId, userId);
    }

    public List<StatusHistoryDTO> findStatusHistories(Long complaintId) {
        if (complaintId == null || complaintId <= 0) {
            return List.of();
        }

        return statusHistoryDAO.findByComplaintId(complaintId);
    }


}
