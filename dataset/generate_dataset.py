"""
UPI Transaction Dataset Generator
===================================
Generates a synthetic 7-day UPI transaction dataset
with realistic distributions for failure types, banks, apps, and amounts.

Output: upi_transaction_dataset.csv (15,000 rows)
Period: 01 Jun 2026 00:03 → 07 Jun 2026 23:59

Requirements:
    pip install faker
"""

import csv
import random
from datetime import datetime, timedelta
from faker import Faker

fake = Faker('en_IN')
random.seed(42)

# ── Configuration ─────────────────────────────────────────────────────────────

TOTAL_ROWS      = 15_000
START_DATE      = datetime(2026, 6, 1, 0, 3)
END_DATE        = datetime(2026, 6, 7, 23, 59)
OUTPUT_FILE     = "upi_transaction_dataset.csv"

BANKS = ["SBI", "HDFC", "ICICI", "AXIS"]
APPS  = ["GPay", "PhonePe", "Paytm"]

BANK_WEIGHTS = [0.35, 0.30, 0.20, 0.15]   # SBI most common
APP_WEIGHTS  = [0.40, 0.40, 0.20]          # GPay & PhonePe dominant

# Overall failure rate ~16%
FAILURE_RATE = 0.163

# Among failures: 59% Technical (TD), 41% Business (BD)
TD_RATE = 0.591

# Among BD failures: Incorrect PIN vs Insufficient Balance
PIN_RATE = 0.355   # ~35.5% of BD
BAL_RATE = 0.645   # ~64.5% of BD

# Bank-level server timeout weight (SBI and HDFC more prone)
BANK_TIMEOUT_WEIGHTS = {
    "SBI":   0.35,
    "HDFC":  0.32,
    "ICICI": 0.18,
    "AXIS":  0.15,
}

# Hour-of-day failure probability multiplier (evening spike)
HOUR_FAILURE_MULTIPLIER = {
    0: 0.3, 1: 0.2, 2: 0.2, 3: 0.1, 4: 0.2, 5: 0.4,
    6: 0.5, 7: 0.6, 8: 0.7, 9: 0.8, 10: 0.9, 11: 1.0,
    12: 1.1, 13: 1.0, 14: 1.0, 15: 0.9, 16: 1.0, 17: 1.1,
    18: 1.3, 19: 2.5, 20: 2.3, 21: 1.8, 22: 1.0, 23: 0.6,
}

# ── Helpers ───────────────────────────────────────────────────────────────────

def random_timestamp(start: datetime, end: datetime) -> datetime:
    delta = end - start
    seconds = random.randint(0, int(delta.total_seconds()))
    return start + timedelta(seconds=seconds)


def generate_amount() -> float:
    """Realistic UPI amount: skewed toward small values, occasional high-value."""
    r = random.random()
    if r < 0.50:
        return round(random.uniform(10, 500), 2)
    elif r < 0.80:
        return round(random.uniform(500, 2000), 2)
    elif r < 0.95:
        return round(random.uniform(2000, 4000), 2)
    else:
        return round(random.uniform(4000, 4999), 2)


def generate_row(txn_id: int) -> dict:
    bank    = random.choices(BANKS, weights=BANK_WEIGHTS)[0]
    app     = random.choices(APPS,  weights=APP_WEIGHTS)[0]
    ts      = random_timestamp(START_DATE, END_DATE)
    hour    = ts.hour
    amount  = generate_amount()
    user_id = f"USR_{random.randint(1000, 5000)}"
    upi_id  = f"{user_id.lower()}@ok{bank.lower()}"

    # Adjust failure probability based on hour
    multiplier     = HOUR_FAILURE_MULTIPLIER.get(hour, 1.0)
    effective_fail = min(FAILURE_RATE * multiplier, 0.75)

    if random.random() < effective_fail:
        status = "Failure"
        if random.random() < TD_RATE:
            decline_type   = "TD"
            failure_reason = "Bank Server Timeout"
        else:
            decline_type = "BD"
            if random.random() < PIN_RATE:
                failure_reason = "Incorrect PIN"
            else:
                failure_reason = "Insufficient Balance"
    else:
        status         = "Success"
        decline_type   = "NULL"
        failure_reason = "None"

    return {
        "Transaction_ID": f"TXN{100000 + txn_id}",
        "Timestamp":      ts.strftime("%d/%m/%y %-H:%M"),
        "User_ID":        user_id,
        "UPI_ID":         upi_id,
        "Bank_Name":      bank,
        "UPI_App":        app,
        "Amount":         amount,
        "Status":         status,
        "Decline_Type":   decline_type,
        "Failure_Reason": failure_reason,
    }


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    fieldnames = [
        "Transaction_ID", "Timestamp", "User_ID", "UPI_ID",
        "Bank_Name", "UPI_App", "Amount", "Status",
        "Decline_Type", "Failure_Reason",
    ]

    rows = [generate_row(i) for i in range(TOTAL_ROWS)]

    # Sort by timestamp for natural ordering
    rows.sort(key=lambda r: datetime.strptime(r["Timestamp"], "%d/%m/%y %H:%M")
              if len(r["Timestamp"].split(":")[0].split(" ")[1]) == 2
              else datetime.strptime(r["Timestamp"], "%d/%m/%y %-H:%M"))

    with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    # Summary stats
    failures = [r for r in rows if r["Status"] == "Failure"]
    tsr      = (TOTAL_ROWS - len(failures)) / TOTAL_ROWS * 100
    print(f"✅ Generated {TOTAL_ROWS:,} rows → {OUTPUT_FILE}")
    print(f"   TSR          : {tsr:.1f}%")
    print(f"   Failures     : {len(failures):,}")
    print(f"   Date range   : {rows[0]['Timestamp']} → {rows[-1]['Timestamp']}")


if __name__ == "__main__":
    main()
