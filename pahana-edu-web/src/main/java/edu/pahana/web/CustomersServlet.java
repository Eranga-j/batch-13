package edu.pahana.web;

import com.google.gson.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CustomersServlet", urlPatterns = {"/customers"})
public class CustomersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // table data
        req.setAttribute("json", RestClient.get("customers"));

        // edit prefill if ?editId=...
        String editId = req.getParameter("editId");
        if (editId != null && !editId.isBlank()) {
            RestClient.Response r = RestClient.getResp("customers/" + editId);
            if (r.status == 200) req.setAttribute("edit", r.body);
        }

        req.getRequestDispatcher("customers.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) { resp.sendRedirect("customers"); return; }

        switch (action) {
            case "create" -> handleCreate(req, resp);
            case "update" -> handleUpdate(req, resp);
            case "delete" -> handleDelete(req, resp);
            default -> resp.sendRedirect("customers");
        }
    }

    /* ---------- helpers ---------- */

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String accountNumber = safe(req.getParameter("accountNumber"));
        String name          = safe(req.getParameter("name"));
        String address       = safe(req.getParameter("address"));
        String phone         = safe(req.getParameter("phone")).replaceAll("\\s+", "");

        try {
            JsonArray all = JsonParser.parseString(RestClient.get("customers")).getAsJsonArray();
            for (JsonElement el : all) {
                JsonObject o = el.getAsJsonObject();
                if (o.get("phone").getAsString().equals(phone)) {
                    resp.sendRedirect("customers?err=dup_phone"); return;
                }
                if (o.get("accountNumber").getAsString().equalsIgnoreCase(accountNumber)) {
                    resp.sendRedirect("customers?err=dup_acc"); return;
                }
            }

            JsonObject body = new JsonObject();
            body.addProperty("accountNumber", accountNumber);
            body.addProperty("name", name);
            body.addProperty("address", address);
            body.addProperty("phone", phone);

            RestClient.Response r = RestClient.post("customers", body.toString());
            resp.sendRedirect(r.status == 201 ? "customers?msg=created" : "customers?err=server");
        } catch (Exception e) {
            resp.sendRedirect("customers?err=server");
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr         = req.getParameter("id");
        String accountNumber = safe(req.getParameter("accountNumber"));
        String name          = safe(req.getParameter("name"));
        String address       = safe(req.getParameter("address"));
        String phone         = safe(req.getParameter("phone")).replaceAll("\\s+","");

        try {
            int id = Integer.parseInt(idStr);

            // duplicate checks excluding the record being edited
            JsonArray all = JsonParser.parseString(RestClient.get("customers")).getAsJsonArray();
            for (JsonElement el : all) {
                JsonObject o = el.getAsJsonObject();
                int otherId = o.get("id").getAsInt();
                if (otherId == id) continue;

                if (o.get("phone").getAsString().equals(phone)) {
                    resp.sendRedirect("customers?err=dup_phone&editId=" + id); return;
                }
                if (o.get("accountNumber").getAsString().equalsIgnoreCase(accountNumber)) {
                    resp.sendRedirect("customers?err=dup_acc&editId=" + id); return;
                }
            }

            JsonObject body = new JsonObject();
            body.addProperty("accountNumber", accountNumber);
            body.addProperty("name", name);
            body.addProperty("address", address);
            body.addProperty("phone", phone);

            RestClient.Response r = RestClient.put("customers/" + id, body.toString());
            resp.sendRedirect(r.status == 200 ? "customers?msg=updated" : "customers?err=server");
        } catch (Exception e) {
            resp.sendRedirect("customers?err=server");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        try {
            int status = RestClient.delete("customers/" + Integer.parseInt(idStr));
            resp.sendRedirect((status == 200 || status == 204) ? "customers?msg=deleted" : "customers?err=server");
        } catch (Exception e) {
            resp.sendRedirect("customers?err=server");
        }
    }

    private static String safe(String s) { return s == null ? "" : s.trim(); }
}
