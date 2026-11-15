# Анализ базы данных


## Закупка продукции

**Основные таблицы** — `bm_StorageOperations`, `bm_JournalBarnetDocs`.

**Связанные таблицы** — `product`, `vendors`, `bm_JournalTypeDocuments`, `bm_StorageOperationsType`.

### Основные таблицы

#### `bm_StorageOperations`

Хранит складские движения. В строке поступления указаны товар, поставщик, количество и сумма.

- `ID` — ключ строки движения, например `6326063`.
- `DocumentID` — ссылка на документ `bm_JournalBarnetDocs.ID`, например `465980`.
- `OperationID` — ссылка на `bm_StorageOperationsType.ID`. Код `1` означает «Поступление».
- `ProductID` — ссылка на `product.id`, например `4377`.
- `VendorID` — код поставщика, например `91`. Для поступлений сопоставляется с `vendors.id`.
- `RangeID` — код размера или единицы.
- `Count` — количество поступившего товара, например `6`.
- `Price` — цена за единицу, например `404.00`.
- `Amount` — сумма, например `2424.00`.
- `Period` — код периода движения, например `202312`.
- `DateAdd` — когда добавили движение, например `2023-12-04 17:08:07`.

<details>
<summary>Пример строк bm_StorageOperations</summary>

![Строки складских движений](./examples/purchase-movement-rows.png)

</details>

**Проверка `DocumentID`.** Запрос ищет движения без соответствующего документа. Пустая выборка означает, что таких строк нет.

![Результат проверки DocumentID](./checks/purchase-movement-document-id.png)

**Проверка `OperationID`.** Запрос ищет движения, для которых отсутствует тип операции. Выборка пустая.

![Результат проверки OperationID](./checks/purchase-movement-operation-id.png)

**Проверка `ProductID`.** Запрос ищет движения с заполненным кодом товара, для которого нет карточки в `product`. Выборка пустая.

![Результат проверки ProductID](./checks/purchase-product-id.png)

**Проверка `VendorID`.** Запрос ищет строки закупочных поступлений без карточки поставщика. Выборка пустая, у каждой строки есть поставщик.

![Результат проверки VendorID](./checks/purchase-vendor-id.png)

#### `bm_JournalBarnetDocs`

Хранит сам документ. На один документ могут ссылаться несколько строк движения через `DocumentID`.

- `ID` — ключ документа, например `465980`.
- `DocumentTypeID` — внешний ключ на `bm_JournalTypeDocuments.ID`. Код `4` означает «Поступление продуктов».
- `Period` — дата и время документа, например `2023-11-30 08:00:00`.

<details>
<summary>Пример строк bm_JournalBarnetDocs</summary>

![Строки журнала документов](./examples/purchase-document-rows.png)

</details>

**Проверка `DocumentTypeID`.** Запрос ищет документы без соответствующего типа. Пустая выборка подтверждает, что для каждого документа есть запись в справочнике типов.

![Результат проверки DocumentTypeID](./checks/purchase-document-type-id.png)

### Связанные таблицы

#### `product`

Справочник товаров. `id` — ключ товара, например `4377`. `description` — название, например «Фарш домашний с/м».

<details>
<summary>Пример строк product</summary>

![Карточки товаров](./examples/purchase-product-rows.png)

</details>

#### `vendors`

Справочник поставщиков. `id` — ключ поставщика, например `95`. `firstname` — имя или название, например «ООО Вираж».

<details>
<summary>Пример строк vendors</summary>

![Карточки поставщиков](./examples/purchase-vendor-rows.png)

</details>

#### `bm_JournalTypeDocuments`

Справочник типов документов. `ID` — код типа, например `4`. `Description` — название, например «Поступление продуктов».

<details>
<summary>Пример строк bm_JournalTypeDocuments</summary>

![Справочник типов документов](./examples/purchase-document-type-rows.png)

</details>

#### `bm_StorageOperationsType`

Справочник видов движения. `ID` — код, например `1`. `Description` — название, например «Поступление».

<details>
<summary>Пример строк bm_StorageOperationsType</summary>

![Справочник видов складских движений](./examples/purchase-operation-type-rows.png)

</details>

### ER-диаграмма

![ER-диаграмма. Закупка продукции](./er/purchases-er.png)

## Продажа товара

**Основные таблицы** — `journal`, `bm_Journal_Details`.

**Связанные таблицы** — `transtype`, `product`, `category`, `size`.

### Основные таблицы

#### `journal`

Кассовый журнал. В нём встречаются продажи, оплаты и итоги чеков.

