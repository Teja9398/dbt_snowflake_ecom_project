
with sellers as (

      select distinct
            seller_id,
            seller_city,
            seller_state,
            seller_zip_code_prefix
      from {{ ref("int_order_items_enriched") }}

),

final as (

      select
            seller_id,
            seller_city,
            seller_state,
            seller_zip_code_prefix
      from sellers

)

select * from final
