with order_items as(
      select * from 
      {{ref("stg_order_items")}}
),
products as (
      select 
      p.product_id,
      p1.product_category_name_english as product_category_name,
      p.product_photos_qty,
      p.PRODUCT_WEIGHT_G,
      p.product_length_cm,
      p.product_height_cm,
      p.product_width_cm,
      p.product_length_cm * p.product_height_cm * p.product_width_cm as product_volume_cm3
      from 
      {{ref("stg_products")}} p left join {{ref("stg_product_category_name_translation")}} p1
      using(product_category_name)
),
sellers as(
      select * from
      {{ref("stg_sellers")}}
)
,
final as (
      select  
            {{dbt_utils.generate_surrogate_key(['oi.order_id','oi.order_item_id','oi.product_id','oi.seller_id'])}} as order_item_key,
            oi.order_id,
            oi.order_item_id,
            oi.product_id,
            oi.seller_id,
            oi.shipping_limit_date,
            oi.price,
            oi.freight_value,
            oi.price + oi.freight_value as item_total_value,
            coalesce(p.product_category_name,'unknown') as product_category_name,
            p.product_photos_qty,
            p.product_weight_g,
            p.product_length_cm,
            p.product_height_cm,
            p.product_width_cm,
            p.product_volume_cm3,
            s.seller_city,
            s.seller_state,
            s.seller_zip_code_prefix
      from 
            order_items oi join products p 
            using(product_id)
            join sellers s 
            using(seller_id)
)

select * from final