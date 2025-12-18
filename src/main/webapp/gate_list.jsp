<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>게이트 조회/수정</h1>
  <p>게이트 목록을 확인하고, 클릭하여 수정할 수 있습니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">게이트 목록</p>
        <p class="card-sub">검색은 클라이언트 필터(즉시 반영)로 동작합니다.</p>
      </div>
      <div class="split">
        <a class="btn primary" href="gate_add.jsp">게이트 등록</a>
      </div>
    </div>
    <div class="card-body">
      <div class="toolbar">
        <div class="split">
          <input class="input w-360" type="text" placeholder="검색: 코드/터미널/타입/상태" data-table-filter="gateTable">
        </div>
        <div class="hint">수정하려면 게이트 ID를 클릭</div>
      </div>

      <div class="table-wrap">
        <table id="gateTable">
          <thead>
            <tr>
              <th>게이트 ID</th>
              <th>코드</th>
              <th>터미널</th>
              <th>타입</th>
              <th>상태</th>
            </tr>
          </thead>
          <tbody>
          <%
          request.setCharacterEncoding("UTF-8");
          try (Connection conn = Condb.getConnection();
               Statement st = conn.createStatement();
               ResultSet rs = st.executeQuery("select gate_id, gate_code, terminal, gate_type, gate_status from gates order by gate_id")) {
            while (rs.next()) {
              String status = rs.getString("gate_status");
              String badge = "badge";
              if ("OPEN".equals(status)) badge += " ok";
              else if ("MAINT".equals(status)) badge += " warn";
              else badge += " bad";
          %>
            <tr>
              <td><a href="gate_edit.jsp?gate_id=<%=rs.getString("gate_id")%>"><%=rs.getString("gate_id")%></a></td>
              <td><%=rs.getString("gate_code")%></td>
              <td><span class="badge purple"><%=rs.getString("terminal")%></span></td>
              <td><span class="badge"><%=rs.getString("gate_type")%></span></td>
              <td><span class="<%=badge%>"><%=status%></span></td>
            </tr>
          <%
            }
          } catch (Exception e) {
            e.printStackTrace();
          }
          %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
