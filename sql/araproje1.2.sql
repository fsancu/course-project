-- Query 1.2: ROMI Analysis
-- Calculating Return on Marketing Investment (ROMI) - the revenue generated per dollar spent

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
    ad_date,
    sum(spend) as t_spend,
    sum(value) as t_value,
    1.00 * coalesce(sum(value), 0) / sum(spend) as romi
from fg_ads_cte
where spend > 0 or value > 0
group by ad_date
order by romi desc
limit 5;
