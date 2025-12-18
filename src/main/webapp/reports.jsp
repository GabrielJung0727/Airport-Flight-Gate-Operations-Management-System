<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
String view = request.getParameter("view");
if (view == null || view.trim().isEmpty()) view = "daily";

String date = request.getParameter("date");
if (date == null || date.trim().isEmpty()) {
  // 'YYYY-MM-DD' (서버 로컬 기준)
  java.time.LocalDate today = java.time.LocalDate.now();
  date = today.toString();
}
%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>리포트</h1>
  <p>일일 운항표 · 지연 통계 · 게이트 사용률을 확인합니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">리포트 선택</p>
        <p class="card-sub">날짜 기준으로 조회합니다.</p>
      </div>
      <div class="split">
        <a class="btn <%= "daily".equals(view) ? "primary" : "" %>" href="reports.jsp?view=daily&date=<%=date%>">일일 운항표</a>
        <a class="btn <%= "delay".equals(view) ? "primary" : "" %>" href="reports.jsp?view=delay&date=<%=date%>">지연 통계</a>
        <a class="btn <%= "gate".equals(view) ? "primary" : "" %>" href="reports.jsp?view=gate&date=<%=date%>">게이트 사용률</a>
      </div>
    </div>
    <div class="card-body">
      <form method="get" action="reports.jsp">
        <input type="hidden" name="view" value="<%=view%>">
        <div class="row">
          <div class="col-3">
            <div class="field">
              <div class="label">조회 날짜</div>
              <input class="input" type="date" name="date" value="<%=date%>">
            </div>
          </div>
          <div class="col-12">
            <div class="split">
              <button class="btn primary" type="submit">조회</button>
              <span class="hint">항공편의 `sched_dep`가 <%=date%>로 시작하는 데이터 기준</span>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>

  <%
  if ("daily".equals(view)) {
  %>
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">일일 운항표</p>
        <p class="card-sub"><%=date%> 기준</p>
      </div>
      <div class="hint">게이트는 ACTIVE 배정 중 항공편별 최신 배정 1건을 표시</div>
    </div>
    <div class="card-body">
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>편명</th>
              <th>노선</th>
              <th>예정 출발</th>
              <th>구분</th>
              <th>게이트</th>
              <th>상태</th>
            </tr>
          </thead>
          <tbody>
          <%
          String dsql =
            "select f.flight_no, f.airline, f.origin, f.destination, f.sched_dep, f.route_type, f.status, " +
            "nvl(g.terminal,'') terminal, nvl(g.gate_code,'') gate_code, nvl(g.gate_type,'') gate_type " +
            "from flights f " +
            "left join (" +
            "  select a.flight_id, max(a.assign_id) max_assign_id from assignments a " +
            "  where a.assign_status='ACTIVE' group by a.flight_id" +
            ") am on am.flight_id = f.flight_id " +
            "left join assignments a2 on a2.assign_id = am.max_assign_id " +
            "left join gates g on g.gate_id = a2.gate_id " +
            "where f.sched_dep like ? " +
            "order by f.sched_dep, f.flight_id";

          try (Connection conn = Condb.getConnection();
               PreparedStatement ps = conn.prepareStatement(dsql)) {
            ps.setString(1, date + "%");
            try (ResultSet rs = ps.executeQuery()) {
              while (rs.next()) {
                String status = rs.getString("status");
                String badge = "badge";
                if ("DELAYED".equals(status)) badge += " warn";
                else if ("CANCELLED".equals(status)) badge += " bad";
                else if ("DEPARTED".equals(status) || "ARRIVED".equals(status)) badge += " ok";
                else badge += " purple";
                String terminal = rs.getString("terminal");
                String gateLabel = (terminal == null || terminal.trim().isEmpty()) ? "-" :
                  (terminal + " " + rs.getString("gate_code") + " (" + rs.getString("gate_type") + ")");
          %>
            <tr>
              <td><b><%=rs.getString("flight_no")%></b> · <%=rs.getString("airline")%></td>
              <td><%=rs.getString("origin")%> → <%=rs.getString("destination")%></td>
              <td><%=rs.getString("sched_dep")%></td>
              <td><span class="badge"><%=rs.getString("route_type")%></span></td>
              <td><span class="badge purple"><%=gateLabel%></span></td>
              <td><span class="<%=badge%>"><%=status%></span></td>
            </tr>
          <%
              }
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
  <%
  } else if ("delay".equals(view)) {
  %>
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">지연 통계</p>
        <p class="card-sub"><%=date%> 기준(이벤트 시간 기준)</p>
      </div>
    </div>
    <div class="card-body">
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>편명</th>
              <th>지연 횟수</th>
              <th>지연 합계(분)</th>
              <th>최근 사유</th>
            </tr>
          </thead>
          <tbody>
          <%
          String s1 =
            "select f.flight_no, f.airline, " +
            "count(*) delay_cnt, nvl(sum(nvl(e.delay_min,0)),0) delay_sum " +
            "from flight_events e join flights f on f.flight_id=e.flight_id " +
            "where e.event_type='DELAYED' and e.event_time like ? " +
            "group by f.flight_no, f.airline " +
            "order by delay_sum desc, delay_cnt desc";

          try (Connection conn = Condb.getConnection();
               PreparedStatement ps = conn.prepareStatement(s1)) {
            ps.setString(1, date + "%");
            try (ResultSet rs = ps.executeQuery()) {
              while (rs.next()) {
                String flightNo = rs.getString("flight_no");
                String airline = rs.getString("airline");
                int delayCnt = rs.getInt("delay_cnt");
                int delaySum = rs.getInt("delay_sum");
                String reasonLatest = "";

                String s2 =
                  "select reason from (" +
                  "  select nvl(reason,'') reason from flight_events e2 join flights f2 on f2.flight_id=e2.flight_id " +
                  "  where e2.event_type='DELAYED' and f2.flight_no=? and e2.event_time like ? " +
                  "  order by e2.event_time desc, e2.event_id desc" +
                  ") where rownum=1";
                try (PreparedStatement ps2 = conn.prepareStatement(s2)) {
                  ps2.setString(1, flightNo);
                  ps2.setString(2, date + "%");
                  try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) reasonLatest = rs2.getString(1);
                  }
                }
          %>
            <tr>
              <td><b><%=flightNo%></b> · <%=airline%></td>
              <td><span class="badge warn"><%=delayCnt%></span></td>
              <td><span class="badge warn"><%=delaySum%></span></td>
              <td><%=reasonLatest%></td>
            </tr>
          <%
              }
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
  <%
  } else if ("gate".equals(view)) {
  %>
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">게이트 사용률</p>
        <p class="card-sub"><%=date%> 기준(점유 시작이 해당 날짜인 ACTIVE 배정)</p>
      </div>
    </div>
    <div class="card-body">
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>게이트</th>
              <th>배정 건수</th>
              <th>상태</th>
            </tr>
          </thead>
          <tbody>
          <%
          String gsql =
            "select g.terminal, g.gate_code, g.gate_type, g.gate_status, count(*) cnt " +
            "from assignments a join gates g on g.gate_id=a.gate_id " +
            "where a.assign_status='ACTIVE' and a.occupy_start like ? " +
            "group by g.terminal, g.gate_code, g.gate_type, g.gate_status " +
            "order by cnt desc, g.terminal, g.gate_code";
          try (Connection conn = Condb.getConnection();
               PreparedStatement ps = conn.prepareStatement(gsql)) {
            ps.setString(1, date + "%");
            try (ResultSet rs = ps.executeQuery()) {
              while (rs.next()) {
                String status = rs.getString("gate_status");
                String badge = "badge";
                if ("OPEN".equals(status)) badge += " ok";
                else if ("MAINT".equals(status)) badge += " warn";
                else badge += " bad";
          %>
            <tr>
              <td><%=rs.getString("terminal")%> <b><%=rs.getString("gate_code")%></b> (<%=rs.getString("gate_type")%>)</td>
              <td><span class="badge purple"><%=rs.getInt("cnt")%></span></td>
              <td><span class="<%=badge%>"><%=status%></span></td>
            </tr>
          <%
              }
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
  <%
  }
  %>
</div>

<jsp:include page="footer.jsp"/>
