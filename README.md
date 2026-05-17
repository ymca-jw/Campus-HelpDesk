# Campus-HelpDesk

JSP/Servlet 기반 학과·행정부서별 캠퍼스 민원 처리 시스템 프로젝트입니다.

현재는 프로젝트 초기 구조를 구성한 단계이며, MVC 패턴을 기반으로 기능을 점진적으로 구현할 예정입니다.

## 프로젝트 개요

Campus-HelpDesk는 학교 내에서 발생하는 학과 및 행정부서 관련 민원을 웹으로 등록하고 처리할 수 있도록 하는 민원 티켓 관리 시스템입니다.

학생은 민원을 등록하고 처리 상태를 확인할 수 있으며, 담당자는 자신이 맡은 부서의 민원에 답변하고 상태를 변경할 수 있습니다. 관리자는 사용자, 부서, 민원 정보를 관리할 수 있도록 구현할 예정입니다.

## 주요 기능 예정

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

## 기술 스택

- Java
- JSP / Servlet
- Jakarta Servlet API
- JDBC
- MySQL
- Apache Tomcat 10
- Maven
- HTML / CSS / JavaScript

## 프로젝트 구조 (임시)

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