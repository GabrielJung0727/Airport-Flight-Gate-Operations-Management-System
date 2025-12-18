# 공항 항공편/게이트 운영 관리 프로그램 기획서

## 1. 프로젝트 개요

### 1.1 프로젝트명
- 공항 항공편/게이트 운영 관리 시스템 (Airport Flight & Gate Operations)

### 1.2 목적
- 공항의 **항공편(Flight)** 정보와 **게이트(Gate)** 자원을 관리하고, 항공편별 **게이트 배정(Assignment)** 및 **운항 상태(Event/Status)** 를 기록하여
  - 게이트 중복 배정 방지
  - 지연/결항 등 변동 이력 관리
  - 일자별 운항/게이트 사용 리포트 제공
  을 목표로 한다.

### 1.3 대상 사용자(역할)
- 운영관리자(Admin): 전체 CRUD, 배정/변경, 리포트 확인
- 운항담당(Ops): 항공편 등록/상태 업데이트, 배정 요청
- 게이트담당(Gate): 게이트 상태 변경(사용가능/점검), 배정 확인
- 조회자(Viewer, 선택): 조회/리포트만 가능

### 1.4 구현 형태(현재 프로젝트 스타일 가정)
- JSP 기반 웹 애플리케이션 + Oracle DB(JDBC)
- 상단 고정 `header.jsp`, 하단 `footer.jsp` 포함
- 메뉴 기반 CRUD 화면(등록/목록조회/수정) + 리포트 화면

> 본 기획서는 “서점 관리 프로그램(회원/도서/판매/매출)”의 구조를 “항공편/게이트/배정/리포트”로 치환한 형태로 설계한다.

---

## 2. 범위(Scope)

### 2.1 포함(필수)
- 게이트 정보 관리(CRUD)
- 항공편 정보 관리(CRUD)
- 게이트 배정 관리(등록/변경/취소) + **중복 배정 방지 로직**
- 운항 상태 이벤트 관리(지연/탑승시작/출발/도착/결항 등)
- 조회 화면(목록, 검색/필터)
- 리포트(일일 운항표, 지연 현황, 게이트 사용률)

### 2.2 제외(선택/확장)
- 승객 예약/티켓/좌석
- 수하물 처리
- 실시간 외부 연동(항공 데이터 API)
- 권한/로그인 고도화(기본 로그인만 선택)

---

## 3. 핵심 개념 매핑(서점 → 공항)
- 회원(Member) → 항공사/담당자(선택) 또는 “운영 사용자”
- 도서(Book) → 항공편(Flight)
- 판매(Sales) → 게이트 배정/운항 처리(Assignment/Event)
- 매출집계(Report) → 운항 리포트/지연 통계/게이트 사용률

---

## 4. 기능 요구사항

### 4.1 게이트 관리
- 게이트 등록/조회/수정
- 속성: 터미널, 게이트 타입(국내/국제/혼합), 사용 가능 여부(정상/점검/폐쇄)
- 게이트 목록에서 “현재/예정 배정 항공편” 간단 표시(선택)

### 4.2 항공편 관리
- 항공편 등록/조회/수정
- 속성: 편명, 항공사, 출발/도착지, 예정 출발/도착 시간, 국제/국내 구분, 기종(선택), 현재 상태
- 항공편 목록에서 “배정 게이트/지연 여부” 표시

### 4.3 게이트 배정 관리(핵심)
- 배정 등록(항공편 1건 ↔ 게이트 1개, 시간 구간 포함)
- 배정 변경(게이트 변경/시간 변경) 및 변경 이력(선택)
- 배정 취소
- **중복 배정 방지**
  - 같은 게이트에서 시간이 겹치는 배정이 있으면 등록/변경 불가
  - 국제/국내 구분에 따른 게이트 타입 제약(예: 국제편은 국내 전용 게이트 배정 불가)
- 배정 시 권장 시간 구간(예시)
  - 점유 시작: `예정 출발 60분 전`
  - 점유 종료: `예정 출발 15분 후`
  - (도착편까지 포함하는 모델로 확장 가능)

### 4.4 운항 상태 이벤트 관리
- 항공편별 이벤트 추가/조회
- 이벤트 유형(예시)
  - CHECKIN_OPEN, BOARDING, DEPARTED, ARRIVED, DELAYED, CANCELLED, GATE_CHANGED
- 지연 시 지연분/사유 입력
- 최신 이벤트를 항공편 “현재 상태”로 반영(선택: 목록에서 빠르게 확인)

