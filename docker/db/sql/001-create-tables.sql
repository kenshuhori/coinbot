---- drop ----
DROP TABLE IF EXISTS prices;

---- create ----
CREATE TABLE IF NOT EXISTS prices
(
 `id`               INT(20) AUTO_INCREMENT,
 `product_code`     VARCHAR(20) NOT NULL,
 `price`            INT(20),
 `created_at`       Datetime DEFAULT NULL,
 `updated_at`       Datetime DEFAULT NULL,
    PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
