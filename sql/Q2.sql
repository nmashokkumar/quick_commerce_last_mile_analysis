-- Q2. What factors are associated with longer delivery times and delayed orders?

select
	hour(order_timestamp),
    count(*) as total_orders
from
	orders
group by 1
order by 2 desc;

SELECT
	d.traffic_level,
    
    ROUND(AVG(TIMESTAMPDIFF(
        SECOND, order_timestamp, dispatch_ready_timestamp
    )) / 60, 2) AS avg_order_to_ready_min,

    ROUND(AVG(TIMESTAMPDIFF(
        SECOND, order_timestamp, rider_assignment_timestamp
    )) / 60, 2) AS avg_order_to_assignment_min,

    ROUND(AVG(TIMESTAMPDIFF(
        SECOND, dispatch_ready_timestamp, rider_pickup_timestamp
    )) / 60, 2) AS avg_ready_to_pickup_min,

    ROUND(AVG(TIMESTAMPDIFF(
        SECOND, rider_pickup_timestamp, actual_delivery_timestamp
    )) / 60, 2) AS avg_last_mile_min,

    ROUND(AVG(TIMESTAMPDIFF(
        SECOND, order_timestamp, actual_delivery_timestamp
    )) / 60, 2) AS avg_total_delivery_min 

FROM deliveries d
join orders o 
	on d.order_id = o.order_id
GROUP BY 1;

select
	traffic_level,
	round(
    sum(case
		when actual_delivery_timestamp <= promised_delivery_timestamp then 1 
		else 0 
	end) / count(*)*100,2) as otd_rate
from
	deliveries
group by traffic_level;

select 
	hour(order_timestamp) as hr,
	case 
		when o.planned_distance_km < 2 then 'Normal'
        else 'Long'
	end as status,
    count(*) as total_orders
from
	orders o
join deliveries d
	on o.order_id = d.order_id
group by hr,status
order by hr asc;

SELECT
    traffic_level,
    AVG(
        TIMESTAMPDIFF(
            MINUTE,
            rider_pickup_timestamp,
            actual_delivery_timestamp
        )
    ) AS avg_last_mile_min
FROM deliveries
GROUP BY traffic_level;

SELECT
    traffic_level,
    COUNT(*) AS total_orders,

    SUM(CASE
        WHEN actual_delivery_timestamp IS NOT NULL
         AND promised_delivery_timestamp IS NOT NULL
        THEN 1 ELSE 0
    END) AS valid_timestamp_orders,

    SUM(CASE
        WHEN actual_delivery_timestamp <= promised_delivery_timestamp
        THEN 1 ELSE 0
    END) AS on_time_orders,

    SUM(CASE
        WHEN actual_delivery_timestamp > promised_delivery_timestamp
        THEN 1 ELSE 0
    END) AS late_orders,
    
    ROUND(
        AVG(
            CASE
                WHEN actual_delivery_timestamp > promised_delivery_timestamp
                THEN TIMESTAMPDIFF(
                    SECOND,
                    promised_delivery_timestamp,
                    actual_delivery_timestamp
                ) / 60.0
            END
        ),
        2
    ) AS avg_minutes_late,

    SUM(CASE
        WHEN actual_delivery_timestamp IS NULL
          OR promised_delivery_timestamp IS NULL
        THEN 1 ELSE 0
    END) AS missing_timestamp_orders

FROM deliveries
GROUP BY traffic_level
ORDER BY FIELD(traffic_level, 'Normal', 'High', 'Very High');










