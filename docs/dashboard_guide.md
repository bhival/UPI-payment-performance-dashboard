# 📊 Tableau Dashboard Build Guide

> Step-by-step instructions to recreate the UPI Payment Performance Dashboard in Tableau Public or Desktop.

---

## Theme

| Element | Color |
|---|---|
| Dashboard background | `#878787` |
| Failures / Alerts / TD | `#FF6B00` (UPI Orange) |
| Success / TSR above target | `#2ECC71` (Green) |
| Text / Labels | `#FFFFFF` (White) |
| Heatmap minimum | `#FFFFFF` |
| Heatmap maximum | `#FF6B00` |

---

## Data Connection

1. Open Tableau → Connect → Text File → `upi_transaction_dataset.csv`
2. On the Data Source tab, change `Timestamp` data type from String → **Date & Time**
3. Rename the source to `UPI_Data`

---

## Calculated Fields (create all before building sheets)

| Field Name | Formula |
|---|---|
| `Total Volume` | `COUNT([Transaction ID])` |
| `TSR` | `COUNTD(IF [Status]="Success" THEN [Transaction ID] END) / COUNT([Transaction ID])` |
| `GMV At Risk` | `SUM(IF [Status]="Failure" THEN [Amount] ELSE 0 END)` |
| `TSR Color Flag` | `IF [TSR] >= 0.90 THEN "Above Target" ELSE "Below Target" END` |
| `Hour of Day` | `DATEPART('hour', [Timestamp])` |
| `Day Number` | `DATEDIFF('day', DATE("2026-06-01"), DATE([Timestamp])) + 1` |
| `Failed Amount (Heatmap)` | `IF [Status]="Failure" THEN [Amount] ELSE 0 END` |
| `Avg Failed Amount` | `AVG(IF [Status]="Failure" THEN [Amount] END)` |
| `Decline Type Label` | `IF [Decline_Type]="TD" THEN "Technical Decline" ELSEIF [Decline_Type]="BD" THEN "Business Decline" ELSE NULL END` |
| `Day Filter` | `[Day Number] = [Selected Day] OR [Selected Day] = 0` |

---

## Parameter: Selected Day

- Name: `Selected Day`
- Type: Integer
- Values (List):
  - 0 = All Days
  - 1 = Day 1 – 01 Jun 2026
  - 2 = Day 2 – 02 Jun 2026
  - 3 = Day 3 – 03 Jun 2026
  - 4 = Day 4 – 04 Jun 2026
  - 5 = Day 5 – 05 Jun 2026
  - 6 = Day 6 – 06 Jun 2026
  - 7 = Day 7 – 07 Jun 2026

Add `Day Filter` (= True) to the Filters shelf on every sheet. Right-click → Apply to All Worksheets.

---

## Worksheets

### KPI_Metrics
- Marks: Text
- Labels: `Total Volume`, `TSR`, `GMV At Risk`
- Color: `TSR Color Flag` → green / orange

### Chart_A_Hourly (Clock of Failures)
- Mark: Line
- Columns: `HOUR(Timestamp)` continuous
- Rows: `SUM(Failed Amount (Heatmap))`
- Color: `#FF6B00`
- Filter: `Day Filter` = True

### Chart_B_Breakdown (Error Root-Cause)
- Mark: Pie (Donut via dual axis)
- Color: `Decline Type Label`
- Angle: `COUNT(Transaction ID)`
- TD = `#FF6B00`, BD = `#FFFFFF`

### Chart_C_Heatmap (Channel Friction Matrix)
- Mark: Square (max size)
- Columns: `UPI App`
- Rows: `Bank Name`
- Color: `SUM(Failed Amount (Heatmap))` → White→Orange palette
- Label: same field, format ₹#,##0

### Chart_D_TicketSize (Ticket-Size Distribution)
- Mark: Bar (horizontal)
- Rows: `UPI App`
- Columns: `Avg Failed Amount`
- Color: `UPI App` → GPay=#FF6B00, others=#FFFFFF/#878787
- Filter: `Status` = Failure, `Day Filter` = True

---

## Dashboard Assembly

Layout (1400×900px, Fixed):
```
[Title]                              [Filters: Bank | App | Day]
[KPI: Volume]  [KPI: TSR]  [KPI: GMV At Risk]
[Chart A (60%)]          [Chart C (40%)]
[Chart B (60%)]
[Chart D (full width)]
```

---

## Interactive Action

Dashboard → Actions → Add Action → Filter:
- Name: `Matrix_to_Clock_Filter`
- Source: `Chart_C_Heatmap`
- Run on: Select
- Target: `Chart_A_Hourly`
- Clearing selection: Show all values
