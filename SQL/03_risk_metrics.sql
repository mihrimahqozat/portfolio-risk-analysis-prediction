-- Sharpe ratio per stock over full period
-- Using 4.5% as risk-free rate (approximate 5-year avg T-bill rate)
WITH full_period_stats AS (
    SELECT
        sp.ticker,
        p.company_name,
        p.sector,
        p.weight,
        COUNT(sp.date)                                           AS total_trading_days,
        ROUND((AVG(sp.daily_return) * 252)::NUMERIC, 4)          AS annualized_return,
        ROUND((STDDEV(sp.daily_return) * SQRT(252))::NUMERIC, 4) AS annualized_volatility
    FROM stock_prices sp
    JOIN portfolio p ON sp.ticker = p.ticker
    GROUP BY 
		sp.ticker, 
		p.company_name, 
		p.sector, 
		p.weight
),
sharpe AS (
    SELECT 
		*,
        0.045                                                                    AS risk_free_rate,
        ROUND((annualized_return - 0.045) / NULLIF(annualized_volatility, 0), 4) AS sharpe_ratio
    FROM full_period_stats
)
SELECT *,
    RANK() OVER (ORDER BY sharpe_ratio DESC)           AS sharpe_rank,
    RANK() OVER (ORDER BY annualized_return DESC)      AS return_rank,
    RANK() OVER (ORDER BY annualized_volatility ASC)   AS lowest_risk_rank
FROM sharpe
ORDER BY sharpe_ratio DESC;