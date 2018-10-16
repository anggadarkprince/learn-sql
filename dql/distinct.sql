-- distinct duplicate value from all column (make every record unique combine from all column)
SELECT DISTINCT transaction_date FROM transactions;

-- this DISTINCT has no effect because we know id always unique
-- even though transaction_date in same value still result unique record combination with id
SELECT DISTINCT id, transaction_date FROM transactions;

-- either title or transaction_date may have same value but remember,
-- 2 or more record will be distinct if title and transaction_date have exact same value
SELECT DISTINCT title, transaction_date FROM transactions;