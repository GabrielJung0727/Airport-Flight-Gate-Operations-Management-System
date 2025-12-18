<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String mode = request.getParameter("mode");
String gate_id = request.getParameter("gate_id");
String gate_code = request.getParameter("gate_code");
String terminal = request.getParameter("terminal");
String gate_type = request.getParameter("gate_type");
String gate_status = request.getParameter("gate_status");

if (mode == null) {
  response.sendRedirect("gate_list.jsp?type=error&msg=mode%20%EB%88%84%EB%9D%BD");
  return;
}

try (Connection conn = Condb.getConnection()) {
  if ("insert".equals(mode)) {
    String sql = "insert into gates (gate_id, gate_code, terminal, gate_type, gate_status) values (?,?,?,?,?)";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, Integer.parseInt(gate_id));
      ps.setString(2, gate_code);
      ps.setString(3, terminal);
      ps.setString(4, gate_type);
      ps.setString(5, gate_status);
      ps.executeUpdate();
    }
    response.sendRedirect("gate_add.jsp?type=success&msg=%EA%B2%8C%EC%9D%B4%ED%8A%B8%20%EB%93%B1%EB%A1%9D%20%EC%99%84%EB%A3%8C");
    return;
  }

  if ("modify".equals(mode)) {
    String sql = "update gates set gate_code=?, terminal=?, gate_type=?, gate_status=? where gate_id=?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, gate_code);
      ps.setString(2, terminal);
      ps.setString(3, gate_type);
      ps.setString(4, gate_status);
      ps.setInt(5, Integer.parseInt(gate_id));
      ps.executeUpdate();
    }
    response.sendRedirect("gate_list.jsp?type=success&msg=%EA%B2%8C%EC%9D%B4%ED%8A%B8%20%EC%88%98%EC%A0%95%20%EC%99%84%EB%A3%8C");
    return;
  }
} catch (Exception e) {
  e.printStackTrace();
  response.sendRedirect("gate_list.jsp?type=error&msg=%EC%B2%98%EB%A6%AC%20%EC%A4%91%20%EC%98%A4%EB%A5%98%20%EB%B0%9C%EC%83%9D");
  return;
}

response.sendRedirect("gate_list.jsp?type=error&msg=%EC%95%8C%20%EC%88%98%20%EC%97%86%EB%8A%94%20mode");
%>