- `transnumber` — ключ строки журнала, например `1950990`.
- `receiptn` — номер чека, например `52169561`.
- `transtype` — тип операции из справочника `transtype`, например `101`.
- `grouptranstype` — код группы операций в журнале.
- `dater` — дата и время операции, например `2023-12-04 19:32:38`.
- `quantity` — количество, например `1`.
- `price` — цена за единицу, например `620.00`.
- `amount` — сумма, например `620.00`.

<details>
<summary>Пример строк journal</summary>

![Продажи, оплата и итог чека в кассовом журнале](./examples/sales-journal-rows.png)

</details>

#### `bm_Journal_Details`

Детализация кассовой строки.

- `ID` — ключ строки, например `225297739`.
- `SourceID` — ссылка на `journal.transnumber`, например `1950990`.
- `ProductID` — ссылка на `product.id` для товара или компонента, например `4366`.
- `BludoID` — ссылка на `product.id` для блюда, например `4822`.
- `RangeID` — ссылка на `size.ID`, например `42`.

**Проверка `SourceID`.** Ищем детали без исходной строки в `journal`. Выборка пустая.

![Результат проверки SourceID](./checks/sales-detail-source-id.png)

**Проверка `ProductID`.** Ищем детали, для которых нет товара в `product`. Выборка пустая.

![Результат проверки ProductID](./checks/sales-detail-product-id.png)

**Проверка `BludoID`.** Ищем детали, для которых нет записи блюда в `product`. Выборка пустая.

![Результат проверки BludoID](./checks/sales-detail-bludo-id.png)

**Проверка `RangeID`.** Ищем детали, для которых нет размера или единицы в `size`. Выборка пустая.

![Результат проверки RangeID](./checks/sales-detail-range-id.png)

### Связанные таблицы

#### `transtype`

Справочник кассовых операций. Поле `journal.transtype` ссылается на `transtype.transtypeid`.

- `transtypeid` — код операции, например `101`.
- `description` — название операции, например «PLU Sales».
- `transgroupid` — код группы типов. Поле допускает `NULL`.
- `PreviewGroupType` — дополнительный текстовый код в справочнике. Например, для типа `101` значение `POS`.

<details>
<summary>Пример строк transtype</summary>

![Типы кассовых операций и коды групп](./examples/sales-transaction-type-rows.png)

</details>

#### `product`

Даёт названия товаров и блюд из детализации. Например, у записи с `id = 4822` в поле `description` стоит «Пицца Пепперони 30см». Поле `CategoryID` ссылается на категорию.

#### `category`

Хранит категории товаров. По `product.CategoryID` находится запись `category.id`.

- `id` — ключ категории, например `159`.
- `description` — название, например «Мясные».
- `salesflag` — флаг продаж в карточке категории. У категории `159` стоит `1`.  Возможно, продается ли товар сейчас.

<details>
<summary>Пример строк category</summary>

![Карточки товарных категорий](./examples/sales-category-rows.png)

</details>

#### `size`

Хранит размеры и единицы измерения. Поле `bm_Journal_Details.RangeID` ссылается на `size.ID`.

- `ID` — ключ записи, например `42`.
- `sizeid` и `description` — обозначение и описание. У записи `42` в обоих полях стоит «кг».
- `BaseSizeID`, `portionsize` и `portionrate` — код базовой единицы, её обозначение и коэффициент пересчёта. Например, у «Бут.500мл» записаны `111`, «мл» и `500`.

<details>
<summary>Пример строк size</summary>

![Размеры порций и единицы измерения](./examples/sales-size-rows.png)

</details>

### ER-диаграмма

![ER-диаграмма. Продажа товара](./er/sales-er.png)

## Взаимоотношения с поставщиками

**Основные таблицы** — `vendors`, `bm_StorageOperations`.

**Связанные таблицы** — `vendorgroup`, `bm_JournalBarnetDocs`.

**`vendors`** хранит карточки поставщиков.

- `id` — ключ поставщика, например `95`.
- `firstname` — имя или название, например «ООО Вираж».
- `clientgroup` — группа поставщика из `vendorgroup`, например `31`.

**`bm_StorageOperations`** показывает, что и на какую сумму поступило от поставщика. Сопоставление `VendorID` с `vendors.id` проверено на поступлениях.

- `VendorID` — поставщик, например `91`.
- `DocumentID` — документ поставки, например `465980`.
- `Amount` — сумма по товарной строке, например `2424.00`.

**`vendorgroup`** хранит группы поставщиков. `vendorgroupid` — ключ группы, на него ссылается `vendors.clientgroup`. У группы `31` в `description` стоит «Поставщики», у группы `32` — «Без названия», почему? В обеих строках какой-то флаг `flag = 0`. -> не понятно, что за флаг?

