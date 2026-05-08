-- Annual return and volatility per stock
WITH annual_stats AS (
    SELECT
        sp.ticker,
        p.company_name,
        p.sector,
        p.weight,
        EXTRACT(YEAR FROM sp.date)                               AS year,
        COUNT(sp.date)                                           AS trading_days,
        ROUND((AVG(sp.daily_return) * 252)::NUMERIC, 4)          AS annualized_return,
        ROUND((STDDEV(sp.daily_return) * SQRT(252))::NUMERIC, 4) AS annualized_volatility,
        ROUND(MIN(sp.close_price)::NUMERIC, 2)                   AS yearly_low,
        ROUND(MAX(sp.close_price)::NUMERIC, 2)                   AS yearly_high
    FROM stock_prices sp
    JOIN portfolio p ON sp.ticker = p.ticker
    GROUP BY 
		sp.ticker, 
		p.company_name, 
		p.sector,
        p.weight, 
		EXTRACT(YEAR FROM sp.date)
)
SELECT 
	*,
    ROUND(annualized_return / NULLIF(annualized_volatility, 0), 4) AS return_to_risk_ratio
FROM annual_stats
ORDER BY 
	ticker, 
	year;