-- Murder was committed on Jan 15 2018 in SQL City
select *
from crime_scene_report
where city='SQL City' AND date='20180115' AND type='murder'

-- The above query returns the description: 
-- Security footage shows that there were 2 witnesses. 
-- The first witness lives at the last house on "Northwestern Dr". 
-- The second witness, named Annabel, lives somewhere on "Franklin Ave".

select *
from person
where address_street_name='Northwestern Dr'
order by address_number desc

select *
from person
where address_street_name='Franklin Ave' and name like 'Annabel%'
-- The above queries identifies the first witness as Morty Schapiro and Annabel Miller

-- We can use these names to look at their witness interviews
select *
from interview as i 
join person as p on p.id=i.person_id
where name='Morty Schapiro' OR name='Annabel Miller'

-- Morty Schapiro said: "I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
-- The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
-- Annabel Miller said: "I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
  
select *
from get_fit_now_member as m
join get_fit_now_check_in as c on m.id=c.membership_id
where id like '48Z%' and membership_status='gold' OR name='Annabel Miller'
-- The above query returns two possible indviduals in Jeremy Bowers and Joe Germuska

-- Looking at the plate number we can see that Jeremy Bowers has a car with matching plates
select *
from drivers_license as d
join person as p on d.id=p.license_id
where plate_number like '%H42W%'

-- Jeremy Bowers is the murderer but looking at his interview we can see he was hired by:
-- "a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
-- She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017."
select *
from interview as i
join person as p on i.person_id=p.id
where name='Jeremy Bowers'

-- Using the information from the interview the following query reveals who hired him
select *
from drivers_license as d
join person as p on d.id=p.license_id
join facebook_event_checkin as fb on p.id=fb.person_id
where hair_color='red' and gender='female' and car_model='Model S'

-- The above query shows that a Miranda Priestly fitting the description visited the SQL Symphony Concert 3 times in December 2017.
