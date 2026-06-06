package com.campus.service;

import com.campus.dao.AnswerDAO;
import com.campus.dao.ComplaintDAO;
import com.campus.dao.ComplaintLikeDAO;
import com.campus.dao.StatusHistoryDAO;
import com.campus.dto.AttachmentDTO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.StatusHistoryDTO;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

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
                                                String myFilter, Long userId, int page, int pageSize) {

        return complaintDAO.findComplaints(departmentType, departmentId, category, status, searchType, keyword,
                likeSort, myFilter, userId, page, pageSize);
    }

    // 민원 목록 개수 조회 - 필터/검색
    public int countComplaintList(String departmentType, Long departmentId, String category, String status,
                                  String searchType, String keyword, String myFilter, Long userId) {

        return complaintDAO.countComplaints(departmentType, departmentId, category, status, searchType, keyword,
                myFilter, userId);
    }

    public List<ComplaintDTO> findTopLikedComplaintList(String departmentType, Long departmentId, String category,
                                                        String status, String searchType, String keyword,
                                                        String myFilter, Long userId) {

        return complaintDAO.findTopLikedComplaints(departmentType, departmentId, category, status, searchType, keyword,
                myFilter, userId, 3);
    }


    // 민원 상세
    public ComplaintDTO findComplaintDetail(Long complaintId) {
        if (complaintId == null || complaintId <= 0) {
            return null;
        }
        return complaintDAO.findById(complaintId);
    }

    public List<ComplaintDTO> findComplaintsByWriter(Long writerId) {
        if (writerId == null || writerId <= 0) {
            return List.of();
        }

        return complaintDAO.findByWriterId(writerId);
    }

    public List<ComplaintDTO> findLikedComplaintsByUser(Long userId) {
        if (userId == null || userId <= 0) {
            return List.of();
        }

        return complaintDAO.findLikedByUserId(userId);
    }

    // 1. 민원 등록
    public void createComplaint(ComplaintDTO dto) {
        if (dto == null) {
            return;
        }

        if (dto.getWriterId() == null || dto.getWriterId() <= 0) {
            return;
        }

        // 신규 민원 기본 상태
        dto.setStatus("RECEIVED");
        complaintDAO.insertComplaint(dto);
    }

    public Long createComplaintAndReturnId(ComplaintDTO dto) {
        if (dto == null || dto.getWriterId() == null || dto.getWriterId() <= 0) {
            return null;
        }

        dto.setStatus("RECEIVED");
        return complaintDAO.insertComplaintAndReturnId(dto);
    }

    // 첨부파일 저장
    public void saveAttachments(Long complaintId, List<Part> parts, String uploadDir) throws IOException {
        if (parts == null || parts.isEmpty()) return;

        File dir = new File(uploadDir + File.separator + complaintId);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        for (Part part : parts) {
            if (part == null || part.getSize() == 0 || part.getSubmittedFileName() == null || part.getSubmittedFileName().isBlank()) {
                continue;
            }

            String originalName = part.getSubmittedFileName();
            String ext = "";
            int dotIdx = originalName.lastIndexOf('.');
            if (dotIdx > 0) {
                ext = originalName.substring(dotIdx);
            }
            String storedName = UUID.randomUUID().toString() + ext;

            File saveFile = new File(dir, storedName);
            part.write(saveFile.getAbsolutePath());

            AttachmentDTO attachment = new AttachmentDTO();
            attachment.setComplaintId(complaintId);
            attachment.setOriginalName(originalName);
            attachment.setStoredName(storedName);
            attachment.setFileSize(part.getSize());
            attachment.setContentType(part.getContentType());

            complaintDAO.insertAttachment(attachment);
        }
    }

    public void insertAttachments(List<AttachmentDTO> attachments) {
        if (attachments == null || attachments.isEmpty()) return;
        for (AttachmentDTO att : attachments) {
            complaintDAO.insertAttachment(att);
        }
    }

    public List<AttachmentDTO> findAttachments(Long complaintId) {
        if (complaintId == null || complaintId <= 0) {
            return List.of();
        }
        return complaintDAO.findAttachmentsByComplaintId(complaintId);
    }

    public AttachmentDTO findAttachment(Long attachmentId) {
        if (attachmentId == null || attachmentId <= 0) {
            return null;
        }
        return complaintDAO.findAttachmentById(attachmentId);
    }

    public void deleteAttachment(Long attachmentId, String uploadDir) {
        AttachmentDTO attachment = findAttachment(attachmentId);
        if (attachment != null) {
            File file = new File(uploadDir + File.separator + attachment.getComplaintId(), attachment.getStoredName());
            if (file.exists()) {
                file.delete();
            }
            complaintDAO.deleteAttachmentById(attachmentId);
        }
    }

    public void deleteAttachmentFiles(Long complaintId, String uploadDir) {
        List<AttachmentDTO> attachments = findAttachments(complaintId);
        for (AttachmentDTO att : attachments) {
            File file = new File(uploadDir + File.separator + complaintId, att.getStoredName());
            if (file.exists()) {
                file.delete();
            }
        }
        File dir = new File(uploadDir + File.separator + complaintId);
        if (dir.exists()) {
            dir.delete();
        }
    }

    // 2. 민원 수정
    public void updateComplaint(ComplaintDTO dto) {
        if (dto == null) {
            return;
        }

        if (dto.getComplaintId() == null || dto.getComplaintId() <= 0) {
            return;
        }

        if (dto.getWriterId() == null || dto.getWriterId() <= 0) {
            return;
        }

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

    // 1: liked, 2: unliked, 0: fail
    public int toggleLikeComplaint(Long complaintId, Long userId) {
        if (complaintId == null || complaintId <= 0) {
            return 0;
        }

        if (userId == null || userId <= 0) {
            return 0;
        }

        if (complaintLikeDAO.existsByComplaintIdAndUserId(complaintId, userId)) {
            return complaintLikeDAO.deleteLikeAndDecreaseCount(complaintId, userId) == 1 ? 2 : 0;
        }

        return complaintLikeDAO.insertLikeAndIncreaseCount(complaintId, userId) == 1 ? 1 : 0;
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
