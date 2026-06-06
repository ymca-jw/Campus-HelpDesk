package com.campus.controller;

import com.campus.dto.UserDTO;
import com.campus.service.ComplaintService;
import com.campus.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet({
        "/user/login", "/user/logout", "/user/register", "/user/mypage",
        "/user/my-complaints", "/user/liked-complaints",
        "/user/login.do", "/user/loginAction.do", "/user/logout.do",
        "/user/register.do", "/user/registerAction.do", "/user/mypage.do"
})
public class UserController extends HttpServlet {
    private final UserService userService = new UserService();
    private final ComplaintService complaintService = new ComplaintService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if ("/user/login.do".equals(path)) path = "/user/login";
        if ("/user/register.do".equals(path)) path = "/user/register";
        if ("/user/mypage.do".equals(path)) path = "/user/mypage";
        if ("/user/logout.do".equals(path)) path = "/user/logout";

        if ("/user/login".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(req, res);
            return;
        }

        if ("/user/register".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(req, res);
            return;
        }

        if ("/user/mypage".equals(path)) {
            UserDTO loginUser = getLoginUser(req);
            if (loginUser == null) {
                res.sendRedirect(req.getContextPath() + "/user/login");
                return;
            }
            req.setAttribute("loginUser", loginUser);
            req.getRequestDispatcher("/WEB-INF/views/user/myPage.jsp").forward(req, res);
            return;
        }

        if ("/user/my-complaints".equals(path)) {
            UserDTO loginUser = requireLoginUser(req, res);
            if (loginUser == null) return;

            req.setAttribute("pageTitle", "내가 작성한 민원");
            req.setAttribute("complaints", complaintService.findComplaintsByWriter(loginUser.getUserId()));
            req.setAttribute("activeMyMenu", "written");
            req.getRequestDispatcher("/WEB-INF/views/user/myComplaints.jsp").forward(req, res);
            return;
        }

        if ("/user/liked-complaints".equals(path)) {
            UserDTO loginUser = requireLoginUser(req, res);
            if (loginUser == null) return;

            req.setAttribute("pageTitle", "내가 추천한 민원");
            req.setAttribute("complaints", complaintService.findLikedComplaintsByUser(loginUser.getUserId()));
            req.setAttribute("activeMyMenu", "liked");
            req.getRequestDispatcher("/WEB-INF/views/user/myComplaints.jsp").forward(req, res);
            return;
        }

        if ("/user/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            res.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if ("/user/loginAction.do".equals(path)) path = "/user/login";
        if ("/user/registerAction.do".equals(path)) path = "/user/register";

        if ("/user/login".equals(path)) {
            login(req, res);
            return;
        }

        if ("/user/register".equals(path)) {
            register(req, res);
            return;
        }

        if ("/user/logout".equals(path) || "/user/mypage".equals(path)) {
            res.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        res.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    private void login(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String loginId = req.getParameter("loginId");
        String password = req.getParameter("password");

        UserDTO user = userService.login(loginId, password);
        if (user == null) {
            req.setAttribute("errorMessage", "아이디 또는 비밀번호가 올바르지 않습니다.");
            req.setAttribute("loginId", loginId);
            req.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(req, res);
            return;
        }

        HttpSession oldSession = req.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession newSession = req.getSession(true);
        newSession.setAttribute("loginUser", user);
        res.sendRedirect(req.getContextPath() + redirectPathByRole(user));
    }

    private void register(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String loginId = req.getParameter("loginId");
        String password = req.getParameter("password");
        String name = req.getParameter("name");

        int result = userService.registerStudent(loginId, password, name);

        if (result == UserService.REGISTER_SUCCESS) {
            res.sendRedirect(req.getContextPath() + "/user/login?registered=1");
            return;
        }

        if (result == UserService.REGISTER_INVALID_EMAIL) {
            req.setAttribute("alertMessage", "인증된 학교 계정만 가입 가능합니다.");
            req.setAttribute("errorMessage", "서경대학교 이메일(@skuniv.ac.kr)만 사용할 수 있습니다.");
        } else if (result == UserService.REGISTER_INVALID_PASSWORD) {
            req.setAttribute("errorMessage", "비밀번호는 영문, 숫자, 특수문자를 각각 1개 이상 포함하고 8자 이상이어야 합니다.");
        } else if (result == UserService.REGISTER_DUPLICATE) {
            req.setAttribute("errorMessage", "이미 사용 중인 아이디입니다.");
        } else {
            req.setAttribute("errorMessage", "회원가입 정보를 다시 확인해 주세요.");
        }

        req.setAttribute("loginId", loginId);
        req.setAttribute("name", name);
        req.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(req, res);
    }

    private String redirectPathByRole(UserDTO user) {
        if ("ADMIN".equals(user.getRole())) return "/admin/dashboard";
        if ("STAFF".equals(user.getRole())) return "/staff/dashboard";
        return "/complaints";
    }

    private UserDTO getLoginUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;

        Object loginUser = session.getAttribute("loginUser");
        return loginUser instanceof UserDTO ? (UserDTO) loginUser : null;
    }

    private UserDTO requireLoginUser(HttpServletRequest req, HttpServletResponse res) throws IOException {
        UserDTO loginUser = getLoginUser(req);
        if (loginUser == null) {
            res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return null;
        }

        return loginUser;
    }
}
