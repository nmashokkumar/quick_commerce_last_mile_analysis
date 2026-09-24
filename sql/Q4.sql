-- Q4: Which delivery delays are operationally controllable?

select 
	round(
		avg(timestampdiff(second, o.order_timestamp, o.dispatch_ready_timestamp))/60.0,2) as store_ready,
	round(
		avg(timestampdiff(second, o.dispatch_ready_timestamp, d.rider_assignment_timestamp))/60.0,2) as sr_rider_assign,
	round(
		avg(timestampdiff(second, d.rider_assignment_timestamp, d.rider_pickup_timestamp))/60.0,2) as rider_ass_pickup,
	round(
		avg(timestampdiff(second, d.rider_pickup_timestamp, d.actual_delivery_timestamp))/60.0,2) as pickup_to_act_del
from 
	orders o
join deliveries d 
	on o.order_id = d.order_id;
    

select 
	case 
		when o.planned_distance_km < 2 then 'Normal'
        else 'Long'
	end as dis_status,
    d.traffic_level,
    round(
		avg(timestampdiff(second, d.rider_pickup_timestamp, d.actual_delivery_timestamp))/60.0,2) as pickup_to_act_del
from
	deliveries d
join orders o
	on d.order_id = o.order_id
group by dis_status, d.traffic_level;

select 
	round(
		avg(timestampdiff(second, d.promised_delivery_timestamp, d.actual_delivery_timestamp))/60.0,2) as promised_to_act_del
from
	deliveries d
where d.actual_delivery_timestamp > d.promised_delivery_timestamp;








    

    
    
    
    
    
    
    
    
    