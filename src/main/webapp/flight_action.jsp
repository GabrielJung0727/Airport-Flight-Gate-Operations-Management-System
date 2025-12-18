<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String mode = request.getParameter("mode");
String flight_id = request.getParameter("flight_id");
String flight_no = request.getParameter("flight_no");
String airline = request.getParameter("airline");
String origin = request.getParameter("origin");
String destination = request.getParameter("destination");
String route_type = request.getParameter("route_type");
String sched_dep = request.getParameter("sched_dep");
String sched_arr = request.getParameter("sched_arr");
String status = request.getParameter("status");

if (mode == null) {
  response.sendRedirect("flight_list.jsp?type=error&msg=mode%20%EB%88%84%EB%9D%BD");
  return;
}

try (Connection conn = Condb.getConnection()) {
  if ("insert".equals(mode)) {
    String sql = "insert into flights (flight_id, flight_no, airline, origin, destination, route_type, sched_dep, sched_arr, status) values (?,?,?,?,?,?,?,?,?)";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, Integer.parseInt(flight_id));
      ps.setString(2, flight_no);
      ps.setString(3, airline);
      ps.setString(4, origin);
      ps.setString(5, destination);
      ps.setString(6, route_type);
      ps.setString(7, sched_dep);
      ps.setString(8, (sched_arr == null || sched_arr.trim().isEmpty()) ? null : sched_arr);
      ps.setString(9, (status == null || status.trim().isEmpty()) ? "SCHEDULED" : status);
      ps.executeUpdate();
    }
    response.sendRedirect("flight_add.jsp?type=success&msg=%ED%95%AD%EA%B3%B5%ED%8E%B8%20%EB%93%B1%EB%A1%9D%20%EC%99%84%EB%A3%8C");
    return;
  }

  if ("modify".equals(mode)) {
    String sql = "update flights set flight_no=?, airline=?, origin=?, destination=?, route_type=?, sched_dep=?, sched_arr=?, status=? where flight_id=?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, flight_no);
      ps.setString(2, airline);
      ps.setString(3, origin);
      ps.setString(4, destination);
      ps.setString(5, route_type);
      ps.setString(6, sched_dep);
      ps.setString(7, (sched_arr == null || sched_arr.trim().isEmpty()) ? null : sched_arr);
      ps.setString(8, status);
      ps.setInt(9, Integer.parseInt(flight_id));
      ps.executeUpdate();
    }
    response.sendRedirect("flight_list.jsp?type=success&msg=%ED%95%AD%EA%B3%B5%ED%8E%B8%20%EC%88%98%EC%A0%95%20%EC%99%84%EB%A3%8C");
    return;
  }
} catch (Exception e) {
  e.printStackTrace();
  response.sendRedirect("flight_list.jsp?type=error&msg=%EC%B2%98%EB%A6%AC%20%EC%A4%91%20%EC%98%A4%EB%A5%98%20%EB%B0%9C%EC%83%9D");
  return;
}

response.sendRedirect("flight_list.jsp?type=error&msg=%EC%95%8C%20%EC%88%98%20%EC%97%86%EB%8A%94%20mode");
%>
