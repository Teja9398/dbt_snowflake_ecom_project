select * 
from 
{{source('olist_source','ORDER_ITEMS')}}
where order_id is not null and 
product_id is not null and 
seller_id is not null and 
price > 0 and 
freight_value > 0 