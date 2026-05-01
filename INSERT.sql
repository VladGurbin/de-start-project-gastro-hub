insert into cafe.restaurants (cafe_name, type, menu)
select 
	m.cafe_name,
	t.type,
	m.menu 
from raw_data.menu m
left join (
	select cafe_name, min(type)::cafe.restaurant_type as type 
	from raw_data.sales
	group by cafe_name 
) t on t.cafe_name = m.cafe_name;

insert into cafe.managers (manager_name, manager_phone)
select distinct 
	manager,
	manager_phone
from raw_data.sales;

insert into cafe.restaurant_manager_work_dates (rest_uuid, man_uuid, start_date, end_date)
select 
	r.restaurant_uuid,
	m.manager_uuid,
	MIN(s.report_date),
	MAX(s.report_date)
from raw_data.sales s
join cafe.managers m on m.manager_name = s.manager
join cafe.restaurants r on r.cafe_name = s.cafe_name
group by r.restaurant_uuid, m.manager_uuid;

insert into cafe.sales (date, rest_uuid, avg_check)
select 
	s.report_date,
	r.restaurant_uuid,
	s.avg_check
from raw_data.sales s 
join cafe.restaurants r on s.cafe_name = r.cafe_name;
	
