select 
      order_id,
      order_status,
      order_purchase_timestamp,
      datediff('hour',order_purchase_timestamp,order_approved_at) as approval_lag_hours,
      datediff('day',order_purchase_timestamp,order_delivered_carrier_date) as carrier_handover_days,
      datediff('day',order_purchase_timestamp,order_delivered_customer_date) as delivery_days,
      datediff('day',order_purchase_timestamp,order_estimated_delivery_date) as estimated_delivery_days,
      datediff('day',order_estimated_delivery_date,order_delivered_customer_date) as delivery_delay_days,
      (order_status = 'delivered' and order_delivered_customer_date is not null) as is_delivered_flag,
      delivery_delay_days > 0 as is_late_flag,
      case
            when order_status = 'canceled' or order_status = 'unavailable' then 'canceled'
            when order_status = 'delivered' then 
                  case
                        when order_delivered_customer_date is null then 'delivered_missing_date'
                        when delivery_delay_days > 0 then 'late'
                        else 'on_time'
                  end
            else 'in_progress'
      end as delivery_status_bucket 

from {{ref("stg_orders")}}
      
