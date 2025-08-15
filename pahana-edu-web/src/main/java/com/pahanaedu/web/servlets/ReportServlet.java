package com.pahanaedu.web.servlets;

import com.pahanaedu.web.api.ApiClient;
import jakarta.json.JsonArray;
import jakarta.json.JsonObject;
import jakarta.json.JsonStructure;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

public class ReportServlet extends HttpServlet {

    private String apiBase;

    @Override
    public void init() {
        this.apiBase = getServletContext().getInitParameter("apiBase");
        if (this.apiBase == null) {
            this.apiBase = "http://localhost:8080/pahana-edu-service/api";
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String from = req.getParameter("from");
        String to   = req.getParameter("to");

        String q = "/bills";
        if (from != null && !from.isBlank() && to != null && !to.isBlank()) {
            q += "?from=" + from + "T00:00:00&to=" + to + "T23:59:59";
        }

        ApiClient api = new ApiClient(apiBase);
        JsonStructure data = api.getJson(q);
        JsonArray arr = data.asJsonArray();

        // Convert JSON -> List<Map<String,Object>> using plain Java types
        List<Map<String, Object>> list = new ArrayList<>();
        for (int i = 0; i < arr.size(); i++) {
            JsonObject b = arr.getJsonObject(i);
            Map<String, Object> m = new HashMap<>();
            m.put("billNo", b.getString("billNo", ""));
            m.put("customerName", b.getString("customerName", ""));
            m.put("createdAt", (b.containsKey("createdAt") && !b.isNull("createdAt"))
                    ? b.getString("createdAt") : "");
            BigDecimal total = b.isNull("totalAmount")
                    ? BigDecimal.ZERO
                    : b.getJsonNumber("totalAmount").bigDecimalValue();
            m.put("totalAmount", total);
            list.add(m);
        }

        req.setAttribute("bills", list);
        req.getRequestDispatcher("/admin/reports.jsp").forward(req, resp);
    }
}
