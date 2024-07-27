--create schema Nexa.Sat

--create table in the schema
CREATE TABLE "Nexa_Sat".nexa_sat (
    Customer_ID VARCHAR(50),
    gender VARCHAR(10),
    Partner VARCHAR(3),
    Dependents VARCHAR(3),
    Senior_Citizen INT,
    Call_Duration FLOAT,
    Data_Usage FLOAT,
    Plan_Type VARCHAR(20),
    Plan_Level VARCHAR(20),
    Monthly_Bill_Amount FLOAT,
    Tenure_Months INT,
    Multiple_Lines VARCHAR(3),
    Tech_Support VARCHAR(3),
    Churn INT);

--import data
	
--set search path for queries
SET search_path TO "Nexa_Sat";

--confirm current schema
SELECT current_schema();

--view data
SELECT * 
FROM nexa_sat;


--check for duplicates
SELECT 
    customer_id, gender, partner, dependents, 
    senior_citizen, call_duration, data_usage, 
    plan_type, plan_level, monthly_bill_amount, 
    tenure_months, multiple_lines, tech_support, 
    churn
FROM 
    nexa_sat
GROUP BY 
    customer_id, gender, partner, dependents, 
    senior_citizen, call_duration, data_usage, 
    plan_type, plan_level, monthly_bill_amount, 
    tenure_months, multiple_lines, tech_support, 
    churn
HAVING COUNT(*) > 1; -- This filters out rows that are not duplicates


--check for null values
SELECT *
FROM nexa_sat
WHERE customer_id IS NULL
OR gender IS NULL
OR partner IS NULL
OR dependents IS NULL
OR senior_citizen IS NULL
OR call_duration IS NULL
OR data_usage IS NULL
OR plan_type IS NULL
OR plan_level IS NULL 
OR monthly_bill_amount IS NULL
OR tenure_months IS NULL
OR multiple_lines IS NULL
OR tech_support IS NULL
OR churn IS NULL;


---EDA

--total users
SELECT COUNT(customer_id) AS total_users
FROM nexa_sat;

--total user by level
SELECT plan_level, COUNT(customer_id) AS total_users
FROM nexa_sat
GROUP BY 1;

--total revenue
SELECT ROUND(SUM(monthly_bill_amount::numeric),2) AS revenue
FROM nexa_sat;

--revenue by plan level 
SELECT plan_level, ROUND(SUM(monthly_bill_amount::numeric),2) AS revenue
FROM nexa_sat
GROUP BY 1
ORDER BY 2 DESC;

--Churn count by plan type and plan level
SELECT 
    plan_level, 
    plan_type, 
    COUNT(*) AS total_customers,
    SUM(churn) AS churn_count
FROM 
    nexa_sat
GROUP BY 1, 2
	ORDER BY 1;


--average tenure by level
SELECT plan_level, ROUND(AVG(tenure_months),2)
FROM nexa_sat
GROUP BY 1;


--Marketing segments
--Create table of only existing users
CREATE TABLE existing_customers AS
SELECT *
FROM nexa_sat
WHERE churn = 0;


--view new table
SELECT *
FROM existing_customers;


--calculate ARPU for existing users
SELECT ROUND(AVG(Monthly_Bill_Amount::INT), 2) AS ARPU
FROM existing_customers;


--calculate CLV and add column
ALTER TABLE existing_customers
ADD COLUMN clv FLOAT;

UPDATE existing_customers
SET clv = Monthly_Bill_Amount * tenure_months;


--view new clv column
SELECT customer_id, clv
FROM existing_customers;


--create clv score column
ALTER TABLE existing_customers
ADD COLUMN clv_score NUMERIC(10,2);


--assign weights and calculate clv score
--monthly bill = 40%, tenure = 30%, call_duration = 10%, data = 10%, premium = 10%
UPDATE existing_customers
SET clv_score = 
    (0.4 * Monthly_Bill_Amount) + 
    (0.3 * Tenure_Months) + 
    (0.1 * Call_Duration) + 
    (0.1 * Data_Usage) + 
    (0.1 * 
        CASE 
            WHEN plan_level = 'Premium' THEN 1 
            ELSE 0 
        END);

		
--view new clv_score column
SELECT customer_id, clv_score
FROM existing_customers;


--group into segments based on scores
ALTER TABLE existing_customers
ADD COLUMN clv_segment VARCHAR;

UPDATE existing_customers
SET clv_segment = 
    CASE 
        WHEN clv_score > (SELECT percentile_cont(0.85) WITHIN GROUP (ORDER BY clv_score) FROM existing_customers) THEN 'High Value'
        WHEN clv_score >= (SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY clv_score) FROM existing_customers) THEN 'Moderate Value'
        WHEN clv_score >= (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY clv_score) FROM existing_customers) THEN 'Low Value'
        ELSE 'Churn Risk'
    END;
	
	
-- view segments
SELECT customer_id, clv_score, clv_segment
FROM existing_customers;

--ANALYZE SEGMENTS

--customer count per segment
SELECT clv_segment, COUNT(*) AS segment_count
FROM existing_customers
GROUP BY clv_segment;

