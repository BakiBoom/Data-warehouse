create or replace function sync_from_stg(
    p_id int,
    p_project_id int
)
returns void
language plpgsql
as $$
begin

    -- 1. обновляем stg.transactions
    if exists (select 1 from stg.transactions where id = p_id) then
        update stg.transactions
        set project_id = p_project_id
        where id = p_id;
    end if;

    -- 2. обновляем public.transactions
    if exists (select 1 from public.transactions where id = p_id) then
        update public.transactions
        set project_id = p_project_id
        where id = p_id;
    end if;

end;
$$;


create or replace function load_transaction_facts()
returns setof transaction_facts
language plpgsql
as $$
begin
    return query
        insert into transaction_facts (project_id, amount, fee, create_date)
        select 
            project_id,
            amount,
            fee,
            create_date
        from stg.transactions
        returning *;
end;
$$;
