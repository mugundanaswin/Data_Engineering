-- Test that the car registration and deregistration dates are logical with respect to each other
select *
from {{ ref('slv_cars') }}
where deregistration_date is not null 
  and registration_date > deregistration_date