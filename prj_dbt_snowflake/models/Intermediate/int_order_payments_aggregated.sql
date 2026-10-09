
with agg as (
      select 
            order_id,
            sum(payment_value) as total_payment_value, 
            count(distinct payment_type) as payment_method_count,
            max(payment_installments) as max_installments,
            sum(case
                  when payment_type = 'voucher' then payment_value 
                  else 0
            end) as voucher_value,
            voucher_value > 0  as used_voucher_flag
      from {{ref("stg_order_payments")}}
      group by order_id
),
ppp as (
      select
            order_id,
            payment_type as primary_payment_type
      from {{ref("stg_order_payments")}}
      qualify row_number() over(partition by order_id order by payment_value desc, payment_sequential) = 1
),
final as(

      select
            order_id,
            total_payment_value,
            payment_method_count,
            max_installments,
            primary_payment_type,
            voucher_value,
            used_voucher_flag
      from agg join ppp 
      using(order_id)
) 
select * from final



