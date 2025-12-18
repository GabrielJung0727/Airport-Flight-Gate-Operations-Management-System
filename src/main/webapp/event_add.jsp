<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
String event_id = "";
try (Connection conn = Condb.getConnection();
     Statement st = conn.createStatement();
     ResultSet rs = st.executeQuery("select nvl(max(event_id),0)+1 event_id from flight_events")) {
  rs.next();
  event_id = rs.getString("event_id");
} catch (Exception e) {
  e.printStackTrace();
}
%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>운항 이벤트 등록</h1>
  <p>지연/탑승/출발/도착/결항 등 이벤트를 기록하고 항공편 상태를 갱신합니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">이벤트 입력</p>
        <p class="card-sub">DELAYED일 때는 지연분과 사유를 함께 입력하는 것을 권장합니다.</p>
      </div>
      <div class="split">
        <a class="btn" href="event_list.jsp">목록</a>
      </div>
    </div>
    <div class="card-body">
      <form method="post" action="event_action.jsp">
        <input type="hidden" name="mode" value="insert">
        <div class="row">
          <div class="col-3">
            <div class="field">
              <div class="label">이벤트 ID(자동)</div>
              <input class="input" type="text" name="event_id" value="<%=event_id%>" readonly>
            </div>
          </div>
          <div class="col-6">
            <div class="field">
              <div class="label">항공편 선택</div>
              <select name="flight_id" required>
                <option value="">선택</option>
                <%
                String fsql = "select flight_id, flight_no, airline, origin, destination, sched_dep, status from flights order by sched_dep, flight_id";
                try (Connection conn = Condb.getConnection();
                     Statement st = conn.createStatement();
                     ResultSet rs = st.executeQuery(fsql)) {
                  while (rs.next()) {
                    String fid = rs.getString("flight_id");
                    String label = rs.getString("flight_no") + " · " + rs.getString("airline")
                        + " · " + rs.getString("origin") + "→" + rs.getString("destination")
                        + " · " + rs.getString("sched_dep")
                        + " · " + rs.getString("status");
                %>
                <option value="<%=fid%>"><%=label%></option>
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
              <div class="label">이벤트 유형</div>
              <select name="event_type" required>
                <option value="CHECKIN_OPEN">CHECKIN_OPEN</option>
                <option value="BOARDING">BOARDING</option>
                <option value="DEPARTED">DEPARTED</option>
                <option value="ARRIVED">ARRIVED</option>
                <option value="DELAYED">DELAYED</option>
                <option value="CANCELLED">CANCELLED</option>
                <option value="GATE_CHANGED">GATE_CHANGED</option>
              </select>
            </div>
          </div>

          <div class="col-3">
            <div class="field">
              <div class="label">이벤트 시간</div>
              <input class="input" type="datetime-local" name="event_time" required>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">지연분(선택)</div>
              <input class="input" type="number" name="delay_min" min="0" placeholder="예: 30">
            </div>
          </div>
          <div class="col-12">
            <div class="field">
              <div class="label">사유(선택)</div>
              <textarea name="reason" placeholder="예: 기상 악화, 정비 지연, 승객 탑승 지연 등"></textarea>
            </div>
          </div>

          <div class="col-12">
            <div class="split">
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
