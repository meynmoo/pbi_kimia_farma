CREATE TABLE dataset_kimia_farma.analisa_table AS
SELECT 
    ft.transaction_id,
    ft.date,
    ft.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS branch_rating, -- Alias added to distinguish the rating column from kf_kantor_cabang table
    ft.customer_name,
    ft.product_id,
    kp.product_name,
    kp.price,
    ft.discount_percentage,
    CASE
        WHEN kp.price <= 50000 THEN 0.1
        WHEN kp.price > 50000 AND kp.price <= 100000 THEN 0.15
        WHEN kp.price > 100000 AND kp.price <= 300000 THEN 0.20
        WHEN kp.price > 300000 AND kp.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,
    ft.price * (1 - ft.discount_percentage) AS nett_sales,
    (ft.price * (1 - ft.discount_percentage) * 
        CASE
            WHEN kp.price <= 50000 THEN 0.1
            WHEN kp.price > 50000 AND kp.price <= 100000 THEN 0.15
            WHEN kp.price > 100000 AND kp.price <= 300000 THEN 0.20
            WHEN kp.price > 300000 AND kp.price <= 500000 THEN 0.25
            ELSE 0.30
        END
    ) AS nett_profit,
    ft.rating AS transaction_rating -- Alias added to distinguish the rating column from kf_final_transaction table
FROM 
    dataset_kimia_farma.kf_final_transaction ft
JOIN 
    dataset_kimia_farma.kf_kantor_cabang kc ON ft.branch_id = kc.branch_id
JOIN 
    dataset_kimia_farma.kf_product kp ON ft.product_id = kp.product_id;
