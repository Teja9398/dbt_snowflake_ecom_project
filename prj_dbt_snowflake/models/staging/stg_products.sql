select * 
from {{source('olist_source','PRODUCTS')}}
where product_id is not null