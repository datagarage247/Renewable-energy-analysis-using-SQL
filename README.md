# Renewable Energy Analysis using SQL Server

## Project Overview
This project analyzes renewable energy potential across Indian States and Union Territories using Sql Server.
The dataset includes Wind, Solar, and Small Hydro power values.  

## Key SQL Concepts Used
- Common Table Expressions (CTE)
- Window Functions
- Joins
- Aggregations and Percent Calculations
- NULL handling with NULLIF function

## Insights
- Ordered states based on overall ranking score of energy potential across Solar, Wind and Hydro.
- Calculated total renewable energy output per state.
- Computed percentage contribution of Wind, Solar, and Hydro energy.
- Ordered states by highest renewable energy potential.

## Files in this Repository
- RenewableEnergy.sql → SQL script with queries & analysis.
- Renewable power across States and UTs.csv → dataset.

## How to use
1. Import the CSV into SQL Server.
2. Run the SQL script.
3. Explore total outputs and energy source breakdown by state.

## SQL Query for CTE with percentages

WITH RenewableCTE AS (
    SELECT SlNo, StateUT,
           ([Wind Power] + [Solar Power] + [Small Hydro Power]) AS TotalOutput
    FROM RenewableEnergy
    WHERE StateUT != 'Total'
)
SELECT r.StateUT,
       CAST((r.[Wind Power] / NULLIF(c.TotalOutput,0) * 100) AS DECIMAL(10,2)) AS Wind_Percent,
       CAST((r.[Solar Power] / NULLIF(c.TotalOutput,0) * 100) AS DECIMAL(10,2)) AS Solar_Percent,
       CAST((r.[Small Hydro Power] / NULLIF(c.TotalOutput,0) * 100) AS DECIMAL(10,2)) AS Hydro_Percent,
       c.TotalOutput
FROM RenewableEnergy r
INNER JOIN RenewableCTE c
    ON r.SlNo = c.SlNo
ORDER BY c.TotalOutput DESC;
