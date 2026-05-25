package com.campus.dto;

import java.sql.Timestamp;

public class AnswerDTO {
    private Long answerId;          // 답변 ID
    private Long complaintId;       // 민원 ID
    private Long staffId;           // 유저(담당자) ID
    private String content;         // 내용
    private Timestamp createdAt;    // 날짜

    // JOIN 결과 표시용
    private String staffName;

    public Long getAnswerId() {
        return answerId;
    }
    public void setAnswerId(Long answerId) {
        this.answerId = answerId;
    }
    public Long getComplaintId() {
        return complaintId;
    }
    public void setComplaintId(Long complaintId) {
        this.complaintId = complaintId;
    }
    public Long getStaffId() {
        return staffId;
    }
    public void setStaffId(Long staffId) {
        this.staffId = staffId;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    public String getStaffName() {
        return staffName;
    }
    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }
}