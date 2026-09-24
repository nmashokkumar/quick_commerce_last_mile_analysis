-- 1: Where are the major time losses occurring across the order-to-delivery journey?
CREATE OR REPLACE VIEW vw_all_date AS
    SELECT 
        o.order_id,
        o.order_timestamp,
        o.dispatch_ready_timestamp,
        d.rider_assignment_timestamp,
        d.rider_pickup_timestamp,
        d.actual_delivery_timestamp,
        d.promised_delivery_timestamp
    FROM
        orders o
            JOIN
        deliveries d ON o.order_id = d.order_id;


SELECT
	case 
		when actual_delivery_timestamp > promised_delivery_timestamp then 'delayed'
        else 'on-time'
	end as status,
    
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
	min(planned_distance_km),
    max(planned_distance_km)
from 
	orders;
    

SELECT
	case 
		when planned_distance_km < 1.5 then 'Normal'
        else 'Long'
	end as status,
    
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
















