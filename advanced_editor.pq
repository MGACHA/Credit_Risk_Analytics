let
    Source = Csv.Document(File.Contents("C:\Users\MC\Downloads\Kickstart your Data and AI journeys _ Q1 2026 -English -March- MEA - ET\Kickstart your Data and AI journeys _ Q1 2026 -English -March- MEA - ET\credit_data_biased_training_notclean.csv"),[Delimiter=",", Columns=21, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"CheckingStatus", type text}, {"LoanDuration", type text}, {"CreditHistory", type text}, {"LoanPurpose", type text}, {"LoanAmount", Int64.Type}, {"ExistingSavings", type text}, {"EmploymentDuration", type text}, {"InstallmentPercent", type text}, {"Sex", type text}, {"OthersOnLoan", type text}, {"CurrentResidenceDuration", type text}, {"OwnsProperty", type text}, {"Age", type text}, {"InstallmentPlans", type text}, {"Housing", type text}, {"ExistingCreditsCount", type text}, {"Job", type text}, {"Dependents", type text}, {"Telephone", type text}, {"ForeignWorker", type text}, {"Risk", type text}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "risk_flag", each let
    RiskClean = Text.Lower( Text.Trim( [Risk] ) )
in
    if RiskClean = "risk" then 1
    else if RiskClean = "no risk" then 0
    else null),
    #"Changed Type1" = Table.TransformColumnTypes(#"Added Custom",{{"Age", Int64.Type}}),
    #"Added Custom2" = Table.AddColumn(#"Changed Type1", "Invalid_Age_Flag", each let
    AgeValue = try Number.From([Age]) otherwise null
in
    if AgeValue = null then null
    else if AgeValue < 18 then 1
    else 0),
    #"Added Custom1" = Table.AddColumn(#"Added Custom2", "Age_Groups", each let
    AgeValue = try Number.From([Age]) otherwise null
in
    if AgeValue = null then null
    else if AgeValue < 25 then "<25"
    else if AgeValue <= 34 then "25–34"
    else if AgeValue <= 49 then "35–49"
    else "50+")
in
    #"Added Custom1"
