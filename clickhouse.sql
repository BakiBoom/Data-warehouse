CREATE TABLE contracts
(
    id UInt32,
    bk_contract_id Int32,
    currency String,
    address_test String,
    address_prod String,
    is_deleted UInt8 DEFAULT 0,
    update_date Date DEFAULT today()
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE projects
(
    id UInt32,
    bk_project_id Int32,
    title String,
    api_key String,
    is_deleted UInt8 DEFAULT 0,
    update_date Date DEFAULT today()
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE transactions
(
    id UInt32,
    transaction_hash String,
    external_wallet_address String,
    owner_wallet_address String,
    amount String,
    fee String,
    contract_id Int32,
    project_id Int32,
    create_date Date
)
ENGINE = MergeTree()
ORDER BY (contract_id, project_id, id);