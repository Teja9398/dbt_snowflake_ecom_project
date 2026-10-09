

with valid_orders as (

      select *
      from {{ ref("int_orders_joined") }}
      where order_status not in ('canceled', 'unavailable')

),

agg as (

      select
            customer_unique_id,
            min(order_purchase_timestamp) as first_order_date,
            max(order_purchase_timestamp) as last_order_date,
            count(distinct order_id) as total_orders,
            count_if(is_delivered_flag) as delivered_orders,
            sum(total_order_value) as total_spend,
            round(sum(total_order_value) / count(distinct order_id), 2) as avg_order_value,
            avg(avg_review_score) as avg_review_score,
            datediff('day', min(order_purchase_timestamp), max(order_purchase_timestamp)) as days_between_first_last_order,
            count(distinct order_id) > 1 as is_repeat_customer_flag
      from valid_orders
      group by customer_unique_id

),

latest_location as (

      select
            customer_unique_id,
            customer_city as latest_customer_city,
            customer_state as latest_customer_state
      from valid_orders
      qualify row_number() over (
            partition by customer_unique_id
            order by order_purchase_timestamp desc, order_id desc
      ) = 1

),

final as (

      select
            a.customer_unique_id,
            a.first_order_date,
            a.last_order_date,
            a.total_orders,
            a.delivered_orders,
            a.total_spend,
            a.avg_order_value,
            a.avg_review_score,
            a.days_between_first_last_order,
            a.is_repeat_customer_flag,
            l.latest_customer_city,
            l.latest_customer_state
      from agg a
      left join latest_location l
      using(customer_unique_id)
)

select * from final