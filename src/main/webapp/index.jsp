<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="header.jsp"/>

<div class="hero">
  <h1>공항 항공편/게이트 운영 관리</h1>
  <p>
    항공편(Flight) · 게이트(Gate) · 배정(Assignment) · 운항 이벤트(Event)를 관리하고,
    일일 운항표/지연 통계/게이트 사용률을 리포트로 조회하는 프로그램입니다.
  </p>
</div>

<div class="grid">
  <div class="card" style="grid-column: span 12;">
    <div class="card-header">
      <div>
        <p class="card-title">시작하기</p>
        <p class="card-sub">권장 흐름: 게이트 → 항공편 → 배정 → 이벤트 → 리포트</p>
      </div>
      <div class="split">
        <a class="btn primary" href="gate_add.jsp">게이트 등록</a>
        <a class="btn primary" href="flight_add.jsp">항공편 등록</a>
        <a class="btn primary" href="assign_add.jsp">게이트 배정</a>
        <a class="btn" href="reports.jsp">리포트</a>
      </div>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-6">
          <p class="hint">
            DB 스키마는 <b><code>db/airport_schema.sql</code></b> 을 사용합니다.
            (기존 서점 테이블과 별개로 생성)
          </p>
        </div>
        <div class="col-6">
          <p class="hint">
            게이트 배정은 <b>시간 구간 중복</b>이 있으면 등록/변경이 차단됩니다.
            (출발 60분 전 ~ 출발 15분 후 자동 계산 지원)
          </p>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"/>
