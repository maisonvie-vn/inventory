-- 1. Create categories table
create table if not exists categories (
    id uuid default gen_random_uuid() primary key,
    name varchar(100) not null,
    type varchar(20) not null check (type in ('ingredient', 'menu_item')),
    department varchar(10) not null check (department in ('BEP', 'BAR')),
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Create ingredients table
create table if not exists ingredients (
    id varchar(50) primary key,
    nom_fr varchar(255) not null,
    ten_vi varchar(255) not null,
    name_en varchar(255),
    unit varchar(50) not null,
    unit_price numeric(12, 2) default 0.00 not null,
    yield_rate numeric(5, 2) default 100.00 not null,
    category_id uuid references categories(id) on delete set null,
    is_active boolean default true not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. Create menu_items table
create table if not exists menu_items (
    id varchar(50) primary key,
    name varchar(255) not null,
    sale_price numeric(12, 2) not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 4. Create recipes table
create table if not exists recipes (
    id uuid default gen_random_uuid() primary key,
    recipe_code varchar(50) not null,
    ingredient_id varchar(50) references ingredients(id) on delete cascade not null,
    qty_net numeric(10, 4) not null,
    yield_rate numeric(5, 2) not null,
    qty_eff numeric(10, 4) not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    unique (recipe_code, ingredient_id)
);
