with cte as (select      
      order_id,
      count(*) as item_count,
      count(distinct product_id) as distinct_product_count,
      count(distinct seller_id) as distinct_seller_count,
      sum(price) as total_items_price,
      sum(freight_value) as total_freight_value,
      sum(item_total_value) as total_order_value,
      sum(product_weight_g) as total_weight_g
from {{ref("int_order_items_enriched")}}
group by order_id)

select * from cte

-- select
-- --  count(*) -- 96920
-- -- sum(item_count) -- 110642
-- sum(total_items_price) -- 13369075.55
--  from cte