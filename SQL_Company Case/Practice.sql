 -- Q1 新用户 14 天激活率 定义：注册后 14 天内，是否发生过 open_app 或 start_assessment 任一事件。
 -- 求最近 90 天注册用户的激活率。
 -- first pull all the new users

with recent as (
    Select user_id, 
    created_at
    from users 
where created_at >= current_date() - interval 90 day
),
activated as (
    select 
    distinct user_id 
    from recent r
    JOIN app_events a 
    on r.user_id = a.user_id
    and a.event_time >= r.created_at 
    and a.event_time <= r.created_at + interval 14 day
    and a.event_name in ('open_app', 'start_assessment')
)

Select 
sum(a.user_id is not null) / count(*) as activation_rate
from recent r 
left join 
activated a 
on a.user_id = r.user_id


--2 题 2（内容参与度）：用户每周内容浏览中位数 
-- 以自然周聚合（周一为一周开始）。MySQL 没有 date_trunc('week')，这里用“周起始日”法。

with week_events(
    Select 
    date_trunc('week',event_time) as wk_start, 
    user_id,
    sum(case when event_name = 'view_article' then 1 else 0 end) as v_cnt
    from app_events 
    group by date_trunc('week',event_time), user_id
)

Select wk_start, 
percentile_cont(0.5) within group (order by v_vnt)  over (partition by wk_start) as median_views_per_user
from week_events
order by wk_start


-- 题 3（项目完成率）：按分配月计算 30 天完成率
with base as (
    Select 
    date_format(assigned_at, '%Y-%m-01') as mon,
    count(*) as assigned,
    sum(completed_at is not null and completed_at <= assigned_at + interval 30 day) as completed_30_day
    From care_tasks
    group by mon
)
Select mon, 
completed_30_day / assigned as compleate_rate_30
from base 
order by mon 

--4 预约完成率 & No-show 率（按提供方）

Select 
provider_id, 
round(sum(case when status = 'completed' then 1 else 0 end) / nullif(count(*), 0), 2) as completed_rate,
round(sum(case when status = 'no_show' then 1 else 0 end) / nullif(count(*), 0), 2) as no_show_rate,
from appointments
group by provider_id
order by provider_id

--5 完成任务→积分→7 天内回访

With task_done as (
Select user_id, date(completed_at) as d
from 
care_tasks
where completed_at curdate() - INTERVAL 30 day
), 
earned_same_day(
    Select distinct
    t.user_id, t.d
    from task_done t
    JOIN rewards_txn r 
    on r.user_id = t.user_id
    and r.points > 0 
    and date(r.txn_time) = t.d
), 

return_7d as (
    select distinct 
    e.user_id,e.d
    from 
    earned_same_day e 
    Join app_events a 
    on a.user_id = e.user_id 
    and a.event_name = 'open_app'
    and a.event_time > timestamp(t.d)
    and a.event_time <= timestamp(t.d) + INTERVAL 7 DAY
)

Select 
sum(case when r.user_id is not null then 1 else 0 end) / count(*) as return_7d_rate
from earned_same_day e
left join return_7d r
on e.user_id = r.user_id and e.d = r.d


-- 单日净积分 > P95 的用户

with day_points as (
    Select 
    user_id, 
    date(txn_time) as d, 
    sum(points) as net_points
from 
rewards_txn 
where txn_time >= curdate() - INTERVAL 30 DAY
group by user_id, d
)

t as (
    select percentile_cont(0.95) within group (order by net_points) 
    over() as P95
from day_points
)

Select 
day_point.* 
from 
day_point
join t 
on t.p95 < day_points.net_points

-- 搜索→预约 24 小时转化率

with s as (
    Select user_id, event_time as t0 
    from app_events
    where 
    event_name = 'search_provider'
)

b as (
    Select 
    s.user_id,
    s.t0
    from s 
    join app_events a 
    on s.user_id = a.user_id 
    and a.event_name = 'book_appointment' 
    and a.event_time > s.t0 and a.event_time <= s.t0 + INTERVAL 24 hour
)

Select 
sum(case when b.user_id is not null then 1 else 0 end) / count(*) as search_to_book_w_24
from s 
left join b 
on s.user_id = b.user_id and s.t0 = b.t0 



Select user_id,max(diff) as biggest_window
from
(Select user_id,
datediff(lead(visit_date) over(partition by user_id order by visit_date),visit_date) as diff
from UserVisits) t 
group by user_id 
order by user_id