<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String mode = request.getParameter("mode");
String assign_id = request.getParameter("assign_id");
String flight_id = request.getParameter("flight_id");
String gate_id = request.getParameter("gate_id");
String occupy_start = request.getParameter("occupy_start");
String occupy_end = request.getParameter("occupy_end");
String assign_status = request.getParameter("assign_status");
String note = request.getParameter("note");

if (mode == null) {
  response.sendRedirect("assign_list.jsp?type=error&msg=mode%20%EB%88%84%EB%9D%BD");
  return;
}

boolean shouldCheck = "ACTIVE".equals(assign_status);

String returnPage = "insert".equals(mode) ? "assign_add.jsp" : "assign_edit.jsp?assign_id=" + assign_id;
String returnSep = returnPage.contains("?") ? "&" : "?";

try (Connection conn = Condb.getConnection()) {
  if (shouldCheck) {
    // Gate status check (MAINT/CLOSED block)
    try (PreparedStatement ps = conn.prepareStatement("select gate_status, gate_type from gates where gate_id=?")) {
      ps.setInt(1, Integer.parseInt(gate_id));
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          String gateStatus = rs.getString("gate_status");
          if (!"OPEN".equals(gateStatus)) {
            response.sendRedirect(returnPage + returnSep + "type=error&msg=%EA%B2%8C%EC%9D%B4%ED%8A%B8%20%EC%83%81%ED%83%9C%EA%B0%80%20OPEN%EC%9D%B4%20%EC%95%84%EB%8B%99%EB%8B%88%EB%8B%A4");
            return;
          }
        }
      }
    }

    // Route type vs gate type check
    String routeType = null;
    String gateType = null;
    try (PreparedStatement ps = conn.prepareStatement(
      "select f.route_type, g.gate_type from flights f join gates g on g.gate_id=? where f.flight_id=?")) {
      ps.setInt(1, Integer.parseInt(gate_id));
      ps.setInt(2, Integer.parseInt(flight_id));
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          routeType = rs.getString(1);
          gateType = rs.getString(2);
        }
      }
    }
    if (routeType != null && gateType != null) {
      if ("INT".equals(routeType) && "DOM".equals(gateType)) {
        response.sendRedirect(returnPage + returnSep + "type=error&msg=%EA%B5%AD%EC%A0%9C%ED%8E%B8%EC%9D%80%20DOM%20%EA%B2%8C%EC%9D%B4%ED%8A%B8%EC%97%90%20%EB%B0%B0%EC%A0%95%ED%95%A0%20%EC%88%98%20%EC%97%86%EC%8A%B5%EB%8B%88%EB%8B%A4");
        return;
      }
      if ("DOM".equals(routeType) && "INT".equals(gateType)) {
        response.sendRedirect(returnPage + returnSep + "type=error&msg=%EA%B5%AD%EB%82%B4%ED%8E%B8%EC%9D%80%20INT%20%EA%B2%8C%EC%9D%B4%ED%8A%B8%EC%97%90%20%EB%B0%B0%EC%A0%95%ED%95%A0%20%EC%88%98%20%EC%97%86%EC%8A%B5%EB%8B%88%EB%8B%A4");
        return;
      }
    }

    // Overlap check (same gate, ACTIVE, intersect time)
    String overlapSql =
      "select count(*) cnt from assignments " +
      "where gate_id=? and assign_status='ACTIVE' " +
      "and occupy_start < ? and occupy_end > ? " +
      (("modify".equals(mode)) ? "and assign_id <> ? " : "");
    try (PreparedStatement ps = conn.prepareStatement(overlapSql)) {
      ps.setInt(1, Integer.parseInt(gate_id));
      ps.setString(2, occupy_end);
      ps.setString(3, occupy_start);
      if ("modify".equals(mode)) {
        ps.setInt(4, Integer.parseInt(assign_id));
      }
      try (ResultSet rs = ps.executeQuery()) {
        rs.next();
        if (rs.getInt("cnt") > 0) {
          response.sendRedirect(returnPage + returnSep + "type=error&msg=%EA%B2%8C%EC%9D%B4%ED%8A%B8%20%EC%A4%91%EB%B3%B5%20%EB%B0%B0%EC%A0%95(%EC%8B%9C%EA%B0%84%20%EA%B2%B9%EC%B9%A8)%EC%9E%85%EB%8B%88%EB%8B%A4");
          return;
        }
      }
    }
  }

  if ("insert".equals(mode)) {
    String sql = "insert into assignments (assign_id, flight_id, gate_id, occupy_start, occupy_end, assign_status, note) values (?,?,?,?,?,?,?)";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, Integer.parseInt(assign_id));
      ps.setInt(2, Integer.parseInt(flight_id));
      ps.setInt(3, Integer.parseInt(gate_id));
      ps.setString(4, occupy_start);
      ps.setString(5, occupy_end);
      ps.setString(6, assign_status);
      ps.setString(7, (note == null || note.trim().isEmpty()) ? null : note);
      ps.executeUpdate();
    }
    response.sendRedirect("assign_add.jsp?type=success&msg=%EA%B2%8C%EC%9D%B4%ED%8A%B8%20%EB%B0%B0%EC%A0%95%20%EB%93%B1%EB%A1%9D%20%EC%99%84%EB%A3%8C");
    return;
  }

  if ("modify".equals(mode)) {
    String sql = "update assignments set gate_id=?, occupy_start=?, occupy_end=?, assign_status=?, note=? where assign_id=?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, Integer.parseInt(gate_id));
      ps.setString(2, occupy_start);
      ps.setString(3, occupy_end);
      ps.setString(4, assign_status);
      ps.setString(5, (note == null || note.trim().isEmpty()) ? null : note);
      ps.setInt(6, Integer.parseInt(assign_id));
      ps.executeUpdate();
    }
    response.sendRedirect("assign_list.jsp?type=success&msg=%EB%B0%B0%EC%A0%95%20%EC%88%98%EC%A0%95%20%EC%99%84%EB%A3%8C");
    return;
  }
} catch (Exception e) {
  e.printStackTrace();
  response.sendRedirect("assign_list.jsp?type=error&msg=%EC%B2%98%EB%A6%AC%20%EC%A4%91%20%EC%98%A4%EB%A5%98%20%EB%B0%9C%EC%83%9D");
  return;
}

response.sendRedirect("assign_list.jsp?type=error&msg=%EC%95%8C%20%EC%88%98%20%EC%97%86%EB%8A%94%20mode");
%>