<details>
<summary>Пример строк vendorgroup</summary>

![Группы поставщиков 31 и 32](./examples/supplier-group-rows.png)

</details>

**`bm_JournalBarnetDocs`** даёт дату поставки. По `DocumentID` из движения находится документ с нужным `ID`, например `465980`. Его `Period` — `2023-11-30 08:00:00`, а `DocumentTypeID = 4` означает «Поступление продуктов».

Таблица `bm_Contracts` -> возможно, должны были быть какие-то договоры(поставок, сотрудничества и тд). Таблица пустая

### ER-диаграмма


![ER-диаграмма. Взаимоотношения с поставщиками](./er/suppliers-er.png)

## Работа персонала

**Основные таблицы** — `personnel`, `journal`.

**Связанная таблица** — `transtype`.

**`personnel`** хранит карточки сотрудников. Поле `personid` — ключ сотрудника, например `1066`.

<details>
<summary>Пример строк personnel</summary>

![Карточки сотрудников и их идентификаторы](./examples/staff-personnel-rows.png)

</details>

**`journal`** хранит события начала и окончания работы. Для этих событий `loginid` сопоставляется с `personnel.personid`.

- `transnumber` — ключ события, например `1951154`.
- `loginid` — код сотрудника, например `1066`.
- `transtype` — тип события. Начало/конец работы
- `dater` — когда произошло событие, например `2023-12-06 09:50:30`.

**Проверка `loginid`.** Запрос ищет строки `journal`, для которых не нашёлся сотрудник по `personnel.personid`. Выборка пустая. Связь подтверждена по данным, внешний ключ отсутствует.

![Проверка связи journal.loginid с personnel.personid](./checks/staff-journal-login-id.png)

**Проверка типов событий.** Запрос показывает названия типов, которые встречаются в `journal`. В результате есть «Начало работы» и «Окончание работы».

![Типы событий, найденные в journal](./examples/staff-journal-used-transaction-types.png)

**`transtype`** расшифровывает тип события. `transtypeid` — код, например `386`. `description` — название, например «Начало работы».

<details>
<summary>Пример строк transtype</summary>

![Справочник типов операций](./examples/staff-transaction-type-rows.png)

</details>

Таблица `bm_WorkHours` -> возможно, должен был быть учет рабочего времени.

### ER-диаграмма


![ER-диаграмма. Работа персонала](./er/staff-er.png)

## Остатки

**Основная таблица** — `bm_StorageOperations`.

**Связанные таблицы** — `bm_StorageOperations_Table`, `storages`, `product`, `bm_StorageOperationsType`, `bm_JournalBarnetDocs`.

**`bm_StorageOperations`** показывает, как товар двигался по складу.

- `ID` — ключ движения, например `6325963`.
- `ProductID` — товар, например `4382`.
- `StorageID` — склад, например `41`.
- `OperationID` — вид движения. `2` означает «Списание».
- `DocumentID` — документ движения, например `465974`.
- `Count` — количество, например `-0.0500`.
- `Rest` — остаток скорей всего, например `0.0000`. 
- `DateAdd` — когда добавили строку, например `2023-12-04 16:00:51`.

**`dbo.bm_StorageOperations_Table`** хранит строки складских документов.

- `ID` — ключ строки, например `165000`.
- `DocumentID` — ссылка на `bm_JournalBarnetDocs.ID`, например `465974`.
- `OperationID` — ссылка на `bm_StorageOperationsType.ID`, например `2`.
- `ProductID` — ссылка на `product.id`, например `4382`.
- `StorageID` — ссылка на `storages.id`, например `41`.
- `Count` — количество, например `-0.0500`.
- `Amount` — сумма, например `-13.77`.

<details>
<summary>Пример строк bm_StorageOperations_Table</summary>

![Строки списания с кодами документа, склада и товара](./examples/stock-document-line-rows.png)

</details>

**`storages`** — справочник складов. По `StorageID` из движения находится склад с нужным `id`, например `41`. Поле `description` хранит название, например «Склад».

<details>
<summary>Пример строк storages</summary>

![Карточка склада 41](./examples/stock-storage-rows.png)

</details>

**`product`** — справочник товаров. По `ProductID` из движения находится товар с нужным `id`, например `4382`. Поле `description` хранит название, например «Соус Хайнц чесночный».

**`bm_StorageOperationsType`** объясняет, какое движение записано. 
**`bm_JournalBarnetDocs`** хранит документы движений.

### ER-диаграмма

![ER-диаграмма. Остатки](./er/stock-er.png)
