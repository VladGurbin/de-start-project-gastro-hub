create schema cafe;

create type cafe.restaurant_type as enum ('coffee_shop', 'restaurant', 'bar', 'pizzeria');

create table cafe.restaurants ( 
	restaurant_uuid uuid PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
	cafe_name varchar not null unique,
	type cafe.restaurant_type,
	menu jsonb not null
);

create table cafe.managers (
	manager_uuid uuid PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
	manager_name varchar not null,
	manager_phone varchar not null
);

create table cafe.restaurant_manager_work_dates (
	rest_uuid uuid references cafe.restaurants(restaurant_uuid),
	man_uuid uuid references cafe.managers(manager_uuid),
	start_date date not null,
	end_date date null,
	primary key (rest_uuid, man_uuid)
);

create table cafe.sales (
	date date,
	rest_uuid uuid references cafe.restaurants(restaurant_uuid),
	avg_check numeric(6, 2),
	primary key (date, rest_uuid)
);
