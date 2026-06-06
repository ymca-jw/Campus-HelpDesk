# 1단계: 빌드 환경 (Maven + JDK 17)
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# 의존성 캐싱을 위해 pom.xml 복사 및 다운로드
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 소스 복사 및 프로젝트 빌드 (테스트 건너뛰기)
COPY src ./src
RUN mvn clean package -DskipTests

# 2단계: 실행 환경 (Tomcat 10.1 + JDK 17)
FROM tomcat:10.1-jdk17
WORKDIR /usr/local/tomcat

# 기존의 기본 웹앱 삭제 (선택 사항이나, 깔끔한 배포를 위해 권장)
RUN rm -rf webapps/*

# 빌드된 WAR 파일을 ROOT.war로 복사 (루트 경로 '/' 에서 앱 실행)
COPY --from=build /app/target/campus-helpdesk-1.0-SNAPSHOT.war webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
