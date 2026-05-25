package com.campus.dto;

import java.sql.Timestamp;

public class ComplaintLikeDTO {
    private Long likeId;            // 추천 ID
    private Long complaintId;       // 민원 ID
    private Long userId;            // 유저 ID
    private Timestamp createdAt;    // 날짜

    public Long getLikeId() {
        return likeId;
    }
    public void setLikeId(Long likeId) {
        this.likeId = likeId;
    }
    public Long getComplaintId() {
        return complaintId;
    }
    public void setComplaintId(Long complaintId) {
        this.complaintId = complaintId;
    }
    public Long getUserId() {
        return userId;
    }
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}