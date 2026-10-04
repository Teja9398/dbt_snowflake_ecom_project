with cte as(
      select 
      o.order_id,
      o.order_item_id,
      p.product_id,
      p.product_category_name,
      o.seller_id,
      o.price,
      o.freight_value
      o.price + o.freight_value as item_total_value
      from
      {{ref("stg_order_items")}} o join {{ref("stg_products")}} p
      using(order_id)
      join {{ref("stg_sellers")}} s
      using(seller_id)
      
)
select * from cte;