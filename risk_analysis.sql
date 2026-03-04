-- =================================================================
-- 1. SCHEMA SETUP
-- Knowledge: Proper data typing and handling spaces in column names.
-- =================================================================

DROP TABLE IF EXISTS loan_data;

CREATE TABLE loan_data (
    "ID" NUMERIC,
    "Loan Amount" NUMERIC,
    "Funded Amount" NUMERIC,
    "Funded Amount Investor" NUMERIC,
    "Term" NUMERIC,
    "Batch Enrolled" TEXT,
    "Interest Rate" NUMERIC,
    "Grade" TEXT,
    "Sub Grade" TEXT,
    "Employment Duration" NUMERIC,
    "Home Ownership" TEXT,
    "Verification Status" TEXT,
    "Payment Plan" TEXT,
    "Loan Title" TEXT,
    "Debit to Income" NUMERIC,
    "Delinquency - two years" NUMERIC,
    "Inquires - six months" NUMERIC,
    "Open Account" NUMERIC,
    "Public Record" NUMERIC,
    "Revolving Balance" NUMERIC,
    "Revolving Utilities" NUMERIC,
    "Total Accounts" NUMERIC,
    "Initial List Status" TEXT,
    "Total Received Interest" NUMERIC,
    "Total Received Late Fee" NUMERIC,
    "Recoveries" NUMERIC,
    "Collection Recovery Fee" NUMERIC,
    "Collection 12 months Medical" NUMERIC,
    "Application Type" TEXT,
    "Last week Pay" NUMERIC,
    "Accounts Delinquent" NUMERIC,
    "Total Collection Amount" NUMERIC,
    "Total Current Balance" NUMERIC,
    "Total Revolving Credit Limit" NUMERIC,
    "Loan Status" NUMERIC,
    "Approval_Ratio" NUMERIC
);

-- =================================================================
-- 2. DATA INGESTION
-- Note: Use the pgAdmin Import tool to map your 'cleaned_train.csv' 
-- to these columns using the "Header: Yes" option.
-- =================================================================

-- =================================================================
-- 3. ANALYTICAL QUESTIONS & SOLUTIONS
-- =================================================================

-- Q1: BASELINE PORTFOLIO RISK
-- Question: What is the overall default rate of the portfolio?
SELECT 
    ROUND(AVG("Loan Status") * 100, 2) AS overall_default_rate_pct
FROM loan_data;

-- Q2: RISK BY GRADE
-- Question: Which loan grades show the highest probability of default?
SELECT 
    "Grade",
    COUNT(*) AS total_loans,
    ROUND(AVG("Loan Status") * 100, 2) AS default_rate_pct
FROM loan_data
GROUP BY "Grade"
ORDER BY default_rate_pct DESC;

-- Q3: ASSET STABILITY (HOME OWNERSHIP)
-- Question: Does owning a home reduce the probability of default?
SELECT 
    "Home Ownership",
    ROUND(AVG("Loan Status") * 100, 2) AS default_rate_pct
FROM loan_data
GROUP BY "Home Ownership"
ORDER BY default_rate_pct DESC;

-- Q4: DEBT TRAP ANALYSIS
-- Question: How do high-interest rates (>15%) correlate with defaults?
SELECT 
    CASE 
        WHEN "Interest Rate" < 10 THEN 'Low (<10%)'
        WHEN "Interest Rate" BETWEEN 10 AND 15 THEN 'Medium (10-15%)'
        ELSE 'High (>15%)'
    END AS interest_category,
    ROUND(AVG("Loan Status") * 100, 2) AS default_rate_pct
FROM loan_data
GROUP BY 1
ORDER BY default_rate_pct DESC;

-- Q5: EARLY WARNING SIGNALS (LATE FEES)
-- Question: What is the average late fee for defaulters vs. paid customers?
SELECT 
    "Loan Status",
    ROUND(AVG("Total Received Late Fee")::numeric, 2) AS avg_late_fee
FROM loan_data
GROUP BY "Loan Status";

-- Q6: PERFORMANCE RANKING (CTE)
-- Question: Which 5 batches have the highest default rates?
WITH BatchRisk AS (
    SELECT 
        "Batch Enrolled",
        COUNT(*) AS total_loans,
        AVG("Loan Status") * 100 AS default_rate
    FROM loan_data
    GROUP BY "Batch Enrolled"
    HAVING COUNT(*) > 100
)
SELECT * FROM BatchRisk
ORDER BY default_rate DESC
LIMIT 5;

-- Q7: DEBT CAPACITY (DTI STRESS TEST)
-- Question: Average DTI for 'Jumbo' loans (above average amount) per Grade.
SELECT 
    "Grade",
    ROUND(AVG("Debit to Income")::numeric, 2) AS avg_dti
FROM loan_data
WHERE "Loan Amount" > (SELECT AVG("Loan Amount") FROM loan_data)
GROUP BY "Grade"
ORDER BY "Grade";

-- Q8: CREDIT UTILIZATION RISK
-- Question: Impact of high credit usage (>75%) on defaults.
SELECT 
    CASE WHEN "Revolving Utilities" > 75 THEN 'High Util' ELSE 'Normal Util' END AS util_status,
    ROUND(AVG("Loan Status") * 100, 2) AS default_rate_pct
FROM loan_data
GROUP BY 1;

-- Q9: EMPLOYMENT STABILITY
-- Question: Default rates for new employees (<2 years) vs. stable ones.
SELECT 
    CASE WHEN "Employment Duration" < 2 THEN 'New Employee' ELSE 'Stable Employee' END AS emp_status,
    ROUND(AVG("Loan Status") * 100, 2) AS default_rate_pct
FROM loan_data
GROUP BY 1;

-- Q10: FUNDING GAP (APPROVAL RATIO)
-- Question: Does partial funding correlate with higher risk?
SELECT 
    CASE WHEN "Approval_Ratio" < 1.0 THEN 'Partial Funding' ELSE 'Full Funding' END AS funding_type,
    ROUND(AVG("Loan Status") * 100, 2) AS default_rate_pct
FROM loan_data
GROUP BY 1;

-- 4. VIEW FOR POWER BI INTEGRATION
-- Knowledge: Creating a persistent view for reporting tools.
CREATE OR REPLACE VIEW risk_dashboard_view AS
SELECT 
    "Grade",
    "Home Ownership",
    "Verification Status",
    AVG("Interest Rate") AS avg_rate,
    AVG("Loan Status") AS default_prob
FROM loan_data
GROUP BY 1, 2, 3;
