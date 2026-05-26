# Campus-HelpDesk

JSP/Servlet 기반 학과·행정부서별 캠퍼스 민원 처리 시스템입니다.

---

## 1. 프로젝트 소개

Campus-HelpDesk는 학교 내에서 발생하는 학과 및 행정부서 관련 민원을 웹으로 등록하고 처리할 수 있도록 하는 민원 티켓 관리 시스템입니다.

학생은 민원을 등록하고 처리 상태를 확인할 수 있으며, 담당자는 자신이 맡은 부서의 민원에 답변하고 상태를 변경할 수 있습니다. 관리자는 전체 민원 현황과 통계를 확인할 수 있습니다.

본 프로젝트는 수업에서 학습한 JSP, Servlet, form action, request/response, session, sendRedirect, JDBC, DTO 개념을 기반으로 구현합니다.

다만 JSP 파일에 모든 로직을 작성하면 기능이 많아질수록 유지보수가 어려워지므로, Controller-Service-DAO-DTO 구조로 역할을 분리하여 구현합니다.

---

## 2. 주요 기능

### 회원 기능

- 회원가입
- 로그인
- 로그아웃
- 마이페이지
- 학생 / 담당자 / 관리자 권한 구분

### 민원 기능

- 민원 목록 조회
- 민원 상세 조회
- 민원 작성
- 민원 수정
- 민원 삭제
- 민원 추천
- 유사 민원 / FAQ 추천

### 담당자 기능

- 담당자 대시보드
- 담당 부서 민원 목록 조회
- 담당자 답변 작성
- 민원 상태 변경
- 상태 변경 이력 관리

### 관리자 기능

- 관리자 대시보드
- 전체 민원 관리
- 민원 통계 조회

---

## 3. 기술 스택

### Backend

- Java
- JSP / Servlet
- Jakarta Servlet API
- JDBC
- Maven

### Server

- Apache Tomcat 10.1.x

### Database

- MySQL

### Frontend

- HTML
- CSS
- JavaScript

### Collaboration

- Git
- GitHub

---

## 4. 프로젝트 구조

```text
Campus-HelpDesk
├─ src
│  └─ main
│     ├─ java
│     │  └─ com.campus
│     │     ├─ controller    클라이언트 요청을 처리하는 Servlet 계층
│     │     ├─ service       입력값 검증, 권한 확인, 주요 기능 흐름 처리 계층
│     │     ├─ dao           데이터베이스 접근 및 SQL 실행 계층
│     │     ├─ dto           계층 간 데이터 전달 객체
│     │     ├─ exception     프로젝트 전용 예외 처리 클래스
│     │     └─ util          DB 연결 등 공통 유틸리티 클래스
│     │
│     ├─ resources
│     │  ├─ db.properties.example
│     │  └─ db.properties
│     │
│     └─ webapp
│        ├─ assets
│        │  ├─ css
│        │  ├─ images
│        │  └─ js
│        │
│        ├─ WEB-INF
│        │  ├─ views
│        │  │  ├─ user
│        │  │  ├─ complaint
│        │  │  ├─ manager
│        │  │  ├─ admin
│        │  │  └─ error
│        │  └─ web.xml
│        │
│        └─ index.jsp
│
├─ sql
│  ├─ schema.sql
│  └─ data.sql
│
├─ pom.xml
├─ .gitignore
└─ README.md
```

---

## 5. URL 구조
### User (사용자)
```text
GET  /user/login       로그인 화면
POST /user/login       로그인 처리

GET  /user/register    회원가입 화면
POST /user/register    회원가입 처리

POST /user/logout      로그아웃
GET  /user/mypage      마이페이지
```

### Complaint (민원)
```text
GET  /complaints              민원 목록 조회
GET  /complaints/detail       민원 상세 조회

GET  /complaints/new          민원 작성 화면
POST /complaints/check        유사 민원 / FAQ 확인
POST /complaints/create       민원 등록 처리

GET  /complaints/edit         민원 수정 화면
POST /complaints/update       민원 수정 처리
POST /complaints/delete       민원 삭제 처리

POST /complaints/like         민원 추천
```

### Manager (담당자)
```text
GET  /manager/dashboard          담당자 대시보드
GET  /manager/complaint-manage   담당 부서 민원 목록

POST /manager/answer             담당자 답변 작성
POST /manager/status             민원 상태 변경
```

### Admin (관리자)
```text
GET /admin/dashboard              관리자 대시보드
GET /admin/complaints-management  전체 민원 관리
GET /admin/statistics             민원 통계
```

---

## 6. 사전 요구사항
프로젝트 실행을 위해 아래 환경이 필요합니다.

- JDK 17 이상 권장
- Apache Tomcat 10.1.x
- Maven
- MySQL

---

