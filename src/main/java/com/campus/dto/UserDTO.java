package com.campus.dto;

import java.sql.Timestamp;

public class UserDTO {
    private Long userId;            // 사용자 식별 ID
    private String loginId;         // 사용자 로그인 ID (이메일)
    private String password;        // 비밀번호
    private String name;            // 사용자 이름
    private String role;            // 역할
    private Long departmentId;      // 부서 (담당자, ADMIN용)
    private Timestamp createdAt;    // 날짜

    // JOIN 결과 표시용
    private String departmentName;

    public Long getUserId() {
        return userId;
    }
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    public String getLoginId() {
        return loginId;
    }
    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getRole() {
        return role;
    }
    public void setRole(String role) {
        this.role = role;
    }
    public Long getDepartmentId() {
        return departmentId;
    }
    public void setDepartmentId(Long departmentId) {
        this.departmentId = departmentId;
    }
    public String getDepartmentName() {
        return departmentName;
    }
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}