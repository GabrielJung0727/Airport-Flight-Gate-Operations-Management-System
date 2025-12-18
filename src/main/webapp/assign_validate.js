function joinCheck() {
  const frm = document.forms["assign_frm"];
  if (!frm) return true;

  const flightId = (frm.flight_id.value || "").trim();
  const gateId = (frm.gate_id.value || "").trim();
  const occupyStart = (frm.occupy_start.value || "").trim();
  const occupyEnd = (frm.occupy_end.value || "").trim();

  if (!flightId) {
    alert("항공편을 선택해 주세요.");
    frm.flight_id.focus();
    return false;
  }
  if (!gateId) {
    alert("게이트를 선택해 주세요.");
    frm.gate_id.focus();
    return false;
  }
  if (!occupyStart) {
    alert("점유 시작 시간이 입력되지 않았습니다.");
    frm.occupy_start.focus();
    return false;
  }
  if (!occupyEnd) {
    alert("점유 종료 시간이 입력되지 않았습니다.");
    frm.occupy_end.focus();
    return false;
  }
  if (occupyStart >= occupyEnd) {
    alert("점유 시작 시간은 종료 시간보다 이전이어야 합니다.");
    frm.occupy_end.focus();
    return false;
  }

  return true;
}

function search() {
  window.location = "assign_list.jsp";
  return false;
}

function modify() {
  return true;
}
