-- Query 1.1: Daily Spend Metrics
-- Analyzing average, maximum, and minimum daily spend by media source

select *
from facebook_ads_basic_daily;
 
select* 
from google_ads_basic_daily;

select * 
from facebook_adset;

select *
from facebook_campaign;

-- Create enriched Facebook Ads view with campaign and adset names
create view fb_table as
select 
    a.adset_name,
    c.campaign_name,
    d.ad_date, 
    spend, 
    impressions, 
    reach, 
    clicks, 
    leads, 
    value, 
    url_parameters
from facebook_ads_basic_daily d
left join facebook_adset a on d.adset_id = a.adset_id 
left join facebook_campaign c on d.campaign_id = c.campaign_id;

-- Combine Facebook and Google Ads data
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
    media_source,
    round(avg(spend), 2) as avg_spend,
    max(spend) as max_spend,
    min(spend) as min_spend
from fg_ads_cte
group by media_source, ad_date;
