-- Query 1.3: Weekly Performance Analysis
-- Finding the week with the highest conversion value

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
)
select 
    campaign_name,
    date_trunc('week', ad_date)::date as week_start_date,
    sum(coalesce(value, 0)) as r_total_value
from fg_ads_cte
group by campaign_name, date_trunc('week', ad_date)::date
order by r_total_value desc
limit 1;
