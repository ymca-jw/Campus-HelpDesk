package com.campus.dto;

import java.sql.Timestamp;

public class ComplaintDTO {
    private Long complaintId;           // 민원 ID
    private Long writerId;              // 작성자(유저) ID
    private Long departmentId;          // 부서 ID
    private String category;            // 카테고리
    private String title;               // 제목
    private String content;             // 내용
    private String status;              // 상태(보류, 완료 등)
    private int likeCount;              // 추천수
    private boolean privateFlag;        // 비공개 여부
    private Timestamp createdAt;        // 작성 날짜
    private Timestamp updatedAt;        // 수정 날짜
    private Timestamp completedAt;      // 완료 날짜

    // JOIN 결과 표시용
    private String writerName;
    private String departmentName;

    public Long getComplaintId() {
        return complaintId;
    }
    public void setComplaintId(Long complaintId) {
        this.complaintId = complaintId;
    }
    public Long getWriterId() {
        return writerId;
    }
    public void setWriterId(Long writerId) {
        this.writerId = writerId;
    }
    public Long getDepartmentId() {
        return departmentId;
    }
    public void setDepartmentId(Long departmentId) {
        this.departmentId = departmentId;
    }
    public String getCategory() {
        return category;
    }
    public void setCategory(String category) {
        this.category = category;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public int getLikeCount() {
        return likeCount;
    }
    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }
    public boolean isPrivateFlag() {
        return privateFlag;
    }
    public void setPrivateFlag(boolean privateFlag) {
        this.privateFlag = privateFlag;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    public Timestamp getCompletedAt() {
        return completedAt;
    }
    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }
    public String getWriterName() {
        return writerName;
    }
    public void setWriterName(String writerName) {
        this.writerName = writerName;
    }
    public String getDepartmentName() {
        return departmentName;
    }
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
}