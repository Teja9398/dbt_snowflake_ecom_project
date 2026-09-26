select * 
from {{source('olist_source','ORDER_REVIEWS')}}
where review_id is not null