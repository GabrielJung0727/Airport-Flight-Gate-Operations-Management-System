<%@page import="airport.Condb"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String gate_id = request.getParameter("gate_id");
String gate_code = "";
String terminal = "";
String gate_type = "";
String gate_status = "";

try (Connection conn = Condb.getConnection();
     PreparedStatement ps = conn.prepareStatement("select gate_code, terminal, gate_type, gate_status from gates where gate_id=?")) {
  ps.setInt(1, Integer.parseInt(gate_id));
  try (ResultSet rs = ps.executeQuery()) {
    if (rs.next()) {
      gate_code = rs.getString("gate_code");
      terminal = rs.getString("terminal");
      gate_type = rs.getString("gate_type");
      gate_status = rs.getString("gate_status");
    }
  }
} catch (Exception e) {
  e.printStackTrace();
}
%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>게이트 수정</h1>
  <p>게이트 상태를 변경하면 배정 가능 여부에 영향을 줍니다.</p>
</div>

<div class="grid">
  <div class="card">
    <div class="card-header">
      <div>
        <p class="card-title">게이트 정보 수정</p>
        <p class="card-sub">게이트 ID는 변경할 수 없습니다.</p>
      </div>
      <div class="split">
        <a class="btn" href="gate_list.jsp">목록</a>
      </div>
    </div>
    <div class="card-body">
      <script type="text/javascript" src="gate_validate.js"></script>
      <form method="post" action="gate_action.jsp" name="gate_frm" onsubmit="return joinCheck()">
        <input type="hidden" name="mode" value="modify">
        <div class="row">
          <div class="col-3">
            <div class="field">
              <div class="label">게이트 ID</div>
              <input class="input" type="text" name="gate_id" value="<%=gate_id%>" readonly>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">게이트 코드</div>
              <input class="input" type="text" name="gate_code" value="<%=gate_code%>">
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">터미널</div>
              <select name="terminal">
                <option value="T1" <%= "T1".equals(terminal) ? "selected" : "" %>>T1</option>
                <option value="T2" <%= "T2".equals(terminal) ? "selected" : "" %>>T2</option>
              </select>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">게이트 타입</div>
              <select name="gate_type">
                <option value="DOM" <%= "DOM".equals(gate_type) ? "selected" : "" %>>DOM(국내)</option>
                <option value="INT" <%= "INT".equals(gate_type) ? "selected" : "" %>>INT(국제)</option>
                <option value="MIX" <%= "MIX".equals(gate_type) ? "selected" : "" %>>MIX(혼합)</option>
              </select>
            </div>
          </div>
          <div class="col-3">
            <div class="field">
              <div class="label">게이트 상태</div>
              <select name="gate_status">
                <option value="OPEN" <%= "OPEN".equals(gate_status) ? "selected" : "" %>>OPEN(정상)</option>
                <option value="MAINT" <%= "MAINT".equals(gate_status) ? "selected" : "" %>>MAINT(점검)</option>
                <option value="CLOSED" <%= "CLOSED".equals(gate_status) ? "selected" : "" %>>CLOSED(폐쇄)</option>
              </select>
            </div>
          </div>
          <div class="col-12">
            <div class="split">
              <button class="btn primary" type="submit" onclick="return modify()">수정</button>
              <a class="btn" href="gate_list.jsp">취소</a>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
