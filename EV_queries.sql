--                                                     IEA Global EV Data 2024


-- 1) Global EV Sales and Stock Over Time

SELECT
    year,
    powertrain,
    SUM(CASE WHEN parameter = 'EV sales' AND unit = 'Vehicles' THEN value ELSE 0 END) AS total_ev_sales,
    SUM(CASE WHEN parameter = 'EV stock' AND unit = 'Vehicles' THEN value ELSE 0 END) AS total_ev_stock
FROM
    ev_data
WHERE
    region = 'World' AND mode = 'Cars'
GROUP BY
    year, powertrain
ORDER BY
    year, powertrain;

-- 2) Top 10 Regions by EV Sales Share (Latest Year)

SELECT
    region,
    value AS ev_sales_share
FROM
    ev_data
WHERE
    year = (SELECT MAX(year) FROM ev_data WHERE parameter = 'EV sales share' AND unit = 'percent' AND mode = 'Cars' AND category = 'Historical')
    AND parameter = 'EV sales share'
    AND unit = 'percent'
    AND mode = 'Cars'
    AND region != 'World'
ORDER BY
    ev_sales_share DESC
LIMIT 10;

-- 3) Regional EV Stock (Latest Year)

SELECT
    region,
    SUM(value) AS total_ev_stock_vehicles
FROM
    ev_data
WHERE
    year = (SELECT MAX(year) FROM ev_data WHERE parameter = 'EV stock' AND unit = 'Vehicles' AND mode = 'Cars' AND category = 'Historical')
    AND parameter = 'EV stock'
    AND unit = 'Vehicles'
    AND mode = 'Cars'
    AND region != 'World'
GROUP BY
    region
ORDER BY
    total_ev_stock_vehicles DESC;

-- 4) Powertrain Breakdown of EV Sales (Latest Year)

SELECT
    powertrain,
    SUM(value) AS total_sales
FROM
    ev_data
WHERE
    year = (SELECT MAX(year) FROM ev_data WHERE parameter = 'EV sales' AND unit = 'Vehicles' AND mode = 'Cars' AND category = 'Historical'  AND powertrain IN ('BEV', 'PHEV'))
    AND parameter = 'EV sales'
    AND unit = 'Vehicles'
    AND mode = 'Cars'
    AND powertrain IN ('BEV', 'PHEV')
    AND region = 'World'
GROUP BY
    powertrain
ORDER BY
    total_sales DESC;

-- 5)  Growth of EV Charging Points (Global)

SELECT
    year,
    powertrain, -- This differentiates between fast and slow charging points
    SUM(value) AS total_charging_points
FROM
    ev_data
WHERE
    region = 'World'
    AND parameter = 'EV charging points'
    AND unit = 'charging points'
    AND powertrain IN ('Publicly available fast', 'Publicly available slow')
GROUP BY
    year, powertrain
ORDER BY
    year, powertrain;

-- 6) Electricity Demand by EVs (Global)

SELECT
    year,
    SUM(value) AS total_electricity_demand_gwh
FROM
    ev_data
WHERE
    region = 'World'
    AND parameter = 'Electricity demand'
    AND unit = 'GWh'
GROUP BY
    year
ORDER BY
    year;

-- 7) Oil Displacement by EVs (Global)

SELECT
    year,
    SUM(CASE WHEN unit = 'Milion barrels per day' THEN value ELSE 0 END) AS oil_displacement_mbd,
    SUM(CASE WHEN unit = 'Oil displacement, million lge' THEN value ELSE 0 END) AS oil_displacement_million_lge
FROM
    ev_data
WHERE
    region = 'World'
    AND (parameter = 'Oil displacement Mbd' OR parameter = 'Oil displacement, million lge')
GROUP BY
    year
ORDER BY
    year;

-- 8) EV Stock Growth Rate by Region (Year-over-Year Data for Calculation)

SELECT
    region,
    year,
    SUM(value) AS total_ev_stock
FROM
    ev_data
WHERE
    parameter = 'EV stock'
    AND unit = 'Vehicles'
    AND mode = 'Cars'
    AND region != 'World'
GROUP BY
    region, year
ORDER BY
    region, year;

-- 9) Average EV Sales Share per Region Over Time

SELECT
    region,
    year,
    AVG(value) AS average_ev_sales_share
FROM
    ev_data
WHERE
    parameter = 'EV sales share'
    AND unit = 'percent'
    AND mode = 'Cars'
    AND region != 'World'
GROUP BY
    region, year
ORDER BY
    region, year;

-- 10) Proportion of Fast vs. Slow Charging Points (Global and Regional)

SELECT
    year,
    region,
    SUM(CASE WHEN powertrain = 'Publicly available fast' THEN value ELSE 0 END) AS fast_charging_points,
    SUM(CASE WHEN powertrain = 'Publicly available slow' THEN value ELSE 0 END) AS slow_charging_points
FROM
    ev_data
WHERE
    parameter = 'EV charging points'
    AND unit = 'charging points'
GROUP BY
    year, region
ORDER BY
    year, region;

-- 11) Total Values Based On Categories & Parameters

SELECT
    parameter,category,
    SUM(value) AS total_value
FROM
    ev_data
GROUP BY
    parameter,category
ORDER BY
    parameter,category;

-- 12) Count Of Mode In Diffrent Units

SELECT
    mode,
    unit,
    COUNT(mode) AS count_of_mode_unit_combinations 
FROM
    ev_data
GROUP BY
    mode,
    unit
ORDER BY
    mode,
    unit;

--                                                              END

