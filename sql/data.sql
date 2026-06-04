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
                                                                      ('student1', '1234', '홍길동', 'STUDENT', NULL),
                                                                      ('student2', '1234', '박길동', 'STUDENT', NULL),
                                                                      ('staff_it', '1234', '김전산', 'STAFF', 4),
                                                                      ('staff_facility', '1234', '김시설', 'STAFF', 5),
                                                                      ('staff_academic', '1234', '김학사', 'STAFF', 3),
                                                                      ('admin1', '1234', '김관리', 'ADMIN', NULL),
                                                                      ('student3', '1234', '이길동', 'STUDENT', NULL),
                                                                      ('student4', '1234', '박철수', 'STUDENT', NULL),
                                                                      ('student5', '1234', '안철수', 'STUDENT', NULL),
                                                                      ('staff_iphak', '1234', '김입학', 'STAFF', 4),
                                                                      ('student6', '1234', '김철수', 'STUDENT', NULL),
                                                                      ('student7', '1234', '배철수', 'STUDENT', NULL),
                                                                      ('admin2', '1234', '박관리', 'ADMIN', NULL),
                                                                      ('software', '1234', '김소웨', 'STAFF', 3),
                                                                      ('staff_iljari', '1234', '김일자', 'STAFF', 3),
                                                                      ('student8', '1234', '홍김전', 'STUDENT', NULL),
                                                                      ('student9', '1234', '이재명', 'STUDENT', NULL),
                                                                      ('student10', '1234', '김재명', 'STUDENT', NULL),
                                                                      ('student11', '1234', '박재명', 'STUDENT', NULL),
                                                                      ('student12', '1234', '윤석열', 'STUDENT', NULL),
                                                                      ('student13', '1234', '김석열', 'STUDENT', NULL),
                                                                      ('staff_haksul', '1234', '박학술', 'STAFF', 4),
                                                                      ('staff_sandam', '1234', '김상담', 'STAFF', 4),
                                                                      ('staff_kyomu', '1234', '김교무', 'STAFF', 4);



INSERT INTO complaints
(writer_id, department_id, category, title, content, status, like_count, is_private, created_at, completed_at)
VALUES
-- 교무과 department_id = 1
(1, 1, '교무학적', '휴학 신청 처리 상태 문의',
 '포털에서 휴학 신청을 했는데 처리 상태가 계속 접수 상태로 남아 있습니다. 승인 일정 확인 부탁드립니다.',
 'RECEIVED', 3, FALSE, NOW() - INTERVAL 28 DAY, NULL),

(2, 1, '수업', '수강정정 내역 반영 문의',
 '수강정정 기간에 변경한 과목이 아직 포털 시간표에 반영되지 않았습니다. 확인 부탁드립니다.',
 'COMPLETED', 6, FALSE, NOW() - INTERVAL 27 DAY, NOW() - INTERVAL 25 DAY),


-- 학생과 department_id = 2
(7, 2, '학생지원', '학생증 재발급 절차 문의',
 '학생증을 분실해서 재발급을 받고 싶습니다. 신청 방법과 수수료, 발급까지 걸리는 기간을 알고 싶습니다.',
 'RECEIVED', 4, FALSE, NOW() - INTERVAL 26 DAY, NULL),

(8, 2, '학생지원', '동아리 활동 공간 사용 문의',
 '동아리 회의와 연습을 위한 공간을 사용하고 싶습니다. 신청 방법과 주말 사용 가능 여부를 확인 부탁드립니다.',
 'REVIEWING', 6, FALSE, NOW() - INTERVAL 25 DAY, NULL),

(9, 2, '학생지원', '학생 복지 지원 프로그램 문의',
 '재학생 대상 복지 지원 프로그램이나 긴급 지원 제도가 있는지 문의드립니다. 신청 조건과 절차가 궁금합니다.',
 'COMPLETED', 8, FALSE, NOW() - INTERVAL 24 DAY, NOW() - INTERVAL 22 DAY),


