create or replace function log_project_change()
	returns trigger
	language plpgsql
	as
$$
begin
    -- Если это INSERT (OLD = NULL), вставляем новую запись
    if TG_OP = 'INSERT' then
        insert into public.transactions(project_id)
        values (new.project_id);
    
    -- Если это UPDATE, проверяем изменения и обновляем
    elsif TG_OP = 'UPDATE' then
        if old.project_id <> new.project_id then
            update public.transactions
            set project_id = new.project_id
            where id = old.id;
        end if;
    end if;
	return new;
end;
$$

create trigger trg_log_project_change
after insert or update
on stg.transactions
for each row
execute function log_project_change();

---------------------------------------
select
    project_id,
    amount::numeric as amount,
    fee::numeric as fee,
    create_date::timestamp as create_date
from public.transactions
order by project_id asc;

create table transaction_facts (
	id bigserial primary key,
	transaction_id int,
	project_id int references projects(id),
	gate_id int references gates(id),
	amount varchar(100),
	fee varchar(100),
	create_date varchar(100)
);

