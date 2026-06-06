package com.campus.controller; // ★ 패키지 경로를 팀원들 기준(com.campus)으로 통일!

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
		
		HttpSession session = request.getSession();
		
		// 1. 로그인 화면 요청
		if (command.equals("/user/login.do")) {
			RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/user/login.jsp");
			rd.forward(request, response);
		} 
		
		// 2. 로그인 처리 버튼 눌렀을 때
		else if (command.equals("/user/loginAction.do")) {
			String userId = request.getParameter("userId");
			String userPw = request.getParameter("password");
			
			// ★ 마이페이지(myPage.jsp) 설계도에 맞게 세션 키값을 "userInfo"로 통일!
			if ("root".equals(userId) && "1234".equals(userPw)) {
				session.setAttribute("userInfo", userId);     // loginUser -> userInfo로 변경
				session.setAttribute("userRole", "Logged-in"); 
				
				response.sendRedirect(request.getContextPath() + "/complaints/list.do");
			} 
			else if ("admin".equals(userId) && "1234".equals(userPw)) {
				session.setAttribute("userInfo", userId);     // loginUser -> userInfo로 변경
				session.setAttribute("userRole", "Admin");    
				
				response.sendRedirect(request.getContextPath() + "/complaints/list.do");
			}
			else {
				response.sendRedirect(request.getContextPath() + "/user/login.do?error=1");
			}
		} 
		
		// 3. 회원가입 화면 요청
		else if (command.equals("/user/register.do")) {
			RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/user/register.jsp");
			rd.forward(request, response);
		} 
		
		// 4. 회원가입 처리 버튼 눌렀을 때
		else if (command.equals("/user/registerAction.do")) {
			String userAuthInput = request.getParameter("verifynumber");
			String realAuthKey = (String) session.getAttribute("emailAuthKey");
			
			if (realAuthKey != null && realAuthKey.equals(userAuthInput)) {
				System.out.println("인증번호 일치! 회원가입 처리를 진행합니다.");
				
				session.removeAttribute("emailAuthKey"); 
				response.sendRedirect(request.getContextPath() + "/user/login.do"); 
			} else {
				java.io.PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('인증번호가 올바르지 않습니다. 다시 확인하고 입력해주세요.');");
				out.println("history.back();");
				out.println("</script>");
				out.flush();
				out.close();
			}
		}
		
		// 5. 로그아웃 요청 처리
		else if (command.equals("/user/logout.do")) {
			HttpSession session1 = request.getSession(false);
			
			// ★ 여기도 검증 대상을 userInfo로 변경
			if (session1 != null && session1.getAttribute("userInfo") != null) {
				session1.invalidate(); 
			}
			response.sendRedirect(request.getContextPath() + "/user/login.do");
		}
		
		// 6. 마이페이지 화면 요청 구역
		else if (command.equals("/user/mypage.do")) {
			String userRole = (String) session.getAttribute("userRole");
			String userInfo = (String) session.getAttribute("userInfo"); // ★ loginUser -> userInfo
			
			// ★ 검증 대상을 userInfo로 변경
			if (userInfo != null && ("Logged-in".equals(userRole) || "Admin".equals(userRole))) {
				try {
					RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/user/mypage.jsp");
					rd.forward(request, response);
				} catch (Exception e) {
					e.printStackTrace();
					response.sendRedirect(request.getContextPath() + "/user/login.do");
				}
			} else {
				java.io.PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('로그인이 필요한 서비스입니다.');");
				out.println("location.href='" + request.getContextPath() + "/user/login.do';");
				out.println("</script>");
				out.flush();
				out.close();
			}
		}
	}
}