# 공항 항공편/게이트 운영 관리 시스템  
# Airport Flight & Gate Operations

> ✈️ **한국어:** JSP/Oracle 기반 항공 운영 학습 프로젝트입니다.  
> ✨ **English:** A JSP + Oracle learning project for airport operations management.

---

## 목차 · Table of Contents
1. [프로젝트 개요 · Overview](#프로젝트-개요--overview)
2. [주요 기능 · Key Features](#주요-기능--key-features)
3. [화면 구성 · Screens](#화면-구성--screens)
4. [데이터베이스 설계 · Database](#데이터베이스-설계--database)
5. [설치 및 실행 · Setup](#설치-및-실행--setup)
6. [게이트 코드 정책 · Gate Code Policy](#게이트-코드-정책--gate-code-policy)
7. [기여 및 라이선스 · Contribution](#기여-및-라이선스--contribution)

---

## 프로젝트 개요 · Overview
- **한국어:** 기존 서점 CRUD 템플릿을 항공 도메인으로 재구성하여 항공편/게이트/배정/운항 이벤트/리포트를 단일 웹에서 관리합니다.  
- **English:** Refactors a bookstore CRUD sample into an airport-ops demo that manages flights, gates, assignments, flight events, and dashboards in one UI.

**Tech Stack**
| 구분 / Area | 기술 스택 (한국어) | Stack (English) |
| --- | --- | --- |
| Frontend | JSP, HTML5, CSS, JavaScript | JSP, HTML5, CSS, JavaScript |
| UX Layer | `app.css`, `app.js` (다크/라이트 테마, 토스트, 필터) | `app.css`, `app.js` (dark/light theme, toast, filters) |
| Backend | Oracle XE + JDBC (`airport.Condb`), JSP 로직 | Oracle XE + JDBC (`airport.Condb`), JSP logic |

---

## 주요 기능 · Key Features
1. **게이트 관리 / Gate Management**  
   - 한국어: 게이트 CRUD, 터미널/타입/상태 관리, OPEN 상태에서만 배정 가능  
   - English: Gate CRUD, terminal/type/state controls, assignments allowed only when status is OPEN
2. **항공편 관리 / Flight Management**  
   - 한국어: 편명·항공사·출발/도착지·예정 시간·상태를 등록/조회/수정  
   - English: Maintain flight number, carrier, route, schedule, and current status
3. **게이트 배정 / Gate Assignment**  
   - 한국어: 점유 시간 자동 계산(출발 -60/+15분)과 중복 배정/타입 규칙 검증  
   - English: Auto occupancy window (-60/+15 min) plus overlap & gate-type validation
4. **운항 이벤트 / Flight Events**  
   - 한국어: DELAYED/BOARDING/ARRIVED 등 이벤트 로그와 항공편 상태 동기화  
   - English: Log events (DELAYED, BOARDING, ARRIVED, etc.) and sync flight status
5. **리포트 / Reports**  
   - 한국어: 일일 운항표, 지연 통계, 게이트 사용률 대시보드  
   - English: Dashboards for daily schedule, delay statistics, and gate utilization

---

## 화면 구성 · Screens
| 메뉴 · Menu | JSP | 설명 (한국어) / Description (English) |
| --- | --- | --- |
| 대시보드 / Dashboard | `index.jsp` | 소개/빠른 이동 / Intro & quick links |
| 게이트 등록/조회/수정 | `gate_add.jsp`, `gate_list.jsp`, `gate_edit.jsp` | 게이트 CRUD / Gate CRUD |
| 항공편 등록/조회/수정 | `flight_add.jsp`, `flight_list.jsp`, `flight_edit.jsp` | 항공편 CRUD / Flight CRUD |
| 배정 등록/조회/수정 | `assign_add.jsp`, `assign_list.jsp`, `assign_edit.jsp` | 배정 CRUD + 자동시간 / Assignment CRUD + auto time |
| 이벤트 등록/조회 | `event_add.jsp`, `event_list.jsp` | 운항 이벤트 로그 / Flight event log |
| 리포트 | `reports.jsp` | 일일/지연/게이트 리포트 / Daily/Delay/Gate reports |

---

## 데이터베이스 설계 · Database
- **한국어:** [`db/airport_schema.sql`](db/airport_schema.sql)에 `GATES`, `FLIGHTS`, `ASSIGNMENTS`, `FLIGHT_EVENTS` 테이블과 인덱스가 정의되어 있습니다.  
- **English:** [`db/airport_schema.sql`](db/airport_schema.sql) defines `GATES`, `FLIGHTS`, `ASSIGNMENTS`, and `FLIGHT_EVENTS` tables plus indexes.

**핵심 제약 / Key Constraints**
- 한국어: 게이트 상태 `OPEN`일 때만 배정 가능  
  English: Only `OPEN` gates accept assignments
- 한국어: 국제/국내 노선에 맞는 게이트 타입(INT/DOM/MIX) 사용  
  English: Route type must match gate type (INT/DOM/MIX)
- 한국어: 점유 시간 겹치면 중복 배정 금지  
  English: Overlapping occupancy windows are rejected

---

## 설치 및 실행 · Setup
```bash
# 한국어 1) Oracle XE에 스키마 생성
# English 1) Create schema on Oracle XE
sqlplus system/***** @db/airport_schema.sql

# 한국어 2) (선택) docs/gate_codes.md 참고해 GATES 초기 데이터 입력
# English 2) (Optional) seed GATES data from docs/gate_codes.md

# 한국어 3) Eclipse/Tomcat 배포 후 src/main/java/airport/Condb.java DB 정보 수정
# English 3) Deploy via Eclipse/Tomcat and edit DB creds in Condb.java

# 한국어 4) http://localhost:8080/final/index.jsp 접속
# English 4) Browse http://localhost:8080/final/index.jsp
```

---

## 게이트 코드 정책 · Gate Code Policy
- **한국어:** 표준 명명 규칙과 기종 호환 목록은 [`docs/gate_codes.md`](docs/gate_codes.md)에 정리되어 있으며, Concourse Gate 101-132 → CG101-CG132, Cargo 601-647 → C601-C647 등 규칙을 따릅니다.  
- **English:** Standard naming/compatibility lives in [`docs/gate_codes.md`](docs/gate_codes.md), e.g., Concourse Gate 101-132 → CG101-CG132, Cargo 601-647 → C601-C647.
- 한국어: UI에서 새 게이트 등록 시 규칙을 안내하여 일관성을 보장합니다.  
  English: UI hints enforce the rule when registering new gates.

---

## 기여 및 라이선스 · Contribution
- **한국어:** 학습/실습용으로 자유롭게 포크하고 Issue·PR로 개선 사항을 공유해 주세요.  
- **English:** Feel free to fork for learning; share improvements via Issues/PRs. Korean & English discussions are both welcome.
