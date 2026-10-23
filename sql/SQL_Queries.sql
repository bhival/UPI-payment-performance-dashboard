-- ============================================================
-- UPI PAYMENT PERFORMANCE DASHBOARD
-- SQL Analysis — All 10 Business Questions
-- Dataset: upi_transaction_dataset.csv (15,000 rows)
-- Period : 01 Jun 2026 – 07 Jun 2026
-- ============================================================


CREATE TABLE upi_transactions (
    Transaction_ID  VARCHAR(20),
    Timestamp       DATETIME,
    User_ID         VARCHAR(20),
    UPI_ID          VARCHAR(50),
    Bank_Name       VARCHAR(20),
    UPI_App         VARCHAR(20),
    Amount          DECIMAL(10,2),
    Status          VARCHAR(10),
    Decline_Type    VARCHAR(5),
    Failure_Reason  VARCHAR(50)
);

-- ============================================================
-- 🟢 PHASE A: OPERATIONAL BASELINE ANALYTICS
-- ============================================================


-- ------------------------------------------------------------
-- Q1: Transaction Success Rate (TSR) Benchmarking
-- Problem: Calculate the absolute distribution and percentage
--          split of successful vs failed transactions.
-- ------------------------------------------------------------

SELECT
    Status,
    COUNT(*)                                        AS transaction_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM upi_transactions
GROUP BY Status
ORDER BY transaction_count DESC;

-- ------------------------------------------------------------
-- Q2: User-Induced Failure Friction Analysis
-- Problem: Identify the volume of unique customers impacted
--          by 'Incorrect PIN' declines.
-- ------------------------------------------------------------

SELECT
    COUNT(DISTINCT User_ID)  AS unique_users_impacted,
    COUNT(*)                 AS total_incorrect_pin_txns
FROM upi_transactions
WHERE Failure_Reason = 'Incorrect PIN';

-- ------------------------------------------------------------
-- Q3: App-Specific Ticket Size Failure Correlation
-- Problem: Evaluate average transaction value of failed
--          payments across PSP applications.
-- ------------------------------------------------------------

SELECT
    UPI_App,
    ROUND(AVG(Amount), 2)   AS avg_failed_amount,
    COUNT(*)                AS failure_count
FROM upi_transactions
WHERE Status = 'Failure'
GROUP BY UPI_App
ORDER BY avg_failed_amount DESC;

-- ------------------------------------------------------------
-- Q4: Infrastructure Vulnerability Assessment
-- Problem: Rank banks by volume of 'Bank Server Timeout'
--          technical declines.
-- ------------------------------------------------------------

SELECT
    Bank_Name,
    COUNT(*)   AS timeout_count
FROM upi_transactions
WHERE Failure_Reason = 'Bank Server Timeout'
GROUP BY Bank_Name
ORDER BY timeout_count DESC;


-- ============================================================
-- 🟡 PHASE B: TEMPORAL & MULTI-DIMENSIONAL ANALYSIS
-- ============================================================


-- ------------------------------------------------------------
-- Q5: Diurnal Server Degradation Patterns
-- Problem: Map hourly transactional failures (0–23) to
--          pinpoint peak traffic windows causing timeout surges.
-- ------------------------------------------------------------

SELECT
    HOUR(Timestamp)    AS hour_of_day,
    COUNT(*)           AS timeout_count
FROM upi_transactions
WHERE Failure_Reason = 'Bank Server Timeout'
GROUP BY HOUR(Timestamp)
ORDER BY hour_of_day;


-- ------------------------------------------------------------
-- Q6: High-Value Financial Leakage Quantification
-- Problem: Calculate total failed GMV segmented by
--          Bank × PSP App combinations.
-- ------------------------------------------------------------

SELECT
    Bank_Name,
    UPI_App,
    ROUND(SUM(Amount), 2)        AS total_failed_gmv,
    COUNT(*)                     AS failure_count
FROM upi_transactions
WHERE Status = 'Failure'
GROUP BY Bank_Name, UPI_App
ORDER BY total_failed_gmv DESC;


-- ------------------------------------------------------------
-- Q7: Behavioral Breakdown of Business Declines
-- Problem: Contrast 'Incorrect PIN' vs 'Insufficient Balance'
--          failures across individual banking institutions.
-- ------------------------------------------------------------

SELECT
    Bank_Name,
    Failure_Reason,
    COUNT(*)   AS failure_count
FROM upi_transactions
WHERE Decline_Type = 'BD'
  AND Failure_Reason IN ('Incorrect PIN', 'Insufficient Balance')
GROUP BY Bank_Name, Failure_Reason
ORDER BY Bank_Name, failure_count DESC;


-- ============================================================
-- 🟠 PHASE C: ADVANCED CONDITIONAL & STRATEGIC INSIGHTS
-- ============================================================


-- ------------------------------------------------------------
-- Q8: Macro-Temporal Performance Contrast
-- Problem: Compare Bank Server Timeout frequency between
--          peak lunch hours (12PM–3PM) vs midnight off-peak
--          (12AM–3AM).
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN HOUR(Timestamp) BETWEEN 12 AND 14 THEN 'Peak Hours (12PM-3PM)'
        WHEN HOUR(Timestamp) BETWEEN 0  AND 2  THEN 'Off-Peak (12AM-3AM)'
    END                          AS time_window,
    COUNT(*)                     AS timeout_count
FROM upi_transactions
WHERE Failure_Reason = 'Bank Server Timeout'
  AND (
      HOUR(Timestamp) BETWEEN 12 AND 14
   OR HOUR(Timestamp) BETWEEN 0  AND 2
  )
GROUP BY time_window
ORDER BY timeout_count DESC;



-- ------------------------------------------------------------
-- Q9: Chronic Transaction Failure Identification
-- Problem: Identify individual customers who registered
--          more than 3 'Insufficient Balance' failures.
-- ------------------------------------------------------------

SELECT
    User_ID,
    COUNT(*)   AS insufficient_balance_count
FROM upi_transactions
WHERE Failure_Reason = 'Insufficient Balance'
GROUP BY User_ID
HAVING COUNT(*) > 3
ORDER BY insufficient_balance_count DESC;



-- ------------------------------------------------------------
-- Q10: Temporal Channel Degradation Tracking
-- Problem: Identify the specific day of the week on which
--          SBI × PhonePe suffered its lowest TSR.
-- ------------------------------------------------------------

SELECT
    DAYNAME(Timestamp)                                             AS day_of_week,
    DATE(Timestamp)                                                AS date,
    COUNT(*)                                                       AS total_txns,
    SUM(CASE WHEN Status = 'Success' THEN 1 ELSE 0 END)           AS successful_txns,
    ROUND(
        SUM(CASE WHEN Status = 'Success' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    )                                                              AS tsr_percentage
FROM upi_transactions
WHERE Bank_Name = 'SBI'
  AND UPI_App   = 'PhonePe'
GROUP BY DAYNAME(Timestamp), DATE(Timestamp)
ORDER BY tsr_percentage ASC
LIMIT 1;


-- ============================================================
-- END OF ANALYSIS
-- ============================================================