### 4.5 리포트/조회
- 일일 운항표(일자 + 시간순): 편명/출발지/도착지/예정시간/게이트/상태
- 지연 항공편 TOP(일자/기간): 지연분 합계, 지연 횟수
- 게이트 사용률(일자/기간): 게이트별 배정 건수/점유시간(단순 합산)

---

## 5. 화면(메뉴) 구성안(JSP 파일명 예시)

### 5.1 공통
- `index.jsp`: 프로그램 소개 + 개발 순서 안내
- `header.jsp`: 상단 타이틀/메뉴
- `footer.jsp`: 하단 정보

### 5.2 게이트
- `g_join.jsp`: 게이트 등록
- `g_list.jsp`: 게이트 목록조회/수정 링크
- `g_modify.jsp`: 게이트 수정
- `g_action.jsp`: 등록/수정 처리(INSERT/UPDATE)

### 5.3 항공편
- `f_join.jsp`: 항공편 등록
- `f_list.jsp`: 항공편 목록조회/수정 링크
- `f_modify.jsp`: 항공편 수정
- `f_action.jsp`: 등록/수정 처리

### 5.4 배정
- `a_join.jsp`: 게이트 배정 등록(중복 검사 포함)
- `a_list.jsp`: 배정 목록조회/수정 링크
- `a_modify.jsp`: 배정 변경/취소
- `a_action.jsp`: 배정 처리(INSERT/UPDATE/취소)

### 5.5 이벤트/리포트
- `e_join.jsp`: 이벤트 등록(지연/결항/출발/도착 등)
- `e_list.jsp`: 항공편별 이벤트 조회
- `report_daily.jsp`: 일일 운항표
- `report_gate.jsp`: 게이트 사용률
- `report_delay.jsp`: 지연 통계

---

## 6. 데이터베이스 설계(Oracle 기준)

> 테이블/컬럼명은 예시이며, 현재 프로젝트의 네이밍 규칙에 맞춰 조정 가능.

### 6.1 테이블 목록
- `AIRLINE` (선택): 항공사 마스터
- `GATE`: 게이트 마스터
- `FLIGHT`: 항공편 마스터
- `GATE_ASSIGNMENT`: 게이트 배정(시간 구간 포함)
- `FLIGHT_EVENT`: 운항 이벤트 로그

### 6.2 컬럼 제안(요약)

#### AIRLINE (선택)
- `airline_code`(PK): 예) KE, OZ
- `airline_name`

#### GATE
- `gate_id`(PK): 예) A01, B12
- `terminal`: 예) T1, T2
- `gate_type`: DOM / INT / MIX
- `gate_status`: OPEN / MAINT / CLOSED

#### FLIGHT
- `flight_id`(PK): 시퀀스 또는 UUID(과제형이면 NUMBER 시퀀스 권장)
- `flight_no`: 예) KE123
- `airline_code`(FK, 선택)
- `origin`
- `destination`
- `route_type`: DOM / INT
- `sched_dep_time`(DATE 또는 TIMESTAMP)
- `sched_arr_time`(DATE 또는 TIMESTAMP, 선택)
- `flight_status`: SCHEDULED / BOARDING / DEPARTED / ARRIVED / DELAYED / CANCELLED

#### GATE_ASSIGNMENT
- `assign_id`(PK)
- `flight_id`(FK)
- `gate_id`(FK)
- `occupy_start_time`(DATE/TIMESTAMP)
- `occupy_end_time`(DATE/TIMESTAMP)
- `assign_status`: ACTIVE / CANCELLED
- `note`(선택)

#### FLIGHT_EVENT
- `event_id`(PK)
- `flight_id`(FK)
- `event_type`
- `event_time`(DATE/TIMESTAMP)
- `delay_min`(NUMBER, 선택: DELAYED일 때)
- `reason`(VARCHAR2, 선택)

### 6.3 핵심 제약/검증 로직(애플리케이션 레벨)
- [중복 배정 검사] 배정 등록/변경 시 아래 조건을 만족하면 실패 처리
  - 같은 `gate_id`
  - 상태가 `ACTIVE`
  - 시간구간이 겹침:
    - `new_start < existing_end` AND `new_end > existing_start`
- [게이트 타입 제약]
  - `FLIGHT.route_type = INT` 인 경우 `GATE.gate_type = DOM` 불가
  - `FLIGHT.route_type = DOM` 인 경우 `GATE.gate_type = INT` 불가 (정책에 따라 허용 가능)
