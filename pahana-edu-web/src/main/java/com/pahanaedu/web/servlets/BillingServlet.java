package com.pahanaedu.web.servlets;

import com.pahanaedu.web.api.ApiClient;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import jakarta.json.JsonStructure;
import jakarta.json.Json;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

@WebServlet(name = "BillingServlet", urlPatterns = {"/billing"})
public class BillingServlet extends HttpServlet {

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

        // --- Customers -> List<Map<String,Object>> (plain Java types) ---
        JsonArray carr = api.getJson("/customers").asJsonArray();
        List<Map<String, Object>> clist = new ArrayList<>();
        for (int i = 0; i < carr.size(); i++) {
            JsonObject o = carr.getJsonObject(i);
            Map<String, Object> m = new HashMap<>();
            m.put("id", Integer.valueOf(o.getInt("id")));         // Integer, not JsonNumber
            m.put("accountNumber", o.getString("accountNumber",""));
            m.put("name", o.getString("name",""));
            clist.add(m);
        }

        // --- Items -> raw JSON string (used by JS in JSP) ---
        String itemsJson = api.getJson("/items").toString();

        req.setAttribute("customers", clist);
        req.setAttribute("itemsJson", itemsJson);
        req.getRequestDispatcher("/bills/create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        int userId = (session != null && session.getAttribute("userId") != null)
                ? (Integer) session.getAttribute("userId") : 0;

        String customerId = req.getParameter("customerId");
        String[] itemIds = req.getParameterValues("itemId");
        String[] qtys = req.getParameterValues("qty");
        String[] unitPrices = req.getParameterValues("unitPrice");

        // Build request payload for service
        JsonArrayBuilder lines = Json.createArrayBuilder();
        if (itemIds != null) {
            for (int i = 0; i < itemIds.length; i++) {
                if (itemIds[i] == null || itemIds[i].isBlank()) continue;
                int qty = 1;
                try { qty = Integer.parseInt(qtys[i]); } catch (Exception ignore) {}
                BigDecimal up = BigDecimal.ZERO;
                try { up = new BigDecimal(unitPrices[i]); } catch (Exception ignore) {}
                if (qty <= 0) continue;

                lines.add(Json.createObjectBuilder()
                        .add("itemId", Integer.parseInt(itemIds[i]))
                        .add("qty", qty)
                        .add("unitPrice", up));
            }
        }

        JsonObject payload = Json.createObjectBuilder()
                .add("customerId", Integer.parseInt(customerId))
                .add("createdBy", userId)
                .add("lines", lines.build())
                .build();

        ApiClient api = new ApiClient(apiBase);
        JsonObject b = api.sendJson("POST", "/bills", payload.toString()).asJsonObject();

        // --- Convert response bill -> Map<String,Object> (plain Java types) ---
        Map<String, Object> bill = new HashMap<>();
        bill.put("billNo", b.getString("billNo", ""));
        bill.put("customerId", b.getInt("customerId", 0));  // Integer
        bill.put("customerName", b.getString("customerName", ""));
        bill.put("createdAt", (b.containsKey("createdAt") && !b.isNull("createdAt")) ? b.getString("createdAt") : "");
        bill.put("totalAmount", b.getJsonNumber("totalAmount").bigDecimalValue()); // BigDecimal

        List<Map<String, Object>> items = new ArrayList<>();
        if (b.containsKey("items") && !b.isNull("items")) {
            JsonArray arr = b.getJsonArray("items");
            for (int i = 0; i < arr.size(); i++) {
                JsonObject o = arr.getJsonObject(i);
                Map<String, Object> m = new HashMap<>();
                m.put("itemId", o.getInt("itemId", 0));                                  // Integer
                m.put("itemName", o.containsKey("itemName") && !o.isNull("itemName")
                        ? o.getString("itemName") : "");
                m.put("qty", o.getInt("qty", 0));                                        // Integer
                m.put("unitPrice", o.getJsonNumber("unitPrice").bigDecimalValue());      // BigDecimal
                m.put("lineTotal", o.getJsonNumber("lineTotal").bigDecimalValue());      // BigDecimal
                items.add(m);
            }
        }
        bill.put("items", items);

        req.setAttribute("bill", bill);
        req.getRequestDispatcher("/bills/view.jsp").forward(req, resp);
    }
}
