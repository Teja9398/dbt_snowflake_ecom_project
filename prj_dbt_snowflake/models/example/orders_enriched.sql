with cust_orders as (
    select 
      o.order_id,
      c.customer_id,
      c.customer_unique_id,
      o.order_status,
      o.order_purchase_timestamp as purchase_at,
      o.order_approved_at as approved_at,
      o.order_delivered_customer_date as delivered_at,
      o.order_estimated_delivery_date as estimated_delivery_date,
      datediff(day,date(purchase_at),date(delivered_at)) as delivered_days,
      case
      when date(delivered_at) > estimated_delivery_date
            then datediff(days,estimated_delivery_date,date(delivered_at))
            else 0
      end as delivery_delay_days,
      case 
            when date(delivered_at) > estimated_delivery_date then true
            else false
      end as is_late


      from {{ ref("stg_customers") }} as c 
      inner join {{ ref("stg_orders") }} as o
      using (customer_id)
),
payments as (
      select 
            order_id,
            sum(payment_value) as total_amount,
            count(*) as payment_count
      from {{ref("stg_order_payments")}}
      group by order_id
)

select * from payments
-- select * from {{ref("stg_orders")}}