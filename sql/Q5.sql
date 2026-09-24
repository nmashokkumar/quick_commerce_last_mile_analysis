-- Q5: Which operational interventions are likely to have the greatest impact on on-time delivery?

-- Late order count

select
	count(*) as late_orders
from
	deliveries d
where d.actual_delivery_timestamp > d.promised_delivery_timestamp;

-- delay rate
select 
	round(sum((case
		when d.actual_delivery_timestamp > d.promised_delivery_timestamp then 1 else 0
	end))/count(*)*100,2) as delay_rate
from 
	deliveries d;

-- Affected by distance bucket

select
	case 
		when o.planned_distance_km < 2 then 'Normal'
        else 'Long'
	end as dis_status,
	count(*) as late_orders
from
	deliveries d
join orders o
	on d.order_id = o.order_id
where d.actual_delivery_timestamp > d.promised_delivery_timestamp
group by dis_status;

-- Affected by taffic
select
	d.traffic_level,
	count(*) as late_orders
from
	deliveries d
where d.actual_delivery_timestamp > d.promised_delivery_timestamp
Group by 1;

-- Affected by both high traffic and long distance

with delayed_orders as (
select 
	case 
		when o.planned_distance_km < 2 then 'Normal'
        else 'Long'
	end as dis_status,
    d.traffic_level,
	count(*) as delayed_orders,
from
	deliveries d
join orders o
	on d.order_id = o.order_id
where d.actual_delivery_timestamp > d.promised_delivery_timestamp
group by dis_status, d.traffic_level
)

select 
	dis_status,
	traffic_level,
	delayed_orders,
    total_delayed_orders,
    round(delayed_orders/total_delayed_orders*100,2) as delayed_pct
from
	delayed_orders;
    

SELECT
    CASE
        WHEN o.planned_distance_km < 2 THEN 'Normal'
        ELSE 'Long'
    END AS dis_status,
    d.traffic_level,

    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN d.actual_delivery_timestamp > d.promised_delivery_timestamp
            THEN 1
            ELSE 0
        END
    ) AS delayed_orders,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN d.actual_delivery_timestamp > d.promised_delivery_timestamp
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_delivery_rate

FROM deliveries d
JOIN orders o
    ON d.order_id = o.order_id

WHERE
    d.actual_delivery_timestamp IS NOT NULL
    AND d.promised_delivery_timestamp IS NOT NULL

GROUP BY
    dis_status,
    d.traffic_level

ORDER BY
    dis_status,
    FIELD(d.traffic_level, 'Normal', 'High', 'Very High');
    
    
-- Does rider vechicle affect the delivery duration 

select 
	
	round(avg(timestampdiff(second, o.order_timestamp, d.actual_delivery_timestamp)/60.0),2) as total_duration,
    round(avg(timestampdiff(second, d.rider_pickup_timestamp, d.actual_delivery_timestamp)/60.0),2) as last_mile
from 
	orders o
join deliveries d 	
	on o.order_id = d.order_id
join riders r
	on d.rider_id = r.rider_id
order by 2 desc;

-- Rider experience

select 
	case 
		when r.rider_experience_months <= 8 then '0-8'
        when r.rider_experience_months between 7 and 16 then '7-16'
        else '17-24'
	end as bucket,
	round(avg(timestampdiff(second, d.rider_pickup_timestamp, d.actual_delivery_timestamp)/60.0),2) as lastMile

from deliveries d

join riders r
	on r.rider_id = d.rider_id
GROUP BY 1;


-- python analysis ready dataset
create view eta_analysis_dataset as 
select 
	o.order_id,
    ds.store_id,
    ds.zone,
    o.order_timestamp,
    o.planned_distance_km,
    o.total_items,
    o.fresh_item_count,
    ds.picking_capacity,
    ds.rider_capacity,
    d.traffic_level,
    d.weather_condition,
    round(avg(timestampdiff(second, o.order_timestamp, d.actual_delivery_timestamp)/60.0),2) as actual_delivery_time,
    round(avg(timestampdiff(second, o.order_timestamp, d.promised_delivery_timestamp)/60.0),2) as promised_del_time
from 
	orders o
join deliveries d
	on o.order_id = d.order_id
join darkstores ds
	on o.store_id = ds.store_id
join riders r
	on d.rider_id = r.rider_id
group by 
	o.order_id,
    ds.store_id,
    ds.zone,
    o.order_timestamp,
    o.planned_distance_km,
    o.total_items,
    o.fresh_item_count,
    ds.picking_capacity,
    ds.rider_capacity,
    d.traffic_level,
    d.weather_condition
order by o.order_id;