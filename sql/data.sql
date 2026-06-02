USE campus_helpdesk;

INSERT INTO departments (department_id, name, type, created_at) VALUES
                                                                    (1, '교무과', 'ADMIN', NOW()),
                                                                    (2, '학생과', 'ADMIN', NOW()),
                                                                    (3, '장학과', 'ADMIN', NOW()),
                                                                    (4, '입학관리과', 'ADMIN', NOW()),
                                                                    (5, '전산지원팀', 'ADMIN', NOW()),
                                                                    (6, '시설관리팀', 'ADMIN', NOW()),
                                                                    (7, '학술정보관', 'ADMIN', NOW()),
                                                                    (8, '학생상담센터', 'ADMIN', NOW()),
                                                                    (9, '대학일자리플러스본부', 'ADMIN', NOW()),
                                                                    (10, '인권센터', 'ADMIN', NOW()),
                                                                    (11, '소프트웨어학과', 'MAJOR', NOW()),
                                                                    (12, '경영학부', 'MAJOR', NOW()),
                                                                    (13, '공연예술학부', 'MAJOR', NOW());

INSERT INTO users (login_id, password, name, role, department_id) VALUES
                                                                      ('student1', '1234', '학생1', 'STUDENT', NULL),
                                                                      ('student2', '1234', '학생2', 'STUDENT', NULL),
                                                                      ('staff_it', '1234', '전산담당자', 'STAFF', 4),
                                                                      ('staff_facility', '1234', '시설담당자', 'STAFF', 5),
                                                                      ('staff_academic', '1234', '학사담당자', 'STAFF', 3),
                                                                      ('admin', '1234', '관리자', 'ADMIN', NULL);

INSERT INTO complaints (
    writer_id,
    department_id,
    category,
    title,
    content,
    status,
    like_count,
    is_private
) VALUES
      (1, 4, '전산', '실습실 와이파이가 자주 끊깁니다', '컴퓨터공학과 실습실에서 와이파이가 자주 끊겨 수업 중 접속이 어렵습니다.', 'RECEIVED', 5, FALSE),
      (2, 5, '시설', '강의실 에어컨이 작동하지 않습니다', '강의실 에어컨이 켜지지 않아 수업 중 불편합니다.', 'PROCESSING', 12, FALSE),
      (1, 3, '학사', '수강신청 정정 기간 문의', '수강신청 정정 기간이 언제인지 알고 싶습니다.', 'COMPLETED', 3, FALSE),
      (2, 6, '장학', '장학금 서류 제출 문의', '장학금 신청 시 제출해야 하는 서류가 궁금합니다.', 'RECEIVED', 1, TRUE),
      (1, 4, '전산', '포털 로그인이 안 됩니다', '학교 포털에 로그인을 시도하면 계속 오류가 발생합니다.', 'REVIEWING', 7, FALSE);

INSERT INTO answers (complaint_id, staff_id, content) VALUES
                                                          (3, 5, '수강신청 정정 기간은 학사 공지사항에서 확인할 수 있습니다.'),
                                                          (2, 4, '시설관리팀에서 해당 강의실 에어컨 상태를 확인 중입니다.');

INSERT INTO status_history (
    complaint_id,
    changed_by,
    prev_status,
    new_status,
    reason
) VALUES
      (1, 1, NULL, 'RECEIVED', '민원이 접수되었습니다.'),
      (2, 2, NULL, 'RECEIVED', '민원이 접수되었습니다.'),
      (2, 4, 'RECEIVED', 'PROCESSING', '시설관리팀에서 처리 중입니다.'),
      (3, 1, NULL, 'RECEIVED', '민원이 접수되었습니다.'),
      (3, 5, 'RECEIVED', 'COMPLETED', '답변 완료 처리되었습니다.'),
      (4, 2, NULL, 'RECEIVED', '민원이 접수되었습니다.'),
      (5, 1, NULL, 'RECEIVED', '민원이 접수되었습니다.'),
      (5, 3, 'RECEIVED', 'REVIEWING', '전산지원팀 담당자가 확인 중입니다.');

INSERT INTO complaint_likes (complaint_id, user_id) VALUES
                                                        (1, 2),
                                                        (2, 1),
                                                        (3, 2),
                                                        (5, 2);


