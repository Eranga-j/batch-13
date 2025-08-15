/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.student.service.resources;

import com.google.gson.Gson;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.PUT;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import utils.Student;
import utils.Utils;

/**
 *
 * @author hd
 */
@Path("students")
public class StudentResources {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getStudents() {
        Utils utils = new Utils();
        Gson gson = new Gson();
        return Response
                .ok(gson.toJson(utils.getStudents()))
                .build();
    }

    @GET
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getStudent(@PathParam("id") int id) {
        Utils utils = new Utils();
        Gson gson = new Gson();
        return Response
                .ok(gson.toJson(utils.getStudentById(id)))
                .build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response createStudent(String studentJson) {
        Utils utils = new Utils();
        Gson gson = new Gson();
        Student student = gson.fromJson(studentJson, Student.class);

        boolean created = utils.createStudent(student);

        if (created) {
            return Response.status(Response.Status.CREATED)
                    .entity(gson.toJson(student))
                    .build();
        } else {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\":\"Student could not be created\"}")
                    .build();
        }
    }

    @PUT
    @Path("{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response updateStudent(@PathParam("id") int id, String studentJson) {
        Utils utils = new Utils();
        Gson gson = new Gson();
        Student student = gson.fromJson(studentJson, Student.class);
        student.setId(id); // Ensure path ID overrides JSON ID if needed

        boolean updated = utils.updateStudent(student);

        if (updated) {
            return Response.ok(gson.toJson(student)).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\":\"Student not found\"}")
                    .build();
        }
    }

    @DELETE
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteStudent(@PathParam("id") int id) {
        Utils utils = new Utils();
        boolean deleted = utils.deleteStudent(id);

        if (deleted) {
            return Response.noContent().build();
        } else {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\":\"Student not found\"}")
                    .build();
        }
    }

}
