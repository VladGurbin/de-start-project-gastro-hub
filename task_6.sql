begin;

with upd_price as (
	select 
		r.restaurant_uuid,
		m.key,
		c.key,
		array[m.key, c.key] as cupp_path,
		c.value,
		((c.value::int) * 1.2)::int as new_price
	from cafe.restaurants r
	cross join jsonb_each(menu::jsonb) as m(key, value)
	cross join jsonb_each(m.value::jsonb) as c(key, value)
	where c.key = 'Капучино'
	)
	
update cafe.restaurants r 
set menu = jsonb_set(
	r.menu, 
	u.cupp_path, 
	to_jsonb(u.new_price)
)
from upd_price u
where r.restaurant_uuid = u.restaurant_uuid;

commit;

--Для исключения изменения заблокированных строк я использую row-level блокировку -
-- режим FOR UPDATE, которая автоматически накладывается оператором UPDATE и обеспечивает 
-- блокировку только подлежащих изменению строк.

