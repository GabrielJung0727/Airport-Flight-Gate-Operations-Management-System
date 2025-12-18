-- Airport Flight & Gate Ops schema (Oracle)
-- Note: datetime is stored as VARCHAR2(16) with format 'YYYY-MM-DDTHH24:MI'

-- Drop (optional)
-- DROP TABLE flight_events;
-- DROP TABLE assignments;
-- DROP TABLE flights;
-- DROP TABLE gates;

sqlplus
/as sysdba

CREATE TABLE gates (
  gate_id      NUMBER PRIMARY KEY,
  gate_code    VARCHAR2(10) NOT NULL,
  terminal     VARCHAR2(10) NOT NULL,
  gate_type    VARCHAR2(10) NOT NULL,  -- DOM / INT / MIX
  gate_status  VARCHAR2(10) NOT NULL   -- OPEN / MAINT / CLOSED
);

CREATE TABLE flights (
  flight_id    NUMBER PRIMARY KEY,
  flight_no    VARCHAR2(10) NOT NULL,
  airline      VARCHAR2(30) NOT NULL,
  origin       VARCHAR2(30) NOT NULL,
  destination  VARCHAR2(30) NOT NULL,
  route_type   VARCHAR2(10) NOT NULL,  -- DOM / INT
  sched_dep    VARCHAR2(16) NOT NULL,  -- 'YYYY-MM-DDTHH24:MI'
  sched_arr    VARCHAR2(16),
  status       VARCHAR2(15) NOT NULL   -- SCHEDULED / BOARDING / DEPARTED / ARRIVED / DELAYED / CANCELLED
);

CREATE TABLE assignments (
  assign_id    NUMBER PRIMARY KEY,
  flight_id    NUMBER NOT NULL REFERENCES flights(flight_id),
  gate_id      NUMBER NOT NULL REFERENCES gates(gate_id),
  occupy_start VARCHAR2(16) NOT NULL,
  occupy_end   VARCHAR2(16) NOT NULL,
  assign_status VARCHAR2(10) NOT NULL, -- ACTIVE / CANCELLED
  note         VARCHAR2(200)
);

CREATE TABLE flight_events (
  event_id    NUMBER PRIMARY KEY,
  flight_id   NUMBER NOT NULL REFERENCES flights(flight_id),
  event_type  VARCHAR2(20) NOT NULL,  -- CHECKIN_OPEN / BOARDING / DEPARTED / ARRIVED / DELAYED / CANCELLED / GATE_CHANGED
  event_time  VARCHAR2(16) NOT NULL,
  delay_min   NUMBER,
  reason      VARCHAR2(200)
);

-- Helpful indexes
CREATE INDEX idx_assign_gate_time ON assignments (gate_id, occupy_start, occupy_end, assign_status);
CREATE INDEX idx_event_flight_time ON flight_events (flight_id, event_time);

commit;
exit;