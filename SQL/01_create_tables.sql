DROP TABLE IF EXISTS stock_prices;
DROP TABLE IF EXISTS portfolio;

-- Daily stock price data
CREATE TABLE stock_prices (
    date            DATE,
    ticker          TEXT,
    open_price      NUMERIC(15, 4),
    high_price      NUMERIC(15, 4),
    low_price       NUMERIC(15, 4),
    close_price     NUMERIC(15, 4),
    volume          BIGINT,
    daily_return    NUMERIC(15, 6)
);

-- Portfolio holdings
CREATE TABLE portfolio (
    ticker          TEXT,
    company_name    TEXT,
    sector          TEXT,
    weight          NUMERIC(6, 4)
);