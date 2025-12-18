<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>이벤트 조회</h1>
  <p>등록된 운항 이벤트를 시간순으로 확인합니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">이벤트 목록</p>
        <p class="card-sub">검색은 즉시 필터링됩니다.</p>
      </div>
      <div class="split">
        <a class="btn primary" href="event_add.jsp">이벤트 등록</a>
      </div>
    </div>
    <div class="card-body">
      <div class="toolbar">
        <div class="split">
          <input class="input w-360" type="text" placeholder="검색: 편명/유형/사유" data-table-filter="eventTable">
        </div>
      </div>

      <div class="table-wrap">
        <table id="eventTable">
          <thead>
            <tr>
              <th>이벤트 ID</th>
              <th>항공편</th>
              <th>유형</th>
              <th>시간</th>
              <th>지연분</th>
              <th>사유</th>
            </tr>
          </thead>
          <tbody>
          <%
          request.setCharacterEncoding("UTF-8");
          String sql =
            "select e.event_id, e.event_type, e.event_time, nvl(to_char(e.delay_min),'') delay_min, nvl(e.reason,'') reason, " +
            "f.flight_no, f.airline, f.origin, f.destination " +
            "from flight_events e join flights f on f.flight_id=e.flight_id " +
            "order by e.event_time desc, e.event_id desc";
          try (Connection conn = Condb.getConnection();
               Statement st = conn.createStatement();
               ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
              String type = rs.getString("event_type");
              String badge = "badge";
              if ("DELAYED".equals(type)) badge += " warn";
              else if ("CANCELLED".equals(type)) badge += " bad";
              else if ("DEPARTED".equals(type) || "ARRIVED".equals(type)) badge += " ok";
              else badge += " purple";
          %>
            <tr>
              <td><%=rs.getString("event_id")%></td>
              <td><%=rs.getString("flight_no")%> · <%=rs.getString("airline")%> · <%=rs.getString("origin")%>→<%=rs.getString("destination")%></td>
              <td><span class="<%=badge%>"><%=type%></span></td>
              <td><%=rs.getString("event_time")%></td>
              <td><%=rs.getString("delay_min")%></td>
              <td><%=rs.getString("reason")%></td>
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
