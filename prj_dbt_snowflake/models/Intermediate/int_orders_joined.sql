with cte as (
      select 
      o.order_id,
      o.customer_id,
      o.order_status,
      o.order_purchase_timestamp,
      c.customer_unique_id,
      c.customer_city,
      c.customer_state,
      c.customer_zip_code_prefix,
      d.approval_lag_hours,
      d.carrier_handover_days, 
      d.delivery_days, 
      d.estimated_delivery_days, 
      d.delivery_delay_days, 
      d.is_delivered_flag, 
      d.is_late_flag, 
      d.delivery_status_bucket,
      i.item_count, 
      i.distinct_seller_count, i.total_items_price, 
      i.total_freight_value, 
      i.total_order_value,
      p.total_payment_value, 
      p.primary_payment_type, 
      p.max_installments, 
      p.payment_method_count,
      r.avg_review_score, 
      r.review_count, 
      coalesce(r.review_count > 0,false) as has_review_flag,
      abs(p.total_payment_value - i.total_order_value) <= 1 as payment_matches_order_flag
from {{ref("stg_orders")}} o left join {{ref("stg_customers")}} c
using(customer_id)
left join {{ref("int_order_delivery_metrics")}} d 
using(order_id)
left join {{ref("int_order_items_aggregated")}} i
using(order_id)
left join {{ref("int_order_payments_aggregated")}} p
using(order_id)
left join {{ref("int_order_reviews_aggregated")}} r
using(order_id)
)
select count(*) from cte