package com.campus.service;

import com.campus.dao.AnswerDAO;
import com.campus.dao.ComplaintDAO;
import com.campus.dao.StatusHistoryDAO;
import com.campus.dto.AnswerDTO;
import com.campus.dto.ComplaintDTO;
import com.campus.dto.StatusHistoryDTO;

import java.util.List;

public class AnswerService {

    private final AnswerDAO answerDAO = new AnswerDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final StatusHistoryDAO statusHistoryDAO = new StatusHistoryDAO();

    // 담당 부서 민원 목록 조회
    public List<ComplaintDTO> findComplaintsByDepartment(Long departmentId) {
        if (departmentId == null || departmentId <= 0) {
            return List.of();
        }

        return complaintDAO.findByDepartmentId(departmentId);
    }

    // 답변 등록 및 민원 상태 변경
    public void registerAnswer(AnswerDTO answerDTO) {
        if (answerDTO == null) return;
        if (answerDTO.getComplaintId() == null || answerDTO.getComplaintId() <= 0) return;
        if (answerDTO.getStaffId() == null || answerDTO.getStaffId() <= 0) return;
        if (answerDTO.getContent() == null || answerDTO.getContent().isBlank()) return;

        answerDTO.setContent(answerDTO.getContent().trim());

        answerDAO.insertAnswer(answerDTO);

        changeComplaintStatus(answerDTO.getComplaintId(), "COMPLETED", answerDTO.getStaffId(), "답변 등록");
    }

    // 답변 조회
    public AnswerDTO findAnswer(Long complaintId) {
        if (complaintId == null || complaintId <= 0) {
            return null;
        }

        return answerDAO.findByComplaintId(complaintId);
    }

    // 답변 수정
    public void modifyAnswer(AnswerDTO answer) {
        if (answer == null) return;
        if (answer.getAnswerId() == null || answer.getAnswerId() <= 0) return;
        if (answer.getContent() == null || answer.getContent().isBlank()) return;

        answer.setContent(answer.getContent().trim());

        answerDAO.updateAnswer(answer);
    }

    // 답변 삭제
    public void removeAnswer(Long answerId, Long complaintId) {
        if (answerId == null || answerId <= 0) return;
        if (complaintId == null || complaintId <= 0) return;

        answerDAO.deleteAnswer(answerId);

        changeComplaintStatus(complaintId, "RECEIVED", 3L, "답변 삭제");
    }

    // 상태 변경
    public void updateComplaintStatus(Long complaintId, String status, Long changedBy) {
        if (complaintId == null || complaintId <= 0) return;
        if (status == null || status.isBlank()) return;
        if (changedBy == null || changedBy <= 0) return;

        if (!status.equals("RECEIVED")
                && !status.equals("REVIEWING")
                && !status.equals("PROCESSING")
                && !status.equals("COMPLETED")
                && !status.equals("REJECTED")) {
            return;
        }

        changeComplaintStatus(complaintId, status, changedBy, "담당자 상태 변경");
    }

    // 대시보드 상태별 개수
    public int countComplaintsByDepartmentAndStatus(Long departmentId, String status) {
        if (departmentId == null || departmentId <= 0) return 0;
        if (status == null || status.isBlank()) return 0;

        return complaintDAO.countByDepartmentAndStatus(departmentId, status);
    }

    // 민원 상세 (담당자)
    public ComplaintDTO findComplaintDetail(Long complaintId) {
        if (complaintId == null || complaintId <= 0) {
            return null;
        }

        return complaintDAO.findById(complaintId);
    }

    public List<StatusHistoryDTO> findStatusHistories(Long complaintId) {
        if (complaintId == null || complaintId <= 0) {
            return List.of();
        }

        return statusHistoryDAO.findByComplaintId(complaintId);
    }

    private void changeComplaintStatus(Long complaintId, String newStatus, Long changedBy, String reason) {
        ComplaintDTO complaint = complaintDAO.findById(complaintId);
        if (complaint == null) {
            return;
        }

        String prevStatus = complaint.getStatus();
        if (newStatus.equals(prevStatus)) {
            return;
        }

        complaintDAO.updateStatus(complaintId, newStatus);

        StatusHistoryDTO statusHistory = new StatusHistoryDTO();
        statusHistory.setComplaintId(complaintId);
        statusHistory.setChangedBy(changedBy);
        statusHistory.setPrevStatus(prevStatus);
        statusHistory.setNewStatus(newStatus);
        statusHistory.setReason(reason);

        statusHistoryDAO.insertStatusHistory(statusHistory);
    }
}
