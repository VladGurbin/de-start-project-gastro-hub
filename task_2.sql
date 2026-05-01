create materialized view cafe.dynamic_check as 
	with 
	check_year as (
	select 
		r.cafe_name as cafe_name,
		r.type as type,
		round(AVG(s.avg_check), 2) as avg_check,
		EXTRACT(year from s.date::date) as year_stat
	from cafe.restaurants r
	join cafe.sales s on r.restaurant_uuid = s.rest_uuid
	where EXTRACT(year from s.date::date) < 2023
	group by EXTRACT(year from s.date::date), r.cafe_name, r.type
	),
	lag_check as (
	select 
		year_stat,
		cafe_name,
		type,
		avg_check,
		LAG(avg_check) over (partition by cafe_name order by year_stat) as avg_check_prev
	from check_year
	)

	select
		l.year_stat as year,
		l.cafe_name as cafe_name,
		l.type as type,
		l.avg_check as avg_check,
		l.avg_check_prev as avg_check_prev,
		(l.avg_check - l.avg_check_prev) / l.avg_check_prev * 100 as avg_check_dynamics
	from lag_check l;
