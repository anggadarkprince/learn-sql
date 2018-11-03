SELECT * FROM sandbox.transactions;

SELECT b.*, t.total FROM (
	SELECT owner, category, SUM(total) AS total
	FROM transactions
	GROUP BY owner, category
) t
JOIN (
	SELECT m1.owner, m1.category, m1.posisi
	FROM transactions m1 
	LEFT JOIN transactions m2
	 ON (m1.category = m2.category 
		AND m1.owner = m2.owner 
			AND m1.transaction_date < m2.transaction_date)
	WHERE m2.transaction_date IS NULL
) b
ON t.owner = b.owner AND t.category = b.category
