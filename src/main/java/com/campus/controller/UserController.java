package com.campus.controller;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("*.do")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String RequestURI = request.getRequestURI();
		String contextPath = request.getContextPath();
		String command = RequestURI.substring(contextPath.length());
		
		response.setContentType("text/html; charset=utf-8");
		request.setCharacterEncoding("utf-8");
		
		// [위치 1] 기본 세션 객체 가져오기
		HttpSession session = request.getSession();
		
		// 1. 로그인 화면 요청
		if (command.equals("/user/login.do")) {
			// ★ [추가 권한제어]: 이미 로그인된 유저가 로그인 페이지로 가려고 하면 차단하고 리스트로 보냄
			if (session.getAttribute("loginUser") != null) {
				response.sendRedirect(request.getContextPath() + "/complaints/list.do");
				return;
			}
			RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/user/login.jsp");
			rd.forward(request, response);
		} 
		
		// 2. 로그인 처리 버튼 눌렀을 때
		else if (command.equals("/user/loginAction.do")) {
			String userId = request.getParameter("userId");
			String userPw = request.getParameter("password");
			
			// 테스트 계정 등급 분기 (명세서의 Admin, Staff, Logged-in 권한 대응용)
			if ("root".equals(userId) && "1234".equals(userPw)) {
				session.setAttribute("loginUser", userId);     // 세션에 로그인 ID 저장
				session.setAttribute("userRole", "Logged-in"); // 일반 유저 권한 부여
				
				response.sendRedirect(request.getContextPath() + "/complaints/list.do");
			} 
			//  관리자 기능 테스트용 가상 분기
			else if ("admin".equals(userId) && "1234".equals(userPw)) {
				session.setAttribute("loginUser", userId);
				session.setAttribute("userRole", "Admin");    // 설계도상 'Admin' 등급 부여
				
				response.sendRedirect(request.getContextPath() + "/complaints/list.do");
			}
			else {
				response.sendRedirect(request.getContextPath() + "/user/login.do?error=1");
			}
		} 
		
		// 3. 회원가입 화면 요청
		else if (command.equals("/user/register.do")) {
			// 이미 로그인된 유저는 회원가입 화면 접근 불가
			if (session.getAttribute("loginUser") != null) {
				response.sendRedirect(request.getContextPath() + "/complaints/list.do");
				return;
			}
			RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/user/register.jsp");
			rd.forward(request, response);
		} 
		
		// 4. 회원가입 처리 버튼 눌렀을 때
		else if (command.equals("/user/registerAction.do")) {
			String userAuthInput = request.getParameter("verifynumber");
			String realAuthKey = (String) session.getAttribute("emailAuthKey");
			
			if (realAuthKey != null && realAuthKey.equals(userAuthInput)) {
				System.out.println("인증번호 일치! 회원가입 처리를 진행합니다.");
				// DB 작업 예정
				
				session.removeAttribute("emailAuthKey"); 
				response.sendRedirect(request.getContextPath() + "/user/login.do"); 
			} else {
				java.io.PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('인증번호가 올바르지 않습니다. 다시 확인하고 입력해주세요.');");
				out.println("history.back();");
				out.println("< /script>");
				out.flush();
				out.close();
			}
		}
		
		// 5. 로그아웃 요청 처리
		else if (command.equals("/user/logout.do")) {
			// ★ [수정]: 명세서 조건에 맞는 POST 검증 및 무단 로그아웃 접근 차단 안전장치
			HttpSession session1 = request.getSession(false);
			
			if (session1 != null && session1.getAttribute("loginUser") != null) {
				session1.invalidate(); // 세션 완전 제거 (초기화)
			}
			
			// 명세서 규격: 로그아웃 성공 시 메인 화면(홈)이나 로그인창으로 바인딩
			response.sendRedirect(request.getContextPath() + "/user/login.do");
		}
		
		// 6. 마이페이지 화면 요청 구역
		else if (command.equals("/user/mypage.do")) {
			String userRole = (String) session.getAttribute("userRole");
			String loginUser = (String) session.getAttribute("loginUser"); 
			
			// ★ 명세서 조건 반영 검증: 권한 등급이 'Logged-in' 혹은 'Admin'인 인증된 유저만 통과
			if (loginUser != null && ("Logged-in".equals(userRole) || "Admin".equals(userRole))) {
				try {
					// DB 연동 예정 끄집어낸 loginUser ID값 대조 후 마이페이지 바인딩
					RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/user/mypage.jsp");
					rd.forward(request, response);
				} catch (Exception e) {
					e.printStackTrace();
					response.sendRedirect(request.getContextPath() + "/user/login.do");
				}
			}
		}
	}
}