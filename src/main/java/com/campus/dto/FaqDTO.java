package com.campus.dto;

import java.sql.Timestamp;

public class FaqDTO {
    private Long faqId;             // FAQ 식별 ID
    private Long departmentId;      // 부서 ID
    private String category;        // 카테고리
    private String question;        // FAQ 질문
    private String answer;          // FAQ 답변
    private Timestamp createdAt;    // 날짜

    // JOIN 결과 표시용
    private String departmentName;

    public Long getFaqId() {
        return faqId;
    }
    public void setFaqId(Long faqId) {
        this.faqId = faqId;
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
    public String getQuestion() {
        return question;
    }
    public void setQuestion(String question) {
        this.question = question;
    }
    public String getAnswer() {
        return answer;
    }
    public void setAnswer(String answer) {
        this.answer = answer;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    public String getDepartmentName() {
        return departmentName;
    }
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
}