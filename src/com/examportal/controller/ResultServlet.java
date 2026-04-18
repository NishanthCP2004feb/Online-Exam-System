package com.examportal.controller;

import com.examportal.dao.ResultDAO;
import com.examportal.model.Result;
import com.examportal.model.User;
import com.examportal.util.RequestUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/result")
public class ResultServlet extends HttpServlet {

    private ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        Integer resultId = RequestUtils.parsePositiveInt(request.getParameter("id"));

        if (resultId != null) {
            // Show specific result
            Result result = resultDAO.getResultById(resultId);
            
            if (result != null && result.getUserId() == user.getId()) {
                request.setAttribute("result", result);
                request.getRequestDispatcher("/student/result.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/student/my-results");
            }
        } else {
            // Show all results for user
            List<Result> results = resultDAO.getResultsByUserId(user.getId());
            request.setAttribute("results", results);
            request.getRequestDispatcher("/student/my-results.jsp").forward(request, response);
        }
    }
}
