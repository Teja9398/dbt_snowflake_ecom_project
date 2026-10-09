with agg as (
      select 
            order_id,
            avg(review_score) as avg_review_score,
            count(*) as review_count,
            max(review_creation_date) as latest_review_date,
           count(review_comment_message) > 0 as has_comment_flag
      from {{ref("stg_order_reviews")}}
      group by order_id
),
ls as(
      select
            order_id,
            review_score as latest_review_score
      from {{ref('stg_order_reviews')}}
      qualify row_number() over(partition by order_id order by review_creation_date desc,review_answer_timestamp desc) = 1
),
final as(
      select
            order_id,
            review_count,
            avg_review_score,
            latest_review_score,
            latest_review_date,
            has_comment_flag
      from agg join ls
      using(order_id)
)
select * from final