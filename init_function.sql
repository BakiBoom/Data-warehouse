create or replace function etl.merge_contracts()
returns void
language plpgsql
as
$$
begin
    update dwh.contracts c
    set
        currency     = s.currency,
        address_test = s.address_test,
        address_prod = s.address_prod,
        update_date  = now(),
        isdeleted    = false
    from stg.contracts s
    where s.id = c.bk_contract_id
      and (
            s.currency     is distinct from c.currency
         or s.address_test is distinct from c.address_test
         or s.address_prod is distinct from c.address_prod
      );
    insert into dwh.contracts (
        bk_contract_id,
        currency,
        address_test,
        address_prod,
        isdeleted,
        update_date
    )
    select
        s.id,
        s.currency,
        s.address_test,
        s.address_prod,
        false,
        now()
    from stg.contracts s
    left join dwh.contracts c on c.bk_contract_id = s.id
    where c.bk_contract_id is null;
    update dwh.contracts c
    set
        isdeleted   = true,
        update_date = now()
    where not exists (
        select 1
        from stg.contracts s
        where s.id = c.bk_contract_id
    );
end;
$$;


create or replace function etl.merge_projects()
returns void
language plpgsql
as
$$
begin
    update dwh.projects p
    set
        title     = s.title,
        api_key = s.api_key,
        update_date  = now(),
        is_deleted    = false
    from stg.projects s
    where s.id = p.bk_project_id
      and (
            s.title     is distinct from p.title
         or s.api_key is distinct from p.api_key
      );
    insert into dwh.projects (
        bk_project_id,
        title,
        api_key,
        is_deleted,
        update_date
    )
    select
        s.id,
        s.title,
        s.api_key,
        false,
        now()
    from stg.projects s
    left join dwh.projects p on p.bk_project_id = s.id
    where p.bk_project_id is null;
    update dwh.projects p
    set
        is_deleted   = true,
        update_date = now()
    where not exists (
        select 1
        from stg.contracts s
        where s.id = p.bk_project_id
    );
end;
$$;

create or replace function etl.factinsert_transactions(p_datefrom timestamp, p_dateto timestamp)
returns void
language plpgsql
as
$$
begin
    delete from dwh.transactions
    where create_date::date between p_datefrom::date and p_dateto::date;
    insert into dwh.transactions (
        transaction_hash,
        external_wallet_address,
        owner_wallet_address,
        amount,
        fee,
        contract_id,
        project_id,
        create_date
    )
    select
        st.transaction_hash,
        st.external_wallet_address,
        st.owner_wallet_address,
        st.amount::numeric,
        st.fee::numeric,
        c.bk_contract_id,
        p.bk_project_id,
        st.create_date::date
    from stg.transactions st
    inner join dwh.contracts c
        on c.bk_contract_id = st.contract_id
    inner join dwh.projects p
        on p.bk_project_id = st.project_id
    where st.create_date::date between p_datefrom::date and p_dateto::date;
end;
$$;