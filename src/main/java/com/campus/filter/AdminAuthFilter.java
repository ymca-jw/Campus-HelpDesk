package com.campus.filter;

// 권한 필터들은 여기에..

import com.campus.dto.UserDTO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

// @WebFilter("/admin/*")  -> 사용자 기능 (로그인 등) 완성 전이라 주석 처리함
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

//        마찬가지로 로그인이 완성 안되서 주석처리
//        UserDTO loginUser = (UserDTO) req.getSEssion().getAttribute("loginUser");
//        if (loginUser == null) {
//            res.sendRedirect(req.getContextPath() + "/user/login");
//            return;
//        }
//
//        // ADMIN이 아닌 경우
//        if (!"ADMIN".equals(loginUser.getRole())) {
//            res.sendError(HttpServletResponse.SC_FORBIDDEN);
//            return;
//        }
//
//        // 통과
//        chain.doFilter(request, response);

    }
}
