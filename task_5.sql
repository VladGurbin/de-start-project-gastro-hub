with menu_cte as (
	select	
		r.cafe_name as cafe_name,
		p.key as pizza_name,
		p.value::int as price
	from cafe.restaurants r
	cross join jsonb_each_text(menu::jsonb -> 'Пицца') as p(key, value)
	where "type" = 'pizzeria'
	),
	menu_with_rank as (
	select 
		cafe_name,
		pizza_name,
		price,
		row_number() over (partition by cafe_name order by price desc) as pizza_rank
	from menu_cte
	)
	
select 
	cafe_name,
	'Пицца' as type,
	pizza_name, 
	price
from menu_with_rank
where pizza_rank = 1
order by cafe_name;
