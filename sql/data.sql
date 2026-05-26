USE campus_helpdesk;

INSERT INTO departments (name, type) VALUES
                                         ('컴퓨터공학과', 'MAJOR'),
                                         ('경영학과', 'MAJOR'),
                                         ('학사행정팀', 'ADMIN'),
                                         ('전산지원팀', 'ADMIN'),
                                         ('시설관리팀', 'ADMIN'),
                                         ('학생지원팀', 'ADMIN');

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

INSERT INTO faq (department_id, category, question, answer) VALUES
                                                                (4, '전산', '학교 와이파이 연결 방법이 궁금합니다.', '학교 포털 계정으로 Wi-Fi에 로그인한 뒤 이용할 수 있습니다.'),
                                                                (4, '전산', '포털 로그인이 되지 않습니다.', '비밀번호를 재설정한 뒤에도 문제가 지속되면 전산지원팀에 문의해주세요.'),
                                                                (4, '전산', '실습실 PC 로그인이 되지 않습니다.', '포털 계정 상태를 확인한 뒤에도 로그인이 되지 않으면 전산지원팀에 문의해주세요.'),
                                                                (5, '시설', '강의실 시설 고장은 어디에 문의하나요?', '시설관리팀으로 민원을 접수하면 담당자가 확인 후 처리합니다.'),
                                                                (3, '학사', '수강신청 정정 기간은 어디서 확인하나요?', '학사 공지사항에서 수강신청 정정 기간을 확인할 수 있습니다.'),
                                                                (6, '장학', '장학금 신청 서류는 어디서 확인하나요?', '학생지원팀 공지사항 또는 장학 안내 페이지에서 확인할 수 있습니다.');

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