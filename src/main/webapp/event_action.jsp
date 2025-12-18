<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String mode = request.getParameter("mode");
String event_id = request.getParameter("event_id");
String flight_id = request.getParameter("flight_id");
String event_type = request.getParameter("event_type");
String event_time = request.getParameter("event_time");
String delay_min = request.getParameter("delay_min");
String reason = request.getParameter("reason");

if (!"insert".equals(mode)) {
  response.sendRedirect("event_list.jsp?type=error&msg=mode%20%EB%88%84%EB%9D%BD");
  return;
}

String newFlightStatus = null;
if ("DELAYED".equals(event_type)) newFlightStatus = "DELAYED";
else if ("CANCELLED".equals(event_type)) newFlightStatus = "CANCELLED";
else if ("BOARDING".equals(event_type)) newFlightStatus = "BOARDING";
else if ("DEPARTED".equals(event_type)) newFlightStatus = "DEPARTED";
else if ("ARRIVED".equals(event_type)) newFlightStatus = "ARRIVED";

try (Connection conn = Condb.getConnection()) {
  String insertSql = "insert into flight_events (event_id, flight_id, event_type, event_time, delay_min, reason) values (?,?,?,?,?,?)";
  try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
    ps.setInt(1, Integer.parseInt(event_id));
    ps.setInt(2, Integer.parseInt(flight_id));
    ps.setString(3, event_type);
    ps.setString(4, event_time);
    if (delay_min == null || delay_min.trim().isEmpty()) ps.setNull(5, Types.NUMERIC);
    else ps.setInt(5, Integer.parseInt(delay_min));
    ps.setString(6, (reason == null || reason.trim().isEmpty()) ? null : reason);
    ps.executeUpdate();
  }

  if (newFlightStatus != null) {
    try (PreparedStatement ps = conn.prepareStatement("update flights set status=? where flight_id=?")) {
      ps.setString(1, newFlightStatus);
      ps.setInt(2, Integer.parseInt(flight_id));
      ps.executeUpdate();
    }
  }
} catch (Exception e) {
  e.printStackTrace();
  response.sendRedirect("event_list.jsp?type=error&msg=%EC%9D%B4%EB%B2%A4%ED%8A%B8%20%EB%93%B1%EB%A1%9D%20%EC%8B%A4%ED%8C%A8");
  return;
}

response.sendRedirect("event_add.jsp?type=success&msg=%EC%9D%B4%EB%B2%A4%ED%8A%B8%20%EB%93%B1%EB%A1%9D%20%EC%99%84%EB%A3%8C");
%>
