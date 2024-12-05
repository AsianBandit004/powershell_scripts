$searchBases = "OU=Interns & Temps Disabled,OU=Disabled User Accounts,DC=Americanlegacy,DC=org" , "OU=SI Disabled,OU=Disabled User Accounts,DC=Americanlegacy,DC=org" , "OU=TI Disabled,OU=Disabled User Accounts,DC=Americanlegacy,DC=org"
$disabledUsers = foreach ($searchBase in $searchBases) {
    Get-ADUser -Filter "Enabled -eq 'False'" -SearchBase $searchBase -Properties whenChanged
}

if ($disabledUsers) {
    $disabledUsers | Select-Object Name, SamAccountName, @{n='DisabledDate';e={$_.whenChanged}}, DistinguishedName | Sort-Object DisabledDate
} else {
    Write-Host "No disabled users found."
}