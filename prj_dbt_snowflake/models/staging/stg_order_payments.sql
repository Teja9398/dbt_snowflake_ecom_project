select *
from {{source('olist_source','ORDER_PAYMENTS')}}
qualify row_number() over (partition by order_id) >1

