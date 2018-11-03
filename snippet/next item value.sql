SELECT item, data_prices.weight AS item_weight, prices.weight AS min_weight, max_weight, price 
FROM data_prices
LEFT JOIN (
	SELECT *, (
		SELECT weight FROM prices AS next_prices
		WHERE weight = (
			SELECT MIN(weight) FROM prices AS all_prices 
      WHERE weight > prices.weight
				AND type = 'TON'
		)
	) AS max_weight
	FROM prices
) AS prices
	ON data_prices.weight >= prices.weight
		AND IF(prices.max_weight IS NULL, TRUE, (data_prices.weight < prices.max_weight))
WHERE prices.type = 'TON';


SELECT *, (
	SELECT weight FROM prices AS next_prices
	WHERE weight = (SELECT MIN(weight) FROM prices AS all_prices WHERE weight > prices.weight AND type = 'TON')
) AS max_weight
FROM prices WHERE prices.type = 'TON';
