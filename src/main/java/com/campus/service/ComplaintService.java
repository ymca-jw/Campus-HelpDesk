package com.campus.service;

import com.campus.dao.AnswerDAO;
import com.campus.dao.ComplaintDAO;
import com.campus.dto.AnswerDTO;
import com.campus.dto.ComplaintDTO;

import java.util.List;

public class ComplaintService {

    private final ComplaintDAO complaintDAO =  new ComplaintDAO();
    private final AnswerDAO answerDAO = new AnswerDAO(); // 담당자 답변용

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

    // 1. 민원 등록
    public void createComplaint(ComplaintDTO dto) {
        dto.setWriterId(1L); // TODO: 로그인 세션
        dto.setStatus("RECEIVED");
        complaintDAO.insertComplaint(dto);
    }

    // 2. 민원 수정
    public void updateComplaint(ComplaintDTO dto) {
        complaintDAO.updateComplaint(dto);
    }

    // 3. 민원 삭제
    public void deleteComplaint(Long complaintId) {
        complaintDAO.deleteComplaint(complaintId);
    }
    // 4. 부서별 민원 목록 조회 (대시보드)
    public List<ComplaintDTO> findComplaintsByDepartment(Long departmentId) {
        return complaintDAO.findByDepartmentId(departmentId);
    }

    // 5. 답변 등록 및 민원 상태 변경
    public void registerAnswer(AnswerDTO answerDTO) {
        // 1. 답변을 DB에 저장합니다.
        answerDAO.insertAnswer(answerDTO); 
        // 2. 해당 민원의 상태를 '답변 완료(COMPLETED)'로 바꿔줍니다.
        complaintDAO.updateStatus(answerDTO.getComplaintId(), "COMPLETED"); 
    }
    // 6. 민원 상세 보기할 때 답변도 같이 가져오기
    public AnswerDTO findAnswer(Long complaintId) {
        return answerDAO.findByComplaintId(complaintId);
    }
    // 7. 답변 수정
    public void modifyAnswer(AnswerDTO answer) {
        answerDAO.updateAnswer(answer);
    }

    // 8. 답변 삭제 (삭제 후 민원 상태를 다시 RECEIVED로 변경)
    public void removeAnswer(Long answerId, Long complaintId) {
        answerDAO.deleteAnswer(answerId);
        complaintDAO.updateStatus(complaintId, "RECEIVED"); 
    }
}