--avg bill and tenure per segment 
SELECT clv_segment, 
       ROUND(AVG(monthly_bill_amount::INT),2) AS avg_monthly_charges,
       ROUND(AVG(tenure_months::INT),2) AS avg_tenure
FROM existing_customers
GROUP BY clv_segment;

--tech support count and additional line count
SELECT clv_segment, 
       ROUND(AVG(CASE WHEN tech_support = 'Yes' THEN 1 ELSE 0 END),2) AS tech_support_pct,
      ROUND(AVG(CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END),2) AS additional_line_pct
FROM existing_customers
GROUP BY clv_segment;

--revenue per segment
SELECT 
    clv_segment, COUNT(customer_id),
    CAST(SUM(monthly_bill_amount * tenure_months) AS NUMERIC(10,2)) AS total_revenue
FROM 
    existing_customers
GROUP BY 
    clv_segment;



--CROSS SELLING AND UP SELLING
--cross selling: senior citizens who could use tech support
SELECT customer_id
FROM existing_customers
WHERE senior_citizen = 1-- senior citizens
AND dependents = 'No'-- no children or tech savvy helpers
AND tech_support = 'No'-- no tech support
AND (clv_segment = 'Churn Risk' OR clv_segment = 'Low Value');
-- Offering tech support to senior citizens without dependents leads to higher satisfaction, 
-- increased loyalty, reduced frustration, and enhanced brand image, ultimately resulting 
-- in lower churn rates and potential for additional revenue through cross-selling.


--up selling: premium discount for basic users with churn risk
SELECT customer_id
FROM existing_customers
WHERE clv_segment = 'Churn Risk'
AND plan_level = 'Basic';


--cross selling: multiple lines for dependents and partners on basic plan
SELECT customer_id
FROM existing_customers
WHERE multiple_lines = 'No'
AND (dependents = 'Yes' OR partner = 'Yes')
AND plan_level = 'Basic';


--up selling: basic to premium to longer lock in period and higher ARPU
SELECT plan_level, AVG(monthly_bill_amount), AVG(tenure_months)
FROM existing_customers
WHERE clv_segment = 'Moderate Value'
OR clv_segment = 'High Value'
GROUP BY 1;


--select higher paying customer ids for the upgrade offer
SELECT customer_id, monthly_bill_amount
FROM existing_customers
WHERE plan_level = 'Basic'
AND (clv_segment = 'High Value' OR clv_segment = 'Moderate Value')
AND monthly_bill_amount > 150;
-- Offering higher-paying customers cheaper plans with lock-in periods can 
-- increase customer retention and lifetime value by reducing churn.
-- This also creates custome loyalty to the brand, not just due to the lock in
-- but because customers appreciate discounts, especially when it appears like the brand is looking out for them.




--CREATE STORED PROCEDURES
--senior citizens who will be offered tech support
CREATE FUNCTION tech_support_snr_citizens() 
RETURNS TABLE (customer_id VARCHAR(50)) 
AS $$
BEGIN
    RETURN QUERY 
    SELECT ec.customer_id
    FROM existing_customers ec
    WHERE ec.senior_citizen = 1
        AND ec.dependents = 'No'
        AND ec.tech_support = 'No'
        AND (ec.clv_segment = 'Churn Risk' OR ec.clv_segment = 'Low Value');
END;
$$ LANGUAGE plpgsql;




--at risk customers who will be offered premium discount
CREATE FUNCTION churn_risk_discount() 
RETURNS TABLE (customer_id VARCHAR(50)) 
AS $$
BEGIN
    RETURN QUERY 
	SELECT ec.customer_id
	FROM existing_customers ec
	WHERE ec.clv_segment = 'Churn Risk'
	AND ec.plan_level = 'Basic';
END;
$$ LANGUAGE plpgsql;


--customers for multiple lines offer
CREATE FUNCTION multiple_lines_offer() 
RETURNS TABLE (customer_id VARCHAR(50)) 
AS $$
BEGIN
    RETURN QUERY 
	SELECT ec.customer_id
	FROM existing_customers ec
	WHERE ec.multiple_lines = 'No'
	AND (ec.dependents = 'Yes' OR ec.partner = 'Yes')
	AND ec.plan_level = 'Basic';
	END;
$$ LANGUAGE plpgsql;




--high usage customers who will be offered a premium upgrade
CREATE FUNCTION high_usage_basic() 
RETURNS TABLE (customer_id VARCHAR(50)) 
AS $$
BEGIN
    RETURN QUERY 
	SELECT ec.customer_id
	FROM existing_customers ec
	WHERE ec.plan_level = 'Basic'
	AND (ec.clv_segment = 'High Value' OR ec.clv_segment = 'Moderate Value')
	AND ec.monthly_bill_amount > 150;
END;
$$ LANGUAGE plpgsql;


-- USE PROCEDURES
SELECT * FROM tech_support_snr_citizens();

SELECT * FROM churn_risk_discount();

SELECT * FROM multiple_lines_offer();

SELECT * FROM high_usage_basic();


select *
from existing_customers