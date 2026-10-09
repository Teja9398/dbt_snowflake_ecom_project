select 
    *
from {{source('olist_source','ORDERS')}}
where order_id is not null 
and customer_id is not null

{% if is_incremental()%}
 and purchase_at > (select coalesce(max(purchase_at),timestamp('1990-01-01') from {{this}})
{% endif %}