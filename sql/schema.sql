DROP TABLE IF EXISTS status_history;
DROP TABLE IF EXISTS complaint_likes;
DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS faq;
DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
                             department_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                             name VARCHAR(100) NOT NULL,
                             type VARCHAR(20) NOT NULL COMMENT 'MAJOR, ADMIN',
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                             CONSTRAINT chk_departments_type
                                 CHECK (type IN ('MAJOR', 'ADMIN'))
);

CREATE TABLE users (
                       user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                       login_id VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       name VARCHAR(50) NOT NULL,
                       role VARCHAR(20) NOT NULL COMMENT 'STUDENT, STAFF, ADMIN',
                       department_id BIGINT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                       CONSTRAINT chk_users_role
                           CHECK (role IN ('STUDENT', 'STAFF', 'ADMIN')),

                       CONSTRAINT fk_users_department
                           FOREIGN KEY (department_id)
                               REFERENCES departments(department_id)
                               ON DELETE SET NULL
                               ON UPDATE CASCADE
);

CREATE TABLE complaints (
                            complaint_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            writer_id BIGINT NOT NULL,
                            department_id BIGINT NOT NULL,
                            category VARCHAR(50) NOT NULL,
                            title VARCHAR(200) NOT NULL,
                            content TEXT NOT NULL,
                            status VARCHAR(20) NOT NULL DEFAULT 'RECEIVED' COMMENT 'RECEIVED, REVIEWING, PROCESSING, COMPLETED, REJECTED',
                            like_count INT NOT NULL DEFAULT 0,
                            is_private BOOLEAN NOT NULL DEFAULT FALSE,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                            completed_at TIMESTAMP NULL,

                            CONSTRAINT chk_complaints_status
                                CHECK (status IN ('RECEIVED', 'REVIEWING', 'PROCESSING', 'COMPLETED', 'REJECTED')),

                            CONSTRAINT chk_complaints_like_count
                                CHECK (like_count >= 0),

                            CONSTRAINT fk_complaints_writer
                                FOREIGN KEY (writer_id)
                                    REFERENCES users(user_id)
                                    ON DELETE CASCADE
                                    ON UPDATE CASCADE,

                            CONSTRAINT fk_complaints_department
                                FOREIGN KEY (department_id)
                                    REFERENCES departments(department_id)
                                    ON DELETE RESTRICT
                                    ON UPDATE CASCADE
);

CREATE TABLE answers (
                         answer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                         complaint_id BIGINT NOT NULL,
                         staff_id BIGINT NOT NULL,
                         content TEXT NOT NULL,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                         CONSTRAINT fk_answers_complaint
                             FOREIGN KEY (complaint_id)
                                 REFERENCES complaints(complaint_id)
                                 ON DELETE CASCADE
                                 ON UPDATE CASCADE,

                         CONSTRAINT fk_answers_staff
                             FOREIGN KEY (staff_id)
                                 REFERENCES users(user_id)
                                 ON DELETE CASCADE
                                 ON UPDATE CASCADE
);

CREATE TABLE complaint_likes (
                                 like_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                 complaint_id BIGINT NOT NULL,
                                 user_id BIGINT NOT NULL,
                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                                 CONSTRAINT uq_complaint_likes
                                     UNIQUE (complaint_id, user_id),

                                 CONSTRAINT fk_complaint_likes_complaint
                                     FOREIGN KEY (complaint_id)
                                         REFERENCES complaints(complaint_id)
                                         ON DELETE CASCADE
                                         ON UPDATE CASCADE,

                                 CONSTRAINT fk_complaint_likes_user
                                     FOREIGN KEY (user_id)
                                         REFERENCES users(user_id)
                                         ON DELETE CASCADE
                                         ON UPDATE CASCADE
);

CREATE TABLE faq (
                     faq_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                     department_id BIGINT NULL,
                     category VARCHAR(50) NOT NULL,
                     question VARCHAR(200) NOT NULL,
                     answer TEXT NOT NULL,
                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                     CONSTRAINT fk_faq_department
                         FOREIGN KEY (department_id)
                             REFERENCES departments(department_id)
                             ON DELETE SET NULL
                             ON UPDATE CASCADE
);

CREATE TABLE status_history (
                                history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                complaint_id BIGINT NOT NULL,
                                changed_by BIGINT NOT NULL,
                                prev_status VARCHAR(20) NULL COMMENT '이전 상태',
                                new_status VARCHAR(20) NOT NULL COMMENT '변경 상태',
                                reason VARCHAR(255) NULL COMMENT '변경 사유',
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                                CONSTRAINT chk_status_history_prev_status
                                    CHECK (
                                        prev_status IS NULL
                                            OR prev_status IN ('RECEIVED', 'REVIEWING', 'PROCESSING', 'COMPLETED', 'REJECTED')
                                        ),

                                CONSTRAINT chk_status_history_new_status
                                    CHECK (new_status IN ('RECEIVED', 'REVIEWING', 'PROCESSING', 'COMPLETED', 'REJECTED')),

                                CONSTRAINT fk_status_history_complaint
                                    FOREIGN KEY (complaint_id)
                                        REFERENCES complaints(complaint_id)
                                        ON DELETE CASCADE
                                        ON UPDATE CASCADE,

                                CONSTRAINT fk_status_history_changed_by
                                    FOREIGN KEY (changed_by)
                                        REFERENCES users(user_id)
                                        ON DELETE CASCADE
                                        ON UPDATE CASCADE
);

-- 조회 성능용 인덱스
CREATE INDEX idx_users_department_id
    ON users(department_id);

CREATE INDEX idx_complaints_writer_id
    ON complaints(writer_id);

CREATE INDEX idx_complaints_department_id
    ON complaints(department_id);

CREATE INDEX idx_complaints_status
    ON complaints(status);

CREATE INDEX idx_complaints_category
    ON complaints(category);

CREATE INDEX idx_complaints_like_count
    ON complaints(like_count);

CREATE INDEX idx_complaints_created_at
    ON complaints(created_at);

CREATE INDEX idx_answers_complaint_id
    ON answers(complaint_id);

CREATE INDEX idx_complaint_likes_user_id
    ON complaint_likes(user_id);

CREATE INDEX idx_faq_department_id
    ON faq(department_id);

CREATE INDEX idx_faq_category
    ON faq(category);

CREATE INDEX idx_status_history_complaint_id
    ON status_history(complaint_id);

CREATE INDEX idx_status_history_changed_by
    ON status_history(changed_by);