## 7. 설치 및 세팅
### 1. 저장소 Clone
```bash
git clone https://github.com/조직명/Campus-HelpDesk.git
cd Campus-HelpDesk
```


### 2. MySQL DB 생성
MySQL에서 데이터베이스를 생성합니다.
```SQL
CREATE DATABASE campus_helpdesk
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```
이후 아래 순서로 SQL을 실행합니다.
```text
1. sql/schema.sql
2. sql/data.sql      // 테스트 용 데이터셋
```


### 3. DB 설정 파일 생성
DB 접속 정보는 **db.properties** 파일에서 관리합니다. src/main/resources/db.properties.example 파일을 복사하여 **db.properties**를 생성합니다.
```text
src/main/resources/db.properties
```
예시:
```properties
db.url=jdbc:mysql://localhost:3306/campus_helpdesk?serverTimezone=Asia/Seoul&characterEncoding=UTF-8
db.username=root
db.password=본인 MySQL 비밀번호
```


### 4. Tomcat 설정
Tomcat 10.1.x를 설치한 뒤 IDE에 서버를 등록합니다.

### 4-1. Eclipse 기준

Eclipse에서는 Tomcat 서버를 먼저 등록합니다.

```text
Window
→ Preferences
→ Server
→ Runtime Environments
→ Add
→ Apache Tomcat v10.1 선택
→ Tomcat 설치 경로 지정
```

그다음 프로젝트를 서버에 추가합니다.

```text
Servers 탭
→ Tomcat v10.1 Server 우클릭
→ Add and Remove
→ Campus-HelpDesk 프로젝트 추가
→ Finish
```

서버를 실행합니다.

```text
Servers 탭
→ Tomcat v10.1 Server 우클릭
→ Start
```

Eclipse에서 실행할 경우 Context Path는 프로젝트 이름을 따라갈 수 있습니다.

예시:

```text
http://localhost:8080/Campus-HelpDesk/
http://localhost:8080/Campus-HelpDesk/complaints
```

만약 주소가 다르게 잡히면 Eclipse에서 아래 경로를 확인합니다.

```text
프로젝트 우클릭
→ Properties
→ Web Project Settings
→ Context root
```

Context root를 `Campus-HelpDesk`로 맞추면 위 주소와 동일하게 사용할 수 있습니다.

### 4-2. IntelliJ IDEA 기준

Tomcat 10.1.x를 설치한 뒤 IntelliJ에서 서버를 등록합니다.

```text
Run/Debug Configurations
→ Add New Configuration
→ Tomcat Server
→ Local
```

Application Server에 설치한 Tomcat 10 경로를 지정합니다.

그다음 Deployment를 설정합니다.

```text
Deployment
→ +
→ Artifact
→ Campus-HelpDesk:war exploded
```

Application Context는 예시로 아래와 같이 설정합니다.

```text
/Campus-HelpDesk
```

서버 실행 후 아래 주소로 접속해서 화면이 잘 뜨는지 확인합니다.

```text
http://localhost:8080/Campus-HelpDesk/
http://localhost:8080/Campus-HelpDesk/complaints
```
---

## 8. 개발 규칙
### Git Convention
| 타입         | 설명                                  |
| ---------- | ----------------------------------- |
| `feat`     | 새로운 기능 추가                           |
| `fix`      | 버그 수정                               |
| `docs`     | 문서 수정                               |
| `style`    | 코드 포맷팅, 세미콜론 누락 등 비즈니스 로직 변경이 없는 수정 |
| `refactor` | 코드 리팩토링                             |
| `perf`     | 성능 개선                               |
| `test`     | 테스트 코드 추가, 수정, 삭제                   |
| `build`    | 빌드 시스템, 의존성 변경                      |
| `ci`       | CI 설정 파일 변경                         |
| `chore`    | 기타 자잘한 수정                           |
| `revert`   | 이전 커밋 되돌리기                          |

---

## 9. 개발 현황
* [x] DB 스키마 설계
* [x] `schema.sql` 작성
* [x] `data.sql` 작성
* [x] DTO 기본 구조 작성
* [x] DAO 기본 구조 작성
* [x] DBUtil 작성
* [x] 민원 목록 조회 구현
* [x] 민원 상세 조회 구현
* [ ] 회원가입 / 로그인 / 로그아웃 구현
* [ ] 마이페이지 구현
* [ ] 민원 작성 / 수정 / 삭제 구현
* [ ] 담당자 답변 기능 구현
* [ ] 상태 변경 및 상태 이력 구현
* [ ] 추천 기능 구현
* [ ] 유사 민원 / FAQ 추천 구현
* [ ] 관리자 기능 구현
* [ ] 예외 처리 및 권한 검증 정리
* [ ] 화면 디자인 적용