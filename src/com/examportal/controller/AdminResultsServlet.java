package com.examportal.controller;

import com.examportal.dao.ResultDAO;
import com.examportal.model.Result;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/results")
public class AdminResultsServlet extends HttpServlet {

    private ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Result> results = resultDAO.getAllResults();
        request.setAttribute("results", results);
        request.getRequestDispatcher("/admin/all-results.jsp").forward(request, response);
    }
}
