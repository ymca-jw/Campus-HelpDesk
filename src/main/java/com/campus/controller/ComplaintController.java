package com.campus.controller;

import com.campus.dto.ComplaintDTO;
import com.campus.service.ComplaintService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/complaints", "/complaints/detail", "/complaint/new", "/complaint/new", "/complaints/check",
"/complaints/create"})
public class ComplaintController extends HttpServlet {
    private final ComplaintService complaintService = new ComplaintService();

    // GET 요청
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<ComplaintDTO> complaints = complaintService.findComplaintList();
        req.setAttribute("complaints", complaints);
        req.getRequestDispatcher("/WEB-INF/views/test/list.jsp").forward(req, res);
        // req.getRequestDispatcher("/WEB-INF/views/complaint/list.jsp").forward(req, res);

    }
}
