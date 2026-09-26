-- Query 1.4: Campaign Growth Analysis
-- Identifying the campaign with the largest month-over-month reach growth

with fg_ads_cte as 
(
    select 
        ad_date,
        'facebook_ads' as media_source,
        campaign_name,
        adset_name,
        spend,
        impressions,
        reach,
        clicks,
        leads,
        value
    from fb_table
    union all
    select 
        ad_date,
        'google_ads' as media_source,
        campaign_name,
        adset_name,
        spend,
        impressions,
        reach,
        clicks,
        leads,
        value
    from google_ads_basic_daily
),
monthly_reach as 
(
    select 
        campaign_name,
        date_trunc('month', ad_date)::date as ad_month,
        sum(coalesce(reach, 0)) as total_reach
    from fg_ads_cte
    group by campaign_name, date_trunc('month', ad_date)::date
),
reach_growth as
(
    select
        campaign_name,
        ad_month,
        total_reach,
        lag(total_reach) over (partition by campaign_name order by ad_month) as month_reach,
        total_reach - lag(total_reach) over (partition by campaign_name order by ad_month) as monthly_diff
    from monthly_reach
)
select
    campaign_name,
    ad_month,
    month_reach,
    total_reach,
    monthly_diff
from reach_growth
where monthly_diff is not null
order by monthly_diff desc
limit 1;
