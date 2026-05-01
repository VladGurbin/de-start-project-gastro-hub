with prev_man as (
	select 
		rest_uuid,
		man_uuid,
		LAG(man_uuid) over (partition by rest_uuid order by start_date) as prev_man_uuid
	from cafe.restaurant_manager_work_dates
	),
	change_man as (
	select 
		rest_uuid,
		man_uuid,
		prev_man_uuid,
		case 
			when man_uuid = prev_man_uuid then 0
			when man_uuid != prev_man_uuid then 1
		end as change_manager
	from prev_man
	where prev_man_uuid is not null
	)
	
select 
	r.cafe_name as cafe_name,
	SUM(c.change_manager) as change_manager
from change_man c 
join cafe.restaurants r on c.rest_uuid = r.restaurant_uuid 
group by r.cafe_name
order by change_manager desc
limit 3;
