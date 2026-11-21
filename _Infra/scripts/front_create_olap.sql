DO $$
BEGIN
    CREATE SEQUENCE public.seq_dim_ranges;

    CREATE TABLE public.dim_ranges (
        id bigint primary key DEFAULT nextval('public.seq_dim_ranges'),
        external_id bigint NOT NULL UNIQUE,
        name text,
        factor float,
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_ranges IS 'Единицы измерения и размеры товаров';

    CREATE SEQUENCE public.seq_dim_categories;

    CREATE TABLE public.dim_categories (
        id bigint primary key DEFAULT nextval('public.seq_dim_categories'),
        external_id bigint NOT NULL UNIQUE,
        name text,
        parent_id bigint REFERENCES public.dim_categories (external_id),
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_categories IS 'Категории товаров';

    CREATE SEQUENCE public.seq_dim_vendor_groups;

    CREATE TABLE public.dim_vendor_groups (
        id bigint primary key DEFAULT nextval('public.seq_dim_vendor_groups'),
        external_id bigint NOT NULL UNIQUE,
        name text,
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_vendor_groups IS 'Группы поставщиков.';

    CREATE SEQUENCE public.seq_dim_vendors;

    CREATE TABLE public.dim_vendors (
        id bigint primary key DEFAULT nextval('public.seq_dim_vendors'),
        external_id bigint NOT NULL UNIQUE,
        name text,
        parent_id bigint REFERENCES public.dim_vendor_groups (external_id),
        parent_name text,
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_vendors IS 'Поставщики и их группы.';

    CREATE SEQUENCE public.seq_dim_products;

    CREATE TABLE public.dim_products (
        id bigint primary key DEFAULT nextval('public.seq_dim_products'),
        external_id bigint NOT NULL UNIQUE,
        product_code text,
        name text,
        category_id bigint REFERENCES public.dim_categories (external_id),
        category_description text,
        unit_id bigint REFERENCES public.dim_ranges (external_id),
        size_description text,
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_products IS 'Товары и блюда с категориями и единицами измерения.';

    CREATE SEQUENCE public.seq_dim_employees;

    CREATE TABLE public.dim_employees (
        id bigint primary key DEFAULT nextval('public.seq_dim_employees'),
        external_id bigint NOT NULL UNIQUE,
        last_name text,
        first_name text,
        access_role_id integer,
        access_role_name text,
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_employees IS 'Сотрудники и их роли доступа';

    CREATE SEQUENCE public.seq_dim_companies;

    CREATE TABLE public.dim_companies (
        id bigint primary key DEFAULT nextval('public.seq_dim_companies'),
        external_id bigint NOT NULL UNIQUE,
        name text,
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_companies IS 'Компании.';

    CREATE SEQUENCE public.seq_dim_storages;

    CREATE TABLE public.dim_storages (
        id bigint primary key DEFAULT nextval('public.seq_dim_storages'),
        external_id bigint NOT NULL UNIQUE,
        name text,
        company_id bigint REFERENCES public.dim_companies (external_id),
        company_name text,
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_storages IS 'Склады и компании, к которым они относятся.';

    CREATE SEQUENCE public.seq_dim_document_types;

    CREATE TABLE public.dim_document_types (
        id bigint primary key DEFAULT nextval('public.seq_dim_document_types'),
        external_id bigint NOT NULL UNIQUE,
        name text,
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_document_types IS 'Типы складских документов.';

    CREATE SEQUENCE public.seq_dim_storage_operation_types;

    CREATE TABLE public.dim_storage_operation_types (
        id bigint primary key DEFAULT nextval('public.seq_dim_storage_operation_types'),
        external_id bigint NOT NULL UNIQUE,
        name text,
        factor integer,
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_storage_operation_types IS 'Виды складских движений.';

    CREATE SEQUENCE public.seq_dim_transaction_types;

    CREATE TABLE public.dim_transaction_types (
        id bigint primary key DEFAULT nextval('public.seq_dim_transaction_types'),
        external_id bigint NOT NULL UNIQUE,
        name text,
        transaction_group_id integer,
        group_code text,
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_transaction_types IS 'Типы кассовых операций.';

    CREATE SEQUENCE public.seq_dim_payment_types;

    CREATE TABLE public.dim_payment_types (
        id bigint primary key DEFAULT nextval('public.seq_dim_payment_types'),
        external_id bigint NOT NULL UNIQUE,
        name text,
        date_add timestamp default now()
    );

    COMMENT ON TABLE public.dim_payment_types IS 'Способы оплаты.';
END;
$$;
