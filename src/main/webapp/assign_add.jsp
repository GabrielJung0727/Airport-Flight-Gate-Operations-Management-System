<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
String assign_id = "";
try (Connection conn = Condb.getConnection();
     Statement st = conn.createStatement();
     ResultSet rs = st.executeQuery("select nvl(max(assign_id),0)+1 assign_id from assignments")) {
  rs.next();
  assign_id = rs.getString("assign_id");
} catch (Exception e) {
  e.printStackTrace();
}
%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>게이트 배정 등록</h1>
  <p>게이트 중복 배정(시간 구간 겹침)은 자동으로 차단됩니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">배정 정보 입력</p>
        <p class="card-sub">“시간 자동계산”을 사용하면 출발 기준으로 점유 시간이 채워집니다.</p>
      </div>
      <div class="split">
        <button class="btn" type="button" onclick="return search()">목록</button>
      </div>
    </div>
    <div class="card-body">
      <script type="text/javascript" src="assign_validate.js"></script>
      <form method="post" action="assign_action.jsp" name="assign_frm" onsubmit="return joinCheck()">
        <input type="hidden" name="mode" value="insert">
        <div class="row">
          <div class="col-3">
            <div class="field">
              <div class="label">배정 ID(자동)</div>
              <input class="input" type="text" name="assign_id" value="<%=assign_id%>" readonly>
            </div>
          </div>

          <div class="col-6">
            <div class="field">
              <div class="label">항공편 선택</div>
              <select name="flight_id" data-flight-select>
                <option value="">선택</option>
                <%
                String fsql = "select flight_id, flight_no, airline, origin, destination, route_type, sched_dep, status from flights order by sched_dep, flight_id";
                try (Connection conn = Condb.getConnection();
                     Statement st = conn.createStatement();
                     ResultSet rs = st.executeQuery(fsql)) {
                  while (rs.next()) {
                    String fid = rs.getString("flight_id");
                    String label = rs.getString("flight_no") + " · " + rs.getString("airline")
                        + " · " + rs.getString("origin") + "→" + rs.getString("destination")
                        + " · " + rs.getString("sched_dep")
                        + " · " + rs.getString("route_type")
                        + " · " + rs.getString("status");
                %>
                <option value="<%=fid%>" data-dep="<%=rs.getString("sched_dep")%>"><%=label%></option>
                <%
                  }
                } catch (Exception e) {
                  e.printStackTrace();
                }
                %>
              </select>
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
                <option value="<%=gid%>"><%=label%></option>
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
              <input class="input" type="datetime-local" name="occupy_start" data-occupy-start>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">점유 종료</div>
              <input class="input" type="datetime-local" name="occupy_end" data-occupy-end>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">배정 상태</div>
              <select name="assign_status">
                <option value="ACTIVE" selected>ACTIVE</option>
                <option value="CANCELLED">CANCELLED</option>
              </select>
            </div>
          </div>
          <div class="col-12">
            <div class="field">
              <div class="label">비고(선택)</div>
              <textarea name="note" placeholder="예: 항공기 교체 예정, 승무원 교대 등"></textarea>
            </div>
          </div>

          <div class="col-12">
            <div class="split">
              <button class="btn" type="button" data-occupy-auto>시간 자동계산</button>
              <button class="btn primary" type="submit">등록</button>
              <button class="btn" type="reset">초기화</button>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
