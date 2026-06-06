package com.ymc.controller;

import java.io.IOException;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// jakarta.mail-api-2.1.5.jar, angus-mail-2.0.3.jar 파일 추가 필요
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

// 브라우저나 자바스크립트가 /user/sendEmail.do 로 신호를 보내면 이 파일이 켜집니다.
@WebServlet("/user/sendEmail.do")
public class EmailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 보안을 위해 인증번호 발송은 POST 방식으로만 처리하도록 doPost로 넘깁니다.
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/plain; charset=utf-8"); // 응답을 단순 텍스트로 보냄
		
		// 1. register.jsp의 이메일 입력칸(name="id")에서 사용자가 쓴 아이디를 가져옵니다.
		String emailId = request.getParameter("id");
		String fullEmail = emailId + "@skuniv.ac.kr"; // 학교 이메일 주소 완성
		
		// 2. 6자리의 보안 인증번호(난수) 생성
		int randomNumber = (int)(Math.random() * 899999) + 100000;
		String authKey = String.valueOf(randomNumber);
		
		// 3. 생성된 인증번호를 서버 세션(장바구니)에 저장 (나중에 가입하기 누를 때 대조용)
		HttpSession httpSession = request.getSession();
		httpSession.setAttribute("emailAuthKey", authKey);
		
		// 4. SMTP 메일 발송 설정 (네이버 메일 기준 예시)
		String host = "smtp.naver.com";
		final String user = "mabub100"; 
		final String password = "Q2ZBMZXWJVHY"; // 네이버 애플리케이션 비밀번호 **실제비밀번호 아님**
		
		Properties props = new Properties();
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", 587); // 네이버 SMTP 포트번호
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true"); // 보안 연결 활성화
		
		// 메일 서버 인증 객체 생성
		Session mailSession = Session.getInstance(props, new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(user, password);
			}
		});
		
		try {
			// 진짜 메일 내용 구성하기
			MimeMessage message = new MimeMessage(mailSession);
			message.setFrom(new InternetAddress(user + "@naver.com")); // 보내는 사람
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(fullEmail)); // 받는 사람
			
			message.setSubject("[민원처리] 회원가입 인증번호 발송"); // 메일 제목
			message.setText("안녕하세요. 회원가입 인증번호는 [" + authKey + "] 입니다."); // 메일 내용
			
			// 5. 실제 메일 전송
			Transport.send(message);
			
			// 성공 시 화면(JSP)에 success 라는 글자를 결과로 던져줍니다.
			response.getWriter().write("success");
			System.out.println("메일 발송 성공! 인증번호: " + authKey);
			
		} catch (Exception e) {
			e.printStackTrace();
			// 실패 시 화면(JSP)에 fail 이라는 글자를 던져줍니다.
			response.getWriter().write("fail");
		}
	}
}