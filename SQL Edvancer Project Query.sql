--Quest 1
select profile_id, first_name + ' ' + last_name as 'Full_Name', phone from Profiles where profile_id = (select profile_id from ['Tenancy History']
where DATEDIFF(month, [move_in_date], [move_out_date]) = (select max(DATEDIFF(month, [move_in_date], [move_out_date])) from ['Tenancy History']))

 --Quest 2
 
select CONCAT(Profiles.first_name,' ',Profiles.last_name) as FullName, Profiles.email_id,
 Profiles.phone from Profiles
 inner join ['Tenancy History']
 on Profiles.profile_id= ['Tenancy History'].profile_id
 where  ['Tenancy History'].rent>9000 and Profiles.profile_id in
 (select profile_id from profiles where marital_status='Y')

-- Quest 3
 Select P.profile_id, P.Full_Name, P.phone, P.email_id, P.city, T.house_id, T.move_in_date, T.move_out_date,

T.rent,R.ReferralCount, E.latest_employer, E.occupational_category

from

(select profile_id, first_name + ' ' + last_name AS 'Full_Name', phone, email_id,city from Profiles where city in ('Bangalore', 'Pune'))P

inner join

(select profile_id, house_id, move_in_date, move_out_date, rent from ['Tenancy History']

where move_in_date>='20150101' and move_in_date<='20160101' )T

inner join

(select profile_id, latest_employer, occupational_category from ['Employment Status'])E

inner join

(select profile_id, count(profile_id) AS ReferralCount from Referral group by profile_id)R

ON R.profile_id = E.profile_id

ON T.profile_id = E.profile_id

ON P.profile_id = T.profile_id

ORDER BY rent DESC
 

  --Quest 4
  
 select CONCAT(p.first_name,' ',p.last_name) as FullName, p.email_id, 
 p.phone, p.referral_code, r.TotalReferralBonus from Profiles as p
 inner join (select profile_id,sum(referrer_bonus_amount) as TotalReferralBonus from Referral
 where referral_valid=1
 group by profile_id) as r
 on p.profile_id=r.profile_id

 --Quest 5
 
SELECT

isnull

(Profiles.city,'Grand Total') as CITY,

SUM (['Tenancy History'].rent) TotalRentByCity

FROM

Profiles

INNER JOIN ['Tenancy History'] ON Profiles.profile_id = ['Tenancy History'].profile_id

GROUP BY

Profiles.city

WITH ROLLUP
--Quest6

create view 
vw_tenant
as
select profile_id, rent, move_in_date, h.house_type, h.beds_vacant, a.description, a.city
 from ['Tenancy History'] as t
inner join Houses as h
on t.house_id=h.house_id
inner join Addresses as a
on a.house_id=h.house_id
 where move_in_date>='2015-04-30' 
and move_out_date is null and
h.beds_vacant>0

select * from vw_tenant

--Quest 7

SELECT C.profile_id, valid_till, DATEADD (MONTH, 1, valid_till) as NewValidDate

from Referral

inner join

(SELECT profile_id, count(profile_id) AS COUNT

from Referral

group by profile_id

having count(profile_id)>2 )C

on C.profile_id= Referral.profile_id

--Quest 8

select p.profile_id, CONCAT(p.first_name,' ',p.last_name) as FullName,
 p.phone, iif(t.rent>10000,'Grade A',iif(t.rent<7500,'Grade C', 'Grade B')) as 'Customer Segment' from Profiles as p
 inner join ['Tenancy History'] as t
 on t.profile_id=p.profile_id


 --Quest 9
 
select CONCAT(p.first_name,' ',p.last_name) as FullName,
 p.phone, p.[city], h.house_type, h.bhk_type, h.bed_count, h.furnishing_type, h.Beds_vacant
  from Profiles as p
 inner join ['Tenancy History'] as t
 on t.profile_id=p.profile_id
 inner join Houses as h
 on t.house_id=h.house_id
 where p.profile_id not in (select profile_id from Referral)


--Quest 10
SELECT house_id, house_type, bhk_type, bed_count, beds_vacant, furnishing_type FROM Houses

WHERE (bed_count - beds_vacant) = (select ( MAX(bed_count - beds_vacant)) from Houses)

