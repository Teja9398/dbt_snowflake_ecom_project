select 
    order_id as order_id,
    customer_id as customer_id,
    order_status as order_status,
    order_purchase_timestamp as purchase_at,
    order_approved_at as approved_at,
    order_delivered_carrier_date as delivered_to_carrier_at,
    order_delivered_customer_date as delivered_at,
    order_estimated_delivery_date as estimated_delivery_at
from {{source('olist_source','ORDERS')}}
where order_id is not null 
and customer_id is not null