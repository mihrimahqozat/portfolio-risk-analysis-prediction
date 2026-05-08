-- Maximum drawdown per stock
WITH running_max AS (
    SELECT
        date,
        ticker,
        close_price,
        MAX(close_price) OVER (
            PARTITION BY ticker
            ORDER BY date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS peak_price
    FROM stock_prices
),
drawdowns AS (
    SELECT
        date,
        ticker,
        close_price,
        peak_price,
        ROUND(((close_price - peak_price) /
            NULLIF(peak_price, 0) * 100)::NUMERIC, 2) AS drawdown_pct
    FROM running_max
)
SELECT
    ticker,
    ROUND(MIN(drawdown_pct)::NUMERIC, 2)                AS max_drawdown_pct,
    MIN(date)                                           AS first_date,
    MAX(date)                                           AS last_date
FROM drawdowns
GROUP BY ticker
ORDER BY max_drawdown_pct ASC;