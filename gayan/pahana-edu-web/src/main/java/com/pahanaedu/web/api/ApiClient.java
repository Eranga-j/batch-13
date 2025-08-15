package com.pahanaedu.web.api;

import jakarta.json.Json;
import jakarta.json.JsonReader;
import jakarta.json.JsonStructure;
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class ApiClient {

    private final String baseUrl;

    public ApiClient(String baseUrl) {
        this.baseUrl = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length()-1) : baseUrl;
    }

    public JsonStructure getJson(String path) throws IOException {
        HttpURLConnection con = open("GET", path);
        int code = con.getResponseCode();
        InputStream is = (code >= 200 && code < 300) ? con.getInputStream() : con.getErrorStream();
        try (JsonReader jr = Json.createReader(is)) {
            return jr.read();
        }
    }

    public JsonStructure sendJson(String method, String path, String json) throws IOException {
        HttpURLConnection con = open(method, path);
        con.setDoOutput(true);
        try (OutputStream os = con.getOutputStream()) {
            os.write(json.getBytes(StandardCharsets.UTF_8));
        }
        int code = con.getResponseCode();
        InputStream is = (code >= 200 && code < 300) ? con.getInputStream() : con.getErrorStream();
        try (JsonReader jr = Json.createReader(is)) {
            return jr.read();
        }
    }

    private HttpURLConnection open(String method, String path) throws IOException {
        URL url = new URL(baseUrl + path);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod(method);
        con.setRequestProperty("Content-Type", "application/json");
        con.setRequestProperty("Accept", "application/json");
        con.setConnectTimeout(15000);
        con.setReadTimeout(15000);
        return con;
    }
}
