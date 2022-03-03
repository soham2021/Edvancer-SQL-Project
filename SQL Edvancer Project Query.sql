--Quest 1
select Profiles.profile_id, CONCAT(Profiles.first_name,' ',Profiles.last_name) as FullName,
 Profiles.phone AS ConatactNumber from Profiles
 inner join ['Tenancy History']
 on Profiles.profile_id=['Tenancy History'].profile_id
 where Profiles.profile_id in
 (select profile_id from
  (select top(1) datediff(dd, move_in_date,move_out_date)as a,profile_id from 
 ['Tenancy History']) as b)

 --Quest 2
 
select CONCAT(Profiles.first_name,' ',Profiles.last_name) as FullName, Profiles.email_id,
 Profiles.phone from Profiles
 inner join ['Tenancy History']
 on Profiles.profile_id= ['Tenancy History'].profile_id
 where  ['Tenancy History'].rent>9000 and Profiles.profile_id in
 (select profile_id from profiles where marital_status='Y')

 --Quest 3
  select p.profile_id, CONCAT(p.first_name,' ',p.last_name) as FullName, p.phone, p.email_id,
  p.city, t.house_id, t.move_in_date, t.move_out_date, t.rent, e.latest_employer,
  e.Occupational_category, COALESCE(r.NumberOfrefferals,0) from ['Tenancy History'] as t
   inner join Profiles as p
   on t.profile_id=p.profile_id
   inner join ['Employment Status'] as e
   on p.profile_id=e.profile_id
	left join(select COUNT(*) as NumberOfrefferals, referral_valid from Referral
  where referral_valid=1
  group by referral_valid) as r
   on p.profile_id=r.referral_valid
      where
   p.city in('Bangalore', 'Pune') and 
   (t.move_in_date between '2015-01-01' and '2016-01-31') or
  (t.move_out_date between '2015-01-01' and '2016-01-31') or
  (t.move_in_date <= '2015-01-01' and t.move_out_date>= '2016-01-31')
  order by rent desc

  --Quest 4
  
 select CONCAT(p.first_name,' ',p.last_name) as FullName, p.email_id, 
 p.phone, p.referral_code, r.TotalReferralBonus from Profiles as p
 inner join (select profile_id,sum(referrer_bonus_amount) as TotalReferralBonus from Referral
 where referral_valid=1
 group by profile_id) as r
 on p.profile_id=r.profile_id

 --Quest 5
 
select distinct(p.city), sum(t.rent) over (partition by [city] ) as CityTotalRent, 
SUM(rent) over() as TotalRent from Profiles as p
inner join ['Tenancy History'] as t
on t.profile_id=p.profile_id
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

select top(1)
 referral_valid,profile_id,valid_till,DATEADD(m,1,valid_till) as extended_valid_till from Referral
 where profile_id in (select profile_id from Referral
group by profile_id
having  COUNT(*) >2)
order by valid_till desc

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
select * from Houses where SUBSTRING(bhk_type,1,1) in(
select top(1) SUBSTRING(bhk_type,1,1) as occupancy from Houses order by bhk_type desc )

