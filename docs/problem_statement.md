# 📋 Problem Statement

## Project Title
**UPI Payment Performance Dashboard — Failure Intelligence & Channel Risk Analytics**

## Business Context

India's UPI ecosystem is the world's largest real-time payments network, processing over 13 billion transactions per month as of 2026. For any fintech platform, PSP (Payment Service Provider), or bank operating in this ecosystem, even a 1% increase in failure rate translates to:

- **Direct revenue loss** from failed high-value transactions
- **Customer churn** from repeated friction at checkout
- **Regulatory scrutiny** from NPCI on TSR benchmarks
- **Operational blind spots** when failures cannot be attributed to a specific channel or time window

This project addresses the need for a **real-time, drill-down analytics system** that moves beyond aggregate success rates and surfaces the *who, when, where, and why* of UPI payment failures.

---

## Problem Definition

A mid-sized fintech platform is experiencing a **Transaction Success Rate (TSR) of 83.7%** — significantly below NPCI's recommended benchmark of 90%+. The platform processes transactions across:

- **4 partner banks:** SBI, HDFC, ICICI, AXIS
- **3 PSP apps:** GPay, PhonePe, Paytm
- **24-hour windows** with varying traffic intensity
- **7-day rolling data** capturing weekday and weekend patterns

The operations and product teams need answers to three core questions:

1. **Where** is the failure concentrated — which bank-app channel is leaking the most GMV?
2. **When** does failure spike — which hours and days create the most risk?
3. **Why** are transactions failing — is it infrastructure (server timeouts) or user behavior (wrong PIN, low balance)?

---

## Project Objectives

| # | Objective | Outcome |
|---|---|---|
| 1 | Generate a realistic UPI transaction dataset | 15,000-row CSV with all relevant dimensions |
| 2 | Perform SQL-based analytical deep dives | 10 business questions across 3 complexity phases |
| 3 | Build an interactive Tableau executive dashboard | 4-zone dashboard with day-level drill-down |
| 4 | Surface actionable business recommendations | Insight-driven findings tied to each chart |

---

## Scope & Constraints

**In scope:**
- Transaction-level failure analysis (not user journey or session analysis)
- 7-day window (01 Jun – 07 Jun 2026)
- Bank-level and PSP-level segmentation
- Hourly and daily temporal analysis
- Financial impact quantification (GMV at risk)

**Out of scope:**
- Real-time streaming data pipeline
- Individual user PII or behavioral profiling
- Network-level infrastructure diagnostics
- Cross-border or international UPI transactions

---

## Deliverables

| Deliverable | Format | Location |
|---|---|---|
| Synthetic dataset | `.csv` | `dataset/upi_transaction_dataset.csv` |
| Dataset generator script | `.py` | `dataset/generate_dataset.py` |
| SQL analytical queries (10 questions) | `.sql` | `sql/` folder |
| SQL outputs & interpretations | `.md` | `docs/sql_answers.md` |
| Tableau dashboard (packaged) | `.twbx` | `tableau/upi_dashboard.twbx` |
| Tableau build guide | `.md` | `docs/dashboard_guide.md` |
| Project README | `.md` | `README.md` |

---

## Success Criteria

The project is considered complete when:

- [ ] Dataset is generated with correct schema, realistic distributions, and no data quality issues
- [ ] All 10 SQL questions are answered with correct output and business interpretation
- [ ] Tableau dashboard has all 5 components (KPI + 4 charts) with correct data
- [ ] Day parameter and global filters work correctly across all sheets
- [ ] Heatmap → Line chart interactive action is functional
- [ ] Dashboard theme matches UPI brand colors (#878787, #FF6B00, #2ECC71)
- [ ] Repository is clean, well-documented, and ready for portfolio showcase
