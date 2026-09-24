-- Q3: Which locations or time periods have the weakest delivery performance?

select
	ds.zone,
	count(*) as total_orders,
    round(avg(timestampdiff(minute, o.order_timestamp, d.actual_delivery_timestamp)),2) as avg_del_time,
    round(sum(case
		when promised_delivery_timestamp < actual_delivery_timestamp then 1 else 0 end)/
        count(*)*100,2) as delay_rate
from
	orders o
join deliveries d
	on o.order_id = d.order_id
join darkstores ds
	on o.store_id = ds.store_id
group by ds.zone
order by 3 desc, 4 desc ;

with data as (
select 
	ds.zone,
	hour(o.order_timestamp) as hr,
    count(*) as total_orders,
    round(avg(timestampdiff(minute, o.order_timestamp, d.actual_delivery_timestamp)),2) as avg_del_time,
    round(sum(case
		when promised_delivery_timestamp < actual_delivery_timestamp then 1 else 0 end)/
        count(*)*100,2) as delay_rate
from
	orders o
join deliveries d
	on o.order_id = d.order_id
join darkstores ds
	on o.store_id = ds.store_id
group by ds.zone, hr
)
select 
	*
from 
	data
where hr in (21)
order by 4 desc,5 DESC ;


select
	ds.zone,
	count(*) as total_orders,
    round(avg(timestampdiff(minute, o.order_timestamp, d.actual_delivery_timestamp)),2) as avg_del_time,
    round(sum(case
		when promised_delivery_timestamp < actual_delivery_timestamp then 1 else 0 end)/
        count(*)*100,2) as delay_rate
from
	orders o
join deliveries d
	on o.order_id = d.order_id
join darkstores ds
	on o.store_id = ds.store_id
WHERE ds.zone in ('Jayanagar', 'Mahadevapura')
group by ds.zone
order by 2 asc;









