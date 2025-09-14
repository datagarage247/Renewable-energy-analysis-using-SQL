create table RenewableEnergy
(SlNo int primary key, StateUT varchar(100), [Wind Power] float, [Solar Power] float, [Small Hydro Power] float
);

BULK INSERT RenewableEnergy
FROM 'D:\BI\Data Analytics\Data.gov.in\Renewable power across States and UTs.csv'
WITH (
    
    FIRSTROW = 2,                 
    FIELDTERMINATOR = ',',       
    ROWTERMINATOR = '\n',        
    TABLOCK
);

select * from RenewableEnergy;

select StateUT, DENSE_RANK() over (order by [Wind Power] desc) as WindPotential,DENSE_RANK() over (order by [Solar Power] desc) as SolarPotential, DENSE_RANK() over (order by [Small Hydro Power] desc) as HydroPotential,
(DENSE_RANK() over (order by [Wind Power] desc) + DENSE_RANK() over (order by [Solar Power] desc) + DENSE_RANK() over (order by [Small Hydro Power] desc)) AS OverallRankScore
from RenewableEnergy
where StateUT != 'Total'
order by OverallRankScore;

with RenewableCTE
as
(
	select RenewableEnergy.SlNo,RenewableEnergy.StateUT, (RenewableEnergy.[Wind Power] + RenewableEnergy.[Solar Power]  + RenewableEnergy.[Small Hydro Power]) as TotalOutput from RenewableEnergy
	where RenewableEnergy.StateUT != 'Total'
	
)
select r.StateUT,  CAST((r.[Wind Power] * 100.0 / NULLIF(c.TotalOutput,0)) AS DECIMAL(10,2)) AS Wind_Percent,
    CAST((r.[Solar Power] * 100.0 / NULLIF(c.TotalOutput,0)) AS DECIMAL(10,2)) AS Solar_Percent,
    CAST((r.[Small Hydro Power] * 100.0 / NULLIF(c.TotalOutput,0)) AS DECIMAL(10,2)) AS Hydro_Percent, 
	c.TotalOutput
from RenewableEnergy r
inner join RenewableCTE c
on r.SlNo = c.SlNo
order by c.TotalOutput desc; 