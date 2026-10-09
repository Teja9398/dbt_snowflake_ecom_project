with orders as (
      select 
            *
      from {{ref("int_orders_joined")}}
),

final as (

      select
            
            order_id,
            customer_unique_id,

            order_status,
            delivery_status_bucket,
            coalesce(order_status not in ('canceled', 'unavailable'), false) as is_valid_order_flag,

            order_purchase_timestamp,
            order_purchase_timestamp::date as purchase_date,

            approval_lag_hours,
            carrier_handover_days,
            delivery_days,
            estimated_delivery_days,
            delivery_delay_days,
            is_delivered_flag,
            is_late_flag,

            item_count,
            distinct_seller_count,
            total_items_price,
            total_freight_value,
            total_order_value,

            total_payment_value,
            max_installments,
            payment_method_count,
            primary_payment_type,

            avg_review_score,
            review_count,
            has_review_flag,

            payment_matches_order_flag

      from orders

)

select * from final