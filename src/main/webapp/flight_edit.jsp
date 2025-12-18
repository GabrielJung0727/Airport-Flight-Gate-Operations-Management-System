<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String flight_id = request.getParameter("flight_id");
String flight_no = "";
String airline = "";
String origin = "";
String destination = "";
String route_type = "";
String sched_dep = "";
String sched_arr = "";
String status = "";

try (Connection conn = Condb.getConnection();
     PreparedStatement ps = conn.prepareStatement(
       "select flight_no, airline, origin, destination, route_type, sched_dep, nvl(sched_arr,'') sched_arr, status from flights where flight_id=?")) {
  ps.setInt(1, Integer.parseInt(flight_id));
  try (ResultSet rs = ps.executeQuery()) {
    if (rs.next()) {
      flight_no = rs.getString("flight_no");
      airline = rs.getString("airline");
      origin = rs.getString("origin");
      destination = rs.getString("destination");
      route_type = rs.getString("route_type");
      sched_dep = rs.getString("sched_dep");
      sched_arr = rs.getString("sched_arr");
      status = rs.getString("status");
    }
  }
} catch (Exception e) {
  e.printStackTrace();
}
%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>항공편 수정</h1>
  <p>편명/시간/상태 변경이 필요할 때 사용합니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">항공편 정보 수정</p>
        <p class="card-sub">항공편 ID는 변경할 수 없습니다.</p>
      </div>
      <div class="split">
        <a class="btn" href="flight_list.jsp">목록</a>
      </div>
    </div>
    <div class="card-body">
      <script type="text/javascript" src="flight_validate.js"></script>
      <form method="post" action="flight_action.jsp" name="flight_frm" onsubmit="return joinCheck()">
        <input type="hidden" name="mode" value="modify">
        <div class="row">
          <div class="col-3">
            <div class="field">
              <div class="label">항공편 ID</div>
              <input class="input" type="text" name="flight_id" value="<%=flight_id%>" readonly>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">편명</div>
              <input class="input" type="text" name="flight_no" value="<%=flight_no%>">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">항공사</div>
              <input class="input" type="text" name="airline" value="<%=airline%>">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">국내/국제</div>
              <select name="route_type">
                <option value="DOM" <%= "DOM".equals(route_type) ? "selected" : "" %>>DOM(국내)</option>
                <option value="INT" <%= "INT".equals(route_type) ? "selected" : "" %>>INT(국제)</option>
              </select>
            </div>
          </div>

          <div class="col-3">
            <div class="field">
              <div class="label">출발지</div>
              <input class="input" type="text" name="origin" value="<%=origin%>">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">도착지</div>
              <input class="input" type="text" name="destination" value="<%=destination%>">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">예정 출발</div>
              <input class="input" type="datetime-local" name="sched_dep" value="<%=sched_dep%>">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">예정 도착(선택)</div>
              <input class="input" type="datetime-local" name="sched_arr" value="<%=sched_arr%>">
            </div>
          </div>

          <div class="col-3">
            <div class="field">
              <div class="label">상태</div>
              <select name="status">
                <option value="SCHEDULED" <%= "SCHEDULED".equals(status) ? "selected" : "" %>>SCHEDULED</option>
                <option value="BOARDING" <%= "BOARDING".equals(status) ? "selected" : "" %>>BOARDING</option>
                <option value="DEPARTED" <%= "DEPARTED".equals(status) ? "selected" : "" %>>DEPARTED</option>
                <option value="ARRIVED" <%= "ARRIVED".equals(status) ? "selected" : "" %>>ARRIVED</option>
                <option value="DELAYED" <%= "DELAYED".equals(status) ? "selected" : "" %>>DELAYED</option>
                <option value="CANCELLED" <%= "CANCELLED".equals(status) ? "selected" : "" %>>CANCELLED</option>
              </select>
            </div>
          </div>

          <div class="col-12">
            <div class="split">
              <button class="btn primary" type="submit" onclick="return modify()">수정</button>
              <a class="btn" href="flight_list.jsp">취소</a>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
