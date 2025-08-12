package edu.pahana.web;

import com.google.gson.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name="BillServlet", urlPatterns={"/bill"})
public class BillServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Preload for the page (used by JS for phone lookup + item prices)
        req.setAttribute("customers", RestClient.get("customers")); // [{"id", "name", "phone", ...}]
        req.setAttribute("items",     RestClient.get("items"));     // [{"id","code","name","price"}, ...]

        // If returning after create, "json" may contain the order/invoice
        req.getRequestDispatcher("bill.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String phone      = safe(req.getParameter("phone")).replaceAll("\\s+","");
        String customerId = safe(req.getParameter("customerId"));
        String itemsJson  = safe(req.getParameter("items")); // built by JS [{itemId, quantity}]

        try {
            // If customerId not provided, try resolve by phone (server-side safety)
            if (customerId.isBlank() && !phone.isBlank()) {
                JsonArray customers = JsonParser.parseString(RestClient.get("customers")).getAsJsonArray();
                for (JsonElement el : customers) {
                    JsonObject c = el.getAsJsonObject();
                    if (phone.equals(c.get("phone").getAsString())) {
                        customerId = String.valueOf(c.get("id").getAsInt());
                        break;
                    }
                }
            }
            if (customerId.isBlank()) {
                // reload with an error
                req.setAttribute("err", "Customer not found for given phone.");
                doGet(req, resp);
                return;
            }

            // Build order body
            JsonObject body = new JsonObject();
            body.addProperty("customerId", Integer.parseInt(customerId));

            JsonArray arr;
            try {
                arr = JsonParser.parseString(itemsJson).getAsJsonArray();
            } catch (Exception ex) {
                arr = new JsonArray();
            }
            body.add("items", arr);

            // POST to service
            RestClient.Response r = RestClient.post("orders", body.toString());

            // Put order response + preload again for page
            req.setAttribute("json", r.body);
            req.setAttribute("customers", RestClient.get("customers"));
            req.setAttribute("items",     RestClient.get("items"));

            req.getRequestDispatcher("bill.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("err", "Server error. Please try again.");
            doGet(req, resp);
        }
    }

    private static String safe(String s){ return s == null ? "" : s.trim(); }
}
