Step 1.1 - Load the data

1. In Power BI Desktop - Get Data → Text/CSV
2. Load german_credit_data_biased_training.csv
3. Click Transform Data

Step 1.2 Risk Label Transformation (Power Query / M)

1. Risk column renamed to risk_flag
2. Correct values mapping:

| CSV Value | Meaning | Risk_Flag |
|---|---|---|
| Risk | Bad credit risk | 1 |
| No Risk | Good credit risk | 0 |


```M
let
    RiskClean = Text.Lower( Text.Trim( [Risk] ) )
in
    if RiskClean = "risk" then 1
    else if RiskClean = "no risk" then 0
    else null
```

Step 1.3 - Validate Age (Data Quality Rule)
Goal - Flag unrealistic values (e.g. Age < 18)

Flag, not delete. 
Column Age - changed data type into  int (whole number)

Power Query
Custom column - "Invalid_Age_Flag"
```M
if [Age] = null then null
else if [Age] < 18 then 1
else 0

```
Data quality validation:
In row 14, the error shows no numeric value; I used the logic below to return null instead of an error. 

```M
let
    AgeValue = try Number.From([Age]) otherwise null
in
    if AgeValue = null then null
    else if AgeValue < 18 then 1
    else 0
```

Step 1.4 - Create Age Groups

```M
if [Age] < 25 then "<25"
else if [Age] <= 34 then "25–34"
else if [Age] <= 49 then "35–49"
else "50+"
```

Data quality validation:
In row 14, the error shows no numeric value; I used the logic below to return null instead of an error. 

```M
let
    AgeValue = try Number.From([Age]) otherwise null
in
    if AgeValue = null then null
    else if AgeValue < 25 then "<25"
    else if AgeValue <= 34 then "25–34"
    else if AgeValue <= 49 then "35–49"
    else "50+"

```

STEP 1.5 - Loan Size Buckets

```M
let
    Amount = try Number.From([CreditAmount]) otherwise null
in
    if Amount = null then null
    else if Amount < 1000 then "Small"
    else if Amount <= 5000 then "Medium"
    else "Large"
```
