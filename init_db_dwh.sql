create table coffee_name (
	id serial primary key,
	name text
);

create table day_time (
	id serial primary key,
	type text
);

create table weekday (
	id serial primary key,
	day text
);

create table month_name (
	id serial primary key,
	name text
);

create table coffee_sale (
	id serial primary key,
	money numeric(30, 18),
	coffee_name_id int,
	foreign key (coffe_name_id) references coffee_name(id),
	day_time_id int,
	foreign key (day_time_id) references day_time(id),
	weekday_id int,
	foreign key (weekday_id) references weekday(id),
	month_name_id int,
	foreign key (month_name_id) references month_name(id),
	date text,
	time time(6)
);

INSERT INTO coffee_name (id, name) VALUES
(1, 'Americano'),
(2, 'Americano with milk'),
(3, 'Cappuccino'),
(4, 'Cocoa'),
(5, 'Cortado'),
(6, 'Espresso'),
(7, 'Hot chocolate'),
(8, 'Latte');

INSERT INTO day_time (id, type) VALUES
(1, 'morning'),
(2, 'afternoon'),
(3, 'evening');

INSERT INTO weekday (id, day) VALUES
(1, 'Monday'),
(2, 'Tuesday'),
(3, 'Wednesday'),
(4, 'Thursday'),
(5, 'Friday'),
(6, 'Saturday'),
(7, 'Sunday');

INSERT INTO month_name (id, name) VALUES
(1, 'January'),
(2, 'February'),
(3, 'March'),
(4, 'April'),
(5, 'May'),
(6, 'June'),
(7, 'July'),
(8, 'August'),
(9, 'September'),
(10, 'October'),
(11, 'November'),
(12, 'December');