package com.campus.dto;

import java.sql.Timestamp;

public class StatusHistoryDTO {
    private Long historyId;
    private Long complaintId;       // 민원 ID
    private Long changedBy;         // 변경한 이
    private String prevStatus;      // 이전 상태
    private String newStatus;       // 변경 후 상태
    private String reason;          // 이유
    private Timestamp createdAt;    // 날짜

    // JOIN 결과 표시용
    private String changedByName;

    public Long getHistoryId() {
        return historyId;
    }
    public void setHistoryId(Long historyId) {
        this.historyId = historyId;
    }
    public Long getComplaintId() {
        return complaintId;
    }
    public void setComplaintId(Long complaintId) {
        this.complaintId = complaintId;
    }
    public Long getChangedBy() {
        return changedBy;
    }
    public void setChangedBy(Long changedBy) {
        this.changedBy = changedBy;
    }
    public String getPrevStatus() {
        return prevStatus;
    }
    public void setPrevStatus(String prevStatus) {
        this.prevStatus = prevStatus;
    }
    public String getNewStatus() {
        return newStatus;
    }
    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }
    public String getReason() {
        return reason;
    }
    public void setReason(String reason) {
        this.reason = reason;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    public String getChangedByName() {
        return changedByName;
    }
    public void setChangedByName(String changedByName) {
        this.changedByName = changedByName;
    }
}