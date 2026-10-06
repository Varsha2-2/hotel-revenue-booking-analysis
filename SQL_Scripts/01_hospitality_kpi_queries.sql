-- =================================================================================
-- HOTEL BOOKING PERFORMANCE & REVENUE OPTIMIZATION: EXECUTIVE KPI ANALYTICS SCRIPT
-- Objective: Evaluate transactional lead times, pricing matrices, and churn risk patterns
-- Data Author: Varsha
-- =================================================================================

USE hospitality;


-- 📊 KPI 1: Financial Health Matrix (Total Revenue Realized)
-- Business Case: Quantify the total concrete top-line revenue collected post-cancellations.
SELECT 
    CONCAT(FORMAT(SUM(Revenue_Realized) / 1000000, 0), 'M') AS Total_Revenue 
FROM fact_bookings;


-- 🏨 KPI 2: Space Utilization Efficiency (Strategic Occupancy Rate)
-- Business Case: Measure room occupancy density against full operating capacity.
SELECT 
    CONCAT(ROUND((SUM(Successful_Bookings) / SUM(Capacity)) * 100, 0), '%') AS OccupancyRate 
FROM fact_aggregated_bookings;


-- 📉 KPI 3: Revenue Leakage Tracking (Gross Cancellation Rate)
-- Business Case: Calculate booking churn frequency to evaluate policy constraints.
SELECT 
    CONCAT(ROUND(SUM(CASE WHEN Booking_Status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(Booking_Id) * 100, 0), '%') AS Cancellation_Rate 
FROM fact_bookings;


-- 🗓️ KPI 4: Operational Footprint Scale (Gross Booking Volume)
-- Business Case: Isolate the total scale of demand generation across all booking platforms.
SELECT 
    CONCAT(ROUND(COUNT(Booking_Id) / 1000, 0), 'K') AS Total_Bookings 
FROM fact_bookings;


-- ⚡ KPI 5: Capacity Absorption Index (Total Successfully Utilized Rooms)
-- Business Case: Calculate the actual volume of room assets actively retaining guest stays.
SELECT 
    CONCAT(ROUND(SUM(Successful_Bookings) / 1000, 0), 'K') AS Utilize_Capacity 
FROM fact_aggregated_bookings;


-- 🗺️ KPI 6: Regional Property Revenue Optimization Map
-- Business Case: Identify high-performing municipal property hubs to scale operational budgets.
SELECT 
    h.City,
    h.Property_Name,
    CONCAT(FORMAT(SUM(f.Revenue_Realized) / 1000000, 0), 'M') AS Revenue 
FROM dim_hotels AS h 
JOIN fact_bookings AS f ON h.Property_Id = f.Property_Id 
GROUP BY h.City, h.Property_Name;


-- 🛏️ KPI 7: Room Class Revenue Tier Performance Analysis
-- Business Case: Evaluate luxury vs budget structural product tiers to steer inventory focus.
SELECT 
    r.Room_Class AS Class, 
    CONCAT(FORMAT(SUM(f.Revenue_Realized) / 1000000, 0), 'M') AS Revenue
FROM dim_rooms AS r 
JOIN fact_bookings AS f ON r.Room_Id = f.Room_Category 
GROUP BY r.Room_Class;


-- 📋 KPI 8: Post-Reservation Guest Lifecycle Breakdown
-- Business Case: Uncover operations metrics behind check-outs, flakes, and cancellations.
SELECT 
    Booking_Status, 
    COUNT(Booking_Id) AS Total_Bookings 
FROM fact_bookings 
GROUP BY Booking_Status;


-- 🏷️ KPI 9: Segmented Core Hospitality Category Performance Mix
-- Business Case: Correlate revenue variations between business travelers and luxury stays.
SELECT 
    h.Category,
    CONCAT(ROUND(SUM(f.Revenue_Generated) / 1000000, 0), 'M') AS Revenue_In_M
FROM dim_hotels AS h
JOIN fact_bookings AS f ON h.Property_Id = f.Property_Id  
GROUP BY h.Category;
