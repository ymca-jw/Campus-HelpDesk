package com.campus.filter;

import com.campus.dto.UserDTO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter({
        "/complaints",
        "/complaints/*",
        "/staff/*",
        "/admin/*"
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        UserDTO loginUser = getLoginUser(req);
        if (loginUser == null) {
            res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String path = req.getRequestURI().substring(req.getContextPath().length());
        String role = loginUser.getRole();

        if (path.startsWith("/admin") && !"ADMIN".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (path.startsWith("/staff") && !"STAFF".equals(role) && !"ADMIN".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(request, response);
    }

    private UserDTO getLoginUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return null;
        }

        Object loginUser = session.getAttribute("loginUser");
        return loginUser instanceof UserDTO ? (UserDTO) loginUser : null;
    }
}
