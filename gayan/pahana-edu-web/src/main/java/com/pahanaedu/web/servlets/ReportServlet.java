package com.pahanaedu.web.servlets;

import com.pahanaedu.web.api.ApiClient;
import jakarta.json.JsonStructure;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ReportServlet extends HttpServlet {

    private String apiBase;

    @Override
    public void init() {
        this.apiBase = getServletContext().getInitParameter("apiBase");
        if (this.apiBase == null) this.apiBase = "http://localhost:8080/pahana-edu-service/api";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String from = req.getParameter("from");
        String to = req.getParameter("to");
        String q = "/bills";
        if (from != null && to != null && !from.isBlank() && !to.isBlank()) {
            q += "?from=" + from + "T00:00:00&to=" + to + "T23:59:59";
        }
        ApiClient api = new ApiClient(apiBase);
        JsonStructure data = api.getJson(q);
        req.setAttribute("bills", data);
        req.getRequestDispatcher("/admin/reports.jsp").forward(req, resp);
    }
}
