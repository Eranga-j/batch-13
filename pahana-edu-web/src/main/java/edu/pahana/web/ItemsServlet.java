package edu.pahana.web;

import com.google.gson.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name="ItemsServlet", urlPatterns={"/items"})
public class ItemsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Load list for table
        req.setAttribute("json", RestClient.get("items"));

        // If editing, fetch single item
        String editId = req.getParameter("editId");
        if (editId != null && !editId.isBlank()) {
            RestClient.Response r = RestClient.getResp("items/" + editId);
            if (r.status == 200) {
                req.setAttribute("edit", r.body);
            }
        }
        req.getRequestDispatcher("items.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) { resp.sendRedirect("items"); return; }

        switch (action) {
            case "create" -> handleCreate(req, resp);
            case "update" -> handleUpdate(req, resp);
            case "delete" -> handleDelete(req, resp);
            default -> resp.sendRedirect("items");
        }
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String code  = safe(req.getParameter("itemCode"));
        String name  = safe(req.getParameter("name"));
        String price = safe(req.getParameter("unitPrice"));

        try {
            // duplicate item code?
            JsonArray all = JsonParser.parseString(RestClient.get("items")).getAsJsonArray();
            for (JsonElement el : all) {
                JsonObject o = el.getAsJsonObject();
                if (o.has("sku") && code.equalsIgnoreCase(o.get("sku").getAsString())) {
                    resp.sendRedirect("items?err=dup_code");
                    return;
                }
            }

            JsonObject body = new JsonObject();
            body.addProperty("sku", code);          // backend expects 'sku'
            body.addProperty("name", name);
            body.addProperty("unitPrice", Double.parseDouble(price));

            RestClient.Response r = RestClient.post("items", body.toString());
            resp.sendRedirect(r.status == 201 ? "items?msg=created" : "items?err=server");
        } catch (Exception e) {
            resp.sendRedirect("items?err=server");
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id    = safe(req.getParameter("id"));
        String code  = safe(req.getParameter("itemCode"));
        String name  = safe(req.getParameter("name"));
        String price = safe(req.getParameter("unitPrice"));

        try {
            int itemId = Integer.parseInt(id);

            // duplicate code (exclude self)
            JsonArray all = JsonParser.parseString(RestClient.get("items")).getAsJsonArray();
            for (JsonElement el : all) {
                JsonObject o = el.getAsJsonObject();
                if (o.get("id").getAsInt() == itemId) continue;
                if (o.has("sku") && code.equalsIgnoreCase(o.get("sku").getAsString())) {
                    resp.sendRedirect("items?err=dup_code&editId=" + id);
                    return;
                }
            }

            JsonObject body = new JsonObject();
            body.addProperty("sku", code);
            body.addProperty("name", name);
            body.addProperty("unitPrice", Double.parseDouble(price));

            RestClient.Response r = RestClient.put("items/" + id, body.toString());
            resp.sendRedirect(r.status == 200 ? "items?msg=updated" : "items?err=server");
        } catch (Exception e) {
            resp.sendRedirect("items?err=server");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = safe(req.getParameter("id"));
        try {
            int code = RestClient.delete("items/" + Integer.parseInt(id));
            resp.sendRedirect((code == 200 || code == 204) ? "items?msg=deleted" : "items?err=server");
        } catch (Exception e) {
            resp.sendRedirect("items?err=server");
        }
    }

    private static String safe(String s) { return s == null ? "" : s.trim(); }
}
