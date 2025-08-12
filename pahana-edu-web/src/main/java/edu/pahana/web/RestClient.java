package edu.pahana.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/** Minimal REST helper for the web app → service calls. */
public class RestClient {
    // You can override with VM option:
    // -Dservice.base=http://localhost:8080/pahana-edu-service/api/
    private static final String BASE = System.getProperty(
            "service.base",
            "http://localhost:8080/pahana-edu-service/api/"
    );

    private static final int CONNECT_TIMEOUT_MS = 8000;
    private static final int READ_TIMEOUT_MS    = 10000;

    /* ----------------------- GET ----------------------- */

    /** Returns only the response body (legacy helper). */
    public static String get(String path) {
        return getResp(path).body;
    }

    /** Returns status + body (use this for robust error handling). */
    public static Response getResp(String path) {
        try {
            HttpURLConnection c = (HttpURLConnection) new URL(BASE + path).openConnection();
            c.setRequestMethod("GET");
            c.setRequestProperty("Accept", "application/json");
            c.setConnectTimeout(CONNECT_TIMEOUT_MS);
            c.setReadTimeout(READ_TIMEOUT_MS);
            return readResponse(c);
        } catch (Exception e) {
            return new Response(500, "[]");
        }
    }

    /* ------------------ POST / PUT / DELETE ------------------ */

    public static Response post(String path, String body) {
        return writeWithBody("POST", path, body);
    }

    public static Response put(String path, String body) {
        return writeWithBody("PUT", path, body);
    }

    /** Return only HTTP code for delete (kept for backward compatibility). */
    public static int delete(String path) {
        try {
            HttpURLConnection c = (HttpURLConnection) new URL(BASE + path).openConnection();
            c.setRequestMethod("DELETE");
            c.setRequestProperty("Accept", "application/json");
            c.setConnectTimeout(CONNECT_TIMEOUT_MS);
            c.setReadTimeout(READ_TIMEOUT_MS);
            return c.getResponseCode();
        } catch (Exception e) {
            return 500;
        }
    }

    /** Full delete response (optional, if you ever need body on DELETE). */
    public static Response deleteResp(String path) {
        try {
            HttpURLConnection c = (HttpURLConnection) new URL(BASE + path).openConnection();
            c.setRequestMethod("DELETE");
            c.setRequestProperty("Accept", "application/json");
            c.setConnectTimeout(CONNECT_TIMEOUT_MS);
            c.setReadTimeout(READ_TIMEOUT_MS);
            return readResponse(c);
        } catch (Exception e) {
            return new Response(500, "{\"message\":\"client error\"}");
        }
    }

    /* ------------------------ internals ------------------------ */

    private static Response writeWithBody(String method, String path, String body) {
        try {
            HttpURLConnection c = (HttpURLConnection) new URL(BASE + path).openConnection();
            c.setRequestMethod(method);
            c.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            c.setRequestProperty("Accept", "application/json");
            c.setDoOutput(true);
            c.setConnectTimeout(CONNECT_TIMEOUT_MS);
            c.setReadTimeout(READ_TIMEOUT_MS);

            try (OutputStream os = c.getOutputStream()) {
                os.write(body.getBytes("UTF-8"));
            }
            return readResponse(c);
        } catch (Exception e) {
            return new Response(500, "{\"message\":\"client error\"}");
        }
    }

    private static Response readResponse(HttpURLConnection c) {
        try {
            int status = c.getResponseCode();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    status < 400 ? c.getInputStream() : c.getErrorStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            return new Response(status, sb.toString());
        } catch (Exception e) {
            return new Response(500, "{\"message\":\"client error\"}");
        }
    }

    public static class Response {
        public final int status;
        public final String body;
        public Response(int s, String b){ this.status = s; this.body = b; }
    }
}
