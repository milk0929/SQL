CREATE TABLE users (
  user_id        BIGINT PRIMARY KEY,
  employer_id    BIGINT,
  created_at     TIMESTAMP,
  has_pharmacy_opt_in BOOLEAN
);

-- 会话/事件
CREATE TABLE app_events (
  user_id     BIGINT,
  event_time  TIMESTAMP,
  event_name  VARCHAR,      -- 'open_app','view_article','start_assessment','complete_assessment','book_appointment','start_chat','redeem_reward',等
  meta        JSON          -- 可含 program_id, provider_id, channel, ab_variant 等
);

-- 任务/项目（如“控糖7天”、个性化打卡）
CREATE TABLE care_tasks (
  task_id     BIGINT,
  user_id     BIGINT,
  program_id  BIGINT,
  assigned_at TIMESTAMP,
  due_at      TIMESTAMP,
  completed_at TIMESTAMP  -- NULL 表示未完成
);



-- 预约（药房、营养师、护士、远程问诊等）
CREATE TABLE appointments (
  appt_id     BIGINT,
  user_id     BIGINT,
  provider_id BIGINT,
  booked_at   TIMESTAMP,
  start_at    TIMESTAMP,
  status      VARCHAR -- 'booked','completed','no_show','cancelled'
);


-- 奖励/积分（与零售/药房积分联动）
CREATE TABLE rewards_txn (
  txn_id      BIGINT,
  user_id     BIGINT,
  txn_time    TIMESTAMP,
  points      INT,           -- 正 earn，负 redeem
  reason      VARCHAR        -- 'complete_task','streak','promo','redeem'
);

-- 雇主与福利资格（看雇主方案使用）
CREATE TABLE benefits_eligibility (
  user_id     BIGINT,
  benefit_id  BIGINT,
  eligible_from TIMESTAMP,
  eligible_to   TIMESTAMP
);

CREATE TABLE employers (
  employer_id BIGINT PRIMARY KEY,
  name        VARCHAR,
  industry    VARCHAR
);