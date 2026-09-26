select * 
from {{source('olist_source','GEOLOCATION')}}
where geolocation_zip_code_prefix is not null