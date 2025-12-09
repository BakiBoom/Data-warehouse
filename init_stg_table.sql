CREATE TABLE contracts (
    id SERIAL PRIMARY KEY,
    currency VARCHAR(15),
    address_test VARCHAR(255),
    address_prod VARCHAR(255)
);

CREATE TABLE transaction_states (
    id INTEGER PRIMARY KEY,
    title VARCHAR(255)
);

CREATE TABLE gates (
    id SERIAL PRIMARY KEY,
    title VARCHAR(20)
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    api_key VARCHAR(255) NOT NULL
);

CREATE TABLE transactions (
    id BIGSERIAL PRIMARY KEY,
    transaction_hash VARCHAR(256) NOT NULL,
    external_wallet_address VARCHAR(100) NOT NULL,
    owner_wallet_address VARCHAR(100),
    amount VARCHAR(100),
    contract_id BIGINT REFERENCES contracts(id),
    fee VARCHAR(100),
    is_prod_network SMALLINT DEFAULT 0,
    transaction_state_id INT REFERENCES transaction_states(id),
    gate_id INT REFERENCES gates(id),
    project_id BIGINT REFERENCES projects(id),
    ext_id BIGINT,
    block_number BIGINT,
    block_conf INT DEFAULT 20,
    create_date VARCHAR(100) NOT NULL,
    update_date VARCHAR(100) NOT NULL
);


INSERT INTO transaction_states (id, title)
VALUES (1, 'Initial'),
 (4, 'Processing'),
 (5, 'Checking'),
 (8, 'Success'),
 (9, 'Failed'),
 (10, 'WaitingAFCheck'),
 (11, 'AFBlocked');

INSERT INTO gates (id, title)
VALUES (1, 'DEBIT'),
 (2, 'CREDIT'),
 (3, 'COLLECT');
 
INSERT INTO projects (title, api_key)
VALUES
    ('Project 1', 'api_key_4f92c1e7a8b641239df0b7e3c12fdb73'),
    ('Project 2',  'api_key_c98ad73f21b9470fb32de19af40e82cc'),
    ('Project 3', 'api_key_0af3e91b72cc4a1f8d9e6b54a22c3d10'),
    ('Project I', 'api_key_4f92c1e7a8b641239df0b7e3c12fdb73'),
    ('Project II',  'api_key_c98ad73f21b9470fb32de19af40e82cc'),
    ('Project III', 'api_key_4f92c1e7a8b641239df0b7e3c12fdb73'),
    ('Project 11',  'api_key_c98ad73f21b9470fb32de19af40e82cc'),
    ('Project 22', 'api_key_4f92c1e7a8b641239df0b7e3c12fdb73'),
    ('Project 33',  'api_key_c98ad73f21b9470fb32de19af40e82cc');

INSERT INTO contracts (id, currency, address_test, address_prod)
VALUES (1, 'TRX', '', ''),
 (2, 'USDT-TRC20', 'TG3XXyExBkPp9nzdajDZsozEu4BkaSJozs', 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t'),
 (3, 'USDC-TRC20', 'TSdZwNqpHofzP6BsBKGQUWdBeJphLmF6id', 'TEkxiTehnzSmSe2XqrBj4w32RUN966rdz8'),
 (4, 'Energy', '', '');