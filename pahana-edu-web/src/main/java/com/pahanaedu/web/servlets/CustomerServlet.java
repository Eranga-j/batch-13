package com.pahanaedu.web.servlets;

import com.pahanaedu.web.api.ApiClient;
import jakarta.json.JsonArray;
import jakarta.json.JsonObject;
import jakarta.json.JsonStructure;
import jakarta.json.Json;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customers"})
public class CustomerServlet extends HttpServlet {

    private String apiBase;

    @Override
    public void init() {
        this.apiBase = getServletContext().getInitParameter("apiBase");
        if (this.apiBase == null) this.apiBase = "http://localhost:8080/pahana-edu-service/api";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        ApiClient api = new ApiClient(apiBase);
        JsonStructure res = api.getJson("/customers");
        JsonArray arr = res.asJsonArray();

        // Convert JSON -> List<Map<String,Object>> with real Java types
        List<Map<String, Object>> list = new ArrayList<>();
        for (int i = 0; i < arr.size(); i++) {
            JsonObject o = arr.getJsonObject(i);
            Map<String, Object> m = new HashMap<>();
            m.put("id", Integer.valueOf(o.getInt("id"))); // Integer, not JsonNumber
            m.put("accountNumber", o.getString("accountNumber", ""));
            m.put("name", o.getString("name", ""));
            m.put("address", (o.containsKey("address") && !o.isNull("address")) ? o.getString("address") : "");
            m.put("phone", (o.containsKey("phone") && !o.isNull("phone")) ? o.getString("phone") : "");
            list.add(m);
        }

        req.setAttribute("customers", list);
        req.getRequestDispatcher("/customers/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ✅ Admin-only guard for write operations
        HttpSession session = req.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (!"ADMIN".equals(role)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only admin can modify customers.");
            return;
        }

        String action = req.getParameter("action");
        ApiClient api = new ApiClient(apiBase);

        if ("create".equals(action)) {
            JsonObject json = Json.createObjectBuilder()
                    .add("accountNumber", req.getParameter("accountNumber"))
                    .add("name", req.getParameter("name"))
                    .add("address", req.getParameter("address"))
                    .add("phone", req.getParameter("phone"))
                    .build();
            api.sendJson("POST", "/customers", json.toString());

        } else if ("update".equals(action)) {
            String id = req.getParameter("id");
            JsonObject json = Json.createObjectBuilder()
                    .add("accountNumber", req.getParameter("accountNumber"))
                    .add("name", req.getParameter("name"))
                    .add("address", req.getParameter("address"))
                    .add("phone", req.getParameter("phone"))
                    .build();
            api.sendJson("PUT", "/customers/" + id, json.toString());

        } else if ("delete".equals(action)) {
            String id = req.getParameter("id");
            api.sendJson("DELETE", "/customers/" + id, "{}");
        }

        resp.sendRedirect(req.getContextPath() + "/customers");
    }
}
