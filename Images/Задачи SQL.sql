# 1. Имеется таблица  с клиентами. Найти кол-во уникальных клиентов в каждом городе (Таблица_1)

SELECT 
      city, COUNT(DISTINCT id) as count_clients
FROM table_1 
GROUP BY city


  
# 2. Найти последний остаток клиента по каждому его счету на дату, используя Таблиа_2 и Таблица_2. В таблице_2 интервальное хранение, записи добавляются только при изменении остатка.
  У одного клиента может быть несколько счетов (идентификатор счета - поле acc_id)

SELECT 
      c.id,
      c.fio,
      c.city,
      p.acc_id,
      p.rest,
      p.date
FROM table_1 c
      JOIN table_2 p
            ON p.client_oid = c.id
WHERE p.date = (
      SELECT MAX(p2.date)
      FROM table_2 p2
      WHERE p2.clien_oid = p.client_oid
      AND p2.acc_id = p.acc_id
      AND p2.date <= :YourDate
      )


# 3. Вывести идентификаторы клиентов, с остатком больше 1млн. рублей. У одного клиента может быть несколько счетов (идентификатор счета - поле acc_id). Таблица_2

SELECT
      DISTINCT client_oid
FROM table_2
WHERE rest > 1000000



  
# 4. Вывести город, с наибольшим числом открытых счетов и остатом больше 0. Таблица_1 и Таблица_2

SELECT
      c.city
FROM table_1 c
      JOIN table_2 p
          ON p.client_oid = c.id
WHERE p.rest > 0
GROUP BY c.city
ORDER BY COUNT(p.id) DESC
LIMIT 1



# 5. Удалить дубли в таблице без использования доп. Таблиц. Таблица имеет только 1 поле - value. Удалить_дубликаты

WITH cte AS (
    SELECT value,
           ROW_NUMBER() OVER (PARTITION BY value ORDER BY value) AS rn
    FROM duplicates
)
DELETE FROM duplicates
WHERE value IN (
    SELECT value FROM cte WHERE rn > 1
)
