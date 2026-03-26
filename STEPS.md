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
