# Campus-HelpDesk

JSP/Servlet 기반 학과·행정부서별 캠퍼스 민원 처리 시스템입니다.

---

## 프로젝트 소개

Campus-HelpDesk는 학교 내에서 발생하는 학과 및 행정부서 관련 민원을 웹으로 등록하고 처리할 수 있도록 하는 민원 티켓 관리 시스템입니다.

기존에는 학생이 학과 사무실 또는 행정부서에 직접 문의하거나 전화로 처리해야 하는 불편함이 있을 수 있습니다. 본 프로젝트는 이러한 민원을 웹에서 등록하고, 처리 상태를 확인하며, 담당자가 답변과 상태 변경을 수행할 수 있도록 하는 것을 목표로 합니다.

학생은 민원을 등록하고 처리 상태를 확인할 수 있으며, 담당자는 자신이 맡은 부서의 민원에 답변하고 상태를 변경할 수 있습니다. 관리자는 사용자, 부서, 전체 민원 정보를 관리할 수 있도록 구현할 예정입니다.

### 주요 기능 예정 
주요 기능은 추후에 추가되거나 삭제될 수 있습니다.

- 회원가입, 로그인, 로그아웃
- 학생 / 담당자 / 관리자 권한 구분
- 학과 및 행정부서별 민원 등록
- 민원 목록 조회 및 상세 조회
- 민원 수정 및 삭제
- 민원 상태 관리
  - 접수 완료
  - 검토중
  - 처리중
  - 완료
  - 반려
- 담당자 답변 작성
- 부서별, 상태별, 카테고리별 검색 및 필터링
- 내가 작성한 민원 조회
- 관리자 페이지
- 민원 처리 이력 관리

---

## 기술 스택

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

## 프로젝트 구조

```text
Campus-HelpDesk
├─ src
│  └─ main
│     ├─ java
│     │  └─ com.campus
│     │     ├─ controller
│     │     ├─ service
│     │     ├─ dao
│     │     ├─ dto
│     │     ├─ exception
│     │     └─ util
│     │
│     ├─ resources
│     │
│     └─ webapp
│        ├─ assets
│        │  ├─ css
│        │  ├─ images
│        │  └─ js
│        │
│        ├─ WEB-INF
│        │  ├─ views
│        │  └─ web.xml
│        │
│        └─ index.jsp
│
├─ sql
├─ pom.xml
├─ .gitignore
└─ README.md
```

### 패키지 역할

| 패키지 | 역할 |
|---|---|
| `controller` | 클라이언트 요청을 처리하는 Servlet 계층 |
| `service` | 주요 비즈니스 로직 처리 계층 |
| `dao` | 데이터베이스 접근 계층 |
| `dto` | 계층 간 데이터 전달 객체 |
| `exception` | 프로젝트 전용 예외 처리 클래스 |
| `util` | DB 연결 등 공통 유틸리티 클래스 |

---

## API 구조

현재는 프로젝트 초기 구조 구성 단계이므로 API는 아직 구현되지 않았습니다.

추후 기능 구현 시 아래와 같은 URL 구조로 설계할 예정입니다.

```text
/user/*
- 회원가입
- 로그인
- 로그아웃
- 마이페이지

/complaints/*
- 민원 등록
- 민원 목록 조회
- 민원 상세 조회
- 민원 수정
- 민원 삭제

/staff/*
- 담당 부서 민원 조회
- 담당자 답변 작성
- 민원 상태 변경

/admin/*
- 사용자 관리
- 부서 관리
- 전체 민원 관리
```

---

## 지침 사항

### 요구사항

프로젝트 실행을 위해 아래 환경이 필요합니다.

- JDK 17 이상 권장
- Apache Tomcat 10.1.x
- Maven
- MySQL
- IntelliJ IDEA 또는 Eclipse

---

## 설치 및 세팅

### 1. 저장소 Clone

```bash
git clone https://github.com/조직명/Campus-HelpDesk.git
```

```bash
cd Campus-HelpDesk
```

---

### 2. IDE에서 프로젝트 열기

#### IntelliJ IDEA 기준

```text
File → Open → Campus-HelpDesk 폴더 선택
```

프로젝트를 연 뒤 Maven 의존성을 새로고침합니다.

```text
Maven 탭 → Reload All Maven Projects
```

#### Eclipse 기준

```text
File → Import → Maven → Existing Maven Projects
```

프로젝트 폴더를 선택한 뒤 `pom.xml`이 인식되는지 확인합니다.

---

### 3. Tomcat 설정

Tomcat 10.1.x를 설치한 뒤 IDE에 서버를 등록합니다.

#### IntelliJ IDEA 기준

```text
Run/Debug Configurations
→ Tomcat Server
→ Local
→ Application Server에 Tomcat 10 경로 지정
```

Deployment에는 `war exploded`를 추가합니다.

```text
Deployment
→ Artifact
→ Campus-HelpDesk:war exploded
```

Application Context는 예시로 아래와 같이 설정합니다.

```text
/campus
```

서버 실행 후 아래 주소로 접속합니다.

```text
http://localhost:8080/campus/
```

---

## 개발 규칙

### Branch 전략

초기에는 단순한 브랜치 전략을 사용합니다.

```text
main       : 최종 제출 및 안정 버전
feature/*  : 기능 개발 브랜치
```

예시:

```text
feature/login
feature/complaint-crud
feature/staff-answer
feature/admin
```

---

### Commit Convention

커밋 메시지는 아래 타입을 기준으로 작성합니다.

| 타입 | 설명 |
|---|---|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `docs` | 문서 수정 |
| `style` | 코드 포맷팅, 세미콜론 누락 등 비즈니스 로직 변경이 없는 수정 |
| `refactor` | 코드 리팩토링 |
| `perf` | 성능 개선 |
| `test` | 테스트 코드 추가, 수정, 삭제 |
| `build` | 빌드 시스템, 의존성 변경 |
| `ci` | CI 설정 파일 변경 |
| `chore` | 기타 자잘한 수정 |
| `revert` | 이전 커밋 되돌리기 |

커밋 메시지 예시:

```text
feat: 회원가입 기능 추가
feat: 민원 등록 기능 추가
fix: 로그인 실패 시 예외 처리 수정
docs: README 프로젝트 구조 수정
style: 코드 포맷팅 정리
refactor: 민원 상태 변경 로직 분리
chore: .gitignore 설정 추가
```

---

## 작업 시 주의사항

- `target/`, `.idea/`, `.iml` 등 개인 IDE 설정 및 빌드 결과물은 커밋하지 않습니다.
- DB 계정, 비밀번호 등 민감 정보는 GitHub에 올리지 않습니다.
- 기능 구현 전 반드시 최신 `main` 브랜치를 pull 받은 뒤 작업합니다.
- JSP 파일은 가능하면 `WEB-INF/views` 아래에 두고, 직접 접근이 아닌 Controller를 통해 접근하도록 구성합니다.
- Tomcat 10을 사용하므로 Servlet import는 `javax.servlet`이 아닌 `jakarta.servlet`을 사용합니다.

예시:

```java
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
```

---

## 현재 진행 상태

- [x] Maven 기반 JSP 프로젝트 생성
- [x] Tomcat 10 실행 확인
- [x] 기본 프로젝트 디렉터리 구조 구성
- [x] GitHub 저장소 연결
- [ ] 회원 기능 구현
- [ ] 민원 CRUD 구현
- [ ] 담당자 답변 기능 구현
- [ ] 관리자 기능 구현
- [ ] 검색 및 필터링 기능 구현
- [ ] 예외 처리 및 권한 검증 구현

---

