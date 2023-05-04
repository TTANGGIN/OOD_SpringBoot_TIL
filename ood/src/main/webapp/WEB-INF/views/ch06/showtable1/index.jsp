<%-- 
    Document   : index
    Created on : 2023. 5. 4., 오후 2:05:37
    Author     : CHANG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<spring:eval expression="@environment.getProperty('spring.datasource.driver-class-name')" var="db_driver" />
<spring:eval expression="@environment.getProperty('spring,datasource.username')" var="db_username" />
<spring:eval expression="@environment.getProperty('spring.datasource.password')" var="db_password" />

<spring:eval expression="@configProperties['mysql.server.ip']" var="mysqlServerIp"/>
<spring:eval expression="@configProperties['mysql.server.port']" var="mysqlServerPort"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>주소록 보기 1</title>
        <link rel="styleSheet" type="text/css" href="${pageContext.request.contextPath}/css/my_style.css">
    </head>
    <body>
        <h1>주소록</h1>
        <hr />
        <%
            final String JDBC_DRIVER = (String)pageContext.getAttribute("db_driver");
            // Ch06Controller.java에서 추가한 Model의 애트리뷰트 사용할 때
            final String mysqlServerIp = (String) request.getAttribute("mysql_server_ip");
            final String mysqlServerPort = (String) request.getAttribute("mysql_server_port");
            // @configProperties 사용
            // final String mysqlServer Ip (String) pageContext.getAttribute("mysql ServerIp");
            // final String mysql ServerPort (String) pageContext.getAttribute("mysqlServerPort");

            final String JDBC_URL = String.format("jdbc:mysql://%s:%s/webmail", mysqlServerIp, mysqlServerPort);
            final String USER = (String)pageContext.getAttribute("db_username");
            final String PASSWORD = (String)pageContext.getAttribute("db_password");

            try {
                Class.forName(JDBC_DRIVER);
                Connection conn = DriverManager.getConnection(JDBC_URL, USER, PASSWORD);
                Statement stmt = conn.createStatement();
                String sql = "SELECT * FROM addrbook";
                ResultSet rs = stmt.executeQuery(sql);
        %>
        <table>
            <tr>
                <th>이름</th>
                <th>이메일</th>
                <th>전화번호</th>
            </tr>
            <tbody>
                <%
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("name") + "</td>");
                        out.println("<td>" + rs.getString("email") + "</td>");
                        out.println("<td>" + rs.getString("phone") + "</td>");
                        out.println("</tr>");
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                %>
            </tbody>
        </table>
        <%
            } catch (Exception ex) {
                out.println("mysql_server = " + request.getParameter("mysql_server_ip"));
                out.println("오류가 발생했습니다. (발생 오류: " + ex.getMessage() + ")");
            }
        %>

        <br><br>

        <div>
            참고. &dollar;{db_driver} = ${db_driver}
        </div>

        <%@include file="/WEB-INF/jspf/main_footer.jspf" %>
    </body>
</html>
