function joinCheck() {
  const frm = document.forms["gate_frm"];
  if (!frm) return true;

  const gateCode = (frm.gate_code.value || "").trim();
  const terminal = (frm.terminal.value || "").trim();
  const gateType = (frm.gate_type.value || "").trim();
  const gateStatus = (frm.gate_status.value || "").trim();

  if (!gateCode) {
    alert("게이트 코드가 입력되지 않았습니다. 예) A01");
    frm.gate_code.focus();
    return false;
  }
  if (!terminal) {
    alert("터미널을 선택해 주세요.");
    frm.terminal.focus();
    return false;
  }
  if (!gateType) {
    alert("게이트 타입을 선택해 주세요.");
    frm.gate_type.focus();
    return false;
  }
  if (!gateStatus) {
    alert("게이트 상태를 선택해 주세요.");
    frm.gate_status.focus();
    return false;
  }
  return true;
}

function search() {
  window.location = "gate_list.jsp";
  return false;
}

function modify() {
  return true;
}