-- 장학과 department_id = 3
(11, 3, '장학', '국가장학금 서류 제출 확인 요청',
 '국가장학금 관련 서류를 제출했는데 제출 완료 여부를 확인하고 싶습니다.',
 'REVIEWING', 5, FALSE, NOW() - INTERVAL 23 DAY, NULL),

(12, 3, '장학', '근로장학생 출근부 오류 문의',
 '근로장학생 출근부 입력 시간이 실제 근무 시간과 다르게 표시됩니다. 수정 가능한지 문의드립니다.',
 'PROCESSING', 7, FALSE, NOW() - INTERVAL 22 DAY, NULL),


-- 입학관리과 department_id = 4
(16, 4, '기타', '편입학 전형 일정 문의',
 '편입학 전형 일정과 제출 서류 안내를 확인하고 싶습니다. 홈페이지 공지 외 추가 안내가 있는지 궁금합니다.',
 'RECEIVED', 2, FALSE, NOW() - INTERVAL 21 DAY, NULL),

(17, 4, '기타', '입학 관련 증명서 발급 문의',
 '입학 관련 증명서 발급 방법과 방문 수령 가능 여부를 문의드립니다.',
 'COMPLETED', 4, FALSE, NOW() - INTERVAL 20 DAY, NOW() - INTERVAL 18 DAY),


-- 전산지원팀 department_id = 5
(18, 5, '전산', '실습실 와이파이가 자주 끊깁니다',
 '소프트웨어학과 실습실에서 와이파이 연결이 자주 끊깁니다. 수업 중 인터넷 접속이 불안정해서 실습 진행에 어려움이 있습니다.',
 'PROCESSING', 9, FALSE, NOW() - INTERVAL 19 DAY, NULL),

(19, 5, '전산', '학교 포털 로그인이 되지 않습니다',
 '학교 포털에 로그인하려고 하면 오류 메시지가 뜨고 접속이 되지 않습니다. 비밀번호를 변경해도 같은 문제가 발생합니다.',
 'RECEIVED', 5, FALSE, NOW() - INTERVAL 18 DAY, NULL),

(20, 5, '전산', 'Adobe 프로그램 사용 권한 문의',
 '디자인 및 실습 수업에서 Adobe 프로그램을 사용해야 하는데 학교 계정 인증이 되지 않습니다. 사용 권한 확인 부탁드립니다.',
 'COMPLETED', 12, FALSE, NOW() - INTERVAL 17 DAY, NOW() - INTERVAL 15 DAY),


-- 시설관리팀 department_id = 6
(21, 6, '시설', '강의실 에어컨이 작동하지 않습니다',
 '본관 302호 강의실 에어컨이 작동하지 않아 수업 중 매우 덥습니다. 점검 부탁드립니다.',
 'REVIEWING', 6, FALSE, NOW() - INTERVAL 16 DAY, NULL),

(1, 6, '시설', '화장실 세면대 누수 문제',
 '인문관 2층 화장실 세면대 아래에서 물이 계속 새고 있습니다. 바닥이 미끄러워 위험합니다.',
 'PROCESSING', 7, FALSE, NOW() - INTERVAL 15 DAY, NULL),


-- 학술정보관 department_id = 7
(2, 7, '기타', '도서 대출 연장 오류 문의',
 '도서관 홈페이지에서 대출 연장을 시도했는데 오류가 발생합니다. 반납 기한이 임박해 확인 부탁드립니다.',
 'RECEIVED', 3, FALSE, NOW() - INTERVAL 14 DAY, NULL),

(7, 7, '기타', '열람실 좌석 예약 시스템 문의',
 '학술정보관 열람실 좌석 예약이 정상적으로 되지 않습니다. 예약 후에도 좌석이 배정되지 않습니다.',
 'COMPLETED', 5, FALSE, NOW() - INTERVAL 13 DAY, NOW() - INTERVAL 11 DAY),


-- 학생상담센터 department_id = 8
(8, 8, '상담', '상담 신청 일정 변경 요청',
 '학생상담센터 상담을 신청했는데 개인 사정으로 일정을 변경하고 싶습니다. 가능한 시간 확인 부탁드립니다.',
 'RECEIVED', 1, TRUE, NOW() - INTERVAL 12 DAY, NULL),

