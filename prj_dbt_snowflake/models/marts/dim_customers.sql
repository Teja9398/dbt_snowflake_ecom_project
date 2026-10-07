 
with customer_orders as (
 
      select
            customer_unique_id,
            customer_city,
            customer_state,
            customer_zip_code_prefix,
            order_id,
            order_purchase_timestamp,
            min(order_purchase_timestamp) over (
                  partition by customer_unique_id
            ) as first_order_date
      from {{ ref("int_orders_joined") }}
 
),
 
final as (
 
      select
            customer_unique_id,
            customer_city,
            customer_state,
            customer_zip_code_prefix,
            first_order_date
      from customer_orders
      qualify row_number() over (
            partition by customer_unique_id
            order by order_purchase_timestamp desc, order_id desc
      ) = 1
 
)
select * from final