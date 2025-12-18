<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
String flight_id = "";
try (Connection conn = Condb.getConnection();
     Statement st = conn.createStatement();
     ResultSet rs = st.executeQuery("select nvl(max(flight_id),0)+1 flight_id from flights")) {
  rs.next();
  flight_id = rs.getString("flight_id");
} catch (Exception e) {
  e.printStackTrace();
}
%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>항공편 등록</h1>
  <p>편명/노선/예정시간/상태를 관리합니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">항공편 정보 입력</p>
        <p class="card-sub">예정 출발시간은 배정 시간 자동계산에 사용됩니다.</p>
      </div>
      <div class="split">
        <button class="btn" type="button" onclick="return search()">목록</button>
      </div>
    </div>
    <div class="card-body">
      <script type="text/javascript" src="flight_validate.js"></script>
      <form method="post" action="flight_action.jsp" name="flight_frm" onsubmit="return joinCheck()">
        <input type="hidden" name="mode" value="insert">
        <div class="row">
          <div class="col-3">
            <div class="field">
              <div class="label">항공편 ID(자동)</div>
              <input class="input" type="text" name="flight_id" value="<%=flight_id%>" readonly>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">편명</div>
              <input class="input" type="text" name="flight_no" placeholder="예: KE123">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">항공사</div>
              <input class="input" type="text" name="airline" placeholder="예: KOREAN AIR">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">국내/국제</div>
              <select name="route_type">
                <option value="">선택</option>
                <option value="DOM">DOM(국내)</option>
                <option value="INT">INT(국제)</option>
              </select>
            </div>
          </div>

          <div class="col-3">
            <div class="field">
              <div class="label">출발지</div>
              <input class="input" type="text" name="origin" placeholder="예: GMP">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">도착지</div>
              <input class="input" type="text" name="destination" placeholder="예: ICN">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">예정 출발</div>
              <input class="input" type="datetime-local" name="sched_dep">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">예정 도착(선택)</div>
              <input class="input" type="datetime-local" name="sched_arr">
            </div>
          </div>

          <div class="col-3">
            <div class="field">
              <div class="label">상태</div>
              <select name="status">
                <option value="SCHEDULED" selected>SCHEDULED</option>
                <option value="BOARDING">BOARDING</option>
                <option value="DEPARTED">DEPARTED</option>
                <option value="ARRIVED">ARRIVED</option>
                <option value="DELAYED">DELAYED</option>
                <option value="CANCELLED">CANCELLED</option>
              </select>
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
