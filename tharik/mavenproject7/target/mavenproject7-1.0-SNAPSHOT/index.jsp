<%-- 
    Document   : index
    Created on : Jul 6, 2025, 9:58:40 AM
    Author     : hd
--%>
<%@page import="utils.Utils"%>
<%@page import="utils.Student"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.css" />
        <script src="https://cdn.datatables.net/2.3.2/js/dataTables.js"></script>
        
        <script>
            $(document).ready( function () {
                $('#tblStudents').DataTable();
            } );
            
        </script>
        
    </head>
    <body>
        <h1> 
            <%      
                Utils utils = new Utils(); 
                
                out.print("<table id='tblStudents'>");
                out.print("<thead><tr>"
                        + "<th>ID</th>"
                        + "<th>Name</th>"
                        + "</tr></thead>");
                out.print("<tbody>");
                for(Student st : utils.getStudents()) {
                    out.print("<tr>");
                    out.print("<td>" + st.getId() + "</td>");
                    out.print("<td>" + st.getName() + "</td>");
                    out.print("</tr>");
                }
                 out.print("</tbody>");
                out.print("</table>");
            %> 
            </h1>
    </body>
</html>
