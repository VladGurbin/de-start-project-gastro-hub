with menu as (
	select 
		cafe_name,
		jsonb_each_text(menu::jsonb -> 'Пицца') 
	from cafe.restaurants r 
	where "type" = 'pizzeria'
	),
	count_pizza as (
	select 
		cafe_name,	
		count(*) as count_pizza,
		dense_rank() over (order by count(*) desc) as pizza_rank
	from menu
	group by cafe_name
	)
	
select 
	cafe_name,
	count_pizza
from count_pizza 
where pizza_rank = 1;
