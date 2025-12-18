<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String assign_id = request.getParameter("assign_id");

String flight_id = "";
String flight_no = "";
String airline = "";
String origin = "";
String destination = "";
String sched_dep = "";
String route_type = "";

String gate_id = "";
String occupy_start = "";
String occupy_end = "";
String assign_status = "";
String note = "";

String sql =
  "select a.flight_id, a.gate_id, a.occupy_start, a.occupy_end, a.assign_status, nvl(a.note,'') note, " +
  "f.flight_no, f.airline, f.origin, f.destination, f.sched_dep, f.route_type " +
  "from assignments a join flights f on f.flight_id=a.flight_id where a.assign_id=?";

try (Connection conn = Condb.getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {
  ps.setInt(1, Integer.parseInt(assign_id));
  try (ResultSet rs = ps.executeQuery()) {
    if (rs.next()) {
      flight_id = rs.getString("flight_id");
      gate_id = rs.getString("gate_id");
      occupy_start = rs.getString("occupy_start");
      occupy_end = rs.getString("occupy_end");
      assign_status = rs.getString("assign_status");
      note = rs.getString("note");

      flight_no = rs.getString("flight_no");
      airline = rs.getString("airline");
      origin = rs.getString("origin");
      destination = rs.getString("destination");
      sched_dep = rs.getString("sched_dep");
      route_type = rs.getString("route_type");
    }
  }
} catch (Exception e) {
  e.printStackTrace();
}
%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>배정 수정/취소</h1>
  <p>게이트/시간/상태를 변경합니다. ACTIVE 상태는 중복 배정 검사를 통과해야 합니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">배정 상세</p>
        <p class="card-sub"><%=flight_no%> · <%=airline%> · <%=origin%>→<%=destination%> · <%=sched_dep%> · <%=route_type%></p>
      </div>
      <div class="split">
        <a class="btn" href="assign_list.jsp">목록</a>
      </div>
    </div>
    <div class="card-body">
      <script type="text/javascript" src="assign_validate.js"></script>
      <form method="post" action="assign_action.jsp" name="assign_frm" onsubmit="return joinCheck()">
        <input type="hidden" name="mode" value="modify">
        <div class="row">
          <div class="col-3">
            <div class="field">
              <div class="label">배정 ID</div>
              <input class="input" type="text" name="assign_id" value="<%=assign_id%>" readonly>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">항공편 ID(고정)</div>
              <input class="input" type="text" name="flight_id" value="<%=flight_id%>" readonly>
            </div>
          </div>

          <div class="col-6">
            <div class="field">
              <div class="label">게이트 선택</div>
              <select name="gate_id">
                <option value="">선택</option>
                <%
                String gsql = "select gate_id, gate_code, terminal, gate_type, gate_status from gates order by terminal, gate_code, gate_id";
                try (Connection conn = Condb.getConnection();
                     Statement st = conn.createStatement();
                     ResultSet rs = st.executeQuery(gsql)) {
                  while (rs.next()) {
                    String gid = rs.getString("gate_id");
                    String label = rs.getString("terminal") + " · " + rs.getString("gate_code")
                        + " · " + rs.getString("gate_type")
                        + " · " + rs.getString("gate_status");
                %>
                <option value="<%=gid%>" <%=gid.equals(gate_id) ? "selected" : ""%>><%=label%></option>
                <%
                  }
                } catch (Exception e) {
                  e.printStackTrace();
                }
                %>
              </select>
            </div>
          </div>

          <div class="col-3">
            <div class="field">
              <div class="label">점유 시작</div>
              <input class="input" type="datetime-local" name="occupy_start" value="<%=occupy_start%>" data-occupy-start>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">점유 종료</div>
              <input class="input" type="datetime-local" name="occupy_end" value="<%=occupy_end%>" data-occupy-end>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">배정 상태</div>
              <select name="assign_status">
                <option value="ACTIVE" <%= "ACTIVE".equals(assign_status) ? "selected" : "" %>>ACTIVE</option>
                <option value="CANCELLED" <%= "CANCELLED".equals(assign_status) ? "selected" : "" %>>CANCELLED</option>
              </select>
            </div>
          </div>

          <div class="col-12">
            <div class="field">
              <div class="label">비고</div>
              <textarea name="note"><%=note%></textarea>
            </div>
          </div>

          <div class="col-12">
            <div class="split">
              <button class="btn primary" type="submit" onclick="return modify()">수정</button>
              <a class="btn" href="assign_list.jsp">취소</a>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
