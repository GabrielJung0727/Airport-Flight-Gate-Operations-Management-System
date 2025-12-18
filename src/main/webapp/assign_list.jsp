<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>배정 조회/수정</h1>
  <p>항공편과 게이트 배정 내역을 확인하고, 배정 ID를 클릭하여 변경/취소할 수 있습니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">배정 목록</p>
        <p class="card-sub">ACTIVE 배정은 게이트 중복 배정 방지 규칙의 대상입니다.</p>
      </div>
      <div class="split">
        <a class="btn primary" href="assign_add.jsp">배정 등록</a>
      </div>
    </div>
    <div class="card-body">
      <div class="toolbar">
        <div class="split">
          <input class="input w-360" type="text" placeholder="검색: 편명/게이트/시간/상태" data-table-filter="assignTable">
        </div>
        <div class="hint">수정하려면 배정 ID를 클릭</div>
      </div>

      <div class="table-wrap">
        <table id="assignTable">
          <thead>
            <tr>
              <th>배정 ID</th>
              <th>항공편</th>
              <th>게이트</th>
              <th>점유 시작</th>
              <th>점유 종료</th>
              <th>상태</th>
              <th>비고</th>
            </tr>
          </thead>
          <tbody>
          <%
          request.setCharacterEncoding("UTF-8");
          String sql =
            "select a.assign_id, a.occupy_start, a.occupy_end, a.assign_status, nvl(a.note,'') note, " +
            "f.flight_no, f.airline, f.origin, f.destination, g.terminal, g.gate_code, g.gate_type " +
            "from assignments a " +
            "join flights f on f.flight_id = a.flight_id " +
            "join gates g on g.gate_id = a.gate_id " +
            "order by a.assign_id desc";
          try (Connection conn = Condb.getConnection();
               Statement st = conn.createStatement();
               ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
              String status = rs.getString("assign_status");
              String badge = "badge " + ("ACTIVE".equals(status) ? "ok" : "bad");
              String gateLabel = rs.getString("terminal") + " " + rs.getString("gate_code") + " (" + rs.getString("gate_type") + ")";
              String flightLabel = rs.getString("flight_no") + " · " + rs.getString("airline") + " · " + rs.getString("origin") + "→" + rs.getString("destination");
          %>
            <tr>
              <td><a href="assign_edit.jsp?assign_id=<%=rs.getString("assign_id")%>"><%=rs.getString("assign_id")%></a></td>
              <td><%=flightLabel%></td>
              <td><span class="badge purple"><%=gateLabel%></span></td>
              <td><%=rs.getString("occupy_start")%></td>
              <td><%=rs.getString("occupy_end")%></td>
              <td><span class="<%=badge%>"><%=status%></span></td>
              <td><%=rs.getString("note")%></td>
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
