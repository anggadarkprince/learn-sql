-- add index (multiple columns allowed)
CREATE INDEX idx_product_identity
ON products (sku, product_name);

-- add unique column index
CREATE UNIQUE INDEX idx_product_sku
ON products (sku); 

-- drop index
ALTER TABLE products
DROP INDEX idx_product_identity; 