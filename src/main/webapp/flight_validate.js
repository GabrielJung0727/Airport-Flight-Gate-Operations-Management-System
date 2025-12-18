function joinCheck() {
  const frm = document.forms["flight_frm"];
  if (!frm) return true;

  const flightNo = (frm.flight_no.value || "").trim();
  const airline = (frm.airline.value || "").trim();
  const origin = (frm.origin.value || "").trim();
  const destination = (frm.destination.value || "").trim();
  const routeType = (frm.route_type.value || "").trim();
  const schedDep = (frm.sched_dep.value || "").trim();

  if (!flightNo) {
    alert("편명이 입력되지 않았습니다. 예) KE123");
    frm.flight_no.focus();
    return false;
  }
  if (!airline) {
    alert("항공사가 입력되지 않았습니다.");
    frm.airline.focus();
    return false;
  }
  if (!origin) {
    alert("출발지가 입력되지 않았습니다.");
    frm.origin.focus();
    return false;
  }
  if (!destination) {
    alert("도착지가 입력되지 않았습니다.");
    frm.destination.focus();
    return false;
  }
  if (!routeType) {
    alert("국내/국제를 선택해 주세요.");
    frm.route_type.focus();
    return false;
  }
  if (!schedDep) {
    alert("예정 출발시간이 입력되지 않았습니다.");
    frm.sched_dep.focus();
    return false;
  }

  return true;
}

function search() {
  window.location = "flight_list.jsp";
  return false;
}

function modify() {
  return true;
}
