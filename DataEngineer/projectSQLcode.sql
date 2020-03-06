use yelpdata;

#rename table for consistency
rename table checkin to Checkin;
rename table city2 to City;

# sort the cities by number of restaurants in the database, get the top20 
select 
	c.city_name, 
    c.state,
	count(r.business_id) as number_of_restaurants
from 
	City c 
		inner join 
	Address a on a.city_id=c.city_id
		inner join 
	Restaurant r on r.business_id=a.business_id
group by 
	c.city_id
order by 
	number_of_restaurants desc
limit 20;
	

# find the top 10 most popular type of restaurants in the entire database 
select 
	c.category,
	count(r.business_id) as number_of_restaurants
from 
	Category c
		inner join 
	Restaurant r on r.category_id=c.category_id
group by 
	c.category
order by 
	number_of_restaurants desc
limit 10;

# find the most popular type of restaurants in a certain city, e.g. Las Vegas
select 
	c.category,
	count(r.business_id) as number_of_restaurants
from 
	Category c
		inner join 
	Restaurant r on r.category_id=c.category_id
		inner join 
	Address a on r.business_id=a.business_id
		inner join 
	City ct on a.city_id=ct.city_id
where 
	ct.city_name='Las Vegas'
group by 
	c.category
order by 
	number_of_restaurants desc;

# find the 10 cities with the least number of a certain type of restaurants, i.e. Chinese. 
# Recommendation: expanding to those cities  
select 
	ct.city_name,
    ct.state,
	count(r.business_id) as number_of_restaurants
from 
	Category c
		inner join 
	Restaurant r on r.category_id=c.category_id
		inner join 
	Address a on r.business_id=a.business_id
		inner join 
	City ct on a.city_id=ct.city_id
where 
	c.category='Chinese' and ct.population is not null
group by 
	ct.city_id
order by 
	number_of_restaurants asc 
limit 10;

# same query look within the top 20 cities (cities with population info not null) 
# filter for the ones with less than 10 Chinese restaurant 
select 
	ct.city_name,
    ct.state,
	count(r.business_id) as number_of_restaurants
from 
	Category c
		inner join 
	Restaurant r on r.category_id=c.category_id
		inner join 
	Address a on r.business_id=a.business_id
		inner join 
	City ct on a.city_id=ct.city_id
where 
	c.category='Chinese' and ct.population is not null 
group by 
	ct.city_id
having 
	number_of_restaurants<10
order by 
	number_of_restaurants asc ;


# find the top 10 restaurants in a certain city with the most reviews, minimum 4 stars raiting, e.g. Las Vegas
select 
    r.name,
	r.reviewcount,
    r.stars
from 
	Restaurant r 
		inner join 
	Address a on r.business_id=a.business_id
		inner join 
	City c on c.city_id=a.city_id
where 
	stars>=4 and c.city_name='Las Vegas'
order by 
	reviewcount desc
limit 10;

# find the top 100 users with the most number of fans. They are the yelp influencers 
select * from User 
order by fans desc
limit 100;


#sort the restaurant by their checkin numbers
select 
	Restaurant. name,
	sum(Checkin.checkins) as checkinNum
from Restaurant 
left join Checkin on Restaurant.business_id = Checkin.business_id
group by Restaurant.name
order by checkinNum Desc;

#get the checkin numbers of top 5 restaurant
Select * from Restaurant
left join Checkin on Restaurant.business_id = Checkin.business_id
where name in ('Starbucks','Kung Fu Tea','McDonald\'s', 'Pizza Hut','Dunkin\' Donuts');

#get rid of checkins on Saturday 1am
SELECT * FROM yelpdata.Checkin;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM `yelpdata`.`Checkin` WHERE (`weekday` = 'Sat' and `hour` = 1);
SET SQL_SAFE_UPDATES = 1;

