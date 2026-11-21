USE [Front];

-- 1. Единицы изм
select id, sizeid as name, portionrate as factor
from [size]
order by id;

select 'insert into dim_ranges(external_id, name, factor) values ('
    + cast(t1.id as varchar(max)) + ','''
    + t1.name + ''','
    + cast(t1.factor as varchar(max)) + ');' as [sql]
from (
    select id, sizeid as name, portionrate as factor
    from [size]
) as t1
order by t1.id;

-- 2. категории
select id, description as name,
    case when coalesce(ParentID, 0) = 0
        then null else ParentID
    end as parent_id
from dbo.category
order by parent_id, name, id;

select 'insert into dim_categories(external_id, name, parent_id) values ('
    + cast(t1.id as varchar(max)) + ','
    + coalesce('''' + t1.name + '''', 'NULL') + ','
    + coalesce(cast(t1.parent_id as varchar(max)), 'NULL') + ');' as [sql]
from (
    select id, description as name,
        case when coalesce(ParentID, 0) = 0
            then null else ParentID
        end as parent_id
    from dbo.category
) as t1
order by t1.parent_id, t1.name, t1.id;

-- 3. Группы поставщиков
SELECT
    g.vendorgroupid AS external_id,
    g.description AS name
FROM dbo.vendorgroup AS g
order by external_id;

select 'insert into dim_vendor_groups(external_id, name) values ('
    + cast(t1.external_id as varchar(max)) + ','
    + coalesce('''' + t1.name + '''', 'NULL') + ');' as [sql]
from (
    SELECT
        g.vendorgroupid AS external_id,
        g.description AS name
    FROM dbo.vendorgroup AS g
) as t1
order by t1.external_id;

-- 4. Поставщики
select v.id, v.clientid as name, v.clientgroup as parent_id,
    g.description as parent_name
from dbo.vendors as v
inner join dbo.vendorgroup as g on v.clientgroup = g.vendorgroupid
order by parent_id, id;

select 'insert into dim_vendors(external_id, name, parent_id, parent_name) values ('
    + cast(t1.id as varchar(max)) + ','
    + coalesce('''' + t1.name + '''', 'NULL') + ','
    + coalesce(cast(t1.parent_id as varchar(max)), 'NULL') + ','
    + coalesce('''' + t1.parent_name + '''', 'NULL') + ');' as [sql]
from (
    select v.id, v.clientid as name, v.clientgroup as parent_id,
        g.description as parent_name
    from dbo.vendors as v
    inner join dbo.vendorgroup as g on v.clientgroup = g.vendorgroupid
) as t1
order by t1.parent_id, t1.id;

-- 5. Товары и блюда
SELECT
    p.id AS external_id,
    p.productid AS product_code,
    p.description AS name,
    p.CategoryID AS category_id,
    c.[description] as category_description,
    p.SizeID AS unit_id,
    s.[description] as size_description
FROM dbo.product AS p
LEFT JOIN category c ON c.id = p.CategoryID
LEFT JOIN size s ON p.SizeID = s.ID
order by external_id;

select 'insert into dim_products(external_id, product_code, name, category_id, category_description, unit_id, size_description) values ('
    + cast(t1.external_id as varchar(max)) + ','
    + coalesce('''' + t1.product_code + '''', 'NULL') + ','
    + coalesce('''' + t1.name + '''', 'NULL') + ','
    + coalesce(cast(t1.category_id as varchar(max)), 'NULL') + ','
    + coalesce('''' + t1.category_description + '''', 'NULL') + ','
    + coalesce(cast(t1.unit_id as varchar(max)), 'NULL') + ','
    + coalesce('''' + t1.size_description + '''', 'NULL') + ');' as [sql]
from (
    SELECT
        p.id AS external_id,
        p.productid AS product_code,
        p.description AS name,
        p.CategoryID AS category_id,
        c.[description] as category_description,
        p.SizeID AS unit_id,
        s.[description] as size_description
    FROM dbo.product AS p
    LEFT JOIN category c ON c.id = p.CategoryID
    LEFT JOIN size s ON p.SizeID = s.ID
) as t1
order by t1.external_id;

-- 6. Сотрудники с ролью доступа
SELECT
    p.personid AS external_id,
    p.lastname AS last_name,
    p.firstname AS first_name,
    p.securityaccess AS access_role_id,
    s.[description] AS access_role_name
FROM dbo.personnel AS p
LEFT JOIN dbo.securityaccess AS s ON s.securityaccessid = p.securityaccess
order by external_id;

select 'insert into dim_employees(external_id, last_name, first_name, access_role_id, access_role_name) values ('
    + cast(t1.external_id as varchar(max)) + ','
    + coalesce('''' + t1.last_name + '''', 'NULL') + ','
    + coalesce('''' + t1.first_name + '''', 'NULL') + ','
    + coalesce(cast(t1.access_role_id as varchar(max)), 'NULL') + ','
    + coalesce('''' + t1.access_role_name + '''', 'NULL') + ');' as [sql]
from (
    SELECT
        p.personid AS external_id,
        p.lastname AS last_name,
        p.firstname AS first_name,
        p.securityaccess AS access_role_id,
        s.[description] AS access_role_name
    FROM dbo.personnel AS p
    LEFT JOIN dbo.securityaccess AS s ON s.securityaccessid = p.securityaccess
) as t1
order by t1.external_id;

-- 7. Компании
SELECT
    c.ID AS external_id,
    c.CompanyName AS name
FROM dbo.bm_Companies AS c
order by external_id;

select 'insert into dim_companies(external_id, name) values ('
    + cast(t1.external_id as varchar(max)) + ','
    + coalesce('''' + t1.name + '''', 'NULL') + ');' as [sql]
from (
    SELECT
        c.ID AS external_id,
        c.CompanyName AS name
    FROM dbo.bm_Companies AS c
) as t1
order by t1.external_id;

-- 8. Склады
SELECT
    s.id AS external_id,
    s.description AS name,
    s.CompanyID AS company_id,
    c.CompanyName as company_name
FROM dbo.storages AS s
LEFT JOIN bm_Companies c ON s.CompanyID = c.ID
order by external_id;

select 'insert into dim_storages(external_id, name, company_id, company_name) values ('
    + cast(t1.external_id as varchar(max)) + ','
    + coalesce('''' + t1.name + '''', 'NULL') + ','
    + coalesce(cast(t1.company_id as varchar(max)), 'NULL') + ','
    + coalesce('''' + t1.company_name + '''', 'NULL') + ');' as [sql]
from (
    SELECT
        s.id AS external_id,
        s.description AS name,
        s.CompanyID AS company_id,
        c.CompanyName as company_name
    FROM dbo.storages AS s
    LEFT JOIN bm_Companies c ON s.CompanyID = c.ID
) as t1
order by t1.external_id;

-- 9. Типы складских документов
SELECT
    d.ID AS external_id,
    d.Description AS name
FROM dbo.bm_JournalTypeDocuments AS d
order by external_id;

select 'insert into dim_document_types(external_id, name) values ('
    + cast(t1.external_id as varchar(max)) + ','
    + coalesce('''' + t1.name + '''', 'NULL') + ');' as [sql]
from (
    SELECT
        d.ID AS external_id,
        d.Description AS name
    FROM dbo.bm_JournalTypeDocuments AS d
) as t1
order by t1.external_id;

-- 10. Виды складских движений
SELECT
    o.ID AS external_id,
    o.Description AS name,
    o.Factor AS factor
FROM dbo.bm_StorageOperationsType AS o
order by external_id;

select 'insert into dim_storage_operation_types(external_id, name, factor) values ('
    + cast(t1.external_id as varchar(max)) + ','
    + coalesce('''' + t1.name + '''', 'NULL') + ','
    + coalesce(cast(t1.factor as varchar(max)), 'NULL') + ');' as [sql]
from (
    SELECT
        o.ID AS external_id,
        o.Description AS name,
        o.Factor AS factor
    FROM dbo.bm_StorageOperationsType AS o
) as t1
order by t1.external_id;

-- 11. Виды операций
SELECT
    t.transtypeid AS external_id,
    t.description AS name,
    t.transgroupid AS transaction_group_id,
    t.PreviewGroupType AS group_code
FROM dbo.transtype AS t
order by external_id;

select 'insert into dim_transaction_types(external_id, name, transaction_group_id, group_code) values ('
    + cast(t1.external_id as varchar(max)) + ','
    + coalesce('''' + t1.name + '''', 'NULL') + ','
    + coalesce(cast(t1.transaction_group_id as varchar(max)), 'NULL') + ','
    + coalesce('''' + t1.group_code + '''', 'NULL') + ');' as [sql]
from (
    SELECT
        t.transtypeid AS external_id,
        t.description AS name,
        t.transgroupid AS transaction_group_id,
        t.PreviewGroupType AS group_code
    FROM dbo.transtype AS t
) as t1
order by t1.external_id;

-- 12. Способы оплаты
SELECT
    p.paymenttypeid AS external_id,
    p.description AS name
FROM dbo.paymenttype AS p
order by external_id;

select 'insert into dim_payment_types(external_id, name) values ('
    + cast(t1.external_id as varchar(max)) + ','
    + coalesce('''' + t1.name + '''', 'NULL') + ');' as [sql]
from (
    SELECT
        p.paymenttypeid AS external_id,
        p.description AS name
    FROM dbo.paymenttype AS p
) as t1
order by t1.external_id;
