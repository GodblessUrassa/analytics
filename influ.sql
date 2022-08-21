select *
from cousera..['social media influencers-youtub$']

select *
from cousera..['social media influencers-instag$']

select *
from cousera..tiktok3$

---number of records---
SELECT  count(*) as youtube
FROM cousera..['social media influencers-youtub$']

SELECT count(*) as instagram
FROM cousera..['social media influencers-instag$']

SELECT count(*) as tiktok
FROM cousera..tiktok3$

---duplicate values in youtube---
select username, count (*)
from cousera..['social media influencers-youtub$']
group by username
having count (*) > 1

---duplicate values in instagram---
select [instagram name], count (*)
from cousera..['social media influencers-instag$']
group by [instagram name]
having count (*) > 1

---duplicate values in tiktok---
select [Tiktoker name], count (*)
from cousera..tiktok3$
group by [Tiktoker name]
having count (*) > 1

---examples of duplicates---
select *
from cousera..['social media influencers-youtub$']
where Username = 'joshdub'

select *
from cousera..['social media influencers-instag$']
where [instagram name] = 'cznburak'

select *
from cousera..tiktok3$
where [Tiktoker name] = 'cleanpuppy'

---deleting 22 duplicate rows---
WITH youtube_cte as 
(select *, row_number() over (partition by username order by channel_name) as rownumbre 
from cousera..['social media influencers-youtub$']
)
delete from youtube_cte
where rownumbre > 1

---deleting 43 duplicates---
with instagram_cte as
(
select *, row_number() over (partition by [instagram name] order by [influencer name]) as rownumbre
from cousera..['social media influencers-instag$']
)
delete from instagram_cte
where rownumbre > 1

---deleting 43 duplicates---
with tiktok_cte as
(
select *, row_number() over (partition by [tiktoker name] order by [tiktok name]) as rownumbre
from cousera..tiktok3$
)
delete from tiktok_cte
where rownumbre > 1

---accounts with most subscribers/followers---
select top (5) username, MAX(subscribers) as youtube
from cousera..['social media influencers-youtub$']
group by Username
order by youtube desc 

select top (5) [instagram name],MAX(followers) as instagram
from cousera..['social media influencers-instag$']
group by [instagram name]
order by instagram desc

select top (5) [Tiktoker name],MAX([Subscribers count]) as tiktok
from cousera..tiktok3$
group by [Tiktoker name] 
order by tiktok desc

---top 5 categories ---
select top (5) Category, count(Category) as total_for_youtube
from cousera..['social media influencers-youtub$']
group by Category
order by total_for_youtube desc 

select top (5) Category_1, count(Category_1) as total_for_instagram
from cousera..['social media influencers-instag$']
group by Category_1
order by total_for_instagram desc

---categories with most engagements--

---instagram---
create table #insta_engagements (category nvarchar(255), likes float, comments float, engagements float)

insert into #insta_engagements
select category_1, [likes avg], [Comments avg], ([likes avg] + [Comments avg])
from cousera..['social media influencers-instag$']

select top (5) category, sum(engagements) as total_engagements_instagram
from #insta_engagements
where category is not null
group by category
order by total_engagements_instagram desc 

---youtube---
create table #youtube_engagements (category nvarchar(255), likes float, views float, engagements float)

insert into #youtube_engagements
select category, avg_likes, Avg_views, (avg_likes + Avg_views)
from cousera..['social media influencers-youtub$']

select top (5) category, sum(engagements) as total_engagements_Utube
from #youtube_engagements
where category is not null
group by category
order by total_engagements_Utube desc

---categories with less engagements---
select top (5) category, sum(engagements) as total_engagements
from #insta_engagements
where category is not null
group by category
order by total_engagements 

select top (5) category, sum(engagements) as total_engagements
from #youtube_engagements
where category is not null
group by category
order by total_engagements 

---most engaged accoounts in tiktok---
create table #tiktok_engagements ([tiktoker name] nvarchar(255), likes float, views float, engagements float)

insert into #tiktok_engagements
select [tiktoker name], [views avg], [likes avg], ([views avg] + [likes avg])
from cousera..tiktok3$

select top (10) [tiktoker name], sum(engagements) as total_engagements_tiktok
from #tiktok_engagements
where [tiktoker name] is not null
group by [tiktoker name]
order by total_engagements_tiktok desc