- [시간 유효성]
  - `occupy_start_time < occupy_end_time`
  - (선택) 점유 시간은 예정 출발 기준 자동 산출 + 수동 수정 가능

---

## 7. 주요 처리 흐름(Use Case)

### UC-01 항공편 등록
1) 운영자가 `f_join.jsp`에서 항공편 정보 입력  
2) `FLIGHT`에 INSERT  
3) 목록에서 확인(`f_list.jsp`)

### UC-02 게이트 등록
1) `g_join.jsp`에서 게이트 입력  
2) `GATE`에 INSERT  
3) 목록 확인(`g_list.jsp`)

### UC-03 게이트 배정(충돌 검사)
1) `a_join.jsp`에서 항공편 선택 + 게이트 선택 + 점유 시간 입력/자동계산  
2) 중복 배정 검사 실행  
3) 통과 시 `GATE_ASSIGNMENT`에 INSERT  
4) `a_list.jsp`에서 확인

### UC-04 지연 처리
1) `e_join.jsp`에서 이벤트 유형 `DELAYED`, 지연분/사유 입력  
2) `FLIGHT_EVENT` INSERT  
3) (선택) `FLIGHT.flight_status = DELAYED` 업데이트  
4) 리포트에서 지연 현황 확인(`report_delay.jsp`)

---

## 8. 개발 순서(권장)
1) 게이트 테이블 생성 + 등록/조회/수정 화면
2) 항공편 테이블 생성 + 등록/조회/수정 화면
3) 게이트 배정 테이블 생성 + 배정 등록/조회/수정 화면
4) 배정 중복 검사 로직 구현(핵심)
5) 운항 이벤트 테이블 생성 + 이벤트 등록/조회
6) 리포트(일일 운항표/지연/게이트 사용률)

---

## 9. 리포트 SQL 예시(설계 참고)

### 9.1 일일 운항표(특정 날짜)
- 기준: `sched_dep_time` 날짜로 조회

### 9.2 지연 통계(기간)
- `event_type='DELAYED'` 기준으로 `delay_min` 합계/횟수 집계

### 9.3 게이트 사용률(기간)
- `ACTIVE` 배정 대상으로 `occupy_end_time - occupy_start_time` 합산(단순 계산)

> 실제 구현 시 DATE/TIMESTAMP 타입과 오라클의 날짜 연산(일 단위)을 고려해 분(min) 단위로 변환하는 로직이 필요할 수 있다.

---

## 10. 입력 항목/검증(요약)
- 필수 입력: 게이트ID, 게이트타입, 항공편번호, 출발/도착지, 예정시간, 배정 게이트/점유시간
- 형식 검증: 시간 포맷, 지연분 숫자, 문자열 길이 제한
- 논리 검증: 시간 구간 역전 금지, 중복 배정 금지, 타입 제약

---

## 11. 산출물(Deliverables)
- DB 스키마(SQL): 테이블 생성문 + 샘플 데이터(선택)
- JSP 화면: 등록/목록/수정 + 배정/이벤트 + 리포트
- 공통 UI: `header.jsp`, `footer.jsp`
- (선택) 간단 매뉴얼: “사용 흐름” 1페이지

---

## 12. 확장 아이디어(가산점용)
- 자동 게이트 추천(가장 빨리 비는 게이트 / 타입 적합 + 충돌 없는 게이트 우선)
- 배정 변경 이력 테이블(`ASSIGNMENT_HISTORY`) 추가
- 게이트 상태가 MAINT/CLOSED면 배정 불가
- 지연 발생 시 “재배정 시뮬레이션”(현재 배정과 겹치는 후속 항공편 탐지)

---

## 13. 게이트 코드 정책
- 공항에서 사용하는 게이트 표준 코드는 `docs/gate_codes.md`에 정의되어 있으며, 다음 범위를 준수해야 한다.
  - Concourse Gate 101-132 → CG101-CG132
  - Maintenance 701-711 → M701-M711
  - Stand 227-357 → S227-S357
  - Terminal 2 Gate 231-268 → T2G231-T2G268
  - Terminal Gate 01-50 → TG01-TG50
  - Cargo 601-647 → C601-C647
- 각 코드는 `항공사용(Airline)` 또는 `화물(Cargo)` 구분과 지원 기종 목록을 함께 관리한다.
- UI에서 게이트 등록 시 위 규칙을 안내하고, 목록/리포트에서는 코드와 원래 명칭을 함께 표시해 운영자가 쉽게 파악할 수 있도록 구성한다.
