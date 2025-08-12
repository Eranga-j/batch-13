package edu.pahana.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ReportsServlet", urlPatterns={"/reports"})
public class ReportsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type");
        if (type == null) type = "sales-today";
        // For demo, call service raw SQL via simple endpoints (reuse customers/items)
        String json;
        switch (type) {
            case "top-items":
                json = RestClient.get("items"); // Simplification: show all items as "top"
                break;
            default:
                json = RestClient.get("customers"); // Simplification: show customers
        }
        req.setAttribute("json", json);
        req.getRequestDispatcher("reports.jsp").forward(req, resp);
    }
}
