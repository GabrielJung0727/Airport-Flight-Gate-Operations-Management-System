<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
String gate_id = "";
try (Connection conn = Condb.getConnection();
     Statement st = conn.createStatement();
     ResultSet rs = st.executeQuery("select nvl(max(gate_id),0)+1 gate_id from gates")) {
  rs.next();
  gate_id = rs.getString("gate_id");
} catch (Exception e) {
  e.printStackTrace();
}
%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>게이트 등록</h1>
  <p>터미널/게이트 타입/상태를 관리합니다. 점검(MAINT)·폐쇄(CLOSED) 게이트는 배정이 제한됩니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">게이트 정보 입력</p>
        <p class="card-sub">필수 항목을 입력하고 등록하세요.</p>
      </div>
      <div class="split">
        <button class="btn" type="button" onclick="return search()">목록</button>
      </div>
    </div>
    <div class="card-body">
      <script type="text/javascript" src="gate_validate.js"></script>
      <form method="post" action="gate_action.jsp" name="gate_frm" onsubmit="return joinCheck()">
        <input type="hidden" name="mode" value="insert">
        <div class="row">
          <div class="col-3">
            <div class="field">
              <div class="label">게이트 ID(자동)</div>
              <input class="input" type="text" name="gate_id" value="<%=gate_id%>" readonly>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">게이트 코드</div>
              <input class="input" type="text" name="gate_code" placeholder="예: A01">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">터미널</div>
              <select name="terminal">
                <option value="">선택</option>
                <option value="T1">T1</option>
                <option value="T2">T2</option>
              </select>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">게이트 타입</div>
              <select name="gate_type">
                <option value="">선택</option>
                <option value="DOM">DOM(국내)</option>
                <option value="INT">INT(국제)</option>
                <option value="MIX">MIX(혼합)</option>
              </select>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">게이트 상태</div>
              <select name="gate_status">
                <option value="">선택</option>
                <option value="OPEN" selected>OPEN(정상)</option>
                <option value="MAINT">MAINT(점검)</option>
                <option value="CLOSED">CLOSED(폐쇄)</option>
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
      <p class="hint" style="margin-top:10px">
        팁: 코드/터미널/타입을 통일된 규칙으로 입력하면 조회/리포트가 더 깔끔해집니다.
        (표준 정의: <code>docs/gate_codes.md</code>)
      </p>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