(9, 8, '상담', '비대면 상담 가능 여부 문의',
 '상담센터 방문이 어려워 비대면 상담이 가능한지 문의드립니다. 가능한 방식과 신청 절차를 알고 싶습니다.',
 'REVIEWING', 2, TRUE, NOW() - INTERVAL 11 DAY, NULL),


-- 대학일자리플러스본부 department_id = 9
(11, 9, '취업', '이력서 첨삭 프로그램 신청 문의',
 '대학일자리플러스본부에서 진행하는 이력서 첨삭 프로그램 신청 방법과 일정이 궁금합니다.',
 'PROCESSING', 6, FALSE, NOW() - INTERVAL 10 DAY, NULL),

(12, 9, '취업', '현장실습 관련 상담 요청',
 '방학 중 현장실습 참여를 고민하고 있습니다. 신청 조건과 학점 인정 여부를 상담받고 싶습니다.',
 'COMPLETED', 9, FALSE, NOW() - INTERVAL 9 DAY, NOW() - INTERVAL 7 DAY),


-- 인권센터 department_id = 10
(16, 10, '인권', '강의 중 부적절한 발언 관련 상담 요청',
 '수업 중 불편함을 느낀 발언이 있어 상담을 받고 싶습니다. 비공개로 처리 부탁드립니다.',
 'REVIEWING', 0, TRUE, NOW() - INTERVAL 8 DAY, NULL),

(17, 10, '인권', '동아리 내 갈등 상담 문의',
 '동아리 활동 중 갈등이 발생해 중재나 상담을 받을 수 있는지 문의드립니다.',
 'RECEIVED', 1, TRUE, NOW() - INTERVAL 7 DAY, NULL),


-- 소프트웨어학과 department_id = 11
(18, 11, '수업', '전공 실습 과목 수강 인원 증원 요청',
 '소프트웨어학과 전공 실습 과목의 정원이 너무 적어 수강신청을 하지 못했습니다. 추가 증원이 가능한지 문의드립니다.',
 'REVIEWING', 7, FALSE, NOW() - INTERVAL 6 DAY, NULL),

(19, 11, '기타', '졸업 프로젝트 관련 안내 요청',
 '졸업 프로젝트 진행 방식과 팀 구성, 제출 일정에 대한 안내가 부족합니다. 자세한 공지가 필요합니다.',
 'RECEIVED', 3, FALSE, NOW() - INTERVAL 5 DAY, NULL),


-- 경영학부 department_id = 12
(20, 12, '수업', '경영학부 전공 과목 강의실 변경 요청',
 '수강 인원이 많은 전공 수업인데 강의실이 좁아 자리가 부족합니다. 더 큰 강의실로 변경 가능한지 문의드립니다.',
 'PROCESSING', 6, FALSE, NOW() - INTERVAL 4 DAY, NULL),

(21, 12, '교무학적', '복수전공 신청 관련 문의',
 '경영학부 복수전공 신청 조건과 제출 서류가 궁금합니다. 신청 기간과 심사 기준도 함께 안내 부탁드립니다.',
 'COMPLETED', 10, FALSE, NOW() - INTERVAL 3 DAY, NOW() - INTERVAL 2 DAY),


-- 공연예술학부 department_id = 13
(1, 13, '시설', '공연 연습실 음향 장비 점검 요청',
 '공연예술학부 연습실의 스피커와 마이크 상태가 좋지 않습니다. 수업과 연습에 지장이 있어 점검을 요청드립니다.',
 'REVIEWING', 8, FALSE, NOW() - INTERVAL 2 DAY, NULL),

(2, 13, '수업', '공연 실습 일정 공지 요청',
 '공연 실습 수업의 리허설 일정과 장소 공지가 늦어 준비에 어려움이 있습니다. 일정 안내를 조금 더 빨리 받을 수 있으면 좋겠습니다.',
 'RECEIVED', 2, FALSE, NOW() - INTERVAL 1 DAY, NULL);


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


