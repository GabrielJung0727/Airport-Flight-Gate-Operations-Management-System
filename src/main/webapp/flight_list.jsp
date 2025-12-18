<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>항공편 조회/수정</h1>
  <p>항공편 목록을 확인하고, ID를 클릭하여 수정할 수 있습니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">항공편 목록</p>
        <p class="card-sub">검색은 즉시 필터링됩니다.</p>
      </div>
      <div class="split">
        <a class="btn primary" href="flight_add.jsp">항공편 등록</a>
      </div>
    </div>
    <div class="card-body">
      <div class="toolbar">
        <div class="split">
          <input class="input w-360" type="text" placeholder="검색: 편명/항공사/노선/상태" data-table-filter="flightTable">
        </div>
        <div class="hint">수정하려면 항공편 ID를 클릭</div>
      </div>

      <div class="table-wrap">
        <table id="flightTable">
          <thead>
            <tr>
              <th>항공편 ID</th>
              <th>편명</th>
              <th>항공사</th>
              <th>노선</th>
              <th>구분</th>
              <th>예정 출발</th>
              <th>상태</th>
            </tr>
          </thead>
          <tbody>
          <%
          request.setCharacterEncoding("UTF-8");
          String sql = "select flight_id, flight_no, airline, origin, destination, route_type, sched_dep, status from flights order by sched_dep, flight_id";
          try (Connection conn = Condb.getConnection();
               Statement st = conn.createStatement();
               ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
              String status = rs.getString("status");
              String badge = "badge";
              if ("DELAYED".equals(status)) badge += " warn";
              else if ("CANCELLED".equals(status)) badge += " bad";
              else if ("DEPARTED".equals(status) || "ARRIVED".equals(status)) badge += " ok";
              else badge += " purple";
          %>
            <tr>
              <td><a href="flight_edit.jsp?flight_id=<%=rs.getString("flight_id")%>"><%=rs.getString("flight_id")%></a></td>
              <td><b><%=rs.getString("flight_no")%></b></td>
              <td><%=rs.getString("airline")%></td>
              <td><%=rs.getString("origin")%> → <%=rs.getString("destination")%></td>
              <td><span class="badge"><%=rs.getString("route_type")%></span></td>
              <td><%=rs.getString("sched_dep")%></td>
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
