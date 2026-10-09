with order_info as (

      select
            d.order_id,
            d.order_status,
            d.order_purchase_timestamp,
            d.delivery_days,
            d.is_delivered_flag,
            d.is_late_flag,
            r.avg_review_score
      from {{ ref("int_order_delivery_metrics") }} d
      left join {{ ref("int_order_reviews_aggregated") }} r
            using(order_id)
      where d.order_status not in ('canceled', 'unavailable')

),

seller_items as (

      select
            i.seller_id,
            i.seller_city,
            i.seller_state,
            i.order_id,
            i.product_id,
            i.price,
            i.freight_value,
            o.order_purchase_timestamp
      from {{ ref("int_order_items_enriched") }} i
      inner join order_info o
            on i.order_id = o.order_id

),

item_level as (

      select
            seller_id,
            max(seller_city) as seller_city,
            max(seller_state) as seller_state,
            count(*) as total_items_sold,
            sum(price) as total_revenue,
            sum(freight_value) as total_freight,
            count(distinct product_id) as distinct_product_count,
            min(order_purchase_timestamp) as first_sale_date,
            max(order_purchase_timestamp) as last_sale_date
      from seller_items
      group by seller_id

),

seller_orders as (

      -- one row per seller + order, so each order is counted once per seller
      select distinct
            si.seller_id,
            si.order_id,
            o.delivery_days,
            o.is_delivered_flag,
            o.is_late_flag,
            o.avg_review_score
      from seller_items si
      inner join order_info o
            on si.order_id = o.order_id

),

order_level as (

      select
            seller_id,
            count(*) as total_orders,
            avg(avg_review_score) as avg_review_score,
            count_if(is_late_flag) / nullif(count_if(is_delivered_flag), 0) as late_delivery_rate,
            avg(case when is_delivered_flag then delivery_days end) as avg_delivery_days
      from seller_orders
      group by seller_id

),

final as (

      select
            il.seller_id,
            il.seller_city,
            il.seller_state,
            ol.total_orders,
            il.total_items_sold,
            il.total_revenue,
            il.total_freight,
            il.distinct_product_count,
            round(ol.avg_review_score, 2) as avg_review_score,
            round(ol.late_delivery_rate, 4) as late_delivery_rate,
            round(ol.avg_delivery_days, 2) as avg_delivery_days,
            il.first_sale_date,
            il.last_sale_date
      from item_level il
      left join order_level ol
            on il.seller_id = ol.seller_id

)

select * from final
