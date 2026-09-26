{{config(
      materialized= 'view',
      schema= 'staging'
)}}

select * from {{source('olist_source','CUSTOMERS')}}
where customer_id is not null 
and customer_unique_id is not null