(function () {
  const root = document.documentElement;

  function setTheme(theme) {
    root.setAttribute("data-theme", theme);
    try { localStorage.setItem("theme", theme); } catch (_) {}
  }

  function initTheme() {
    const saved = (() => {
      try { return localStorage.getItem("theme"); } catch (_) { return null; }
    })();
    if (saved === "light" || saved === "dark") return setTheme(saved);
    setTheme("dark");
  }

  function qs(sel, el) { return (el || document).querySelector(sel); }
  function qsa(sel, el) { return Array.from((el || document).querySelectorAll(sel)); }

  function initThemeToggle() {
    const btn = qs("[data-theme-toggle]");
    if (!btn) return;
    btn.addEventListener("click", () => {
      const current = root.getAttribute("data-theme") || "dark";
      setTheme(current === "dark" ? "light" : "dark");
    });
  }

  function setActiveNav() {
    const path = (location.pathname || "").split("/").pop();
    qsa(".chip[data-page]").forEach((a) => {
      if (a.getAttribute("data-page") === path) a.setAttribute("aria-current", "page");
    });
  }

  function initTableFilter() {
    qsa("[data-table-filter]").forEach((input) => {
      const tableId = input.getAttribute("data-table-filter");
      const table = qs("#" + tableId);
      if (!table) return;
      const rows = qsa("tbody tr", table);
      input.addEventListener("input", () => {
        const q = (input.value || "").toLowerCase().trim();
        rows.forEach((tr) => {
          const text = (tr.innerText || "").toLowerCase();
          tr.style.display = text.includes(q) ? "" : "none";
        });
      });
    });
  }

  function toast(type, title, msg) {
    const t = qs("#toast");
    if (!t) return;
    t.className = "toast " + (type || "");
    qs(".toast-title", t).textContent = title || "알림";
    qs(".toast-msg", t).textContent = msg || "";
    t.classList.add("show");
    setTimeout(() => t.classList.remove("show"), 3200);
  }

  function initToastFromQuery() {
    const params = new URLSearchParams(location.search);
    const msg = params.get("msg");
    if (!msg) return;
    const type = params.get("type") || "success";
    const title = params.get("title") || (type === "error" ? "오류" : "완료");
    toast(type, title, msg);
  }

  function initAutoOccupyTime() {
    const flightSel = qs("[data-flight-select]");
    const startEl = qs("[data-occupy-start]");
    const endEl = qs("[data-occupy-end]");
    const btn = qs("[data-occupy-auto]");
    if (!flightSel || !startEl || !endEl) return;

    function parseLocalDT(dt) {
      if (!dt || dt.length < 16) return null;
      const y = +dt.slice(0, 4);
      const m = +dt.slice(5, 7) - 1;
      const d = +dt.slice(8, 10);
      const hh = +dt.slice(11, 13);
      const mm = +dt.slice(14, 16);
      const date = new Date(y, m, d, hh, mm, 0, 0);
      return Number.isNaN(date.getTime()) ? null : date;
    }

    function fmtLocalDT(date) {
      const pad = (n) => String(n).padStart(2, "0");
      return (
        date.getFullYear() +
        "-" + pad(date.getMonth() + 1) +
        "-" + pad(date.getDate()) +
        "T" + pad(date.getHours()) +
        ":" + pad(date.getMinutes())
      );
    }

    function applyAuto() {
      const opt = flightSel.options[flightSel.selectedIndex];
      const dep = opt ? opt.getAttribute("data-dep") : null;
      const depDate = parseLocalDT(dep);
      if (!depDate) return toast("warn", "시간 자동계산", "선택한 항공편의 예정 출발시간이 올바르지 않습니다.");
      const start = new Date(depDate.getTime() - 60 * 60000);
      const end = new Date(depDate.getTime() + 15 * 60000);
      startEl.value = fmtLocalDT(start);
      endEl.value = fmtLocalDT(end);
      toast("success", "시간 자동계산", "점유 시간(출발 60분 전 ~ 출발 15분 후)으로 채웠습니다.");
    }

    if (btn) btn.addEventListener("click", (e) => { e.preventDefault(); applyAuto(); });
    flightSel.addEventListener("change", () => {
      if (startEl.value || endEl.value) return;
      applyAuto();
    });
  }

  initTheme();
  initThemeToggle();
  setActiveNav();
  initTableFilter();
  initToastFromQuery();
  initAutoOccupyTime();
})();

