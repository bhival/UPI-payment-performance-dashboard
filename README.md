# 🏦 UPI Payment Performance Dashboard

> **An end-to-end Data Analytics project** — from synthetic dataset generation to SQL-driven insights to an executive-grade Tableau dashboard — built to monitor, diagnose, and act on UPI transaction failures in real time.

---

## 📌 Project Overview

India's Unified Payments Interface (UPI) processes billions of transactions monthly across multiple PSP apps and banking nodes. Even a fractional failure rate translates into massive financial leakage and customer trust erosion.

This project simulates a **real-world fintech data analyst workflow**:

1. **Generate** a realistic 7-day UPI transaction dataset using Python
2. **Analyze** operational and strategic questions using SQL
3. **Visualize** findings through an interactive Tableau executive dashboard

---

## 🗂️ Repository Structure

```
upi-payment-performance-dashboard/
│
├── 📁 dataset/
│   ├── upi_transaction_dataset.csv        # Final generated dataset (15,000 rows)
│   └── generate_dataset.py                # Python script used to generate the data
│
├── 📁 sql/
│   └── SQL_Queries.sql                    # All 10 queries in one file
│
├── 📁 tableau/
│   └── upi_dashboard.twbx                 # Packaged Tableau workbook (upload here)
│
├── 📁 docs/
│   ├── problem_statement.md               # Full project brief
│   ├── sql_answers.md                     # Query outputs & business interpretations
│   └── dashboard_guide.md                 # Step-by-step Tableau build guide
│
├── 📁 assets/
│   └── dashboard_preview.png              # Screenshot of final dashboard
│
└── README.md
```

---

## 📊 Dataset Snapshot

| Attribute | Value |
|---|---|
| **Source** | Synthetically generated via Python (`Faker` + `random`) |
| **Time Period** | 01 June 2026 – 07 June 2026 (7 days) |
| **Total Transactions** | 15,000 |
| **Banks** | SBI, HDFC, ICICI, AXIS |
| **PSP Apps** | GPay, PhonePe, Paytm |
| **Amount Range** | ₹10 – ₹4,999 |
| **Total GMV** | ₹1,16,52,474 |
| **GMV at Risk (Failures)** | ₹22,46,826 |

### Schema

| Column | Type | Description |
|---|---|---|
| `Transaction_ID` | String | Unique transaction identifier (TXN######) |
| `Timestamp` | DateTime | Date and time of transaction (DD/MM/YY HH:MM) |
| `User_ID` | String | Unique user identifier |
| `UPI_ID` | String | User's VPA (e.g., usr_001@okhdfc) |
| `Bank_Name` | String | Linked bank: SBI / HDFC / ICICI / AXIS |
| `UPI_App` | String | PSP used: GPay / PhonePe / Paytm |
| `Amount` | Float | Transaction amount in INR |
| `Status` | String | Success / Failure |
| `Decline_Type` | String | TD (Technical) / BD (Business) / NULL |
| `Failure_Reason` | String | Bank Server Timeout / Incorrect PIN / Insufficient Balance / None |

---

## 🔍 SQL Analysis — 10 Business Questions

The SQL analysis is structured across three phases of increasing complexity:

### 🟢 Phase A — Operational Baseline Analytics

| # | Question | Business Goal |
|---|---|---|
| Q1 | Transaction Success Rate (TSR) Benchmarking | Establish platform baseline performance |
| Q2 | User-Induced Failure Friction Analysis | Quantify customers hit by PIN errors |
| Q3 | App-Specific Ticket Size Failure Correlation | Find which app has highest-value failures |
| Q4 | Infrastructure Vulnerability Assessment | Rank banks by Bank Server Timeout volume |

### 🟡 Phase B — Temporal & Multi-Dimensional Analysis

| # | Question | Business Goal |
|---|---|---|
| Q5 | Diurnal Server Degradation Patterns | Map hourly failure surges (0–23h) |
| Q6 | High-Value Financial Leakage Quantification | Find worst Bank × App GMV leakage combo |
| Q7 | Behavioral Breakdown of Business Declines | PIN vs Balance errors by bank |

### 🟠 Phase C — Advanced Conditional & Strategic Insights

| # | Question | Business Goal |
|---|---|---|
| Q8 | Macro-Temporal Performance Contrast | Peak hours vs off-peak failure comparison |
| Q9 | Chronic Transaction Failure Identification | Flag users with >3 repeated balance failures |
| Q10 | Temporal Channel Degradation Tracking | Worst day for SBI × PhonePe channel |

> Full queries and output interpretations: [`docs/sql_answers.md`](docs/sql_answers.md)

---

## 📈 Tableau Dashboard

**Theme:** Gray (`#878787`) · Orange (`#FF6B00`) · Green (`#2ECC71`) · White — inspired by UPI brand identity

### Dashboard Zones

| Zone | Chart | Type |
|---|---|---|
| **KPI Banner** | Total Volume · TSR · GMV at Risk | Text / Scorecard |
| **Infrastructure Health** | Chart A: Clock of Failures | Continuous Line Chart |
| **Infrastructure Health** | Chart B: Error Root-Cause | Donut Chart |
| **Channel Risk** | Chart C: Channel Friction Matrix | Heatmap / Highlight Table |
| **Behavioral Analytics** | Chart D: Ticket-Size Distribution | Horizontal Bar Chart |

### Key Interactive Features
- **Day Parameter** — Switch between Day 1–7 or All Days to track daily KPIs dynamically
- **Global Filters** — Filter by Bank and UPI App across all charts simultaneously
- **Heatmap → Line Chart Action** — Click any Bank × App cell in Chart C to isolate that channel's hourly failure wave in Chart A

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **Python** (`Faker`, `random`, `csv`) | Synthetic dataset generation |
| **SQL** (MySQL / PostgreSQL compatible) | Business questions & analytical queries |
| **Tableau Public / Desktop** | Interactive executive dashboard |
| **GitHub** | Version control & project showcase |

---

## 🚀 How to Run This Project

### 1. Regenerate the Dataset
```bash
cd dataset
python generate_dataset.py
# Output: upi_transaction_dataset.csv (15,000 rows)
```

### 2. Run SQL Queries
```sql
-- Import the CSV into your SQL environment first
-- Then run queries from the sql/ folder

-- Option A: MySQL
-- Option B: PostgreSQL
-- Option C: SQLite (for quick local testing)

SOURCE sql/SQL_Queries.sql;
```

### 3. Open the Tableau Dashboard
- Download `tableau/upi_dashboard.twbx`
- Open with Tableau Public (free) or Tableau Desktop
- The dataset is embedded in the `.twbx` packaged workbook

---

## 💡 Key Findings

- **TSR is 83.7%** — below the industry benchmark of 90%+, indicating systemic infrastructure issues
- **Peak failure window: 19:00–21:00** — GMV at risk spikes to ₹4,22,302 in a single hour
- **SBI × GPay is the highest-risk channel** — ₹4,32,621 in failed transaction value
- **GPay has the highest avg failed ticket size** — ₹1,124 vs PhonePe's ₹775 (45% higher)
- **59.1% of failures are Technical Declines (TD)** — meaning server-side fixes have the biggest ROI
- **1,441 Bank Server Timeouts** — all attributable to infrastructure, not user error

---

## 👤 Author

**[Your Name]**
Data Analyst | Python · SQL · Tableau

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://linkedin.com/in/your-profile)
[![Tableau Public](https://img.shields.io/badge/Tableau-View%20Dashboard-orange)](https://public.tableau.com/your-profile)


