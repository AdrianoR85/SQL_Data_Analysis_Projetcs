-- ============================================================
--  RETAIL SALES ANALYSIS — PostgreSQL
-- ============================================================

CREATE TABLE retail_sales (
    transaction_id  INT  PRIMARY KEY,
    sale_date       DATE,          
    sale_time       TIME,          
    customer_id     INT,   
    gender          VARCHAR(10),   
    age             SMALLINT,      
    category        VARCHAR(100),  
    quantity        SMALLINT,     
    price_per_unit  NUMERIC(10,2),
    cogs            NUMERIC(10,2), 
    total_sale      NUMERIC(10,2)
);

-- Indexes for performance on analytical queries
CREATE INDEX idx_rs_date        ON retail_sales(sale_date);
CREATE INDEX idx_rs_customer    ON retail_sales(customer_id);
CREATE INDEX idx_rs_category    ON retail_sales(category);
