package com.pahanaedu.web.servlets;

import com.pahanaedu.web.api.ApiClient;
import jakarta.json.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="BillingServlet", urlPatterns={"/billing"})
public class BillingServlet extends HttpServlet {

    private String apiBase;

    @Override
    public void init() {
        this.apiBase = getServletContext().getInitParameter("apiBase");
        if (this.apiBase == null) this.apiBase = "http://localhost:8080/pahana-edu-service/api";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ApiClient api = new ApiClient(apiBase);
        JsonStructure customers = api.getJson("/customers");
        JsonStructure items = api.getJson("/items");
        req.setAttribute("customers", customers);
        req.setAttribute("items", items);
        req.getRequestDispatcher("/bills/create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String customerId = req.getParameter("customerId");
        String[] itemIds = req.getParameterValues("itemId");
        String[] qtys = req.getParameterValues("qty");
        String[] unitPrices = req.getParameterValues("unitPrice");

        JsonArrayBuilder lines = Json.createArrayBuilder();
        for (int i=0; i<itemIds.length; i++) {
            if (itemIds[i]==null || itemIds[i].isBlank()) continue;
            int qty = Integer.parseInt(qtys[i]);
            if (qty <= 0) continue;
            lines.add(Json.createObjectBuilder()
                .add("itemId", Integer.parseInt(itemIds[i]))
                .add("qty", qty)
                .add("unitPrice", new java.math.BigDecimal(unitPrices[i])));
        }
        JsonObject payload = Json.createObjectBuilder()
                .add("customerId", Integer.parseInt(customerId))
                .add("createdBy", userId)
                .add("lines", lines.build())
                .build();

        ApiClient api = new ApiClient(apiBase);
        JsonStructure created = api.sendJson("POST","/bills", payload.toString());
        req.setAttribute("bill", created);
        req.getRequestDispatcher("/bills/view.jsp").forward(req, resp);
    }
}
