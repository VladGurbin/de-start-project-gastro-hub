begin;

lock table cafe.managers in share mode;

alter table cafe.managers add column numbers text[];

with upd_phone as (
	select 
		m.manager_uuid,
		(99 + (row_number() over (order by m.manager_name))) as man_number,
		concat('8-800-2500-', '', (99 + row_number() over (order by m.manager_name))) as new_phone,
		ARRAY[concat('8-800-2500-', '', (99 + row_number() over (order by m.manager_name))), m.manager_phone] as prev_new_num
	from cafe.managers m
)

update cafe.managers m
set numbers = u.prev_new_num
from upd_phone u
where m.manager_uuid = u.manager_uuid;

alter table cafe.managers 
drop column manager_phone;

commit;

-- Таблица заблокирована в режиме SHARE, это позволяет выполнять операции чтения,
-- но запрещает любые изменения со стороны других транзакций.

