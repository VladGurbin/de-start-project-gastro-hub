create view cafe.bonus as 
	with 
	cafe_avg_check as (
		select 
			r.cafe_name as cafe_name,
			r.type as type,
			round(AVG(s.avg_check), 2) as avg_check
		from cafe.restaurants r 
		join cafe.sales s on r.restaurant_uuid = s.rest_uuid
		group by r.cafe_name, r.type
	),
	cafe_avg_rank as (
		select 
			*,
			rank() over (partition by type order by avg_check desc) as avg_rank
		from cafe_avg_check
	)
	
	select * from cafe_avg_rank where avg_rank <= 3;
	
	
