<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="ko" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>공항 항공편/게이트 운영 관리</title>
  <link rel="stylesheet" href="app.css">
  <script defer src="app.js"></script>
</head>
<body>
  <div class="topbar">
    <div class="topbar-inner">
      <a class="brand" href="index.jsp">
        <span class="logo" aria-hidden="true"></span>
        <span>Airport Ops</span>
      </a>

      <nav class="nav" aria-label="main">
        <a class="chip" data-page="gate_add.jsp" href="gate_add.jsp">게이트 등록</a>
        <a class="chip" data-page="gate_list.jsp" href="gate_list.jsp">게이트 조회</a>
        <a class="chip" data-page="flight_add.jsp" href="flight_add.jsp">항공편 등록</a>
        <a class="chip" data-page="flight_list.jsp" href="flight_list.jsp">항공편 조회</a>
        <a class="chip" data-page="assign_add.jsp" href="assign_add.jsp">게이트 배정</a>
        <a class="chip" data-page="assign_list.jsp" href="assign_list.jsp">배정 조회</a>
        <a class="chip" data-page="event_add.jsp" href="event_add.jsp">이벤트 등록</a>
        <a class="chip" data-page="event_list.jsp" href="event_list.jsp">이벤트 조회</a>
        <a class="chip" data-page="reports.jsp" href="reports.jsp">리포트</a>
      </nav>

      <div class="actions">
        <button class="btn" type="button" data-theme-toggle>테마</button>
        <a class="btn primary" href="index.jsp">홈</a>
      </div>
    </div>
  </div>

  <main class="container">
