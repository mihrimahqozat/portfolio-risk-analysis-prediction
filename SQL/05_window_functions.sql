-- 30-day and 90-day rolling returns and volatility per stock
WITH rolling_stats AS (
    SELECT
        date,
        ticker,
        close_price,
        daily_return,
        ROUND((AVG(daily_return) OVER (
            PARTITION BY ticker
            ORDER BY date
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) * 252)::NUMERIC, 4)                            AS rolling_30d_ann_return,
        ROUND((STDDEV(daily_return) OVER (
            PARTITION BY ticker
            ORDER BY date
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) * SQRT(252))::NUMERIC, 4)                      AS rolling_30d_volatility,
        ROUND((AVG(daily_return) OVER (
            PARTITION BY ticker
            ORDER BY date
            ROWS BETWEEN 89 PRECEDING AND CURRENT ROW
        ) * 252)::NUMERIC, 4)                            AS rolling_90d_ann_return,
        ROUND(STDDEV(daily_return) OVER (
            PARTITION BY ticker
            ORDER BY date
            ROWS BETWEEN 89 PRECEDING AND CURRENT ROW
        ) * SQRT(252))::NUMERIC, 4)                      AS rolling_90d_volatility
    FROM stock_prices
)
SELECT *
FROM rolling_stats
WHERE rolling_30d_volatility IS NOT NULL
ORDER BY ticker, date;