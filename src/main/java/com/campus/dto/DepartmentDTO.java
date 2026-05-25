package com.campus.dto;

import java.sql.Timestamp;

public class DepartmentDTO {
    private Long departmentId;      // 식별 id
    private String name;            // 부서 이름
    private String type;            // 부서 타입
    private Timestamp createdAt;    // 시간

    public Long getDepartmentId() {
        return departmentId;
    }
    public void setDepartmentId(Long departmentId) {
        this.departmentId = departmentId;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
}
