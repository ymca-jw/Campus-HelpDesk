package com.ymc.controller;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// *.do 로 끝나는 모든 주소 요청을 이 컨트롤러가 받아서 처리
@WebServlet("*.do")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// 브라우저에서 GET 방식으로 요청이 오든, POST로 오든 모두 doPost 메서드로 보내서 처리
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//사용자가 요청한 커맨드를 추출
		String RequestURI = request.getRequestURI();
		String contextPath = request.getContextPath();
		String command = RequestURI.substring(contextPath.length());
		
		// 한글 깨짐 방지 설정
		response.setContentType("text/html; charset=utf-8");
		request.setCharacterEncoding("utf-8");
		
		// 로그인 세션 관리를 위한 세션 객체 생성
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
			
			// [임시 기능] 나중에 DB 연동예정
			if ("root".equals(userId) && "1234".equals(userPw)) {
				session.setAttribute("loginUser", userId);    // 세션에 로그인 ID 저장
				session.setAttribute("userRole", "Logged-in"); // 세션에 권한 저장
				
				// 성공 시 민원 목록 화면으로 강제 이동
				response.sendRedirect(request.getContextPath() + "/complaints/list.do");
			} else {
				// 실패 시 에러 표시를 달고 로그인 화면으로 다시 이동
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
		    // 사용자가 회원가입 창에 직접 입력한 인증번호를 읽음
		    String userAuthInput = request.getParameter("verifynumber");
		    
		    // EmailServlet이 메일을 보낼 때 세션에 저장해 둔 인증번호를 가져옴
		    String realAuthKey = (String) session.getAttribute("emailAuthKey");
		    
		    // 서버가 쥐고 있는 번호와 사용자가 쓴 번호가 완벽히 일치하는지 대조
		    if (realAuthKey != null && realAuthKey.equals(userAuthInput)) {
		        
		        // 인증 성공
		        System.out.println("인증번호 일치! 회원가입 처리를 진행합니다.");
		        
		        // 여기에 유저 데이터베이스 저장 코드 필요
		        
		        session.removeAttribute("emailAuthKey"); // 인증 성공후 인증번호 세션 삭제
		        response.sendRedirect(request.getContextPath() + "/user/login.do"); // 로그인 페이지로 이동
		        
		    } else {
		        
		        //인증 실패 다른 번호를 입력했거나 틀렸을 때
		    	java.io.PrintWriter out = response.getWriter();
		    	out.println("<script>");
		        out.println("alert('인증번호가 올바르지 않습니다. 다시 확인하고 입력해주세요.');");
		        out.println("history.back();");
		        out.println("</script>");
		        out.flush();
		        out.close();
		    }
		}
		
		// 5. 로그아웃 요청 작성 예정
		
		// 6. 마이페이지 화면 요청 구역 수정
		else if (command.equals("/user/mypage.do")) {
		    String userRole = (String) session.getAttribute("userRole");
		    // 회원가입/로그인 시 세션에 저장해 둔 이메일 아이디를 꺼냅니다 (예: "test1234")
		    String loginUser = (String) session.getAttribute("loginUser"); 
		    
		    // 명세서 조건: 로그인된 유저만 마이페이지에 접근 가능
		    if ("Logged-in".equals(userRole) && loginUser != null) {
		        
		        try {
		            //데이터베이스 이용해서 여기에 이메일 대조 후 해당 정보 띄우는 코드 작성예정
		        	RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/user/mypage.jsp");
		            rd.forward(request, response);
		            
		        } catch (Exception e) {
		            e.printStackTrace();
		            response.sendRedirect(request.getContextPath() + "/home.do");
		        }
		        
		    } else {
		        // 로그인 안 한 비회원이면 로그인 페이지로 강제 이동
		        response.sendRedirect(request.getContextPath() + "/user/login.do");
		    }
		}
	}
}