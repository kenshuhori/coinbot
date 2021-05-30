---- drop ----
DROP TABLE IF EXISTS prices;
DROP TABLE IF EXISTS conversions;

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
CREATE TABLE IF NOT EXISTS conversions
(
 `id`               INT(20) AUTO_INCREMENT,
 `product_code`     VARCHAR(20) NOT NULL,
 `child_order_id`   VARCHAR(20) NOT NULL,
 `price`            INT(20),
 `size`             INT(20),
 `type`             VARCHAR(20) NOT NULL,
 `side`             VARCHAR(20) NOT NULL,
 `created_at`       Datetime DEFAULT NULL,
 `updated_at`       Datetime DEFAULT NULL,
    PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
